import { LightningElement, api, track } from "lwc";
import getBadgeData from "@salesforce/apex/TrailheadLeaderboardAuraController.getBadgeData";

const OFFSET_STEP = 30;

export default class LeaderboardBadges extends LightningElement {
  @api trailblazer;
  @track showSpinner = false;
  @track badges;
  @track noMoreBadges = false;
  @track selectedBadgeType = "all";
  @track endCursor;
  offset = OFFSET_STEP;

  badgeTypeOptions = [
    { label: "All", value: "all" },
    { label: "Superbadges", value: "superbadge" },
    { label: "Modules", value: "module" },
    { label: "Projects", value: "project" },
    { label: "Event/Community", value: "event" }
  ];

  @api
  get trailblazerId() {
    return this._trailblazerId;
  }

  set trailblazerId(value) {
    this.setAttribute("trailblazerId", value);
    this._trailblazerId = value;
  }

  @api
  get trailblazerHandle() {
    return this._trailblazerHandle;
  }

  set trailblazerHandle(value) {
    this.setAttribute("trailblazerHandle", value);
    this._trailblazerHandle = value;
    this.selectedBadgeType = "all";
    this.badges = [];
    this.offset = OFFSET_STEP;

    if (value) {
      this.showSpinner = true;

      getBadgeData({
        userId: value,
        filter: "all",
        count: OFFSET_STEP,
        after: ""
      })
        .then((result) => {
          if (result) {
            this.badges = result.edges;
            this.endCursor = result.pageInfo.endCursor;

            this.dispatchEvent(
              new CustomEvent("updatesectionlabel", {
                detail: {
                  name: "badges",
                  label:
                    this.trailblazer.Badges__c +
                    (this.trailblazer.Badges__c === 1 ? " Badge" : " Badges")
                }
              })
            );
          }

          this.showSpinner = false;
        })
        .catch((error) => {
          console.error(error);
          this.showSpinner = false;
        });
    }
  }

  get showFilters() {
    return this.badges && this.badges.length > 0;
  }

  get showNoBadgesMessage() {
    return !this.showSpinner && (!this.badges || this.badges.length === 0);
  }

  get noBadgesMessage() {
    return this.badges && this.badges.length === 0
      ? "No badges found for this Trailblazer."
      : "No badges found for this Trailblazer using this filter type.";
  }

  get firstName() {
    return this.trailblazer.Name.split(" ")[0];
  }

  get showMore() {
    return (
      this.badges &&
      this.badges.length > 29 &&
      this.badges.length !== this.trailblazer.Badges__c &&
      !this.noMoreBadges
    );
  }

  updateSelectedBadgeFilter(event) {
    this.selectedBadgeType = event.target.value;
    this.showSpinner = true;

    getBadgeData({
      userId: this.trailblazerHandle,
      filter: this.selectedBadgeType,
      count: OFFSET_STEP,
      after: ""
    })
      .then((result) => {
        this.badges = result.edges;
        this.endCursor = result.pageInfo.endCursor;
        this.showSpinner = false;
      })
      .catch((error) => {
        console.error(error);
        this.showSpinner = false;
      });
  }

  handleShowMore() {
    this.showSpinner = true;

    getBadgeData({
      userId: this.trailblazerHandle,
      filter: this.selectedBadgeType,
      count: OFFSET_STEP,
      after: this.endCursor
    })
      .then((result) => {
        if (result && result.edges.length > 0) {
          this.badges = this.badges.concat(result.edges);
          this.endCursor = result.pageInfo.endCursor;
        } else {
          this.noMoreBadges = true;
        }

        this.showSpinner = false;
      })
      .catch((error) => {
        console.error(error);
        this.showSpinner = false;
      });
  }
}
