/**
* @author meruff
* @date 2019-06-17
*
* Apex controller logic for LWC leaderboard.
*/
public class TrailheadLeaderboardAuraController {
    @AuraEnabled(Cacheable=true)
    public static List<Trailblazer__c> populateTrailblazers(String fieldToSortBy, Boolean descending) {
        String queryString = '' +
            'SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Handle__c, Profile_Id__c, ' +
                'Profile_Link__c, Rank__c, Profile_Photo__c, Job_Role__c, Job_Title__c, Company_Institution__c, ' +
                'Rank_Badge_Link__c, Superbadges__c ' +
            'FROM Trailblazer__c';

        if (String.isBlank(fieldToSortBy)) {
            queryString += ' ORDER BY Points__c DESC';
        } else {
            queryString += ' ORDER BY ' + fieldToSortBy;

            if (descending == null || descending) {
                queryString += ' DESC';
            } else {
                queryString += ' ASC';
            }
        }

        System.debug('merf: ' + queryString);

        return Database.query(queryString);
    }

    @AuraEnabled
    public static String createTrailblazer(String userId) {
        Trailblazer__c newTrailblazer = new Trailblazer__c(Profile_Handle__c = userId.replace(' ', '').trim());
        PopulateTrailblazers.populateTrailblazerProfileData(newTrailblazer, PopulateTrailblazers.getProfileData(newTrailblazer));
        PopulateTrailblazers.populateTrailblazerProfileCountsData(newTrailblazer, PopulateTrailblazers.getProfileCountData(newTrailblazer));
        PopulateTrailblazers.populateTrailblazerSuperbadgeData(newTrailblazer, PopulateTrailblazers.getSuperbadgeData(newTrailblazer));

        try {
            upsert newTrailblazer Profile_Handle__c;
            return 'success';
        } catch(Exception e) {
            return 'Could not find a Trailhead profile for User Id/handle: ' + userId +
                '. Please ensure your profile is set to public and you\'ve copied your Id correctly.';
        }
    }

    @AuraEnabled
    public static List<BadgeData.EarnedAwards> getBadgeData(String userId, String filter, String offset) {
        String calloutURL = '';

        if (!String.isBlank(filter)) {
            calloutURL = PopulateTrailblazers.GO_TRAILHEAD_API + userId + '/badges/' + filter;

            if (!String.isBlank(offset)) {
                calloutURL += '/' + offset;
            }
        } else {
            calloutURL = PopulateTrailblazers.GO_TRAILHEAD_API + userId + 'badges';
        }

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(calloutURL);
        req.setMethod('GET');
        req.setTimeout(60000);
        HttpResponse res = h.send(req);

        if (res.getBody().contains('application-error')) {
            return null;
        }

        BadgeData data = (BadgeData) JSON.deserialize(res.getBody().replaceAll('__c', ''), BadgeData.class);

        if (data.value != null && !data.value.isEmpty() && data.value[0].EarnedAwards != null && !data.value[0].EarnedAwards.isEmpty()) {
            return data.value[0].EarnedAwards;
        } else {
            return null;
        }
    }
}