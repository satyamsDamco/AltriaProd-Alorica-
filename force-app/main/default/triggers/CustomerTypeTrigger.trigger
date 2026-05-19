trigger CustomerTypeTrigger on Customer_Type__c (after insert, after update) {

    if(trigger.isAfter) {
        if(CustomerTypeTriggerHandler.isFirstTime) {
            CustomerTypeTriggerHandler.isFirstTime = false;
            CustomerTypeTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
        
    }
}