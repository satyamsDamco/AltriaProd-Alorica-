/**/
trigger IssueAdjustmentUpdate on Issue_Adjustment__c (before insert, after insert) {
    
    if(Trigger.isInsert && Trigger.isBefore){
        IssueAdjustmentHelper obj = new IssueAdjustmentHelper();
        obj.updateSequence(Trigger.new); 
    }
    
    if(Trigger.isInsert && Trigger.isAfter){
        IssueAdjustmentHelper obj = new IssueAdjustmentHelper();
        obj.updateIssueData(Trigger.new); 
    }    
}