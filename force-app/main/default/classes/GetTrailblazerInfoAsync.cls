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
    private List<Trailblazer__c> trailblazers;

    public GetTrailblazerInfoAsync(Integer count, List<Trailblazer__c> scope) {
        jobCount = count;
        trailblazers = scope;
    }

    public void execute(QueueableContext context) {
        if (trailblazers.isEmpty()) {
            return;
        }

        Trailblazer__c trailblazer = trailblazers[0];
        getProfileData(trailblazer, TrailheadHelper.buildCalloutURL(trailblazer, TrailheadHelper.PROFILE_PATH));
        getRankData(trailblazer, TrailheadHelper.buildCalloutURL(trailblazer, TrailheadHelper.RANK_PATH));
        getSuperbadgeData(trailblazer, TrailheadHelper.buildCalloutURL(trailblazer, TrailheadHelper.SUPERBADGES_PATH));
        getCertificationData(trailblazer, TrailheadHelper.buildCalloutURL(trailblazer, TrailheadHelper.CERTIFICATIONS_PATH));

        if (!String.isBlank(trailblazer.Profile_Handle__c)) {
            upsert trailblazer Profile_Handle__c;
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
     * @return a string representing a successful callout.
     */
    public static String getProfileData(Trailblazer__c trailblazer, String resBody) {
        if (resBody.contains(TrailheadHelper.HEROKU_ERROR) || String.isBlank(resBody)) {
            return TrailheadHelper.buildErrorAsJSON('Application Error, please try again. API may be down.');
        }

        ProfileData data = (ProfileData) JSON.deserialize(
            resBody.replaceAll('__c', ''),
            ProfileData.class
        );

        if (!String.isBlank(data.error)) {
            return data.error;
        }

        if (data.profileUser != null) {
            trailblazer.Profile_Id__c = data.profileUser.Id;
            trailblazer.Name = data.profileUser.FirstName + ' ' + data.profileUser.LastName;
            trailblazer.Profile_Photo__c = data.profilePhotoUrl;
            trailblazer.Profile_Handle__c = data.profileUser.TrailblazerId;
            trailblazer.Company_Institution__c = data.profileUser.CompanyName;
            trailblazer.Job_Title__c = data.profileUser.Title;
            trailblazer.Job_Role__c = data.profileUser.TBID_Role;

            if (!String.isBlank(data.profileUser.TrailblazerId)) {
                trailblazer.Profile_Link__c = TrailheadHelper.TRAILHEAD_ME + data.profileUser.TrailblazerId;
            } else {
                trailblazer.Profile_Link__c = TrailheadHelper.TRAILHEAD_ME_USERID + data.profileUser.Id;
            }
        }

        return TrailheadHelper.SUCCESS;
    }

    /**
     * @description Writes data from the /rank endpoint to the Trailblazer__c record.
     *
     * @param trailblazer a Trailblazer__c record to write to.
     * @param resBody the response body JSON to deserialize and write to the Trailblazer__c record.
     *
     * @return a string representing a successful callout.
     */
    public static String getRankData(Trailblazer__c trailblazer, String resBody) {
        if (resBody.contains(TrailheadHelper.HEROKU_ERROR) || String.isBlank(resBody)) {
            return TrailheadHelper.buildErrorAsJSON('Application Error, please try again. API may be down.');
        }

        TrailheadGraphQlData data = (TrailheadGraphQlData) JSON.deserialize(
            resBody
                .replaceAll('__c', '')
                .replaceAll('__', ''),
            TrailheadGraphQlData.class
        );

        if (!String.isBlank(data.error)) {
            return data.error;
        }

        if (data?.profile?.trailheadStats != null) {
            trailblazer.Points__c = data.profile.trailheadStats.earnedPointsSum;
            trailblazer.Badges__c = data.profile.trailheadStats.earnedBadgesCount;
            trailblazer.Trails__c = data.profile.trailheadStats.completedTrailCount;
            trailblazer.Rank__c = data.profile.trailheadStats.rank.title.capitalize();
            trailblazer.Rank_Badge_Link__c = data.profile.trailheadStats.rank.imageUrl;
        }

        return TrailheadHelper.SUCCESS;
    }

    /**
     * @description Writes data from the /trailblazer/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer a Trailblazer__c record to write to.
     * @param resBody the response body JSON to deserialize and write to the Trailblazer__c record.
     *
     * @return a string representing a successful callout.
     */
    public static String getSuperbadgeData(Trailblazer__c trailblazer, String resBody) {
        if (resBody.contains(TrailheadHelper.HEROKU_ERROR) || String.isBlank(resBody)) {
            return TrailheadHelper.buildErrorAsJSON('Application Error, please try again. API may be down.');
        }

        TrailheadGraphQlData data = (TrailheadGraphQlData) JSON.deserialize(
            resBody
                .replaceAll('__c', '')
                .replaceAll('__', ''),
            TrailheadGraphQlData.class
        );

        if (!String.isBlank(data.error)) {
            return data.error;
        }

        if (data.profile?.earnedAwards?.edges != null) {
            Integer count = 0;

            for (TrailheadGraphQlData.edges edge : data.profile?.earnedAwards?.edges) {
                if (edge.node.award.type == 'SUPERBADGE') {
                    count++;
                }
            }

            trailblazer.Superbadges__c = count;
        }

        return TrailheadHelper.SUCCESS;
    }

    /**
     * @description Writes data from the /trailblazer/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer a Trailblazer__c record to write to.
     * @param resBody the response body JSON to deserialize and write to the Trailblazer__c record.
     *
     * @return a string representing a successful callout.
     */
    public static String getCertificationData(Trailblazer__c trailblazer, String resBody) {
        if (resBody.contains(TrailheadHelper.HEROKU_ERROR) || String.isBlank(resBody)) {
            return TrailheadHelper.buildErrorAsJSON('Application Error, please try again. API may be down.');
        }

        CertificationData data = (CertificationData) JSON.deserialize(
            resBody.replaceAll('__c', ''),
            CertificationData.class
        );

        if (!String.isBlank(data.error)) {
            return data.error;
        }

        if (data != null && data.certificationsList != null && !data.certificationsList.isEmpty()) {
            trailblazer.Certifications__c = data.certificationsList.size();
        }

        return TrailheadHelper.SUCCESS;
    }
}