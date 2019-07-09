# Trailhead Leaderboard

## Summary

**Now built using Lightning Web Components!**

This is a simple app that displays Trailhead users on a leaderboard table using the Lightning Components for Visualforce JavaScript library. The bulk of the work happens in a scheduled Apex class that calls out to Trailhead and scrapes the profile of users in your Salesforce org and upserting them into a custom Object named `Trailblazer__c`. The page simply queries for and displays the `Trailblazer__c` records. Users can add themselves to the leaderboard by clicking "Add New" at the top right of the page.

![Desktop Desktop](images/screenshot.png "Desktop View")

> **Note:** This works by calling out to Trailhead and parsing the response body of the User's Profile. If Salesforce decides to update/change the HTML of the Trailhead site this could break at any time. If Salesforce ever makes api.trailhead.salesforce.com public, I will update this project to use that instead.

You can deploy this using the [Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm) or [convert it to metadata](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_source.htm) and use the [Force.com Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool_install.htm). 

## Adding New Trailblazers

To add new Users to the leaderboard, you'll need to first ensure their Trailhead profile is public. In the "About Me"
section at the bottom of their profile, click the Edit icon in the top right and check "Profile Public". Now all you have to do is copy the Salesforce Id from the end of the URL and paste it into the Id field on the Leaderboard by clicking "Add New" (or if they have set up a custom handle, copy that i.e. "matruff"). The code will automatically pull in the User's data and upsert a new `Trailblazer__c` record for them, along with their related `Badge__c` records.

## Scheduling

You can schedule `PopulateTrailblazers.cls` to run at various intervals to update your `Trailblazer__c` by simply going to *Setup > Custom Code > Apex Classes > Schedule Apex*. Give your job a name, select `PopulateTrailblazers.cls` as your Apex class, and choose a run date/time.

Or, you can simply run it manually from anonymous Apex:

```$java
PopulateTrailblazers pop = new PopulateTrailblazers();
```

## Possible Updates for the Future

- ~~Add Badges~~
- ~~Move from Bootstrap 3 to Salesforce Lightning Design System~~
- ~~Test/Mock Classes~~
- ~~Convert to Lightning Web Components ⚡~~
- ~~Convert to Salesforce DX Project~~
- Trailhead public API? (If they ever let us use it)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
