public with sharing class IssueSurveyController{
          
    public String StartIndex {get; set;}
    public Map<String,Boolean> nextButton {get;set;}
    public Map<String,Boolean> preButton {get;set;}
    public Map<string,wrapperMapping> wrpList {get;set;}
    public Set<string> SurveyQuestionIds {get;set;}
    public Case issueObj{get;set;} 
    public Boolean questionRequired {get;set;}
    public Boolean saveError {get;set;}
    public List<String> surveyNameList {get;set;}
    public boolean mainScreen {get;set;}
    public boolean surveyScreen {get;set;}
    public boolean cancelScreen {get;set;}
    public string endSurveyType {get;set;}
   	public Case issueObjNew {get;set;}
    public boolean IQOSSurvey {get;set;}
    public boolean multiSurvey {get;set;}
    public boolean isIQOSsurveyOffered {get;set;}
    public boolean isSurveyOffered {get;set;}
 
    private boolean isRequired = false;
    private boolean isTest = false;
    private string  firstQuestionId;    
    private map<string,string> previousNodeInfo; 
    private Map<id,Survey__c> surveyMapData;
    private Transaction_Management__c transactionObj;  
    private Map<String,wrapperRequiredMapping> requiedQuestion;
    private string questionTerId;
    private string questionTerId1;
    
    public IssueSurveyController(){       
        string issueId = ApexPages.currentPage().getParameters().get('issueId');
        string tranId = ApexPages.currentPage().getParameters().get('tranId');
        wrpList = new Map<string,wrapperMapping>();
        previousNodeInfo = new map<string,string>();
        nextButton = new  Map<String,Boolean>();
        preButton = new  Map<String,Boolean>();
        SurveyQuestionIds = new Set<string>();
        surveyNameList = new List<String>();
        questionRequired = false;
        requiedQuestion =  new Map<String,wrapperRequiredMapping>();
        isSurveyOffered = false;
        isIQOSsurveyOffered = false;
        saveError = false;
        surveyScreen = false;
        mainScreen = false;
        cancelScreen = false;
        questionTerId = '';
        transactionObj = new Transaction_Management__c();
        issueObj = [Select id, CaseNumber,Issue_Hierarchy_Code__c, CaseNumber__c,SurveyHiddenReason__c,
                   Issue_Hierarchy_Code__r.Survey_Requirements__c,Survey__c,Survey_Cancel_Reason__c,Survey_Cancel_Comments__c
                   from Case where id =:issueId];
        
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();
            transactionObj = [Select id,contact__c from Transaction_Management__c  where id = :tranId];
        } 
                        
        surveyMapData = new Map<id,Survey__c>();
        
        surveyMapData = getSurveyList(issueObj);
        
        If(!surveyMapData.isEmpty()){
            mainScreen = true;
            for(Survey__c suv :surveyMapData.values()){
                surveyNameList.add(suv.Survey_Name__c);
            } 
        }  
        //Check if IQOS Survey is offered
        if(surveyNameList.contains('IQOS APE')){
           	IQOSSurvey = true;
            //Check if there are multiple survey offers for the issue
            if(surveyMapData.size()>1){
                multiSurvey = true;
                //Check if there is an answer on another survey
                List<aggregateResult> ag = [SELECT Survey__c FROM Survey_Issue__c 
                                                WHERE Issue__c =: issueId AND Survey_Name__c = 'IQOS APE'
                                                GROUP BY Survey__c];
                if(ag.size()>0){
                    isIQOSSurveyOffered = true;
                }else{
                    isRequired = true;
                }
                
                List<aggregateResult> agr = [SELECT Survey__c FROM Survey_Issue__c 
                                                WHERE Issue__c =: issueId AND Survey_Name__c != 'IQOS APE'
                                                GROUP BY Survey__c];
                if(agr.size()>0){
                    isSurveyOffered = true;
                }
            }
        }
    }
    
    public pagereference StartSurveySection(){
        PageReference retURL = new PageReference('/apex/IssueSurveySection?issueId='+issueObj.Id);
        retURL.setRedirect(true);
        return retURL;
    }
    
    public pagereference StartSurvey(){
        if(!surveyMapData.isEmpty()  && surveyMapData.size() >0){
          System.debug('------surveyMapData.keySet---------'+surveyMapData.keySet());                                                                          
            Map<id,Survey_Configuration__c> sqa =new Map<id,Survey_Configuration__c>([select id,Answer__c,AnswerText__c,Answer_Sequence__c,CommentRequired__c,
                                                                                    QuestionFrom__c,QuestionFrom__r.Type__c,QuestionFromText__c,
                                                                                    Starting_Question__c,End_Question__c,
                                                                                    Question_Required__c,Question_Sequence__c,QuestionTo__c,
                                                                                    Survey__c,Survey__r.Survey_Name__c
                                                                                    from Survey_Configuration__c                                                                                    
                                                                                    where Active__c = true and  Survey__c  in : surveyMapData.keySet()
                                                                                    and Survey__r.Survey_Name__c != 'IQOS APE'
                                                                                    order by Survey__r.Survey_Name__c,Question_Sequence__c,Answer_Sequence__c asc                                                                                    
                                                                                    ]);
                                                                                    
            System.debug('test size sqa '+sqa.size() );                                                                       
            List<Survey_Issue__c> oldSurveyIssue = new List<Survey_Issue__c>([Select id, Answer__c, Issue__c, Comment__c, Question__c,Survey__c,Transaction__c,
                                                                              Question_Sequence__c,Answer_Sequence__c  
                                                                              From Survey_Issue__c 
                                                                              Where isActive__c =  true
                                                                              and Issue__c =: issueObj.id 
                                                                              ]);
                                                                                    
            Map<String,Survey_Issue__c> mapSurvey = new Map<String,Survey_Issue__c>();
            Map<String,Survey_Issue__c> mapSurveyOnlyQuestion = new Map<String,Survey_Issue__c>();
            
            if(!oldSurveyIssue.isEmpty()){
                for(Survey_Issue__c svy: oldSurveyIssue){
                    String sMap = String.valueOf(svy.Survey__c) + String.valueOf(svy.Question__c) + String.valueOf(svy.Answer__c);
                    String sMap1 = String.valueOf(svy.Survey__c) + String.valueOf(svy.Question__c);
                    
                    if(!mapSurvey.ContainsKey(sMap)){
                        mapSurvey.put(sMap, svy);
                    }
                    
                    if(!mapSurveyOnlyQuestion.ContainsKey(sMap1)){
                        mapSurveyOnlyQuestion.put(sMap1, svy);
                    }
                }            
            }
                                                                                    
            Map<Id,String> surveyStartQuestion = new Map<Id,String>();
            if(!sqa.isEmpty() && sqa.size() >0){
                for(Survey_Configuration__c sqMap :sqa.Values()){                   
                    if(!surveyStartQuestion.ContainsKey(sqMap.Survey__c) && sqMap.Starting_Question__c){
                        String MapData  = String.ValueOf(sqMap.Survey__c)+String.ValueOf(sqMap.QuestionFrom__c);                        
                        surveyStartQuestion.put(sqMap.Survey__c,MapData);
                    }
                }         
            }
                                                                                   
                                                                                    
           Set<Id> questionIds = new set<Id>();
           Map<String,Survey__c> surveyMapName = new Map<String,Survey__c>();
           ID lastSurvey;
           Integer surveyCount = 0;
           for(Survey__c sury :surveyMapData.values()){ 
               surveyMapName.put(sury.Survey_Name__c,sury);
           }
           
           lastSurvey = surveyMapName.get(surveyNameList[surveyNameList.size()-1]).id;           
                                                                
           for(String suryName :surveyNameList){
               
               Survey__c sury = surveyMapName.get(suryName);
                for(Survey_Configuration__c suQuestion :sqa.Values()){  
                                   
                    if(sury.id ==  suQuestion.Survey__c){
                        
                        String mapValue = String.valueof(suQuestion.Survey__c)+String.valueof(suQuestion.QuestionFrom__c);                       
                        
                        if(!SurveyQuestionIds.Contains(mapValue)){                            
                             
                            if(wrpList.isEmpty() || wrpList.size() == 0){                 
                                if(StartIndex == null){
                                    StartIndex = mapValue;
                                    firstQuestionId = mapValue;
                                    questionTerId = mapValue;
                                }
                            }
                            SurveyQuestionIds.add(mapValue); 
                                                                           
                            List<wrapperMappingInner> wrpInnerList = new List<wrapperMappingInner>();
                            Set<String>  requiredSet = new Set<String>();
                            
                            for(Survey_Configuration__c r :sqa.Values()){
                                
                                if(sury.id ==  r.Survey__c){ 
                                    if(r.QuestionFrom__c == suQuestion.QuestionFrom__c){  
                                        
                                        Survey_Issue__c surIssueObj;
                                        String sMap = String.valueOf(r.Survey__c) + String.valueOf(suQuestion.QuestionFrom__c) + String.valueOf(r.Answer__c);
                    
                                        if(!mapSurvey.ContainsKey(sMap)){                                  
                                            surIssueObj = new Survey_Issue__c(Survey__c = sury.id,Issue__c= issueObj.id , Transaction__c = transactionObj.id,Question__c = suQuestion.QuestionFrom__c, Question_Sequence__c = suQuestion.Question_Sequence__c,Answer_Sequence__c = r.Answer_Sequence__c, Answer__c = r.Answer__c);
                                        }else{                                            
                                            surIssueObj = mapSurvey.get(sMap);
                                            surIssueObj.Question_Sequence__c = suQuestion.Question_Sequence__c;
                                            surIssueObj.Answer_Sequence__c = r.Answer_Sequence__c;
                                        }
                                        
                                        String sMap1 = String.valueOf(suQuestion.id) + String.valueOf(r.Answer__c);
                                        
                                        if(r.QuestionTo__c == null){
                                            integer i=0;
                                            String nextRoute;
                                            
                                            for(String surName :surveyNameList){
                                                if(i == 1){
                                                    i++;
                                                }
                                                if(surName == sury.Survey_Name__c){
                                                    i++;
                                                }
                                                if(i==2){
                                                   if(surveyStartQuestion.containsKey(surveyMapName.get(surName).id) && lastSurvey != sury.id){
                                                        nextRoute = surveyStartQuestion.get(surveyMapName.get(surName).id);
                                                        requiredSet.add(nextRoute);
                                                    }
                                                    i++;
                                                }
                                                
                                            }
                                            wrpInnerList.add(new wrapperMappingInner(r,surIssueObj,nextRoute ));
                                        }else{                                            
                                            String nextPath = String.valueOf(r.Survey__c)+ string.valueOf(r.QuestionTo__c);
                                            requiredSet.add(nextPath);
                                            
                                            wrpInnerList.add(new wrapperMappingInner(r,surIssueObj,nextPath));
                                        }
                                   } 
                               }                          
                           }
                           
                           String surIssuecomments = '';
                           String sMap11 = String.valueOf(suQuestion.Survey__c) + String.valueOf(suQuestion.QuestionFrom__c);
        
                           if(mapSurveyOnlyQuestion.ContainsKey(sMap11)){                                  
                                surIssuecomments = mapSurveyOnlyQuestion.get(sMap11).Comment__c;
                           }  
                                
                           wrpList.put(mapValue,new wrapperMapping(suQuestion,wrpInnerList,surIssuecomments)); 
                           
                           buttonHide();
                                                      
                           requiedQuestion.put(mapValue,new wrapperRequiredMapping(mapValue,suQuestion.Question_Required__c,requiredSet));                          
                        }                     
                    }                    
                }  
            }
            System.debug('test surveyListName'+surveyNameList);     
        }
        surveyScreen = true;
        mainScreen = false;
        return null; 
    }
    
    public Map<id,Survey__c> getSurveyList(Case issueData){
        
        Map<id,Survey__c> surveyMap = new Map<id,Survey__c>();               
        
        issueSurveyRequired survey = new issueSurveyRequired();
        
        //surveyMap = new Map<id,Survey__c>([Select id,Survey_Name__c from Survey__c where active__c = true  order by Survey_Name__c asc]);
        surveyMap = survey.getsurveyList(issueData.Issue_Hierarchy_Code__c);      
            system.debug('-----------surveyMap-----------'+surveyMap);
        return surveyMap;
    }
    
    public pagereference nextRoute(){
        system.debug('wrpList -- ' + wrpList);
        system.debug('inside nextRoute');
        String quesId = ApexPages.currentPage().getParameters().get('startingPoint');
        system.debug('--quesId---'+quesId);
        if(wrpList.Containskey(quesId)){
            system.debug('inside first if');
            wrapperMapping wp= wrpList.get(quesId);
            system.debug('----wp----'+wp);
            if(wp.questionComment != null && wp.questionComment.trim() != '' && wp.questionComment.trim().length() >= 32768){
                system.debug('inside first if');
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comment: Max. 32768 characters are allowed')); 
                return null;            
            }
            List<wrapperMappingInner> ansMapObj = wp.ansMap;                 
                Boolean CheckBoxChecked  = false;
                if(!ansMapObj.isEmpty()){
                    
                    for(wrapperMappingInner wpInner :ansMapObj){
                        
                        if(wp.questionMap.QuestionFrom__r.Type__c == 'Single Choice'){
                            if(wp.seletedRadio == null || wp.seletedRadio == ''){
                                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select answer')); 
                                return null;
                            }else{
                                if(wp.questionComment == null || wp.questionComment.trim() == ''){ 
                                    for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                        if(wp.seletedRadio == wpInnerCheck.qtn.Answer__c){
                                             if(wpInnerCheck.qtn.CommentRequired__c){
                                                 ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                                 return null;
                                             }
                                        }    
                                    } 
                                }                                
                                    
                                if(wp.seletedRadio == wpInner.qtn.Answer__c){ 
                                    if(wpInner.surIssue.id == null){                                    
                                        for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                            if(wpInnerCheck.surIssue.id != null){
                                                if(wpInner.nextRoute != wpInnerCheck.nextRoute){
                                                     ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Answer cannot be changed'));
                                                     return null;
                                                }
                                            }    
                                        }                                    
                                    }
                                    questionTerId1 = wp.surveyQuestionId;
                                    StartIndex = wpInner.nextRoute;
                                    questionTerId = StartIndex; 
                                    previousNodeInfo.put(StartIndex,wp.surveyQuestionId); 
                                    return null;
                                }else{
                                    if(wpInner.surIssue.id != null){                                    
                                        for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                            if(wpInnerCheck.surIssue.id == null){
                                                if(wpInner.nextRoute != wpInnerCheck.nextRoute){
                                                     ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Answer cannot be changed'));
                                                     return null;
                                                }
                                            }    
                                        }
                                    
                                    }
                                }
                            }
                        }
                            
                        
                        if(wp.questionMap.QuestionFrom__r.Type__c == 'Comment'){
                            if(wpInner.qtn.CommentRequired__c && (wp.questionComment == null || wp.questionComment.trim() == '')){
                                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                return null;
                            }else{
                                questionTerId1 = wp.surveyQuestionId;
                                StartIndex = wpInner.nextRoute;
                                questionTerId = StartIndex;
                                previousNodeInfo.put(StartIndex,wp.surveyQuestionId);  
                                return null;
                            }
                        }
                        
                        if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice'){
                            
                            if(wpInner.radioCheckBtn){                                
                                for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                    if(wpInnerCheck.radioCheckBtn){
                                        if(wpInnerCheck.qtn.CommentRequired__c && (wp.questionComment == null || wp.questionComment.trim() == '')){
                                             ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                             return null;
                                        }
                                    }                                
                                }                                
                                questionTerId1 = wp.surveyQuestionId;
                                StartIndex = wpInner.nextRoute;
                                questionTerId = StartIndex;
                                previousNodeInfo.put(StartIndex,wp.surveyQuestionId); 
                                CheckBoxChecked = true;
                                return null;
                            }                            
                        }
                    }
                    
                    if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice'){
                        if(!CheckBoxChecked ){
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Answer Required'));
                            return null;
                        }
                    }
                }
        }
        return null;
    }
    
    public pagereference preRoute(){ 
        String quesId = ApexPages.currentPage().getParameters().get('startingPoint');  
        
        if(quesId == ''){
            quesId = null;
        }
        if(previousNodeInfo.ContainsKey(quesId)){
            StartIndex = previousNodeInfo.get(quesId);
            questionTerId = StartIndex; 
            previousNodeInfo.remove(quesId);
        }
        return null;    
    }
    
    public void buttonHide(){
        preButton = new  Map<String,Boolean>();
        Integer k = 1;
        
        if(!wrpList.isEmpty()){
            for(wrapperMapping i :wrpList.values()){
                if(k == 1){
                    preButton.put(i.surveyQuestionId,false);
                }else{
                     preButton.put(i.surveyQuestionId,true);
                }
                k++;
            }
        
            Integer j = 1;
            nextButton = new  Map<String,Boolean>();
            for(wrapperMapping i :wrpList.values()){
                if(j != wrpList.size()){
                    nextButton.put(i.surveyQuestionId,true);
                }else{
                     nextButton.put(i.surveyQuestionId,false);
                }
                j++;
            }
        }
    }
    
    public class wrapperRequiredMapping{
        public string surveyQuestionVal;
        public boolean requiredQuestion;
        public Set<String> nextQuestion;
        
        public wrapperRequiredMapping(String surveyQuestionObj, Boolean requiredQuestionObj,Set<String> nextQuestionObj){
            this.surveyQuestionVal = surveyQuestionObj;
            this.requiredQuestion = requiredQuestionObj;
            nextQuestion = new Set<String>();
            this.nextQuestion = nextQuestionObj;
        }
    }
    
    public class wrapperMapping{    
        public string surveyQuestionId {get;set;}
        public Survey_Configuration__c questionMap  {get;set;}
        public List<wrapperMappingInner> ansMap {get;set;}
        public string questionComment {get;set;}  
        public List<SelectOption> radioAnsList {get;set;}
        public String seletedRadio {get;set;}
        
        public wrapperMapping(Survey_Configuration__c questionMapObj, List<wrapperMappingInner> ansMapObj, String Comments){                
            questionMap = questionMapObj;
            surveyQuestionId = String.valueof(questionMap.Survey__c)+String.valueof(questionMap.QuestionFrom__c);
            
            ansMap = new List<wrapperMappingInner>();
            ansMap = ansMapObj;   
            questionComment = Comments;
            radioAnsList = new List<SelectOption>();
            if(questionMapObj.QuestionFrom__r.Type__c =='Single Choice'){
                if(!ansMapObj.isEmpty() && ansMapObj.size()>0){
                    for(wrapperMappingInner wp :ansMapObj){
                        
                        radioAnsList.add(new SelectOption(wp.qtn.Answer__c,wp.qtn.AnswerText__c));
                        
                        if(wp.surIssue != null && wp.surIssue.id != null && wp.surIssue.Answer__c != null)
                            seletedRadio = wp.surIssue.Answer__c;               
                    }
                }
            }
        }    
    }
    
    public class wrapperMappingInner{
        public Survey_Configuration__c qtn{get;set;}
        public Survey_Issue__c surIssue {get;set;}
        public Boolean radioCheckBtn {get;set;}
        public string nextRoute {get;set;}
        public wrapperMappingInner(Survey_Configuration__c qtnObj,Survey_Issue__c surIssueObj, string nextRouteObj)                
        {
            this.qtn = qtnObj;     
            this.surIssue = surIssueObj;
            if(qtnObj.QuestionTo__c != null){
                nextRoute = String.valueof(qtnObj.survey__c)+String.valueof(qtnObj.QuestionTo__c);
            }
            
            if(qtnObj.QuestionTo__c == null){
                nextRoute = nextRouteObj;
            }
            
            if(surIssueObj != null && surIssueObj.id != null){
                radioCheckBtn =  true;
            }else{
                radioCheckBtn =  false;
            }
        }
        
        public wrapperMappingInner(Survey_Configuration__c qtnObj, id nextRouteObj){
            if(qtnObj.id == qtn.id && nextRoute != null && nextRoute != ''){
                nextRoute = nextRouteObj;
            }
        }
    }
    
    public PageReference saveReason(){
        try{
            if(issueObjNew.Survey_Cancel_Reason__c == null || issueObjNew.Survey_Cancel_Reason__c ==  ''){
              ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Survey Cancel Reason: You must enter a value')); 
              saveError = true;   
              return null;  
            }
            issueObj.Survey__c = 'Incomplete';
            issueObj.SurveyHiddenReason__c = endSurveyType;
            issueObj.Survey_Cancel_Reason__c =  issueObjNew.Survey_Cancel_Reason__c;
            System.debug('test '+issueObjNew.Survey_Cancel_Reason__c);
            update issueObj;
            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();   
            mgmtHelper.createTransactionMgmtHistoryRecord('CREATE_SURVEY',String.valueOf(issueObj.id)); 
            
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Sever Error,Please try again'));
        }
        return null;
    }
    
    public PageReference CancelSurvey(){
        surveyScreen = false;
        mainScreen = false;
        cancelScreen = true;
        endSurveyType = 'Cancel';
        cancelReasons(endSurveyType);
        return null;
    }    
    
    public PageReference TerminateSurvey(){
        surveyScreen = false;
        mainScreen = false;
        cancelScreen = true;
        endSurveyType = 'Terminate';
        cancelReasons(endSurveyType);
        return null;
    }
    
    public void cancelReasons(String type){       
        //, Survey_Cancel_Reason__c = issueObj.Survey_Cancel_Reason__c
        issueObjNew = new Case(SurveyHiddenReason__c = type);        
    }
    
    public PageReference SaveSurvey(){
        try{
            String quesId = questionTerId;
            System.debug('test quesId '+quesId);
            saveError = false;
            if(wrpList.Containskey(quesId)){
                wrapperMapping wp= wrpList.get(quesId);
                if(wp.questionComment != null && wp.questionComment.trim() != '' && wp.questionComment.trim().length() >= 32768){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comment: Max. 32768 characters are allowed')); 
                    saveError = true;
                    return null;            
                }
                List<wrapperMappingInner> ansMapObj = wp.ansMap;                 
                Boolean CheckBoxChecked  = false;
                if(!ansMapObj.isEmpty()){
                    
                    for(wrapperMappingInner wpInner :ansMapObj){
                        if(previousNodeInfo.containsKey(wp.surveyQuestionId) || firstQuestionId == wp.surveyQuestionId  || StartIndex == wp.surveyQuestionId || wpInner.surIssue.id != null){
                         wpInner.surIssue.Comment__c = wp.questionComment;
                        if(wp.questionMap.QuestionFrom__r.Type__c == 'Single Choice'){
                            if(wp.seletedRadio == null || wp.seletedRadio == ''){
                                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select answer')); 
                                saveError = true;
                                return null;
                            }else{
                                 if(wp.questionComment == null || wp.questionComment.trim() == ''){ 
                                    for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                        if(wp.seletedRadio == wpInnerCheck.qtn.Answer__c){
                                             if(wpInnerCheck.qtn.CommentRequired__c){
                                                 ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                                 return null;
                                             }
                                        }    
                                    } 
                                }
                                if(wp.seletedRadio == wpInner.qtn.Answer__c && !isTest){ 
                                    if(wpInner.surIssue.id == null){                                    
                                        for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                            if(wpInnerCheck.surIssue.id != null){
                                                if(wpInner.nextRoute != wpInnerCheck.nextRoute){
                                                     ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Answer cannot be changed'));
                                                     saveError = true;
                                                     return null;
                                                }
                                            }    
                                        }                                    
                                    }
                                
                                }else{
                                    if(wpInner.surIssue.id != null){                                    
                                        for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                            if(wpInnerCheck.surIssue.id == null){
                                                if(wpInner.nextRoute != wpInnerCheck.nextRoute){
                                                     ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Answer cannot be changed'));
                                                     saveError = true;
                                                     return null;
                                                }
                                            }    
                                        }                                    
                                    }
                                }
                            }
                        }  
                        
                        if(wp.questionMap.QuestionFrom__r.Type__c == 'Comment'){
                            if(wpInner.qtn.CommentRequired__c && (wp.questionComment == null || wp.questionComment.trim() == '')){
                                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                saveError = true;
                                return null;
                            }
                        }
                        
                        if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice'){                            
                            if(wpInner.radioCheckBtn){                                
                                for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                    if(wpInnerCheck.radioCheckBtn){
                                        if(wpInnerCheck.qtn.CommentRequired__c && (wp.questionComment == null || wp.questionComment.trim() == '')){
                                             ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                             saveError = true;
                                             return null;
                                        }
                                    }                                
                                } 
                                CheckBoxChecked = true;
                            }                            
                        }
                        }
                    }
                    
                    if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice'){
                        if(!CheckBoxChecked ){
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Answer Required'));
                            saveError = true;
                            return null;
                        }
                    }
                }
            }
        
            if(!wrpList.isEmpty()){
                List<Survey_Issue__c> updatedListSurvey = new List<Survey_Issue__c>();
                List<Survey_Issue__c> deActiveListSurvey = new List<Survey_Issue__c>();
                
                for(wrapperMapping wp :  wrpList.values()){
                    
                    if(wp.surveyQuestionId != null){
                    List<wrapperMappingInner> ansMapObj = wp.ansMap;                 
                    
                        if(!ansMapObj.isEmpty()){
                            
                            for(wrapperMappingInner wpInner :ansMapObj){
                                wpInner.surIssue.Comment__c = wp.questionComment;                            
                                
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Single Choice'){
                                    if(wpInner.qtn.Answer__c == wp.seletedRadio && !isTest){
                                        updatedListSurvey.add(wpInner.surIssue);
                                    }else{
                                        if(wpInner.surIssue.id != null){
                                            Survey_Issue__c surveyIssue = wpInner.surIssue;
                                            surveyIssue.isActive__c = false;
                                            surveyIssue.isReviewed__c = false;
                                            deActiveListSurvey.add(surveyIssue);
                                        }
                                    }
                                }
                                
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Comment'){
                                    if(wpInner.surIssue.Comment__c != null && wpInner.surIssue.Comment__c.trim() != ''){ 
                                        updatedListSurvey.add(wpInner.surIssue);
                                    }else{
                                        if(wpInner.surIssue.id != null){
                                            Survey_Issue__c surveyIssue = wpInner.surIssue;
                                            surveyIssue.isActive__c = false;
                                            surveyIssue.isReviewed__c = false;
                                            deActiveListSurvey.add(surveyIssue);
                                        }
                                    }           
                                }
                                
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice'){
                                    
                                    if(wpInner.radioCheckBtn && !isTest){
                                        updatedListSurvey.add(wpInner.surIssue);
                                    }else{
                                        if(wpInner.surIssue.id != null){
                                            Survey_Issue__c surveyIssue = wpInner.surIssue;
                                            surveyIssue.isActive__c = false;
                                            surveyIssue.isReviewed__c = false;
                                            deActiveListSurvey.add(surveyIssue); 
                                        }
                                    }                            
                                }
                            }
                        }                
                    }                
                }
                Map<id,id>  surveyIssueMap = new Map<id,id>();
                
                Set<id> updateList = new Set<id>();
                 if(!updatedListSurvey.isEmpty()){
                    for(Survey_Issue__c sIssue :updatedListSurvey){
                        if(sIssue.id != null && !updateList.Contains(sIssue.survey__c)){
                            updateList.add(sIssue.survey__c);
                        }                        
                    } 
                    upsert updatedListSurvey;  
                    for(Survey_Issue__c sIssue :updatedListSurvey){
                        if(!surveyIssueMap.containsKey(sIssue.survey__c)){
                            surveyIssueMap.put(sIssue.survey__c,sIssue.id);
                        }
                    }  
                }
                
                if(!deActiveListSurvey.isEmpty()){
                    for(Survey_Issue__c sIssue :deActiveListSurvey){
                        if(!updateList.Contains(sIssue.survey__c)){
                            updateList.add(sIssue.survey__c);
                        }
                        
                        if(!surveyIssueMap.containsKey(sIssue.survey__c)){
                            surveyIssueMap.put(sIssue.survey__c,sIssue.id);
                        }
                    }  
                    update deActiveListSurvey;    
                }
                
                if(!isRequired){
                	issueObj.Survey__c = 'Completed';
                }
                update issueObj;
                
                if(!surveyIssueMap.isEmpty()){
                    
                    for(id suvId :surveyIssueMap.keyset()){
                        TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper(); 
                        System.debug('test survey ID '+suvId); 
                        if(updateList.Contains(suvId)){
                             System.debug('test survey ID Update'); 
                             mgmtHelper.createTransactionMgmtHistoryRecord('UPDATE_SURVEY',String.valueOf(surveyIssueMap.get(suvId))); 
                        }else{
                            System.debug('test survey ID Create'); 
                            mgmtHelper.createTransactionMgmtHistoryRecord('CREATE_SURVEY',String.valueOf(surveyIssueMap.get(suvId))); 
                        }
                    }
                }                     
            }
            saveError = false;  
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Sever Error,Please try again'));
           saveError = true;
        }
        
        return null;
      }
      
       
    Set<String> ids;  
    
    @TestVisible private void getRequiredQuestionList(String SurveyQuestion,Boolean FirstQuestion){

        if(requiedQuestion.ContainsKey(SurveyQuestion)){
            wrapperRequiredMapping wpObj = requiedQuestion.get(SurveyQuestion);           
            
            if(wpObj != null){
                
                if(wpObj.requiredQuestion && !FirstQuestion){
                    ids.add(wpObj.surveyQuestionVal);
                }
            
                if(!wpObj.nextQuestion.isEmpty() && wpObj.nextQuestion.size() >0){   
                    if(FirstQuestion){
                        Set<String> CurrentQuestionNextList = new Set<String>(); 
                        CurrentQuestionNextList = wpObj.nextQuestion;
                        wrapperMapping wp =  wrpList.get(SurveyQuestion);
                        
                        List<wrapperMappingInner> ansMapObj = wp.ansMap; 
                        
                        if(!ansMapObj.isEmpty()){  
                           Boolean checkQuestion = false; 
                            String StartIndex = ''; 
                           for(wrapperMappingInner wpInner :ansMapObj){  
                                System.debug('test wp.questionMap.QuestionFrom__r.Type__c '+wp.questionMap.QuestionFrom__r.Type__c+', wp.seletedRadio '+wp.seletedRadio);
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Single Choice' && !checkQuestion){
                                    if(wp.seletedRadio != null && wp.seletedRadio.trim() != '' && wp.seletedRadio == wpInner.qtn.Answer__c ){
                                       System.debug('test wp.seletedRadio '+wp.seletedRadio+', wpInner.nextRoute '+wpInner.nextRoute); 
                                       checkQuestion = true;
                                       StartIndex = wpInner.nextRoute;
                                    }                                    
                                }                                
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Comment' && !checkQuestion){
                                    if(wp.questionComment != null && wp.questionComment.trim() != ''){
                                        checkQuestion = true;
                                        StartIndex = wpInner.nextRoute;
                                    }
                                }                                
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice' && !checkQuestion){
                                    for(wrapperMappingInner wpInner1 :ansMapObj){
                                        if(wpInner1.radioCheckBtn){
                                            checkQuestion = true;
                                            StartIndex = wpInner.nextRoute;
                                            break;
                                        }
                                    }                                                                
                                }                               
                            }
                            System.debug('test checkQuestion '+checkQuestion );
                             System.debug('test StartIndex '+StartIndex );
                            if(checkQuestion && StartIndex != null && StartIndex != ''){
                                getRequiredQuestionList(StartIndex,false);
                            }else{
                                for(String nx :wpObj.nextQuestion){   
                                    if(nx != null && nx.trim() != ''){
                                        getRequiredQuestionList(nx,false);
                                    }                        
                                }
                            }
                       } 
                    }else{
                        for(String nx :wpObj.nextQuestion){                        
                           
                            if(nx != null && nx.trim() != ''){
                                getRequiredQuestionList(nx,false);
                            }                        
                        } 
                    }                   
                }                
            }       
        }
    }
      
    public PageReference requiredQuestionValidation(){        
        
        String quesId = questionTerId;//ApexPages.currentPage().getParameters().get('questionId');
        System.debug('test quesId '+quesId);
       
        questionRequired =  false;
        saveError = false;
        if(!wrpList.isEmpty() && quesId != null){             
            
            for(wrapperMapping wp :  wrpList.values()){ 
                if(wp.questionComment != null && wp.questionComment.trim() != '' && wp.questionComment.trim().length() >= 32768){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comment: Max. 32768 characters are allowed')); 
                    saveError = true;
                    return null;            
                }
                if(wp.surveyQuestionId != null){                   
                   List<wrapperMappingInner> ansMapObj = wp.ansMap; 
                    if(!ansMapObj.isEmpty()){  
                       Boolean multipleAns = false;                        
                       for(wrapperMappingInner wpInner :ansMapObj){
                          if(previousNodeInfo.containsKey(wp.surveyQuestionId) || firstQuestionId == wp.surveyQuestionId || StartIndex == wp.surveyQuestionId || wpInner.surIssue.id != null){ 
                           wpInner.surIssue.Comment__c = wp.questionComment;
                           if(wp.questionMap.QuestionFrom__r.Type__c == 'Single Choice'){
                                if(wp.seletedRadio != null && wp.seletedRadio != ''){
                                     if(wp.questionComment == null || wp.questionComment.trim() == ''){ 
                                        for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                            if(wp.seletedRadio == wpInnerCheck.qtn.Answer__c){
                                                 if(wpInnerCheck.qtn.CommentRequired__c){
                                                     ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                                     saveError = true;
                                                          return null;
                                                 }
                                            }    
                                        } 
                                    }
                                    if(wp.seletedRadio == wpInner.qtn.Answer__c){ 
                                        if(wpInner.surIssue.id == null){                                    
                                            for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                                if(wpInnerCheck.surIssue.id != null){
                                                    if(wpInner.nextRoute != wpInnerCheck.nextRoute){
                                                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Answer cannot be changed'));
                                                        saveError = true;
                                                          return null;
                                                    }
                                                }    
                                            }                                    
                                        }
                                    
                                    }else{
                                        if(wpInner.surIssue.id != null){                                    
                                            for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                                if(wpInnerCheck.surIssue.id == null){
                                                    if(wpInner.nextRoute != wpInnerCheck.nextRoute){
                                                         ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Answer cannot be changed'));
                                                         saveError = true;
                                                          return null;
                                                    }
                                                }    
                                            }
                                        
                                        }
                                    }
                                }
                            }
                            
                              
                            if(wp.questionMap.QuestionFrom__r.Type__c == 'Comment'){
                                if(wpInner.qtn.CommentRequired__c && (wpInner.surIssue.Comment__c == null || wpInner.surIssue.Comment__c == '')){
                                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                     saveError = true;
                                      return null;
                                }
                            }
                            
                            if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice'){
                                
                                if(wpInner.radioCheckBtn){
                                    for(wrapperMappingInner wpInnerCheck :ansMapObj){
                                        if(wpInnerCheck.radioCheckBtn){
                                            if(wpInnerCheck.qtn.CommentRequired__c && (wp.questionComment == null || wp.questionComment.trim() == '')){
                                                 ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                                 saveError = true;
                                                 return null;
                                            }
                                        }                                
                                    }
                                }                           
                            }
                            }                            
                        }
                    }                                
                }
             }
             ids = new Set<String>();
            Boolean checkQuestion = false;
            Boolean checkError = false; 
            getRequiredQuestionList(quesId,true);
             for(wrapperMapping wp :  wrpList.values()){               
                System.debug('test quesId ids '+ids );               
                if(wp.surveyQuestionId != null && !ids.isEmpty() && ids.size() >0){                   
                   List<wrapperMappingInner> ansMapObj = wp.ansMap; 
                    if(!ansMapObj.isEmpty()){  
                       Boolean multipleAns = false;                        
                       for(wrapperMappingInner wpInner :ansMapObj){
                           wpInner.surIssue.Comment__c = wp.questionComment;
                           if(ids.Contains(wp.surveyQuestionId) && !checkQuestion){
                               System.debug('test  '+wp.surveyQuestionId);     
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Single Choice'){
                                    if(wp.seletedRadio == null|| wp.seletedRadio.trim() == ''){
                                       checkQuestion = true;
                                       System.debug('test checkQuestion 1'+checkQuestion );
                                    }                                    
                                }
                                
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Comment' && !checkQuestion){
                                    if(wp.questionComment == null || wp.questionComment.trim() == ''){
                                        checkQuestion = true;
                                        System.debug('test checkQuestion 2'+checkQuestion );
                                    }
                                }
                                
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice' && !checkQuestion){
                                    for(wrapperMappingInner wpInner1 :ansMapObj){
                                        if(wpInner1.radioCheckBtn){
                                            multipleAns = true;
                                            break;
                                        }
                                    }
                                    System.debug('test multipleAns '+multipleAns);
                                    if(!multipleAns){
                                        checkQuestion = true;
                                        System.debug('test checkQuestion 3'+checkQuestion );
                                    }                                                                
                                }
                           }
                       }
                   }                   
                }
            } 
            System.debug('test checkQuestion '+checkQuestion);
            if(checkQuestion){
                questionRequired = true;
            }else{
                questionRequired =  false;
            }                    
        } 
        return null;   
    }
    
    public PageReference customSaveSurvey(){
          try{
           if(issueObjNew.Survey_Cancel_Reason__c == null || issueObjNew.Survey_Cancel_Reason__c ==  ''){
              ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Survey Termination Reason: You must enter a value')); 
              saveError = true;   
              return null;  
            }  
              
            if(!wrpList.isEmpty()){
                List<Survey_Issue__c> updatedListSurvey = new List<Survey_Issue__c>();
                List<Survey_Issue__c> deActiveListSurvey = new List<Survey_Issue__c>();
                saveError = false;
                for(wrapperMapping wp :  wrpList.values()){
                    if(wp.questionComment != null && wp.questionComment.trim() != '' && wp.questionComment.trim().length() >= 32768){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comment: Max. 32768 characters are allowed')); 
                        saveError = true;   
                        return null;            
                    }
                    if(wp.surveyQuestionId != null){
                    List<wrapperMappingInner> ansMapObj = wp.ansMap;        
                    
                        if(!ansMapObj.isEmpty()){                        
                            for(wrapperMappingInner wpInner :ansMapObj){
                                if(previousNodeInfo.containsKey(wp.surveyQuestionId) || firstQuestionId == wp.surveyQuestionId || StartIndex == wp.surveyQuestionId || wpInner.surIssue.id != null){
                                wpInner.surIssue.Comment__c = wp.questionComment;
                                    
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Single Choice'){
                                    if(wpInner.qtn.Answer__c == wp.seletedRadio && !isTest){ 
                                         if(wp.questionComment == null || wp.questionComment.trim() == ''){                                             
                                             if(wpInner.qtn.CommentRequired__c){
                                                 ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                                 return null;
                                             }
                                        }                                                                         
                                        updatedListSurvey.add(wpInner.surIssue);
                                    }else{
                                        if(wpInner.surIssue.id != null){
                                            Survey_Issue__c surveyIssue = wpInner.surIssue;
                                            surveyIssue.isActive__c = false;
                                            deActiveListSurvey.add(surveyIssue); 
                                        }
                                    }
                                }
                                                                  
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Comment'){
                                    
                                    if(wpInner.qtn.CommentRequired__c && (wp.questionComment == null || wp.questionComment.trim() == '')){
                                        saveError = true; 
                                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                        return null;
                                    
                                    }
                                    
                                    if(wpInner.surIssue.Comment__c != null && wpInner.surIssue.Comment__c != ''){
                                        updatedListSurvey.add(wpInner.surIssue);
                                    }else{
                                        if(wpInner.surIssue.id != null){
                                            Survey_Issue__c surveyIssue = wpInner.surIssue;
                                            surveyIssue.isActive__c = false;
                                            deActiveListSurvey.add(surveyIssue);  
                                        }                                
                                    }
                                }
                                
                                if(wp.questionMap.QuestionFrom__r.Type__c == 'Multiple Choice'){
                                    
                                    if(wpInner.radioCheckBtn && !isTest){
                                        if(wpInner.qtn.CommentRequired__c && (wp.questionComment == null || wp.questionComment.trim() == '')){
                                             saveError = true; 
                                             ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Comments Required'));
                                             return null;
                                        }                                          
                                        updatedListSurvey.add(wpInner.surIssue);
                                    }else{
                                        if(wpInner.surIssue.id != null){
                                            Survey_Issue__c surveyIssue = wpInner.surIssue;
                                            surveyIssue.isActive__c = false;
                                            deActiveListSurvey.add(surveyIssue); 
                                        }
                                    }                            
                                }
                                }
                            }
                        }                
                    }                
                }
                Map<id,id>  surveyIssueMap = new Map<id,id>();
                
                Set<id> updateList = new Set<id>();
                 
                if(!updatedListSurvey.isEmpty()){
                    for(Survey_Issue__c sIssue :updatedListSurvey){
                        if(sIssue.id != null && !updateList.Contains(sIssue.survey__c)){
                            updateList.add(sIssue.survey__c);
                        }
                        
                    } 
                    upsert updatedListSurvey;      
                     for(Survey_Issue__c sIssue :updatedListSurvey){
                        if(!surveyIssueMap.containsKey(sIssue.survey__c)){
                            surveyIssueMap.put(sIssue.survey__c,sIssue.id);
                        }
                    }                  
                }
                
                if(!deActiveListSurvey.isEmpty()){
                    for(Survey_Issue__c sIssue :deActiveListSurvey){
                        if(!updateList.Contains(sIssue.survey__c)){
                            updateList.add(sIssue.survey__c);
                        }
                        
                        if(!surveyIssueMap.containsKey(sIssue.survey__c)){
                            surveyIssueMap.put(sIssue.survey__c,sIssue.id);
                        }
                    }  
                    update deActiveListSurvey;           
                }
                
                issueObj.SurveyHiddenReason__c = 'Terminate';
                issueObj.Survey_Cancel_Reason__c =  issueObjNew.Survey_Cancel_Reason__c;
            
                if(issueObj.Survey__c != 'Completed'){
                    if(!isRequired){
                    	issueObj.Survey__c = 'Incomplete';
                    }
                    update issueObj;
                } 
                
                if(!surveyIssueMap.isEmpty()){
                    
                    for(id suvId :surveyIssueMap.keyset()){
                        TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();  
                        if(updateList.Contains(suvId)){
                            mgmtHelper.createTransactionMgmtHistoryRecord('UPDATE_SURVEY',String.valueOf(surveyIssueMap.get(suvId))); 
                        }else{
                            mgmtHelper.createTransactionMgmtHistoryRecord('CREATE_SURVEY',String.valueOf(surveyIssueMap.get(suvId))); 
                        }
                    }
                }
            }
           saveError = false;   
         }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Sever Error,Please try again'));
            saveError = true;
        }
         return null;
    }
    
    public PageReference previousTerminate(){
        System.debug('questionTerId  '+questionTerId);
        if(questionTerId  != null && questionTerId   != ''){
            StartIndex = questionTerId;
        }
        else{
            StartIndex = firstQuestionId ;
            questionTerId  = firstQuestionId; 
        }  
        mainScreen = false;
        cancelScreen = false;
        surveyScreen = true;
        return null;
    }
    
    public PageReference previousEnd(){
        System.debug('questionTerId  '+questionTerId1 );
        if(questionTerId1 != null && questionTerId1 != ''){
            StartIndex = questionTerId1 ;
        }
        else{
            StartIndex = firstQuestionId ;
            questionTerId1 = firstQuestionId; 
        }  
        mainScreen = false;
        cancelScreen = false;
        surveyScreen = true;
        return null;
    }   

    public void testFlag(boolean flag){
        isTest = flag;
    }     
}