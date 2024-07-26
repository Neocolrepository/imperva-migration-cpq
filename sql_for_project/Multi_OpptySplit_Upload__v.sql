/*
	Who	When		What
    ===========================================================================
    JZ	7/11/24		Initial view creation
    JZ	7/24/24		Added Case statement for Sales_Team_Picklist__c
	JZ	7/26/24		Removed Case statement as client opened up the picklist because they need the historical values
					Dropped lines that had a 0 Split as these don't need to flow through.
    ===========================================================================
*/

-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW Multi_OpptySplit_Upload__v AS


SELECT 
	`Source.Id`,
    `New.Id`,
	`Source.Split__c`,
    `New.SplitPercentage`,
    `Source.Deal_Owner__c`,
    `New.SplitOwnerId`,
    `Source.Opportunity__c`,
    `New.OpportunityId`,
    `Source.Commissionable_Bookings__c`,
    `New.Commissionable_Bookings__c`,
    `Source.CreatedById`,
    `Source.CreatedDate`,
    `Source.Distributor_PAE__c`,
    `New.Distributor_PAE__c`,
    `Source.Reseller_PAE__c`,
    `New.Reseller_PAE__c`,
    `Source.First_Year_Split_Amount_Service__c`,
    `New.Split_ACV__c`,
    `Source.Region_Text__c`,
    `New.Region_Text__c`,
    `Source.Sales_Team_Picklist__c`,
    `New.Sales_Team_Picklist__c`,
	`Source.CaseSafeID_OPSplit__c`,
    `New.CaseSafeID_OPSplit__c`,
    `Source.Territory__c`,
    `New.Territory__c`,
    `Source.Trigger_Territory_Update__c`,
    `New.Trigger_Territory_Update__c`

FROM `op_split_comparison_multi__v` 
WHERE `Source.Id` IS NOT NULL
AND `Source.Split__c` > 0



 