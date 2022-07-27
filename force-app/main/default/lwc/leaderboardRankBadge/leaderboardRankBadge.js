import { LightningElement, api } from "lwc";
import LEADERBOARD_SOURCE from "@salesforce/resourceUrl/Trailhead_Leaderboard";

export default class LeaderboardRankBadge extends LightningElement {
  @api rankName;
  @api rankBadgeLink;
  @api showName = false;

  get rankBadgeURL() {
    return (
      LEADERBOARD_SOURCE +
      "/trailheadLeaderboard/ranks/" +
      this.rankName.toLowerCase() +
      ".png"
    );
  }

  get alt() {
    return this.rankName;
  }
}
