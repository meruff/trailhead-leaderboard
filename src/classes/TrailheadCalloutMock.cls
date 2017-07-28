/*****************************************
* File: TrailheadCalloutMock
* Author: detonation0
* Description: Mock callout class for PopulateTrailblazers.cls
******************************************/
@isTest
global class TrailheadCalloutMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        String resBody = '' +
            // Name
            '<span class=\'th-profile-fullname\'>detonation0</span>' +

            // Badges
            '<div class=\'panel-heading\'>\n' +
                '<h3 class=\'panel-heading__title\'>\n' +
                    'Badges\n' +
                '</h3>\n' +
            '</div>\n' +
            '<div class=\'panel-body text-center\'>\n' +
                '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>' +
                    '45' +
                '</h4>' +

            // Points
            '<div class=\'panel-heading\'>\n' +
                '<h3 class=\'panel-heading__title\'>\n' +
                    'Points\n' +
                '</h3>\n' +
                '</div>\n' +
            '<div class=\'panel-body text-center\'>\n' +
                '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>' +
                    '2000' +
                '</h4>' +

            // Trails
            '<div class=\'panel-heading\'>\n' +
                '<h3 class=\'panel-heading__title\'>\n' +
                    'Trails\n' +
                '</h3>\n' +
            '</div>\n' +
            '<div class=\'panel-body text-center\'>\n' +
                '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>' +
                    '5' +
                '</h4>' +

            // Trailblazer Since
            '<div class=\'th-profile-textbox__text\'>Trailblazer Since</div>\n' +
                '<div class=\'controls\'>\n' +
                    '<div class=\'th-profile-value\'>August 21, 2010<' +

            // Profile Link
            '<div class=\'th-profile-textbox__text\'>Profile Link</div>\n' +
                '<div class=\'controls\'>\n' +
                    '<div class=\'th-profile-value\'>https://example.net<' +

            // Rank
            '<img class=\'th-profile-rank-image\' src=\'/assets/ranks/mountaineer-' +

            // Profile Photo
            '<div class=\'th-profile-photo-container img-circle\'>\n' +
                '<img src=\'/assets/somewhere\'>';

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody(resBody);

        return res;
    }
}