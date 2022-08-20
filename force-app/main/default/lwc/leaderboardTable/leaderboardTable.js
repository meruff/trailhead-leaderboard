import { LightningElement, api, track } from "lwc";
import LEADERBOARD_SOURCE from "@salesforce/resourceUrl/Trailhead_Leaderboard";

export default class LeaderboardTable extends LightningElement {
  @api trailblazers;
  @track isProfileModalOpen = false;
  @track isTrailblazerModalOpen = false;
  @track selectedTrailblazerId;
  @track selectedTrailblazerHandle;
  @track fieldToSortBy = "Points__c";
  @track descending = true;

  get trailblazerCountString() {
    return this.trailblazers && this.trailblazers.length > 0
      ? this.trailblazers.length + " Trailblazers"
      : "All Trailblazers";
  }

  get moreInfoText() {
    return "Click on a Trailblazer for more info.";
  }

  get githubLogoUrl() {
    return LEADERBOARD_SOURCE + "/trailheadLeaderboard/github.svg";
  }

  showProfileModal(event) {
    this.selectedTrailblazerId = event.detail.trailblazerId;
    this.selectedTrailblazerHandle = event.detail.trailblazerHandle;
    this.isProfileModalOpen = true;
  }

  hideProfileModal() {
    this.isProfileModalOpen = false;
  }

  showNewTrailblazerModal() {
    this.isTrailblazerModalOpen = true;
  }

  hideNewTrailblazerModal() {
    this.isTrailblazerModalOpen = false;
  }

  sort(event) {
    if (this.fieldToSortBy !== event.target.dataset.field) {
      this.fieldToSortBy = event.target.dataset.field;
      this.descending = true;
    } else {
      this.descending = !this.descending;
    }

    this.dispatchEvent(
      new CustomEvent("sort", {
        detail: {
          fieldToSortBy: this.fieldToSortBy,
          descending: this.descending
        }
      })
    );
  }

  fireRefresh() {
    this.dispatchEvent(new CustomEvent("refreshtable"));
  }
}
