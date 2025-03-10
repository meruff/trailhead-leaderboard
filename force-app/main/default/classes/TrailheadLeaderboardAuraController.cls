/**
 * @description Apex controller logic for the main leaderboard.
 *
 * @author meruff
 *
 * @date 6/17/19
 */
public without sharing class TrailheadLeaderboardAuraController {
    /**
     * @description Queries for Trailblazer__c records to display on the page.
     *
     * @param options TrailheadLeaderboardAuraController.TrailblazerQueryConfig record of query options to use.
     *
     * @return a List of Trailblazer__c records.
     *
     * @see TrailheadLeaderboardAuraController.TrailblazerQueryConfig
     */
    @AuraEnabled(Cacheable=true)
    public static List<Trailblazer__c> populateTrailblazers(TrailblazerQueryConfig options) {
        String queryString = '' +
            'SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Handle__c, Profile_Id__c, ' +
            'Profile_Link__c, Rank__c, Profile_Photo__c, Job_Role__c, Job_Title__c, Company_Institution__c, ' +
            'Rank_Badge_Link__c, Superbadges__c, Certifications__c, LastModifiedDate ' +
            'FROM Trailblazer__c ' +
            'WHERE Points__c != NULL ' +
            'AND Rank__c != NULL';

        if (String.isBlank(options.sortBy)) {
            queryString += ' ORDER BY Points__c DESC';
        } else {
            queryString += ' ORDER BY ' + options.sortBy;

            if (options.descending == null || !options.descending) {
                queryString += ' ASC';
            } else {
                queryString += ' DESC';
            }
        }

        if (options.pageSize != null) {
            queryString += ' LIMIT ' + options.pageSize;
        }

        if (options.offset != null) {
            queryString += ' OFFSET ' + options.offset;
        }

        return Database.query(String.escapeSingleQuotes(queryString));
    }

    /**
     * @description Runs an AggregateResult query for COUNT of all Trailblazer__c records.
     *
     * @return an Integer representing the count.
     */
    @AuraEnabled(Cacheable=true)
    public static Integer getTotalTrailblazerCount() {
        return (Integer) [SELECT COUNT(Id) FROM Trailblazer__c][0]?.get('expr0');
    }

    /**
     * @description Create and upsert a new Trailblazer__c record by calling out to the Trailhead API and
     * parsing the response data.
     *
     * @param userId the user handle to use when calling out to Trailhead.
     *
     * @return a message String whether or not the callout succeeded.
     */
    @AuraEnabled
    public static String createTrailblazer(String userId) {
        Trailblazer__c newTrailblazer = new Trailblazer__c(
            Profile_Handle__c = userId.replace(' ', '').trim()
        );

        Set<String> potentialErrors = new Set<String>{
            GetTrailblazerInfoAsync.getProfileData(newTrailblazer, TrailheadHelper.fetchTrailblazerData(newTrailblazer, TrailheadHelper.PROFILE_PATH)),
            GetTrailblazerInfoAsync.getRankData(newTrailblazer, TrailheadHelper.fetchTrailblazerData(newTrailblazer, TrailheadHelper.RANK_PATH)),
            GetTrailblazerInfoAsync.getSuperbadgeData(newTrailblazer, TrailheadHelper.fetchTrailblazerData(newTrailblazer, TrailheadHelper.SUPERBADGES_PATH)),
            GetTrailblazerInfoAsync.getCertificationData(newTrailblazer, TrailheadHelper.fetchTrailblazerData(newTrailblazer, TrailheadHelper.CERTIFICATIONS_PATH))
        };

        for (String errorString : potentialErrors) {
            if (String.isNotBlank(errorString)) {
                return errorString;
            }
        }

        try {
            upsert newTrailblazer Profile_Handle__c;
        } catch (Exception e) {
            return 'Error creating Trailblazer__c. Please try again.';
        }

        return TrailheadHelper.SUCCESS;
    }

    /**
     * @description Returns a TrailheadGraphQlData.earnedAwards record after parsing the response data from the API.
     *
     * @param userId the user handle to use when calling out to Trailhead.
     * @param filter the value to filter badges on.
     * @param count the count of badges to return. Defaults to 8.
     * @param after the "after" page value to query for more pages.
     *
     * @return a TrailheadGraphQlData.earnedAwards record.
     */
    @AuraEnabled
    public static TrailheadGraphQlData.EarnedAwards getBadgeData(
        String userId,
        String filter,
        Integer count,
        String after
    ) {
        String calloutURL = TrailheadHelper.GO_TRAILHEAD_API + userId + TrailheadHelper.BADGES_PATH;

        // Add badge type filter.
        if (String.isNotBlank(filter)) {
            calloutURL += '/' + filter;

            // Add count type filter.
            if (count != null) {
                calloutURL += '/' + count;
            } else {
                calloutURL += '/8';
            }

            // "after" is added last
            if (String.isNotBlank(after)) {
                calloutURL += '/' + after;
            }
        }

        String resBody = TrailheadHelper.executeHttpGetRequest(calloutURL);

        if (resBody.contains('application-error')) {
            return null;
        }

        TrailheadGraphQlData data = (TrailheadGraphQlData) JSON.deserialize(
            resBody.replaceAll('__c', '').replaceAll('__', ''),
            TrailheadGraphQlData.class
        );

        if (String.isBlank(data.error) && data.profile?.earnedAwards != null) {
            return data.profile.earnedAwards;
        } else {
            return null;
        }
    }

    /**
     * @description Returns a List of TrailheadGraphQlData.earnedSkills records after parsing the response data from the API.
     *
     * @param userId the user handle to use when calling out to Trailhead.
     *
     * @return a List of TrailheadGraphQlData.earnedSkills records.
     */
    @AuraEnabled
    public static List<TrailheadGraphQlData.EarnedSkills> getSkillData(String userId) {
        String resBody = TrailheadHelper.executeHttpGetRequest(
            TrailheadHelper.GO_TRAILHEAD_API +
            userId +
            TrailheadHelper.SKILLS_PATH
        );

        if (resBody.contains('application-error')) {
            return null;
        }

        TrailheadGraphQlData data = (TrailheadGraphQlData) JSON.deserialize(
            resBody.replaceAll('__c', '').replaceAll('__', ''),
            TrailheadGraphQlData.class
        );

        if (String.isBlank(data.error) && data?.profile?.earnedSkills != null) {
            return data?.profile?.earnedSkills;
        } else {
            return null;
        }
    }

    /**
     * @description Returns a List of CertificationData.certificationsList records after parsing the response data from the Trailhead API.
     *
     * @param userId the user handle to use when calling out to Trailhead.
     *
     * @return a List of CertificationData.certificationsList records.
     */
    @AuraEnabled
    public static List<CertificationData.CertificationsList> getCertificationData(String userId) {
        String resBody = TrailheadHelper.executeHttpGetRequest(
            TrailheadHelper.GO_TRAILHEAD_API +
            userId +
            TrailheadHelper.CERTIFICATIONS_PATH
        );

        if (resBody.contains('application-error')) {
            return null;
        }

        CertificationData data = (CertificationData) JSON.deserialize(
            resBody.replaceAll('__c', ''),
            CertificationData.class
        );

        if (String.isBlank(data.error) && data?.certificationsList != null) {
            return data.certificationsList;
        } else {
            return null;
        }
    }

    public class TrailblazerQueryConfig {
        @AuraEnabled
        public String sortBy { get; set; }

        @AuraEnabled
        public Boolean descending { get; set; }

        @AuraEnabled
        public Integer pageSize { get; set; }

        @AuraEnabled
        public Integer offset { get; set; }
    }
}
