trigger ProductLineTrigger on Product_Line__c (after insert, after update) {

    if(trigger.isAfter) {
        if(ProductLineTriggerHandler.isFirstTime) {
            ProductLineTriggerHandler.isFirstTime = false;
            ProductLineTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}