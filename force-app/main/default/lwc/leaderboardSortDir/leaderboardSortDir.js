import { LightningElement, api, track } from "lwc";

export default class LeaderboardSortDir extends LightningElement {
    @api columnField;
    @api fieldToSortBy;
    @api descending;

    get showSort() {
        return this.columnField === this.fieldToSortBy;
    }
}