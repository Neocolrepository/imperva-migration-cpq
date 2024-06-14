-- Initial View Date: 8/12/21 (JZ)
/* 
    Who		When		What
    ========================================================
	JZ		081221		Added logic for single account to test against (remove later)
    JZ		081721		Updated Join Logic to map correctly
    JZ				   	Updated view with proper external IDs
	JZ					Renamed some aliases to better align with what they mean
    JZ		082021		Added Rate Plan Order Line Number
    JZ				   	Added IS_LAST_SEGMENT check
	JZ		  		  	Removed account limiting where clause. Limiter moved to Kettle
	JZ					Cast dates form datetime to date format
    KZ		082721		Changed PRPL JOIN from LEFT to INNER. Reduced records returned for test Subscription
    JZ		090921		Updated logic for [Group: Start/End Date] as client identified correct field for this
    JZ	 	 	 	 	Added logic to exclude Evergreen records
    JZ		091421		Added Product Rate Plan: ID to out pulled data
	KB		092021 		Added Subcription: Name 
    JZ		092121		Added PRPL.Primary clause to view
    JZ		092821		Cloned previous view
						Updated view with feedback from Brian @ KT
                        Changed LEFT JOIN to INNER JOIN
                        Removed JOIN against cache_Zuora_Product
                        Moved Evergreen search to ON clause of SUB JOIN statement
	KB		093021		Added additional fields in the view as follows
						Payment Term, Zuora Subscription Number
	JZ		100521		Added EXCLUDE for accounts with KT_Id that are '--
						Added EXCLUDE for account that had "CADmigrate" as the KT_Id
	KB		100821		Added following fields according to the Mapping Document, which are as follows 
						Renewal Term, Initial Term,Ship_To_Street,Ship_To_City, Ship_To_Country, Ship_To_Postal_Code, Ship_To_State
	JZ		100921		Removed Subscription: Name as additional field in view as it was already in view as [Line: Subscription Name]
	KB		101121		added condition to remove "Shipping charges", based on Brandon's feedback
    JZ		101121		Added RPC.`Rate Plan Charge: Order Number` AS '[Line: RPC Order Number]'
    KB		101521		Added MRR, Prorate Multiplier (It is returning an incorrect value), List Price,Regular Price,Renewal Price,Special Price,Customer Price,Net Price 
    JZ		101821		Correct field Alias conventions to align with strategy 
						Update End Dates to align with how SFDC uses dates by subtracting 1 day from the end date
                        Corrected Shipping City (was being sent to Street)
                        Added Shipping Street (was not being pulled in)
	JZ		101921		Added Account Payment Method
						Removed computed fields from view after the Prorate Multiplier field
	JZ		102521		Added case statement for [Line: Billing Frequency] to cover known mappings
    JZ		102821		Added more case statements for [Line:: Billing Frequency]
    JZ 		110821		Update Proration logic per logic provided by client
						Added logic for [Line: RPC.ARR]
	JZ		111021		Updated logic for Prorate Multiplier
    JZ		111221		Updated WHERE clause to exclude Credit lines
						Added ROUND() to Prorate Multiplier with 4 decimal places
                        Updated logic for Prorate Multiplier to remove Interval 1 day from Year and Month items
	JZ		111521		Updated logic to refine how discount is collected
    JZ		111821		Worked with Brandon to update logic to collapse query and get RPCU/RPCD joins correct
						Added logic to get BillTo and SoldTo Contact IDs
	JZ		112921		Updated view with Default Payment Method: Type now coming from Account table
    JZ		113021		Added additional fields for SoldTo which need to be populated on Contract
    JZ		120221		Updated view due to rename of Contact table to cache_SalesforceContactExtract
    JZ		120921		Added Subscription: Auto Renew AS '[Group: Auto Renew?]' to fields we are pulling through
    JZ		121421		New ProductRatePlanLookup table introduced to replace old one
    BW/JZ	122321		Updated JOIN logic for when we have Hardware and Software on the same rate plan
    JZ		122721		Updated WHERE clause to remove 'Amendment Type = Remove a Product'
    JZ		010722		Updated final where clause with new uddate
    JZ		011022		Added new table for account exclusions and logic to select from it
    JZ		011522		Added Inclusion table during go-live for missing records
    JZ		020822		Added new Inclusion table for Delta migrations
						Removed Inclusion table from go-live
	JZ		030722		Updated view for bug found with RPDC section bringing through expired discounts
    JZ		030822		Updated view again to correctly fxi bug with RPCD section
    JZ		031122		Added Group Billing Frequency for Contract level data
    JZ		032222		Removed Group Billing Frequency as this is not correct
    JZ		041222		Removed RPC.Start/End Dates as they aren't used at all
    JZ		052422		Added logic for Vendir Financing Name
   
*/
-- Need to check view for Cartesian join causing duplication
-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW Zuora_Staging_with_Product_v2 AS

