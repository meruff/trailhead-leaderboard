/**
 * @description Unit Tests for PopulateTrailblazers.cls
 *
 * @author meruff
 *
 * @date 7/27/17
 */
@IsTest
private class PopulateTrailblazersTest {
    @IsTest
    static void testExecuteBatch() {
        Test.startTest();
        Database.executeBatch(new PopulateTrailblazers());
        Test.stopTest();
    }

    @IsTest
    static void testExecuteBatchWithScope() {
        insert new Trailblazer__c(
            Name = 'mat ruff',
            Profile_Handle__c = 'matruff'
        );

        Test.startTest();
        Database.executeBatch(
            new PopulateTrailblazers([
                SELECT Id,
                    Profile_Handle__c,
                    Profile_Id__c
                FROM Trailblazer__c
            ])
        );
        Test.stopTest();
    }

    @IsTest
    static void testSchedulePopulation() {
        Test.startTest();
        System.schedule(
            'Test Scheduling PopulateTrailblazers',
            '0 0 23 * * ?',
            new PopulateTrailblazers()
        );
        Test.stopTest();

        List<AsyncApexJob> assertScheduledJobs = [
            SELECT ApexClass.Name
            FROM AsyncApexJob
            WHERE JobType = 'ScheduledApex'
        ];

        Assert.areEqual('PopulateTrailblazers', assertScheduledJobs[0].ApexClass.Name, 'PopulateTrailblazers should be scheduled.');
        Assert.areEqual(1, assertScheduledJobs.size(), 'Only PopulateTrailblazers should be in the queue.');

        List<AsyncApexJob> assertBatchJobs = [
            SELECT ApexClass.Name
            FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
        ];

        Assert.areEqual('PopulateTrailblazers', assertBatchJobs[0].ApexClass.Name, 'PopulateTrailblazers should be in the batch queue.');
        Assert.areEqual(1, assertBatchJobs.size(), 'Only PopulateTrailblazers should be in the queue.');
    }
}
