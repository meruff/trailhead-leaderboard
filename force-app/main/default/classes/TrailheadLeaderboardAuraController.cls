/**
* @author meruff
* @date 2019-06-17
*
* Apex controller logic for LWC leaderboard.
*/
public without sharing class TrailheadLeaderboardAuraController {
    /**
     * Queries for Trailblazer__c records to display on the page.
     *
     * @param fieldToSortBy, the API Name of the field used to sort, defaults to Points__c.
     * @param descending, whether or not to sort by DESC.
     *
     * @return a List of Trailblazer__c records.
     */
    @AuraEnabled(Cacheable=true)
    public static List<Trailblazer__c> populateTrailblazers(String fieldToSortBy, Boolean descending) {
        String queryString = '' +
            'SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Handle__c, Profile_Id__c, ' +
                'Profile_Link__c, Rank__c, Profile_Photo__c, Job_Role__c, Job_Title__c, Company_Institution__c, ' +
                'Rank_Badge_Link__c, Superbadges__c, Certifications__c, LastModifiedDate ' +
            'FROM Trailblazer__c ' +
            'WHERE Points__c != NULL ' +
            'AND Rank__c != NULL';

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

        return Database.query(queryString);
    }

    /**
     * Creates and upserts a new Trailblazer__c record by calling out to the Trailhead API and parsing the response data.
     *
     * @param userId, the user handle to use when calling out to Trailhead.
     *
     * @return, a message String whether or not the callout succeeded.
     */
    @AuraEnabled
    public static String createTrailblazer(String userId) {
        Trailblazer__c newTrailblazer = new Trailblazer__c(Profile_Handle__c = userId.replace(' ', '').trim());

        for (String s : new Set<String>{
            GetTrailblazerInfoAsync.getProfileCountsData(newTrailblazer, GetTrailblazerInfoAsync.buildCalloutURL(newTrailblazer, '')),
            GetTrailblazerInfoAsync.getProfileData(newTrailblazer, GetTrailblazerInfoAsync.buildCalloutURL(newTrailblazer, GetTrailblazerInfoAsync.PROFILE_PATH)),
            GetTrailblazerInfoAsync.getSuperbadgeData(newTrailblazer, GetTrailblazerInfoAsync.buildCalloutURL(newTrailblazer, GetTrailblazerInfoAsync.SUPERBADGES_PATH)),
            GetTrailblazerInfoAsync.getCertificationData(newTrailblazer, GetTrailblazerInfoAsync.buildCalloutURL(newTrailblazer, GetTrailblazerInfoAsync.CERTIFICATIONS_PATH))
        }) {
            if (!s.equals(GetTrailblazerInfoAsync.SUCCESS)) {
                return s;
            }
        }

        try {
            upsert newTrailblazer Profile_Handle__c;
            return 'success';
        } catch(Exception e) {
            return 'Error creating Trailblazer__c. Please try again.';
        }
    }

    /**
     * Returns a List of BadgeData.EarnedAwards records after parsing the response data from the Trailhead API.
     *
     * @param userId, the user handle to use when calling out to Trailhead.
     *
     * @return, a List of BadgeData.EarnedAwards records.
     */
    @AuraEnabled
    public static List<BadgeData.EarnedAwards> getBadgeData(String userId, String filter, String offset) {
        String calloutURL = '';

        if (!String.isBlank(filter)) {
            calloutURL = GetTrailblazerInfoAsync.GO_TRAILHEAD_API + userId + '/badges/' + filter;

            if (!String.isBlank(offset)) {
                calloutURL += '/' + offset;
            }
        } else {
            calloutURL = GetTrailblazerInfoAsync.GO_TRAILHEAD_API + userId + 'badges';
        }

        HttpResponse res = doCallout(calloutURL);

        if (res.getBody().contains('application-error')) {
            return null;
        }

        BadgeData data = (BadgeData) JSON.deserialize(res.getBody().replaceAll('__c', ''), BadgeData.class);

        if (String.isBlank(data.error)
            && data.value != null 
            && !data.value.isEmpty() 
            && data.value[0].EarnedAwards != null 
            && !data.value[0].EarnedAwards.isEmpty()
        ) {
            return data.value[0].EarnedAwards;
        } else {
            return null;
        }
    }

    /**
     * Returns a List of ProfileCountData.LearnedSkills records after parsing the response data from the Trailhead API.
     *
     * @param userId, the user handle to use when calling out to Trailhead.
     *
     * @return, a List of ProfileCountData.LearnedSkills records.
     */
    @AuraEnabled
    public static List<ProfileCountData.LearnedSkills> getSkillData(String userId) {
        HttpResponse res = doCallout(GetTrailblazerInfoAsync.GO_TRAILHEAD_API + userId);

        if (res.getBody().contains('application-error')) {
            return null;
        }

        ProfileCountData data = (ProfileCountData) JSON.deserialize(res.getBody().replaceAll('__c', ''), ProfileCountData.class);

        if (String.isBlank(data.error) 
            && data.value != null 
            && !data.value.isEmpty() 
            && data.value[0].LearnedSkills != null 
            && !data.value[0].LearnedSkills.isEmpty()
        ) {
            return data.value[0].LearnedSkills;
        } else {
            return null;
        }
    }

    /**
     * Returns a List of CertificationData.cerificationsList records after parsing the response data from the Trailhead API.
     *
     * @param userId, the user handle to use when calling out to Trailhead.
     *
     * @return, a List of CertificationData.certificationsList records.
     */
    @AuraEnabled
    public static List<CertificationData.certificationsList> getCertificationData(String userId) {
        HttpResponse res = doCallout(GetTrailblazerInfoAsync.GO_TRAILHEAD_API + userId + '/certifications');

        if (res.getBody().contains('application-error')) {
            return null;
        }

        CertificationData data = (CertificationData) JSON.deserialize(res.getBody().replaceAll('__c', ''), CertificationData.class);

        if (String.isBlank(data.error) 
            && data != null 
            && data.certificationsList != null 
            && !data.certificationsList.isEmpty()
        ) {
            return data.certificationsList;
        } else {
            return null;
        }
    }

    /**
     * Does a callout with the provided URL. 
     * 
     * @param calloutURL, the URL to call out to.
     * 
     * @return a HttpResponse from the callout.
     */
    public static HttpResponse doCallout(String calloutURL) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(calloutURL);
        req.setMethod('GET');
        req.setTimeout(60000);
        HttpResponse res = h.send(req);

        return res;
    }
}