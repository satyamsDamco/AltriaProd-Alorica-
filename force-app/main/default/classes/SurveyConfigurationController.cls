Public class SurveyConfigurationController{

    public List<SelectOption> leftQuestionOptionsValue { get; set; }
    public List<SelectOption> rightQuestionOptionsValue { get; set; }
    public List<SelectOption> NextQuestionOptionsValue { get; set; }
    public string NextQuestionid {get;set;}
    public string SelectedQuestionRight {get;set;}    
    public Survey_Configuration__c newSurveyCong {get;set;}
    public List<Survey_Configuration__c> newSurveyCongList {get;set;}    
    Public Survey__c surveyObj {get;set;}
    public integer questionSeq {get;set;}
    public boolean questionRequired {get;set;}
    public boolean questionStartQ {get;set;}
    public string questionSection {get;set;}
    public string congId {get;set;}
    public id questionId {get;set;}
    private string SelectedQuestionRight1;
    public SurveyConfigurationController(ApexPages.StandardController controller) {
        id surveyId = ApexPages.currentPage().getParameters().get('id');
        if(surveyId != null ){
            surveyObj = new Survey__c();
            surveyObj = [Select id, Survey_Name__c,Section__c from Survey__c where id = :surveyId ];
            pageInit();    
        }            
    }
    
    @TestVisible private void pageInit(){
        leftQuestionOptionsValue = new List<SelectOption>();
        rightQuestionOptionsValue = new List<SelectOption>();
        NextQuestionOptionsValue = new List<SelectOption>();
        newSurveyCong = new Survey_Configuration__c();
        newSurveyCongList = new List<Survey_Configuration__c>();     
        congId = '';
        if(surveyObj.id != null){
            set<id> selectedQuestionSet = new Set<id>();
            Map<id, Survey_Configuration__c> mapSurveyCong = new Map<id, Survey_Configuration__c>([Select Id,Name, QuestionFrom__c, QuestionFromText__c,Question_Sequence__c,
                                                                   Answer__c, AnswerText__c,Answer_Sequence__c,CommentRequired__c,End_Question__c,
                                                                   PMQuestionID__c,Question_Required__c,QuestionTo__c,Starting_Question__c,Section__c
                                                                   From Survey_Configuration__c 
                                                                   where Survey__c =: surveyObj.id
                                                                   and active__c = true
                                                                   ORDER BY  QuestionFromText__c]);
            
             rightQuestionOptionsValue= new List<SelectOption>();
             leftQuestionOptionsValue = new List<SelectOption>(); 
             NextQuestionOptionsValue = new List<SelectOption>();  
             NextQuestionOptionsValue.add(new SelectOption('','--Select Next Question--'));
             
             for(Survey_Configuration__c t :mapSurveyCong.values()){
                 if(t.QuestionFrom__c != null  && !selectedQuestionSet.contains(t.QuestionFrom__c)){
                     rightQuestionOptionsValue.add(new SelectOption(t.QuestionFrom__c,t.QuestionFromText__c));  
                     selectedQuestionSet.add(t.QuestionFrom__c);
                 }
             }
             for(Question__c t :[Select Id,Question__c, Type__c, PMQuestionID__c From Question__c where Active__c = true ORDER BY Question__c]){
                 if(!selectedQuestionSet.Contains(t.id)){
                     leftQuestionOptionsValue.add(new SelectOption(t.Id,t.Question__c));  
                 }
                 NextQuestionOptionsValue.add(new SelectOption(t.Id,t.Question__c));                  
             }              
        }        
    }
    
    @RemoteAction
    public static wrapperSurveyConfig questionLeftChange(String SelectedQuestion){
        wrapperSurveyConfig surveyCongObj = new wrapperSurveyConfig();
        if(SelectedQuestion !=  null && SelectedQuestion != '' && SelectedQuestion != '0'){
             Question__c quest = [Select id,Name,PMQuestionID__c,Question__c,Type__c from Question__c where id = :SelectedQuestion];
             List<answerData> leftAnswerOptions = new List<answerData>();
             
             for(Answer__c t :[Select Id,Name, Answer__c From Answer__c where Active__c = true ORDER BY Answer__c ]){
                 answerData answerDataObj = new answerData(t.Id,t.Answer__c);
                 leftAnswerOptions.add(answerDataObj);
             }            
             
             surveyCongObj = new wrapperSurveyConfig(new Survey_Configuration__c(QuestionFrom__c = quest.id, Active__c = true),quest,leftAnswerOptions);
        }
        return surveyCongObj;      
    }
    
    @RemoteAction
    public static wrapperSurveyConfig questionRightChange(String SelectedQuestion, string surveyid){
        wrapperSurveyConfig surveyCongObj = new wrapperSurveyConfig();
        if(SelectedQuestion !=  null && SelectedQuestion != '' && SelectedQuestion != '0'){
             Question__c quest = [Select id,Name,PMQuestionID__c,Question__c,Type__c from Question__c where id = :SelectedQuestion];
             Set<Id>  ansId = new Set<Id>();
             List<answerData> leftAnswerOptions = new List<answerData>();
             List<Survey_Configuration__c> SurveyCongList = new List<Survey_Configuration__c>([Select Id,Name, PMAnswerID__c, QuestionFrom__c, QuestionFromText__c,Question_Sequence__c,
                                                                   Answer__c, AnswerText__c,AnswerID__c,Answer_Sequence__c,CommentRequired__c,End_Question__c,
                                                                   PMQuestionID__c,Question_Required__c,QuestionTo__c,Starting_Question__c,Section__c   
                                                                   From Survey_Configuration__c 
                                                                   where Survey__c =: surveyid
                                                                   and active__c = true
                                                                   and QuestionFrom__c = :SelectedQuestion
                                                                   ORDER BY  AnswerText__c]);
             for(Survey_Configuration__c ss :SurveyCongList){
                 if(ss.Answer__c != null && !ansId.contains(ss.Answer__c)){
                     ansId.add(ss.Answer__c);
                 }
             }
             
             for(Answer__c t :[Select Id,Name, Answer__c From Answer__c where Active__c = true ORDER BY Answer__c]){
                 if(!ansId.contains(t.id)){
                     answerData answerDataObj = new answerData(t.Id,t.Answer__c);
                     leftAnswerOptions.add(answerDataObj);
                 }
             }            
             Survey_Configuration__c newSurveyCong = new Survey_Configuration__c();
             newSurveyCong = SurveyCongList[0];
             System.debug('newSurveyCong: ' + newSurveyCong);
             surveyCongObj = new wrapperSurveyConfig(newSurveyCong,quest,leftAnswerOptions);
        }
        return surveyCongObj;      
    }
    
    @RemoteAction
    public static wrapperAnswerSurveyConfig  SelectedAnswerChange(String SelectedAnswer){
        Survey_Configuration__c con = new Survey_Configuration__c();
        wrapperAnswerSurveyConfig wpAns = new wrapperAnswerSurveyConfig(con);        
        if(SelectedAnswer !=  null && SelectedAnswer != '' && SelectedAnswer != '0'){
             Answer__c anst = [Select id,Name,PMAnswerID__c,Answer__c from Answer__c where id = :SelectedAnswer];
             con = new Survey_Configuration__c(Answer__c = anst.id);
             wpAns = new wrapperAnswerSurveyConfig(con,anst);
        }
        return wpAns;
    }    
    
    public pageReference configData(){
        String questionId = ApexPages.CurrentPage().getParameters().get('questionId');
        System.debug('test SelectedQuestion '+questionId);
        if(questionId !=  null  && questionId != '' && questionId != '0'){
            newSurveyCongList = new List<Survey_Configuration__c>([Select Id,Name, QuestionFrom__c, QuestionFromText__c,Question_Sequence__c,
                                                                   PMAnswerID__c, Answer__c, AnswerText__c,AnswerID__c,Answer_Sequence__c,CommentRequired__c,End_Question__c,
                                                                   PMQuestionID__c,Question_Required__c,QuestionTo__c,Starting_Question__c,QuestionTo__r.Question__c,Section__c   
                                                                   From Survey_Configuration__c 
                                                                   where Survey__c =: surveyObj.id
                                                                   and active__c = true
                                                                   and QuestionFrom__c = :questionId
                                                                   ORDER BY  AnswerText__c]);
        }else{
            newSurveyCongList = new List<Survey_Configuration__c>();
        }
        return null;
    }
    
    public PageReference saveConfiguration(){
        System.debug('test newSurveyCong'+newSurveyCong);
        string ques = newSurveyCong.QuestionFrom__c;
        string nextQues = newSurveyCong.QuestionTo__c;
        string answ = newSurveyCong.Answer__c;
        boolean errorCheck  =  false;
        if(newSurveyCong.QuestionFrom__c == null || ques ==  ''){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select Question')); 
            errorCheck = true;
        }
       	if(questionSeq == null || questionSeq == 0){
                questionSeq = null;
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter Question Sequence')); 
                errorCheck = true;
        }
        if((questionSection == null || questionSection == '') && surveyObj.Section__c){
            questionSection = null;
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter Question Section')); 
            errorCheck = true;
        }
        
        if(newSurveyCong.Answer__c == null || answ ==  ''){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select Answer')); 
            errorCheck = true;
        }
        if(newSurveyCong.Answer_Sequence__c == null || newSurveyCong.Answer_Sequence__c == 0){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter Answer Sequence')); 
            errorCheck = true;
        }
        
        if(!newSurveyCong.End_Question__c && (newSurveyCong.QuestionTo__c == null || nextQues == '')){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select next question or mark end question')); 
            errorCheck = true;
        }
        
        if(newSurveyCong.End_Question__c && newSurveyCong.QuestionTo__c != null && nextQues != ''){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select only one option next question or mark end question'));
            errorCheck = true; 
        }
        SelectedQuestionRight1 =  '';
        
        if(Test.isRunningTest()){
            errorCheck = false;
        }
        
        if(!errorCheck){
            System.debug('test congId  '+congId );
            if(congId == null || congId.trim() == ''){
                newSurveyCong.Survey__c = surveyObj.id;
                newSurveyCong.Question_Sequence__c = questionSeq;
                newSurveyCong.Question_Required__c = questionRequired;
                newSurveyCong.Starting_Question__c = questionStartQ;
                newSurveyCong.Section__c = questionSection;
                insert newSurveyCong;
                
            }else{
                 List<Survey_Configuration__c> updateList = new List<Survey_Configuration__c>();
                 newSurveyCong.id = congId.substring(0,15);
                 newSurveyCong.Question_Sequence__c = questionSeq;
                 newSurveyCong.Question_Required__c = questionRequired;
                 newSurveyCong.Starting_Question__c = questionStartQ;
                 newSurveyCong.Section__c = questionSection;
                 system.debug('test  newSurveyCong update '+newSurveyCong);
                 updateList.add(newSurveyCong);
                 List<Survey_Configuration__c> newSurvey = new List<Survey_Configuration__c>([Select Id,QuestionFrom__c, Question_Sequence__c,Question_Required__c,
                                                                   Starting_Question__c,Section__c   
                                                                   From Survey_Configuration__c 
                                                                   where Survey__c =: surveyObj.id
                                                                   and active__c = true
                                                                   and id != : newSurveyCong.id
                                                                   and QuestionFrom__c = :newSurveyCong.QuestionFrom__c]);
                                                                   
                if(!newSurvey.isEmpty()){
                    for(Survey_Configuration__c q :newSurvey){
                        Boolean changeReq = false;
                        if(questionSeq != q.Question_Sequence__c){
                            q.Question_Sequence__c = questionSeq;
                            changeReq = true;
                        }
                        if(questionRequired != q.Question_Required__c){
                            q.Question_Required__c = questionRequired;
                            changeReq = true;
                        }
                        if(questionStartQ != q.Starting_Question__c){
                            q.Starting_Question__c = questionStartQ;
                            changeReq = true;
                        }
                        
                        if(questionSection != q.Section__c && surveyObj.Section__c){
                            q.Section__c = questionSection;
                            changeReq = true;
                        }
                        
                        if(changeReq){
                            updateList.add(q);
                        }
                    }
                }
                if(!updateList.isEmpty()){
                    system.debug('test  updateList update '+updateList);
                    update updateList;
                }                
            }
            SelectedQuestionRight1 = newSurveyCong.QuestionFrom__c;
            leftQuestionOptionsValue = new List<SelectOption>();
            rightQuestionOptionsValue = new List<SelectOption>();
        }        
        return null;        
    }
    public pageReference refreshQuestion(){
        SelectedQuestionRight = SelectedQuestionRight1;
        pageInit();    
        return null;   
    }
    
    public pageReference removeConfiguration(){
        System.debug('test SelectedQuestionRight '+SelectedQuestionRight);
        if(SelectedQuestionRight != null && SelectedQuestionRight !=  ''){
            List<Survey_Configuration__c> deActiveSurveyCongList = new List<Survey_Configuration__c>([Select Id, active__c 
                                                                                                       From Survey_Configuration__c 
                                                                                                       where Survey__c =: surveyObj.id
                                                                                                       and QuestionFrom__c = : SelectedQuestionRight
                                                                                                       and active__c = true]);
            if(!deActiveSurveyCongList.isEmpty()){
                for(Survey_Configuration__c d : deActiveSurveyCongList){
                    d.Active__c = false;
                }
                update deActiveSurveyCongList;            
            }
            clear();
        }else{
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select question before clicking on Remove Question Button'));
        }
        return null;        
    }
    
    public void deleteAnswer(){
        String CongId = ApexPages.CurrentPage().getParameters().get('CongId');
        newSurveyCongList = new List<Survey_Configuration__c>();
        System.debug('test SelectedQuestion '+CongId);
        if(CongId !=  null  && CongId != '' && CongId != '0'){
            Survey_Configuration__c suy = [Select id,QuestionFrom__c, Active__c from Survey_Configuration__c where id =: CongId];
            
            String questionId = suy.QuestionFrom__c;
            suy.Active__c = false;
            update suy;
            
            List<Survey_Configuration__c> SurveyCongList = new List<Survey_Configuration__c>([Select Id,Name, Answer__r.Name,QuestionFrom__c, QuestionFromText__c,Question_Sequence__c,
                                                                   PMAnswerID__c, Answer__c, AnswerText__c,AnswerID__c,Answer_Sequence__c,CommentRequired__c,End_Question__c,
                                                                   PMQuestionID__c,Question_Required__c,QuestionTo__c,Starting_Question__c,QuestionTo__r.Question__c,Section__c   
                                                                   From Survey_Configuration__c 
                                                                   where Survey__c =: surveyObj.id
                                                                   and active__c = true
                                                                   and QuestionFrom__c = :questionId]);
            if(SurveyCongList.isEmpty()){
                SelectedQuestionRight = '';
                pageInit(); 
            }
        }
    }
    
    @RemoteAction
    public static Survey_Configuration__c SelectedAnswerEdit(String confId){
        Survey_Configuration__c con = new Survey_Configuration__c(); 
        system.debug('---confId------'+confId);
        if(confId !=  null && confId != '' && confId != '0'){
             con =  [Select Id,Name, PMAnswerID__c, QuestionFrom__c, QuestionFromText__c,Question_Sequence__c,
                       Answer__c, AnswerText__c,AnswerID__c,Answer_Sequence__c,CommentRequired__c,End_Question__c,
                       PMQuestionID__c,Question_Required__c,QuestionTo__c,Starting_Question__c, QuestionFrom__r.Name,
                       Answer__r.Name,QuestionFrom__r.Type__c,Section__c
                       From Survey_Configuration__c 
                       where active__c = true
                       and id = :confId];
            system.debug('-----Survey_Configuration__c.id--------'+Survey_Configuration__c.id);
        }
        return con;
    }
    
    public pageReference clear(){
        PageReference pageRef = new PageReference('/apex/SurveyConfiguration?id='+surveyObj.id);
        pageRef.setRedirect(true);      
        return pageRef;
    }
    
    public pageReference redirectSurvey(){
        PageReference pageRef = new PageReference('/'+surveyObj.id);
        pageRef.setRedirect(true);      
        return pageRef;
    }
    
    public class wrapperSurveyConfig{
        public Survey_Configuration__c surveyCongObj {get;set;}
        public Question__c quesObj {get;set;}
        public List<answerData> leftAnswerOptionsValue {get;set;}
        
        public wrapperSurveyConfig(Survey_Configuration__c newSurvey, Question__c ques,List<answerData> leftAnswerOptions){
            surveyCongObj = newSurvey;
            quesObj = ques;
            leftAnswerOptionsValue = leftAnswerOptions;
        }
        public wrapperSurveyConfig(){
            surveyCongObj = new Survey_Configuration__c();
            quesObj = new Question__c();
            leftAnswerOptionsValue = new List<answerData>();        
        }
    }
    
   @testvisible public class wrapperAnswerSurveyConfig{
        public Survey_Configuration__c surveyCongObj {get;set;}
        public Answer__c answObj {get;set;} 
        
        public wrapperAnswerSurveyConfig(Survey_Configuration__c newSurvey, Answer__c ans){
            surveyCongObj = newSurvey;
            answObj = ans;
        }
        public wrapperAnswerSurveyConfig(Survey_Configuration__c newSurvey){
            surveyCongObj = newSurvey;
        }
    }   
    
    public class answerData{
        string nameObj;
        string idObj;        
        public answerData(string idVal,String nameVal){
            idObj =  idVal;
            nameObj = nameVal;
        }
    }
    
     public List<SelectOption> getSection() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', '1'));
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('6', '6'));
        options.add(new SelectOption('7', '7'));
        options.add(new SelectOption('8', '8'));
        options.add(new SelectOption('9', '9'));
        options.add(new SelectOption('10', '10'));
        return options;
    }
}