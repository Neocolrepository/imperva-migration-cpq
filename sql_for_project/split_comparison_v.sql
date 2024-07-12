/*
	Who	When		What
    ===========================================================================
    JZ	7/5/24		Initial view creation
    JZ	7/8/24		Fixed issues with field naming.
					Updated to only fields with values to edit
	JZ	7/11/24 	Fixed Deal_Owner__c to SplitOwnerId field mapping
    ===========================================================================
*/

-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW OP_Split_Comparison__v AS

SELECT LOS.`Source.AccountManagerIsCurrentUser__c`,
	OOTB.`New.AccountManagerIsCurrentUser`,
    CASE 
		WHEN LOS.`Source.AccountManagerIsCurrentUser__c` = OOTB.`New.AccountManagerIsCurrentUser` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS AccountManagerIsCurrentUser_Match,
	LOS.`Source.AppSec_Split_ACV__c`,
    OOTB.`New.AppSec_Split_ACV__c`,
    CASE 
		WHEN LOS.`Source.AppSec_Split_ACV__c` = OOTB.`New.AppSec_Split_ACV__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS	AppSec_Split_ACV_Match,
    LOS.`Source.CaseSafeID_OPSplit__c`,
    OOTB.`New.CaseSafeID_OPSplit__c`,
    CASE 
		WHEN LOS.`Source.CaseSafeID_OPSplit__c` = OOTB.`New.CaseSafeID_OPSplit__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS CaseSafeID_OPSplit_Match,   
    LOS.`Source.Commission_Close_Date__c`,
    OOTB.`New.Commission_Close_Date__c`,
    CASE 
		WHEN LOS.`Source.Commission_Close_Date__c` = OOTB.`New.Commission_Close_Date__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Commission_Close_Date_Match,
    LOS.`Source.Commission_Type__c`,
    OOTB.`New.Commission_Type__c`,
    CASE 
		WHEN LOS.`Source.Commission_Type__c` = OOTB.`New.Commission_Type__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Commission_Type_Match,  
    LOS.`Source.Commissionable_Bookings_Amount__c`,
    OOTB.`New.Commissionable_Bookings_Amount__c`,
    CASE 
		WHEN LOS.`Source.Commissionable_Bookings_Amount__c` = OOTB.`New.Commissionable_Bookings_Amount__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Commissionable_Bookings_Amount_Match,
    LOS.`Source.Commissionable_Bookings__c`,
    OOTB.`New.Commissionable_Bookings__c`,
     CASE 
		WHEN LOS.`Source.Commissionable_Bookings__c` = OOTB.`New.Commissionable_Bookings__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Commissionable_Bookings_Match,   
    LOS.`Source.CreatedById`,
    OOTB.`New.CreatedByID`,
    CASE 
		WHEN LOS.`Source.CreatedById` = OOTB.`New.CreatedById` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS CreatedById_Match,   
    LOS.`Source.CreatedDate`,
    OOTB.`New.CreatedDate`,
     CASE 
		WHEN LOS.`Source.CreatedDate` = OOTB.`New.CreatedDate` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS CreatedDate_Match,  
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
    LOS.`Source.Is_Split_Territory_Active__c`,
    OOTB.`New.Is_Split_Territory_Active__c`,
    CASE 
		WHEN LOS.`Source.Is_Split_Territory_Active__c` = OOTB.`New.Is_Split_Territory_Active__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Is_Split_Territory_Active_Match,   
    LOS.`Source.Non_Recurring_Services_Split_ACV__c`,
    OOTB.`New.Non_Recurring_Services_Split_ACV__c`,
    CASE 
		WHEN LOS.`Source.Non_Recurring_Services_Split_ACV__c` = OOTB.`New.Non_Recurring_Services_Split_ACV__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Non_Recurring_Services_Split_ACV_Match,   
    LOS.`Source.Opportunity__c`,
    OOTB.`New.OpportunityId`,
    CASE 
		WHEN LOS.`Source.Opportunity__c` = OOTB.`New.OpportunityId` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Opportunity_Match,   
    LOS.`Source.Other_Split_ACV__c`,
    OOTB.`New.Other_Split_ACV__c`,
    CASE 
		WHEN LOS.`Source.Other_Split_ACV__c` = OOTB.`New.Other_Split_ACV__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Other_Split_ACV_Match,   
    LOS.`Source.Product__c`,
    OOTB.`New.Product__c`,
    CASE 
		WHEN LOS.`Source.Product__c` = OOTB.`New.Product__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Product_Match,  
    LOS.`Source.Recurring_Services_Split_ACV__c`,
    OOTB.`New.Recurring_Services_Split_ACV__c`,
    CASE 
		WHEN LOS.`Source.Recurring_Services_Split_ACV__c` = OOTB.`New.Recurring_Services_Split_ACV__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Recurring_Services_Split_ACV_Match,   
    LOS.`Source.Region_Text_Formula__c`,
    OOTB.`New.Region_Text_Formula__c`,
    CASE 
		WHEN LOS.`Source.Region_Text_Formula__c` = OOTB.`New.Region_Text_Formula__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Region_Text_Formula_Match,   
    LOS.`Source.Region_Text__c`,
    OOTB.`New.Region_Text__c`,
    CASE 
		WHEN LOS.`Source.Region_Text__c` = OOTB.`New.Region_Text__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Region_Text_Match,  
    LOS.`Source.RelatedSEIsCurrentUser__c`,
    OOTB.`New.RelatedSEIsCurrentUser__c`,
    CASE 
		WHEN LOS.`Source.RelatedSEIsCurrentUser__c` = OOTB.`New.RelatedSEIsCurrentUser__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS RelatedSEIsCurrentUser_Match,   
    LOS.`Source.RelatedSEManagerIsCurrentUser__c`,
    OOTB.`New.RelatedSEManagerIsCurrentUser__c`,
    CASE 
		WHEN LOS.`Source.RelatedSEManagerIsCurrentUser__c` = OOTB.`New.RelatedSEManagerIsCurrentUser__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS RelatedSEManagerIsCurrentUser_Match,   
    LOS.`Source.Related_SE_ID__c`,
    OOTB.`New.Related_SE_ID__c`,
    CASE 
		WHEN LOS.`Source.Related_SE_ID__c` = OOTB.`New.Related_SE_ID__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Related_SE_ID_Match,   
    LOS.`Source.Related_SE_Manager_Name__c`,
    OOTB.`New.Related_SE_Manager_Name__c`,
    CASE 
		WHEN LOS.`Source.Related_SE_Manager_Name__c` = OOTB.`New.Related_SE_Manager_Name__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Related_SE_Manager_Name_Match,   
    LOS.`Source.Related_SE_Manager__c`,
    OOTB.`New.Related_SE_Manager__c`,
    CASE 
		WHEN LOS.`Source.Related_SE_Manager__c` = OOTB.`New.Related_SE_Manager__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Related_SE_Manager_Match,   
    LOS.`Source.Related_SE_Role__c`,
    OOTB.`New.Related SE Role`,
    CASE 
		WHEN LOS.`Source.Related_SE_Role__c` = OOTB.`New.Related SE Role` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Related_SE_Role_Match,   
    LOS.`Source.Related_SE__c`,
    OOTB.`New.Related_SE__c`,
    CASE 
		WHEN LOS.`Source.Related_SE__c` = OOTB.`New.Related_SE__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Related_SE_Match,    
    LOS.`Source.Reseller_PAE__c`,
    OOTB.`New.Reseller_PAE__c`,
    CASE 
		WHEN LOS.`Source.Reseller_PAE__c` = OOTB.`New.Reseller_PAE__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Reseller_PAE_Match,  
    LOS.`Source.Sales_Team_Geo__c`,
    OOTB.`New.Sales_Team_Geo__c`,
    CASE 
		WHEN LOS.`Source.Sales_Team_Geo__c` = OOTB.`New.Sales_Team_Geo__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Sales_Team_Geo_Match,   
    LOS.`Source.Sales_Team_Picklist__c`,
    OOTB.`New.Sales_Team_Picklist__c`,
    CASE 
		WHEN LOS.`Source.Sales_Team_Picklist__c` = OOTB.`New.Sales_Team_Picklist__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Sales_Team_Picklist_Match,   
    LOS.`Source.Sales_Team__c`,
    OOTB.`New.Sales_Team__c`,
    CASE 
		WHEN LOS.`Source.Sales_Team__c` = OOTB.`New.Sales_Team__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Sales_Team_Match,   
    LOS.`Source.Service_ACV_Split_OPSplit__c`,
    OOTB.`New.Service_ACV_Split_OPSplit`,
    CASE 
		WHEN LOS.`Source.Service_ACV_Split_OPSplit__c` = OOTB.`New.Service_ACV_Split_OPSplit` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Service_ACV_Split_OPSplit_Match,   
    LOS.`Source.Service__c`,
    OOTB.`New.Service__c`,
     CASE 
		WHEN LOS.`Source.Service__c` = OOTB.`New.Service__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Service_Match,  
    LOS.`Source.Split_ACVE__c`,
    OOTB.`New.Split_ACVE__c`,
    CASE 
		WHEN LOS.`Source.Split_ACVE__c` = OOTB.`New.Split_ACVE__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Split_ACVE_Match,   
    LOS.`Source.Split_Amount__c`,
    OOTB.`New.SplitAmount`,
    CASE 
		WHEN LOS.`Source.Split_Amount__c` = OOTB.`New.SplitAmount` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS SplitAmount_Match,   
    LOS.`Source.Split_Pipeline_Amount__c`,
    OOTB.`New.Split_Pipelime_Amount__c`,
    CASE 
		WHEN LOS.`Source.Split_Pipeline_Amount__c` = OOTB.`New.Split_Pipelime_Amount__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Split_Pipeline_Amount_Match,   
    LOS.`Source.Split__c`,
    OOTB.`New.SplitPercentage`,
    CASE 
		WHEN LOS.`Source.Split__c` = OOTB.`New.SplitPercentage` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS SplitPercentage_Match,   
    LOS.`Source.Subscription_First_Year__c`,
    OOTB.`New.Subscription_First_Year__c`,
    CASE 
		WHEN LOS.`Source.Subscription_First_Year__c` = OOTB.`New.Subscription_First_Year__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Subscription_First_Year_Match,   
    LOS.`Source.Subscription__c`,
    OOTB.`New.Subscription__c`,
    CASE 
		WHEN LOS.`Source.Subscription__c` = OOTB.`New.Subscription__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Subscription_Match,  
    LOS.`Source.Support_First_Year__c`,
	OOTB.`New.Support_First_Year__c`,
    CASE 
		WHEN LOS.`Source.Support_First_Year__c` = OOTB.`New.Support_First_Year__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Support_First_Year_Match,    
    LOS.`Source.Support__c`,
    OOTB.`New.Support__c`,
    CASE 
		WHEN LOS.`Source.Support__c` = OOTB.`New.Support__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Support_Match,   
    LOS.`Source.Territory_ID__c`,
    OOTB.`New.Territory_ID__c`,
    CASE 
		WHEN LOS.`Source.Territory_ID__c` = OOTB.`New.Territory_ID__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Territory_ID_Match,   
    LOS.`Source.Territory_Validation__c`,
    OOTB.`New.Territory_Validation__c`,
    CASE 
		WHEN LOS.`Source.Territory_Validation__c` = OOTB.`New.Territory_Validation__c` THEN 'TRUE' 
		ELSE 'FALSE'
    END AS Territory_Validation_Match,   
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
FROM `ootb_OpSplits` OOTB

-- LEFT OUTER JOIN `ootb_OpSplits` OOTB
LEFT OUTER JOIN `imperva_db`.`legacy_OpSplits` LOS
ON ( LOS.`Source.Opportunity__c` = OOTB.`New.OpportunityId`)
ORDER BY `New.OpportunityId`
