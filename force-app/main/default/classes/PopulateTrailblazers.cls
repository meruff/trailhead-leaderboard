/**
* @author: meruff
* @date 3/10/20
*
* A class to call Trailhead profiles and update their related Objects in Salesforce.
*/
global class PopulateTrailblazers implements Schedulable {
    private List<Trailblazer__c> trailblazers;

    global void execute(SchedulableContext SC) {
        populateAll();
    }

    public PopulateTrailblazers() {
        populateAll();
    }

    public PopulateTrailblazers(List<Trailblazer__c> scope) {
        trailblazers = scope;
        populateAll();
    }

    private void populateAll() {
        System.enqueueJob(
            new GetTrailblazerInfoAsync(
                0,
                (trailblazers != null && !trailblazers.isEmpty())
                    ? trailblazers : [SELECT Profile_Handle__c, Profile_Id__c FROM Trailblazer__c]
            )
        );
    }
}