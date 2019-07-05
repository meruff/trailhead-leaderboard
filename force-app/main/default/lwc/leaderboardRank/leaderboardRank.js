import { LightningElement, api } from 'lwc';

export default class LeaderboardRank extends LightningElement {
    @api showHashtag = false;

    @api
    get rank() {
        return this._rank;
    }

    set rank(value) {
        this.setAttribute('rank', value++);
        this._rank = value;
    }

    get first() {
        return (this.rank === 1);
    }
}