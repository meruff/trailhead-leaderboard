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
        public String typename { get; set; }

        @AuraEnabled
        public TrailheadStats trailheadStats { get; set; }

        @AuraEnabled
        public List<EarnedSkills> earnedSkills { get; set; }

        @AuraEnabled
        public EarnedAwards earnedAwards { get; set; }
    }

    // Rank data
    public class TrailheadStats {
        public Integer completedTrailCount { get; set; }
        public Integer earnedBadgesCount { get; set; }
        public Rank rank { get; set; }
        public Integer earnedPointsSum { get; set; }
    }

    public class Rank {
        public String imageUrl { get; set; }
        public String title { get; set; }
    }

    // Skill data
    public class Skill {
        @AuraEnabled
        public String name { get; set; }
    }

    public class EarnedSkills {
        @AuraEnabled
        public Integer earnedPointsSum { get; set; }

        @AuraEnabled
        public Skill skill { get; set; }
    }

    // Badge data
    public class PageInfo {
        @AuraEnabled
        public Boolean hasNextPage { get; set; }

        @AuraEnabled
        public String startCursor { get; set; }

        @AuraEnabled
        public String endCursor { get; set; }

        @AuraEnabled
        public Boolean hasPreviousPage { get; set; }
    }

    public class Node {
        @AuraEnabled
        public Award award { get; set; }

        @AuraEnabled
        public String earnedAt { get; set; }

        @AuraEnabled
        public String earnedPointsSum { get; set; }
    }

    public class Edges {
        @AuraEnabled
        public Node node { get; set; }
    }

    public class EarnedAwards {
        @AuraEnabled
        public PageInfo pageInfo { get; set; }

        @AuraEnabled
        public List<Edges> edges { get; set; }
    }

    public class Content {
        @AuraEnabled
        public String webUrl { get; set; }
    }

    public class Award {
        @AuraEnabled
        public String icon { get; set; }

        @AuraEnabled
        public String title { get; set; }

        @AuraEnabled
        public String type { get; set; }

        @AuraEnabled
        public String id { get; set; }

        @AuraEnabled
        public Content content { get; set; }
    }
}
