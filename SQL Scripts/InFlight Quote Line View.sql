/* 
	Who	When	What
    	==========================================================================================
	KB	MMDD22	Initial view created
	JZ	121222	Formatted view and added header information for tracking changes
	CM	011823	Adding AGR_INT_COMMENTS
	JZ  	020223  Added logic for ISG_Duration. Only used for ISG lines
	KB  	020823  Added _23 to the table name till we get the next extract
	CM	021423	Reverted back to original table INTFUSER.TMP_AGR_DATA_PRD_QUT for Mock2
  CM  042123  Added agr_line_int_comments field
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
--CREATE or replace VIEW SIEBEL_InFlightQT_Line AS
SELECT
	AGREE_ID,
	AGR_NUM,
	AGR_NAME,
	AGR_OPP_ID,
	AGREE_STATUS,
	AGREE_SUB_STATUS,
	ora_ord_num,
	BILL_TO_ADDR_SITE,
	SHIP_TO_ADDR_SITE,
	AGR_START_DT,
	AGR_END_DT,
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
	CASE 
		WHEN AGR_BUS_UNIT = 'ISG' THEN ROUND(MONTHS_BETWEEN(AGR_LINE_END_DT, AGR_LINE_START_DT),4) 
		ELSE null
	END AS ISG_Duration,
	MONTH_PRICE,
	ADJ_UNIT_PRI,
	LINE_SPN,
	INT_MODEL,
	AGR_LINE_COMMENTS,
	AGR_BUS_UNIT,
  AGR_INT_COMMENTS,
  agr_line_int_comments
from INTFUSER.TMP_AGR_DATA_PRD_QUT;