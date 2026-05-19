trigger SurveyTrigger on Survey__c (after insert, after update) {

    if(trigger.isAfter) {
        if(SurveyTriggerHandler.isFirstTime) {
            SurveyTriggerHandler.isFirstTime = false;
            SurveyTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}