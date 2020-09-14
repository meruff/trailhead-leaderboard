/**
* @author meruff
* @date 3/9/20
*
* A class to deserialize Trailhead Badge data from the API into.
*/
public class BadgeData {
    public String error { get; set; }

    @AuraEnabled
    public List<value> value { get; set; }

    public class value {
        @AuraEnabled
        public List<EarnedAwards> EarnedAwards { get; set; }
    }

    public class EarnedAwards {
        @AuraEnabled
        public String AwardType { get; set; }

        @AuraEnabled
        public String LearningUrl { get; set; }

        @AuraEnabled
        public Award Award { get; set; }
    }

    public class Award {
        @AuraEnabled
        public String Name { get; set; }

        @AuraEnabled
        public String Label { get; set; }

        @AuraEnabled
        public String ImageUrl { get; set; }
    }
}