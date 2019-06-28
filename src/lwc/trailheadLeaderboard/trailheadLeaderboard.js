import { LightningElement, wire } from 'lwc';
import populateTrailblazers from '@salesforce/apex/TrailheadLeaderboardAuraController.populateTrailblazers';
import { refreshApex } from '@salesforce/apex';

export default class TrailheadLeaderboard extends LightningElement {
    @wire(populateTrailblazers) trailblazers;

    refresh() {
        return refreshApex(this.trailblazers);
    }
}