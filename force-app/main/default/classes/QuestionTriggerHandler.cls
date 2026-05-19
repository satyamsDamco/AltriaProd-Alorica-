/************************************************************************ 
Author: Randolf Suplito
Date: 08/22/2022
Description: This handler class is for QuestionTrigger
*************************************************************************/

public class QuestionTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Question__c> triggerNewList, Map<Id,Question__c> triggerNewMap) {
        
        Map<String,String> createdComNameMap = new Map<String,String>();
        Map<String,String> modifiedComNameMap = new Map<String,String>();
        String lastModifiedUser;
        
        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<questionDTO> questionDTOList = new List<questionDTO>();
        
        for(Question__c questionRec : [SELECT Id, CreatedBy.CommunityNickname, LastModifiedBy.CommunityNickname FROM Question__c WHERE Id IN :triggerNewMap.keyset()]) {
            createdComNameMap.put(questionRec.Id, questionRec.CreatedBy.CommunityNickname);
            modifiedComNameMap.put(questionRec.Id, questionRec.LastModifiedBy.CommunityNickname);
            lastModifiedUser = questionRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Question__c questionRec : triggerNewList) {
            questionDTO qDTO = new questionDTO();
            qDTO.QUESTIONID = questionRec.Name != null ? questionRec.Name : '';
            qDTO.QUESTION = questionRec.Question__c != null ? questionRec.Question__c : '';
            if(questionRec.Active__c != null && questionRec.Active__c) { 
                qDTO.ACTIVEFLAG = '1'; 
            } else if(questionRec.Active__c != null && !questionRec.Active__c) { 
                qDTO.ACTIVEFLAG = '0'; 
            } else if(questionRec.Active__c == null) {
                qDTO.ACTIVEFLAG = '';
            }
            qDTO.PMQUESTIONID = questionRec.PMQuestionID__c != null ? String.valueOf(questionRec.PMQuestionID__c) : '';
            qDTO.MULTIANSWERS = questionRec.MultiAnswers__c != null ? questionRec.MultiAnswers__c : '';
            qDTO.DEFSTARTPOS = questionRec.DefStartPos__c != null ? questionRec.DefStartPos__c : '';
            qDTO.DEFENDPOS = questionRec.DefEndPos__c != null ? questionRec.DefEndPos__c : '';
            qDTO.CREATEDDATE = questionRec.CreatedDate__c != null ? questionRec.CreatedDate__c : '';
            qDTO.CREATEDBY = createdComNameMap.get(questionRec.Id);
            qDTO.MODIFIEDDATE = questionRec.LastModifiedDate__c != null ? questionRec.LastModifiedDate__c : '';
            qDTO.MODIFIEDBY = modifiedComNameMap.get(questionRec.Id);
            qDTO.ISDELETED = questionRec.IsDeleted__c != null ? questionRec.IsDeleted__c : '';
            qDTO.QUESTIONTOCHECK = questionRec.QuestionToCheck__c != null ? questionRec.QuestionToCheck__c : '';
            
            questionDTOList.add(qDTO);
        }
        
        if(!questionDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.SurveyQuestion = questionDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.QUESTION_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<questionDTO> SurveyQuestion;
    }
    
    public class questionDTO {
        public String QUESTIONID {get; set;}
        public String QUESTION {get; set;}
        public String ACTIVEFLAG {get; set;}
        public String PMQUESTIONID {get; set;}
        public String MULTIANSWERS {get; set;}
        public String DEFSTARTPOS {get; set;}
        public String DEFENDPOS {get; set;}
        public String CREATEDDATE {get; set;}
        public String CREATEDBY {get; set;}
        public String MODIFIEDDATE {get; set;}
        public String MODIFIEDBY {get; set;}
        public String ISDELETED {get; set;}
        public String QUESTIONTOCHECK {get; set;}
    }
}