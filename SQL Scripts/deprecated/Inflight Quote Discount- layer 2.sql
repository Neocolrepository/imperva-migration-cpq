/* 
	Who	When	What
    	==========================================================================================
	KB	MMDD22	Initial view created
	JZ	121222	Added header information for tracking changes
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away your working view
-- CREATE or replace VIEW SIEBEL_QT_Line_InFlight_DIS AS

with cte as(select AGREE_ID_DISCOUNTS, AGREE_NUM_DISCOUNTS,AGREE_DT,AGREE_STATUS_DISCOUNTS,AGR_LINE_ID_DISCOUNTS,AGR_MOD_ID,
AGR_MOD_DESC,AGR_MOD_PERCENT,AGR_MOD_AMT,Discount_Method,
                    row_number() over(partition by AGR_LINE_ID_DISCOUNTS order by AGR_LINE_ID_DISCOUNTS) as rn
             from SIEBEL_QT_Line_DIS_InFlight)
select rn,AGREE_ID_DISCOUNTS, AGREE_NUM_DISCOUNTS,AGREE_DT,AGREE_STATUS_DISCOUNTS,AGR_LINE_ID_DISCOUNTS,AGR_MOD_AMT,AGR_MOD_PERCENT,Discount_Method,AGR_MOD_DESC,AGR_MOD_ID,
       case 
       when rn = 1 and Discount_Method = 'Amount' then AGR_MOD_AMT 
       when rn = 1 and Discount_Method = 'Percent' then (AGR_MOD_PERCENT)/100 end as "Modifier_1",
       case
       when rn = 2 and Discount_Method = 'Amount' then AGR_MOD_AMT
       when rn = 2 and Discount_Method = 'Percent' then (AGR_MOD_PERCENT)/100 end as "Modifier_2",
       case
       when rn = 3 and Discount_Method = 'Amount'  then  AGR_MOD_AMT 
       when rn = 3 and Discount_Method = 'Percent' then (AGR_MOD_PERCENT)/100 end as "Modifier_3",
       case 
       when rn = 4 and Discount_Method = 'Amount'  then  AGR_MOD_AMT 
       when rn = 4 and Discount_Method = 'Percent' then (AGR_MOD_PERCENT)/100 end as "Modifier_4",
       case 
       when rn = 5 and Discount_Method = 'Amount'  then  AGR_MOD_AMT 
       when rn = 5 and Discount_Method = 'Percent' then (AGR_MOD_PERCENT)/100 end as "Modifier_5"
 from cte;