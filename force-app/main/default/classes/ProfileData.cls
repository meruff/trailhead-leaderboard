/**
* @author meruff
* @date 3/9/20
*
* A class to deserialize Trailhead Profile data into.
*/
public class ProfileData {
    public String profilePhotoUrl { get; set; }
    public profileUser profileUser { get; set; }
    public String profileUserBgImageUrl { get; set; }

    public class profileUser {
        public String LinkedInProfileLink { get; set; }
        public String CountryCode { get; set; }
        public String Company_Size { get; set; }
        public String TBID_Role { get; set; }
        public String CompanyName { get; set; }
        public String Certification_Status { get; set; }
        public Boolean Is_Public_Profile { get; set; }
        public String BackgroundImageResource { get; set; }
        public String TrailblazerId { get; set; }
        public String Relationship_To_Salesforce { get; set; }
        public String FacebookProfileLink { get; set; }
        public String Title { get; set; }
        public String State { get; set; }
        public String StateCode { get; set; }
        public String Pronoun { get; set; }
        public String FirstName { get; set; }
        public String TwitterProfileLink { get; set; }
        public String AboutMe { get; set; }
        public String Country { get; set; }
        public String Company_Website { get; set; }
        public String LastName { get; set; }
        public String WebsiteLink { get; set; }
        public String Id { get; set; }
    }
}