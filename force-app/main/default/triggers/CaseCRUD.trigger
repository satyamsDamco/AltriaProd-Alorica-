trigger CaseCRUD on Case (before insert, before update, after insert, after update) {
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        CaseHelper helperObj = new CaseHelper();
        helperObj.calculateOverage(trigger.new);
    } else if(trigger.isAfter) {
        if(CaseHelper.isFirstTime){
            CaseHelper.isFirstTime = false;
            CaseHelper helperObj = new CaseHelper();
        	helperObj.setFieldValues(trigger.new,trigger.old,trigger.operationType);
        }
        
        if(IssueAPIDataCallout.isFirstTime){
            IssueAPIDataCallout.isFirstTime = false;
            IssueAPIDataCallout.createCallout(trigger.new, trigger.newMap);
        }
    }
}