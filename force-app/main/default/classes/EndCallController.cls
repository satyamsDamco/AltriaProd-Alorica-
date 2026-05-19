/* End Call edit Page Controller
   08/22/2016 - Infogain---Created
*/

 public class EndCallController {
 
    public Transaction_Management__c tranObj{get;set;}
    private String tranId{get;set;}
    public boolean isError {get;set;}
     
    
    
    public EndCallController(ApexPages.StandardController stdController) {
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        tranObj=new Transaction_Management__c();
        isError = false;
        if(counter != null) {
            tranId = counter.getValue();
            EndCallValidationMessage(tranId); 
            
        }
    }
    
    public void EndCallValidationMessage(String tranId){
        
       List<Transaction_Management__c> TmObj = new List<Transaction_Management__c>([select id,Disposition__c, Comments__c, Contact__c,End_Date_Time__c,Operating_Company__c, Operating_Company__r.Trade__c  
                                                                                    from Transaction_Management__c 
                                                                                    where id =: TranId]);
                                                                                    
         if(!TmObj.isEmpty() &&  TmObj[0].Operating_Company__c != null){
         
            tranObj = TmObj[0];
              
             List<Case> issueList = new List<Case>([Select Id,Survey__c from Case where Transaction__c =: TmObj[0].id and Survey__c =: 'Required']);
             
             if(TmObj[0].Contact__c == null){
                 isError = true;
                  if(TmObj[0].Operating_Company__r.Trade__c){
                      ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error,'Please select the trade customer for which the issue is created'));
                  }else{
                      ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error,'Please select the consumer for which the issue is created'));
                  }
             }
             
             if(!issueList.isEmpty()){
                  ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error,'Please present the survey or select a Cancel Reason')); 
                  isError =  true;                  
             }         
         }  
    }
    public void customSave(){
        try{
            tranObj.End_Date_Time__c = system.now();
            Database.SaveResult saverst = Database.update(tranObj);
            if(tranObj != null){
                 system.debug('=======tranObj======'+tranObj);
                 TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                 mgmtHelper.createTransactionMgmtHistoryRecord('ENDCALL',saverst.getId());
             }
             Cookie counter = new Cookie('tranid', null,null,0,true);
             tranId = null;
         }catch(DMLException e){ 
            ApexPages.addMessages(e);
        }
    }     
 }