SELECT
    ACC.`Account: KT_Id` AS '[Account: External ID]',
    ACC.`Account: Name` AS '[Account: Name]',
    ACC.`Account: Payment Term` As '[Account: Payment Term]', 
    ACC.`Default Payment Method: Type` AS '[Account: Payment Method]',
    VFM.`name` AS '[Vendor Finance: Name]',
    CASE WHEN RPCT.`Rate Plan Charge Tier: Currency` = 'US Dollar' THEN 'USD'
        WHEN RPCT.`Rate Plan Charge Tier: Currency` = 'Canadian Dollar' THEN 'CAD'
    END AS '[Zuora.CurrencyIsoCode]',
    SUB.`Subscription: ID` AS '[Group: External ID]', -- This one must be unique between migrations
    RPCT.`Rate Plan Charge Tier: ID` AS '[Line: RPCT: ID]',
    RPCT.`Rate Plan: ID` AS '[Line: External ID]', -- This one must be unique between migrations
    RPC.`Rate Plan Charge: Charge Number` AS '[Line: Rate Plan Charge Number]', 
    RPC.`Rate Plan Charge: Order Number` AS '[Line: RPC Order Number]', 
    RP.`Rate Plan: Name` AS '[Line: Product: Product Name]',
    RPC.`Rate Plan Charge: Name` AS '[Line: Rate Plan Charge: Name]',
    CASE WHEN RP.`Rate Plan: Order Line Number` NOT LIKE 'DM%' THEN LPAD(RP.`Rate Plan: Order Line Number`, 10, '0') 
		 ELSE RP.`Rate Plan: Order Line Number`
         END AS 'Rate Plan: Order Line Number',
    PRPL.`Product_Code__c` AS '[Line: Product: Product Code]',
    SUB.`Subscription: Auto Renew` AS '[Group: Auto Renew?]',
    RPC.`Rate Plan Charge: Bill Cycle Day` AS '[Group: Bill Day of Month]',
    DATE(SUB.`Subscription: Term Start Date`) AS '[Group: Start Date]',
    DATE_SUB(DATE(SUB.`Subscription: Term End Date`), INTERVAL 1 DAY) AS '[Group: End Date]',
    DATE(RPC.`Rate Plan Charge: Effective Start Date`) AS '[Line: Start Date]',
    DATE_SUB(DATE(RPC.`Rate Plan Charge: Effective End Date`), INTERVAL 1 DAY) AS '[Line: End Date]',
    RPC.`Rate Plan Charge: Quantity` AS '[Line: Quantity]',
    RPCT.`Rate Plan Charge Tier: Price` AS '[Line: Unit Price]',
    CASE WHEN RPC.`Rate Plan Charge: Billing Period` = 'Month' THEN 'Monthly'
        WHEN RPC.`Rate Plan Charge: Billing Period` = 'Quarter' THEN 'Quarterly'
        WHEN RPC.`Rate Plan Charge: Billing Period` = 'Subscription Term' THEN 'Paid Upfront'
        WHEN RPC.`Rate Plan Charge: Billing Period` = 'Five Years' THEN 'Annual'
        WHEN RPC.`Rate Plan Charge: Billing Period` = 'Week' THEN 'Monthly'
        WHEN RPC.`Rate Plan Charge: Billing Period` = 'Annually' THEN 'Annual'
        ELSE RPC.`Rate Plan Charge: Billing Period`
    END AS '[Line: Billing Frequency]', 
    CASE WHEN RPC.`Rate Plan Charge: Billing Timing` = 'In Advance' THEN 'Advance'
        WHEN RPC.`Rate Plan Charge: Billing Timing` = 'In Arrears'	THEN 'Arrears'
    END AS '[Zuora.BillingTiming]',
    RPCTD.`Rate Plan Charge Tier: Discount Percentage` AS '[Line: Discount Percentage]', 
    SUB.`Subscription: Version` AS '[Line: Subscription: Version]',
    SUB.`Subscription: ID` AS '[Line: Subscription: ID]',
    SUB.`Subscription: Name` AS '[Line: Subscription: Name]',  
    RPC.`Product Rate Plan: ID` AS 'Product Rate Plan: ID', 
    SUB.`Subscription: Renewal Term` AS '[Renewal Term]', 
    SUB.`Subscription: Initial Term` AS '[Initial Term]', 
    RPC.`Rate Plan Charge: Charge Type` AS '[Line: RPC.Charge Type]', -- Note for Charge Type: Recurring = Subscription, One-time = Asset, Usage not in scope
    RPC.`Rate Plan Charge: MRR` AS '[Line: RPC.MRR]',
    RPC.`Rate Plan Charge: MRR` * 12 AS '[Line: RPC.ARR]',
    RPC.`Rate Plan Charge: Created Date` AS '[Line: RPC.Created Date]',
    ACC.`Bill To: Address 1` AS '[Line: BillToStreet]',
    ACC.`Bill To: City` AS '[Line: BillToCity]',
    ACC.`Bill To: Country` AS '[Line: BillToCountry]',
    ACC.`Bill To: Postal Code` AS '[Line: BillToPostalCode]',
    ACC.`Bill To: State/Province` AS '[Line: BillToState]',
    ACC.`Sold To: Address 1` AS '[Line: SoldToStreet]',
    ACC.`Sold To: City` AS '[Line: SoldToCity]',
    ACC.`Sold To: Country` AS '[Line: SoldToCountry]',
    ACC.`Sold To: Postal Code` AS '[Line: SoldToPostalCode]',
    ACC.`Sold To: State/Province` '[Line: SoldToState]',
    SCEB.`ID` AS '[Line: BillToContactId]',
    RPC.`Rate Plan Charge: Shipping Street` AS '[Line: ShipToStreet]',
    RPC.`Rate Plan Charge: Shipping City` AS '[Line: ShipToCity]',
    RPC.`Rate Plan Charge: Shipping Country` AS '[Line: ShipToCountry]',
    RPC.`Rate Plan Charge: Shipping Zip Code` AS '[Line: ShipToPostalCode]',
    RPC.`Rate Plan Charge: Shipping State` AS '[Line: ShipToState]',
    SCES.`ID` AS '[Line: SoldToContactId]',
    ROUND((((YEAR(DATE_SUB(RPC.`Rate Plan Charge: Effective End Date`, INTERVAL 1 DAY)) - YEAR(RPC.`Rate Plan Charge: Effective Start Date`)) * 12) + 
    (MONTH(DATE_SUB(RPC.`Rate Plan Charge: Effective End Date`, INTERVAL 1 DAY)) - MONTH(RPC.`Rate Plan Charge: Effective Start Date`)) + 
    (IF(((DAY(DATE_SUB(RPC.`Rate Plan Charge: Effective End Date`, INTERVAL 1 DAY)) - DAY(RPC.`Rate Plan Charge: Effective Start Date`)) < -1), -1, 0))) + 
    ((DATEDIFF(
        DATE_ADD(DATE_SUB(RPC.`Rate Plan Charge: Effective End Date`, INTERVAL 1 DAY), INTERVAL 1 DAY), 
        (DATE_ADD(RPC.`Rate Plan Charge: Effective Start Date` , INTERVAL (((YEAR(DATE_SUB(RPC.`Rate Plan Charge: Effective End Date`, INTERVAL 1 DAY)) - YEAR(RPC.`Rate Plan Charge: Effective Start Date`)) * 12) + 
        (MONTH(DATE_SUB(RPC.`Rate Plan Charge: Effective End Date`, INTERVAL 1 DAY)) - MONTH(RPC.`Rate Plan Charge: Effective Start Date`)) + 
        (IF(((DAY(DATE_SUB(RPC.`Rate Plan Charge: Effective End Date`, INTERVAL 1 DAY)) - DAY(RPC.`Rate Plan Charge: Effective Start Date`)) < -1), -1, 0))) MONTH)))) / (365 / 12)),4)
    AS '[Line: Prorate Multiplier]'

