/**
 * @description Unit Tests for GetTrailblazerInfoAsync.cls
 *
 * @author meruff
 *
 * @date 5/29/20
 */
@IsTest
private class GetTrailblazerInfoAsyncTest {
    @TestSetup
    static void setUpData() {
        insert new Trailblazer__c(Name = 'mat ruff', Profile_Handle__c = 'matruff');
    }

    /**
     * @description Tests successful Trailblazer__c callout and population.
     */
    @IsTest
    static void testGetTrailblazerInfo() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulGraphQLResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        System.enqueueJob(
            new GetTrailblazerInfoAsync(
                0,
                new List<Trailblazer__c>(
                    [SELECT Profile_Handle__c, Profile_Id__c FROM Trailblazer__c]
                )
            )
        );
        Test.stopTest();

        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name,
                Badges__c,
                Trails__c,
                Superbadges__c
            FROM Trailblazer__c
        ];

        Assert.areEqual(1, assertTrailblazers.size(), 'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        Assert.areEqual(168, assertTrailblazers[0].Badges__c, '168 badges should have been created from the profile counts data.');
        Assert.areEqual(1, assertTrailblazers[0].Superbadges__c, 'One superbadge should have been created.');
        Assert.areEqual(21, assertTrailblazers[0].Trails__c, 'Trails__c should have been upserted to 21');
    }

    /**
     * @description Tests encountering an error with superbadge data population.
     */
    @IsTest
    static void testSuperbadgeDataError() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getUnsuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        Trailblazer__c testTrailblazer = new List<Trailblazer__c>(
            [SELECT Profile_Handle__c, Profile_Id__c FROM Trailblazer__c]
        )[0];

        testTrailblazer.Superbadges__c = 3;
        update testTrailblazer; // Set existing Trailblazer superbadges to 3.

        Test.startTest();
        GetTrailblazerInfoAsync.getSuperbadgeData(
            testTrailblazer,
            TrailheadHelper.fetchTrailblazerData(testTrailblazer, TrailheadHelper.SUPERBADGES_PATH)
        );
        Test.stopTest();

        Trailblazer__c assertTrailblazer = [
            SELECT Superbadges__c
            FROM Trailblazer__c
            WHERE Id = :testTrailblazer.Id
        ];

        Assert.areEqual(3, assertTrailblazer.Superbadges__c, 'Superbadges should not have been updated from a failed server callout.');
    }

    /**
     * @description Tests encountering an error with certification data population.
     */
    @IsTest
    static void testCertificationDataError() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getUnsuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        Trailblazer__c testTrailblazer = new List<Trailblazer__c>(
        [
            SELECT Profile_Handle__c,
                Profile_Id__c
            FROM Trailblazer__c
        ]
        )[0];

        testTrailblazer.Certifications__c = 5;
        update testTrailblazer; // Set existing Trailblazer certifications to 5.

        Test.startTest();
        GetTrailblazerInfoAsync.getCertificationData(
            testTrailblazer,
            TrailheadHelper.fetchTrailblazerData(testTrailblazer, TrailheadHelper.CERTIFICATIONS_PATH)
        );
        Test.stopTest();

        Trailblazer__c assertTrailblazer = [
            SELECT Certifications__c
            FROM Trailblazer__c
            WHERE Id = :testTrailblazer.Id
        ];

        Assert.areEqual(5, assertTrailblazer.Certifications__c, 'Certifications should not have been updated from a failed server callout.');
    }

    /**
     * @description Tests an error with the remote API application being down.
     */
    @IsTest
    static void testGetTrailblazerInfoApplicationError() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getApplicationDownResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        System.enqueueJob(
            new GetTrailblazerInfoAsync(
                0,
                new List<Trailblazer__c>(
                    [SELECT Profile_Handle__c, Profile_Id__c FROM Trailblazer__c]
                )
            )
        );
        Test.stopTest();

        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name,
                Badges__c,
                Trails__c,
                Superbadges__c,
                Certifications__c
            FROM Trailblazer__c
        ];

        Assert.areEqual(1, assertTrailblazers.size(), 'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        Assert.areEqual(0, assertTrailblazers[0].Badges__c, '0 badges should have been created from the profile counts data.');
        Assert.areEqual(0, assertTrailblazers[0].Superbadges__c, '0 superbadges should have been created.');
        Assert.areEqual(0, assertTrailblazers[0].Certifications__c, '0 certifications should have been created.');
        Assert.areEqual(0, assertTrailblazers[0].Trails__c, '0 Trails__c should have been created.');
    }

    @IsTest
    static void testGetTrailblazerInfoProfileData() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulTrailheadResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        System.enqueueJob(
            new GetTrailblazerInfoAsync(0, new List<Trailblazer__c>([SELECT Profile_Handle__c, Profile_Id__c FROM Trailblazer__c]))
        );
        Test.stopTest();

        List<Trailblazer__c> assertTrailblazers = [
            SELECT Name,
                Certifications__c,
                Company_Institution__c,
                Job_Title__c,
                Job_Role__c
            FROM Trailblazer__c
        ];

        Assert.areEqual(1, assertTrailblazers.size(), 'Should have created 1 Trailblazer during test set up and upserted that singular record.');
        Assert.areEqual('Mat Ruff', assertTrailblazers[0].Name, 'Name should have been upserted to capitalized \'Mat Ruff\'.');
        Assert.areEqual('ABC Co.', assertTrailblazers[0].Company_Institution__c, 'Name should have been upserted to \'ABC Co.\'.');
        Assert.areEqual('Senior Developer', assertTrailblazers[0].Job_Title__c, 'Name should have been upserted to \'Senior Developer\'.');
        Assert.areEqual('Developer', assertTrailblazers[0].Job_Role__c, 'Name should have been upserted to \'Developer\'.');
        Assert.areEqual(1, assertTrailblazers[0].Certifications__c, 'One certification should have been created.');
    }
}
