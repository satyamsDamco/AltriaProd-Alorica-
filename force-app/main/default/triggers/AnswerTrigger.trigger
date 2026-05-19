trigger AnswerTrigger on Answer__c (after insert, after update) {

    if(trigger.isAfter) {
        if(AnswerTriggerHandler.isFirstTime) {
            AnswerTriggerHandler.isFirstTime = false;
            AnswerTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}