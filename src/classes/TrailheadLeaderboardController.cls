/*****************************************
* File: TrailheadLeaderboardController
* Author: meruff
* Description: Controller class for trailheadLeaderboard.page
******************************************/
public class TrailheadLeaderboardController {
    private Set<String> trailblazerIds;
    public List<Trailblazer__c> trailblazers { get; set; }
    public Map<String, List<Badge__c>> badgesMap { get; set; }
    public String newProfileId { get; set; }
    public String selectedName { get; set; }
    public String selectedId { get; set; }

    public TrailheadLeaderboardController() {
        populateTrailblazers();
    }

    /**
     * Queries for current Trailblazer__c records to display on the Visualforce page.
     */
    public void populateTrailblazers() {
        newProfileId = '';
        trailblazerIds = new Set<String>();
        badgesMap = new Map<String, List<Badge__c>>();

        trailblazers = new List<Trailblazer__c>([
            SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Id__c,
                Profile_Link__c, Rank__c, Profile_Photo__c, Job_Role__c, Job_Title__c, Company_Institution__c, (
                SELECT Title__c, Icon_Link__c, Type__c, Points__c, Date_Earned__c, Path__c
                FROM Badges__r
                ORDER BY Date_Earned__c DESC NULLS LAST
            )
            FROM Trailblazer__c
            ORDER BY Points__c DESC
        ]);

        for (Trailblazer__c tb : trailblazers) {
            trailblazerIds.add(tb.Profile_Id__c);

            for (Badge__c badge : tb.Badges__r) {
                if (!badgesMap.containsKey(tb.Profile_Id__c)) {
                    badgesMap.put(tb.Profile_Id__c, new List<Badge__c>{badge});
                } else {
                    badgesMap.get(tb.Profile_Id__c).add(badge);
                }
            }
        }
    }

    /**
     * Creates a new Trailblazer record to upsert into Salesforce by calling out to Trailhead with the provided profile
     * Id on the Visualforce page.
     */
    public PageReference upsertNewTrailblazer() {
        try {
            findAndUpsertTrailblazer(newProfileId);
            populateTrailblazers();
            PageReference refresh = new PageReference('/trailheadLeaderboard');
            refresh.setRedirect(true);
            return refresh;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                ' Error during callout to Trailhead, please try again. ' + e.getMessage()));
            return null;
        }
    }

    /**
     * Calls out to Trailhead and attempts to find the Trailblazer by the profile Id provided.
     *
     * @param profileId, the public Trailhead profile Id for the user.
     * @return tbToUpsert, the Trailblazer__c record to upsert into Salesforce.
     */
    public void findAndUpsertTrailblazer(String profileId) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(PopulateTrailblazers.TRAILHEAD_URL + '/me/' + profileId);
        req.setMethod('GET');
        HttpResponse res = h.send(req);

        // Handling for redirects (custom Trailhead Profiles /me/)
        Boolean redirect = false;

        if (res.getStatusCode() >= 300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
            do {
                redirect = false; // reset the value each time
                String loc = res.getHeader('Location'); // get location of the redirect

                if (loc == null) {
                    redirect = false;
                    continue;
                }

                req = new HttpRequest();
                req.setEndpoint(loc);
                req.setMethod('GET');
                res = h.send(req);

                if (res.getStatusCode() != 500) { // 500 = fail
                    if (res.getStatusCode() >= 300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
                        redirect = true;
                    }
                }
            } while (redirect && Limits.getCallouts() != Limits.getLimitCallouts());
        }

        if (res.getStatus() != 'Not Found'
            && (!res.getBody().contains('Someone\'s hiding!')
            && !res.getBody().contains('This user has chosen to keep their profile private.'))
        ) {
            Trailblazer__c tbToUpsert = PopulateTrailblazers.populateTrailblazer(res.getBody());
            upsert tbToUpsert Profile_Id__c;

            List<Badge__c> badgesToUpsert = PopulateTrailblazers.getTrailblazerBadges(res.getBody(), tbToUpsert);
            if (badgesToUpsert.size() > 0) {
                upsert badgesToUpsert Upsert_Key__c;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                'Could not find a Trailhead profile for User Id: ' + profileId +
                '. Please ensure your profile is set to public and you\'ve copied your Id correctly.'
            ));
            return;
        }
    }

    public Boolean getIsMapEmpty() {
        return (badgesMap.get(selectedId) == null || badgesMap.get(selectedId).size() == 0);
    }
}