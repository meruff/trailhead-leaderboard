/**
 * @description A class to deserialize GraphQL data into for use on the leaderboard.
 *
 * @author meruff
 *
 * @date 7/21/22
 */
public class TrailheadGraphQlData {
    public String error { get; set; }

    @AuraEnabled
    public Profile profile { get; set; }

    public class Profile {
        @AuraEnabled
        public trailheadStats trailheadStats { get; set; }

        @AuraEnabled
        public List<earnedSkills> earnedSkills { get; set; }

        @AuraEnabled
        public earnedAwards earnedAwards { get; set; }
    }

    // Rank data
    public class trailheadStats {
        public Integer completedTrailCount { get; set; }
        public Integer earnedBadgesCount { get; set; }
        public rank rank { get; set; }
        public Integer earnedPointsSum { get; set; }
    }

    public class rank {
        public String imageUrl { get; set; }
        public String title { get; set; }
    }

    // Skill data
    public class skill {
        @AuraEnabled
        public String name { get; set; }
    }

    public class earnedSkills {
        @AuraEnabled
        public Integer earnedPointsSum { get; set; }

        @AuraEnabled
        public skill skill { get; set; }
    }

    // Badge data
    public class pageInfo {
        @AuraEnabled
        public Boolean hasNextPage { get; set; }

        @AuraEnabled
        public String startCursor { get; set; }

        @AuraEnabled
        public String endCursor { get; set; }

        @AuraEnabled
        public Boolean hasPreviousPage { get; set; }
    }

    public class node {
        @AuraEnabled
        public award award { get; set; }

        @AuraEnabled
        public String earnedAt { get; set; }

        @AuraEnabled
        public String earnedPointsSum { get; set; }
    }

    public class edges {
        @AuraEnabled
        public node node { get; set; }
    }

    public class earnedAwards {
        @AuraEnabled
        public pageInfo pageInfo { get; set; }

        @AuraEnabled
        public List<edges> edges { get; set; }
    }

    public class content {
        @AuraEnabled
        public String webUrl { get; set; }
    }

    public class award {
        @AuraEnabled
        public String icon { get; set; }

        @AuraEnabled
        public String title { get; set; }

        @AuraEnabled
        public String type { get; set; }

        @AuraEnabled
        public String id { get; set; }

        @AuraEnabled
        public content content { get; set; }
    }
}
