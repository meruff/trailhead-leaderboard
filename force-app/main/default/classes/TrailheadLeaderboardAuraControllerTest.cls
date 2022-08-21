/**
 * @description Unit Tests for TrailheadLeaderboardAuraController.cls
 *
 * @author meruff
 *
 * @date 2019-06-28
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

    @IsTest
    static void testPopulateTrailblazers() {
        // Act
        Test.startTest();
        List<Trailblazer__c> trailblazers =
            TrailheadLeaderboardAuraController.populateTrailblazers('', null, null, null);
        Test.stopTest();

        // Assert
        System.assertEquals(2, trailblazers.size());
        System.assertEquals(
            'Another Trailblazer',
            trailblazers[0].Name,
            'Sort should default to Points, making Another Trailblazer the first on the list.'
        );
    }

    @IsTest
    static void testPopulateTrailblazersSort() {
        // Act
        Test.startTest();
        List<Trailblazer__c> trailblazers =
            TrailheadLeaderboardAuraController.populateTrailblazers('Superbadges__c', false, null, null);
        Test.stopTest();

        // Assert
        System.assertEquals(2, trailblazers.size());
        System.assertEquals(
            'Some ExistingBlazer',
            trailblazers[0].Name,
            'Sort should be by Superbadges Ascending, making the lowest number, Some ExistingBlazer, the first person ' +
            'on the list.'
        );
    }

    @IsTest
    static void testCreateNewTrailblazer() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulTrailheadResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        String resultString = TrailheadLeaderboardAuraController.createTrailblazer('someId');
        Test.stopTest();

        // Assert
        System.assertEquals('success', resultString);
        System.assertEquals(
            2,
            TrailheadLeaderboardAuraController.populateTrailblazers('', null, null, null).size(),
            'Two Trailblazers should exist now.'
        );
    }

    @IsTest
    static void testCreateNewTrailblazerWithError() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getUnsuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        String resultString = TrailheadLeaderboardAuraController.createTrailblazer('someId');
        Test.stopTest();

        // Assert
        System.assertEquals(0, [SELECT Id FROM Trailblazer__c WHERE Profile_Handle__c = :'someId'].size(),
            'Test Trailblazer should not have been created.');
        System.assertNotEquals('success', resultString);
        System.assertEquals(2,
            TrailheadLeaderboardAuraController.populateTrailblazers('', null, null, null).size(),
            'Only the two Trailblazers should exist, \'someId\' should not have been created.'
        );
    }

    @IsTest
    static void testGetSkillData() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulGraphQLResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        List<TrailheadGraphQlData.earnedSkills> skills =
            TrailheadLeaderboardAuraController.getSkillData('someId');
        Test.stopTest();

        // Assert
        System.assertEquals(2, skills.size(), 'Two skills should have been returned.');

        for (TrailheadGraphQlData.earnedSkills skill : skills) {
            System.assertNotEquals(null, skill.skill.name);
            System.assertNotEquals(null, skill.earnedPointsSum);
        }
    }

    @IsTest
    static void testGetCertificationData() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulTrailheadResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        List<CertificationData.certificationsList> certifications =
            TrailheadLeaderboardAuraController.getCertificationData('someId');
        Test.stopTest();

        // Assert
        System.assertEquals(1, certifications.size(), 'One certification should have been returned.');

        for (CertificationData.certificationsList certification : certifications) {
            System.assertEquals(null, certification.dateExpired);
            System.assertNotEquals(null, certification.dateCompleted);
            System.assertNotEquals(null, certification.description);
            System.assertNotEquals(null, certification.certificationUrl);
            System.assertNotEquals(null, certification.certificationStatus);
            System.assertNotEquals(null, certification.title);
            System.assertNotEquals(null, certification.certificationImageUrl);
        }
    }

    @IsTest
    static void testGetBadgeData() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulGraphQLResponse());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        TrailheadGraphQlData.earnedAwards earnedAwards = TrailheadLeaderboardAuraController.getBadgeData(
            'someId',
            'all',
            16,
            'someAfterHash'
        );
        Test.stopTest();

        // Assert
        System.assertEquals(3, earnedAwards.edges.size(),
            'Three badges should have been returned.');
        System.assertNotEquals(null, earnedAwards.pageInfo,
            'pageInfo should have been returned.');
        System.assertNotEquals(null, earnedAwards.pageInfo.hasNextPage,
            'hasNextPage should have been returned.');
        System.assertNotEquals(null, earnedAwards.pageInfo.startCursor,
            'startCursor should have been returned.');
        System.assertNotEquals(null, earnedAwards.pageInfo.endCursor,
            'endCursor should have been returned.');
        System.assertNotEquals(null, earnedAwards.pageInfo.hasPreviousPage,
            'hasPreviousPage should have been returned.');

        for (TrailheadGraphQlData.edges award : earnedAwards.edges) {
            System.assertNotEquals(null, award.node.award.content.webUrl);
            System.assertNotEquals(null, award.node.award.title);
            System.assertNotEquals(null, award.node.award.icon);
            System.assertNotEquals(null, award.node.award.type);
        }
    }

    @IsTest
    static void testGetBadgeDataNoAPIResponse() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getUnsuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        TrailheadGraphQlData.earnedAwards earnedAwards = TrailheadLeaderboardAuraController.getBadgeData(
            'someId',
            'all',
            null,
            null
        );
        Test.stopTest();

        // Assert
        System.assertEquals(null, earnedAwards,
            'No badges should have been returned as the API failed to respond with data.');
    }
}