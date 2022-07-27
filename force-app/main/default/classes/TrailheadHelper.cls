/**
 * @description A helper class used for basic shared methods between the Trailhead API and Salesforce.
 *
 * @author meruff
 *
 * @date 7/25/22
 */
public class TrailheadHelper {
    public static final String GO_TRAILHEAD_API = 'https://go-trailhead-leaderboard-api.herokuapp.com/trailblazer/';
    public static final String TRAILHEAD_ME = 'https://trailblazer.me/id/';
    public static final String TRAILHEAD_ME_USERID = 'https://trailblazer.me/id?cmty=trailhead&uid=';

    public static final String BADGES_PATH = '/badges';
    public static final String CERTIFICATIONS_PATH = '/certifications';
    public static final String HEROKU_ERROR = 'Application error';
    public static final String PROFILE_PATH = '/profile';
    public static final String RANK_PATH = '/rank';
    public static final String SKILLS_PATH = '/skills';
    public static final String SUCCESS = 'success';
    public static final String SUPERBADGES_PATH = BADGES_PATH + '/superbadge/50';

    /**
     * @description Builds the callout endpoint before calling doCallout() to get a JSON response.
     *
     * @param trailblazer the Trailblazer__c record to populate with response data.
     * @param path the URL path to append to the end of the default callout URL i.e. '/certifications'.
     *
     * @return the response body returned from the endpoint.
     *
     * @see TrailheadHelper.doCallout
     */
    public static String buildCalloutURL(Trailblazer__c trailblazer, String path) {
        return TrailheadHelper.doCallout(TrailheadHelper.GO_TRAILHEAD_API +
            (String.isNotBlank(trailblazer.Profile_Handle__c)
                ? trailblazer.Profile_Handle__c
                : trailblazer.Profile_Id__c
            ) +
            path
        );
    }

    /**
     * @description Creates a callout using the supplied URL.
     *
     * @param calloutURL the URL to do a callout to.
     *
     * @return the body of the callout response.
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
     * @description Returns a JSON Error object from the provided message String.
     *
     * @param message the String to output as the Error message.
     *
     * @return a serialized GetTrailblazerInfoAsync.Error object.
     */
    public static String buildErrorAsJSON(String message) {
        return JSON.serialize(new Error(message));
    }

    public class Error {
        public String error { get; set; }

        public Error(String message) {
            this.error = message;
        }
    }
}