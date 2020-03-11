/**
* @author meruff
* @date 2019-06-28
*
* Unit Tests for TrailheadLeaderboardAuraController.cls
*/
@IsTest
private class TrailheadLeaderboardAuraControllerTest {
    @TestSetup
    static void setUpTest() {
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
    static void testPopulateTrailblazers() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res1 = new HttpResponse();
        res1.setHeader('Content-Type', 'application/json');
        res1.setHeader('Location', 'forwardToUrl.com');
        res1.setStatusCode(301);
        mock.addResponse(res1);

        HttpResponse res2 = new HttpResponse();
        res2.setHeader('Content-Type', 'application/json');
        res2.setStatusCode(200);
        res2.setBody(TrailheadCalloutMock.getSuccessfulResponseBody());
        mock.addResponse(res2);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act 
        Test.startTest();
        List<Trailblazer__c> trailblazers = TrailheadLeaderboardAuraController.populateTrailblazers();
        Test.stopTest();

        // Assert
        System.assertEquals(1, trailblazers.size());
        System.assertEquals('Some ExistingBlazer', trailblazers[0].Name);
    }

    @IsTest
    static void testCreateNewTrailblazer() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res1 = new HttpResponse();
        res1.setHeader('Content-Type', 'application/json');
        res1.setHeader('Location', 'forwardToUrl.com');
        res1.setStatusCode(301);
        mock.addResponse(res1);

        HttpResponse res2 = new HttpResponse();
        res2.setHeader('Content-Type', 'application/json');
        res2.setStatusCode(200);
        res2.setBody(TrailheadCalloutMock.getSuccessfulResponseBody());
        mock.addResponse(res2);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        String resultString = TrailheadLeaderboardAuraController.createTrailblazer('someId');
        Test.stopTest();

        // Assert
        System.assertEquals('success', resultString);
        System.assertEquals(2, TrailheadLeaderboardAuraController.populateTrailblazers().size(), 'Two Trailblazers should exist now.');
    }

    @IsTest
    static void testCreateNewTrailblazerFail() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res1 = new HttpResponse();
        res1.setHeader('Content-Type', 'application/json');
        res1.setHeader('Location', 'forwardToUrl.com');
        res1.setStatusCode(301);
        mock.addResponse(res1);

        HttpResponse res2 = new HttpResponse();
        res2.setHeader('Content-Type', 'application/json');
        res2.setStatusCode(200);
        res2.setBody(TrailheadCalloutMock.getErrorResponseBody());
        mock.addResponse(res2);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        String resultString = TrailheadLeaderboardAuraController.createTrailblazer('someId');
        Test.stopTest();

        // Assert
        System.assertNotEquals('success', resultString);
        System.assertEquals(1, TrailheadLeaderboardAuraController.populateTrailblazers().size(), 'After failing, only the 1 Trailblazer should exist.');
    }
}