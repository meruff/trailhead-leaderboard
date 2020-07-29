import { LightningElement, api, track } from "lwc";

const SKILLS = "Skills";
const CERTIFICATIONS = "Certifications";
const BADGES = "Badges";

export default class LeaderboardProfileModal extends LightningElement {
    @api isModalOpen = false;
    @api trailblazers;
    @api selectedTrailblazerId;
    @api selectedTrailblazerHandle;
    @track skillsLabel = SKILLS;
    @track certificationsLabel = CERTIFICATIONS;
    @track badgesLabel = BADGES;

    activeSections = ["skills","certifications","badges"];

    get trailblazer() {
        return this.trailblazers.find(blazer => blazer.Id === this.selectedTrailblazerId);
    }

    get firstName() {
        return this.trailblazer.Name.split(" ")[0];
    }

    hideModal() {
        this.skillsLabel = SKILLS;
        this.certificationsLabel = CERTIFICATIONS;
        this.badgesLabel = BADGES;
        this.dispatchEvent(new CustomEvent("closemodal"));
    }

    handleUpdateSectionLabel(event) {
        if (event.detail.name && event.detail.label) {
            if (event.detail.name === "skills") {
                this.skillsLabel = event.detail.label;
            } else if (event.detail.name === "certifications") {
                this.certificationsLabel = event.detail.label;
            } else if (event.detail.name === "badges") {
                this.badgesLabel = event.detail.label;
            }
        }
    }
}