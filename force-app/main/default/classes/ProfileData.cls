/**
 * @description A class to deserialize Trailhead Profile data from the API into.
 *
 * @author meruff
 *
 * @date 3/9/20
 */
public class ProfileData {
    public String error { get; set; }
    public String profilePhotoUrl { get; set; }
    public ProfileUser profileUser { get; set; }

    public class ProfileUser {
        public String TBID_Role { get; set; }
        public String CompanyName { get; set; }
        public String TrailblazerId { get; set; }
        public String Title { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }
        public String Id { get; set; }
    }
}
