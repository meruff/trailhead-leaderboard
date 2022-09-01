import { LightningElement, api } from "lwc";

const PAGE_SIZE_OPTIONS = [
  {
    label: "10",
    value: "10"
  },
  {
    label: "15",
    value: "15"
  },
  {
    label: "25",
    value: "25"
  }
];

export default class LeaderboardPagination extends LightningElement {
  @api paginationData;

  get selectedPageSize() {
    return this._selectedPageSize || this.paginationData.pageSize;
  }

  set selectedPageSize(value) {
    this._selectedPageSize = value;
  }

  get pageSizeOptions() {
    return PAGE_SIZE_OPTIONS;
  }

  get previousDisabled() {
    return this.paginationData.pageNumber === 1 ?? false;
  }

  get nextDisabled() {
    return (
      this.paginationData.pageNumber === this.paginationData.totalPages ?? false
    );
  }

  handlePrevious() {
    this.dispatchEvent(new CustomEvent("previous"));
  }

  handlePageSizeChange(event) {
    this.selectedPageSize = event.detail.value;
    this.dispatchEvent(
      new CustomEvent("pagesize", {
        detail: parseInt(event.detail.value, 10)
      })
    );
  }

  handleNext() {
    this.dispatchEvent(new CustomEvent("next"));
  }
}
