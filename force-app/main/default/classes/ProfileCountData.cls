/**
* @author meruff
* @date 3/10/20
*
*
*/
public class ProfileCountData {
    public List<value> value { get; set; }
    public class value {
        public List<ProfileCounts> ProfileCounts { get; set; }
        public List<LearnedSkills> LearnedSkills { get; set; }
        public String Id { get; set; }
    }

    public class ProfileCounts {
        public Integer PointTotalForNextRank { get; set; }
        public Integer BadgeTotalForNextRank { get; set; }
        public Integer CompletedTrailTotal { get; set; }
        public String RankLabel { get; set; }
        public String Id { get; set; }
        public String RankImageUrl { get; set; }
        public Integer EarnedPointTotal { get; set; }
        public Integer EarnedBadgeTotal { get; set; }
        public String NextRankImageUrl { get; set; }
    }

    public class LearnedSkills {
        public Integer UnitTotalPerSkill { get; set; }
        public String Label { get; set; }
        public String Name { get; set; }
        public String Id { get; set; }
    }
}