/************************************************************************ 
Author: Randolf Suplito
Date: 08/22/2022
Description: This handler class is for SurveyTrigger
*************************************************************************/

public class SurveyTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Survey__c> triggerNewList, Map<Id,Survey__c> triggerNewMap) {
        
        Map<String,String> createdComNameMap = new Map<String,String>();
        Map<String,String> modifiedComNameMap = new Map<String,String>();
        String lastModifiedUser;
        
        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<surveyDTO> surveyDTOList = new List<surveyDTO>();
        
        for(Survey__c surveyRec : [SELECT Id, CreatedBy.CommunityNickname, LastModifiedBy.CommunityNickname FROM Survey__c WHERE Id IN :triggerNewMap.keyset()]) {
            createdComNameMap.put(surveyRec.Id, surveyRec.CreatedBy.CommunityNickname);
            modifiedComNameMap.put(surveyRec.Id, surveyRec.LastModifiedBy.CommunityNickname);
            lastModifiedUser = surveyRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Survey__c surveyRec : triggerNewList) {
            surveyDTO sDTO = new surveyDTO();
            sDTO.SurveyID = surveyRec.Name != null ? surveyRec.Name : '';
            sDTO.SurveyName = surveyRec.Survey_Name__c != null ? surveyRec.Survey_Name__c : '';
            sDTO.StartDate = surveyRec.Start_Date__c != null ? String.valueOf(surveyRec.Start_Date__c) : '';
            sDTO.EndDate = surveyRec.End_Date_Feed__c != null ? surveyRec.End_Date_Feed__c : '';
            if(surveyRec.Active__c != null && surveyRec.Active__c) { 
                sDTO.ActiveFlag = 'Y'; 
            } else if(surveyRec.Active__c != null && !surveyRec.Active__c) { 
                sDTO.ActiveFlag = 'N'; 
            } else if(surveyRec.Active__c == null) {
                sDTO.ActiveFlag = '';
            }
            sDTO.Priority = surveyRec.Priority__c != null ? String.valueOf(surveyRec.Priority__c) : '';
            sDTO.Mandatory = surveyRec.RequiredFeed__c != null ? surveyRec.RequiredFeed__c : '';
            sDTO.CreatedBy = createdComNameMap.get(surveyRec.Id);
            sDTO.ModifiedBy = modifiedComNameMap.get(surveyRec.Id);
            sDTO.CreatedDate = surveyRec.CreatedDate__c != null ? surveyRec.CreatedDate__c : '';
            sDTO.ModifiedDate = surveyRec.LastModifiedDate__c != null ? surveyRec.LastModifiedDate__c : '';
            sDTO.IsDeleted = surveyRec.IsDeleted__c != null ? surveyRec.IsDeleted__c : '';
            
            surveyDTOList.add(sDTO);
        }
        
        if(!surveyDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.SurveyDefinition = surveyDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.SURVEY_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<surveyDTO> SurveyDefinition;
    }
    
    public class surveyDTO {
        public String SurveyID {get; set;}
        public String SurveyName {get; set;}
        public String StartDate {get; set;}
        public String EndDate {get; set;}
        public String ActiveFlag {get; set;}
        public String Priority {get; set;}
        public String Mandatory {get; set;}
        public String CreatedBy {get; set;}
        public String ModifiedBy {get; set;}
        public String CreatedDate {get; set;}
        public String ModifiedDate {get; set;}
        public String IsDeleted {get; set;}
    }
}