/*
	Who	When		What
    ===========================================================================
    JZ	7/24/24		Created new Multi-Split version of existing view as we can now tell which are which
    JZ	7/28/24		Updated View to  tighten match by Deal_Owner = Split_Owner

    ===========================================================================
*/

-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW OP_Split_Comparison_Multi__v AS

SELECT 
    LOS.`Source.CaseSafeID_OPSplit__c`,
    OOTB.`New.CaseSafeID_OPSplit__c`,
    CASE 
		WHEN LOS.`Source.CaseSafeID_OPSplit__c` = OOTB.`New.CaseSafeID_OPSplit__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS CaseSafeID_OPSplit_Match,   
    LOS.`Source.Commissionable_Bookings__c`,
    OOTB.`New.Commissionable_Bookings__c`,
     CASE 
		WHEN LOS.`Source.Commissionable_Bookings__c` = OOTB.`New.Commissionable_Bookings__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Commissionable_Bookings_Match,   
    LOS.`Source.CreatedById`,
    OOTB.`New.CreatedByID`,
    LOS.`Source.CreatedDate`,
    OOTB.`New.CreatedDate`,
    LOS.`Source.DataSec_Split_ACV__c`,
	OOTB.`New.DataSec_Split_ACV__c`,
    CASE 
		WHEN LOS.`Source.DataSec_Split_ACV__c` = OOTB.`New.DataSec_Split_ACV__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS DataSec_Split_ACV__c_Match,   
    LOS.`Source.Deal_Owner_Sales_Role_OP_Split__c`,
    OOTB.`New.Deal_Owner_Sales_Role_OP_Split__c`,
    CASE 
		WHEN LOS.`Source.Deal_Owner_Sales_Role_OP_Split__c` = OOTB.`New.Deal_Owner_Sales_Role_OP_Split__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Deal_Owner_Sales_Role_OP_Split__c_Match,   
    LOS.`Source.Deal_Owner__c`,
    OOTB.`New.SplitOwnerId`,
    CASE 
		WHEN LOS.`Source.Deal_Owner__c` = OOTB.`New.SplitOwnerId` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Deal_Owner__c_Match,   
    LOS.`Source.Distributor_PAE__c`,
    OOTB.`New.Distributor_PAE__c`,
    CASE 
		WHEN LOS.`Source.Distributor_PAE__c` = OOTB.`New.Distributor_PAE__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Distributor_PAE__c,   
    LOS.`Source.District__c`,
    OOTB.`New.District__c`,
    CASE 
		WHEN LOS.`Source.District__c` = OOTB.`New.District__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS District_Match,   
    LOS.`Source.First_Year_Split_Amount_Service__c`,
    OOTB.`New.Split_ACV__c`,
    CASE 
		WHEN LOS.`Source.First_Year_Split_Amount_Service__c` = OOTB.`New.Split_ACV__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Split_ACV_Match,   
    LOS.`Source.Id`,
    OOTB.`New.Id`,
    CASE 
		WHEN LOS.`Source.Id` = OOTB.`New.Id` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Id_Match,  
    LOS.`Source.Opportunity__c`,
    OOTB.`New.OpportunityId`,
    CASE 
		WHEN LOS.`Source.Opportunity__c` = OOTB.`New.OpportunityId` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Opportunity_Match,   
    LOS.`Source.Region_Text__c`,
    OOTB.`New.Region_Text__c`,
    CASE 
		WHEN LOS.`Source.Region_Text__c` = OOTB.`New.Region_Text__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Region_Text_Match,  
    LOS.`Source.Reseller_PAE__c`,
    OOTB.`New.Reseller_PAE__c`,
    CASE 
		WHEN LOS.`Source.Reseller_PAE__c` = OOTB.`New.Reseller_PAE__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Reseller_PAE_Match,  
    LOS.`Source.Sales_Team_Picklist__c`,
    OOTB.`New.Sales_Team_Picklist__c`,
    CASE 
		WHEN LOS.`Source.Sales_Team_Picklist__c` = OOTB.`New.Sales_Team_Picklist__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Sales_Team_Picklist_Match,   
    LOS.`Source.Split_Amount__c`,
    OOTB.`New.SplitAmount`,
    CASE 
		WHEN LOS.`Source.Split_Amount__c` = OOTB.`New.SplitAmount` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS SplitAmount_Match,   
    LOS.`Source.Split__c`,
    OOTB.`New.SplitPercentage`,
    CASE 
		WHEN LOS.`Source.Split__c` = OOTB.`New.SplitPercentage` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS SplitPercentage_Match,   
    LOS.`Source.Territory__c`,
    OOTB.`New.Territory__c`,
    CASE 
		WHEN LOS.`Source.Territory__c` = OOTB.`New.Territory__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Territory_Match,   
    LOS.`Source.Trigger_Territory_Update__c`,
    OOTB.`New.Trigger_Territory_Update__c`,
    CASE 
		WHEN LOS.`Source.Trigger_Territory_Update__c` = OOTB.`New.Trigger_Territory_Update__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Trigger_Territory_Update_Match
-- FROM `imperva_db`.`legacy_OpSplits` LOS
FROM `legacy_OpSplits_multi` LOS

LEFT OUTER JOIN `ootb_OpSplits` OOTB
ON ( LOS.`Source.Opportunity__c` = OOTB.`New.OpportunityId` AND LOS.`Source.Deal_Owner__c` = OOTB.`New.SplitOwnerId`)
WHERE `Source.Split__c` > 0
ORDER BY `New.OpportunityId`
