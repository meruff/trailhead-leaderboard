/**
 * @description Unit Tests for TrailheadLeaderboardAuraController.cls
 *
 * @author meruff
 *
 * @date 6/28/19
 */
@IsTest
private class TrailheadLeaderboardAuraControllerTest {
    @TestSetup
    static void setUpTest() {
        insert new List<Trailblazer__c>{
            new Trailblazer__c(
                Name = 'Some ExistingBlazer',
                Profile_Handle__c = 'existingBoye',
                Points__c = 450,
                Trails__c = 8,
                Rank__c = 'Adventurer',
                Profile_Photo__c = 'https://trailhead.com/photourl'
            ),
            new Trailblazer__c(
                Name = 'Another Trailblazer',
                Profile_Handle__c = 'anotherBlazer',
                Points__c = 1337,
                Trails__c = 3,
                Rank__c = 'Ranger',
                Superbadges__c = 10,
                Profile_Photo__c = 'https://trailhead.com/photourl'
            )
        };
    }

    /**
     * @description Tests the default population of Trailblazer__c records.
     */
    @IsTest
    static void testPopulateTrailblazers() {
        Test.startTest();
        List<Trailblazer__c> trailblazers = TrailheadLeaderboardAuraController.populateTrailblazers(
            new TrailheadLeaderboardAuraController.TrailblazerQueryConfig()
        );
        Test.stopTest();

        Assert.areEqual(2, trailblazers.size());
        Assert.areEqual('Another Trailblazer', trailblazers[0].Name, 'Sort should default to Points, making Another Trailblazer the first on the list.');
    }

    /**
     * @description Tests the population of Trailblazer__c records sorted by Superbadges.
     */
    @IsTest
    static void testPopulateTrailblazersSort() {
        Test.startTest();
        TrailheadLeaderboardAuraController.TrailblazerQueryConfig config = new TrailheadLeaderboardAuraController.TrailblazerQueryConfig();
        config.sortBy = 'Superbadges__c';
        List<Trailblazer__c> trailblazers = TrailheadLeaderboardAuraController.populateTrailblazers(config);
        Test.stopTest();

        Assert.areEqual(2, trailblazers.size());
        Assert.areEqual('Some ExistingBlazer', trailblazers[0].Name, 'Sort should be by Superbadges Ascending, making the lowest number, Some ExistingBlazer, the first person ' + 'on the list.');
    }

    /**
     * @description Tests creating a new Trailblazer__c record.
     */
    @IsTest
    static void testCreateNewTrailblazer() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getFullCalloutResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        Test.startTest();
        String resultString = TrailheadLeaderboardAuraController.createTrailblazer('someId');
        Test.stopTest();

        Assert.areEqual(TrailheadHelper.SUCCESS, resultString, 'Trailblazer should have been created without error.');
        Assert.areEqual(3, TrailheadLeaderboardAuraController.populateTrailblazers(new TrailheadLeaderboardAuraController.TrailblazerQueryConfig()).size(), 'Three Trailblazers should exist now.');
    }

    /**
     * @description Tests creating a new Trailblazer__c record with an error.
     */
    @IsTest
    static void testCreateNewTrailblazerWithError() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getUnsuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        Test.startTest();
        String resultString = TrailheadLeaderboardAuraController.createTrailblazer('someId');
        Test.stopTest();

        Assert.areEqual(0, [SELECT Id FROM Trailblazer__c WHERE Profile_Handle__c = :'someId'].size(), 'Test Trailblazer should not have been created.');
        Assert.areNotEqual('success', resultString);
        Assert.areEqual(2, TrailheadLeaderboardAuraController.populateTrailblazers(new TrailheadLeaderboardAuraController.TrailblazerQueryConfig()).size(), 'Only the two Trailblazers should exist, \'someId\' should not have been created.');
    }

    /**
     * @description Tests getting skill data.
     */
    @IsTest
    static void testGetSkillData() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulGraphQLResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        Test.startTest();
        List<TrailheadGraphQlData.EarnedSkills> skills = TrailheadLeaderboardAuraController.getSkillData('someId');
        Test.stopTest();

        Assert.areEqual(2, skills.size(), 'Two skills should have been returned.');

        for (TrailheadGraphQlData.EarnedSkills skill : skills) {
            Assert.isNotNull(skill.skill.name);
            Assert.isNotNull(skill.earnedPointsSum);
        }
    }

    /**
     * @description Tests getting certification data.
     */
    @IsTest
    static void testGetCertificationData() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulTrailheadResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        Test.startTest();
        List<CertificationData.CertificationsList> certifications = TrailheadLeaderboardAuraController.getCertificationData('someId');
        Test.stopTest();

        Assert.areEqual(1, certifications.size(), 'One certification should have been returned.');

        for (CertificationData.CertificationsList certification : certifications) {
            Assert.isNull(certification.dateExpired);
            Assert.isNotNull(certification.dateCompleted);
            Assert.isNotNull(certification.description);
            Assert.isNotNull(certification.certificationUrl);
            Assert.isNotNull(certification.certificationStatus);
            Assert.isNotNull(certification.title);
            Assert.isNotNull(certification.certificationImageUrl);
        }
    }

    /**
     * @description Tests getting badge data.
     */
    @IsTest
    static void testGetBadgeData() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulGraphQLResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        Test.startTest();
        TrailheadGraphQlData.EarnedAwards earnedAwards = TrailheadLeaderboardAuraController.getBadgeData(
            'someId',
            'all',
            16,
            'someAfterHash'
        );
        Test.stopTest();

        Assert.areEqual(3, earnedAwards.edges.size(), 'Three badges should have been returned.');
        Assert.isNotNull(earnedAwards.pageInfo, 'pageInfo should have been returned.');
        Assert.isNotNull(earnedAwards.pageInfo.hasNextPage, 'hasNextPage should have been returned.');
        Assert.isNotNull(earnedAwards.pageInfo.startCursor, 'startCursor should have been returned.');
        Assert.isNotNull(earnedAwards.pageInfo.endCursor, 'endCursor should have been returned.');
        Assert.isNotNull(earnedAwards.pageInfo.hasPreviousPage, 'hasPreviousPage should have been returned.');

        for (TrailheadGraphQlData.Edges award : earnedAwards.edges) {
            Assert.isNotNull(award.node.award.content.webUrl);
            Assert.isNotNull(award.node.award.title);
            Assert.isNotNull(award.node.award.icon);
            Assert.isNotNull(award.node.award.type);
        }
    }

    /**
     * @description Tests getting badge data with a null response.
     */
    @IsTest
    static void testGetBadgeDataNoAPIResponse() {
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getUnsuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        Test.startTest();
        TrailheadGraphQlData.EarnedAwards earnedAwards = TrailheadLeaderboardAuraController.getBadgeData(
            'someId',
            'all',
            null,
            null
        );
        Test.stopTest();

        Assert.isNull(earnedAwards, 'No badges should have been returned as the API failed to respond with data.');
    }
}
