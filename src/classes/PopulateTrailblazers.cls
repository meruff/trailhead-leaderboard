/*****************************************
* File: PopulateTrailblazers
* Author: detonation0
* Description: A class to call Trailhead profiles and update their related Objects in Salesforce.
******************************************/
global class PopulateTrailblazers implements Schedulable {
    global void execute(SchedulableContext SC) {
        calloutToTrailhead();
    }

    public PopulateTrailblazers() {
        calloutToTrailhead();
    }

    /**
     * @description Calls out to Trailhead and updates Trailblazer__c records in Salesforce with new data
     * pulled from each users Trailhead profile.
     */
    @future(callout=true)
    public static void calloutToTrailhead() {
        List<Trailblazer__c> trailblazersToUpsert = new List<Trailblazer__c>();

        for (Trailblazer__c trailblazer : [
            SELECT Id, Name, Badges__c, Points__c, Trails__c, Trailblazer_Since__c, Profile_Link__c,
                Profile_Id__c, Rank__c, Profile_Photo__c
            FROM Trailblazer__c
        ]) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://trailhead.salesforce.com/users/profiles/' + trailblazer.Profile_Id__c);
            req.setMethod('GET');
            HttpResponse res = h.send(req);

            Trailblazer__c newBlazer = populateTrailblazer(res.getBody());
            newBlazer.Profile_Id__c = trailblazer.Profile_Id__c;
            trailblazersToUpsert.add(newBlazer);
        }

        if (trailblazersToUpsert.size() > 0) {
            upsert trailblazersToUpsert Profile_Id__c;
        }
    }

    /**
     * @description Parses the response body of the callout to update the Trailblazer__c record.
     * @param resBody, the body of the user's Trailhead profile. Used to parse data for updating the Traiblazer__c record.
     * @return tb, the Trailblazer__c record to update in Salesforce.
     */
    public static Trailblazer__c populateTrailblazer(String resBody) {
        Trailblazer__c tb = new Trailblazer__c();

        try {
            // Name
            String fixedName = '';
            String fullName = resBody.substringBetween('class=\'th-profile-fullname\'>', '<').trim();
            fullName = fullName.replaceAll('[0-9]', '');
            String[] temp = fullName.split(' ');

            for (String s : temp) {
                s = s.capitalize();
                fixedName += s + ' ';
            }
            tb.Name = fixedName;

            // Badges
            tb.Badges__c = Decimal.valueOf(
                resBody.substringBetween('' +
                    '<div class=\'panel-heading\'>\n' +
                        '<h3 class=\'panel-heading__title\'>\n' +
                            'Badges\n' +
                        '</h3>\n' +
                    '</div>\n' +
                    '<div class=\'panel-body text-center\'>\n' +
                        '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>', '</h4>'
                ).replace(',', '').trim()
            );

            // Points
            tb.Points__c = Decimal.valueof(
                resBody.substringBetween('' +
                    '<div class=\'panel-heading\'>\n' +
                        '<h3 class=\'panel-heading__title\'>\n' +
                            'Points\n' +
                        '</h3>\n' +
                    '</div>\n' +
                    '<div class=\'panel-body text-center\'>\n' +
                        '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>', '</h4>'
                ).replace(',', '').trim()
            );

            // Trails
            tb.Trails__c = Decimal.valueof(
                resBody.substringBetween('' +
                    '<div class=\'panel-heading\'>\n' +
                        '<h3 class=\'panel-heading__title\'>\n' +
                            'Trails\n' +
                        '</h3>\n' +
                        '</div>\n' +
                    '<div class=\'panel-body text-center\'>\n' +
                        '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>', '</h4>'
                ).replace(',', '').trim()
            );

            // Trailblazer Since
            tb.Trailblazer_Since__c = resBody.substringBetween('' +
                '<div class=\'th-profile-textbox__text\'>Trailblazer Since</div>\n' +
                    '<div class=\'controls\'>\n' +
                        '<div class=\'th-profile-value\'>', '<'
            ).trim();

            // Profile Link
            tb.Profile_Link__c = resBody.substringBetween('' +
                '<div class=\'th-profile-textbox__text\'>Profile Link</div>\n' +
                    '<div class=\'controls\'>\n' +
                        '<div class=\'th-profile-value\'>', '<'
            ).trim();

            // Rank
            tb.Rank__c = resBody.substringBetween('' +
                '<img class=\'th-profile-rank-image\' src=\'/assets/ranks/', '-'
            ).capitalize().trim();

            // Profile Photo URL
            tb.Profile_Photo__c = resBody.substringBetween('' +
                '<div class=\'th-profile-photo-container img-circle\'>\n' +
                 '<img src=\'', '\'>'
            ).trim();

            // Fix for Profile Photo if the user has not uploaded one.
            if (tb.Profile_Photo__c.startsWith('/assets/')) {
                String newPhotoURL = 'https://trailhead.salesforce.com';
                newPhotoURL += tb.Profile_Photo__c;
                tb.Profile_Photo__c = newPhotoURL;
            }
        } catch(Exception e) {
            System.debug('ERROR - problem parsing response body from Trailhead. ' + e.getMessage());
        }

        return tb;
    }
}