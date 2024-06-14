-- Initial View Date: 5/3/23 (JZ)
/* 
    Who		When	What
    ========================================================
	JZ		050323	Replicated code for Bill To Contact Fix
					Turned script into View. This can be used to feed Kettle or used
					to dataload into Salesforce without Kettle.
                    Updated View to only produce the fields required for updating Salesforce
*/

-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW SoldToContactToFix__v AS

-- To test the master portion of the code, select only the code inside of the CTE.
-- This will allow you to see more of the fields needed for validation.
WITH SHIP_TO_CTE AS
(
SELECT
	DISTINCT T1.`Zuora_Subscription_Number`,
	T1.`SF_Contract_Id`, -- Used in Salesforce Update
    T1.`SF.Con.atg migrated`,
    T2.`Subscription: Name`,
    T2.`Account: ID` AS '[Sub: Account: ID]',
    T3.`Account: ID` AS '[Acct: Account: ID]',
    T3.`Account: KT_Id` AS '[Acct: KT_Id]',
    T3.`Account: CRM Account ID` AS '[Zoura CRM Id]',
    T3.`Sold To: Address 1` AS '[Zuora STA 1]', -- Used in Salesforce Update
    T3.`Sold To: City` AS '[Zuora STA City]', -- Used in Salesforce Update
    T3.`Sold To: Country` AS '[Zuora STA Country]', -- Used in Salesforce Update
    T3.`Sold To: Postal Code` AS '[Zuora STA Zip]', -- Used in Salesforce Update
    T3.`Sold To: State/Province` AS '[Zuora STA State]', -- Used in Salesforce Update
    T3.`Sold To: Work Email` AS '[Zuora STA Email]',
    T3.`Sold To: ID` AS '[Zuora Sold To: ID]',
    T4.`Contact ID` AS '[SF Contact ID]', -- Used in Salesforce Update
    T4.`Account ID` AS '[SF Account Id]', 
    T4.`Email` AS '[SF Contact Email]',
    T4.`KT_Id` AS '[SF Contact KT_Id]'
FROM `cache_Contracts_To_Fix` T1

LEFT JOIN `cache_Zuora_Subscriptions` T2 ON
(T1.`Zuora_Subscription_Number` = T2.`Subscription: Name`)
LEFT JOIN `cache_Zuora_Account` T3 ON
(T2.`Account: ID` = T3.`Account: ID`)
LEFT JOIN `cache_SalesforceContactExtract_new` T4 ON
(T3.`Account: CRM Account ID` = T4.`Account ID`  AND T3.`Sold To: Work Email` = T4.`Email`)
WHERE T4.`Contact ID` IS NOT NULL
ORDER BY 1,2
)

-- Now just pull the fields we need to update Salesforce
SELECT 
	DISTINCT `SF_Contract_Id`,
    `[Zuora STA 1]`,
    `[Zuora STA City]`,
    `[Zuora STA Country]`,
    `[Zuora STA Zip]`,
    `[Zuora STA State]`,
    `[SF Contact ID]`
FROM `SHIP_TO_CTE`
ORDER BY 1