FROM `cache_Zuora_Account` ACC -- Indexed Account

INNER JOIN `cache_Zuora_Subscriptions` SUB -- Indexed Subscriptions
	ON (SUB.`Account: ID` = ACC.`Account: ID`
    AND (SUB.`Subscription: Current Term` != 'Evergreen' OR SUB.`Subscription: Current Term` IS NULL)) 

INNER JOIN `cache_Zuora_RatePlan` RP -- Indexed Rate Plan
	ON (RP.`Subscription: ID` = SUB.`Subscription: ID`)

INNER JOIN `cache_Zuora_RatePlanCharge` RPC  -- Rate Plan Charge Unit
	ON (RPC.`Rate Plan: ID` = RP.`Rate Plan: ID`
    AND RPC.`Rate Plan Charge: Is Last Segment` = 1 
    AND RPC.`Rate Plan Charge: Charge Model` != 'Discount-Percentage')

INNER JOIN `cache_Zuora_RatePlanChargeTier` RPCT -- Join RPCTUnit Pricing(RPC.ID) up with the Rate Plan Charge Tier(RPC.ID)
	ON (RPC.`Rate Plan Charge: ID` = RPCT.`Rate Plan Charge: ID`)

/* replacement join. IF PRPL.MatchRatePlanCharge = 1, then must also join on the Product Rate Plan Charge ID */
INNER JOIN `cache_ProductRatePlanLookup` PRPL -- Indexed
	ON (PRPL.`Zuora_Rate_Plan_ID__c` = RPC.`Product Rate Plan: ID`
		AND PRPL.`Primary` = 1
        AND (
			((PRPL.`Rate_Plan_Charge_ID_Per_Unit_Price__c` = RPC.`Product Rate Plan Charge: ID`) AND (PRPL.`MatchRatePlanCharge` = 1)) OR
            (PRPL.`MatchRatePlanCharge` = '') OR
            (PRPL.`MatchRatePlanCharge` IS NULL)
            )
		)

