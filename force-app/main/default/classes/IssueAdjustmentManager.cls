/************************************************************************ 
Author: Randolf Suplito
Date: 06/23/2022
Description: This api will handle creation of issue adjustment. /services/apexrest/IssueAdjustmentAPI/
*************************************************************************/

@RestResource(urlMapping='/IssueAdjustmentAPI/') //url name to be use to invoke the apex rest in external app
global class IssueAdjustmentManager {

    @HttpPost // Insert Issue Adjustment in salesforce
    global static List<responseDTO> doPost(){
        jsonRequestDTO issueAdjustmentPayload = new jsonRequestDTO();
        Set<String> issueIdSet = new Set<String>();
        Map<String,String> customerNoMap = new Map<String,String>();
        List<Issue_Adjustment__c> issAddjList = new List<Issue_Adjustment__c>();
        Map<String,String> notExistMap = new Map<String,String>();
        Set<String> issueAdjSet = new Set<String>();
        List<responseDTO> responseList = new List<responseDTO>();
        
        List<String> adjCodeList = new List<String>{'BH','CN','DC','IH','RID','SCF','ST','TC'};
        Map<String,IssueAdjustmentMetadata__mdt> mapIssueAdj = IssueAdjustmentMetadata__mdt.getAll();
        
        try {
            if(RestContext.request != null) {
                String requestBody = RestContext.request.requestBody.toString();
                issueAdjustmentPayload = (jsonRequestDTO) json.deserialize(requestBody, jsonRequestDTO.class);
                System.debug('issueAdjustmentPayload '+issueAdjustmentPayload);
                
                if(!issueAdjustmentPayload.IssueAdjustment.isEmpty()){
                    for(issueAdjusmentDTO issAdj : issueAdjustmentPayload.IssueAdjustment) {
                        issueIdSet.add(issAdj.IssueID);
                    }
                    
                    if(!issueIdSet.isEmpty()) {
                        for(Case caseRec : [SELECT Id, CaseNumber__c, CaseNumber FROM Case WHERE CaseNumber IN : issueIdSet]) {
                            customerNoMap.put(caseRec.CaseNumber, caseRec.CaseNumber__c);
                        }
                    }
                    
                    for(issueAdjusmentDTO issAdj : issueAdjustmentPayload.IssueAdjustment) {
                        
                        if(!customerNoMap.isEmpty()) {
                            if(customerNoMap.containsKey(issAdj.IssueID)){
                                Issue_Adjustment__c issAddjRec = new Issue_Adjustment__c();
                                
                                issAddjRec.Request_ID__c = issAdj.Request_ID;
                                issAddjRec.Row_ID__c = issAdj.Row_ID;
                                issAddjRec.IssueNumber__c = customerNoMap.get(issAdj.IssueID);
                                issAddjRec.Adjustment_Type__c = issAdj.Adjustment_Type;
                                issAddjRec.Adjustment_Code__c = issAdj.Adjustment_Code;
                                issAddjRec.Adjustment_Instructions__c = issAdj.Adjustment_Instructions;
                                issAddjRec.Old_Value__c = issAdj.Old_Value;
                                issAddjRec.New_Value__c = issAdj.New_Value;
                                issAddjRec.Action_Type__c = issAdj.Action_Type;
                                issAddjRec.UpdateFromFeed__c = issAdj.UpdateFromFeed == '1' ? true : false;
                                
                                issAddjList.add(issAddjRec);
                            } else {
                                notExistMap.put(issAdj.Request_ID, issAdj.IssueID);
                            }
                        } else if(customerNoMap.isEmpty()) {
                            notExistMap.put(issAdj.Request_ID, issAdj.IssueID);
                        }
                    }
                    
                    if(!issAddjList.isEmpty()){
                        Database.SaveResult[] srList = Database.insert(issAddjList, false);
                        
                        for(Database.SaveResult sr : srList) {
                            if (sr.isSuccess()) {
                                issueAdjSet.add(sr.getId());
                            } 
                        }
                        
                        //Return for successful issue adjustment
                        if(!issueAdjSet.isEmpty()) {
                            for(Issue_Adjustment__c issueAdjRec : [SELECT Id, Request_ID__c, Adjustment_Code__c, Status__c, Comment__c FROM Issue_Adjustment__c WHERE Id IN :issueAdjSet]) {
								
                                responseDTO resDTO = new responseDTO(); 
                                if(issueAdjRec.Status__c == 'Success') {
                                    resDTO.request_id = issueAdjRec.Request_ID__c;
                                    resDTO.success = ConstantClass.SUCCESS_TRUE;
                                    resDTO.statuscode = 200;
                                    resDTO.message = ConstantClass.RESPONSE_MESSAGE_CREATED;
                                    
                                    responseList.add(resDTO);
                                } else if(issueAdjRec.Request_ID__c == null || String.isBlank(issueAdjRec.Request_ID__c)) {
                                    resDTO.request_id = issueAdjRec.Request_ID__c;
                                    resDTO.success = ConstantClass.SUCCESS_FALSE;
                                    resDTO.statuscode = 200;
                                    resDTO.message = ConstantClass.RESPONSE_MESSAGE_INVALIDREQID;
                                    
                                    responseList.add(resDTO);
                                } else if(issueAdjRec.Status__c == 'Fail') {
                                    resDTO.request_id = issueAdjRec.Request_ID__c;
                                    resDTO.success = ConstantClass.SUCCESS_FALSE;
                                    resDTO.statuscode = 200;
                                    resDTO.message = issueAdjRec.Comment__c;
                                    
                                    responseList.add(resDTO);
                                }                              
                            }
                        }
                    }
                    
                    //If IssueId does not exist
                    if(!notExistMap.isEmpty()) {
                        for(String rec : notExistMap.keySet()) {
                            responseDTO resDTO = new responseDTO();
                            resDTO.request_id = rec;
                            resDTO.success = ConstantClass.SUCCESS_FALSE;
                            resDTO.statuscode = 200;
                            resDTO.message = ConstantClass.RESPONSE_MESSAGE_ISSUEIDNOTEXIST;
                            
                            responseList.add(resDTO);
                        }
                    }
                    
                    //Create Integration Log
                    if(!responseList.isEmpty()) {
                        createIL(issueAdjustmentPayload, responseList);
                    }
                }
            }
            
        } catch(Exception e) {
            responseDTO resDTO = new responseDTO();
            resDTO.statuscode = 500;
            resDTO.success = ConstantClass.SUCCESS_FALSE;
            resDTO.message = e.getMessage();
            responseList.add(resDTO);
            
            createIL(issueAdjustmentPayload, responseList);
        }
        
        System.debug('responseList: ' + responseList);
        return responseList;
    }
    
    //Creation of Integration Log
    public static void createIL(jsonRequestDTO req, List<responseDTO> resList){
        
		List<IntegrationLog__c> integLogList = new List<IntegrationLog__c>();
        
        for(responseDTO res : resList) {
            IntegrationLog__c IL = new IntegrationLog__c();
            
        	IL.Callout__c = ConstantClass.INTEGRATIONLOG_NAME;
        	IL.FormName__c = ConstantClass.INTEGRATIONLOG_NAME;
            
            if(res.statuscode == 500){
                IL.Message__c = JSON.Serialize(res);
                IL.Success__c = false;
            } else if(res.statuscode == 200){
                IL.Message__c = JSON.Serialize(res);
                IL.Success__c = true;
            }
            IL.Request__c = JSON.Serialize(req);
            IL.Response__c = JSON.Serialize(res);
            IL.Type__c = ConstantClass.INTEGRATIONLOG_TYPE;
            
            integLogList.add(IL);
        }
        
        if(!integLogList.isEmpty()) {
            insert integLogList;
        }
    }
    
    global class jsonRequestDTO {
        public List<issueAdjusmentDTO> IssueAdjustment;
    }
    
    global class issueAdjusmentDTO {
        public String Request_ID{get; set;}
        public String Row_ID{get; set;}
        public String IssueID{get; set;}
        public String Adjustment_Type{get; set;}
        public String Adjustment_Code{get; set;}
        public String Adjustment_Instructions{get; set;}
        public String Old_Value{get; set;}
        public String New_Value{get; set;}
        public String Action_Type{get; set;}
        public String UpdateFromFeed{get; set;}
        public String Force{get; set;}
    }
    
    global class responseDTO {
        public String request_id{get; set;}
        public Integer statuscode{get; set;}
        public String success{get; set;}
        public String message{get; set;}
    }
}