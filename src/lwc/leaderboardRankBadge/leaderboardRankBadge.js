import {LightningElement, api} from 'lwc';
import Leaderboard_Ranks from '@salesforce/resourceUrl/Trailhead_Leaderboard';

export default class LeaderboardRankBadge extends LightningElement {
    @api rankName;
    @api showName = false;

    get rankBadgeURL() {
        return Leaderboard_Ranks + '/trailheadLeaderboard/ranks/' + this.rankName.toLowerCase() + '.png';
    }

    get alt() {
        return this.rankName + ' Badge';
    }

    get imgAdjust() {
        if (['Ranger', 'Adventurer', 'Expeditioner'].includes(this.rankName)) {
            return 'slds-m-top_x-small';
        } else if (this.rankName === 'Hiker') {
            return 'slds-m-top_xx-small';
        }
    }
}