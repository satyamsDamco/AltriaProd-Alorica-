/************************************************************************ 
Author: Randolf Suplito
Date: 08/22/2022
Description: This handler class is for AnswerTrigger
*************************************************************************/

public class AnswerTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Answer__c> triggerNewList, Map<Id,Answer__c> triggerNewMap) {
		
        Map<String,String> createdComNameMap = new Map<String,String>();
        Map<String,String> modifiedComNameMap = new Map<String,String>();
        String lastModifiedUser;

		jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<answerDTO> answerDTOList = new List<answerDTO>();
        
        for(Answer__c answerRec : [SELECT Id, CreatedBy.CommunityNickname, LastModifiedBy.CommunityNickname FROM Answer__c WHERE Id IN :triggerNewMap.keyset()]) {
            createdComNameMap.put(answerRec.Id, answerRec.CreatedBy.CommunityNickname);
            modifiedComNameMap.put(answerRec.Id, answerRec.LastModifiedBy.CommunityNickname);
            lastModifiedUser = answerRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Answer__c answerRec : triggerNewList) {
            answerDTO aDTO = new answerDTO();
            aDTO.ANSWERID = answerRec.Name != null ? answerRec.Name : '';
            aDTO.ANSWER = answerRec.Answer__c != null ? answerRec.Answer__c : '';
            if(answerRec.Active__c != null && answerRec.Active__c) { 
                aDTO.ACTIVEFLAG = '1'; 
            } else if(answerRec.Active__c != null && !answerRec.Active__c) { 
                aDTO.ACTIVEFLAG = '0'; 
            } else if(answerRec.Active__c == null) {
                aDTO.ACTIVEFLAG = '';
            }
            aDTO.PMANSWERID = answerRec.PMAnswerID__c != null ? String.valueOf(answerRec.PMAnswerID__c) : '';
            aDTO.DEFSTARTPOS = answerRec.DefStartPos__c != null ? answerRec.DefStartPos__c : '';
            aDTO.DEFENDPOS = answerRec.DefEndPos__c != null ? answerRec.DefEndPos__c : '';
            aDTO.CREATEDDATE = answerRec.CreatedDate__c != null ? answerRec.CreatedDate__c : '';
            aDTO.CREATEDBY = createdComNameMap.get(answerRec.Id);
            aDTO.MODIFIEDDATE = answerRec.LastModifiedDate__c != null ? answerRec.LastModifiedDate__c : '';
            aDTO.MODIFIEDBY = modifiedComNameMap.get(answerRec.Id);
            aDTO.ISDELETED = answerRec.IsDeleted__c != null ? answerRec.IsDeleted__c : '';
            
            answerDTOList.add(aDTO);
        }
        
        if(!answerDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.SurveyAnswer = answerDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.ANSWER_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<answerDTO> SurveyAnswer;
    }
    
    public class answerDTO {
        public String ANSWERID {get; set;}
        public String ANSWER {get; set;}
        public String ACTIVEFLAG {get; set;}
        public String PMANSWERID {get; set;}
        public String DEFSTARTPOS {get; set;}
        public String DEFENDPOS {get; set;}
        public String CREATEDDATE {get; set;}
        public String CREATEDBY {get; set;}
        public String MODIFIEDDATE {get; set;}
        public String MODIFIEDBY {get; set;}
        public String ISDELETED {get; set;}
    }
}