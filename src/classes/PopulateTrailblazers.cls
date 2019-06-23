/*****************************************
* File: PopulateTrailblazers
* Author: meruff
* Description: A class to call Trailhead profiles and update their related Objects in Salesforce.
******************************************/
global class PopulateTrailblazers implements Schedulable {
    public static final String TRAILHEAD_URL = 'https://trailhead.salesforce.com';

    global void execute(SchedulableContext SC) {
        populateAll();
    }

    public PopulateTrailblazers() {
        populateAll();
    }

    /**
     * Calls out to Trailhead and updates Trailblazer__c records in Salesforce with new data
     * pulled from each users Trailhead profile.
     */
    @Future(Callout=true)
    public static void populateAll() {
        List<Trailblazer__c> trailblazersToUpsert = new List<Trailblazer__c>();
        List<Badge__c> badgesToUpsert = new List<Badge__c>();

        for (Trailblazer__c trailblazer : [
            SELECT Id, Name, Badges__c, Points__c, Trails__c, Trailblazer_Since__c, Profile_Link__c,
                Profile_Id__c, Rank__c, Profile_Photo__c
            FROM Trailblazer__c
        ]) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(TRAILHEAD_URL + '/me/' + trailblazer.Profile_Id__c);
            req.setMethod('GET');
            req.setTimeout(60000);
            HttpResponse res = h.send(req);

            // Handling for redirects (custom Trailhead Profiles /me/)
            Boolean redirect = false;

            if (res.getStatusCode() >= 300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
                do {
                    redirect = false; // reset the value each time
                    String loc = res.getHeader('Location'); // get location of the redirect

                    if (loc == null) {
                        redirect = false;
                        continue;
                    }

                    req = new HttpRequest();
                    req.setEndpoint(loc);
                    req.setMethod('GET');
                    res = h.send(req);

                    if (res.getStatusCode() != 500) { // 500 = fail
                        if (res.getStatusCode() >= 300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
                            redirect = true;
                        }
                    }
                } while (redirect && Limits.getCallouts() != Limits.getLimitCallouts());
            }

            Trailblazer__c newBlazer = populateTrailblazer(res.getBody());
            trailblazersToUpsert.add(newBlazer);
            badgesToUpsert.addAll(getTrailblazerBadges(res.getBody(), newBlazer));
        }

        if (trailblazersToUpsert.size() > 0) {
            upsert trailblazersToUpsert Profile_Id__c;
        }

        if (badgesToUpsert.size() > 0) {
            upsert badgesToUpsert Upsert_Key__c;
        }
    }

    /**
     * Parses the response body of the callout to update the Trailblazer__c record.
     *
     * @param resBody, the body of the user's Trailhead profile. Used to parse data for updating the Traiblazer__c record.
     * @return tb, the Trailblazer__c record to update in Salesforce.
     */
    public static Trailblazer__c populateTrailblazer(String resBody) {
        Trailblazer__c tb = new Trailblazer__c();

        try {
            tb.Badges__c = Decimal.valueOf(resBody.substringBetween('data-test-badges-count>', '</').replace(',', '').trim());
            tb.Points__c = Decimal.valueOf(resBody.substringBetween('data-test-points-count>', '</').replace(',', '').trim());
            tb.Trails__c = Decimal.valueOf(resBody.substringBetween('data-test-trails-count>', '</').replace(',', '').trim());

            // About Me
            String aboutMe = resBody.substringBetween('<div data-react-class=\"profile/AboutMe\" data-react-props=\"', '</').trim();
            Map<String, Object> aboutMeMap = (Map<String, Object>) JSON.deserializeUntyped(aboutMe.replace('&quot;', '\"'));
            Map<String, Object> userMap = (Map<String, Object>) aboutMeMap.get('user');

            // Name
            String fullName = String.valueOf(userMap.get('full_name'));
            String fixedName = '';
            fullName = fullName.replaceAll('[0-9]', '');
            String[] temp = fullName.split(' ');
            for (String s : temp) fixedName += s.capitalize() + ' ';
            tb.Name = fixedName;

            // Trailblazer Since
            Datetime createdAt = (Datetime) JSON.deserialize('\"' + userMap.get('created_at') + '\"', Datetime.class);
            tb.Trailblazer_Since__c = createdAt.format('MMMM d, yyyy');

            // Profile Id
            tb.Profile_Id__c = String.valueOf(userMap.get('th_sfid'));

            // Profile Link
            tb.Profile_Link__c = String.valueOf(aboutMeMap.get('profileShortcutUrl'));

            // Job Title
            tb.Job_Title__c = String.valueOf(userMap.get('job_title'));

            // Job Role
            tb.Job_Role__c = String.valueOf(userMap.get('job_role'));

            // Company
            tb.Company_Institution__c = String.valueOf(userMap.get('company'));

            // Rank
            tb.Rank__c = resBody.substringBetween('src=\"/assets/ranks/', '-').capitalize().trim();

            // Profile Photo URL
            tb.Profile_Photo__c = resBody.substringBetween('<img class=\"user-information__avatar-img\" src=\"', '\"').trim();

            // Fix for Profile Photo if the user has not uploaded one.
            if (tb.Profile_Photo__c.startsWith('/assets/')) {
                String newPhotoURL = 'https://trailhead.salesforce.com';
                newPhotoURL += tb.Profile_Photo__c;
                tb.Profile_Photo__c = newPhotoURL;
            }

            return tb;
        } catch (Exception e) {
            System.debug('ERROR - problem parsing response body from Trailhead. ' + e.getMessage() + ' ' + e.getLineNumber());
            return null;
        }
    }

    /**
     * Parses the resBody for the User's Badge records.
     *
     * @param resBody, the body of the user's Trailhead profile. Used to parse data for updating the Traiblazer__c record.
     * @param tb, The Trailblazer__c record to use to attach the upserted Badge__c records to.
     * @return a List of Badge__c records for the Trailblazer.
     */
    public static List<Badge__c> getTrailblazerBadges(String resBody, Trailblazer__c tb) {
        List<Badge__c> newBadges = new List<Badge__c>();

        if (resBody.contains('<div data-react-class=\"BadgesPanel\" data-react-props=\"')) {
            String badges = resBody.substringBetween('<div data-react-class=\"BadgesPanel\" data-react-props=\"', '</').trim();
            Map<String, Object> badgesMap = (Map<String, Object>) JSON.deserializeUntyped(badges.replace('&quot;', '\"'));

            for (Object o : (List<Object>) badgesMap.get('badges')) {
                Map<String, Object> badge = (Map<String, Object>) o;

                Badge__c newBadge = new Badge__c(
                    Name = String.valueOf(badge.get('title')),
                    Icon_Link__c = String.valueOf(badge.get('icon_url')),
                    Points__c = String.valueOf(badge.get('points')),
                    Type__c = String.valueOf(badge.get('type')),
                    Path__c = String.valueOf(badge.get('path')),
                    Trailblazer__r = new Trailblazer__c(Profile_Id__c = tb.Profile_Id__c)
                );

                if (!String.isBlank(String.valueOf(badge.get('api_name')))) {
                    newBadge.Upsert_Key__c = tb.Profile_Id__c + String.valueOf(badge.get('api_name'));
                } else if (!String.isBlank(String.valueOf(badge.get('id')))) {
                    newBadge.Upsert_Key__c = tb.Profile_Id__c + String.valueOf(badge.get('id'));
                }

                if (!String.isBlank(String.valueOf(badge.get('finished_at')))) {
                    Datetime finishedAt = (Datetime) JSON.deserialize('\"' + badge.get('finished_at') + '\"', Datetime.class);
                    newBadge.Date_Earned__c = finishedAt;
                }

                if (!String.isBlank(newBadge.Upsert_Key__c)) newBadges.add(newBadge);
            }
        }

        return newBadges;
    }
}