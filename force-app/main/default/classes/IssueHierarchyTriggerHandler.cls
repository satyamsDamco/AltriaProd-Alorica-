/************************************************************************ 
Author: Randolf Suplito
Date: 08/19/2022
Description: This handler class is for IssueHierarchyTrigger
*************************************************************************/

public class IssueHierarchyTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Issue_Hierarchy__c> triggerNewList, Map<Id,Issue_Hierarchy__c> triggerNewMap) {
        
        Map<String,String> createdComNameMap = new Map<String,String>();
        Map<String,String> modifiedComNameMap = new Map<String,String>();
        String lastModifiedUser;

        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<issueHierarchyDTO> issueHierarchyDTOList = new List<issueHierarchyDTO>();
        
        for(Issue_Hierarchy__c issueHieRec : [SELECT Id, CreatedBy.CommunityNickname, LastModifiedBy.CommunityNickname FROM Issue_Hierarchy__c WHERE Id IN :triggerNewMap.keyset()]) {
            createdComNameMap.put(issueHieRec.Id, issueHieRec.CreatedBy.CommunityNickname);
            modifiedComNameMap.put(issueHieRec.Id, issueHieRec.LastModifiedBy.CommunityNickname);
            lastModifiedUser = issueHieRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Issue_Hierarchy__c issueHieRec : triggerNewList) {
            issueHierarchyDTO ihDTO = new issueHierarchyDTO();
            ihDTO.TENANTID = issueHieRec.TenantId__c != null ? issueHieRec.TenantId__c : '';
            ihDTO.CODECATEGORY = issueHieRec.CodeCategory__c != null ? issueHieRec.CodeCategory__c : '';
            ihDTO.CODETYPE = issueHieRec.CodeType__c != null ? issueHieRec.CodeType__c : '';
            ihDTO.ISSUEHIERARCHYCODE = issueHieRec.Name != null ? issueHieRec.Name : '';
            ihDTO.CLASSIFICATIONCODE = issueHieRec.Classification_Code__c != null ? issueHieRec.Classification_Code__c : '';
            ihDTO.CLASSIFICATION = issueHieRec.Classification_Des__c != null ? issueHieRec.Classification_Des__c : '';
            ihDTO.CLASSIFICATIONDISPLAYORDER = issueHieRec.ClassificationDisplayOrder__c != null ? issueHieRec.ClassificationDisplayOrder__c : '';
            ihDTO.PRODUCTLINECODE = issueHieRec.Product_Line_Code__c != null ? issueHieRec.Product_Line_Code__c : '';
            ihDTO.PRODUCTLINE = issueHieRec.Product_Line_Name__c != null ? issueHieRec.Product_Line_Name__c : '';
            ihDTO.PRODUCTLINEDISPLAYORDER = issueHieRec.ProductLineDisplayOrder__c != null ? issueHieRec.ProductLineDisplayOrder__c : '';
            ihDTO.ISSUETYPECODE = issueHieRec.Issue_Type_Code__c != null ? issueHieRec.Issue_Type_Code__c : '';
            ihDTO.ISSUETYPE = issueHieRec.Issue_Type_Name__c != null ? issueHieRec.Issue_Type_Name__c : '';
            ihDTO.ISSUETYPEDISPLAYORDER = issueHieRec.IssueTypeDisplayOrder__c != null ? issueHieRec.IssueTypeDisplayOrder__c : '';
            ihDTO.GROUPCODE = issueHieRec.Group_Code__c != null ? issueHieRec.Group_Code__c : '';
            ihDTO.GROUPDESC = issueHieRec.Group_Desc__c != null ? issueHieRec.Group_Desc__c : '';
            ihDTO.GROUPDISPLAYORDER = issueHieRec.GroupDisplayOrder__c != null ? issueHieRec.GroupDisplayOrder__c : '';
            ihDTO.REASONCODE = issueHieRec.Reason_Code__c != null ? issueHieRec.Reason_Code__c : '';
            ihDTO.REASON = issueHieRec.Reason_Name__c != null ? issueHieRec.Reason_Name__c : '';
            ihDTO.REASONDISPLAYORDER = issueHieRec.ReasonDisplayOrder__c != null ? issueHieRec.ReasonDisplayOrder__c : '';
            ihDTO.CAUSECODE = issueHieRec.Cause_Code__c != null ? issueHieRec.Cause_Code__c : '';
            ihDTO.CAUSE = issueHieRec.Cause_Name__c != null ? issueHieRec.Cause_Name__c : '';
            ihDTO.CAUSEDISPLAYORDER = issueHieRec.CauseDisplayOrder__c != null ? issueHieRec.CauseDisplayOrder__c : '';
            ihDTO.CUSTCONSFLAG = issueHieRec.Cust_Cons_Flag__c != null ? issueHieRec.Cust_Cons_Flag__c : '';
            ihDTO.RPTCATEGORY = issueHieRec.RptCategory__c != null ? issueHieRec.RptCategory__c : '';
            ihDTO.ESCALATEFLAG = issueHieRec.EscalateFlagFeed__c != null ? issueHieRec.EscalateFlagFeed__c : '';
            ihDTO.ISSUEASSOCIATION = issueHieRec.Issue_Association__c != null ? issueHieRec.Issue_Association__c : '';
            ihDTO.ISSROLLUP = issueHieRec.Issue_Rollup__c != null ? issueHieRec.Issue_Rollup__c : '';
            ihDTO.FACTORYCONTROLLABLEFLAG = issueHieRec.FactoryControllableFlagFeed__c != null ? issueHieRec.FactoryControllableFlagFeed__c : '';
            ihDTO.PQRBRTPCATEGORY = issueHieRec.Pqrb_Rtp_Category__c != null ? issueHieRec.Pqrb_Rtp_Category__c : '';
            if(issueHieRec.Visible__c != null && issueHieRec.Visible__c) { 
                ihDTO.VISIBLE = 'Y'; 
            } else if(issueHieRec.Visible__c != null && !issueHieRec.Visible__c) { 
                ihDTO.VISIBLE = 'N'; 
            } else if(issueHieRec.Visible__c == null) {
                ihDTO.VISIBLE = '';
            }
            if(issueHieRec.Select__c != null && issueHieRec.Select__c) { 
                ihDTO.SELECT1 = 'Y'; 
            } else if(issueHieRec.Select__c != null && !issueHieRec.Select__c) { 
                ihDTO.SELECT1 = 'N'; 
            } else if(issueHieRec.Select__c == null) {
                ihDTO.SELECT1 = ''; 
            }
            ihDTO.PRODUCTRETURNLEVEL = issueHieRec.Product_Return_Level__c != null ? issueHieRec.Product_Return_Level__c : '';
            ihDTO.ALERTDISTRIBUTION = issueHieRec.Alert_Distribution__c != null ? issueHieRec.Alert_Distribution__c : '';
            ihDTO.ALCSINVESTIGATIONLEVEL = issueHieRec.Alcs_Investigation_Level__c != null ? issueHieRec.Alcs_Investigation_Level__c : '';
            ihDTO.MANFINVESTIGATIONLEVEL = issueHieRec.Manf_Investigation_Level__c != null ? issueHieRec.Manf_Investigation_Level__c : '';
            ihDTO.THRESHOLDWITHMANFINFO = issueHieRec.Threshold_With_Manf_Info__c != null ? issueHieRec.Threshold_With_Manf_Info__c : '';
            ihDTO.THRESHOLDWITHPRODDESCONLY = issueHieRec.Threshold_With_Prod_Desc_Only__c != null ? issueHieRec.Threshold_With_Prod_Desc_Only__c : '';
            ihDTO.SURVEYREQUIREMENTS = issueHieRec.Survey_Requirements__c != null ? issueHieRec.Survey_Requirements__c : '';
            ihDTO.CAUSEID = issueHieRec.CauseId__c != null ? issueHieRec.CauseId__c : '';
            if(issueHieRec.Active__c != null && issueHieRec.Active__c) { 
                ihDTO.ACTIVEFLAG = 'Y'; 
            } else if(issueHieRec.Active__c != null && !issueHieRec.Active__c) { 
                ihDTO.ACTIVEFLAG = 'N'; 
            } else if(issueHieRec.Active__c == null) {
                ihDTO.ACTIVEFLAG = ''; 
            }
            ihDTO.CREATEDDATE = issueHieRec.CreatedDate__c != null ? issueHieRec.CreatedDate__c : '';
            ihDTO.CREATEDBY = createdComNameMap.get(issueHieRec.Id);
            ihDTO.MODIFIEDDATE = issueHieRec.LastModifiedDate__c != null ? issueHieRec.LastModifiedDate__c : '';
            ihDTO.MODIFIEDBY = modifiedComNameMap.get(issueHieRec.Id);
            ihDTO.ARCHIVALDATE = issueHieRec.Archival_Date__c != null ? issueHieRec.Archival_Date__c : '';
            ihDTO.SUBJECT_CODE = issueHieRec.SUBJECT_CODE__c != null ? issueHieRec.SUBJECT_CODE__c : '';
            ihDTO.SUBJECT_DESC = issueHieRec.SUBJECT_DESC__c != null ? issueHieRec.SUBJECT_DESC__c : '';
            
            issueHierarchyDTOList.add(ihDTO);
        }
        
