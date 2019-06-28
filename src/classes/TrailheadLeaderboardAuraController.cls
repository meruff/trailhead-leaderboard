/**
* @author Mathew Ruff, Sierra-Cedar
* @date 2019-06-17
*
* Apex controller logic for LWC leaderboard.
*/
public class TrailheadLeaderboardAuraController {
    @AuraEnabled(Cacheable=true)
    public static List<Trailblazer__c> populateTrailblazers() {
        return [
            SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Id__c,
                Profile_Link__c, Rank__c, Profile_Photo__c, Job_Role__c, Job_Title__c, Company_Institution__c, (
                SELECT Title__c, Icon_Link__c, Type__c, Points__c, Date_Earned__c, Path__c
                FROM Badges__r
                ORDER BY Title__c ASC
            )
            FROM Trailblazer__c
            ORDER BY Points__c DESC
        ];
    }

    @AuraEnabled
    public static String createTrailblazer(String userId) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(PopulateTrailblazers.TRAILHEAD_URL + '/me/' + userId.replace(' ' , '').trim());
        req.setMethod('GET');
        HttpResponse res = h.send(req);

        System.debug('merf: ' + req.getEndpoint());

        // Handling for redirects (custom Trailhead Profiles /me/)
        Boolean redirect = false;

        if (res.getStatusCode() >= 300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
            do {
                redirect = false;
                String loc = res.getHeader('Location');

                if (loc == null) {
                    redirect = false;
                    continue;
                }

                req = new HttpRequest();
                req.setEndpoint(loc);
                req.setMethod('GET');
                res = h.send(req);

                if (res.getStatusCode() != 500) {
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
            System.debug('merf tbToUpsert: ' + tbToUpsert);
//            upsert tbToUpsert Profile_Id__c;

            List<Badge__c> badgesToUpsert = PopulateTrailblazers.getTrailblazerBadges(res.getBody(), tbToUpsert);
            System.debug('merf badgesToUpsert: ' + badgesToUpsert);
//            if (badgesToUpsert.size() > 0) {
//                upsert badgesToUpsert Upsert_Key__c;
//            }
            return 'success';
        } else {
            return 'Could not find a Trailhead profile for User Id/handle: ' + userId +
                '. Please ensure your profile is set to public and you\'ve copied your Id correctly.';
        }
    }
}