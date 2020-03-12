import { LightningElement, api } from "lwc";
const profileHelper = new LeaderboardProfileHelper();
import LeaderboardProfileHelper from "c/leaderboardProfileHelper";

export default class LeaderboardProfileTableRow extends LightningElement {
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

    handleProfileClick(event) {
        event.stopPropagation();
    }

    openModalHandler() {
        this.dispatchEvent(new CustomEvent("openmodal", { detail: {trailblazerId: this.trailblazer.Id, trailblazerHandle: this.trailblazer.Profile_Handle__c} }));
    }
}