/*****************************************
* File: TrailheadCalloutMock
* Author: meruff
* Description: Mock callout class for PopulateTrailblazers.cls
******************************************/
@IsTest
public class TrailheadCalloutMock implements HttpCalloutMock {
    List<HttpResponse> responses = new List<HttpResponse>();

    public void addResponse(HttpResponse response) {
        responses.add(response);
    }

    public HttpResponse respond(HttpRequest req) {
        if (responses.size() > 1) {
            return responses.remove(0);
        } else {
            return responses[0];
        }
    }

    public static String getSuccessfulResponseBody() {
        return '' +
            // User Data
            '<div data-react-class=\"profile/AboutMe\" data-react-props=\"' +
                '{' +
                    '\"user\":{' +
                        '\"first_name\":\"Tony\",' +
                        '\"last_name\":\"Stark\",' +
                        '\"job_role\":\"Developer\",' +
                        '\"company\":\"Test Co.\",' +
                        '\"job_title\":\"Developer\",' +
                        '\"created_at\":\"2014-02-11T13:35:04.000-08:00\",' +
                        '\"th_sfid\":\"005500000061jCZBBB\",' +
                        '\"full_name\":\"Tony Stark\"' +
                    '},' +
                    '\"profileUrl\":\"https://trailhead.salesforce.com/en/me/005500000061jCZBBB\",' +
                    '\"profileShortcutUrl\":\"https://trailhead.com/me/005500000061jCZBBB\"' +
                '}' +
            '</' +

            'data-test-badges-count>1</' +
            'data-test-points-count>6000</' +
            'data-test-trails-count>0</' +

            // Rank
            '<a class=\'slds-show slds-text-align_center\' data-test-current-rank href=\'/en/trailblazer-ranks\'>' +
                '<img width=\"100px\" src=\"/assets/ranks/expeditioner-test.png\" alt=\"Expeditioner\"/>' +
            '</a>' +

            // Profile Photo
            '<img class=\"user-information__avatar-img\" src=\"/assets/photo.jpg\">' +

            // Badges
            '<div data-react-class=\"BadgesPanel\" data-react-props=\"' +
                '{' +
                    '\"badges\":[{' +
                        '\"user_id\":4783481,' +
                        '\"api_name\":\"superbadge_aap\",' +
                        '\"state\":\"Completed\",' +
                        '\"last_attempted_at\":\"2018-02-19T12:16:19.008-08:00\",' +
                        '\"finished_at\":\"2018-02-19T12:16:22.707-08:00\",' +
                        '\"created_at\":\"2018-02-15T07:11:36.104-08:00\",' +
                        '\"updated_at\":\"2018-02-19\",' +
                        '\"type\":\"Th::UserSuperbadge\",' +
                        '\"path\":\"/superbadges/superbadge_aap\",' +
                        '\"badge_type\":\"superbadge\",' +
                        '\"icon_url\":\"https://developer.salesforce.com/resource/images/trailhead/badges/superbadges/trailhead_superbadge_advanced_apex_specialist.png\",' +
                        '\"title\":\"Advanced Apex Specialist\",' +
                        '\"progress\":100,' +
                        '\"points\":6000' +
                    '}]' +
                '}' +
            '\"></';
    }

    public static String getErrorResponseBody() {
        return 'Someone\'s hiding!';
    }
}