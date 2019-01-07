/*****************************************
* File: TrailheadLeaderboardControllerTest
* Author: meruff
* Description: Unit tests for TrailheadLeaderboardControllerTest.cls
******************************************/
@IsTest
private class TrailheadLeaderboardControllerTest {
    @TestSetup
    static void setUpData() {
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

    @IsTest
    static void testAddTrailblazer() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new TrailheadCalloutMock());
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        TrailheadLeaderboardController tlb = new TrailheadLeaderboardController();
        tlb.selectedId = '005500000061jCZBBB';
        tlb.selectedName = 'Some ExistingBlazer';
        tlb.getIsMapEmpty();
        tlb.newProfileId = '005500000061jCZBBB'; // Throws existing user error
        tlb.upsertNewTrailblazer();
        tlb.newProfileId = '005500000061jCZAA'; // Throws length error
        tlb.upsertNewTrailblazer();
        tlb.newProfileId = '005500000061jCZBBB'; // Should succeed.
        tlb.upsertNewTrailblazer();
        Test.stopTest();

        // Assert
        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name, Badges__c, Trails__c, (SELECT Id FROM Badges__r)
            FROM Trailblazer__c
            WHERE Profile_Id__c = '005500000061jCZBBB'
        ];

        System.assertEquals(1, assertTrailblazers.size(),
            'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        System.assertEquals('Tony Stark', assertTrailblazers[0].Name,
            'Name should have been upserted to Detonation. Capitalized and numbers removed.');
        System.assertEquals(1, assertTrailblazers[0].Badges__c,
            'Badges__c count should have been upserted to 1');
        System.assertEquals(1, assertTrailblazers[0].Badges__r.size(),
            'Related child Badges__r count should have been upserted to 1');
        System.assertEquals(0, assertTrailblazers[0].Trails__c,
            'Trails__c should have been upserted to 0');
    }
}