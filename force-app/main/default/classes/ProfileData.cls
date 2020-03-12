/**
* @author meruff
* @date 3/9/20
*
* A class to deserialize Trailhead Profile data from the API into.
*/
public class ProfileData {
    public String profilePhotoUrl { get; set; }
    public profileUser profileUser { get; set; }

    public class profileUser {
        public String TBID_Role { get; set; }
        public String CompanyName { get; set; }
        public String TrailblazerId { get; set; }
        public String Title { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }
        public String Id { get; set; }
    }
}