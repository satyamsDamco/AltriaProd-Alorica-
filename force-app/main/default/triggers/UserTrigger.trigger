trigger UserTrigger on User (after insert, after update) {

    if(trigger.isAfter) {
        if(UserTriggerHandler.isFirstTime) {
            UserTriggerHandler.isFirstTime = false;
        	UserTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}