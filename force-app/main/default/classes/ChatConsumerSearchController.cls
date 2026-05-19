/*
*   @Author: Ariel Tribunal
*   @Date: 5/8/2019
*   @Apex Name: ChatConsumerSearchController
*   @Description: This controller is use by ChatConsumerSearch.page
*
*/
public class ChatConsumerSearchController {
    public static Transaction_Management__c transmgmObj;
    private string customerNumber;
    private string tollNumber;
    private string ucid;
    
    public static PageReference redirectCustomerSearch() {
        PageReference pgRef = null;
        String tranid = '';
        transmgmObj = new Transaction_Management__c();
        List<Operating_Company__c> opCom = new List<Operating_Company__c>([select id,Default_TFN__c,
            OperatingCompany__c,Trade__c from Operating_Company__c where OperatingCompany__c = 'PMUSA']);
        
        transmgmObj.Operating_Company__c = opCom[0].id;
        transmgmObj.Start_Date_Time__c = system.now();
        transmgmObj.TFN__c = opCom[0].Default_TFN__c;
        transmgmObj.Comments__c = 'Chat';
        
        //system.debug('redirectCustomerSearch: transmgmObj=' + transmgmObj);
        
        Database.UpsertResult upsRst =  Database.upsert(transmgmObj); 
            
        if(upsRst != null && upsRst.isSuccess())
            tranid = upsRst.getId();
        system.debug('redirectCustomerSearch: tranid=' + tranid);
        
        if(tranid != null && tranid != ''){
        
            //Set the transaction data in Cookie
            Cookie counter = new Cookie('tranid', tranid ,null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});

            system.debug('redirectCustomerSearch: counter=' + counter);            

            counter = new Cookie('customerRecType', 'consumer',null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            pgRef = new pagereference('/apex/ConsumerSearch?tranid='+tranid+'&customerRecType=consumer');
        }
        //system.debug('redirectCustomerSearch: pgRef=' + pgRef);
        return pgRef;
    }
}