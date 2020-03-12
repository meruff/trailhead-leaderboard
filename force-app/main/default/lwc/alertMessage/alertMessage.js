import { LightningElement, track, api } from "lwc";

export default class AlertMessage extends LightningElement {
    @api message;
    @api type;
    @api textured = false;
    @api showIcon = false;
    @track dontShow = false;

    iconName;
    assistText;
    alertClass = "slds-notify slds-notify_alert";

    connectedCallback() {
        switch (this.type) {
            case "error":
                this.iconName = "utility:error";
                this.alertClass += " slds-theme_error";
                this.assistText = "error";
                break;
            case "success":
                this.iconName = "utility:success";
                this.alertClass += " slds-theme_success";
                this.assistText = "success";
                break;
            case "warning":
                this.iconName = "utility:warning";
                this.alertClass += " slds-theme_warning";
                this.assistText = "warning";
                break;
            default:
                this.iconName = "utility:info";
                this.alertClass += " slds-theme_info";
                this.assistText = "info";
        }

        if (this.textured) {
            this.alertClass += " slds-theme_alert-texture";
        }
    }

    hideMessage() {
        this.dontShow = true;
    }
}