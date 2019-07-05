import { LightningElement, api, track } from 'lwc';

export default class LeaderboardBadgesModal extends LightningElement {
    @api isModalOpen = false;
    @api trailblazers;
    @track showAll = false;
    @track selectedBadgeType = "all";
    initialListSize = 50;
    badgeTypeOptions = [
        { "label": "All Badges", "value": "all" },
        { "label": "Superbadges", "value": "superbadge" },
        { "label": "Modules", "value": "module" },
        { "label": "Projects", "value": "project" },
        { "label": "Event/Community", "value": "event" }
    ];

    @api
    get selectedTrailblazerId() {
        return this._selectedTrailblazerId;
    }

    set selectedTrailblazerId(value) {
        this.setAttribute("selectedTrailblazerId", value);
        this._selectedTrailblazerId = value;
        this.selectedBadgeType = "all";
        this.showAll = false;
    }

    get trailblazer() {
        return this.trailblazers.find(blazer => blazer.Id === this.selectedTrailblazerId);
    }

    get firstName() {
        return this.trailblazer.Name.split(" ")[0];
    }

    get badges() {
        return this.trailblazer.Badges__r;
    }

    get filteredBadges() {
        if (this.selectedBadgeType !== "all") {
            if (this.showAll) {
                return this.badges.filter(badge => badge.Type__c.toLowerCase() === this.selectedBadgeType);
            } else {
                return this.badges.filter(badge => badge.Type__c.toLowerCase() === this.selectedBadgeType).slice(0, this.initialListSize);
            }
        } else {
            if (this.showAll) {
                return this.badges;
            } else {
                return this.badges.slice(0, this.initialListSize);
            }
        }
    }

    get isFilteredBadges() {
        return this.filteredBadges.length > 0;
    }

    get showMore() {
        if (this.selectedBadgeType !== "all") {
            return this.filteredBadges.length < this.badges.filter(badge => badge.Type__c.toLowerCase() === this.selectedBadgeType).length;
        } else {
            return this.filteredBadges.length < this.badges.length;
        }
    }

    get showMoreButtonLabel() {
        return "Show More (" + (parseInt(this.trailblazer.Badges__c) - this.filteredBadges.length) + ")";
    }

    handleShowAll() {
        this.showAll = true;
    }

    updateSelectedBadgeFilter(event) {
        this.selectedBadgeType = event.target.value;
    }

    hideModal() {
        this.showAll = false;
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent("closemodal"));
    }
}