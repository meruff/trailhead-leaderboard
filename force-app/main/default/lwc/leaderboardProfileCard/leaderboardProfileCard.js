import { LightningElement, api } from "lwc";
import LeaderboardProfileHelper from "c/leaderboardProfileHelper";
const profileHelper = new LeaderboardProfileHelper();

export default class LeaderboardProfileCard extends LightningElement {
    @api trailblazer;

    @api
    get index() {
        return this._index;
    }

    set index(value) {
        this.setAttribute("index", value++);
        this._index = value;
    }

    get titleString() {
        return profileHelper.getTitleString(this.trailblazer.Job_Title__c, this.trailblazer.Company_Institution__c);
    }

    get profileAlt() {
        return profileHelper.getProfileAlt(this.trailblazer.Name);
    }

    get superbadges() {
        return profileHelper.getSuperbadgeCount(this.trailblazer.Badges__r);
    }

    handleProfileClick(event) {
        event.stopPropagation();
    }

    openModalHandler() {
        this.dispatchEvent(new CustomEvent("openmodal", { detail: {trailblazerId: this.trailblazer.Id, trailblazerHandle: this.trailblazer.Profile_Handle__c} }));
    }
}