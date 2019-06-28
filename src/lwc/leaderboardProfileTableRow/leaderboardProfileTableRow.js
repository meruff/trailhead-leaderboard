import {LightningElement, api} from 'lwc';

export default class LeaderboardProfileTableRow extends LightningElement {
    @api trailblazer;
    @api first;
    @api index;

    get titleString() {
        let title = "";

        if (this.trailblazer.Job_Title__c) {
            title += this.trailblazer.Job_Title__c;
        }

        if (this.trailblazer.Company_Institution__c) {
            title += ((this.trailblazer.Job_Title__c) ? "&nbsp;&hyphen;&nbsp;" : "") + this.trailblazer.Company_Institution__c;
        }

        return title;
    }

    get profileAlt() {
        return this.trailblazer.Name.split(" ")[0] + "'s profile photo";
    }

    static handleProfileClick(event) {
        event.stopPropagation();
    }

    openModalHandler() {
        this.dispatchEvent(new CustomEvent("openmodal", { detail: this.trailblazer.Id }));
    }
}