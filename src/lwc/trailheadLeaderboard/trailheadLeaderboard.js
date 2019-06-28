import {LightningElement, wire} from 'lwc';
import populateTrailblazers from '@salesforce/apex/TrailheadLeaderboardAuraController.populateTrailblazers';

export default class TrailheadLeaderboard extends LightningElement {
    @wire(populateTrailblazers) trailblazers;
}