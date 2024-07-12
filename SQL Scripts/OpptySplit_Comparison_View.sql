/*
	Who	When		What
    ===========================================================================
    JZ	7/11/24		Initial view creation

    ===========================================================================
*/

-- Comment out Create line when testing to not blow away working view
-- CREATE OR REPLACE VIEW Multi_OpptySplit_Upload__v AS

SELECT * 
FROM `op_split_comparison__v` 

WHERE `Source.Opportunity__c` IN (
SELECT OpportunityId FROM MultiSplitOpps
)
 