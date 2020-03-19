/**
* @author meruff
* @date 3/18/20
*
* A class to deserialize Trailhead Certification data from the API into.
*/
public class CertificationData {
    @AuraEnabled
    public List<certificationsList> certificationsList { get; set; }

    public class certificationsList {
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