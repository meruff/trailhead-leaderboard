/**
 * @description Apex controller logic for the main leaderboard.
 *
 * @author meruff
 *
 * @date 06/17/2019
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

            if (options.descending == null || options.descending) {
                queryString += ' DESC';
            } else {
                queryString += ' ASC';
            }
        }

        if (options.pageSize != null) {
            queryString += ' LIMIT ' + options.pageSize;
        }

        if (options.offset != null) {
            queryString += ' OFFSET ' + options.offset;
        }

        System.debug(LoggingLevel.DEBUG, 'merf ' + queryString);

        return Database.query(String.escapeSingleQuotes(queryString));
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

        for (String s : new Set<String>{
            GetTrailblazerInfoAsync.getProfileData(
                newTrailblazer,
                TrailheadHelper.buildCalloutURL(
                    newTrailblazer,
                    TrailheadHelper.PROFILE_PATH
                )
            ),

            GetTrailblazerInfoAsync.getRankData(
                newTrailblazer,
                TrailheadHelper.buildCalloutURL(
                    newTrailblazer,
                    TrailheadHelper.RANK_PATH
                )
            ),

            GetTrailblazerInfoAsync.getSuperbadgeData(
                newTrailblazer,
                TrailheadHelper.buildCalloutURL(
                    newTrailblazer,
                    TrailheadHelper.SUPERBADGES_PATH
                )
            ),

            GetTrailblazerInfoAsync.getCertificationData(
                newTrailblazer,
                TrailheadHelper.buildCalloutURL(
                    newTrailblazer,
                    TrailheadHelper.CERTIFICATIONS_PATH
                )
            )
        }) {
            if (!s.equals(TrailheadHelper.SUCCESS)) {
                return s;
            }
        }

        try {
            upsert newTrailblazer Profile_Handle__c;
            return 'success';
        } catch (Exception e) {
            return 'Error creating Trailblazer__c. Please try again.';
        }
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
    public static TrailheadGraphQlData.earnedAwards getBadgeData(
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

        String resBody = TrailheadHelper.doCallout(calloutURL);

        if (resBody.contains('application-error')) {
            return null;
        }

        TrailheadGraphQlData data = (TrailheadGraphQlData) JSON.deserialize(
            resBody
                .replaceAll('__c', '')
                .replaceAll('__', ''),
            TrailheadGraphQlData.class
        );

        if (String.isBlank(data.error)
            && data.profile?.earnedAwards != null
        ) {
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
    public static List<TrailheadGraphQlData.earnedSkills> getSkillData(String userId) {
        String resBody = TrailheadHelper.doCallout(
            TrailheadHelper.GO_TRAILHEAD_API + userId + TrailheadHelper.SKILLS_PATH
        );

        if (resBody.contains('application-error')) {
            return null;
        }

        TrailheadGraphQlData data = (TrailheadGraphQlData) JSON.deserialize(
            resBody
                .replaceAll('__c', '')
                .replaceAll('__', ''),
            TrailheadGraphQlData.class
        );

        if (String.isBlank(data.error)
            && data?.profile?.earnedSkills != null
        ) {
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
    public static List<CertificationData.certificationsList> getCertificationData(String userId) {
        String resBody = TrailheadHelper.doCallout(
            TrailheadHelper.GO_TRAILHEAD_API +
                userId + TrailheadHelper.CERTIFICATIONS_PATH
        );

        if (resBody.contains('application-error')) {
            return null;
        }

        CertificationData data = (CertificationData) JSON.deserialize(
            resBody.replaceAll('__c', ''),
            CertificationData.class
        );

        if (String.isBlank(data.error)
            && data?.certificationsList != null
        ) {
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