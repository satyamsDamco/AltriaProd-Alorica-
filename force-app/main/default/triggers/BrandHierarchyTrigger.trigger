trigger BrandHierarchyTrigger on Brand_Hierarchy__c (after insert, after update) {

    if(trigger.isAfter) {
        if(BrandHierarchyTriggerHandler.isFirstTime) {
            BrandHierarchyTriggerHandler.isFirstTime = false;
            BrandHierarchyTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}