import { LightningElement, api, track } from "lwc";

export default class LeaderboardTable extends LightningElement {
    @api trailblazers;
    @track isBadgesModalOpen = false;
    @track isTrailblazerModalOpen = false;
    @track selectedTrailblazerId;
    @track selectedTrailblazerHandle;
    @track fieldToSortBy = "Points__c";
    @track descending = true;

    showBadgesModal(event) {
        this.selectedTrailblazerId = event.detail.trailblazerId;
        this.selectedTrailblazerHandle = event.detail.trailblazerHandle;
        this.isBadgesModalOpen = true;
    }

    hideBadgesModal() {
        this.isBadgesModalOpen = false;
    }

    showTrailblazerModal() {
        this.isTrailblazerModalOpen = true;
    }

    hideTrailblazerModal() {
        this.isTrailblazerModalOpen = false;
    }

    sort(event) {
        if (this.fieldToSortBy !== event.target.dataset.field) {
            this.fieldToSortBy = event.target.dataset.field;
            this.descending = true;
        } else {
            this.descending = !this.descending;
        }

        this.dispatchEvent(new CustomEvent("sort", { detail: {fieldToSortBy: this.fieldToSortBy, descending: this.descending} }));
    }

    fireRefresh() {
        this.dispatchEvent(new CustomEvent("refreshtable"));
    }
}