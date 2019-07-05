import { LightningElement, api, track } from 'lwc';

export default class LeaderboardTable extends LightningElement {
    @api trailblazers;
    @track isBadgesModalOpen = false;
    @track isTrailblazerModalOpen = false;
    @track selectedTrailblazerId;

    showBadgesModal(event) {
        this.selectedTrailblazerId = event.detail;
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

    fireRefresh() {
        this.dispatchEvent(new CustomEvent("refreshtable"));
    }
}