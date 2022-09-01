import { LightningElement, api } from "lwc";
import LeaderboardProfileHelper from "c/leaderboardProfileHelper";
import LEADERBOARD_SOURCE from "@salesforce/resourceUrl/Trailhead_Leaderboard";

const profileHelper = new LeaderboardProfileHelper();

export default class LeaderboardProfileTableRow extends LightningElement {
  @api trailblazer;
  @api offset;
  @api index;

  photoError = false;

  get rankNumber() {
    return this.index + 1 + (isNaN(this.offset) ? 0 : this.offset);
  }

  get placeholderProfilePhotoURL() {
    return `${LEADERBOARD_SOURCE}/trailheadLeaderboard/astro.png`;
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
