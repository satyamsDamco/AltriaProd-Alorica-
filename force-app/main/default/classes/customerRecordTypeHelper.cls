Public class customerRecordTypeHelper{

    public static string getCustomerRecordType(String TranId){
    
       List<Transaction_Management__c> TmObj = new List<Transaction_Management__c>([select id,Operating_Company__c, Operating_Company__r.Trade__c 
                                                                                    from Transaction_Management__c 
                                                                                    where id =: TranId]);
         
         
        id consumerRectype = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        id tradeRectype = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Trade Customer').getRecordTypeId();
        
        if(!TmObj.isEmpty() &&  TmObj[0].Operating_Company__c != null){
            if(TmObj[0].Operating_Company__r.Trade__c){
                return tradeRectype;
            }else{
                return consumerRectype;
            }
        }
        
        return '';     
    }
}