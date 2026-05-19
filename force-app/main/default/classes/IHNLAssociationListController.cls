public class IHNLAssociationListController {
    
    public List<IssueHierWrapper> ihnlList{get;set;}
    public List<KnowledgeWrapper> knowledgeList{get;set;}
    private Natural_Language__c natlangObj;
    public String selectedProductLine {get; set;} /* String to hold Product Line data */
    public String selectedIssueType {get; set;} /* String to hold Issue Type data */
    public String natlang{get;set;}
    public string customerRecType{get;set;}
    public List<SelectOption> productLineList {get; set;} /* List to hold Product Line data */
    public List<SelectOption> issueTypeList {get; set;} /* List to hold Issue Type data */
    private String productLine = Apexpages.currentpage().getparameters().get('productlinecode');
    public String issueHierId {get; set;} /* String to hold Issue Hierarchy ID */
    public string natlangHtml {get; set;}
    public string ArticleId {get; set;}
    
    //Controller method for IHNLAssociationListController class.
    public IHNLAssociationListController(ApexPages.StandardController stdController){
        
        
        this.natlangObj = (Natural_Language__c)stdController.getRecord();
        ihnlList=new List<IssueHierWrapper>();
        knowledgeList=new  List<KnowledgeWrapper>();
        Cookie counter = ApexPages.currentPage().getCookies().get('customerRecType');
        ArticleId = '';
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

    
    public pageReference reset(){
        selectedProductLine = '';
        selectedIssueType = '';
        issueHierId = '';
        natlang = '';
        natlangHtml  = '';
        ihnlList=new List<IssueHierWrapper>();
        knowledgeList=new  List<KnowledgeWrapper>();
        issueTypeListData();        
        return null;
    }

    /* Reset values on change of Product Line */
    public pageReference onChangeproductLine(){
        selectedProductLine = '';
        selectedIssueType = '';
        issueHierId = '';
        issueTypeList.clear();
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
        issueTypeListData();
    }

    /* Create the Issue Type List from Issue Hierarchy data when Product Line item is selected using aggregate method */
    public void issueTypeListData()
    {   
        If(selectedProductLine != null && selectedProductLine != ''){ 
            issueTypeList = new List<SelectOption>(); 
            issueTypeList.add(new SelectOption('0', '--Select Issue Type--')); 
            
            string product =Apexpages.currentPage().getParameters().get('productParam');                                                 
                                                
            String query = 'Select Count(id), Issue_Type__r.Description__c From Issue_Hierarchy__c Where Active__c = true and Issue_Type__c != null';
        
            query += ' and Product_Line__r.Name = \''+ selectedProductLine +'\'';
            
            if(customerRecType != ''){
                if(customerRecType == 'consumer')    
                    query += ' and (Cust_Cons_Flag__c = \'ALL\' or Cust_Cons_Flag__c = \'CONS\') '; 
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
            
        List<IHNL_Association__c> ihnlListdata = new List<IHNL_Association__c>();
        List<Issue_Hierarchy__c> IHMasterData=new List<Issue_Hierarchy__c>();
        List<IHNL_Association__c> selectedIssueHierarchy = new List<IHNL_Association__c>();
        ihnlList = new List<IssueHierWrapper>();
        selectedIssueHierarchy  = new List<IHNL_Association__c>([
                                      select id,Issue_Hierarchy__c,Natural_Language__r.Natural_Language__c,
                                        Issue_Hierarchy__r.Name,Issue_Hierarchy__r.Group__r.Description__c,Issue_Hierarchy__r.Classification__r.Description__c,
                                      Issue_Hierarchy__r.Product_Line__r.Name,Issue_Hierarchy__r.Issue_Type__r.Description__c,Issue_Hierarchy__r.Reason__r.Description__c,
                                      Issue_Hierarchy__r.Cause__r.Description__c
                                      from IHNL_Association__c 
                                      Where Issue_Hierarchy__c =:issueHierId
                                      Limit 1
                                      ]);
                                      
        if(!selectedIssueHierarchy.isEmpty() && selectedIssueHierarchy.size() >0){
        
            selectedProductLine = selectedIssueHierarchy[0].Issue_Hierarchy__r.Product_Line__r.Name;
            
            issueTypeListData();
             
            selectedIssueType = selectedIssueHierarchy[0].Issue_Hierarchy__r.Issue_Type__r.Description__c;
            natlangHtml = selectedIssueHierarchy[0].Natural_Language__r.Natural_Language__c;
            natlang = selectedIssueHierarchy[0].Natural_Language__r.Natural_Language__c;
            
        if(customerRecType != ''){
            //create a string
            String ntData = natlang;
            
            //add wildcards around it to be more flexible in the search
            ntData = '%' + ntData + '%';
             
                if(customerRecType == 'consumer') 
                     ihnlListdata.addAll([
                      select id,Issue_Hierarchy__c,Natural_Language__r.Natural_Language__c
                      from IHNL_Association__c 
                      where Issue_Hierarchy__r.Product_Line__r.Name =: selectedProductLine 
                      and Issue_Hierarchy__r.Issue_Type__r.Description__c =: selectedIssueType 
                      and Natural_Language__r.Natural_Language__c LIKE :ntData
                      and (Issue_Hierarchy__r.Cust_Cons_Flag__c = 'ALL' or Issue_Hierarchy__r.Cust_Cons_Flag__c = 'CONS') 
                      Limit 1000]);
                else
                     
                     ihnlListdata.addAll([
                      select id,Issue_Hierarchy__c,Natural_Language__r.Natural_Language__c
                      from IHNL_Association__c 
                      where Issue_Hierarchy__r.Product_Line__r.Name =: selectedProductLine 
                      and Issue_Hierarchy__r.Issue_Type__r.Description__c =: selectedIssueType 
                      and Natural_Language__r.Natural_Language__c LIKE :ntData
                      and (Issue_Hierarchy__r.Cust_Cons_Flag__c = 'ALL' or Issue_Hierarchy__r.Cust_Cons_Flag__c = 'CUST') 
                      Limit 1000]);
            }
            
            Map<Id, set<String>> natlangMap = new Map<id, set<String>>();
            
           for(IHNL_Association__c ihnlObj:ihnlListdata){
               set<String> nlData = new set<String>();
               if(!natlangMap.containsKey(ihnlObj.Issue_Hierarchy__c)){
                   nlData.add(ihnlObj.Natural_Language__r.Natural_Language__c);
                   natlangMap.put(ihnlObj.Issue_Hierarchy__c, nlData);
               }else{               
                   set<String> nl = natlangMap.get(ihnlObj.Issue_Hierarchy__c); 
                   if(!nl.Contains(ihnlObj.Natural_Language__r.Natural_Language__c))
                   natlangMap.get(ihnlObj.Issue_Hierarchy__c).add(ihnlObj.Natural_Language__r.Natural_Language__c);    
               }
           }
           
           IHMasterData= new List<Issue_Hierarchy__c>([Select id,Name,Group__r.Description__c,Classification__r.Description__c,
                             Product_Line__r.Name,Issue_Type__r.Description__c,Reason__r.Description__c,
                             Cause__r.Description__c
                             from Issue_Hierarchy__c where id in :natlangMap.keyset()]);
       
       
            if(!IHMasterData.isEmpty()){                           
                for(Issue_Hierarchy__c ih : IHMasterData){  
                    if(ih.id == selectedIssueHierarchy[0].Issue_Hierarchy__c)
                        ihnlList.add(new IssueHierWrapper(true,ih,natlangMap.get(ih.id)));  
                    else
                        ihnlList.add(new IssueHierWrapper(false,ih,natlangMap.get(ih.id))); 
                    
                }
            }
            knowledgeArticleList();  
        }                                     
        return null;
    }
    
    //get All Naturatl Language Names.
    @RemoteAction
    public static set<string> natLangList(String produtLine, String issueType){
        List<IHNL_Association__c> ihnlListdata = new List<IHNL_Association__c>([select id,Natural_Language__c
                                                                              from IHNL_Association__c 
                                                                              where Issue_Hierarchy__r.Product_Line__r.Name =: produtLine and 
                                                                              Issue_Hierarchy__r.Issue_Type__r.Description__c =: issueType]);
        Set<id> ids = new Set<Id>();
        Set<String> NLData = new Set<String>();
        if(!ihnlListdata.isEmpty()){
            for(IHNL_Association__c ih : ihnlListdata){
                if(ih.Natural_Language__c != null)
                    ids.add(ih.Natural_Language__c);
            }        
        }    
        //Natural_Language__r.Natural_Language__c   
        List<Natural_Language__c> natLangList=new List<Natural_Language__c>();
        if(!ids.isEmpty()){
            for(Natural_Language__c ih : [select id,Natural_Language__c from Natural_Language__c where id in: ids]){
               NLData.add(ih.Natural_Language__c);                  
            }
        }
        
        
        return NLData;
        
    }
    
    //Method to get all the related Issue Hierarchy.
    public PageReference IssueHierList(){
        List<IHNL_Association__c> ihnlListdata =new List<IHNL_Association__c>();
        List<Issue_Hierarchy__c> IHMasterData=new List<Issue_Hierarchy__c>();
        ihnlList = new List<IssueHierWrapper>();
        if(customerRecType != '' && natlang.length() >1){
            //create a string
            String ntData = natlang;
            
            //add wildcards around it to be more flexible in the search
            ntData = '%' + ntData + '%';
            System.debug('test ntData '+ntData +','+selectedProductLine+',' +selectedIssueType );
                if(customerRecType == 'consumer') 
                     ihnlListdata.addAll([
                      select id,Issue_Hierarchy__c,Natural_Language__r.Natural_Language__c
                      from IHNL_Association__c 
                      where Issue_Hierarchy__r.Product_Line__r.Name =: selectedProductLine 
                      and Issue_Hierarchy__r.Issue_Type__r.Description__c =: selectedIssueType 
                      and Natural_Language__r.Natural_Language__c LIKE :ntData
                      and (Issue_Hierarchy__r.Cust_Cons_Flag__c = 'ALL' or Issue_Hierarchy__r.Cust_Cons_Flag__c = 'CONS') 
                      Limit 1000]);
                else
                     
                     ihnlListdata.addAll([
                      select id,Issue_Hierarchy__c,Natural_Language__r.Natural_Language__c
                      from IHNL_Association__c 
                      where Issue_Hierarchy__r.Product_Line__r.Name =: selectedProductLine 
                      and Issue_Hierarchy__r.Issue_Type__r.Description__c =: selectedIssueType 
                      and Natural_Language__r.Natural_Language__c LIKE :ntData
                      and (Issue_Hierarchy__r.Cust_Cons_Flag__c = 'ALL' or Issue_Hierarchy__r.Cust_Cons_Flag__c = 'CUST') 
                      Limit 1000]);
            }
        
       Map<Id, Set<String>> natlangMap = new Map<id, Set<String>>();
       System.debug('test ihnlListdata '+ihnlListdata); 
       for(IHNL_Association__c ihnlObj:ihnlListdata){
           set<String> nlData = new set<String>();
           if(!natlangMap.containsKey(ihnlObj.Issue_Hierarchy__c)){
               nlData.add(ihnlObj.Natural_Language__r.Natural_Language__c);
               natlangMap.put(ihnlObj.Issue_Hierarchy__c, nlData);
           }else{               
               Set<String> nl = natlangMap.get(ihnlObj.Issue_Hierarchy__c); 
               if(!nl.Contains(ihnlObj.Natural_Language__r.Natural_Language__c))
                   natlangMap.get(ihnlObj.Issue_Hierarchy__c).add(ihnlObj.Natural_Language__r.Natural_Language__c);
           }
       }
       
       IHMasterData= new List<Issue_Hierarchy__c>([Select id,Name,Group__r.Description__c,Classification__r.Description__c,
                         Product_Line__r.Name,Issue_Type__r.Description__c,Reason__r.Description__c,
                         Cause__r.Description__c
                         from Issue_Hierarchy__c where id in :natlangMap.keyset()]);
                          
        if(!IHMasterData.isEmpty()){                           
            for(Issue_Hierarchy__c ih : IHMasterData){                
                ihnlList.add(new IssueHierWrapper(false,ih,natlangMap.get(ih.id))); 
            }
        }
        return null;
    }
    
    //Method to get all the related article.
    public PageReference knowledgeArticleList(){
        knowledgeList = new List<KnowledgeWrapper>();
        if(natlang.length() >1){
            List<IHNL_Association__c> ihnlListdata = new List<IHNL_Association__c>([select id,Natural_Language__c
                                                                                  from IHNL_Association__c 
                                                                                  where Issue_Hierarchy__r.Product_Line__r.Name =: selectedProductLine and 
                                                                                  Issue_Hierarchy__r.Issue_Type__r.Description__c =: selectedIssueType]);
            Set<id> ids = new Set<Id>();
            Set<String> NLData = new Set<String>();
            if(!ihnlListdata.isEmpty()){
                for(IHNL_Association__c ih : ihnlListdata){
                    if(ih.Natural_Language__c != null)
                        ids.add(ih.Natural_Language__c);
                }        
            }    
            //Natural_Language__r.Natural_Language__c   
            List<Natural_Language__c> natLangList=new List<Natural_Language__c>();
            if(!ids.isEmpty()){
                for(Natural_Language__c ih : [select id,Natural_Language__c from Natural_Language__c where id in: ids]){
                   NLData.add(ih.Natural_Language__c);                  
                }
            }
            system.debug('test natlang '+natlang);
            //create a string
            String ntData = natlang;
            
            //add wildcards around it to be more flexible in the search
            ntData = '%' + ntData + '%';
            List<Natural_Language_Knowledge_Junction__c> knowledgeListData = [select id,Article_ID__c,Title__c
                                                                              from Natural_Language_Knowledge_Junction__c 
                                                                              where Natural_Language__c in: ids
                                                                              and Natural_Language__r.Natural_Language__c LIKE :ntData];
            
            if(knowledgeListData.size()>0){
                for(Natural_Language_Knowledge_Junction__c k :knowledgeListData){
                    KnowledgeWrapper kp = new KnowledgeWrapper();
                    kp.titleWithSpace = k.Title__c;
                    kp.articleId = k.Article_ID__c;
                    
                    knowledgeList.add(kp);
                }
            }
        }
        return null;
    }
    
    public class KnowledgeWrapper{
        public string titleWithSpace {get;set;}
        public string articleId {get;set;}        
    }
    
    /* Wrapper Class */
    Public class IssueHierWrapper{
        Public Boolean radio{get;set;}
        Public String groupName{get;set;}
        Public String classification{get;set;}
        Public String cause{get;set;}
        Public String issuetype {get;set;}
        Public String reason {get;set;}
        Public String natlang{get;set;}
        Public Integer nlSize{get;set;}
        public set<String> nlDataList {get;set;}
        Public Issue_Hierarchy__c issuehierarchyObj{get;set;}
        Public IssueHierWrapper(Boolean radio,Issue_Hierarchy__c ih, set<String> nlData){
            this.radio=false;
            this.issuehierarchyObj = ih;
            this.reason = '';
            nlSize = 0;
            nlDataList = new set<String>();
            nlDataList = nlData;
            nlSize = nlDataList.size();
            this.reason = ih.Reason__r.Description__c.replace('\'','\\'+'\'');
            this.cause = ih.Cause__r.Description__c.replace('\'','\\'+'\'');    
            this.groupName = ih.Group__r.Description__c.replace('\'','\\'+'\'');
            this.classification = ih.Classification__r.Description__c.replace('\'','\\'+'\'');
            this.issuetype = ih.Issue_Type__r.Description__c.replace('\'','\\'+'\'');
        }
        Public IssueHierWrapper(){}          
    } 
        
}