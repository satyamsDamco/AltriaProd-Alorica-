trigger NewLineCharAttDetail on Attachment_Detail__c (before insert,before update) {
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate) ){
        NewLineCharHelper helperObj = new NewLineCharHelper();
       helperObj.newlineAttDetail(trigger.new); 
       
    }    
}