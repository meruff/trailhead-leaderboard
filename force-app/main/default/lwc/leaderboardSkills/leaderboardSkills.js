import { LightningElement, api, track } from "lwc";
import getSkillData from "@salesforce/apex/TrailheadLeaderboardAuraController.getSkillData";
import { loadScript } from "lightning/platformResourceLoader";
import LEADERBOARD_SOURCE from "@salesforce/resourceUrl/Trailhead_Leaderboard";

export default class LeaderboardSkills extends LightningElement {
    @api trailblazer;
    @track skills;
    @track showSpinner = false;

    chart;
    chartjsInitialized = false;
    data = [];
    labels = [];
    colors = [];

    palette = [
        "#5899DA",
        "#A5E6FF",
        "#E8743B",
        "#FFC188",
        "#19A979",
        "#66F6C6",
        "#ED4A7B",
        "#FF97C8",
        "#945ECF",
        "#E1ABFF",
        "#13A4B4",
        "#60F1FF",
        "#525DF4",
        "#9FAAFF",
        "#BF399E",
        "#FF86EB",
        "#6C8893",
        "#B9D5E0",
        "#EE6868",
        "#FFB5B5",
        "#2F6497",
        "#7CB1E4"
    ];

    @api
    get trailblazerId() {
        return this._trailblazerId;
    }

    set trailblazerId(value) {
        this.setAttribute("trailblazerId", value);
        this._trailblazerId = value;
    }

    @api
    get trailblazerHandle() {
        return this._trailblazerHandle;
    }

    set trailblazerHandle(value) {
        this.setAttribute("trailblazerHandle", value);
        this._trailblazerHandle = value;
    }

    get showNoSkillsMessage() {
        return !this.showSpinner && (!this.skills || this.skills.length === 0);
    }

    get noSkillsMessage() {
        return "No skills found for this Trailblazer.";
    }

    renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;

        loadScript(this, LEADERBOARD_SOURCE + "/trailheadLeaderboard/assets/Chart.bundle.min.js")
            .then(() => {
                this.showSpinner = true;

                getSkillData({ userId: this.trailblazerHandle })
                    .then(result => {
                        if (result) {
                            this.skills = result.sort((a, b) => a.UnitTotalPerSkill < b.UnitTotalPerSkill);
        
                            let j = 22;
                            for (let i = 0; i < this.skills.length; i++) {
                                this.labels.push(this.skills[i].Label);
                                this.data.push(this.skills[i].UnitTotalPerSkill);
                        
                                if (i < 22) {
                                    this.colors.push(this.palette[i]);
                                } else {
                                    if (i === j + 22) {
                                        j += 22;
                                    }
                        
                                    this.colors.push(this.palette[i - j]);
                                }
                            }

                            window.Chart.platform.disableCSSInjection = true;
                            const canvas = document.createElement('canvas');
                            canvas.setAttribute("width", 100);
                            canvas.setAttribute("height", 100);
                            this.template.querySelector('div.chart').appendChild(canvas);
                            const ctx = canvas.getContext('2d');

                            this.chart = new window.Chart(ctx, {
                                type: "doughnut",
                                data: {
                                    labels: this.labels,
                                    datasets: [{
                                        borderAlign: "inner",
                                        borderColor: this.colors,
                                        hoverBorderWidth: 5,
                                        hoverBorderColor: this.colors,
                                        backgroundColor: this.colors,
                                        data: this.data
                                    }]
                                },
                                options: {
                                    cutoutPercentage: 80,
                                    responsive: true,
                                    maintainAspectRatio: true,
                                    title: {
                                        display: false,
                                        text: "Skills",
                                        position: "bottom"
                                    },
                                    legend: {
                                        display: true,
                                        labels: {
                                            boxWidth: 12,
                                            padding: 10
                                        },
                                        position: "bottom",
                                        fontFamily: "'Salesforce Sans', 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif"
                                    },
                                    tooltips: {
                                        callbacks: {
                                            label: function(tooltipItem, data) {
                                                let allData = data.datasets[tooltipItem.datasetIndex].data;
                                                let tooltipLabel = data.labels[tooltipItem.index];
                                                let tooltipData = allData[tooltipItem.index];
                                                let total = 0;

                                                for (let i in allData) {
                                                    if (allData[i]) {
                                                        total += allData[i];
                                                    }
                                                }

                                                let tooltipPercentage = Math.round(((tooltipData / total) * 100) * 2) / 2;
                                                return " " + tooltipLabel + ": " + tooltipPercentage + "%";
                                            }
                                        },
                                        titleFontFamily: "'Salesforce Sans', 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif"
                                    }
                                }
                            });

                            if (this.skills && this.skills.length > 0) {
                                this.dispatchEvent(
                                    new CustomEvent(
                                        "updatesectionlabel", 
                                        { 
                                            detail: { 
                                                name: "skills", 
                                                label: this.skills.length + " Skills" 
                                            }
                                        }
                                    )
                                );
                            }
                        }
    
                        this.showSpinner = false;
                    })
                    .catch(error => {
                        console.error(error);
                        this.showSpinner = false;
                    })
            })
            .catch((error) => {
                console.error(error);
            });
    }
}