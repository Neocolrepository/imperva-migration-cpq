/* 
	Who	When		What
	==========================================================================================
	JZ		053023	Initial view created
	JZ		053123	Updated view with partition by to get to Unique Asset Id
	JZ		060123	Updated view to only pull records where the Calibration End Date is null.
					This will only pull through the records we need to update.
	JZ		062023	Added select to view to get null spn from separate table
	
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
-- CREATE or replace VIEW Entitlements_BTS__v AS
WITH ROW_NUMBER_CTE AS 
(
SELECT 
	ROW_NUMBER() OVER (PARTITION BY ENTITLEMENT_ASSETID ORDER BY ENTITLEMENT_ASSETID) AS RANK_X,
ENTITLEMENT_ID, ENTITLEMENT_ASSETID, ENTITLEMENT_PRODUCT_SPN_SKU, ENTITLEMENT_SERVICE_CONTENT__C, ENTITLEMENT_CALIB_END_DATE  FROM CACHE_LOAD_BTS
ORDER BY RANK_X
)

SELECT 
ENTITLEMENT_ID, 
ENTITLEMENT_ASSETID,
ENTITLEMENT_PRODUCT_SPN_SKU, 
ENTITLEMENT_SERVICE_CONTENT__C
FROM ROW_NUMBER_CTE
WHERE ENTITLEMENT_ASSETID IS NOT null 
AND ENTITLEMENT_PRODUCT_SPN_SKU IS NOT NULL
AND RANK_X = 1
AND ENTITLEMENT_CALIB_END_DATE IS NULL
AND ENTITLEMENT_ID IN (SELECT ENTITLEMENT_ID FROM cache_null_spn_sku)
ORDER BY ENTITLEMENT_ASSETID DESC