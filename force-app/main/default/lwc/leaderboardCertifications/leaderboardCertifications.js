import { LightningElement, api, track } from "lwc";
import getCertificationData from "@salesforce/apex/TrailheadLeaderboardAuraController.getCertificationData";

export default class LeaderboardCertifications extends LightningElement {
  @api trailblazer;
  @track certifications;
  @track certificationsDisplayed;
  @track showSpinner = false;

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

    if (value) {
      this.showSpinner = true;

      getCertificationData({ userId: value })
        .then((result) => {
          if (result) {
            this.certifications = result.sort((a, b) => a.title > b.title);

            this.dispatchEvent(
              new CustomEvent("updatesectionlabel", {
                detail: {
                  name: "certifications",
                  label:
                    this.certifications.length +
                    (this.certifications.length === 1
                      ? " Certification"
                      : " Certifications")
                }
              })
            );

            if (this.certifications.length > 5) {
              this.certificationsDisplayed = this.certifications.slice(0, 5);
            } else {
              this.showAll();
            }
          }

          this.showSpinner = false;
        })
        .catch((error) => {
          console.error(error);
          this.showSpinner = false;
        });
    }
  }

  get showNoCertificationsMessage() {
    return (
      !this.showSpinner &&
      (!this.certificationsDisplayed ||
        this.certificationsDisplayed.length === 0)
    );
  }

  get noCertificationsMessage() {
    return "No Salesforce certifications found for this Trailblazer";
  }

  get displayShowMore() {
    return (
      this.certifications &&
      this.certifications.length > 5 &&
      this.certificationsDisplayed.length !== this.certifications.length
    );
  }

  showAll() {
    this.certificationsDisplayed = this.certifications;
  }
}
