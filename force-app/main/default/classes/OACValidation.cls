public class OACValidation {
    public  List<string> checkMandatoryFields(IQOSResponseClass.jsonWrapper_CEA jsonBody){
        List<Store_Type__c> ST;
        String valMessage = '';
        String sqlMessage = '';
        boolean isValid = true;
        List<String> finalMessage = new List<String>();
        
        map<string, Brand_Hierarchy__c> BH_Map = new map<string, Brand_Hierarchy__c>();
        map<string, Issue_Hierarchy__c> IH_Map = new map<string, Issue_Hierarchy__c>();
        List<Brand_Hierarchy__c> BH = new List<Brand_Hierarchy__c>();
        List<Issue_Hierarchy__c> IH = new List<Issue_Hierarchy__c>();
        List<String> BHList = new List<String> ();
        List<String> IHList = new List<String> ();
        
        if(jsonBody.IssueInfo.size() > 0){
            //system.assertequals(null, jsonBody.IssueInfo);
            System.debug('test'+jsonBody.IssueInfo);
            for(integer jsonIssue = 0 ; jsonIssue < jsonBody.IssueInfo.size(); jsonIssue++ ){
                if(jsonBody.IssueInfo[jsonIssue].BrandHierarchy != null && jsonBody.IssueInfo[jsonIssue].BrandHierarchy != ''){
                    BHList.add(jsonBody.IssueInfo[jsonIssue].BrandHierarchy);
                }
                if(jsonBody.IssueInfo[jsonIssue].IssueHierarchy != null && jsonBody.IssueInfo[jsonIssue].IssueHierarchy != '' ){
                    IHList.add(jsonBody.IssueInfo[jsonIssue].IssueHierarchy);
                }
            }
        }
        //getting the brand hierarcy
        if(BHList.size() > 0){
            BH = [Select Name, Id, UPC__c, Brand_Code__c, Filter__c, Packaging__c,Brand_Code__r.Name from Brand_Hierarchy__c Where Name IN: BHList ];
        }
        if(BH.size() > 0){
            for(Brand_Hierarchy__c b: BH){
                BH_Map.put(b.Name, b);
            }   
        }//end of brand hierarcy
        
        //getting the issue hierarcy
        if(IHList.size() > 0){
            IH = [Select Name, Id, Classification__c,Issue_Type__c, Group__c,Reason__c, Cause__c, Classification__r.Description__c, Reason__r.Description__c,  Issue_Type__r.Description__c,Cause__r.Description__c,Group__r.Description__c from Issue_Hierarchy__c where  Name IN: IHList];
        }
        if(IH.size() > 0){
            for(Issue_Hierarchy__c i: IH){
                IH_Map.put(i.Name, i);
            }   
        }//end of issue hierarcy
        
        
        //Case fields
        if(jsonBody.IssueInfo.size() > 0){
            for(integer jsonIssue = 0 ; jsonIssue < jsonBody.IssueInfo.size(); jsonIssue++ ){
                String caseValMessage = '';
                String caseSqlMessage = '';
                if(jsonBody.IssueInfo[jsonIssue].BrandHierarchy == ''){
                    caseValMessage = caseValMessage + 'Brand Hierarchy, ';
                    isValid = false;
                }
                else{
                    if(!BH_Map.containskey(jsonBody.IssueInfo[jsonIssue].BrandHierarchy)){
                        caseSqlMessage = caseSqlMessage + 'Brand Hierarchy not Valid, ';
                        isValid = false;
                    }
                }

                if(jsonBody.IssueInfo[jsonIssue].AgentID == ''){
                    caseValMessage = caseValMessage + 'Agent ID, ';
                    isValid = false;
                }
                if(jsonBody.IssueInfo[jsonIssue].Comment == ''){
                    caseValMessage = caseValMessage + 'Comment, ';
                    isValid = false;
                }
                if(jsonBody.IssueInfo[jsonIssue].ComplaintSource == ''){
                    caseValMessage = caseValMessage + 'Complaint Source, ';
                    isValid = false;
                }
                if(jsonBody.IssueInfo[jsonIssue].ReferenceID == ''){
                    caseValMessage = caseValMessage + 'Reference ID, ';
                    isValid = false;
                }
                if(jsonBody.IssueInfo[jsonIssue].IssueHierarchy == ''){
                    caseValMessage = caseValMessage + 'Issue Hierarchy, ';
                    isValid = false;
                }
                else{
                    if(!IH_Map.containskey(jsonBody.IssueInfo[jsonIssue].IssueHierarchy)){
                        caseSqlMessage = caseSqlMessage + 'Issue Hierarchy not Valid, ';
                        isValid = false;
                    }
                }

                if(jsonBody.IssueInfo[jsonIssue].PurchasePrice == null){
                    caseValMessage = caseValMessage + 'Purchase Price, ';
                    isValid = false;
                }
               /* if(jsonBody.IssueInfo[jsonIssue].ReimbursedOrRepIndicator == ''){
                    caseValMessage = caseValMessage + 'Reimbursed Or Replaced Indicator, ';
                    isValid = false;
                }*/
                /*if(jsonBody.IssueInfo[jsonIssue].ThirdPartyRA == null){
                    caseValMessage = caseValMessage + 'Third Party Reimbursement Amount, ';
                    isValid = false;
                }*/
                    
                if(caseValMessage != ''){
                    caseValMessage = caseValMessage.removeEnd(', ') + ' cannot be null for Issue Reference ID: ' + jsonBody.IssueInfo[jsonIssue].ReferenceID;
                    if(caseSqlMessage != ''){
                        caseValMessage = caseSqlMessage + ' ' + caseValMessage;
                    }
                    finalMessage.add(caseValMessage);
                }
                
                if(caseSqlMessage != '' && caseValMessage == ''){
                        caseSqlMessage = caseSqlMessage.removeEnd(', ') + + ' for Issue Reference ID: ' + jsonBody.IssueInfo[jsonIssue].ReferenceID;
                        finalMessage.add(caseSqlMessage);
                }
                
                caseValMessage = '';
                caseSqlMessage = '';
                
            }
            
        }
        

        // End of case fields
        
        //Contact Fields
        if(jsonBody.ContactInfo.firstName == ''){
            valMessage = valMessage + 'First Name, ';
            isValid = false;
        }
        if(jsonBody.ContactInfo.lastName == ''){
            valMessage = valMessage + 'Last Name, ';
            isValid = false;
        }
        if(jsonBody.ContactInfo.addressLine1 == ''){
            valMessage = valMessage + 'Address Line 1, ';
            isValid = false;
        }
        if(jsonBody.ContactInfo.zip == ''){
            valMessage = valMessage + 'Zip, ';
            isValid = false;
        }
        if(jsonBody.ContactInfo.city == ''){
            valMessage = valMessage + 'City, ';
            isValid = false;
        }
        if(jsonBody.ContactInfo.state == ''){
            valMessage = valMessage + 'State, ';
            isValid = false;
        }
        if(jsonBody.ContactInfo.addressVerified == null){
            valMessage = valMessage + 'Address Verified, ';
            isValid = false;
        }
        if(jsonBody.ContactInfo.dob == ''){
            valMessage = valMessage + 'DOB, '; 
            isValid = false;
        }
        if(jsonBody.ContactInfo.ageVerified == null){
            valMessage = valMessage + 'Age Verified, ';
            isValid = false;
        }
        // end of contact fields
        //Store Field
        if(jsonBody.StoreInfo.StoreType == ''){
            valMessage = valMessage + 'Store Type, ';
            isValid = false;
        }
        else{
            ST = [Select Id, Description__c from Store_Type__c where Description__c =: jsonBody.StoreInfo.StoreType limit 1];
            //system.assertequals(null,ST);
            if(ST.isEmpty()){
                sqlMessage = sqlMessage + 'Store Type not Valid. ';
                isValid = false;
            }
        }
        //Store Field
        if(jsonBody.StoreInfo.StoreName == ''){  
            valMessage = valMessage + 'Store Name, ';
            isValid = false;
        }
        
        if(valMessage != ''){
            valMessage = valMessage.removeEnd(', ') + ' cannot be null.';
            if(sqlMessage != ''){
                valMessage = valMessage + ' ' + sqlMessage;
            }
            finalMessage.add(valMessage);
        }
        
        if(sqlMessage != '' && valMessage == ''){
            //sqlMessage = valMessage + ' ' + sqlMessage;
            finalMessage.add(sqlMessage);
        }
        
        if(finalMessage.size() > 0){
            return finalMessage;
        }else{
            finalMessage.clear();
            return finalMessage;
        }
        
        /*if(isValid == false){
            if(valMessage!= ''){
                valMessage = valMessage.removeEnd(',') + ' cannot be null for Issue Reference ID: ' + jsonBody.IssueInfo.ReferenceID;
            }
            if(sqlMessage != ''){
                return valMessage + ' ' + sqlMessage;
            }
            else{
                return valMessage;
            }
        }
        else{
            return null;
        }*/
    }


}