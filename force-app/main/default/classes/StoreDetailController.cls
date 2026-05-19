/*
Functionality to the detail page for Store records
06/29/2016 Infogain – Created.
*/

public class StoreDetailController {
    
    public Store__c store{get;set;} /* Object to get store data */
    public String redirectPath;    /* String to store redirection path */
    public String issueId{get;set;} /* Store the issue id from url */
    public id tranid{get;set;}
    public StoreDetailController(ApexPages.StandardController stdController) {
        store = new Store__c(); 
        this.store = (Store__c)stdController.getRecord();
        init();
    }
    
    public StoreDetailController() {    
        store = new Store__c();        
        init();        
    } 
    
    /* Assign values in store object */
    private void init(){
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();
        }
        
        if(this.store != null && this.store.id != null){
            store = [select id,Store_Type__c,Issue__c, Name,Store_Type__r.Description__c,
                     Store_Address1__c,Store_Address2__c,Store_City__c,Store_State__c,
                     Store_Zip__c,Store_Comment__c,Store_Name__c 
                     from Store__c where Id=:this.store.id];
            issueId=store.Issue__c;
        }  
    }
    
   /* Called on click of Edit button and redirects to Store Edit page after validation check */
    public PageReference editStore()
    {
        validationCheck();
        if(ApexPages.hasMessages()){
            return null;
        }
        redirectPath=  '/apex/StoreEditPage?id='+store.Id;   
        PageReference pageRef = new PageReference(redirectPath);
        return pageRef;
    }

    
    /* Validation check - Add error message on Apex page message incase of validation check failure */
    public void validationCheck(){
        if(ApexPages.currentPage().getParameters().get('Id')==Null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Store Id not mentioned in the url'));
    }
    
    /* Called on click of Cancel button and return to previous page */
    public PageReference cancelStore()
    {
        PageReference pageRef;
        if(issueId==null || issueId=='')
            pageRef = new PageReference('/a00/o');
        else
            pageRef = new PageReference('/apex/Issue_Detail?id='+ issueId);
        return pageRef;  
    }
}