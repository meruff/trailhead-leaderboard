/*****************************************
* File: TrailheadLeaderboardController
* Author: Mat Ruff
* Description: Controller class for trailheadLeaderboard.page
******************************************/
public class TrailheadLeaderboardController {
    private Set<Id> trailblazerIds;
    public List<Trailblazer__c> trailblazers { get; set; }
    public Trailblazer__c newBlazer { get; set; }

    public TrailheadLeaderboardController() {
        newBlazer = new Trailblazer__c();
        populateTrailblazers();
    }

    public void populateTrailblazers() {
        trailblazerIds = new Set<Id>();
        trailblazers = new List<Trailblazer__c>([
            SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Id__c,
                Profile_Link__c, Rank__c, Profile_Photo__c
            FROM Trailblazer__c
            ORDER BY Points__c DESC
        ]);

        for (Trailblazer__c tb : trailblazers) {
            trailblazerIds.add(tb.Profile_Id__c);
        }
    }

    public void createNewTrailblazer() {
        if (newBlazer.Profile_Id__c.length() > 18 || newBlazer.Profile_Id__c.length() < 18) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.Error,
                'Profile Ids must be 18 characters in length.'));
            return;
        }

        if (String.isEmpty(newBlazer.Name) || String.isEmpty(newBlazer.Profile_Id__c)) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.Error,
                'You must enter your Name and Trailhead Profile Id in order to be added to the leaderboard.'));
            return;
        }

        if (trailblazerIds.contains(newBlazer.Profile_Id__c)) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.Error,
                'This trailblazer already exists.'));
            return;
        }

        Trailblazer__c insertBlazer = updateTrailblazer(newBlazer);

        if (insertBlazer != null) {
            insert insertBlazer;
            populateTrailblazers();
        } else {
            return;
        }
    }

    public Trailblazer__c updateTrailblazer(Trailblazer__c tb) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://trailhead.salesforce.com/users/profiles/' + tb.Profile_Id__c);
        req.setMethod('GET');
        HttpResponse res = h.send(req);

        if (res.getStatus() != 'Not Found' && (!res.getBody().contains('Someone\'s hiding!') && !res.getBody().contains('This user has chosen to keep their profile private.'))) {
            Trailblazer__c tbToInsert = PopulateTrailblazers.populateTrailblazer(res.getBody());
            tbToInsert.Profile_Id__c = tb.Profile_Id__c;
            return tbToInsert;
        } else {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.Error,
                'Could not find a Trailhead profile for User Id: ' + tb.Profile_Id__c + '. ' +
                'Please ensure your profile is set to public and you\'ve copied your Id correctly.'));
            return null;
        }
    }
}