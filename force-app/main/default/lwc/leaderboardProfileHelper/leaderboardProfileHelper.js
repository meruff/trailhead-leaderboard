export default class LeaderboardProfileHelper {
    getTitleString(title, company) {
        let titleString = "";

        if (title) {
            titleString += "<div class='slds-text-body_regular' style='white-space:normal;'>" + title + "</div>";
        }

        if (company) {
            titleString += "<div class='slds-text-title' style='white-space:normal;'>" + company + "</div>";
        }

        return titleString;
    }

    getProfileAlt(name) {
        return name.split(" ")[0] + "'s profile photo";
    }
}