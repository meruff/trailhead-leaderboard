/**
* @author meruff
* @date 5/29/20
*
* Unit Tests for GetTrailblazerInfoAsyncTest
*/
@IsTest
private class GetTrailblazerInfoAsyncTest {
    @TestSetup
    static void setUpData() {
        insert new Trailblazer__c(
                Name = 'mat ruff',
                Profile_Handle__c = 'matruff'
        );
    }

    @IsTest
    static void testGetTrailblazerInfo() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        // Act 
        Test.startTest();
        System.enqueueJob(
            new GetTrailblazerInfoAsync(
                0, 
                new List<Trailblazer__c>([
                    SELECT Profile_Handle__c, Profile_Id__c 
                    FROM Trailblazer__c
                ])
            )
        );
        Test.stopTest();

        // Assert
        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name, Badges__c, Trails__c, Superbadges__c, Certifications__c
            FROM Trailblazer__c
        ];

        System.assertEquals(1, assertTrailblazers.size(),
            'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        System.assertEquals('Mat Ruff', assertTrailblazers[0].Name,
            'Name should have been upserted to capitalized \'Mat Ruff\'.');
        System.assertEquals(107, assertTrailblazers[0].Badges__c,
            '107 badges should have been created from the profile counts data.');
        System.assertEquals(1, assertTrailblazers[0].Superbadges__c,
            'One superbadge should have been created.');
        System.assertEquals(1, assertTrailblazers[0].Certifications__c,
            'One certification should have been created.');
        System.assertEquals(6, assertTrailblazers[0].Trails__c,
            'Trails__c should have been upserted to 6');
    }

    @IsTest
    static void testGetTrailblazerInfoNoHandle() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        Trailblazer__c testTrailblazer = new List<Trailblazer__c>([
            SELECT Profile_Handle__c, Profile_Id__c 
            FROM Trailblazer__c
        ])[0];

        testTrailblazer.Profile_Handle__c = null;
        testTrailblazer.Profile_Id__c = '005J0000008vX9z';

        // Act 
        Test.startTest();
        System.enqueueJob(
            new GetTrailblazerInfoAsync(
                0, 
                new List<Trailblazer__c>{testTrailblazer}
            )
        );
        Test.stopTest();

        // Assert
        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name, Badges__c, Trails__c, Superbadges__c, Certifications__c
            FROM Trailblazer__c
        ];

        System.assertEquals(1, assertTrailblazers.size(),
            'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        System.assertEquals('Mat Ruff', assertTrailblazers[0].Name,
            'Name should have been upserted to capitalized \'Mat Ruff\'.');
        System.assertEquals(107, assertTrailblazers[0].Badges__c,
            '107 badges should have been created from the profile counts data.');
        System.assertEquals(1, assertTrailblazers[0].Superbadges__c,
            'One superbadge should have been created.');
        System.assertEquals(1, assertTrailblazers[0].Certifications__c,
            'One certification should have been created.');
        System.assertEquals(6, assertTrailblazers[0].Trails__c,
            'Trails__c should have been upserted to 6');
    }
}