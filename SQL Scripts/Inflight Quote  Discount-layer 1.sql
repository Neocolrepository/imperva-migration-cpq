/* 
	Who	When		What
   ==========================================================================================
	KB		MMDD22	Initial view created
	JZ		121222	Added header information for tracking changes and formatted code
	CM		122822	Replicating new discount logic to In-Flight Quote Lines
	JZ		010823	Changing directIndirect to Direct/Indirect which is the actual picklist value
	JZ		010823	Reverted Direct/Indirect back to directIndirect
	CM		010923	Changing all directIndirect values to Incentive
	CM		020823	USING OLD TABLES  
	KB      021323  Added new case statement to map the Transportation = Quotation Adjustment
	KB   	021323	Removed _23 from the table name
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
-- CREATE or replace VIEW SIEBEL_INFLIGHT_QL_DISCOUNTS AS
SELECT
	DISTINCT T1.AGR_LINE_ID,
	T1.AGREE_ID,
	T1.AGR_NUM,
	T1.AGR_OPP_ID,
	T1.AGREE_STATUS,
	T1.AGREE_SUB_STATUS,
	--T1.ORA_AGR_ID,
	T1.BILL_TO_ADDR_SITE,
	T1.SHIP_TO_ADDR_SITE,
	T1.AGR_START_DT,
	T1.AGR_END_DT,
	T1.CURRENCY,
	T1.AGR_BILL_TYPE,
	T1.AGR_BILL_FREQ,
	T1.AGR_ACCT_AUTH,
	T1.AGREE_TYPE,
	T1.AGREE_SALES_REP_CD,
	--T1.AGR_LINE_ID,
	--T1.AGR_LINE_STATUS,
	T1.ASSET_NUM,
	T1.ASSET_SF_ID,
	T1.QTY_REQ,
	T1.AGR_LINE_START_DT,
	T1.AGR_LINE_END_DT,
	T1.MONTH_PRICE,
	T1.ADJ_UNIT_PRI,
	T1.LINE_SPN,
	T1.INT_MODEL,
	T2.AGREE_ID AS AGREE_ID_DISCOUNTS,
	T2.AGREE_NUM AS AGREE_NUM_DISCOUNTS,
	T2.AGREE_DT,
	T2.AGREE_STATUS AS AGREE_STATUS_DISCOUNTS,
	T2.AGR_LINE_ID AS AGR_LINE_ID_DISCOUNTS,
	T2.AGR_MOD_ID,
	T2.AGR_MOD_DESC,
    CASE 
      WHEN AGR_MOD_DESC = 'Discount' THEN 'Incentive'
      WHEN AGR_MOD_DESC = 'Division Authorized' THEN 'Incentive'
      WHEN AGR_MOD_DESC = 'Purchase Agreement' THEN 'Non-System Purchase Agreement'
      WHEN AGR_MOD_DESC = 'Region/Country' THEN 'Incentive'
      WHEN AGR_MOD_DESC = 'Special Negotiated' THEN 'Incentive'
      WHEN AGR_MOD_DESC = 'Var Parts Consumption Disc' THEN 'Incentive'
      WHEN AGR_MOD_DESC = 'direct/Indirect' THEN 'Incentive'
      WHEN AGR_MOD_DESC = 'Transportation' THEN 'Quotation Adjustment'
      ELSE AGR_MOD_DESC
    END AS Discount_Description,
	T2.AGR_MOD_PERCENT,
	T2.AGR_MOD_AMT,
	T2.AGR_MOD_INT_COMMENTS,
	T2.AGR_MOD_PROM_CD,
	CASE 
		WHEN (AGR_MOD_PERCENT IS NULL AND AGR_MOD_AMT IS NULL) THEN null
		WHEN AGR_MOD_PERCENT IS NULL THEN 'Amount'
		WHEN AGR_MOD_AMT IS NULL THEN 'Percent'
	END AS Discount_Method
FROM INTFUSER.TMP_AGR_DATA_PRD_QUT T1
JOIN INTFUSER.TMP_AGR_MOD_DET_QUT T2
ON T1.AGR_LINE_ID = T2.AGR_LINE_ID;