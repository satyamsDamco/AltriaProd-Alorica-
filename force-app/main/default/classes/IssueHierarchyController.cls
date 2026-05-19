/*
Functionality to select Issue Hierarchy
07/06/2016 Infogain – Created.
*/

public with sharing class IssueHierarchyController{    
    

    public List<causeWrapper> issueHierList{get;set;} /* List to hold selected issue hierarchy data */
    public boolean ShowpageBlock{get;set;} /* Flag for pageblock */
    public boolean controllerBoolTrueVar {get;set;} /**/
    public String selectedProductLine {get; set;} /* String to hold Product Line data */
    public String selectedIssueType {get; set;} /* String to hold Issue Type data */
    public String reasonStr{get;set;} /* String to hold Reason data */
    public String causeStr{get;set;} /* String to hold Cause data */
    public List<SelectOption> productLineList {get; set;} /* List to hold Product Line data */
    public List<SelectOption> issueTypeList {get; set;} /* List to hold Issue Type data */
    public String issueHierId {get; set;} /* String to hold Issue Hierarchy ID */
    private String productLine = Apexpages.currentpage().getparameters().get('productlinecode'); /* String to get Product Line Code */
    public string customerRecType{get;set;}
    
    public IssueHierarchyController(ApexPages.StandardController controller){       
        ShowpageBlock=false;
        controllerBoolTrueVar=true;
        customerRecType = '';
        issueHierList = new list<causeWrapper>();  
        Cookie counter = ApexPages.currentPage().getCookies().get('customerRecType');
        
        if(counter != null) {
            customerRecType = counter.getValue();
        }
             
        issueHierId =  apexpages.currentpage().getparameters().get('issueHierId');
        if(apexpages.currentpage().getparameters().get('productlineName')  !=  null)
            selectedProductLine = apexpages.currentpage().getparameters().get('productlineName');    
            
        productLineListData();
        if(issueHierId != null && issueHierId  != '')
        IssueHierarchyDataOnLoad();        
       
    }
    
    /* Reset values on click of Reset button */
    public pageReference reset(){
        ShowpageBlock=false;
        controllerBoolTrueVar=true;
        issueHierList = new list<causeWrapper>();
        reasonStr = '';
        causeStr = '';
        selectedIssueType = '';
        issueHierId = ''; 
        return null;
    }
    
    /* Reset values on change of Product Line */
    public pageReference onChangeproductLine(){
        ShowpageBlock=false;
        controllerBoolTrueVar=true;
        issueHierList = new list<causeWrapper>(); 
        selectedProductLine = '';
        reasonStr = '';
        causeStr = '';
        selectedIssueType = '';
        issueHierId = '';
        issueTypeList = new List<SelectOption>(); 
        return null;
    }
    
    public pageReference restTable(){
        ShowpageBlock=false;
        controllerBoolTrueVar=true;
        return null;
    }
    
   /* Create the Product Line List from Issue Hierarchy data using aggregate method */
    private void productLineListData()
    {    
        productLineList = new List<SelectOption>();     
        
        if(selectedProductLine != null && selectedProductLine != ''){
            productLineList.add(new SelectOption(selectedProductLine, selectedProductLine));
        }else{
            productLineList.add(new SelectOption('0', '--Select Product Line--'));
            
            List<Product_Line__c> productLineObj = new List<Product_Line__c>([Select id, Name from Product_Line__c where isActive__c = true]);  
            
            for(Product_Line__c pl :productLineObj){
                productLineList.add(new SelectOption(pl.name, pl.name));
            } 
        }               
    }

    /* Create the Issue Type List from Issue Hierarchy data when Product Line item is selected using aggregate method */
    public void issueTypeListData()
    {   
        If(selectedProductLine != null && selectedProductLine != ''){ 
            issueTypeList = new List<SelectOption>(); 
            issueTypeList.add(new SelectOption('0', '--Select Issue Type--')); 
            
            string reasonStr =Apexpages.currentPage().getParameters().get('firstParam');
            string causeStr =Apexpages.currentPage().getParameters().get('secondParam'); 
            string product =Apexpages.currentPage().getParameters().get('productParam');                                                 
                                                
            String query = 'Select Count(id), Issue_Type__r.Description__c From Issue_Hierarchy__c Where Active__c = true and Issue_Type__c != null';
        
            query += ' and Product_Line__r.Name = \''+ selectedProductLine +'\'';
            
            if(reasonStr != '' && reasonStr !=  '0')
                query += 'and reason__r.Description__c =\''+ reasonStr+'\'';
                
            if(causeStr != '' && causeStr !=  '0')
                query += 'and Cause__r.Description__c =\''+ causeStr+'\'';
                
            if(customerRecType != ''){
                if(customerRecType == 'consumer')    
                    query += ' and (Cust_Cons_Flag__c = \'ALL\' or Cust_Cons_Flag__c = \'CONS\' or Cust_Cons_Flag__c = \'IQOS\') '; 
                else
                    query += ' and (Cust_Cons_Flag__c = \'ALL\' or Cust_Cons_Flag__c = \'CUST\') '; 
            }
                                                
            query += ' Group by Issue_Type__r.Description__c';
            
            system.debug('test query  res'+query );    
            string issueType;            
            for (AggregateResult ar : (List<AggregateResult>)Database.query(query)){
                issueType = String.ValueOf(ar.get('Description__c'));
                issueTypeList.add(new SelectOption(String.ValueOf(ar.get('Description__c')), String.ValueOf(ar.get('Description__c'))));
            }
            if(issueTypeList.size() == 2 && issueHierId != null && issueHierId !=  ''){
                selectedIssueType = issueType.trim();
            }
        }              
    }
    
    /* Get Issue Hierarchy data on page load */
    public PageReference IssueHierarchyDataOnLoad(){
        
        List<Issue_Hierarchy__c> listIssueHierarchy = new List<Issue_Hierarchy__c>();
        List<Issue_Hierarchy__c> selectedIssueHierarchy = new List<Issue_Hierarchy__c>();
        issueHierList = new List<causeWrapper>();
        
       selectedIssueHierarchy  = new List<Issue_Hierarchy__c>([
                                      Select Id,Name, Reason__c,Reason__r.Name,Reason__r.Description__c,
                                      Product_Line__c,Product_Line__r.Name,
                                      Issue_Type__c,Issue_Type__r.Description__c,Issue_Type__r.Name,
                                      Cause__c,Cause__r.Description__c ,Cause__r.Name,
                                      Classification__c,Classification__r.Description__c,Classification__r.Name,
                                      Group__c, Group__r.Description__c, Group__r.Name 
                                      From Issue_Hierarchy__c 
                                      Where id =:issueHierId
                                      Limit 1
                                      ]);
                                      
        if(!selectedIssueHierarchy.isEmpty() && selectedIssueHierarchy.size() >0){
        
            selectedProductLine = selectedIssueHierarchy[0].Product_Line__r.Name;
            
            issueTypeListData();
             
            selectedIssueType = selectedIssueHierarchy[0].Issue_Type__r.Description__c;
            reasonStr = selectedIssueHierarchy[0].Reason__r.Description__c;
            causeStr = selectedIssueHierarchy[0].Cause__r.Description__c;
            
            if(customerRecType != ''){
                if(customerRecType == 'consumer'){ 
                    listIssueHierarchy.addAll([
                                    Select Id,Name, Reason__c,Reason__r.Name,Reason__r.Description__c,
                                    Product_Line__c,Product_Line__r.Name,
                                    Issue_Type__c,Issue_Type__r.Description__c,Issue_Type__r.Name,
                                    Cause__c,Cause__r.Description__c ,Cause__r.Name,
                                    Classification__c,Classification__r.Description__c,Classification__r.Name,
                                    Group__c, Group__r.Description__c, Group__r.Name
                                    From Issue_Hierarchy__c 
                                    Where Active__c = true and Reason__r.Description__c =:reasonStr and Cause__r.Description__c =:causeStr 
                                    and Product_Line__r.Name =: selectedProductLine  and  Issue_Type__r.Description__c =:selectedIssueType
                                    and (Cust_Cons_Flag__c = 'ALL' or Cust_Cons_Flag__c = 'CONS' or Cust_Cons_Flag__c = 'IQOS') 
                                    Limit 1000 
                                    ]);
                  }else{
                  
                      listIssueHierarchy.addAll([
                                    Select Id,Name, Reason__c,Reason__r.Name,Reason__r.Description__c,
                                    Product_Line__c,Product_Line__r.Name,
                                    Issue_Type__c,Issue_Type__r.Description__c,Issue_Type__r.Name,
                                    Cause__c,Cause__r.Description__c ,Cause__r.Name,
                                    Classification__c,Classification__r.Description__c,Classification__r.Name,
                                    Group__c, Group__r.Description__c, Group__r.Name
                                    From Issue_Hierarchy__c 
                                    Where Active__c = true and Reason__r.Description__c =:reasonStr and Cause__r.Description__c =:causeStr 
                                    and Product_Line__r.Name =: selectedProductLine  and  Issue_Type__r.Description__c =:selectedIssueType
                                    and (Cust_Cons_Flag__c = 'ALL' or Cust_Cons_Flag__c = 'CUST') 
                                    Limit 1000 
                                    ]);
                  
                  }
            }
            if(!listIssueHierarchy.isEmpty()){      
                for(Issue_Hierarchy__c ih : listIssueHierarchy){
                    if(ih.id == selectedIssueHierarchy[0].id)
                        issueHierList.add(new causeWrapper(true,ih)); //w.radio=true;
                    else
                        issueHierList.add(new causeWrapper(false,ih)); //w.radio=false;
                    
                    ShowpageBlock=true;              
                }   
            }     
        }                                     
        return null;
    }
    
    /* Get Reason data */
    @RemoteAction
    public static set<string> getReasonStatic(String produtLine, String issueType, String cause, String customerRecType){
        List<Issue_Hierarchy__c> listIssueHierarchy = new List<Issue_Hierarchy__c>();
        set<string> tempReason = new set<string>();
        String query = 'Select id, Name,Reason__c, Reason__r.Description__c From Issue_Hierarchy__c Where Active__c = true';
        query += ' and Product_Line__r.Name = \''+produtLine+'\'';
        
        if(issueType != '' && issueType  !=  '0')
            query += 'and Issue_Type__r.Description__c =\''+ issueType +'\'';
            
        if(cause != '' && cause !=  '0')
            query += 'and Cause__r.Description__c =\''+ cause +'\'';
        
        if(customerRecType != ''){
            if(customerRecType == 'consumer')    
                query += ' and (Cust_Cons_Flag__c = \'ALL\' or Cust_Cons_Flag__c = \'CONS\' or Cust_Cons_Flag__c = \'IQOS\') '; 
            else
                query += ' and (Cust_Cons_Flag__c = \'ALL\' or Cust_Cons_Flag__c = \'CUST\') '; 
        }
        query += ' order by Reason__r.Description__c';        
        for(Issue_Hierarchy__c result : (List<Issue_Hierarchy__c>)Database.query(query)){
            tempReason.add(result.Reason__r.Description__c);
        }
        
        system.debug('test tempReason '+tempReason);
        return tempReason;
    }
    
    /* Get Cause data */
    @RemoteAction
    public static set<string> getCauseStatic(String produtLine, String issueType, String reason, String customerRecType){
        List<Issue_Hierarchy__c> listIssueHierarchy = new List<Issue_Hierarchy__c>();
        set<string> CauseList = new set<string>();
        String query = 'Select id,Name, Cause__c, Cause__r.Description__c From Issue_Hierarchy__c Where Active__c = true';
        query += ' and Product_Line__r.Name = \''+produtLine+'\'';
        
        if(issueType != '' && issueType  !=  '0')
            query += 'and Issue_Type__r.Description__c =\''+ issueType +'\'';
            
        if(reason != '' && reason !=  '0')
            query += 'and Reason__r.Description__c =\''+ reason +'\'';
        
        if(customerRecType != ''){
            if(customerRecType == 'consumer')    
                query += ' and (Cust_Cons_Flag__c = \'ALL\' or Cust_Cons_Flag__c = \'CONS\' or Cust_Cons_Flag__c = \'IQOS\') '; 
            else
                query += ' and (Cust_Cons_Flag__c = \'ALL\' or Cust_Cons_Flag__c = \'CUST\') '; 
        }
        query += ' order by Cause__r.Description__c';        
        system.debug('test query '+query);        
        
        for(Issue_Hierarchy__c ih : (List<Issue_Hierarchy__c>)Database.query(query)){
           CauseList.add(ih.Cause__r.Description__c);
              
        }
        
        return CauseList;
    }
    
    /* Get Issue Hierarchy data */
    public PageReference getIssueHierarchyData(){
        List<Issue_Hierarchy__c> listIssueHierarchy = new List<Issue_Hierarchy__c>();
        issueHierList = new List<causeWrapper>();
        
        causeStr=Apexpages.currentPage().getParameters().get('firstParam');
        reasonStr=Apexpages.currentPage().getParameters().get('secondParam');
        
        if(reasonStr!=null && reasonStr!='' && causeStr!=null && causeStr!=''){
            if(customerRecType != ''){
                if(customerRecType == 'consumer') 
                     listIssueHierarchy.addAll([
                        Select Id,Name, Reason__c,Reason__r.Name,Reason__r.Description__c,
                        Product_Line__c ,Product_Line__r.Name,
                        Issue_Type__c,Issue_Type__r.Description__c,Issue_Type__r.Name,
                        Cause__c,Cause__r.Description__c ,Cause__r.Name,
                        Classification__c,Classification__r.Description__c,Classification__r.Name,
                        Group__c, Group__r.Description__c, Group__r.Name
                        From Issue_Hierarchy__c 
                        Where Active__c = true and Reason__r.Description__c =:reasonStr and Cause__r.Description__c =:causeStr 
                        and Product_Line__r.Name =: selectedProductLine  and  Issue_Type__r.Description__c =:selectedIssueType
                        and (Cust_Cons_Flag__c = 'ALL' or Cust_Cons_Flag__c = 'CONS' or Cust_Cons_Flag__c = 'IQOS') 
                        Limit 1000
                        ]);
                else
                     
                     listIssueHierarchy.addAll([
                        Select Id,Name, Reason__c,Reason__r.Name,Reason__r.Description__c,
                        Product_Line__c,Product_Line__r.Name,
                        Issue_Type__c,Issue_Type__r.Description__c,Issue_Type__r.Name,
                        Cause__c,Cause__r.Description__c ,Cause__r.Name,
                        Classification__c,Classification__r.Description__c,Classification__r.Name,
                        Group__c, Group__r.Description__c, Group__r.Name
                        From Issue_Hierarchy__c 
                        Where Active__c = true and Reason__r.Description__c =:reasonStr and Cause__r.Description__c =:causeStr 
                        and Product_Line__r.Name =: selectedProductLine  and  Issue_Type__r.Description__c =:selectedIssueType
                        and (Cust_Cons_Flag__c = 'ALL' or Cust_Cons_Flag__c = 'CUST') 
                        Limit 1000
                        ]);
            }
           system.debug('-----listIssueHierarchy-----'+listIssueHierarchy);
            if(!listIssueHierarchy.isEmpty()){                           
                for(Issue_Hierarchy__c ih : listIssueHierarchy){
                                      
                    issueHierList.add(new causeWrapper(false,ih)); 
                            
                    ShowpageBlock=true;              
                }
            }
        }
        
        return null;
    }
    
    
    
    
    /* Wrapper Class */
    Public class causeWrapper{
        Public Boolean radio{get;set;}
        Public String groupName{get;set;}
        Public String classification{get;set;}
        Public String cause{get;set;}
        Public String issuetype {get;set;}
        Public String reason {get;set;}
        Public Issue_Hierarchy__c issuehierarchyObj{get;set;}
        Public causeWrapper(Boolean radio,Issue_Hierarchy__c ih){
            this.radio=false;
            this.issuehierarchyObj = ih;
            system.debug('----this.issuehierarchyObj---------'+this.issuehierarchyObj);
            this.reason = '';
            system.debug('----this.reason-------'+this.reason);
                        system.debug('----Description__c-----'+ih.Reason__r.Description__c);
            this.reason = ih.Reason__r.Description__c.replace('\'','\\'+'\'');
            this.cause = ih.Cause__r.Description__c.replace('\'','\\'+'\'');    
            this.groupName = ih.Group__r.Description__c.replace('\'','\\'+'\'');
            this.classification = ih.Classification__r.Description__c.replace('\'','\\'+'\'');
            this.issuetype = ih.Issue_Type__r.Description__c.replace('\'','\\'+'\'');
        }
        Public causeWrapper(){}          
    } 
   
}