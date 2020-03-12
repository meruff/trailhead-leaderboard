/**
* @author: meruff
* @date: 2017-07-27
*
* Unit Tests for PopulateTrailblazers.cls
*/
@IsTest
private class PopulateTrailblazersTest {
    @TestSetup
    static void setUpData() {
        Trailblazer__c newBlazer = new Trailblazer__c(
            Name = 'mat ruff',
            Profile_Handle__c = 'matruff'
        );
        insert newBlazer;
    }

    @IsTest
    static void testPopulateTrailblazers() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulProfileDataBody());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        // Act 
        Test.startTest();
        PopulateTrailblazers pop = new PopulateTrailblazers();
        Test.stopTest();

        // Assert
        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name, Badges__c, Trails__c, (SELECT Id FROM Badges__r)
            FROM Trailblazer__c
        ];

        System.assertEquals(1, assertTrailblazers.size(),
            'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        System.assertEquals('Mat Ruff', assertTrailblazers[0].Name,
            'Name should have been upserted to Detonation. Capitalized and numbers removed.');
        System.assertEquals(6, assertTrailblazers[0].Trails__c,
            'Trails__c should have been upserted to 6');
    }

    @IsTest
    static void testSchedulePopulation() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'forwardToUrl.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulProfileDataBody());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        // Act
        Test.startTest();
        System.schedule('Test Scheduling PopulateTrailblazers', '0 0 23 * * ?', new PopulateTrailblazers());
        Test.stopTest();

        // Assert
        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name, Badges__c, Trails__c, (SELECT Id FROM Badges__r)
            FROM Trailblazer__c
        ];

        System.assertEquals(1, assertTrailblazers.size(),
            'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        System.assertEquals('Mat Ruff', assertTrailblazers[0].Name,
            'Name should have been upserted to Detonation. Capitalized and numbers removed.');
        System.assertEquals(6, assertTrailblazers[0].Trails__c,
            'Trails__c should have been upserted to 6');
    }
}