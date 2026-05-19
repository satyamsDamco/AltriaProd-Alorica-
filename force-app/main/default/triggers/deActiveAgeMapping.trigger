/*
Created By: Infogain 
Purpose:To deactive age mapping as per zip  
*/
trigger deActiveAgeMapping on Age_Mapping__c (after update) {
        AgeMappingHandler ageObj = new AgeMappingHandler(); 
        ageObj.deActiveMapping(Trigger.newMap, Trigger.oldMap);
}