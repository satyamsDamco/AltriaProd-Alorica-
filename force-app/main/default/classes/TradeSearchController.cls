public class TradeSearchController {    
   
    public Id tranid{get;set;}    
    public string issueid {get;set;}
   
    public Contact conObj{get;set;}    
    public List<Contact> conlst{get;set;}
    public Boolean isTradeBtnVisible{get;set;}
    public Boolean readOnlyCityState{get;set;}
    public Transaction_Management__c tranObj{get;set;}
    private string customerNumber;
    public List<SelectOption> customerTypeList {get;set;}
    public string selectedCustomerType {get;set;}    
    public string selectedCustomerTypeId {get;set;}
    private Map<id,Customer_Type__c> customerType;
    
    public TradeSearchController(ApexPages.StandardController stdController) {
        isTradeBtnVisible=true;
        readOnlyCityState = true;
        conObj=(contact)stdController.getRecord();
        conObj.Country__c = 'United States';
        conlst=new List<Contact>();
        customerTypeList = new List<SelectOption>(); 
        customerType = new Map<id,Customer_Type__c>();      
        customerNumber = '';
        selectedCustomerType  = '';
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();
            System.debug('I am cookie ' + tranid);
        }
        else{
            tranid = ApexPages.currentPage().getParameters().get('tranid');
            System.debug('I am URL ' + tranid);
        }
        if(tranid != null){
            tranObj = new Transaction_Management__c();
            tranObj = [Select id, Contact__c,Operating_Company__c from Transaction_Management__c where id =:tranid];
            getCustomerType();
            getRecordType();
            
            if(ApexPages.currentPage().getParameters().get('customerNumber') != null && ApexPages.currentPage().getParameters().get('customerNumber') != ''){
                customerNumber = ApexPages.currentPage().getParameters().get('customerNumber');
                conObj.Phone = customerNumber;
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'Trade customer Phone # '+customerNumber));  
                TradeSearch();
            }
        }
        init();
    }
    
    public void init(){
                
        if(ApexPages.currentPage().getParameters().get('comName') != null && ApexPages.currentPage().getParameters().get('comName') != '')
            conObj.Company_Name__c =  ApexPages.currentPage().getParameters().get('comName'); 
        
        if(ApexPages.currentPage().getParameters().get('agentName') != null && ApexPages.currentPage().getParameters().get('agentName') != '')
            conObj.Company_Name__c =  ApexPages.currentPage().getParameters().get('agentName'); 
        
        if(ApexPages.currentPage().getParameters().get('DBA') != null && ApexPages.currentPage().getParameters().get('DBA') != '')
            conObj.DBA_Name__c =  ApexPages.currentPage().getParameters().get('DBA'); 
        
        if(ApexPages.currentPage().getParameters().get('zip') != null && ApexPages.currentPage().getParameters().get('zip') != '')
            conObj.Zip_Code__c =  ApexPages.currentPage().getParameters().get('zip'); 
        
        if(ApexPages.currentPage().getParameters().get('phone') != null && ApexPages.currentPage().getParameters().get('phone') != '')
            conObj.Phone =  ApexPages.currentPage().getParameters().get('phone'); 
        
        if(ApexPages.currentPage().getParameters().get('email') != null && ApexPages.currentPage().getParameters().get('email') != '')
            conObj.Email =  ApexPages.currentPage().getParameters().get('email'); 
        
        if(ApexPages.currentPage().getParameters().get('accountNo') != null && ApexPages.currentPage().getParameters().get('accountNo') != '')
            conObj.Account_No__c =  ApexPages.currentPage().getParameters().get('accountNo'); 
        
        if(ApexPages.currentPage().getParameters().get('retail') != null && ApexPages.currentPage().getParameters().get('retail') != '')
            conObj.Retail_control__c =  ApexPages.currentPage().getParameters().get('retail'); 
        
        if(ApexPages.currentPage().getParameters().get('fSphone') != null && ApexPages.currentPage().getParameters().get('fSphone') != '')
            conObj.Phone =  ApexPages.currentPage().getParameters().get('fSphone'); 
        
        if(ApexPages.currentPage().getParameters().get('territory') != null && ApexPages.currentPage().getParameters().get('territory') != '')
            conObj.Territory__c =  ApexPages.currentPage().getParameters().get('territory'); 
        
        if(ApexPages.currentPage().getParameters().get('custType') != null && ApexPages.currentPage().getParameters().get('custType') != ''){
            conObj.CustomerType__c=  ApexPages.currentPage().getParameters().get('custType');
            selectedCustomerType =  ApexPages.currentPage().getParameters().get('custType');
        }    
            
        if(ApexPages.currentPage().getParameters().get('custType1') != null && ApexPages.currentPage().getParameters().get('custType1') != ''){
            conObj.CustomerType1__c=  ApexPages.currentPage().getParameters().get('custType1');
            selectedCustomerTypeId  = conObj.CustomerType1__c; 
            changeCustomerType();     
        } 
       
    }
    
    public void getCustomerType(){
        
        customerTypeList = new List<SelectOption>();
        customerType = new Map<id,Customer_Type__c>([Select Id, Description__c 
                                                       from Customer_Type__c 
                                                       where IsActive__c = true
                                                       and CodeType__c =: 'CUSTOMERS']);
        customerTypeList.add(new SelectOption('0', '--Select Customer Type--',false)); 
        
        if(!customerType.isEmpty()){
            for(Customer_Type__c ct :customerType.values()){
                customerTypeList.add(new SelectOption(ct.id, ct.Description__c)); 
            }    
        }
    }
    
    public void changeCustomerType(){
        if(selectedCustomerTypeId != null && selectedCustomerTypeId != '' && selectedCustomerTypeId != '0' && !customerType.isEmpty()){
            if(customerType.ContainsKey(selectedCustomerTypeId)){
                selectedCustomerType = customerType.get(selectedCustomerTypeId).Description__c;
            }else{
                selectedCustomerType = '';
            }
        }else{
            selectedCustomerType = '';
        }
    }
    
    public void getRecordType(){
        String RecordTypeidObj = customerRecordTypeHelper.getCustomerRecordType(tranid);
               
        if(RecordTypeidObj != ''){
           conObj.RecordTypeId = RecordTypeidObj;
        }
    }
    
    //clear Search result.
     public PageReference Clear() {
       issueid = '';
       isTradeBtnVisible = true;              
       conObj = new Contact();
       conlst.clear(); 
       conObj.Country__c = 'United States'; 
       readOnlyCityState = true; 
       getCustomerType();
       selectedCustomerTypeId = '0';
       selectedCustomerType = '';
       return null;
    }
    
    public PageReference onCTISearch() {
       
       issueid = '';
       isTradeBtnVisible = true;
       String customerType = selectedCustomerTypeId;       
       conObj = new Contact();//Customer_Type__c = customerType
       conlst.clear(); 
       conObj.Country__c = 'United States'; 
       readOnlyCityState = true; 
       getCustomerType();
       
       if(customerNumber != null && customerNumber !=  ''){
           conObj.Phone = customerNumber;
           isTradeBtnVisible = false;
       }
       return null; 
    } 
    
    Public PageReference TradeSearch(){
      
        conlst.clear(); 
        try{
        
        if(checkTradeContact()){
            return null;
        }
        
        if(conObj.Phone != null &&  conObj.Phone.length()<10 && conObj.Phone!=''){            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Not a valid 10-digit phone number.'));
            return null;            
        }
        

        String query = 'select id,ccn__c,CustomerID__c,phone,zip_code__c,Company_Name__c,DBA_Name__c,Account_No__c,Retail_control__c,Email,Territory__c from Contact ';    
        String queryCondition = '';

       if(selectedCustomerTypeId != null){
           if(selectedCustomerType == system.Label.Wholesaler){
                if((conObj.Phone == null || conObj.Phone == '') && (issueid == null || issueid == '') && (conObj.Account_No__c == null || conObj.Account_No__c == '') && (conObj.Company_Name__c == null || conObj.Company_Name__c == '' || conObj.Zip_Code__c == null || conObj.Zip_Code__c == '')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Mandatory Fields: Please enter atleast Account# or Phone or (Company Name and Zip Code/Postal Code) or Issue #  for search'));
                    isTradeBtnVisible = true;
                    return null;
                }
            }
            
            if(selectedCustomerType == System.Label.Retailer){
                if( (conObj.Phone == null || conObj.Phone == '') && (issueid == null || issueid == '')  && (conObj.Company_Name__c == null || conObj.Company_Name__c == '' || conObj.Zip_Code__c == null || conObj.Zip_Code__c == '')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Mandatory Fields: Please enter atleast Phone or (Company Name and Zip Code/Postal Code) or Issue # for search' ));
                    isTradeBtnVisible = true;
                    return null;
                }
            }
    
            if(selectedCustomerType == system.Label.Field_Sales_Force){
                if( (conObj.Phone == null || conObj.Phone == '') && (issueid == null || issueid == '') && (conObj.Territory__c == null || conObj.Territory__c == '')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Mandatory Fields: Please enter atleast Issue# or FSF Territory # or Phone for search'));
                    isTradeBtnVisible = true;
                    return null;
                }
            }
            
            //Research Panelist
            if(selectedCustomerType == system.Label.Research_Panelist){
                if( (conObj.Study_ID__c == null || conObj.Study_ID__c == '') && (issueid == null || issueid == '')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Mandatory Fields: Please enter at least Issue # or Study ID for search'));
                    isTradeBtnVisible = true;
                    return null;
                }
            }
            
            isTradeBtnVisible = false;
        }else{
            isTradeBtnVisible = true;
        }
        
            String ConsumerId = '';
            String ConName = '';
            string soslCondition = '';
            string whereCondition = '';
            
            if(issueid != null && issueid != ''){
                List<Case> caseObj = new List<Case>([Select id, Contactid, Contact.Name, Contact.CustomerID__c  from Case where CaseNumber__c like: '%'+issueid.trim()]);
                if(!caseObj.isEmpty() && caseObj.size() >0 && caseObj[0].Contactid != null){
                   ConsumerId = caseObj[0].Contact.CustomerID__c;
                   ConName = caseObj[0].Contact.Name;
                }            
            }
            if(ConsumerId != null && ConsumerId != ''){
                soslCondition = ConName; 
                whereCondition = ' Where CustomerID__c = \'' + ConsumerId.trim()+ '\'';
            }
            
            if(conObj.Phone != null && conObj.Phone != null && conObj.Phone != ''){
                //if(soslCondition != '') {soslCondition += ' AND '+conObj.phone.trim();}
                //else {soslCondition += conObj.phone.trim();}
                 Pattern nonAlphanumeric = Pattern.compile('[^0-9]');
                Matcher matcher = nonAlphanumeric.matcher(conObj.Phone);
                system.debug(matcher.replaceAll(''));                
              
                
                if(soslCondition != '') {soslCondition += ' AND ('+conObj.phone+' or '+matcher.replaceAll('')+')';}
                else {soslCondition += '('+conObj.phone+' or '+matcher.replaceAll('')+')';} 
            }

            if(conObj.Zip_Code__c != null && conObj.Zip_Code__c != null && conObj.Zip_Code__c != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Zip_Code__c.trim() ;}
                else {soslCondition += conObj.Zip_Code__c.trim() ;}
            }
            
            if(conObj.Email != null && conObj.Email != null && conObj.Email != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Email.trim() ;}
                else {soslCondition += conObj.Email.trim() ;}
            } 
                       
            if(conObj.Company_Name__c != null && conObj.Company_Name__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Company_Name__c = \''+conObj.Company_Name__c.trim()+'\'';}
                else{ whereCondition =  ' Where Company_Name__c = \''+conObj.Company_Name__c.trim()+'\'';}
               
               if(soslCondition != '') {soslCondition += ' AND '+conObj.Company_Name__c.trim();}
                else {soslCondition  += conObj.Company_Name__c.trim();}
            }
            
            if(conObj.Retail_control__c != null && conObj.Retail_control__c != ''){
                 if(whereCondition != ''){ whereCondition +=  ' and Retail_control__c = \''+conObj.Retail_control__c.trim()+'\'';}
                else{ whereCondition =  ' Where Retail_control__c = \''+conObj.Retail_control__c+'\'';}
                 
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Retail_control__c.trim();}
                else {soslCondition += conObj.Retail_control__c.trim();}
            }
            
            if(conObj.DBA_Name__c != null && conObj.DBA_Name__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and DBA_Name__c = \''+conObj.DBA_Name__c.trim()+'\'';}
                else{ whereCondition =  ' Where DBA_Name__c = \''+conObj.DBA_Name__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.DBA_Name__c.trim();}
                else {soslCondition += conObj.DBA_Name__c.trim();}
            }
            
            if(conObj.Account_No__c != null && conObj.Account_No__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Account_No__c  = \''+conObj.Account_No__c.trim()+'\'';}
                else{ whereCondition =  ' Where Account_No__c = \''+conObj.Account_No__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Account_No__c.trim();}
                else {soslCondition += conObj.Account_No__c.trim();}
            }
            
            if(conObj.Territory__c != null && conObj.Territory__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Territory__c = \''+conObj.Territory__c.trim()+'\'';}
                else{ whereCondition =  ' Where Territory__c = \''+conObj.Territory__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Territory__c.trim();}
                 else {soslCondition += conObj.Territory__c.trim();}
            }                     
             
            //Research Panelist search fields
            if(conObj.Study_ID__c != null && conObj.Study_ID__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Study_ID__c = \''+conObj.Study_ID__c.trim()+'\'';}
                else{ whereCondition =  ' Where Study_ID__c = \''+conObj.Study_ID__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Study_ID__c.trim();}
                 else {soslCondition += conObj.Study_ID__c.trim();}
            }

            if(conObj.Participant_ID__c != null && conObj.Participant_ID__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Participant_ID__c = \''+conObj.Participant_ID__c.trim()+'\'';}
                else{ whereCondition =  ' Where Participant_ID__c = \''+conObj.Participant_ID__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Participant_ID__c.trim();}
                 else {soslCondition += conObj.Participant_ID__c.trim();}
            }
            
            if(conObj.Blinding_Code__c != null && conObj.Blinding_Code__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Blinding_Code__c = \''+conObj.Blinding_Code__c.trim()+'\'';}
                else{ whereCondition =  ' Where Blinding_Code__c = \''+conObj.Blinding_Code__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Blinding_Code__c.trim();}
                 else {soslCondition += conObj.Blinding_Code__c.trim();}
            }
            
            if(conObj.Research_Company__c != null && conObj.Research_Company__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Research_Company__c = \''+conObj.Research_Company__c.trim()+'\'';}
                else{ whereCondition =  ' Where Research_Company__c = \''+conObj.Research_Company__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Research_Company__c.trim();}
                 else {soslCondition += conObj.Research_Company__c.trim();}
            }
            
            if(conObj.Research_Location__c != null && conObj.Research_Location__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Research_Location__c = \''+conObj.Research_Location__c.trim()+'\'';}
                else{ whereCondition =  ' Where Research_Location__c = \''+conObj.Research_Location__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Research_Location__c.trim();}
                 else {soslCondition += conObj.Research_Location__c.trim();}
            }
            
            if(conObj.Research_Panelist_ID__c != null && conObj.Research_Panelist_ID__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Research_Panelist_ID__c = \''+conObj.Research_Panelist_ID__c.trim()+'\'';}
                else{ whereCondition =  ' Where Research_Panelist_ID__c = \''+conObj.Research_Panelist_ID__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Research_Panelist_ID__c.trim();}
                 else {soslCondition += conObj.Research_Panelist_ID__c.trim();}
            }
            
            if(conObj.Project_Flavor_Type__c != null && conObj.Project_Flavor_Type__c != ''){
                if(whereCondition != ''){ whereCondition +=  ' and Project_Flavor_Type__c = \''+conObj.Project_Flavor_Type__c.trim()+'\'';}
                else{ whereCondition =  ' Where Project_Flavor_Type__c = \''+conObj.Project_Flavor_Type__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Project_Flavor_Type__c.trim();}
                 else {soslCondition += conObj.Project_Flavor_Type__c.trim();}
            }
            
            if(conObj.Research_Panelist_Name__c != null && conObj.Research_Panelist_Name__c != ''){
                //if(whereCondition != ''){ whereCondition +=  ' and Research_Panelist_Name__c = \''+conObj.Research_Panelist_Name__c.trim()+'\'';}
               // else{ whereCondition =  ' Where Research_Panelist_Name__c = \''+conObj.Research_Panelist_Name__c.trim()+'\'';}
                
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Research_Panelist_Name__c.trim();}
                 else {soslCondition += conObj.Research_Panelist_Name__c.trim();}
            }
            // end
            if(whereCondition != ''){
                whereCondition +=  ' and RecordType.Name!= \'Consumer\' and Active__c = true  ';
            }else{
                whereCondition =  ' Where RecordType.Name!= \'Consumer\' and Active__c = true ';
            }
            if(selectedCustomerTypeId != null){
                if(whereCondition != ''){
                    whereCondition +=  ' and CustomerType__c= \'' + selectedCustomerType+ '\'';
                }else{
                    whereCondition =  ' Where CustomerType__c= \'' + selectedCustomerType + '\'';
                }
            }
            
            system.debug('------whereCondition------'+whereCondition);
            
        System.debug('test soslCondition before if '+soslCondition );
            if(soslCondition != null && soslCondition != ''){
                System.debug('test soslCondition '+soslCondition );
                if(soslCondition.trim().length() < 3 ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid data'));
                    return null;
                }
                System.debug('test soslCondition 1'+soslCondition);
                soslCondition = escapeMetaCharacters(soslCondition); 
                System.debug('test soslCondition 2'+soslCondition);
                
                string searchQuery = 'FIND {'+ soslCondition +'} IN ALL FIELDS ';
                searchQuery += 'RETURNING Contact(id,Name,CustomerID__c,CCN__c,phone,zip_code__c,Company_Name__c,DBA_Name__c,Account_No__c,Retail_control__c,Email,Territory__c,CustomerType__c,Study_ID__c,Participant_ID__c,Research_Company__c,Research_Panelist_Name__c';
                if(whereCondition  != null && whereCondition != '')
                    searchQuery += whereCondition ; 
                 searchQuery += ')';
                 
                 System.debug(' query  searchQuery '+searchQuery );
                 
                List<List <sObject>> searchList = search.query(searchQuery);
                //conlst = ((List<contact>)searchList[0]); 
                List<Contact> contactData= ((List<contact>)searchList[0]);
                System.debug('test contactData '+contactData.size()); 
                if(!contactData.isEmpty()){
                    for(Contact con :contactData){
                        Contact conInner = con;
                        if(conObj.Email  != null && conObj.Email  != '' && conInner.id != null){
                            if(conObj.Email.trim() == conInner.Email.trim())
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.Zip_Code__c  != null && conObj.Zip_Code__c  != '' && conInner.id != null){
                            if(conObj.Zip_Code__c.trim() == conInner.Zip_Code__c.trim())
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        
                        if(conObj.Phone  != null && conObj.Phone  != '' && conInner.id != null){
                                conInner = con;
                        }                        
                        
                        if(conInner.id != null){
                            System.debug('test conInner'+conInner);
                            conlst.add(conInner);
                        }
                    }
                }
                system.debug('test conlst  '+conlst );            
            }
            System.debug('test conlst '+conlst );
            if(conlst.isEmpty() || conlst.Size() == 0){
                if(selectedCustomerTypeId != null){ 
                    isTradeBtnVisible = false;
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new trade customer.'));  
                }else{
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found,Please select customer type and create new trade customer.'));  
                }
                          
                return null;
            }
            else if (conlst.Size() > 999){
                isTradeBtnVisible = false;
                conlst.clear();
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'Too many search results found (over 1,000), please enter in more search criteria to narrow search results'));
                return null;
            }
            }catch(Exception ex){
                System.debug('test '+ex.getLineNumber());
            }
      
            return null;
        
        }
        
    public String escapeMetaCharacters(String inputString){
        
        List<String> metaCharacters = new List<String>();
        
        metaCharacters.add('\\');metaCharacters.add('^');
        metaCharacters.add('$');metaCharacters.add('{');
        metaCharacters.add('}');
        metaCharacters.add('[');metaCharacters.add(']');
        metaCharacters.add('(');metaCharacters.add(')');
        metaCharacters.add('*');metaCharacters.add('+');
        metaCharacters.add('?');metaCharacters.add('|');
        metaCharacters.add('<');metaCharacters.add('>');
        metaCharacters.add('-');metaCharacters.add('&');
        
        for (Integer i = 0 ; i < metaCharacters.size(); i++){
            if(inputString.contains(metaCharacters[i])){
                inputString= inputString.replace(metaCharacters[i],'\\'+metaCharacters[i]);
            }
        }
        return inputString;
    }    
 
    public Boolean checkTradeContact(){
        Boolean checkTradeContact = false;    
        if(tranObj.Contact__c == null){
            Transaction_Management__c tranData = [Select id,Contact__c from Transaction_Management__c where id =:tranObj.id];
            if(tranData.Contact__c != null){
                tranObj.Contact__c = tranData.Contact__c;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Trade customer already associated with current transaction.'));
                checkTradeContact = true;
            }
        }else{
            checkTradeContact = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Trade customer already associated with current transaction.'));
        }
        return checkTradeContact ;
    }
    
    public PageReference RefreshTradeContact(){
        
        if(checkTradeContact()){
            Clear(); 
            isTradeBtnVisible = false;           
        }   
        return null;
    }
}