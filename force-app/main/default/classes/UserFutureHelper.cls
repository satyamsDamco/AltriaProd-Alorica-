global class UserFutureHelper {    
    
    @future
    public static void updateUser(List<Id> lstUserIds){
        List<User> userList =  new List<User>([Select Id, CreatedDate__c, CreatedDate From User Where Id in :lstUserIds]);
        
        for(User uObj :userList){
            uObj.CreatedDate__c =  uObj.CreatedDate; 
        }
        
        update userList;
    }
    
}