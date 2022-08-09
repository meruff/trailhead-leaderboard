import { LightningElement, api, track } from "lwc";
import LEADERBOARD_SOURCE from "@salesforce/resourceUrl/Trailhead_Leaderboard";
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

  @track photoError = false;

  get placeholderProfilePhotoURL() {
    return LEADERBOARD_SOURCE + "/trailheadLeaderboard/astro.png";
  }

  get titleString() {
    return profileHelper.getTitleString(
      this.trailblazer.Job_Title__c,
      this.trailblazer.Company_Institution__c
    );
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
    this.dispatchEvent(
      new CustomEvent("openmodal", {
        detail: {
          trailblazerId: this.trailblazer.Id,
          trailblazerHandle: this.trailblazer.Profile_Handle__c
        }
      })
    );
  }

  loadPlaceholderPhoto() {
    this.photoError = true;
  }
}
