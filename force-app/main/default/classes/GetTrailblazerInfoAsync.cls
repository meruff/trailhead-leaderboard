/**
* @author meruff
* @date 5/29/20
*
* A helper class for calling out to the Trailhead API and populating Trailblazer__c records.
*/
public class GetTrailblazerInfoAsync implements Queueable, Database.AllowsCallouts {
    public static final String TRAILHEAD_ME = 'https://trailblazer.me/id/';
    public static final String TRAILHEAD_ME_USERID = 'https://trailblazer.me/id?cmty=trailhead&uid=';
    public static final String GO_TRAILHEAD_API = 'https://go-trailhead-leaderboard-api.herokuapp.com/trailblazer/';
    public static final String JOB_NAME = 'Populate Trailblazers from GetTrailblazerInfoAsync';
    public static final String PROFILE_PATH = '/profile';
    public static final String SUPERBADGES_PATH = '/badges/superbadge';
    public static final String CERTIFICATIONS_PATH = '/certifications';
    public static final String HEROKU_ERROR = 'Application error';
    public static final String SUCCESS = 'success';

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
        getProfileCountsData(trailblazer, buildCalloutURL(trailblazer, ''));
        getProfileData(trailblazer, buildCalloutURL(trailblazer, PROFILE_PATH));
        getSuperbadgeData(trailblazer, buildCalloutURL(trailblazer, SUPERBADGES_PATH));
        getCertificationData(trailblazer, buildCalloutURL(trailblazer, CERTIFICATIONS_PATH));

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
     * Bulids the callout endpoint before calling doCallout() to get a JSON response.
     * 
     * @see doCallout()
     * 
     * @param trailblazer, the Trailblazer__c record to populate with response data.
     * @param path, the URL path to append to the end of the default callout URL i.e. '/certifications'.
     *
     * @return res.getBody(), the JSON response body returned from the endpoint.
     */
    public static String buildCalloutURL(Trailblazer__c trailblazer, String path) {
        String calloutURL = '';

        if (!String.isBlank(trailblazer.Profile_Handle__c)) {
            calloutURL = GO_TRAILHEAD_API + trailblazer.Profile_Handle__c + (!String.isBlank(path) ? path : '');
        } else {
            calloutURL = GO_TRAILHEAD_API + trailblazer.Profile_Id__c + (!String.isBlank(path) ? path : '');
        }

        return doCallout(calloutURL);
    }

    /**
     * Writes data from the /profile/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer, a Trailblazer__c record to write to.
     * 
     * @param resBody, the response body JSON to deserialize and write to the Trailblazer__c record.
     */
    public static String getProfileData(Trailblazer__c trailblazer, String resBody) {
        if (resBody.contains(HEROKU_ERROR) || String.isBlank(resBody)) {
            return buildErrorAsJSON('Application Error, please try again. API may be down.');
        }

        ProfileData data = (ProfileData) JSON.deserialize(resBody.replaceAll('__c', ''), ProfileData.class);
        
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
                trailblazer.Profile_Link__c = TRAILHEAD_ME + data.profileUser.TrailblazerId;
            } else {
                trailblazer.Profile_Link__c = TRAILHEAD_ME_USERID + data.profileUser.Id;
            }
        }
        
        return SUCCESS;
    }

    /**
     * Writes data from the /trailblazer/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer, a Trailblazer__c record to write to.
     * 
     * @param resBody, the response body JSON to deserialize and write to the Trailblazer__c record.
     */
    public static String getProfileCountsData(Trailblazer__c trailblazer, String resBody) {
        if (resBody.contains(HEROKU_ERROR) || String.isBlank(resBody)) {
            return buildErrorAsJSON('Application Error, please try again. API may be down.');
        }

        ProfileCountData data = (ProfileCountData) JSON.deserialize(resBody.replaceAll('__c', ''), ProfileCountData.class);

        if (!String.isBlank(data.error)) {
            return data.error;
        }
        
        if (data.value != null && !data.value.isEmpty() 
            && data.value[0].ProfileCounts != null 
            && !data.value[0].ProfileCounts.isEmpty()
        ) {
            trailblazer.Points__c = data.value[0].ProfileCounts[0].EarnedPointTotal;
            trailblazer.Badges__c = data.value[0].ProfileCounts[0].EarnedBadgeTotal;
            trailblazer.Trails__c = data.value[0].ProfileCounts[0].CompletedTrailTotal;
            trailblazer.Rank__c = data.value[0].ProfileCounts[0].RankLabel.capitalize();
            trailblazer.Rank_Badge_Link__c = data.value[0].ProfileCounts[0].RankImageUrl;
        }
        
        return SUCCESS;
    }

    /**
     * Writes data from the /trailblazer/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer, a Trailblazer__c record to write to.
     * 
     * @param resBody, the response body JSON to deserialize and write to the Trailblazer__c record.
     */
    public static String getSuperbadgeData(Trailblazer__c trailblazer, String resBody) {
        if (resBody.contains(HEROKU_ERROR) || String.isBlank(resBody)) {
            return buildErrorAsJSON('Application Error, please try again. API may be down.');
        }

        BadgeData data = (BadgeData) JSON.deserialize(resBody.replaceAll('__c', ''), BadgeData.class);

        if (!String.isBlank(data.error)) {
            return data.error;
        }

        if (data.value != null 
            && !data.value.isEmpty() 
            && data.value[0].EarnedAwards != null 
            && !data.value[0].EarnedAwards.isEmpty()
        ) {
            Integer count = 0;

            for (BadgeData.EarnedAwards award : data.value[0].EarnedAwards) {
                if (award.AwardType == 'Superbadge') count++;
            }

            trailblazer.Superbadges__c = count;
        }

        return SUCCESS;
    }

    /**
     * Writes data from the /trailblazer/ endpoint to the Trailblazer__c record.
     *
     * @param trailblazer, a Trailblazer__c record to write to.
     * 
     * @param resBody, the response body JSON to deserialize and write to the Trailblazer__c record.
     */
    public static String getCertificationData(Trailblazer__c trailblazer, String resBody) {
        if (resBody.contains(HEROKU_ERROR) || String.isBlank(resBody)) {
            return buildErrorAsJSON('Application Error, please try again. API may be down.');
        }

        CertificationData data = (CertificationData) JSON.deserialize(resBody.replaceAll('__c', ''), CertificationData.class);

        if (!String.isBlank(data.error)) {
            return data.error;
        }

        if (data != null 
            && data.certificationsList != null 
            && !data.certificationsList.isEmpty()
        ) {
            trailblazer.Certifications__c = data.certificationsList.size();
        }

        return SUCCESS;
    }

    /**
     * Creates a callout using the supplied URL.
     *
     * @param calloutURL, the URL to do a callout to.
     * 
     * @return res.getBody() the body of the callout response.
     */
    public static String doCallout(String calloutURL) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(calloutURL);
        req.setMethod('GET');
        req.setTimeout(60000);
        HttpResponse res = h.send(req);

        return res.getBody();
    }

    /**
     * Returns a JSON Error object from the provided message String.
     * 
     * @param message, the String to output as the Error message. 
     * 
     * @return a serialized GetTrailblazerInfoAsync.Error object.
     */
    private static String buildErrorAsJSON(String message) {
        return JSON.serialize(new Error(message));
    }

    class Error {
        public String error { get; set; }

        public Error(String message) {
            this.error = message;
        }
    }
}