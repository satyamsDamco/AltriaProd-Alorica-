trigger ContactCRUD on Contact (before insert, before update, after update) {
    Skip_Trigger_Validation_Rule__c skipObj = Skip_Trigger_Validation_Rule__c.getInstance('SkipTrigger');
    boolean skiptrigger = false;
    if(skipObj != null){
        skiptrigger = skipObj.Skip__c;
    }
    if(trigger.isUpdate && trigger.isAfter && !skiptrigger){
        ContactHelper conHelperObj = new ContactHelper();
        conHelperObj.updateReimbursement(Trigger.newMap, Trigger.oldMap);
    }
    if(trigger.isBefore){
        for(Contact c :Trigger.new){
             if(c.Birthdate1__c !=NULL){
                    String dateOutput = c.Birthdate1__c.format();
                    c.Birthdate__c=dateOutput;
             }
        }
    }
}