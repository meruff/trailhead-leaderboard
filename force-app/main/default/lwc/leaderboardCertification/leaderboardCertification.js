import { LightningElement, api } from "lwc";

export default class LeaderboardCertification extends LightningElement {
  @api certification;

  get dateCompleted() {
    // Safari is dumb...
    let dateString = this.certification.dateCompleted
      .replace(/-/g, "/")
      .replace("T", " ");
    return new Date(dateString).toISOString();
  }

  get showEndDate() {
    return (
      this.certification.certificationStatus === "EXPIRED" &&
      this.certification.dateExpired
    );
  }
}
