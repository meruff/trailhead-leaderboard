import {LightningElement, api, track} from 'lwc';

export default class LeaderboardBadgesModal extends LightningElement {
    @api isModalOpen = false;
    @api trailblazers;

    @api
    get selectedTrailblazerId() {
        return this._selectedTrailblazerId;
    }

    set selectedTrailblazerId(value) {
        this.setAttribute("selectedTrailblazerId", value);
        this._selectedTrailblazerId = value;
        this.selectedBadgeType = "all";
    }

    @track selectedBadgeType = "all";

    badgeTypeOptions = [
        {"label": "All Badges", "value": "all"},
        {"label": "Superbadges", "value": "superbadge"},
        {"label": "Modules", "value": "module"},
        {"label": "Projects", "value": "project"},
        {"label": "Event/Community", "value": "event"}
    ];

    get trailblazer() {
        return this.trailblazers.find(blazer => blazer.Id === this.selectedTrailblazerId);
    }

    get firstName() {
        return this.trailblazer.Name.split(" ")[0];
    }

    get badges() {
        return this.trailblazers.find(blazer => blazer.Id === this.selectedTrailblazerId).Badges__r;
    }

    updateSelectedBadgeFilter(event) {
        this.selectedBadgeType = event.target.value;
    }

    get filteredBadges() {
        if (this.selectedBadgeType !== "all") {
            return this.badges.filter(badge => badge.Type__c.toLowerCase() === this.selectedBadgeType);
        } else {
            return this.badges;
        }
    }

    get isFilteredBadges() {
        return this.filteredBadges.length > 0;
    }

    hideModal() {
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent("closemodal"));
    }
}