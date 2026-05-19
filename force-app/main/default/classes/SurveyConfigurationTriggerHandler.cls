/************************************************************************ 
Author: Randolf Suplito
Date: 08/22/2022
Description: This handler class is for SurveyConfigurationTrigger
*************************************************************************/

public class SurveyConfigurationTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Survey_Configuration__c> triggerNewList, Map<Id,Survey_Configuration__c> triggerNewMap) {
        
        Map<String,String> createdComNameMap = new Map<String,String>();
        Map<String,String> modifiedComNameMap = new Map<String,String>();
        String lastModifiedUser;
        
        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<surveyConfigDTO> surveyConfigDTOList = new List<surveyConfigDTO>();
        
        for(Survey_Configuration__c surveyConfigRec : [SELECT Id, CreatedBy.CommunityNickname, LastModifiedBy.CommunityNickname FROM Survey_Configuration__c WHERE Id IN :triggerNewMap.keyset()]) {
            createdComNameMap.put(surveyConfigRec.Id, surveyConfigRec.CreatedBy.CommunityNickname);
            modifiedComNameMap.put(surveyConfigRec.Id, surveyConfigRec.LastModifiedBy.CommunityNickname);
            lastModifiedUser = surveyConfigRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Survey_Configuration__c surveyConfigRec : triggerNewList) {
            surveyConfigDTO scDTO = new surveyConfigDTO();
            scDTO.SurveyConfigID = surveyConfigRec.Name != null ? surveyConfigRec.Name : '';
            scDTO.SurveyID = surveyConfigRec.SurveyID__c != null ? surveyConfigRec.SurveyID__c : '';
            scDTO.QuestionID = surveyConfigRec.QuestionID__c != null ? surveyConfigRec.QuestionID__c : '';
            scDTO.QuestSequence = surveyConfigRec.Question_Sequence__c != null ? String.valueOf(surveyConfigRec.Question_Sequence__c) : '';
            if(surveyConfigRec.Question_Required__c != null && surveyConfigRec.Question_Required__c) { 
                scDTO.QuestMandatory = 'TRUE'; 
            } else if(surveyConfigRec.Question_Required__c != null && !surveyConfigRec.Question_Required__c) { 
                scDTO.QuestMandatory = 'FALSE'; 
            } else if(surveyConfigRec.Question_Required__c == null) {
                scDTO.QuestMandatory = '';
            }
            scDTO.PMQuestionID = surveyConfigRec.PMQuestionID__c != null ? surveyConfigRec.PMQuestionID__c : '';
            scDTO.QuestMultAnswers = surveyConfigRec.MultiAnswers__c != null ? surveyConfigRec.MultiAnswers__c : '';
            scDTO.AnswerID = surveyConfigRec.AnswerID__c != null ? surveyConfigRec.AnswerID__c : '';
            scDTO.AnsSequence = surveyConfigRec.Answer_Sequence__c != null ? String.valueOf(surveyConfigRec.Answer_Sequence__c) : '';
            scDTO.PMAnswerID = surveyConfigRec.PMAnswerID__c != null ? surveyConfigRec.PMAnswerID__c : '';
            scDTO.AnsComments = surveyConfigRec.CommentRequiredFeed__c != null ? surveyConfigRec.CommentRequiredFeed__c : '';
            scDTO.AnsNextQuestionID = surveyConfigRec.QuestionToID__c != null ? surveyConfigRec.QuestionToID__c : '';
            scDTO.CreatedBy = createdComNameMap.get(surveyConfigRec.Id);
            scDTO.createddate = surveyConfigRec.CreatedDate__c != null ? surveyConfigRec.CreatedDate__c : '';
            scDTO.ModifiedBy = modifiedComNameMap.get(surveyConfigRec.Id);
            scDTO.ModifiedDate = surveyConfigRec.LastModifiedDate__c != null ? surveyConfigRec.LastModifiedDate__c : '';
            
            surveyConfigDTOList.add(scDTO);
        }
        
        if(!surveyConfigDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.SurveyConfig = surveyConfigDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.SURVEYCONFIG_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<surveyConfigDTO> SurveyConfig;
    }
    
    public class surveyConfigDTO {
        public String SurveyConfigID {get; set;}
        public String SurveyID {get; set;}
        public String QuestionID {get; set;}
        public String QuestSequence {get; set;}
        public String QuestMandatory {get; set;}
        public String PMQuestionID {get; set;}
        public String QuestMultAnswers {get; set;}
        public String AnswerID {get; set;}
        public String AnsSequence {get; set;}
        public String PMAnswerID {get; set;}
        public String AnsComments {get; set;}
        public String AnsNextQuestionID {get; set;}
        public String CreatedBy {get; set;}
        public String createddate {get; set;}
        public String ModifiedBy {get; set;}
        public String ModifiedDate {get; set;}
    }
}