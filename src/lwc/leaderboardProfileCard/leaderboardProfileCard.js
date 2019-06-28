import { LightningElement, api } from 'lwc';

export default class LeaderboardProfileCard extends LightningElement {
    @api trailblazer;
    @api first;
    @api index;

    get titleString() {
        let title = "";

        if (this.trailblazer.Job_Title__c) {
            title += this.trailblazer.Job_Title__c;
        }

        if (this.trailblazer.Company_Institution__c) {
            title += ((this.trailblazer.Job_Title__c) ? "</br>" : "") + this.trailblazer.Company_Institution__c;
        }

        return title;
    }

    get profileAlt() {
        return this.trailblazer.Name.split(" ")[0] + "'s profile photo";
    }

    handleProfileClick(event) {
        event.stopPropagation();
    }

    openModalHandler() {
        this.dispatchEvent(new CustomEvent("openmodal", { detail: this.trailblazer.Id }));
    }
}