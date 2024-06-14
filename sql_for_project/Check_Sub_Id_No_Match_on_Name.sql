-- CREATE OR REPLACE VIEW Check_Sub_Id_No_Match_on_Name AS

SELECT 
	INC.`Subscription: ID` AS 'Include ID',
	INC.`Subscription: Name` AS 'Include Name',
	SUB.`Subscription: ID` AS 'Subscription ID',
	SUB.`Subscription: Name` AS 'Subscription Name'
  FROM `cache_Zuora_Delta_Includes` INC
  INNER JOIN `cache_Zuora_Subscriptions` SUB -- Indexed Subscriptions
	ON SUB.`Subscription: ID` = INC.`Subscription: ID`
    WHERE SUB.`Subscription: Name` != INC.`Subscription: Name`