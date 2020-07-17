/**
* @author: meruff
* @date: 2017-07-27
*
* Mock callout class for PopulateTrailblazers.cls
*/
@IsTest
public class TrailheadCalloutMock implements HttpCalloutMock {
    List<HttpResponse> responses = new List<HttpResponse>();

    public void addResponse(HttpResponse response) {
        responses.add(response);
    }

    public HttpResponse respond(HttpRequest req) {
        if (responses.size() > 1) {
            return responses.remove(0);
        } else {
            return responses[0];
        }
    }

    public static String getSuccessfulResponseData() {
        return '' +
            '{' +
                '"value":[' +
                    '{' +
                        '"ProfileCounts": [' +
                            '{' +
                                '"Id":"2887eeca-39ea-4608-9714-eba668e9532e",' +
                                '"RankLabel":"ranger",' +
                                '"RankImageUrl":"https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png",' +
                                '"NextRankImageUrl":null,' +
                                '"EarnedPointTotal":108775,' +
                                '"EarnedBadgeTotal":107,' +
                                '"CompletedTrailTotal":6,' +
                                '"PointTotalForNextRank":0,' +
                                '"BadgeTotalForNextRank":0' +
                            '}' +
                        '],' +
                        '"EarnedAwards": [' +
                            '{' +
                                '"LearningUrl": "https://trailhead.salesforce.com/content/learn/modules/platform-developer-i-certification-maintenance-winter-20",' +
                                '"AwardType": "Module",'+
                                '"Award": {' +
                                    '"Name": "platform-developer-i-certification-maintenance-winter-20",' +
                                    '"Label": "Platform Developer I Certification Maintenance (Winter \'20)",' +
                                    '"ImageUrl": "https://res.cloudinary.com/hy4kyit2a/f_auto,fl_lossy,q_70/learn/modules/platform-developer-i-certification-maintenance-winter-20/55fefed61ec894ec7ba4ae62f8b997cc_badge.png"' +
                                '}' +
                            '},' +
                            '{' +
                                '"LearningUrl": "https://trailhead.salesforce.com/content/learn/modules/administrator-certification-maintenance-winter-20",' +
                                '"AwardType": "Module",' +
                                '"Award": {' +
                                    '"Name": "administrator-certification-maintenance-winter-20",' +
                                    '"Label": "Administrator Certification Maintenance (Winter \'20)",' +
                                    '"ImageUrl": "https://res.cloudinary.com/hy4kyit2a/f_auto,fl_lossy,q_70/learn/modules/administrator-certification-maintenance-winter-20/9a8789a05b9606bc29fed35750445fa2_badge.png"' +
                                '}' +
                            '},' +
                            '{' +
                                '"LearningUrl": "https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_lwc_specialist",' +
                                '"AwardType": "Superbadge",' +
                                '"Award": {' +
                                    '"Name": "superbadge_lwc_specialist",' +
                                    '"Label": "Lightning Web Components Specialist",' +
                                    '"ImageUrl": "https://res.cloudinary.com/hy4kyit2a/f_auto,fl_lossy,q_70/learn/superbadges/superbadge_lwc_specialist/78066c22238610a42feb2565c4553d24_badge.png"' +
                                '}' +
                            '}' +
                        ']' +
                    '}' +
                '],' +
                '"profileUser": {' +
                    '"AboutMe": null,' +
                    '"FirstName": "Mat",' +
                    '"StateCode": "AZ",' +
                    '"Title": "Senior Consultant/Developer",' +
                    '"Relationship_To_Salesforce__c": "Partner",' +
                    '"TBID_Role__c": "Developer",' +
                    '"CompanyName": "Sierra-Cedar",' +
                    '"TrailblazerId__c": "matruff",' +
                    '"LastName": "Ruff",' +
                    '"Id": "0051I000004UgTlQAK"' +
                '},' +
                '"profilePhotoUrl": "https://trailblazer.me/profilephoto/7291I000000Jm2C/M",' +
                '"certificationsList":[' +
                    '{' +
                        '"visibleToYouDescription":null,' +
                        '"title":"Salesforce Certified Administrator",' +
                        '"description":"Certified Administrators are Salesforce pros who are always looking for ways to help their companies get even more out of the Salesforce Platform through additional features and capabilities.",' +
                        '"dateExpired":null,' +
                        '"dateCompleted":"2013-06-13",' +
                        '"certificationUrl":"https://trailhead.salesforce.com/credentials/administrator",' +
                        '"certificationStatus":"ACTIVE",' +
                        '"certificationImageUrl":"https://drm--c.na114.content.force.com/servlet/servlet.ImageServer?id=0153k00000AH6hb&oid=00DF0000000gZsu&lastMod=1571903578000"' +
                    '}' +
                ']' +
            '}';
    }
}