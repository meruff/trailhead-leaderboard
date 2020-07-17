/**
* @author: meruff
* @date: 2017-07-27
*
* Unit Tests for PopulateTrailblazers.cls
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
                SELECT Profile_Handle__c, Profile_Id__c 
                FROM Trailblazer__c
            ])
        );
        Test.stopTest();
    }

    @IsTest
    static void testSchedulePopulation() {
        // Act
        Test.startTest();
        String assertJobId = System.schedule('Test Scheduling PopulateTrailblazers', '0 0 23 * * ?', new PopulateTrailblazers());
        Test.stopTest();

        // Assert
        List<AsyncApexJob> assertScheduledJobs = [
            SELECT ApexClass.Name 
            FROM AsyncApexJob 
            WHERE JobType = 'ScheduledApex'
        ];
        
        System.assertEquals('PopulateTrailblazers', assertScheduledJobs[0].ApexClass.Name, 
            'PopulateTrailblazers should be scheduled.');
        System.assertEquals(1, assertScheduledJobs.size(), 
            'Only PopulateTrailblazers should be in the queue.');
        

        List<AsyncApexJob> assertBatchJobs = [
            SELECT ApexClass.Name 
            FROM AsyncApexJob 
            WHERE JobType = 'BatchApex'
        ];

        System.assertEquals('PopulateTrailblazers', assertBatchJobs[0].ApexClass.Name, 
            'PopulateTrailblazers should be in the batch queue.');
        System.assertEquals(1, assertBatchJobs.size(), 
            'Only PopulateTrailblazers should be in the queue.');
    }
}