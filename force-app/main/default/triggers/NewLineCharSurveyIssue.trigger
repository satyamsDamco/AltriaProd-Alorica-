/* Created Date : 11/11/2016
   Created By : Infogain Pvt. Ltd.
   Purpose: To update the text fields for feeds.
*/
trigger NewLineCharSurveyIssue on Survey_Issue__c (before insert, before update) {
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        NewLineCharHelper helperObj = new NewLineCharHelper();
        helperObj.newlineSurveyIssue(trigger.new);
    }
    
    if(trigger.isBefore && trigger.isInsert){
        NewLineCharHelper helperObj = new NewLineCharHelper();
        helperObj.updateIsReviewed(trigger.new);
    }
}