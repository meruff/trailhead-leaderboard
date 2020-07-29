/**
* @author meruff
* @date 3/10/20
*
* A class to deserialize ProfileCounts data from the API into.
*/
public class ProfileCountData {
    public List<value> value { get; set; }

    public class value {
        @AuraEnabled
        public List<LearnedSkills> LearnedSkills { get; set; }

        public List<ProfileCounts> ProfileCounts { get; set; }
    }

    public class LearnedSkills {
        @AuraEnabled
        public String Label { get; set; }
        
        @AuraEnabled
        public String Name { get; set; }
        
        @AuraEnabled
		public Integer UnitTotalPerSkill { get; set; }
	}

    public class ProfileCounts {
        public Integer CompletedTrailTotal { get; set; }
        public String RankLabel { get; set; }
        public String RankImageUrl { get; set; }
        public Integer EarnedPointTotal { get; set; }
        public Integer EarnedBadgeTotal { get; set; }
    }
}