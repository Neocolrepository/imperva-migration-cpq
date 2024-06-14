/* 
	Who	When	What
    ==========================================================================================
	JZ	121422	Initial view created
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
-- CREATE OR REPLACE VIEW Siebel_Discounts_Combined_v2 AS
WITH CTE_1 AS 
(
SELECT 
	*
FROM Siebel_Discounts_Combined_v
-- WHERE  AGR_LINE_ID_DISCOUNTS = '1-6JZSGED'
-- WHERE (AGR_MOD_PERCENT > '0.0' AND DISCOUNT_METHOD = 'Percent')
)

SELECT 
	CASE 
		WHEN (AGR_MOD_ID_2 IS NULL AND AGR_MOD_ID_3 IS NULL AND AGR_MOD_ID_4 IS NULL AND AGR_MOD_ID_5 IS NULL) THEN AGR_MOD_ID_1 AS "AGR_MOD_ID"
	END,
	
	D1.AGR_LINE_ID_DISCOUNTS_1,
	D1.AGR_MOD_ID_1,
	CASE 
		WHEN D1.Disc_Method_1 != 'Uplift' THEN D1.AGR_MOD_DESC_1 = NULL
	END,
	CASE 
		WHEN D1.Disc_Method_1 = 'Uplift' THEN D1.Disc_Method_1 
		ELSE NULL
	END AS "Surchage_Desc_1",
	CASE
		WHEN D1.Disc_Method_1 = 'Uplift' THEN D1.AGR_MOD_PERCENT_1 
		ELSE NULL
	END AS "Surcharge_Total_1",
	D1.AGR_MOD_AMOUNT_1,

   
FROM CTE_1 D1 
ORDER BY "Surcharge_Total_1", "Surcharge_Total_2", "Surcharge_Total_3", "Surcharge_Total_4", "Surcharge_Total_5"