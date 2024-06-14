-- Initial View Date: 8/12/21 (JZ)
/* 
    Who	When	What
    ========================================================
	JZ	110921	Initial view creation
    JZ	111221	Added rounding of prices to 4 decimal places
    JZ	111321	Updated Special Price formula
    JZ	111521	Updated logic for Customer Price and Net Price
    JZ	111821	Added BillToContactId and SoldToContactId
    JZ	113021	Added ShipTo data for Subscription
    JZ	120921	Added Group: Auto Renew field
    JZ	122021	Updated logic for MRR/ARR
    JZ	011622	Updated logic to add [Line: Asset Price] calculation
    JZ	031122	Added Group Billing Freqneucy for Contract level data
    JZ	032222	Removed Group Billing Frequency as this is not correct
    JZ	041222	Removed RPC.Start/End Dates as they aren't used at all
    JZ	062122	Add Revpro Line Number into data set
    JZ	062822	Commented out Revpro Line Number, not in data set
    JZ	072522	Uncommented RevPro. Passing as NULL until value is included in future.
    JZ	072722	Updated Legacy RevPro field so that it is distinguishable in migration scripts from SFDC field
*/

-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW Zuora_Staging_with_Pricing_v AS

SELECT
	V1.`[Account: External ID]`,
    V1.`[Account: Name]`,
    V1.`[Finance Vendor ID]`,   
    V1.`[Finance Vendor Name]`,
    V1.`[Account: Payment Term]`,
    V1.`[Account: Payment Method]`,
    V1.`[Zuora.CurrencyIsoCode]`,
    V1.`[Group: External ID]`,
    V1.`[Line: RPCT: ID]`,
    V1.`[Line: External ID]`,
    V1.`[Line: Rate Plan Charge Number]`,
    V1.`[Line: RPC Order Number]`,
    V1.`RPC.Legacy_Revpro_Line_Number__c`,
    V1.`[Line: Product: Product Name]`,
    V1.`[Line: Rate Plan Charge: Name]`,
    V1.`Rate Plan: Order Line Number`,
    V1.`[Line: Product: Product Code]`,
    V1.`[Group: Auto Renew?]`,
    V1.`[Group: Bill Day of Month]`,
    V1.`[Group: Start Date]`,
    V1.`[Group: End Date]`,
    V1.`[Line: Start Date]`,
    V1.`[Line: End Date]`,
    V1.`[Line: Quantity]`,
    V1.`[Line: Unit Price]`,
    V1.`[Line: Billing Frequency]`,
    V1.`[Zuora.BillingTiming]`,
    V1.`[Line: Discount Percentage]`,
    V1.`[Line: Subscription: Version]`,
    V1.`[Line: Subscription: ID]`,
    V1.`[Line: Subscription: Name]`,
    V1.`[Line: Subscription: Invoice Owner ID]`,
    V1.`Product Rate Plan: ID`,
    V1.`[Renewal Term]`,
    V1.`[Initial Term]`,
    V1.`[Line: RPC.Charge Type]`,
	V1.`[Line: RPC.MRR]`,
    V1.`[Line: RPC.ARR]`,
    V1.`[Line: RPC.Created Date]`,
    V1.`[Line: BillToStreet]`,
    V1.`[Line: BillToCity]`,
    V1.`[Line: BillToCountry]`,
    V1.`[Line: BillToPostalCode]`,
    V1.`[Line: BillToState]`,
    V1.`[Line: BillToContactId]`,
	V1.`[Line: SoldToStreet]`,
    V1.`[Line: SoldToCity]`,
    V1.`[Line: SoldToCountry]`,
    V1.`[Line: SoldToPostalCode]`,
    V1.`[Line: SoldToState]`,
	V1.`[Line: SoldToContactId]`,
    V1.`[Line: ShipToStreet]`,
    V1.`[Line: ShipToCity]`,
    V1.`[Line: ShipToCountry]`,
    V1.`[Line: ShipToPostalCode]`,
    V1.`[Line: ShipToState]`,
    V1.`[Line: Prorate Multiplier]`,
    round((V1.`[Line: RPC.MRR]` / V1.`[Line: Quantity]` * V1.`[Line: Prorate Multiplier]`), 4) AS '[Line: SBQQ__ListPrice__c]',
    round((V1.`[Line: RPC.MRR]` / V1.`[Line: Quantity]` * V1.`[Line: Prorate Multiplier]`), 4) AS '[Line: SBQQ__RegularPrice__c]',
    round(V1.`[Line: RPC.MRR]` /  V1.`[Line: Quantity]`, 4) AS '[Line: SBQQ__SpecialPrice__c]',
    CASE
		WHEN (`[Line: Discount Percentage]`  = '' OR `[Line: Discount Percentage]` IS NULL)
		THEN
			round(((V1.`[Line: RPC.MRR]` * (1-0/100) / V1.`[Line: Quantity]`) * V1.`[Line: Prorate Multiplier]`), 4)
		ELSE
			round(((V1.`[Line: RPC.MRR]` * (1 - (V1.`[Line: Discount Percentage]`/100)) / V1.`[Line: Quantity]`) * V1.`[Line: Prorate Multiplier]`), 4)  
	END AS '[Line: SBQQ__NetPrice__c]',
	CASE
		WHEN (`[Line: Discount Percentage]`  = '' OR `[Line: Discount Percentage]` IS NULL)
		THEN
			round(((V1.`[Line: RPC.MRR]` * (1-0/100) / V1.`[Line: Quantity]`) * V1.`[Line: Prorate Multiplier]`), 4)
		ELSE
			round(((V1.`[Line: RPC.MRR]` * (1 - (V1.`[Line: Discount Percentage]`/100)) / V1.`[Line: Quantity]`) * V1.`[Line: Prorate Multiplier]`), 4)
	END  AS '[Line: SBQQ__CustomerPrice__c]',
	CASE
		WHEN (`[Line: Discount Percentage]`  = '' OR `[Line: Discount Percentage]` IS NULL)
		THEN
			round((V1.`[Line: RPC.MRR]`), 4)
		ELSE
			round((V1.`[Line: RPC.MRR]` * (1 - (V1.`[Line: Discount Percentage]`/100))), 4)  
    END AS '[Line: OSCPQ_Net_MRR__c]',
	CASE
		WHEN (`[Line: Discount Percentage]`  = '' OR `[Line: Discount Percentage]` IS NULL)
		THEN
			round((V1.`[Line: RPC.MRR]`), 4) * 12
		ELSE
			round((V1.`[Line: RPC.MRR]` * (1 - (V1.`[Line: Discount Percentage]`/100))), 4)  * 12
    END AS '[Line: OSCPQ_Net_ARR__c]',
    CASE
            WHEN
                (V1.`[Line: RPC.Charge Type]` != 'One-Time')
            THEN
                NULL
            WHEN
                ((V1.`[Line: Discount Percentage]` = '') OR (V1.`[Line: Discount Percentage]` IS NULL))
            THEN
                ROUND((V1.`[Line: Unit Price]`),4)
            ELSE 
				ROUND((V1.`[Line: Unit Price]` * (1 - (V1.`[Line: Discount Percentage]` / 100))),4)
        END AS `[Line: Asset Price]`

FROM `Zuora_Staging_with_Product_v2` V1
-- WHERE V1.`[Group: External ID]` = '8a129e727f8775b0017f8c86671a37a5'