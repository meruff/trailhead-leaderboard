import { LightningElement, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import populateTrailblazers from "@salesforce/apex/TrailheadLeaderboardAuraController.populateTrailblazers";
import getTotalTrailblazerCount from "@salesforce/apex/TrailheadLeaderboardAuraController.getTotalTrailblazerCount";

const DEFAULT_PAGE_SIZE = 10;

export default class TrailheadLeaderboard extends LightningElement {
  sortBy = "Points__c";
  descending = true;
  pageSize = DEFAULT_PAGE_SIZE;
  offset = null;

  @wire(populateTrailblazers, {
    options: "$queryOptions"
  })
  trailblazers;

  @wire(getTotalTrailblazerCount)
  totalTrailblazerCount;

  get showTable() {
    return this.trailblazers.data && this.totalTrailblazerCount.data;
  }

  get pageNumber() {
    return this._pageNumber || 1;
  }

  set pageNumber(value) {
    this._pageNumber = value;
    this.offset = value > 1 ? (value - 1) * this.pageSize : null;
  }

  /**
   * Formats filter, sort, and page data in an easily consumable config Object.
   * @returns {{offset: null, pageSize: number, sortBy: string, descending: boolean}}
   */
  get queryOptions() {
    return {
      sortBy: this.sortBy,
      descending: this.descending,
      pageSize: this.pageSize,
      offset: this.offset
    };
  }

  /**
   * Formats page number, size, and offset into consumable config object.
   * @returns {{pageNumber: *, offset: null, pageSize: string}}
   */
  get paginationData() {
    return {
      totalPages: this.totalPages,
      pageNumber: this.pageNumber,
      pageSize: this.selectOptionPageSize,
      offset: this.offset
    };
  }

  get totalTrailblazers() {
    return this.totalTrailblazerCount?.data ?? 0;
  }

  get totalPages() {
    return Math.ceil(this.totalTrailblazers / this.pageSize);
  }

  get selectOptionPageSize() {
    return "" + this.pageSize;
  }

  handleSort(event) {
    this.sortBy = event.detail.fieldToSortBy;
    this.descending = event.detail.descending;
  }

  handlePrevious() {
    const currentPageNumber = this.pageNumber;
    this.pageNumber = currentPageNumber !== 1 ? currentPageNumber - 1 : 1;
  }

  handleNext() {
    const currentPageNumber = this.pageNumber;
    this.pageNumber =
      currentPageNumber < this.totalPages
        ? currentPageNumber + 1
        : this.totalPages;
  }

  handleShowMore() {
    this.pageSize += DEFAULT_PAGE_SIZE;
  }

  handlePageSize(event) {
    this.pageNumber = 1;
    this.pageSize = event.detail;
  }

  refresh() {
    Promise.all([
      refreshApex(this.trailblazers),
      refreshApex(this.totalTrailblazerCount)
    ]).then();
  }
}
