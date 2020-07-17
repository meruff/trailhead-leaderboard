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
        List<Trailblazer__c> trailblazers = TrailheadLeaderboardAuraController.populateTrailblazers('', null);
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
        List<Trailblazer__c> trailblazers = TrailheadLeaderboardAuraController.populateTrailblazers('Superbadges__c', false);
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
        res.setBody(TrailheadCalloutMock.getSuccessfulResponseData());
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
            3,
            TrailheadLeaderboardAuraController.populateTrailblazers('', null).size(),
            'Three Trailblazers should exist now.'
        );
    }

    @IsTest
    static void testGetCertificationData() {
        // Arrange
        TrailheadCalloutMock mock = new TrailheadCalloutMock();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'trailheadURL.com');
        res.setStatusCode(200);
        res.setBody(TrailheadCalloutMock.getSuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        List<CertificationData.certificationsList> certifications = TrailheadLeaderboardAuraController.getCertificationData('someId');
        Test.stopTest();

        // Assert
        System.assertEquals(1, certifications.size(), 'One Certification should have been returned.');

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
        res.setBody(TrailheadCalloutMock.getSuccessfulResponseData());
        mock.addResponse(res);

        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPage(Page.trailheadLeaderboard);

        // Act
        Test.startTest();
        List<BadgeData.EarnedAwards> badges = TrailheadLeaderboardAuraController.getBadgeData('someId', 'all', '0');
        Test.stopTest();

        // Assert
        System.assertEquals(3, badges.size(), 'Three badges should have been returned.');

        for (BadgeData.EarnedAwards award : badges) {
            System.assertNotEquals(null, award.Award.ImageUrl);
            System.assertNotEquals(null, award.Award.Label);
            System.assertNotEquals(null, award.Award.Name);
            System.assertNotEquals(null, award.LearningUrl);
            System.assertNotEquals(null, award.AwardType);
        }
    }
}