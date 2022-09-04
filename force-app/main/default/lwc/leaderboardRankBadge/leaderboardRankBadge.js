import { LightningElement, api } from "lwc";
import LEADERBOARD_SOURCE from "@salesforce/resourceUrl/Trailhead_Leaderboard";

export default class LeaderboardRankBadge extends LightningElement {
  @api rankName;
  @api rankBadgeLink;
  @api showName = false;

  get altTitle() {
    return this.rankName;
  }
}
