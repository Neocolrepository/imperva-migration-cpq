/*
	Who	When		What
    ===========================================================================
    JZ	7/11/24		Initial view creation

    ===========================================================================
*/

-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW Multi_OpptySplit_Upload__v AS


SELECT 
	`op_split_comparison__v`.`Source.Id`,
    `op_split_comparison__v`.`New.Id`,
	`op_split_comparison__v`.`Source.Split__c`,
    `op_split_comparison__v`.`New.SplitPercentage`,
    `op_split_comparison__v`.`Source.Deal_Owner__c`,
    `op_split_comparison__v`.`New.SplitOwnerId`,
    `op_split_comparison__v`.`Source.Opportunity__c`,
    `op_split_comparison__v`.`New.OpportunityId`,
    `op_split_comparison__v`.`Source.Commissionable_Bookings__c`,
    `op_split_comparison__v`.`New.Commissionable_Bookings__c`,
    `op_split_comparison__v`.`Source.CreatedById`,
    `op_split_comparison__v`.`Source.CreatedDate`,
    `op_split_comparison__v`.`Source.Distributor_PAE__c`,
    `op_split_comparison__v`.`New.Distributor_PAE__c`,
    `op_split_comparison__v`.`Source.Reseller_PAE__c`,
    `op_split_comparison__v`.`New.Reseller_PAE__c`,
    `op_split_comparison__v`.`Source.First_Year_Split_Amount_Service__c`,
    `op_split_comparison__v`.`New.Split_ACV__c`,
    `op_split_comparison__v`.`Source.Region_Text__c`,
    `op_split_comparison__v`.`New.Region_Text__c`,
    `op_split_comparison__v`.`Source.Sales_Team_Picklist__c`,
    `op_split_comparison__v`.`New.Sales_Team_Picklist__c`,
	`op_split_comparison__v`.`Source.CaseSafeID_OPSplit__c`,
    `op_split_comparison__v`.`New.CaseSafeID_OPSplit__c`,
    `op_split_comparison__v`.`Source.Territory__c`,
    `op_split_comparison__v`.`New.Territory__c`,
    `op_split_comparison__v`.`Source.Trigger_Territory_Update__c`,
    `op_split_comparison__v`.`New.Trigger_Territory_Update__c`

FROM `op_split_comparison__v` 

WHERE `Source.Opportunity__c` IN (
SELECT OpportunityId FROM MultiSplitOpps
)
-- Meeded to match for Single Oppt Lines
-- AND `Source.Deal_Owner__c` = `New.SplitownerId`
 