/************************************************************************ 
Author: Randolf Suplito
Date: 08/10/2022
Description: This handler class is for UserTrigger
*************************************************************************/

public class UserTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<User> triggerNewList, Map<Id,User> triggerNewMap) {
        
        String lastModifiedUser;

        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<userDTO> userDTOList = new List<userDTO>();
        
        for(User userRec : [SELECT Id, LastModifiedBy.CommunityNickname FROM User WHERE Id IN :triggerNewMap.keyset()]) {
            lastModifiedUser = userRec.LastModifiedBy.CommunityNickname;
        }
        
        for(User userRec : [SELECT Id, Name, CommunityNickname, FirstName, LastName, IsAdUser__c, IsActive, CreatedDateTime__c, Location__c, EmployeeNumber, PBX_ID__c FROM User WHERE Id IN :triggerNewList]) {
            userDTO userDTO = new userDTO();
            userDTO.AgentId = userRec.CommunityNickname != null ? userRec.CommunityNickname : '';
            userDTO.FirstName = userRec.FirstName != null ? userRec.FirstName : '';
            userDTO.LastName = userRec.LastName != null ? userRec.LastName : '';
            userDTO.DisplayName = userRec.Name != null ? userRec.Name : '';
            userDTO.IsAdUser = userRec.IsAdUser__c != null ? userRec.IsAdUser__c : '';
            if(userRec.IsActive != null && userRec.IsActive) {
                userDTO.Status = '1';
            } else if(userRec.IsActive != null && !userRec.IsActive) {
                userDTO.Status = '0';
            } else if(userRec.IsActive == null) {
                userDTO.Status = '';
            }
            userDTO.CreatedDateTime = userRec.CreatedDateTime__c != null ? userRec.CreatedDateTime__c : '';
            userDTO.Location = userRec.Location__c != null ? userRec.Location__c : '';
            userDTO.EmployeeNumber = userRec.EmployeeNumber != null ? userRec.EmployeeNumber : '';
            userDTO.PbxId = userRec.PBX_ID__c != null ? userRec.PBX_ID__c : '';
            
            userDTOList.add(userDTO);
        }
        
        if(!userDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.Agent = userDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
            APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.USER_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<userDTO> Agent;
    }
    
    public class userDTO {
        public String AgentId {get; set;}
        public String FirstName {get; set;}
        public String LastName {get; set;}
        public String DisplayName {get; set;}
        public String IsAdUser {get; set;}
        public String Status {get; set;}
        public String CreatedDateTime {get; set;}
        public String Location {get; set;}
        public String EmployeeNumber {get; set;}
        public String PbxId {get; set;}
    }
}