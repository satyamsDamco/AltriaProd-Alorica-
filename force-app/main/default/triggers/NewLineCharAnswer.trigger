trigger NewLineCharAnswer on Answer__c (before insert, before update) {
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        NewLineCharHelper helperObj = new NewLineCharHelper();
        helperObj.newlineAnswer(trigger.new);
       
    }
}