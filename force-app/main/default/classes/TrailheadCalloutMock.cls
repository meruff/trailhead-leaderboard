/**
* @description Mock callout class for PopulateTrailblazers.cls
 *
* @author: meruff
 *
* @date: 2017-07-27
*/
@IsTest
public class TrailheadCalloutMock implements HttpCalloutMock {
    // TODO:
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

    public static String getSuccessfulTrailheadResponse() {
        return '' +
            '{' +
                '"profileUser": {' +
                    '"AboutMe": null,' +
                    '"FirstName": "Mat",' +
                    '"StateCode": "AZ",' +
                    '"Title": "Senior Developer",' +
                    '"Relationship_To_Salesforce__c": "Partner",' +
                    '"TBID_Role__c": "Developer",' +
                    '"CompanyName": "ABC Co.",' +
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

    public static String getSuccessfulGraphQLResponse() {
        return '{\n' +
            '    "profile": {\n' +
            '        "__typename": "PublicProfile",\n' +
            '        "trailheadStats": {\n' +
            '            "__typename": "TrailheadProfileStats",\n' +
            '            "earnedPointsSum": 167050,\n' +
            '            "earnedBadgesCount": 168,\n' +
            '            "completedTrailCount": 21,\n' +
            '            "rank": {\n' +
            '                "__typename": "TrailheadRank",\n' +
            '                "title": "Ranger",\n' +
            '                "requiredPointsSum": 50000,\n' +
            '                "requiredBadgesCount": 100,\n' +
            '                "imageUrl": "https://trailhead.salesforce.com/assets/ranks/ranger-c18ceeaa67bb14bf214edd30a4343f40e766012a0dbda79b5c758209acaeb334.png"\n' +
            '            },\n' +
            '            "nextRank": null\n' +
            '        },\n' +
            '        "earnedSkills": [\n' +
            '            {\n' +
            '                "__typename": "EarnedSkill",\n' +
            '                "earnedPointsSum": 5724,\n' +
            '                "id": "705cc0ea-414f-4bb7-a097-6d90452888fb",\n' +
            '                "itemProgressEntryCount": 51,\n' +
            '                "skill": {\n' +
            '                    "__typename": "Skill",\n' +
            '                    "apiName": "crm",\n' +
            '                    "id": "0246ac31-20f5-9502-7e50-097c19144f62",\n' +
            '                    "name": "CRM"\n' +
            '                }\n' +
            '            },\n' +
            '            {\n' +
            '                "__typename": "EarnedSkill",\n' +
            '                "earnedPointsSum": 1200,\n' +
            '                "id": "22bb4e4e-a83f-4208-a3c9-7c0a9e5fd86b",\n' +
            '                "itemProgressEntryCount": 4,\n' +
            '                "skill": {\n' +
            '                    "__typename": "Skill",\n' +
            '                    "apiName": "chatter",\n' +
            '                    "id": "0246ac31-20f5-9515-92dc-618d160498da",\n' +
            '                    "name": "Chatter"\n' +
            '                }\n' +
            '            }\n' +
            '        ],\n' +
            '        "earnedAwards": {\n' +
            '            "edges": [\n' +
            '                {\n' +
            '                    "node": {\n' +
            '                        "__typename": "EarnedAwardBase",\n' +
            '                        "id": "029ad362-ad42-2964-ce13-e9a8c6959b39",\n' +
            '                        "award": {\n' +
            '                            "__typename": "Award",\n' +
            '                            "id": "0299a056-d802-aeeb-0499-f8530d1f8b28",\n' +
            '                            "title": "Administrator Certification Maintenance (Spring \'22)",\n' +
            '                            "type": "MODULE",\n' +
            '                            "icon": "https://res.cloudinary.com/hy4kyit2a/f_auto,fl_lossy,q_70/learn/modules/administrator-certification-maintenance-spring-22/adeda0c8102c2b18988e32b86754e4b2_badge.png",\n' +
            '                            "content": {\n' +
            '                                "__typename": "Content",\n' +
            '                                "webUrl": "https://trailhead.salesforce.com/content/learn/modules/administrator-certification-maintenance-spring-22",\n' +
            '                                "description": "Review updates to Salesforce to maintain your Administrator certification."\n' +
            '                            }\n' +
            '                        },\n' +
            '                        "earnedAt": "",\n' +
            '                        "earnedPointsSum": ""\n' +
            '                    }\n' +
            '                },\n' +
            '                {\n' +
            '                    "node": {\n' +
            '                        "__typename": "EarnedAwardBase",\n' +
            '                        "id": "02920528-af65-0c0e-7b4c-ae93be02cd5e",\n' +
            '                        "award": {\n' +
            '                            "__typename": "Award",\n' +
            '                            "id": "028fb9fe-34cc-b36d-0e3c-b22d280b8434",\n' +
            '                            "title": "Platform Developer I Certification Maintenance (Winter \'22)",\n' +
            '                            "type": "MODULE",\n' +
            '                            "icon": "https://res.cloudinary.com/hy4kyit2a/f_auto,fl_lossy,q_70/learn/modules/platform-developer-i-certification-maintenance-winter-22/9f70c0e3f1affdc98ef7bfe9bd2211e3_badge.png",\n' +
            '                            "content": {\n' +
            '                                "__typename": "Content",\n' +
            '                                "webUrl": "https://trailhead.salesforce.com/content/learn/modules/platform-developer-i-certification-maintenance-winter-22",\n' +
            '                                "description": "Review updates to Salesforce to maintain your Platform Developer I Certification."\n' +
            '                            }\n' +
            '                        },\n' +
            '                        "earnedAt": "",\n' +
            '                        "earnedPointsSum": ""\n' +
            '                    }\n' +
            '                },\n' +
            '               {\n' +
            '                    "node": {\n' +
            '                        "__typename": "EarnedAwardBase",\n' +
            '                        "id": "0267597c-4bfd-9314-cad5-4b8b43d4cd63",\n' +
            '                        "award": {\n' +
            '                            "__typename": "Award",\n' +
            '                            "id": "0265dbe8-1e2f-4ce8-3cfa-726c28e850ad",\n' +
            '                            "title": "Lightning Web Components Specialist",\n' +
            '                            "type": "SUPERBADGE",\n' +
            '                            "icon": "https://res.cloudinary.com/hy4kyit2a/f_auto,fl_lossy,q_70/learn/superbadges/superbadge_lwc_specialist/0b422a78e019b08aa699dc76b48cc7e8_badge.png",\n' +
            '                            "content": {\n' +
            '                                "__typename": "Content",\n' +
            '                                "webUrl": "https://trailhead.salesforce.com/content/learn/superbadges/superbadge_lwc_specialist",\n' +
            '                                "description": "Showcase your mastery of Lightning Web Components by building a sophisticated app."\n' +
            '                            }\n' +
            '                        },\n' +
            '                        "earnedAt": "",\n' +
            '                        "earnedPointsSum": ""\n' +
            '                    }\n' +
            '                }' +
            '            ],\n' +
            '            "pageInfo": {\n' +
            '                "__typename": "PageInfo",\n' +
            '                "endCursor": "eyJzIjoiMDI4ODFlZjYtM2I5MS1lN...DItOGZkMWJiNWY1OWRkIiwicHAiOjMsInBuIjoxfQ",\n' +
            '                "hasNextPage": true,\n' +
            '                "startCursor": "eyJzIjoiMDI5YWQzNjItYWQ0Mi0...WNlMTMtZTlhOGU5YjM5IiwicHAiOjMsInBuIjoxfQ",\n' +
            '                "hasPreviousPage": false\n' +
            '            }\n' +
            '        }\n' +
            '    }\n' +
            '}';
    }

    public static String getUnsuccessfulResponseData() {
        return '{"error":"No response from Trailhead"}';
    }

    public static String getApplicationDownResponseData() {
        return 'Application error';
    }
}