List<Trailblazer__c> trailblazersToUpdate = [
    SELECT Id 
    FROM Trailblazer__c
];

for (Trailblazer__c blazer : trailblazersToUpdate) {
    blazer.Name = null;
    blazer.Points__c = null;
    blazer.Rank__c = null;
    blazer.Profile_Link__c = null;
    blazer.Certifications__c = null;
    blazer.Badges__c = null;
    blazer.Trails__c = null;
    blazer.Superbadges__c = null;
}

update trailblazersToUpdate;