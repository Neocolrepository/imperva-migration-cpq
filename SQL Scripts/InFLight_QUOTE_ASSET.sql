/* 
	Who	When	What
    	==========================================================================================
	KB	MMDDYY	Initial view created
	JZ	122022	Updated format of code and added header
	CM	122122	added AGR_BUS_UNIT for ISG pricing
	CM 	011823	added AGR_INT_COMMENTS
	CM	020123	added AGR_LINE_COMMENTS
	JZ  020223  Added logic for ISG_Duration. Only used for ISG lines
	KB	030323	Added AGR_LINE_INT_COMMENTS
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
CREATE OR REPLACE VIEW SIEBEL_InFLight_QUOTE_ASSET AS
SELECT 
	AGREE_ID,
	AGR_NUM,
	AGR_NAME,
	AGR_OPP_ID,
	AGREE_STATUS,
	ora_ord_num,
	BILL_TO_ADDR_SITE,
	SHIP_TO_ADDR_SITE,
	CURRENCY,
	AGR_BILL_TYPE,
	AGR_BILL_FREQ,
	AGR_ACCT_AUTH,
	AGREE_TYPE,
	AGREE_SALES_REP_CD,
	AGR_LINE_ID,
	AGR_LINE_STATUS,
	ASSET_NUM,
	ASSET_SF_ID,
	QTY_REQ,
	AGR_LINE_START_DT,
	AGR_LINE_END_DT,
	ROUND(MONTHS_BETWEEN(AGR_LINE_END_DT, AGR_LINE_START_DT),4) AS ISG_Duration,
	MONTH_PRICE,
	ADJ_UNIT_PRI,
	LINE_SPN,
	INT_MODEL,
	AGR_CAL_INT_MO,
	PRICE_OVRD_FLG,
	AGR_BUS_UNIT,
  	AGR_INT_COMMENTS,
	AGR_LINE_COMMENTS,
	AGR_LINE_INT_COMMENTS
FROM INTFUSER.TMP_AGR_DATA_PRD_QUT;