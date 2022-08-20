import { LightningElement, track, wire } from "lwc";
import populateTrailblazers from "@salesforce/apex/TrailheadLeaderboardAuraController.populateTrailblazers";
import { refreshApex } from "@salesforce/apex";

export default class TrailheadLeaderboard extends LightningElement {
  @track fieldToSortBy = "Points__c";
  @track descending = true;

  @wire(populateTrailblazers, {
    fieldToSortBy: "$fieldToSortBy",
    descending: "$descending"
  })
  trailblazers;

  handleSort(event) {
    this.fieldToSortBy = event.detail.fieldToSortBy;
    this.descending = event.detail.descending;
    this.refresh();
  }

  refresh() {
    return refreshApex(this.trailblazers);
  }
}
