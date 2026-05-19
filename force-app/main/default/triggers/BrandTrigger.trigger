trigger BrandTrigger on Brand__c (after insert, after update) {

    if(trigger.isAfter) {
        if(BrandTriggerHandler.isFirstTime) {
            BrandTriggerHandler.isFirstTime = false;
            BrandTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}