LEFT JOIN `cache_Zuora_RatePlanCharge` RPCD -- Rate Plan Charge Discount
	ON ((RPCD.`Rate Plan: ID` = RP.`Rate Plan: ID`  )
    AND (RPCD.`Rate Plan Charge: Is Last Segment` = 1)
    AND (RPCD.`Rate Plan Charge: Charge Model` = 'Discount-Percentage')
    AND (
		(RPC.`Rate Plan Charge: Charge Type` = 'One-Time')
		OR (
			(RPC.`Rate Plan Charge: Charge Type` = 'Recurring')
			AND (RPCD.`Rate Plan Charge: Effective End Date` >= curdate())
			)
		)
	)
    
LEFT JOIN `cache_Zuora_RatePlanChargeTier` RPCTD -- Join RPCT Discount Percent(RPC.ID) up with the Rate Plan Charge Tier(RPC.ID)
	ON (RPCTD.`Rate Plan Charge: ID` = RPCD.`Rate Plan Charge: ID`)
    
LEFT JOIN (SELECT DISTINCT `ID`, `ACCOUNTID`, `ACCOUNT.KT_ID__C`, `EMAIL`
			FROM `cache_SalesforceContactExtract`
            GROUP BY `ACCOUNT.KT_ID__C`, `EMAIL` ) SCEB
		ON ( ACC.`Account: KT_Id` = SCEB.`ACCOUNT.KT_ID__C`
		AND ACC.`Bill To: Work Email` = SCEB.`EMAIL`)
    
LEFT JOIN (SELECT DISTINCT `ID`, `ACCOUNTID`, `ACCOUNT.KT_ID__C`, `EMAIL`
			FROM `cache_SalesforceContactExtract`
            GROUP BY `ACCOUNT.KT_ID__C`, `EMAIL` ) SCES
		ON ( ACC.`Account: KT_Id` = SCES.`ACCOUNT.KT_ID__C`
		AND ACC.`Bill To: Work Email` = SCES.`EMAIL`) 
        
INNER JOIN `cache_VF_Mapping` VFM
    ON (SUB.`Subscription: Invoice Owner ID` = VFM.`id`)
	

WHERE (RPC.`Rate Plan Charge: Charge Type` = 'One-Time' OR (RPC.`Rate Plan Charge: Charge Type` = 'Recurring' AND  RPC.`Rate Plan Charge: Effective End Date` >= curdate()))
AND RPC.`Rate Plan Charge: Name` NOT LIKE '%Ship%'
AND RPC.`Rate Plan Charge: Name` NOT LIKE '%Credit%'
AND ((NOT (`RP`.`Rate Plan: Amendment Type` LIKE 'Remove a Product')) OR (`RP`.`Rate Plan: Amendment Type` IS NULL))
AND (SUB.`Subscription: Invoice Owner ID` = VFM.`id` AND ACC.`Account: Payment Term` = 'VF')
AND SUB.`Subscription: ID` IN (SELECT `Subscription: ID` FROM `cache_Zuora_Delta_Includes`)
-- AND SUB.`Subscription: ID` = '8a1297377f555341017f69f7e34e4bc2'




