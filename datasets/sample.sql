BEGIN TRANSACTION;
CREATE TABLE "Badge__c" (
	sf_id VARCHAR(255) NOT NULL, 
	"Date_Earned__c" VARCHAR(255), 
	"Icon_Link__c" VARCHAR(255), 
	"Path__c" VARCHAR(255), 
	"Points__c" VARCHAR(255), 
	"Title__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Upsert_Key__c" VARCHAR(255), 
	trailblazer__c VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
CREATE TABLE "Trailblazer__c" (
	sf_id VARCHAR(255) NOT NULL, 
	"Name" VARCHAR(255), 
	"Badges__c" VARCHAR(255), 
	"Certifications__c" VARCHAR(255), 
	"Company_Institution__c" VARCHAR(255), 
	"Job_Role__c" VARCHAR(255), 
	"Job_Title__c" VARCHAR(255), 
	"Points__c" VARCHAR(255), 
	"Profile_Handle__c" VARCHAR(255), 
	"Profile_Id__c" VARCHAR(255), 
	"Profile_Link__c" VARCHAR(255), 
	"Profile_Photo__c" VARCHAR(255), 
	"Rank_Badge_Link__c" VARCHAR(255), 
	"Rank__c" VARCHAR(255), 
	"Superbadges__c" VARCHAR(255), 
	"Trailblazer_Since__c" VARCHAR(255), 
	"Trails__c" VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjgAAC','Mat Ruff','113.0','5.0','Sierra-Cedar','Developer','Senior Consultant/Developer','111725.0','matruff','0051I000004UgTlQAK','https://trailblazer.me/id/matruff','https://trailblazer.me/profilephoto/7291I000000Jm2C/M','https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png','Ranger','4.0','','7.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjhAAC','Jonathan Dalbey','23.0','0.0','Carvana','Developer','Developer','31874.0','jdalbey','0051I000006UehUQAS','https://trailblazer.me/id/jdalbey','https://trailblazer.me/resource/1549581942000/astro','https://trailhead.salesforce.com/assets/ranks/adventurer-b26177109714fa42d5df7c792e28f39696a6f5ce7ff7464dd27c48bd56e2a94b.png','Adventurer','0.0','','1.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjiAAC','Sudipta Deb','427.0','10.0','Appirio, a Wipro company','Architect','Technical Architect','229125.0','sudeb1','0051I000004GQWYQA4','https://trailblazer.me/id/sudeb1','https://trailblazer.me/profilephoto/7291I000000PkWD/M','https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png','Ranger','6.0','April 28, 2014','60.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjjAAC','Jesica Biecher','245.0','5.0','Delivery Hero','Administrator','Salesforce Administrator','186950.0','jesicabiecher','0051I000004ZIHHQA4','https://trailblazer.me/id/jesicabiecher','https://trailblazer.me/profilephoto/7291I000000cFZu/M','https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png','Ranger','8.0','January 22, 2018','31.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjkAAC','Ash Sehgal','106.0','5.0','KPMG Advisory Services','Architect','Senior Director','78130.0','ashsehgal','0051I000004VPoAQAW','https://trailblazer.me/id/ashsehgal','https://trailblazer.me/profilephoto/7291I000000Jdl3/M','https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png','Ranger','0.0','September 17, 2015','4.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjlAAC','Guha Arumugam','352.0','9.0','Acumen Solutions','Developer','Senior Technical Consultant','180325.0','guha','0051I000004ZOolQAG','https://trailblazer.me/id/guha','https://trailblazer.me/profilephoto/7291I000000QgIT/M','https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png','Ranger','4.0','December 18, 2013','42.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjmAAC','Dave Pattison 🌩️','818.0','7.0','Hewlett-Packard Enterprise','Architect','Salesforce Architect','475362.0','dpattison','0051I000004GeW8QAK','https://trailblazer.me/id/dpattison','https://trailblazer.me/profilephoto/7291I000000JJvm/M','https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png','Ranger','12.0','July 16, 2018','165.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjnAAC','Piyush Singh','21.0','0.0','Salesforce','Developer','AMTS','11750.0','realflash','0051I000004azJeQAI','https://trailblazer.me/id/realflash','https://trailblazer.me/resource/1549581942000/astro','https://trailhead.salesforce.com/assets/ranks/adventurer-b26177109714fa42d5df7c792e28f39696a6f5ce7ff7464dd27c48bd56e2a94b.png','Adventurer','0.0','June 12, 2018','1.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjoAAC','Sayali Kakade','211.0','0.0','Ivision Software Pvt. Ltd.','Developer','','89837.0','skakade1','0051I000004Y304QAC','https://trailblazer.me/id/skakade1','https://trailblazer.me/resource/1549581942000/astro','https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png','Ranger','0.0','May 8, 2018','19.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjpAAC','Anthony Sanchez','32.0','2.0','Sierra-Cedar','Developer','Salesforce Developer','46012.0','macgoober','0051I000004XSMrQAO','https://trailblazer.me/id/macgoober','https://trailblazer.me/profilephoto/7291I000000ea5k/M','https://trailhead.salesforce.com/assets/ranks/mountaineer-121da937d748d9978cc681de9e6d968486ec25ab8a26ddd42a6c50a2c418ea7e.png','Mountaineer','1.0','November 17, 2014','1.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjqAAC','Simon Plumaj','6.0','0.0','Mode 7 LLC','Developer','Owner','11025.0','splumaj','0051I0000053fOMQAY','https://trailblazer.me/id/splumaj','https://trailblazer.me/profilephoto/7291I000000egRr/M','https://trailhead.salesforce.com/assets/ranks/explorer-e43e2a6fc4d869bf9c2990c5a2c265678c45d1a2fd90e7b89010869d0b63798d.png','Explorer','0.0','November 22, 2015','0.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjrAAC','Anil Kumar','53.0','0.0','Woolworths Group','Executive','','43112.0','akumar282','0051I000004UeWJQA0','https://trailblazer.me/id/akumar282','https://trailblazer.me/profilephoto/7291I000001DJ48/M','https://trailhead.salesforce.com/assets/ranks/expeditioner-f2c1a62ba3ce2395efbffdb4df00942a7e55d7da12e73b02805a03c05395bd73.png','Expeditioner','0.0','June 1, 2017','5.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjsAAC','Thangavel Rajan B','70.0','1.0','Tavant','Consultant','Senior Manager','53225.0','thangavelb','0051I000004afEjQAI','https://trailblazer.me/id/thangavelb','https://trailblazer.me/profilephoto/7291I000000HzHa/M','https://trailhead.salesforce.com/assets/ranks/expeditioner-f2c1a62ba3ce2395efbffdb4df00942a7e55d7da12e73b02805a03c05395bd73.png','Expeditioner','0.0','May 3, 2018','4.0');
INSERT INTO "Trailblazer__c" VALUES('a011k000003LzjtAAC','Micah Graf','130.0','1.0','Carvana','Developer','','75225.0','mgraf2','0051I000004biWxQAI','https://trailblazer.me/id/mgraf2','https://trailblazer.me/profilephoto/7291I000000RbFv/M','https://trailhead.salesforce.com/assets/ranks/ranger-c52b81631f16e35fe619b58215db59f7be4d8809acd253606ad9701186bba218.png','Ranger','1.0','October 19, 2016','7.0');
COMMIT;
