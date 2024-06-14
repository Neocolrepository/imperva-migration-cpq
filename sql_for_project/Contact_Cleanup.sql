SELECT *  FROM motive_contacts

WITH Zuora_Account_Info AS 
(
SELECT 
	`Account: CRM Account ID` AS '[Zuora CRM]',
    `Bill To: Address 1` AS '[Zuora Bill To Addr]',
    `Bill To: Postal Code` AS '[Zuora Zip]',
    `Bill To: 
FROM cache_Zuora_Account
)