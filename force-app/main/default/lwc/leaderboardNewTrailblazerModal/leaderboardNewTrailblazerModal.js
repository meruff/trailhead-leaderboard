import { LightningElement, api, track } from "lwc";
import createTrailblazer from "@salesforce/apex/TrailheadLeaderboardAuraController.createTrailblazer";

export default class LeaderboardNewTrailblazerModal extends LightningElement {
    @api isModalOpen = false;
    @track userId = "";
    @track error;
    @track showSpinner = false;

    renderedCallback() {
        if (this.isModalOpen) {
            this.template.querySelector('.trailblazer-handle-input').focus();
        }
    }

    hideModal() {
        this.error = undefined;
        this.userId = "";
        this.dispatchEvent(new CustomEvent("closemodal"));
    }

    updateUserId(event) {
        this.userId = event.target.value;
    }

    saveTrailblazer(event) {
        let submitBtn = event.target;
        submitBtn.disabled = true;
        this.error = undefined;

        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);

        if (allValid) {
            this.showSpinner = true;

            createTrailblazer({ userId: this.userId })
                .then(result => {
                    if (result === 'success') {
                        this.error = undefined;
                        this.hideModal();
                        this.dispatchEvent(new CustomEvent("refreshtable"));
                    } else {
                        this.error = result;
                    }
                    submitBtn.disabled = false;
                    this.showSpinner = false;
                })
                .catch(error => {
                    this.error = error.error;
                    submitBtn.disabled = false;
                    this.showSpinner = false;
                });
        } else {
            submitBtn.disabled = false;
        }
    }
}