trigger SurveyConfigurationTrigger on Survey_Configuration__c (after insert, after update) {

    if(trigger.isAfter) {
        if(SurveyConfigurationTriggerHandler.isFirstTime) {
            SurveyConfigurationTriggerHandler.isFirstTime = false;
            SurveyConfigurationTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}