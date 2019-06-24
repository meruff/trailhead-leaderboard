import {LightningElement, api, track} from 'lwc';

export default class LeaderboardTable extends LightningElement {
    @api trailblazers;
    @track isModalOpen = false;
    @track selectedTrailblazerId;

    showModal(event) {
        this.selectedTrailblazerId = event.detail;
        this.isModalOpen = true
    }

    hideModal() {
        this.isModalOpen = false
    }
}