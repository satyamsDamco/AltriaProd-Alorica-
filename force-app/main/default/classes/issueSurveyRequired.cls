/*
Functionality to get the survey list
08/20/2016 Infogain – Created.
*/

Public class issueSurveyRequired{    
    
    //Function to check survey required or not for Selected Issue Hierarchy    
    public Boolean surveyRequired(string issueHierId){
        Map<id,Survey__c> surveyMap = new Map<id,Survey__c>(); 
        surveyMap  = getsurveyList(issueHierId);
        
        if(!surveyMap.isEmpty() && surveyMap.size() >0){
            return true;
        }else{
            return false;
        }
    }
    
    //Function to get the survey list for Selected Issue Hierarchy
    public Map<id,Survey__c> getsurveyList(String issueHierId){
        Map<id,Survey__c> surveyMap = new Map<id,Survey__c>();          
        System.debug('test issueHierId'+issueHierId);       
        if(issueHierId != null){
        
            List<Issue_Hierarchy__c> issueData = new List<Issue_Hierarchy__c>([Select id,Survey_Requirements__c,Classification__r.Description__c,Cause__r.Description__c,group__r.Description__c,reason__r.Description__c,Product_Line_Name__c
                                            from Issue_Hierarchy__c  
                                            Where id =: issueHierId
                                            and ((Survey_Requirements__c != null  and Survey_Requirements__c != '' and Survey_Requirements__c != 'NULL' and Survey_Requirements__c != '0')
                                                 or Classification__r.Description__c =  'APE'
                                                 or Classification__r.Description__c = 'Select APE'
                                                 or Cause__r.Description__c like '%NPRM%'
                                                 or group__r.Description__c  like '%NPRM%'
                                                 or reason__r.Description__c  like '%NPRM%')]);
            
            if(!issueData.isEmpty()){
                String Condition = '';
                
                if(issueData[0].Survey_Requirements__c != null && issueData[0].Survey_Requirements__c != '' && issueData[0].Survey_Requirements__c != 'NULL' && issueData[0].Survey_Requirements__c != '0'){
                    
                    if(issueData[0].Survey_Requirements__c.length() == 1){
                        Condition = ' SurveyIssueHierRequirements__c = \'0'+ issueData[0].Survey_Requirements__c +'\'';
                    }else{
                        Condition = ' SurveyIssueHierRequirements__c = \''+ issueData[0].Survey_Requirements__c +'\'';
                    }                    
                }
                
                if(issueData[0].Classification__r.Description__c != null && issueData[0].Classification__r.Description__c != '' 
                && (issueData[0].Classification__r.Description__c == 'APE' || issueData[0].Classification__r.Description__c == 'Select APE')&& issueData[0].Product_Line_Name__c != 'Heated Tobacco'){
                    if(Condition.trim()  == ''){
                        Condition = '  SurveyIssueHierRequirements__c= \'APE\'';
                    }else{
                        Condition += ' or  SurveyIssueHierRequirements__c = \'APE\'';
                    }            
                }
                
                //ggcutchon 10/1/2018: RITM2135197 - Implementation  for SCR 18-09-24 2018 PMI APE Survey
                if(issueData[0].Classification__r.Description__c != null && issueData[0].Classification__r.Description__c != '' 
                && (issueData[0].Classification__r.Description__c == 'APE' || issueData[0].Classification__r.Description__c == 'Select APE') && issueData[0].Product_Line_Name__c == 'Heated Tobacco'){
                    if(Condition.trim()  == ''){
                        Condition = '  SurveyIssueHierRequirements__c= \'IQOS APE\'';
                    }else{
                        Condition += ' or  SurveyIssueHierRequirements__c = \'IQOS APE\'';
                    }            
                }
                //end of RITM2135197-------------------
                
                if(issueData[0].Cause__r.Description__c.toUpperCase().Contains('NPRM') || issueData[0].group__r.Description__c.toUpperCase().Contains('NPRM') || issueData[0].reason__r.Description__c.toUpperCase().Contains('NPRM')){
                    if(Condition.trim()  == ''){
                        Condition = '  SurveyIssueHierRequirements__c= \'NPRM\'';
                    }else{
                        Condition += ' or  SurveyIssueHierRequirements__c= \'NPRM\'';
                    }            
                }
                
                List<Survey__c> surList  = new List<Survey__c>();
                          
                if(Condition.trim() != ''){                     
                    surList = Database.query('Select id,Survey_Name__c from Survey__c where active__c = true and ( '+Condition+' ) order by Survey_Name__c asc'); 
                }
                
                
                if(!surList.isEmpty()){
                    for(Survey__c suv :surList){
                        surveyMap.put(suv.id,suv);
                    }
                }
            } 
        } 
        
        return surveyMap;
    }   
    
}