# Trailhead Leaderboard

## Summary

**Now built using Lightning Web Components!**

This is a simple app that displays Trailhead users on a leaderboard table using Salesforce Lightning
Web Components. The bulk of the work happens in a scheduled Apex class that calls out to a custom
Trailhead API. This API pulls back profile data and inserts it into your Salesforce org in a custom
Object named `Trailblazer__c`. The page simply queries for and displays the `Trailblazer__c` records.
Users can add themselves to the leaderboard by clicking "Add New" at the top right of the page.

![Desktop Desktop](images/screenshot.png "Desktop View")

>**Note:** This works by calling out to a Trailhead middleware API I've created to obtain public
>profile data. If Salesforce decides to update/change the data on the Trailhead site this could
>break at any time.

## Installation

You can deploy this using the [Salesforce SFDX CLI](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)
or [convert it to metadata](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_source.htm)
and use the [Force.com Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool_install.htm). 

## Adding New Trailblazers

To add new Users to the leaderboard, you'll need to first ensure their Trailhead profile is public.
In the "About Me" section at the bottom of their profile, click the Edit icon in the top right and
check "Profile Public", then create a custom handle, if you haven't already. Now all you have to do
is enter your handle into the field on the Leaderboard by clicking "Add New" at the top right. The 
page will automatically pull in the User's data and upsert a new `Trailblazer__c` record for them.

## Scheduling

You can schedule `PopulateTrailblazers.cls` to run at various intervals to update your
`Trailblazer__c` by simply going to *Setup > Custom Code > Apex Classes > Schedule Apex*.
Give your job a name, select `PopulateTrailblazers.cls` as your Apex class, and choose a run
date/time.

Or, you can simply run it manually from anonymous Apex:

``` java
PopulateTrailblazers pop = new PopulateTrailblazers();
```

## Update From an Older Version

The latest version of the leaderboard uses a middleware API that I've built to call directly in 
the Trailhead API to get Profile data. Salesforce has updated Trailhead to use custom User handles
now instead of Profile Ids, which the old leaderboard used to get User data. There's a new field
on `Trailblazer__c` called `Profile_Handle__c` that all callouts use to get data from the API, so
you'll need to populate this for all your users. One way to do this would be to run some anonymous
Apex code to parse the custom handle out of the `Profile_Link__c` field.

``` java
List<Trailblazer__c> trailblazersToUpdate = new List<Trailblazer__c>();

for (Trailblazer__c tb : [SELECT Profile_Link__c FROM Trailblazer__c]) {
    tb.Profile_Handle__c = tb.Profile_Link__c.substringAfter('/id/');
    trailblazersToUpdate.add(tb);
}

update trailblazersToUpdate;
``` 

Another way would be to just manually populate the `Profile_Handle__c` field for all your Trailblazers
in your org, the choice is up to you. The rest of the data will updated automatically once you run
the `PopulateTrailblazers` batch. 

## Possible Updates for the Future

- ~~Add Badges~~
- ~~Move from Bootstrap 3 to Salesforce Lightning Design System~~
- ~~Test/Mock Classes~~
- ~~Convert to Lightning Web Components ⚡~~
- ~~Convert to Salesforce DX Project~~
- ~~Add a custom Trailhead API~~

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
