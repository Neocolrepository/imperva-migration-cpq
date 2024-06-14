/* 
	Who	When	What
    	==========================================================================================
	KB	MMDDYY	Initial view created
	JZ	121222	Cleaned up SQL formatting to make it more readable
					Added header information for tracking changes
					Updated SQL to add Order By logic at end. This moves all Surcharges to the top
*/

-- Comment out Create line when testing to not blow away your working view
-- CREATE OR REPLACE VIEW SIEBEL_QUOTE_LINE_DIS AS

WITH cte AS(
	SELECT AGREE_ID_DISCOUNTS, AGREE_NUM_DISCOUNTS,AGREE_DT,AGREE_STATUS_DISCOUNTS,AGR_LINE_ID_DISCOUNTS,AGR_MOD_ID,AGR_MOD_DESC,AGR_MOD_PERCENT,AGR_MOD_AMT,Discount_Method,
      ROW_NUMBER () OVER(PARTITION BY  AGR_LINE_ID_DISCOUNTS ORDER BY AGR_LINE_ID_DISCOUNTS) AS rn
   FROM SIEBEL_QUOTE_LINE_DISCOUNTS)
   
SELECT rn,AGREE_ID_DISCOUNTS, AGREE_NUM_DISCOUNTS,AGREE_DT,AGREE_STATUS_DISCOUNTS,AGR_LINE_ID_DISCOUNTS,AGR_MOD_AMT,AGR_MOD_PERCENT,Discount_Method,AGR_MOD_DESC,AGR_MOD_ID,
	CASE 
		WHEN rn = 1 AND Discount_Method = 'Amount' THEN AGR_MOD_AMT 
		WHEN rn = 1 AND Discount_Method = 'Percent' THEN (AGR_MOD_PERCENT)/100 
	END AS "Modifier_1",
	CASE
		WHEN rn = 2 AND Discount_Method = 'Amount' THEN AGR_MOD_AMT
		WHEN rn = 2 AND Discount_Method = 'Percent' THEN (AGR_MOD_PERCENT)/100 
	END AS "Modifier_2",
	CASE
		WHEN rn = 3 AND Discount_Method = 'Amount'  THEN  AGR_MOD_AMT 
		WHEN rn = 3 AND Discount_Method = 'Percent' THEN (AGR_MOD_PERCENT)/100 
	END AS "Modifier_3",
	CASE 
		WHEN rn = 4 AND Discount_Method = 'Amount'  THEN  AGR_MOD_AMT 
		WHEN rn = 4 AND Discount_Method = 'Percent' THEN (AGR_MOD_PERCENT)/100 
	END AS "Modifier_4",
	CASE 
		WHEN rn = 5 AND Discount_Method = 'Amount'  THEN  AGR_MOD_AMT 
	WHEN rn = 5 AND Discount_Method = 'Percent' THEN (AGR_MOD_PERCENT)/100 
	END AS "Modifier_5"
 FROM cte
 
 ORDER BY CASE 
 	WHEN (AGR_MOD_PERCENT > 0.0 AND DISCOUNT_METHOD = 'Percent') THEN 1
 	ELSE 2
 END