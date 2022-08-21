import { LightningElement, wire } from "lwc";
import populateTrailblazers from "@salesforce/apex/TrailheadLeaderboardAuraController.populateTrailblazers";
import { refreshApex } from "@salesforce/apex";

const DEFAULT_PAGE_SIZE = 10;
const DEFAULT_PAGE_NUMBER = 1;

export default class TrailheadLeaderboard extends LightningElement {
  sortBy = "Points__c";
  descending = true;
  pageSize = DEFAULT_PAGE_SIZE;
  offset = null;

  @wire(populateTrailblazers, {
    options: "$queryOptions"
  })
  trailblazers;

  get pageNumber() {
    if (!this._pageNumber) {
      return DEFAULT_PAGE_NUMBER;
    }

    return this._pageNumber;
  }

  set pageNumber(value) {
    this._pageNumber = value;
    this.offset =
      this._pageNumber > 1 ? --this._pageNumber * this.pageSize : null;
  }

  get queryOptions() {
    return {
      sortBy: this.sortBy,
      descending: this.descending,
      pageSize: this.pageSize,
      offset: this.offset
    };
  }

  handleSort(event) {
    this.sortBy = event.detail.fieldToSortBy;
    this.descending = event.detail.descending;
  }

  handlePrevious() {
    console.log("prev");
    this.pageNumber = this.pageNumber !== 1 ? this.pageNumber-- : 1;
  }

  handleNext() {
    console.log("next");
    // TODO: Some logic here to determine not going past max pages.
    this.pageNumber++;
  }

  handleSetPageSize(event) {
    console.log(event.detail);
    this.pageSize = event.detail;
  }

  refresh() {
    return refreshApex(this.trailblazers);
  }
}
