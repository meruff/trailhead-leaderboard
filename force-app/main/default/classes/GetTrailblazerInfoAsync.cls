/**
 * @description A helper class for calling out to the Trailhead API and populating Trailblazer__c records.
 *
 * @author meruff
 *
 * @date 5/29/20
 */
public class GetTrailblazerInfoAsync implements Queueable, Database.AllowsCallouts {
    private static final String JOB_NAME = 'Populate Trailblazers from GetTrailblazerInfoAsync';

    private Integer jobCount = 0;
    private final List<Trailblazer__c> trailblazers;

    public GetTrailblazerInfoAsync(Integer count, List<Trailblazer__c> scope) {
        jobCount = count;
        trailblazers = scope;
    }

    public void execute(QueueableContext context) {
        if (trailblazers.isEmpty()) {
            return;
        }

        Trailblazer__c trailblazer = trailblazers[0];
        String errorMessage = '';
        errorMessage += '\n' + getProfileData(trailblazer, TrailheadHelper.fetchTrailblazerData(trailblazer, TrailheadHelper.PROFILE_PATH));
        errorMessage += '\n' + getRankData(trailblazer, TrailheadHelper.fetchTrailblazerData(trailblazer, TrailheadHelper.RANK_PATH));
        errorMessage += '\n' + getSuperbadgeData(trailblazer, TrailheadHelper.fetchTrailblazerData(trailblazer, TrailheadHelper.SUPERBADGES_PATH));
        errorMessage += '\n' + getCertificationData(trailblazer, TrailheadHelper.fetchTrailblazerData(trailblazer, TrailheadHelper.CERTIFICATIONS_PATH));

        if (String.isNotBlank(trailblazer.Profile_Handle__c)) {
            trailblazer.Error_Message__c = errorMessage.startsWith('\n') ? errorMessage.substring(1) : errorMessage;

            try {
                upsert trailblazer Profile_Handle__c;
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, e.getMessage());
            }
        }

        trailblazers.remove(0);
        jobCount++;

