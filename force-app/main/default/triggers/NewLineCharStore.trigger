trigger NewLineCharStore on Store__c (before insert,before update) {

    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        NewLineCharHelper helperObj = new NewLineCharHelper();
        helperObj.newlineStore(trigger.new);
    }
}