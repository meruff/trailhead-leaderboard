/*****************************************
* File: TrailheadLeaderboardControllerTest
* Author: detonation0
* Description: Unit tests for TrailheadLeaderboardControllerTest.cls
******************************************/
@isTest
private class TrailheadLeaderboardControllerTest {
    @testSetup static void setUpData() {
        Trailblazer__c newBlazer = new Trailblazer__c(
            Name = 'Some ExistingBlazer',
            Profile_Id__c = '005500000061jCZBBY',
            Points__c = 450,
            Trails__c = 8,
            Trailblazer_Since__c = 'September 17th, 2000',
            Profile_Photo__c = 'https://trailhead.com/photourl'
        );
        insert newBlazer;
    }

    static testMethod void testAddTrailblazer() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new TrailheadCalloutMock());
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        TrailheadLeaderboardController tlb = new TrailheadLeaderboardController();
        tlb.newBlazer.Profile_Id__c = '005500000061jCZBBY'; // Throws existing user error
        tlb.upsertNewTrailblazer();
        tlb.newBlazer.Profile_Id__c = '005500000061jCZAA'; // Throws length error
        tlb.upsertNewTrailblazer();
        tlb.newBlazer.Profile_Id__c = '005500000061jCZAAY'; // Should succeed.
        tlb.upsertNewTrailblazer();
        Test.stopTest();

        // Assert
        Trailblazer__c assertTrailblazer = [
            SELECT Name, Badges__c, Trails__c
            FROM Trailblazer__c
            WHERE Profile_Id__c = '005500000061jCZAAY'
        ];

        System.assertEquals('Detonation', assertTrailblazer.Name,
            'Name should have been upserted to Detonation. Capitalized and numbers removed.');
        System.assertEquals(45, assertTrailblazer.Badges__c,
            'Badges__c should have been upserted to 45');
        System.assertEquals(5, assertTrailblazer.Trails__c,
            'Trails__c should have been upserted to 5');
    }
}