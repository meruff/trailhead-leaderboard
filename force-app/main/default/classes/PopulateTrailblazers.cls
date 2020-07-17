/**
* @author: meruff
* @date 3/10/20
*
* A class to populate Trailblazer__c records in batch.
*/
global class PopulateTrailblazers implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    private List<Trailblazer__c> trailblazers;

    public PopulateTrailblazers() {
        trailblazers = new List<Trailblazer__c>();
    }

    public PopulateTrailblazers(List<Trailblazer__c> scope) {
        trailblazers = scope;
    }

    global void execute(SchedulableContext SC) {
        Database.executeBatch(new PopulateTrailblazers());
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String queryString = 'SELECT Profile_Handle__c, Profile_Id__c FROM Trailblazer__c';

        if (trailblazers != null && !trailblazers.isEmpty()) {
            queryString += ' WHERE Id IN: trailblazers';
        }

        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        if (!Test.isRunningTest()) {
            System.enqueueJob(new GetTrailblazerInfoAsync(0, scope));
        }
    }

    global void finish(Database.BatchableContext BC) { }
}