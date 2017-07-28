/*****************************************
* File: PopulateTrailblazersTest
* Author: detonation0
* Description: Unit Tests for PopulateTrailblazers.cls
******************************************/
@IsTest
private class PopulateTrailblazersTest {
    @testSetup static void setUpData() {
        Trailblazer__c newBlazer = new Trailblazer__c(
            Name = 'Some Name',
            Profile_Id__c = '005500000061jCZAAY'
        );
        insert newBlazer;
    }

    static testMethod void testPopulateTrailblazers() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new TrailheadCalloutMock());

        // Act 
        Test.startTest();
        PopulateTrailblazers pop = new PopulateTrailblazers();
        Test.stopTest();

        // Assert
        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name, Badges__c, Trails__c
            FROM Trailblazer__c
        ];

        System.assertEquals(1, assertTrailblazers.size(),
            'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        System.assertEquals('Detonation', assertTrailblazers[0].Name,
            'Name should have been upserted to Detonation. Capitalized and numbers removed.');
        System.assertEquals(45, assertTrailblazers[0].Badges__c,
            'Badges__c should have been upserted to 45');
        System.assertEquals(5, assertTrailblazers[0].Trails__c,
            'Trails__c should have been upserted to 5');
    }

    static testMethod void testSchedulePopulation() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new TrailheadCalloutMock());

        // Act
        Test.startTest();
        System.schedule('Test Scheduling PopulateTrailblazers', '0 0 23 * * ?', new PopulateTrailblazers());
        Test.stopTest();

        // Assert
        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name, Badges__c, Trails__c
            FROM Trailblazer__c
        ];

        System.assertEquals(1, assertTrailblazers.size(),
            'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        System.assertEquals('Detonation', assertTrailblazers[0].Name,
            'Name should have been upserted to Detonation. Capitalized and numbers removed.');
        System.assertEquals(45, assertTrailblazers[0].Badges__c,
            'Badges__c should have been upserted to 45');
        System.assertEquals(5, assertTrailblazers[0].Trails__c,
            'Trails__c should have been upserted to 5');
    }
}