/* 
	Who	When	What
    ==========================================================================================
	JZ	122222	Initial view created
					Script still needs the Layer1 script to run first
					Updated Logic to add an error flag for use in Kettle if we have 4 discounts
					Updated Logic to separate Discounts and Surcharges
					Trimmed down number of fields to minimum fields required
	CM	122822	Additional Case statement added in previous view (Quote Discount-layer 1)
					Replaced AGR_MOD_DESC with Discount_Description
	JZ	010823	Updated Discount CTE to make Discount positive instead of negative before it goes to Salesforce
	JZ	012023	Updated view to correct sign for amounts
					Added logic to account for Quotation Adjustment
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
-- CREATE OR REPLACE VIEW Siebel_Discounts_Combined_v AS

WITH AGREEMENT_DISCOUNTS_CTE AS
(
-- Percent Discounts Aggregated
SELECT AGR_LINE_ID_DISCOUNTS,Discount_Description, 'Percent' AS DISC_METHOD, (SUM(AGR_MOD_PERCENT)*-1) DISCOUNT_TOTAL, COUNT(*) COUNT_NUM FROM SIEBEL_QUOTE_LINE_DISCOUNTS
WHERE (DISCOUNT_METHOD = 'Percent' AND AGR_MOD_PERCENT < 0.0)
GROUP BY AGR_LINE_ID_DISCOUNTS,Discount_Description

UNION
-- Amount Discounts
SELECT AGR_LINE_ID_DISCOUNTS,Discount_Description, 'Amount' AS DISC_METHOD , (SUM(AGR_MOD_AMT)*-1) DISCOUNT_TOTAL, COUNT(*) COUNT_NUM FROM SIEBEL_QUOTE_LINE_DISCOUNTS
WHERE DISCOUNT_METHOD = 'Amount'
GROUP BY AGR_LINE_ID_DISCOUNTS,Discount_Description
),

AGREEMENT_SURCHARGE_CTE AS
(
-- Uplifts
SELECT AGR_LINE_ID_DISCOUNTS,Discount_Description, 'Uplift' AS DISC_METHOD, SUM(AGR_MOD_PERCENT) DISCOUNT_TOTAL, COUNT(*) COUNT_NUM FROM SIEBEL_QUOTE_LINE_DISCOUNTS
WHERE (DISCOUNT_METHOD = 'Percent' AND AGR_MOD_PERCENT > 0.0)
GROUP BY AGR_LINE_ID_DISCOUNTS,Discount_Description
),

ROW_NUMBER_DISCOUNT_CTE AS 
(
SELECT 
	ROW_NUMBER() OVER (PARTITION BY AGR_LINE_ID_DISCOUNTS ORDER BY AGR_LINE_ID_DISCOUNTS, Discount_Description) AS RANK_X,
AGR_LINE_ID_DISCOUNTS, Discount_Description, DISC_METHOD, DISCOUNT_TOTAL  FROM AGREEMENT_DISCOUNTS_CTE
ORDER BY RANK_X
)

/*
ROW_NUMBER_SURCHARGE_CTE AS 
(SELECT 
	ROW_NUMBER() OVER (PARTITION BY AGR_LINE_ID_DISCOUNTS ORDER BY AGR_LINE_ID_DISCOUNTS, Discount_Description) AS RANK_X,
AGR_LINE_ID_DISCOUNTS, Discount_Description, DISC_METHOD, DISCOUNT_TOTAL  FROM AGREEMENT_SURCHARGE_CTE
ORDER BY RANK_X)
*/

/*
-- For testing logic. Just replace AGR_LINE_ID_DISCOUNTS with record you want to review
SELECT * FROM ROW_NUMBER_DISCOUNT_CTE  
WHERE Discount_Description != 'directIndirect'
ORDER BY AGR_LINE_ID_DISCOUNTS, RANK_X
*/

-- Need these fields
-- RANK_X,AGR_LINE_ID_DISCOUNTS,AGR_MOD_AMT,AGR_MOD_PERCENT,Discount_Method,Discount_Description,

