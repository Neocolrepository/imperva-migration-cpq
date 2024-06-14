/* 
	Who	When	What
    	==========================================================================================
	KB	MMDD22	Initial view created
	JZ	121222	Added header information for tracking changes
	CM	123022	Different verisons, this is the correct verison
	CM	123022	Added AGR_LINE_COMMENTS field
	CM	011723	Added AGR_INT_COMMENTS and AGR_SYS_HANDLE field
	CM	012323	Added AGR_ADM_CON case statement
  	CM  030723  Moved AGR_OPP_ID to a CASE statement instead of a WHERE statement
  	KB	031023	Removed extra space from the sales office case statement
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
--CREATE or replace VIEW SIEBEL_InFlight_QUOTE AS
SELECT 
AGREE_ID,
AGR_NUM,
AGR_NAME,
AGREE_NUM,
REV_NUM,
AGR_OPP_ID,
  CASE
  WHEN agr_opp_id LIKE ' OPP-%' THEN LTRIM(agr_opp_id)
  WHEN agr_opp_id NOT LIKE 'OPP-%' THEN NULL
  ELSE agr_opp_id
  END AS new_agr_opp_id,
AGREE_STATUS,
AGREE_SUB_STATUS,
BILL_TO_ADDR_SITE,
SHIP_TO_ADDR_SITE,
AGR_START_DT,
AGR_END_DT,
CURRENCY,
AGR_BILL_TYPE,
AGR_BILL_FREQ,
AGR_ACCT_AUTH,
AUTH_CON_SF_ID,
EQP_CON_SF_ID,
INV_CON_SF_ID,
SW_CON_SF_ID,
AGR_CON_SF_ID,
AGREE_TYPE,
    CASE
    WHEN AGREE_TYPE = 'Sold Up-Front' THEN 'Entitlement Only'
    WHEN AGREE_TYPE = 'Ixia Agreement - Standard' THEN 'Standard Agreement'
    ELSE AGREE_TYPE
    END AS new_AGREE_TYPE,
AGREE_SALES_REP_CD,
AGR_SYS_HANDLE,
AGR_LINE_ID,
AGR_LINE_STATUS,
ASSET_NUM,
ASSET_SF_ID,
QTY_REQ,
AGR_LINE_START_DT,
AGR_LINE_END_DT,
MONTH_PRICE,
ADJ_UNIT_PRI,
LINE_SPN,
INT_MODEL, 
ORA_ORD_NUM,
ORACLE_OU,
    CASE
    WHEN ORACLE_OU = 'BRS-OU-7213' AND INT_ADDR_OSN IN ('933841', '1343813') THEN 'BR-BARUERI-11'
    WHEN ORACLE_OU = 'BRS-OU-7213' AND INT_ADDR_OSN = '1354039' THEN 'BR-MANAUS-02'
    ELSE null
    END AS created_Brazil_LOV_Value,
AGR_INV_GRP_ID,
AGR_BP_REF,
AGR_ADM_CON,
    CASE 
    WHEN LENGTH(AGR_ADM_CON) < 8 THEN LPAD(AGR_ADM_CON,8,'0')
    WHEN AGR_ADM_CON LIKE 'A%' THEN LTRIM(AGR_ADM_CON, 'A')
    ELSE AGR_ADM_CON
    END new_AGR_ADM_CON,
AGR_SALES_CON,
AGR_GEN_CON,
CFD_LANG,
EXT_COMMENTS,
AGR_SCOPE,
  CASE
  WHEN AGR_SCOPE = 'Global' THEN 'true' 
  ELSE 'false' 
  END AS new_AGR_SCOPE,
AGR_RENEWED_FROM,
Italy_CIG,
Italy_CUP,
AGR_PAY_TM, 
AGR_LAST_INV_AMT,
AGR_LAST_INV_DT,
AGR_LAST_INV_NUM,
X_QUOTE_DATE,
X_QUOTE_EXPIRY_DATE,
AGR_INV_PRNT_LANG,
AGR_INV_PRINTER,
AGR_INV_FOOT_COMMENTS,
AGR_LINE_INT_COMMENTS,
AGR_LINE_COMMENTS,
AGR_INT_COMMENTS,
PRICE_EFF_DT,
PRICE_OVRD_FLG,
AGR_RESEL_OSID,
int_addr_osn
from INTFUSER.TMP_AGR_DATA_PRD_QUT;