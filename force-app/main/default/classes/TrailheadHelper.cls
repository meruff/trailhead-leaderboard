/**
 * @description A helper class used for basic shared methods between the Trailhead API and Salesforce.
 *
 * @author meruff
 *
 * @date 7/25/22
 */
public class TrailheadHelper {
    public static final String API_ERROR = 'Application error';
    public static final String API_ERROR_MESSAGE = 'Api callout error, does trailblazer exist?';
    public static final String BADGES_PATH = '/badges';
    public static final String CERTIFICATIONS_PATH = '/certifications';
    public static final String GO_TRAILHEAD_API = 'https://go-trailhead-leaderboard-api.up.railway.app/trailblazer/';
    public static final String PROFILE_PATH = '/profile';
    public static final String RANK_PATH = '/rank';
    public static final String RES_BODY_CANNOT_FIND = 'Cannot find';
    public static final String SKILLS_PATH = '/skills';
    public static final String SUCCESS = 'success';
    public static final String SUPERBADGE = 'SUPERBADGE';
    public static final String SUPERBADGES_PATH = BADGES_PATH + '/superbadge/50';
    public static final String TRAILHEAD_ME = 'https://trailblazer.me/id/';
    public static final String TRAILHEAD_ME_USERID = 'https://trailblazer.me/id?cmty=trailhead&uid=';

    /**
     * @description Builds the callout endpoint before calling doCallout() to get a JSON response.
     *
     * @param trailblazer the Trailblazer__c record to populate with response data.
     * @param path the URL path to append to the end of the default callout URL i.e. '/certifications'.
     *
     * @return the response body returned from the endpoint.
     *
     * @see TrailheadHelper.executeHttpGetRequest
     */
    public static String fetchTrailblazerData(Trailblazer__c trailblazer, String path) {
        return TrailheadHelper.executeHttpGetRequest(
            TrailheadHelper.GO_TRAILHEAD_API + (trailblazer.Profile_Handle__c ?? trailblazer.Profile_Id__c) + path
        );
    }

    /**
     * @description Creates a callout using the supplied URL.
     *
     * @param calloutURL the URL to do a callout to.
     *
     * @return the body of the callout response.
     */
    public static String executeHttpGetRequest(String calloutURL) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(calloutURL);
        req.setMethod('GET');
        req.setTimeout(60000);

        try {
            HttpResponse res = h.send(req);
            return res.getBody();
        } catch (Exception e) {
            return API_ERROR_MESSAGE + e.getMessage();
        }
    }

    /**
     * @description Sanitizes the response body by removing `'__c'` and `'__'` from the JSON.
     *
     * @param resBody the response body to sanitize.
     *
     * @return a string representing the sanitized response body.
     */
    public static String sanitizeResponseBody(String resBody) {
        return resBody.replaceAll('__c', '').replaceAll('__', '');
    }

    /**
     * @description Determines if the response body is an error.
     *
     * @param resBody the response body to check.
     *
     * @return a boolean indicating if the response body is an error.
     */
    public static Boolean isResponseBodyError(String resBody) {
        return String.isBlank(resBody)
            || resBody.contains(API_ERROR)
            || resBody.contains(RES_BODY_CANNOT_FIND);
    }
}
