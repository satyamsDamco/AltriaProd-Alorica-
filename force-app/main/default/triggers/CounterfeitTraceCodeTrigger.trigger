trigger CounterfeitTraceCodeTrigger on CounterfeitTraceCode__c (after insert, after update) {

    if(trigger.isAfter) {
        if(CounterfeitTraceCodeTriggerHandler.isFirstTime) {
            CounterfeitTraceCodeTriggerHandler.isFirstTime = false;
            CounterfeitTraceCodeTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}