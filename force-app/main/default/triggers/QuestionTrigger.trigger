trigger QuestionTrigger on Question__c (after insert, after update) {

    if(trigger.isAfter) {
        if(QuestionTriggerHandler.isFirstTime) {
            QuestionTriggerHandler.isFirstTime = false;
            QuestionTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}