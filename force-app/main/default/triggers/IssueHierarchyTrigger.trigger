trigger IssueHierarchyTrigger on Issue_Hierarchy__c (after insert, after update) {

    if(trigger.isAfter) {
        if(IssueHierarchyTriggerHandler.isFirstTime) {
            IssueHierarchyTriggerHandler.isFirstTime = false;
            IssueHierarchyTriggerHandler.createCallout(trigger.new, trigger.newMap);
        }
    }
}