SELECT 
	DISTINCT
	T1.AGR_LINE_ID_DISCOUNTS,
	S1.DISCOUNT_TOTAL AS Surcharge,
	S1.DISC_METHOD AS Surcharge_Description,
	CASE 
		WHEN J1.DISC_METHOD = 'Uplift' THEN 'Uplift'
		WHEN (J1.DISCOUNT_TOTAL > 0 AND J1.DISC_METHOD = 'Amount') THEN 'Quotation Adjustment'
		ELSE J1.Discount_Description
	END AS AGR_MOD_DESC_1,
	CASE 
		WHEN J1.DISC_METHOD = 'Uplift' THEN NULL
		ELSE J1.DISC_METHOD
	END AS DISCOUNT_METHOD_1,
		CASE 
		WHEN J1.DISC_METHOD != 'Uplift' THEN J1.DISCOUNT_TOTAL 
		ELSE NULL
	END AS DISCOUNT_1,
	CASE 
		WHEN J2.DISC_METHOD = 'Uplift' THEN 'Uplift'
		WHEN (J2.DISCOUNT_TOTAL > 0 AND J2.DISC_METHOD = 'Amount') THEN 'Quotation Adjustment'
		ELSE J2.Discount_Description
	END AS AGR_MOD_DESC_2,
	CASE 
		WHEN J2.DISC_METHOD = 'Uplift' THEN NULL
		ELSE J2.DISC_METHOD
	END AS DISCOUNT_METHOD_2,
		CASE 
		WHEN J2.DISC_METHOD != 'Uplift' THEN J2.DISCOUNT_TOTAL 
		ELSE NULL
	END AS DISCOUNT_2,
	CASE 
		WHEN J3.DISC_METHOD = 'Uplift' THEN 'Uplift'
		WHEN (J3.DISCOUNT_TOTAL > 0 AND J3.DISC_METHOD = 'Amount') THEN 'Quotation Adjustment'
		ELSE J3.Discount_Description
	END AS AGR_MOD_DESC_3,
	CASE 
		WHEN J3.DISC_METHOD = 'Uplift' THEN NULL
		ELSE J3.DISC_METHOD
	END AS DISCOUNT_METHOD_3,
		CASE 
		WHEN J3.DISC_METHOD != 'Uplift' THEN J3.DISCOUNT_TOTAL 
		ELSE NULL
	END AS DISCOUNT_3,
	CASE 
		WHEN J4.DISC_METHOD = 'Uplift' THEN 'Uplift'
		WHEN (J4.DISCOUNT_TOTAL > 0 AND J4.DISC_METHOD = 'Amount') THEN 'Quotation Adjustment'
		ELSE J4.Discount_Description
	END AS AGR_MOD_DESC_4,
	CASE 
		WHEN J4.DISC_METHOD = 'Uplift' THEN NULL
		ELSE J4.DISC_METHOD
	END AS DISCOUNT_METHOD_4,
		CASE 
		WHEN J4.DISC_METHOD != 'Uplift' THEN J4.DISCOUNT_TOTAL 
		ELSE NULL
	END AS DISCOUNT_4,
	-- We should never have a 4th Discount. If we do, set this field to 'Y' for error handling in Kettle
	CASE 
		WHEN J4.DISC_METHOD <> 'Uplift' THEN 'Y'
		ELSE 'N'
	END AS Extra_Discount  
	
FROM SIEBEL_QUOTE_LINE_DISCOUNTS T1

-- Join the second Discount to the first
LEFT JOIN ROW_NUMBER_DISCOUNT_CTE J1
	ON (T1.AGR_LINE_ID_DISCOUNTS = J1.AGR_LINE_ID_DISCOUNTS)
	AND J1.RANK_X = 1
	
-- Join the second Discount to the first
LEFT JOIN ROW_NUMBER_DISCOUNT_CTE J2
	ON (T1.AGR_LINE_ID_DISCOUNTS = J2.AGR_LINE_ID_DISCOUNTS)
	AND J2.RANK_X = 2


-- Join the third Discount to the first
LEFT JOIN ROW_NUMBER_DISCOUNT_CTE J3
	ON (T1.AGR_LINE_ID_DISCOUNTS = J3.AGR_LINE_ID_DISCOUNTS)
	AND J3.RANK_X = 3


-- Join the fourth Discount to the first
LEFT JOIN ROW_NUMBER_DISCOUNT_CTE J4
	ON (T1.AGR_LINE_ID_DISCOUNTS = J4.AGR_LINE_ID_DISCOUNTS)
	AND J4.RANK_X = 4

-- Join the Surcharge to the discounts
LEFT JOIN AGREEMENT_SURCHARGE_CTE S1
	ON (T1.AGR_LINE_ID_DISCOUNTS = S1.AGR_LINE_ID_DISCOUNTS)
	