        if(!issueHierarchyDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.IssueHierarchy = issueHierarchyDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.ISSUEHIERARCHY_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<issueHierarchyDTO> IssueHierarchy;
    }
    
    public class issueHierarchyDTO {
        public String TENANTID {get; set;}
        public String CODECATEGORY {get; set;}
        public String CODETYPE {get; set;}
        public String ISSUEHIERARCHYCODE {get; set;}
        public String CLASSIFICATIONCODE {get; set;}
        public String CLASSIFICATION {get; set;}
        public String CLASSIFICATIONDISPLAYORDER {get; set;}
        public String PRODUCTLINECODE {get; set;}
        public String PRODUCTLINE {get; set;}
        public String PRODUCTLINEDISPLAYORDER {get; set;}
        public String ISSUETYPECODE {get; set;}
        public String ISSUETYPE {get; set;}
        public String ISSUETYPEDISPLAYORDER {get; set;}
        public String GROUPCODE {get; set;}
        public String GROUPDESC {get; set;}
        public String GROUPDISPLAYORDER {get; set;}
        public String REASONCODE {get; set;}
        public String REASON {get; set;}
        public String REASONDISPLAYORDER {get; set;}
        public String CAUSECODE {get; set;}
        public String CAUSE {get; set;}
        public String CAUSEDISPLAYORDER {get; set;}
        public String CUSTCONSFLAG {get; set;}
        public String RPTCATEGORY {get; set;}
        public String ESCALATEFLAG {get; set;}
        public String ISSUEASSOCIATION {get; set;}
        public String ISSROLLUP {get; set;}
        public String FACTORYCONTROLLABLEFLAG {get; set;}
        public String PQRBRTPCATEGORY {get; set;}
        public String VISIBLE {get; set;}
        public String SELECT1 {get; set;}
        public String PRODUCTRETURNLEVEL {get; set;}
        public String ALERTDISTRIBUTION {get; set;}
        public String ALCSINVESTIGATIONLEVEL {get; set;}
        public String MANFINVESTIGATIONLEVEL {get; set;}
        public String THRESHOLDWITHMANFINFO {get; set;}
        public String THRESHOLDWITHPRODDESCONLY {get; set;}
        public String SURVEYREQUIREMENTS {get; set;}
        public String CAUSEID {get; set;}
        public String ACTIVEFLAG {get; set;}
        public String CREATEDDATE {get; set;}
        public String CREATEDBY {get; set;}
        public String MODIFIEDDATE {get; set;}
        public String MODIFIEDBY {get; set;}
        public String ARCHIVALDATE {get; set;}
        public String SUBJECT_CODE {get; set;}
        public String SUBJECT_DESC {get; set;}
    }
}