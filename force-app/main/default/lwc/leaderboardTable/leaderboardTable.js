import { LightningElement, api } from "lwc";
import LEADERBOARD_SOURCE from "@salesforce/resourceUrl/Trailhead_Leaderboard";

export default class LeaderboardTable extends LightningElement {
  @api trailblazers;
  @api trailblazerCount;
  @api paginationData;

  isProfileModalOpen = false;
  isTrailblazerModalOpen = false;
  selectedTrailblazerId;
  selectedTrailblazerHandle;
  sortBy = "Points__c";
  descending = true;

  get trailblazerCountString() {
    return this.trailblazerCount
      ? `${this.trailblazerCount} Trailblazers`
      : "All Trailblazers";
  }

  get desktopCountText() {
    return `Showing ${this.startCount}-${this.endCount} of ${this.trailblazerCount} • ${this.moreInfoText}`;
  }

  get moreInfoText() {
    return `Click on a Trailblazer for more info`;
  }

  get startCount() {
    return 1 + this.offset;
  }

  get endCount() {
    const endCount = this.pageSize + this.offset;
    return endCount <= this.trailblazerCount ? endCount : this.trailblazerCount;
  }

  get offset() {
    return this.paginationData.offset ?? 0;
  }

  get pageSize() {
    return parseInt(this.paginationData.pageSize) ?? 0;
  }

  get githubLogoUrl() {
    return `${LEADERBOARD_SOURCE}/trailheadLeaderboard/github.svg`;
  }

  get showMoreButton() {
    return this.paginationData.pageSize <= this.trailblazerCount;
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

  handleSort(event) {
    if (this.sortBy !== event.target.dataset.field) {
      this.sortBy = event.target.dataset.field;
      this.descending = true;
    } else {
      this.descending = !this.descending;
    }

    this.dispatchEvent(
      new CustomEvent("sort", {
        detail: {
          fieldToSortBy: this.sortBy,
          descending: this.descending
        }
      })
    );
  }

  handlePrevious() {
    this.dispatchEvent(new CustomEvent("previous"));
  }

  handlePageSize(event) {
    this.dispatchEvent(new CustomEvent("pagesize", { detail: event.detail }));
  }

  handleNext() {
    this.dispatchEvent(new CustomEvent("next"));
  }

  handleShowMore() {
    this.dispatchEvent(new CustomEvent("showmore"));
  }

  fireRefresh() {
    this.dispatchEvent(new CustomEvent("refreshtable"));
  }
}
