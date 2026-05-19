trigger NewLineCharQuestion on Question__c (before insert, before update) {
   
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        NewLineCharHelper helperObj = new NewLineCharHelper();
        helperObj.newlineQuestion(trigger.new);
    }
}