/*****************************************
* File: TrailheadLeaderboardController
* Author: detonation0
* Description: Controller class for trailheadLeaderboard.page
******************************************/
public class TrailheadLeaderboardController {
    private Set<Id> trailblazerIds;
    public List<Trailblazer__c> trailblazers { get; set; }
    public Trailblazer__c newBlazer { get; set; }

    public TrailheadLeaderboardController() {
        populateTrailblazers();
    }

    /**
     * @description Queries for current Trailblazer__c records to display on the Visualforce page.
     */
    public void populateTrailblazers() {
        newBlazer = new Trailblazer__c();
        trailblazerIds = new Set<Id>();
        trailblazers = new List<Trailblazer__c>([
            SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Id__c,
                Profile_Link__c, Rank__c, Profile_Photo__c
            FROM Trailblazer__c
            ORDER BY Points__c DESC
        ]);

        for (Trailblazer__c tb : trailblazers) {
            trailblazerIds.add(tb.Profile_Id__c);
        }
    }

    /**
     * @description Creates a new Trailblazer record to upsert into Salesforce by calling out to Trailhead with
     * the provided profile Id on the Visualforce page.
     */
    public PageReference upsertNewTrailblazer() {
        if (newBlazer.Profile_Id__c.length() > 18 || newBlazer.Profile_Id__c.length() < 18) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Profile Ids must be 18 characters in length.'));
            return null;
        }

        if (trailblazerIds.contains(newBlazer.Profile_Id__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'This trailblazer already exists.'));
            return null;
        }

        Trailblazer__c insertBlazer = findTrailblazer(newBlazer.Profile_Id__c);

        if (insertBlazer != null) {
            upsert insertBlazer Profile_Id__c;
            populateTrailblazers();
            PageReference refresh = new PageReference('/trailheadLeaderboard');
            refresh.setRedirect(true);
            return refresh;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error during callout to Trailhead, please try again.'));
            return null;
        }
    }

    /**
     * @description Calls out to Trailhead and attempts to find the Trailblazer by the profile Id provided.
     * @param profileId, the public Trailhead profile Id for the user. 
     * @return tbToUpsert, the Trailblazer__c record to upsert into Salesforce.
     */
    public Trailblazer__c findTrailblazer(String profileId) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://trailhead.salesforce.com/users/profiles/' + profileId);
        req.setMethod('GET');
        HttpResponse res = h.send(req);

        if (res.getStatus() != 'Not Found'
            && (!res.getBody().contains('Someone\'s hiding!')
            && !res.getBody().contains('This user has chosen to keep their profile private.'))
        ) {
            Trailblazer__c tbToUpsert = PopulateTrailblazers.populateTrailblazer(res.getBody());
            tbToUpsert.Profile_Id__c = profileId;
            return tbToUpsert;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Could not find a Trailhead profile for User Id: ' + profileId + '. Please ensure your profile is set to public and you\'ve copied your Id correctly.'));
            return null;
        }
    }
}