/* 
	Who	When		What
	==========================================================================================
	KB		MMDYY		Initial view created
	JZ		121222	Updated logic to account for additional discounts
						Added header information for tracking changes
	CM		122722	Added Case statement for AGR_MOD_DESC
	CM		010823	Changes to mappings for AGR_MOD_DESC
	JZ		010823	Changing directIndirect to Direct/Indirect which is the actual picklist value
	JZ		010823	Revertec Direct/Indirect back to directIndirect
	CM		010923	Changing all directIndirect values to Incentive
	CM		020823	USING OLD TABLE INTFUSER.TMP_AGR_DATA_PRD_ACT_23  &  INTFUSER.TMP_AGR_MOD_DET_ACT_AGR_23
	KB      021323  Added new case statement to map the Transportation = Quotation Adjustment
	KB   	021323	Removed _23 from the table name
	JZ		031323	Updated code to correct discounting logic
	JZ		031523	Fixed logic for when we have a percent and a 0 amount on the same line
	JZ		032323	Fixed the problem with discount methods not populating correctly.
	JZ		042023	Fixed problem with discounts related to issue tracker #85
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
-- CREATE or replace VIEW SIEBEL_QUOTE_LINE_DISCOUNTS AS

WITH DISCOUNT_LAYER1_CTE AS
(
SELECT 
	CTE1.AGREE_ID AS AGREE_ID_DISCOUNTS,
	CTE1.AGREE_NUM AS AGREE_NUM_DISCOUNTS,
	CTE1.AGREE_DT,
	CTE1.AGREE_STATUS AS AGREE_STATUS_DISCOUNTS,
	CTE1.AGR_LINE_ID AS AGR_LINE_ID_DISCOUNTS,
	CTE1.AGR_MOD_ID,
	CTE1.AGR_MOD_DESC,
	CTE1.AGR_MOD_PERCENT,
 	CASE 
    	WHEN AGR_MOD_AMT > 0 THEN 'Quotation Adjustment'
    	ELSE AGR_MOD_DESC
  	END AS AGR_MOD_DESC_TMP,
	CASE 
		WHEN (AGR_MOD_PERCENT IS NOT NULL AND AGR_MOD_AMT = 0) THEN AGR_MOD_PERCENT
		ELSE AGR_MOD_PERCENT
	END AS Percent_Fix,
	CTE1.AGR_MOD_AMT,
	CASE 
		WHEN (AGR_MOD_PERCENT IS NOT NULL AND AGR_MOD_AMT = 0) THEN NULL
		ELSE AGR_MOD_AMT
	END AS Amount_Fix,
	CTE1.AGR_MOD_INT_COMMENTS,
	CTE1.AGR_MOD_PROM_CD
FROM INTFUSER.TMP_AGR_MOD_DET_ACT_AGR CTE1
WHERE 1=1
)
SELECT
	DISTINCT T1.AGR_LINE_ID,
	T1.AGREE_ID,
	T1.AGR_NUM,
	T1.AGR_OPP_ID,
	T2.AGREE_ID_DISCOUNTS,
	T2.AGREE_NUM_DISCOUNTS,
	T2.AGREE_STATUS_DISCOUNTS,
	T2.AGR_LINE_ID_DISCOUNTS,
	T2.AGR_MOD_ID,
	T2.AGR_MOD_DESC_TMP,
 	CASE 
		WHEN T2.AGR_MOD_DESC_TMP = 'Discount' THEN 'Incentive'
		WHEN T2.AGR_MOD_DESC_TMP = 'Division Authorized' THEN 'Incentive'
    	WHEN T2.AGR_MOD_DESC_TMP = 'Region/Country' THEN 'Incentive'
	 	WHEN T2.AGR_MOD_DESC_TMP = 'Purchase Agreement' THEN 'Non-System Purchase Agreement'
    	WHEN T2.AGR_MOD_DESC_TMP = 'Special Negotiated' THEN 'Incentive'
    	WHEN T2.AGR_MOD_DESC_TMP = 'Var Parts Consumption Disc' THEN 'Incentive'
    	WHEN T2.AGR_MOD_DESC_TMP = 'direct/Indirect' THEN 'Incentive'
    	WHEN T2.AGR_MOD_DESC_TMP = 'Transportation' THEN 'Quotation Adjustment'
    	ELSE T2.AGR_MOD_DESC_TMP
  	END AS Discount_Description,
	T2.Percent_Fix AS AGR_MOD_PERCENT,
	T2.Amount_Fix AS AGR_MOD_AMT,
	T2.AGR_MOD_INT_COMMENTS,
	T2.AGR_MOD_PROM_CD,
	CASE 
		WHEN (T2.Percent_Fix IS NULL AND T2.Amount_Fix IS NULL) THEN null
		WHEN T2.Percent_Fix IS NULL THEN 'Amount'
		WHEN T2.Amount_Fix IS NULL THEN 'Percent'
	END AS Discount_Method
FROM INTFUSER.TMP_AGR_DATA_PRD_ACT T1
JOIN DISCOUNT_LAYER1_CTE T2
ON T1.AGR_LINE_ID = T2.AGR_LINE_ID_DISCOUNTS