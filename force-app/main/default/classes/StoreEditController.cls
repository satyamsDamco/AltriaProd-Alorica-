/*
Functionality to the edit page for Store records
07/18/2016 Infogain – Created.
*/
public class StoreEditController {
      // Global declaration of variables
    public Store__c store{get;set;}   
    public String selectedStoreType{get;set;} // to get the selected value from drop down list  
    public List<Store_List__c> customStoreNameList{get;set;} // to get the list of store from custom list    
    Public String issueId{get;set;} // to store the issue id fetched from url 
    public Id tranid{get;set;} 
    String FormName;
    public Contact conObj{get;set;} 
    public Boolean cityStateDisabled{get;set;}    
    private string ccnNumber;
    private String CustomerId;
        
    public StoreEditController()
    {
        store = new Store__c();
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();            
        }
        init();        
    }
    
    public StoreEditController(ApexPages.StandardController stdController) {
        store = new Store__c(); 
        this.store = (Store__c)stdController.getRecord();
        init();
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();            
        }
        system.debug('------tranid-----'+tranid);
        FormName='StoreEditPage';   
    }
    
    
    // init is initial function to fetch store data if store id exists and to assign issueid value 
    private void init(){
        customStoreNameList= new List<Store_List__c>();         
        customStoreList();
        if(ApexPages.currentPage().getParameters().get('IssueId')!=NULL){
            issueId=ApexPages.currentPage().getParameters().get('IssueId');
            store.Issue__c=issueId;
        }
        if(this.store != null && this.store.id != null){
            store = [select id,Store_Type__c,Issue__c, Name, Store_Name__c,
                     Store_Address1__c,Store_Address2__c,Store_City__c,Store_State__c,
                     Store_Zip__c,Store_Comment__c,Issue__r.Issue_Type__c,HasValidZipCode__c,  
                     Issue__r.IsReviewed__c from Store__c 
                     where Id=:this.store.id];
            selectedStoreType  = store.Store_Type__c;
            issueId= store.Issue__c;
        }
        
        if(store.Issue__c != null){
            Case caseobj = [Select id, Contactid, Contact.CCN__c from Case where id =:store.Issue__c];
            
            if(caseobj != null && caseobj.Contactid != null){
                CustomerId = caseobj.Contactid;
                ccnNumber = caseobj.Contact.CCN__c ;
            }
        }
        
        store.Transaction_Management__c = tranid;   
        if(store.HasValidZipCode__c){
            cityStateDisabled = true;
        }else{
            cityStateDisabled = false;
        }
    }
    
    public PageReference getCityState(){
        store.Store_City__c = '';
        store.Store_State__c = '';       
        cityStateDisabled = false;
        if(store.Store_Zip__c != null && store.Store_Zip__c != ''){ 
            MelissaClasses.zipLookupResponse zipLookup = new MelissaClasses.zipLookupResponse();
            zipLookup = MelissaServices.ZipLookupServiceRequest(store.Store_Zip__c,tranid,FormName, ccnNumber, CustomerId);
            if(zipLookup ==  null){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please enter the City and State'));
                cityStateDisabled = false;
                store.HasValidZipCode__c = false;
            }else{
                if(!zipLookup.Results.isEmpty() && zipLookup.Results.size() >0){        
                    cityStateDisabled = true;
                    store.Store_City__c = zipLookup.Results[0].Address.City.toUpperCase();
                    store.Store_State__c = zipLookup.Results[0].Address.State.toUpperCase();  
                    
                    if(zipLookup.Results[0].Address.PostalCode != null && zipLookup.Results[0].Address.PostalCode != '' && zipLookup.Results[0].Address.PostalCode != store.Store_Zip__c){
                         string messageInfo = 'Zip may require adjustment , ZIP should  be '+ zipLookup.Results[0].Address.PostalCode +'. Please adjust address if applicable';
                         ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info,  messageInfo ));
                    }  
                    store.HasValidZipCode__c = true;                    
                    
                }else{
                    store.HasValidZipCode__c = false;
                    cityStateDisabled = false;
                }                    
            } 
        }
        return null;   
    }
    
    
    // this function used to fetch the store values from custom list and assign it to customStoreNameList 
    public void customStoreList(){
        Map<String,Store_List__c> allNames = Store_List__c.getAll();          
        customStoreNameList.addAll(allNames.values());
        System.debug('test name'+customStoreNameList);
    }
    
    // this function bind the store id and store descrioption with select option and returns the list to show the store in drop down list 
    public List<SelectOption> getStoreType(){
        List<SelectOption> selectOptions=new List<SelectOption>();
        selectOptions.add(new selectOption('--Select Store Type--','--Select Store Type--'));
        List<Store_Type__c> storeTypeList= new List<Store_Type__c>([select id,Name,Description__c from Store_Type__c where isActive__c = true order by Description__c]);         
        
        if(!storeTypeList.IsEmpty() && storeTypeList.size() >0){
            for(Store_Type__c temp :storeTypeList){         
                if(temp.Description__c != NULL && temp.Description__c.trim() != ''){                
                    selectOptions.add(new selectOption(temp.Id, temp.Description__c));
                }
            }
        }
        return selectOptions;
    }
    
    /* function called on click on save button. it validate data and return null if validation fails
     or after sucessful validation insert or update store data and pagereference  */
    public PageReference submitStore()
    {  
       
        validationCheck();
        if(ApexPages.hasMessages()){
            return null;
        }
        if(issueId != null && issueId != ''){
            Case currIssue = [Select Id, IsReviewed__c From Case Where Id =: issueId limit 1];
            if(currIssue != null){
                store.isReviewed__c = currIssue.IsReviewed__c;
            }
        }
         store.Store_Type__c = selectedStoreType;   
        
        try{
            if(store.id == null){
              PageReference pageRef;
            
               insert store;
               pageRef = new PageReference('/apex/StoreDetail?id='+store.Id);
               return pageRef; 
            }
            else{
            update store;
                
           PageReference pageRef;
          if(store.Id == NULL)
              pageRef = new PageReference('/apex/Issue_Detail?id='+ store.Issue__c);
          else
              pageRef = new PageReference('/apex/StoreDetail?id='+store.Id);
                
          return pageRef;
            }
        }catch(Exception ex){
          ApexPages.addMessages(ex);
        }
        
        return null;            
    }
    
     /* function called on click on save and new button. it validate data and return null if validation fails
     or after sucessful validation insert or update store data and return on same page with new instance of store object  */
    public PageReference saveNew()
    {
        validationCheck();
        if(ApexPages.hasMessages()){
            return null;
        }
        
        store.Store_Type__c=selectedStoreType;
        if(issueId != null && issueId != ''){
            Case currIssue = [Select Id, IsReviewed__c From Case Where Id =: issueId limit 1];
            if(currIssue != null){
                store.isReviewed__c = currIssue.IsReviewed__c;
            }
        }
        try{
          if(store == null || store.id == null)
              insert store;
          else
              update store;
              
          store= new Store__c();
          store.Issue__c=issueId;
          selectedStoreType = null;  
          PageReference pageRef = new PageReference('/apex/StoreEditPage?IssueId='+issueId);
          pageRef.setRedirect(true);
          return pageRef; 
          
        
        }catch(Exception ex){
          ApexPages.addMessages(ex);
        }       
        return null;    
    }
    
    // this function check validation and if validation fails then add error message on Apex page message
    public void validationCheck(){
        ApexPages.getMessages().clear();
        if((selectedStoreType == null || selectedStoreType == '--Select Store Type--')){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Store Type'));            
        }
    }
    
    //Method Edit Store page Redirect to Store Detail Page when we click on Cancel Button 
    public PageReference CancelRedirect(){
        PageReference pageRef = new PageReference('/apex/StoreDetail?id='+store.Id);
        pageRef.setRedirect(true);
        return pageRef;   
    } 
    
}