public with sharing class ArticleMappingController {  
    
    
    public Natural_Language__c natlangObj {get; set;}
    private Id natlangId; 
    public boolean ArticleHidePanel {get;set;}
    
    // SelectOption lists for public consumption
    public SelectOption[] leftArticleOptionsValue { get; set; }
    public SelectOption[] rightArticleOptionsValue { get; set; }
    public String tooltipArticle{get;set;}
    public Map<Id, Natural_Language_Knowledge_Junction__c> mapArticle = new Map<Id, Natural_Language_Knowledge_Junction__c>();
    public Map<id,Natural_Language_Knowledge_Junction__c > emptyArticle = new Map<id,Natural_Language_Knowledge_Junction__c>();

    
    public ArticleMappingController(ApexPages.StandardController controller) {
        pageInit();
    }

    
    private void pageInit(){
        natlangId = ApexPages.currentPage().getParameters().get('id');
        natlangObj = new Natural_Language__c();
        if(natlangId != null ){
            natlangObj = [Select id, Natural_Language__c from Natural_Language__c where id = :natlangId ];
            System.debug('----------'+natlangObj);
        }
        
        tooltipArticle = '';
        leftArticleOptionsValue = new List<SelectOption>();
        rightArticleOptionsValue = new List<SelectOption>();
        retrieveArticleNumber();
        retrieveSelectedArticleNumber(); 
        
    }
    
    public void retrieveArticleNumber(){
        for(KnowledgeArticleVersion t :[
            SELECT ID,knowledgeArticleid,  ArticleNumber, title
            FROM KnowledgeArticleVersion 
            WHERE PublishStatus ='Online' and Language = 'en_US' 
            ORDER BY title 
        ]){
            if(!mapArticle.ContainsKey(t.knowledgeArticleid)){
                ArticleHidePanel  = true;
                leftArticleOptionsValue.add(new SelectOption(t.knowledgeArticleid,t.title ));
                if(tooltipArticle == '') {
                    tooltipArticle =  t.title ;
                }else{
                    tooltipArticle = tooltipArticle +'\n' + t.title;       
                }
            }
        }
    }
    
    public void retrieveSelectedArticleNumber(){
        if(natlangId  != null){
            for(Natural_Language_Knowledge_Junction__c t :[
                SELECT ID,Natural_Language__c,Article_ID__c,title__c
                FROM Natural_Language_Knowledge_Junction__c
                WHERE Natural_Language__c=:natlangId
            ]){
                if(t.Article_ID__c != null){
                    rightArticleOptionsValue.add(new SelectOption(t.id,t.title__c));
                    mapArticle.put(t.id,t);
                    ArticleHidePanel  = true;
                    if(tooltipArticle == '') {
                        tooltipArticle =  t.title__c ;
                    }else{
                        tooltipArticle = tooltipArticle +'\n' + t.title__c ;       
                    }
                }else{
                    emptyArticle.put(t.id, t);
                }
            }
        }
    }
    
    // Parse &-separated values and labels from value and 
    // put them in option
    public void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'), 
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
    
    // Backing for hidden text field containing the options from the
    // left list
    public String leftArticleOptionsHidden { get; set {
           leftArticleOptionsHidden = value;
           setOptions(leftArticleOptionsValue, value);
        }
    }
   
    // Backing for hidden text field containing the options from the
    // right list
    public String rightArticleOptionsHidden { get; set {
           rightArticleOptionsHidden = value;
           setOptions(rightArticleOptionsValue, value);
        }
    }
     
    /*Save method for Article mapping*/
     public PageReference saveMe(){
         
         
        List<Natural_Language_Knowledge_Junction__c> InsertList = new List<Natural_Language_Knowledge_Junction__c>();
        List<Natural_Language_Knowledge_Junction__c> deletedList = new List<Natural_Language_Knowledge_Junction__c>();
        List<Id> splitedSelectedArticleId = new List<Id>();
        List<Id> splitedleftArticleId = new List<Id>();
       
        for (SelectOption so : rightArticleOptionsValue) {
            splitedSelectedArticleId.add(so.getValue());
        }
        
        for (SelectOption so : leftArticleOptionsValue) {
            splitedleftArticleId.add(so.getValue());
        }
                 
        if(splitedSelectedArticleId == null || splitedSelectedArticleId.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Article selected'));
        }else{
             try{
                 for(ID t :splitedSelectedArticleId){
                     if(!mapArticle.ContainsKey(t)){
                         Natural_Language_Knowledge_Junction__c kartv = new Natural_Language_Knowledge_Junction__c();
                         kartv.Article_ID__c = t;
                         kartv.Natural_Language__c = natlangObj.id;
                         KnowledgeArticleVersion articleObj =[SELECT ID,knowledgeArticleid,ArticleNumber, title
                                                     FROM KnowledgeArticleVersion 
                                                     WHERE PublishStatus ='Online' and Language = 'en_US' and knowledgeArticleid=:t];
                         kartv.Title__c=articleObj.Title;
                         InsertList.add(kartv);
                     }
                 }
                 
                 for(ID t :splitedleftArticleId){
                     if(mapArticle.ContainsKey(t)){
                          deletedList.add(mapArticle.get(t));
                    }
                 }
                 
                 if(!emptyArticle.isEmpty()){
                    for(Natural_Language_Knowledge_Junction__c ids :emptyArticle.values()){
                        deletedList.add(ids);
                     }
                 }
                 
                 if(InsertList.size() > 0){
                        insert InsertList;
                 }
                 
                 if(deletedList.size() > 0){
                        delete deletedList;
                 }
                
                 return new PageReference('/'+this.natlangObj.id);
            
             }catch(Exception e){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Server Error')); 
             }
         }
         return null;
     }
          
     
     /*Retrun to detail page for Natural Language.*/
     public PageReference cancel() {
        system.debug('garima test cancel');
        return new PageReference('/'+this.natlangObj.id);
     }

}