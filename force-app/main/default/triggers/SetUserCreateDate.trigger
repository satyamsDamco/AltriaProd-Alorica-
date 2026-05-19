Trigger SetUserCreateDate on User (before insert, before update) {
    
    System.debug('Trigger SetUserCreateDate on User before insert, before update)');
    
     if(Trigger.isBefore) {
           for(User uObj : Trigger.New) {
             uObj.CreatedDate__c =  uObj.CreatedDate;
         }
     }

}