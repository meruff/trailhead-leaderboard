/*****************************************
* File: PopulateTrailblazers
* Author: Mat Ruff
* Description: A class to call Trailhead profiles and update their related Objects. 
******************************************/
global class PopulateTrailblazers implements Schedulable {
    private static final String CALLOUT_URL = 'https://trailhead.salesforce.com/users/profiles/';

    global void execute(SchedulableContext SC) {
        findTrailblazers();
    }

    public PopulateTrailblazers() {
        findTrailblazers();
    }

    @future(callout=true)
    public static void findTrailblazers() {
        Map<String, Trailblazer__c> trailblazerMap = new Map<String, Trailblazer__c>();

        List<Trailblazer__c> blazers = new List<Trailblazer__c>([
            SELECT Id, Name, Badges__c, Points__c, Trails__c, Trailblazer_Since__c, Profile_Link__c,
                Profile_Id__c, Rank__c, Profile_Photo__c
            FROM Trailblazer__c
        ]);

        if (blazers.size() > 0) {
            Set<Id> trailblazerIds = new Set<Id>();
            for (Trailblazer__c tb : blazers) {
                trailblazerIds.add(tb.Profile_Id__c);
                trailblazerMap.put(tb.Profile_Id__c, tb);
            }

            calloutToTrailhead(trailblazerIds, trailblazerMap);
        }
    }

    public static void calloutToTrailhead(Set<Id> trailblazerIds, Map<String, Trailblazer__c> trailblazerMap) {
        List<Trailblazer__c> tbsToUpdate = new List<Trailblazer__c>();

        for (Id trailblazerId : trailblazerIds) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(CALLOUT_URL + trailblazerId);
            req.setMethod('GET');
            HttpResponse res = h.send(req);

            Trailblazer__c tb = populateTrailblazer(res.getBody());

            if (trailblazerMap.containsKey(trailblazerId)) {
                Trailblazer__c tbToUpdate = trailblazerMap.get(trailblazerId);
                tbToUpdate.Name = tb.Name;
                tbToUpdate.Rank__c = tb.Rank__c;
                tbToUpdate.Badges__c = tb.Badges__c;
                tbToUpdate.Points__c = tb.Points__c;
                tbToUpdate.Trails__c = tb.Trails__c;
                tbToUpdate.Trailblazer_Since__c = tb.Trailblazer_Since__c;
                tbToUpdate.Profile_Link__c = tb.Profile_Link__c;
                tbToUpdate.Profile_Photo__c = tb.Profile_Photo__c;
                System.debug('Updating tbToUpdate: ' + tbToUpdate);
                tbsToUpdate.add(tbToUpdate);
            }
        }

        if (tbsToUpdate.size() > 0) {
            update tbsToUpdate;
        }
    }

    public static Trailblazer__c populateTrailblazer(String resBody) {
        Trailblazer__c tb = new Trailblazer__c();

        Integer indexOfName = resBody.indexOf('th-profile-fullname') - 14;
        String fullName = resBody.substring(indexOfName).substringBetween(
            '<span class=\'th-profile-fullname\'>',
            '</span>'
        ).trim();
        fullName = fullName.replaceAll('[0-9]', '');
        fullName = fullName.trim();
        String[] temp = fullName.split(' ');
        String fixedName = '';
        for (String s : temp) {
            s = s.capitalize();
            fixedName += s + ' ';
        }
        fixedName = fixedName.trim();
        tb.Name = fixedName;

        Integer indexOfBadges = resBody.indexOf('panel-heading__title\'>\nBadges');
        String numOfBadges = resBody.substring(indexOfBadges).substringBetween(
            '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>',
            '</h4>'
        ).trim();
        tb.Badges__c = Decimal.valueOf(numOfBadges.replace(',', ''));

        Integer indexOfPoints = resBody.indexOf('panel-heading__title\'>\nPoints');
        String numOfPoints = resBody.substring(indexOfPoints).substringBetween(
            '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>',
            '</h4>'
        ).trim();
        tb.Points__c = Decimal.valueof(numOfPoints.replace(',', ''));

        Integer indexOfTrails = resBody.indexOf('panel-heading__title\'>\nTrails');
        String numOfTrails = resBody.substring(indexOfTrails).substringBetween(
            '<h4 class=\'th-profile-title th-profile-title--green leading-marg-m\'>',
            '</h4>'
        ).trim();
        tb.Trails__c = Decimal.valueof(numOfTrails.replace(',', ''));

        Integer indexOfTrailblazerSince = resBody.indexOf('Trailblazer Since');
        String trailblazerSince = resBody.substring(indexOfTrailblazerSince).substringBetween(
            '<div class=\'th-profile-value\'>',
            '</div>'
        ).trim();
        tb.Trailblazer_Since__c = trailblazerSince;

        Integer indexOfProfileLink = resBody.indexOf('Profile Link');
        String profileLink = resBody.substring(indexOfProfileLink).substringBetween(
            '<div class=\'th-profile-value\'>',
            '</div>'
        ).trim();
        tb.Profile_Link__c = profileLink;

        Integer indexOfRank = resBody.indexOf('<img class=\'th-profile-rank-image\' src=\'/assets/ranks/');
        String rank = resBody.substring(indexOfRank).substringBetween(
            '<img class=\'th-profile-rank-image\' src=\'/assets/ranks/',
            '-'
        ).trim();
        tb.Rank__c = rank.capitalize();

        Integer indexOfPhoto = resBody.indexOf('th-profile-photo-container img-circle');
        String photoURL = resBody.substring(indexOfPhoto).substringBetween(
            '<img src=\'',
            '\'>'
        ).trim();
        if (photoURL.contains('/assets/')) {
            photoURL = 'https://trailhead.salesforce.com' + photoURL;
        }
        tb.Profile_Photo__c = photoURL;

        return tb;
    }
}