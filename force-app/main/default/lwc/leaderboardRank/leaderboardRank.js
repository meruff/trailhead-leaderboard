import { LightningElement, api } from "lwc";

export default class LeaderboardRank extends LightningElement {
  @api showHashtag = false;
  @api rank;
}
