trigger NewLineCharBrandHier on Brand_Hierarchy__c (before insert,before update) {
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        NewLineCharHelper helperObj = new NewLineCharHelper();
        helperObj.newlineBrandHier(trigger.new);
    }
}