        if (!trailblazers.isEmpty()) {
            if (jobCount <= 4) {
                if (!Test.isRunningTest()) {
                    System.enqueueJob(new GetTrailblazerInfoAsync(jobCount, trailblazers));
                }
            } else {
                System.scheduleBatch(new PopulateTrailblazers(trailblazers), JOB_NAME, 0);
            }
        }
    }

    /**
     * @description Writes data from the /profile/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer a Trailblazer__c record to write to.
     * @param resBody the response body JSON to deserialize and write to the Trailblazer__c record.
     *
     * @return a string representing an error, if any.
     */
    public static String getProfileData(Trailblazer__c trailblazer, String resBody) {
        if (TrailheadHelper.isResponseBodyError(resBody)) {
            return TrailheadHelper.API_ERROR_MESSAGE;
        }

        ProfileData data;

        try {
            data = (ProfileData) JSON.deserialize(TrailheadHelper.sanitizeResponseBody(resBody), ProfileData.class);
        } catch (Exception e) {
            return e.getMessage();
        }

        if (data.error != null && String.isNotBlank(data.error)) {
            return data.error;
        }

        if (data.profileUser == null) {
            return TrailheadHelper.RES_BODY_CANNOT_FIND + ' profile data.';
        }

        trailblazer.Profile_Id__c = data.profileUser.Id;
        trailblazer.Name = data.profileUser.FirstName + ' ' + data.profileUser.LastName;
        trailblazer.Profile_Photo__c = data.profilePhotoUrl;
        trailblazer.Profile_Handle__c = data.profileUser.TrailblazerId;
        trailblazer.Company_Institution__c = data.profileUser.CompanyName;
        trailblazer.Job_Title__c = data.profileUser.Title;
        trailblazer.Job_Role__c = data.profileUser.TBID_Role;

        if (String.isNotBlank(data.profileUser.TrailblazerId)) {
            trailblazer.Profile_Link__c = TrailheadHelper.TRAILHEAD_ME + data.profileUser.TrailblazerId;
        } else {
            trailblazer.Profile_Link__c = TrailheadHelper.TRAILHEAD_ME_USERID + data.profileUser.Id;
        }

        return '';
    }

    /**
     * @description Writes data from the /rank endpoint to the Trailblazer__c record.
     *
     * @param trailblazer a Trailblazer__c record to write to.
     * @param resBody the response body JSON to deserialize and write to the Trailblazer__c record.
     *
     * @return a string representing an error, if any.
     */
    public static String getRankData(Trailblazer__c trailblazer, String resBody) {
        if (TrailheadHelper.isResponseBodyError(resBody)) {
            return TrailheadHelper.API_ERROR_MESSAGE;
        }

        TrailheadGraphQlData data;

        try {
            data = (TrailheadGraphQlData) JSON.deserialize(TrailheadHelper.sanitizeResponseBody(resBody), TrailheadGraphQlData.class);
        } catch (Exception e) {
            return e.getMessage();
        }

        if (data.error != null && String.isNotBlank(data.error)) {
            return data.error;
        }

        if (data?.profile?.trailheadStats == null || String.isBlank(data.profile?.typename)) {
            return TrailheadHelper.RES_BODY_CANNOT_FIND + ' rank data.';
        }

        trailblazer.Points__c = data.profile.trailheadStats.earnedPointsSum;
        trailblazer.Badges__c = data.profile.trailheadStats.earnedBadgesCount;
        trailblazer.Trails__c = data.profile.trailheadStats.completedTrailCount;
        trailblazer.Rank__c = data.profile.trailheadStats.rank.title.capitalize();
        trailblazer.Rank_Badge_Link__c = data.profile.trailheadStats.rank.imageUrl;

        return '';
    }

    /**
     * @description Writes data from the /trailblazer/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer a Trailblazer__c record to write to.
     * @param resBody the response body JSON to deserialize and write to the Trailblazer__c record.
     *
     * @return a string representing an error, if any.
     */
    public static String getSuperbadgeData(Trailblazer__c trailblazer, String resBody) {
        if (TrailheadHelper.isResponseBodyError(resBody)) {
            return TrailheadHelper.API_ERROR_MESSAGE;
        }

        TrailheadGraphQlData data;

        try {
            data = (TrailheadGraphQlData) JSON.deserialize(TrailheadHelper.sanitizeResponseBody(resBody), TrailheadGraphQlData.class);
        } catch (Exception e) {
            return e.getMessage();
        }

        if (data.error != null && String.isNotBlank(data.error)) {
            return data.error;
        }

        if (data?.profile?.earnedAwards?.edges == null || String.isBlank(data?.profile?.typename)) {
            return TrailheadHelper.RES_BODY_CANNOT_FIND + ' superbadge data.';
        }

        Integer count = 0;

        for (TrailheadGraphQlData.Edges edge : data.profile.earnedAwards.edges) {
            if (edge.node.award.type == TrailheadHelper.SUPERBADGE) {
                count++;
            }
        }

        trailblazer.Superbadges__c = count;

        return '';
    }

    /**
     * @description Writes data from the /trailblazer/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer a Trailblazer__c record to write to.
     * @param resBody the response body JSON to deserialize and write to the Trailblazer__c record.
     *
     * @return a string representing an error, if any.
     */
    public static String getCertificationData(Trailblazer__c trailblazer, String resBody) {
        if (TrailheadHelper.isResponseBodyError(resBody)) {
            return TrailheadHelper.API_ERROR_MESSAGE;
        }

        CertificationData data;

        try {
            data = (CertificationData) JSON.deserialize(TrailheadHelper.sanitizeResponseBody(resBody), CertificationData.class);
        } catch (Exception e) {
            return e.getMessage();
        }

        if (data.error != null && String.isNotBlank(data.error)) {
            return data.error;
        }

        // No certifications found doesn't mean the response body is an error.
        if (data == null || data.certificationsList == null) {
            return '';
        }

        trailblazer.Certifications__c = data.certificationsList.size();

        return '';
    }
}
