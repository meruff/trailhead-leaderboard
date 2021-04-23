import { LightningElement, api } from "lwc";

export default class LeaderboardCertification extends LightningElement {
    @api certification;

    get dateCompleted() {
        return new Date(this.certification.dateCompleted).toISOString();
    }

    get showEndDate() {
        return this.certification.certificationStatus === "EXPIRED" && this.certification.dateExpired;
    }
}