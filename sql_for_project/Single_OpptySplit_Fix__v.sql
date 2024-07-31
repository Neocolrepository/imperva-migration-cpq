/*
	Who	When		What
    ===========================================================================
    JZ	7/25/24		Initial view creation
					Removed dupes in CASE statement and ordered

    ===========================================================================
*/

-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW Single_OpptySplit_Fix__v AS


SELECT 
	LOS.`Source.Id`,
    OOTB.`New.Id`,
--	`Source.Split__c`,
--    `New.SplitPercentage`,
--    `Source.Deal_Owner__c`,
--    `New.SplitOwnerId`,
   `Source.Sales_Team_Picklist__c`,
    LOS.`Source.Opportunity__c`,
    OOTB.`New.OpportunityId`
--    `Source.Commissionable_Bookings__c`,
--    `New.Commissionable_Bookings__c`,
--    `Source.CreatedById`,
--    `Source.CreatedDate`,
--    `Source.Distributor_PAE__c`,
--    `New.Distributor_PAE__c`,
--    `Source.Reseller_PAE__c`,
--    `New.Reseller_PAE__c`,
--    `Source.First_Year_Split_Amount_Service__c`,
--    `New.Split_ACV__c`,
--    `Source.Region_Text__c`,
--    `New.Region_Text__c`,
--    `Source.Sales_Team_Picklist__c`,
--    `New.Sales_Team_Picklist__c`,
--	  `Source.CaseSafeID_OPSplit__c`,
--    `New.CaseSafeID_OPSplit__c`,
--    `Source.Territory__c`,
--    `New.Territory__c`,
--    `Source.Trigger_Territory_Update__c`,
--    `New.Trigger_Territory_Update__c`

FROM `legacy_OpSplits_Single` LOS
LEFT OUTER JOIN ootb_OpSplits OOTB
ON (LOS.`Source.Opportunity__c` = OOTB.`New.OpportunityId`)


 