import {LightningElement, track} from 'lwc';
import populateTrailblazers from '@salesforce/apex/TrailheadLeaderboardAuraController.populateTrailblazers';

export default class TrailheadLeaderboard extends LightningElement {
    @track trailblazers;

    trailblazerPromise = populateTrailblazers();

    connectedCallback() {
        populateTrailblazers().then(result => {
            this.trailblazers = result;
        });
    }
}