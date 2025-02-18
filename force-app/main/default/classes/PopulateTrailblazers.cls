/**
 * @description A class to populate Trailblazer__c records in batch.
 *
 * @author meruff
 *
 * @date 3/10/20
 */
public class PopulateTrailblazers implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    private final List<Trailblazer__c> trailblazers;

    public PopulateTrailblazers() {
        trailblazers = new List<Trailblazer__c>();
    }

    public PopulateTrailblazers(List<Trailblazer__c> scope) {
        trailblazers = scope;
    }

    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        String queryString = 'SELECT Profile_Handle__c, Profile_Id__c FROM Trailblazer__c';

        if (trailblazers != null && !trailblazers.isEmpty()) {
            queryString += ' WHERE Id IN: trailblazers';
        }

        return Database.getQueryLocatorWithBinds(
            queryString,
            new Map<String, Object>{ 'trailblazers' => trailblazers },
            AccessLevel.SYSTEM_MODE
        );
    }

    public void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new PopulateTrailblazers());
    }

    public void execute(Database.BatchableContext batchableContext, List<SObject> scope) {
        if (!Test.isRunningTest()) {
            System.enqueueJob(new GetTrailblazerInfoAsync(0, scope));
        }
    }

    public void finish(Database.BatchableContext batchableContext) {
    }
}
