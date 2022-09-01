import { LightningElement, api } from "lwc";

export default class LeaderboardSortDir extends LightningElement {
  @api columnField;
  @api sortBy;
  @api descending;

  get showSort() {
    return this.columnField === this.sortBy;
  }
}
