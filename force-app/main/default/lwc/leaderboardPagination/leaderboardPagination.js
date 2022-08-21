import { LightningElement } from "lwc";

export default class LeaderboardPagination extends LightningElement {
  handlePrevious() {
    this.dispatchEvent(new CustomEvent("previous"));
  }

  handleNext() {
    this.dispatchEvent(new CustomEvent("next"));
  }
}