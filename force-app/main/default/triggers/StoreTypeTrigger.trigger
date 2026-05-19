trigger StoreTypeTrigger on Store_Type__c (after insert, after update) {

    if(trigger.isAfter) {
        if(StoreTypeTriggerHandler.isFirstTime) {
            StoreTypeTriggerHandler.isFirstTime = false;
        	StoreTypeTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}