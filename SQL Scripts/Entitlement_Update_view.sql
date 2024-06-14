/* 
	Who	When		What
	==========================================================================================
	JZ		061423	Initial view created
	
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
-- CREATE OR REPLACE VIEW ENTITLEMENT_UPDATE_v AS

SELECT 
DISTINCT "Entitlement.Id",
"Entitlement.Name",
"Entitlement.AssetId",
"Entitlement.StartDate",
"Entitlement.EndDate",
"Entitlement.SFCPQ_OAsset",
"OrderAsset.Id",
"OA.Asset_ID",
"OA.Start_Date",
"OA.End_Date",
"OA.Product_SPN_SKU__r.Name",
"OA.OP_r.ContractLineItem_ID"
FROM CACHE_LOAD_SF_ENTITLEMENTS clse 
INNER JOIN CACHE_ORDERASSETS co 
ON clse."Entitlement.AssetId" = co."OA.Asset_ID" 
AND clse."Entitlement.StartDate" = co."OA.Start_Date" 
AND clse."Entitlement.EndDate" =  co."OA.End_Date" 
AND clse."Entitlement.Name" = co."OA.Product_SPN_SKU__r.Name" 




