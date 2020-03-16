import { LightningElement, api, wire, track } from "lwc";
import getBadgeData from "@salesforce/apex/TrailheadLeaderboardAuraController.getBadgeData";

export default class LeaderboardBadgesModal extends LightningElement {
    @api trailblazers;
    @api isModalOpen = false;
    @track badges = [];
    @track noMoreBadges = false;
    @track showSpinner = false;
    @track selectedBadgeType = "all";

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
    }

    @api
    get selectedTrailblazerHandle() {
        return this._selectedTrailblazerHandle;
    }

    set selectedTrailblazerHandle(value) {
        this.setAttribute("selectedTrailblazerHandle", value);
        this._selectedTrailblazerHandle = value;
        this.selectedBadgeType = "all";
        this.badges = [];

        if (value) {
            this.showSpinner = true;

            getBadgeData({ userId: value, filter: "all", offset: "" })
                .then(result => {
                    this.badges = result;
                    this.showSpinner = false;
                })
                .catch(error => {
                    console.error(error);
                    this.showSpinner = false;
                })
        }
    }

    get showNoBadgesMessage() {
        return !this.showSpinner && (!this.badges || this.badges.length === 0);
    }

    get noBadgesMessage() {
        return "No Badges found for this filter type.";
    }

    get trailblazer() {
        return this.trailblazers.find(blazer => blazer.Id === this.selectedTrailblazerId);
    }

    get firstName() {
        return this.trailblazer.Name.split(" ")[0];
    }

    get showMore() {
        return this.badges && this.badges.length > 29 && !this.noMoreBadges;
    }

    updateSelectedBadgeFilter(event) {
        this.selectedBadgeType = event.target.value;
        this.showSpinner = true;

        getBadgeData({
            userId: this.selectedTrailblazerHandle,
            filter: this.selectedBadgeType,
            offset: ""
        })
            .then(result => {
                this.badges = result;
                this.showSpinner = false;
            })
            .catch(error => {
                console.error(error);
                this.showSpinner = false;
            })
    }

    handleShowMore() {
        this.showSpinner = true;

        getBadgeData({
            userId: this.selectedTrailblazerHandle,
            filter: this.selectedBadgeType,
            offset: (this.badges.length <= 30) ? 30 : this.badges.length + 30
        })
            .then(result => {
                if (result) {
                    this.badges = this.badges.concat(result);
                } else {
                    this.noMoreBadges = true;
                }

                this.showSpinner = false;
            })
            .catch(error => {
                console.error(error);
                this.showSpinner = false;
            })
    }

    hideModal() {
        this.noMoreBadges = false;
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent("closemodal"));
    }
}