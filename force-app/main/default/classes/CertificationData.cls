/**
 * @description A class to deserialize Trailhead Certification data from the API into.
 *
 * @author meruff
 *
 * @date 3/18/20
 */
public class CertificationData {
    public String error { get; set; }

    @AuraEnabled
    public List<CertificationsList> certificationsList { get; set; }

    public class CertificationsList {
        @AuraEnabled
        public String dateExpired { get; set; }

        @AuraEnabled
        public String dateCompleted { get; set; }

        @AuraEnabled
        public String certificationUrl { get; set; }

        @AuraEnabled
        public String description { get; set; }

        @AuraEnabled
        public String certificationStatus { get; set; }

        @AuraEnabled
        public String title { get; set; }

        @AuraEnabled
        public String certificationImageUrl { get; set; }
    }
}
