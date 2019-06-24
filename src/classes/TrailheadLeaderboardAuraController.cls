/**
* @author Mathew Ruff, Sierra-Cedar
* @date 2019-06-17
*
* Apex controller logic for LWC leaderboard.
*/
public class TrailheadLeaderboardAuraController {
    @AuraEnabled(Cacheable=true)
    public static List<Trailblazer__c> populateTrailblazers() {
        return [
            SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Id__c,
                Profile_Link__c, Rank__c, Profile_Photo__c, Job_Role__c, Job_Title__c, Company_Institution__c, (
                SELECT Title__c, Icon_Link__c, Type__c, Points__c, Date_Earned__c, Path__c
                FROM Badges__r
                ORDER BY Title__c ASC
            )
            FROM Trailblazer__c
            ORDER BY Points__c DESC
        ];
    }
}