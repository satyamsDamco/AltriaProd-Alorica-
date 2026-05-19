global class IssueAdjustmentFutureHelper {
    
    //Method to update issue based on the issue adjustment received
    
	static boolean flagLine = true;    
    public static void updateIssue(List<Id> lstIssueAdjustIds){
    	
        Set<String> updateIssueNumber = new Set<String>();
        Set<String> issueNumber = new Set<String>();
        Map<String,IssueAdjustmentMetadata__mdt> mapIssueAdj = IssueAdjustmentMetadata__mdt.getAll();
        
        List<Issue_Adjustment__c> lstIssueAdjust = new List<Issue_Adjustment__c>([Select Id, Action_Type__c,Adjustment_Code__c,Adjustment_Instructions__c,
                                        Adjustment_Type__c,Comment__c,isReviewed__c,IssueNumber__c,Issue__c,
                                        Name,New_Value__c,Old_Value__c,OwnerId,Request_ID__c,Row_ID__c,Status__c
                                        From Issue_Adjustment__c
                                        Where id in :lstIssueAdjustIds
                                        order by Sequence__c asc]);
        
        for(Issue_Adjustment__c issue : lstIssueAdjust){
            if(issue.IssueNumber__c != null && String.ValueOf(issue.IssueNumber__c) != '')
                issueNumber.add(String.ValueOf(issue.IssueNumber__c));
        }
        
        list<Case> lstCases = [Select Id, CaseNumber,CaseNumber__c, Comment__c, Related_Issue__c, Suspected_Counterfiet__c, 
                               Suspected_Tampering__c, Product_Line__c, Product_Line_Code__c,Date_Type__c, Date__c, Brandcode__c,
                               ValidUstdateCode__c, Crc_Brand_Hierarchy_Code__c, Trace_Code_Location__c,
                               Mfg_Trace_code__c,Date_Code__c,Production_date__c,ValidTraceCode__c,Line__c,
                                DateCodeProductionDate__c,DateCodeLocation__c,DateCodeShift__c,DateCodeUnit__c,DateCodeColdStorage__c,
                                DateCodeRptBay__c,DateCodeRptFactory__c,DateCodeMilitaryTime__c,SpUstDateCode__c,
					Transacation_Id__c,
					Survey__c,
					MasterId__c,
					Confirmed_Counterfeit__c,
					Test_Issue__c,
					Operating_Company__c

                                From Case where CaseNumber__c in: issueNumber];
                               
        list<case> lstCaseUpdate = new list<case>();
        map<String, Case> mapCases = new map<String, Case>();      
        
        if(!lstCases.isEmpty()){
            for(Case issue : lstCases){
                mapCases.put(String.valueOf(issue.CaseNumber__c),issue);
            }
        }
        
         
        for(Issue_Adjustment__c issueAdj : lstIssueAdjust){
            if(issueAdj.Request_ID__c == null || issueAdj.Request_ID__c.trim() == '' || (issueAdj.Request_ID__c != null && !issueAdj.Request_ID__c.isNumeric())){
                issueAdj.Status__c = 'Fail';
                issueAdj.Comment__c = 'Invalid Request Id.';
            }else if(issueAdj.Row_ID__c == null || issueAdj.Row_ID__c.trim() == '' || (issueAdj.Row_ID__c != null && !issueAdj.Row_ID__c.isNumeric())){
                issueAdj.Status__c = 'Fail';
                issueAdj.Comment__c = 'Invalid Row Id.';
            }else if(issueAdj.IssueNumber__c == null || issueAdj.IssueNumber__c.trim() == ''){
                issueAdj.Status__c = 'Fail';
                issueAdj.Comment__c = 'Issue Number is blank.';
            }else if(issueAdj.IssueNumber__c != null && !mapCases.containsKey(issueAdj.IssueNumber__c)){
                issueAdj.Status__c = 'Fail';
                issueAdj.Comment__c = 'CRC Issue ID not found in AloricaDB.';
            }else if(issueAdj.Action_Type__c != null && issueAdj.Action_Type__c.toUpperCase() != 'U' && issueAdj.Action_Type__c.toUpperCase() != 'R'){
                issueAdj.Status__c = 'Fail';
                issueAdj.Comment__c = 'Unknown Action Type';
            }else if(issueAdj.Action_Type__c.toUpperCase() == 'U' && issueAdj.Adjustment_Code__c != 'TC' && issueAdj.Adjustment_Code__c != 'RID' && issueAdj.Adjustment_Code__c != 'BH' && issueAdj.Adjustment_Code__c != 'IH'
                    && issueAdj.Adjustment_Code__c != 'DC' && issueAdj.Adjustment_Code__c != 'SCF' && issueAdj.Adjustment_Code__c != 'ST'  && issueAdj.Adjustment_Code__c != 'CN' && mapIssueAdj.get(issueAdj.Adjustment_Code__c) == null){
                issueAdj.Status__c = 'Fail';
                issueAdj.Comment__c = 'Unknown Adjustment Code found';
            }else{
                Case relissue = mapCases.get(issueAdj.IssueNumber__c);
                System.debug('test 1'+relissue );
                issueAdj.Issue__c = relissue.id;
                
                if(issueAdj.Action_Type__c.trim() != ''){
                    if(issueAdj.Action_Type__c.toUpperCase() == 'R'){
                        issueAdj.Status__c = 'In Process';                        
                    }else{                        
                        if((issueAdj.New_Value__c == null || issueAdj.New_Value__c == '') && (issueAdj.Adjustment_Code__c.toUpperCase() == 'SCF' || issueAdj.Adjustment_Code__c.toUpperCase() == 'ST' || issueAdj.Adjustment_Code__c.toUpperCase() == 'CN' || issueAdj.Adjustment_Code__c.toUpperCase() == 'IH' || issueAdj.Adjustment_Code__c.toUpperCase() == 'BH' || issueAdj.Adjustment_Code__c.toUpperCase() == 'CCL' || issueAdj.Adjustment_Code__c.toUpperCase() == 'ITVT' || issueAdj.Adjustment_Code__c.toUpperCase() == 'ITVU')){        
                            issueAdj.Status__c = 'Fail';
                            issueAdj.Comment__c = 'New Value is blank';
                        }else{                            
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'BH'){
                                Boolean issueValid = updateBrandHierarchy(relissue,issueAdj);                            
                                if(issueValid){
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    }
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue);  
                                }else{
                                    issueAdj.Status__c = 'Fail';
                                }
                            }                  
                                  
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'IH'){
                                Boolean issueValid = updateIssueHierarchy(relissue,issueAdj);                            
                                if(issueValid){
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    }
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue); 
                                }else{
                                    issueAdj.Status__c = 'Fail';
                                }                                
                            }
                            
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'TC'){
                                if(relissue.Trace_Code_Location__c == null  || relissue.Trace_Code_Location__c == ''){
                                    relissue.Trace_Code_Location__c = 'PAC';
                                }
                                if(relissue.Trace_Code_Location__c != null  && relissue.Trace_Code_Location__c != ''){                                
                                    TraceCodeValidation(relissue,issueAdj);
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    } 
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue); 
                                }else{
                                    // added 2022-12-19
                                    relissue.Trace_Code_Location__c = '';
                                    issueAdj.Status__c = 'Fail';
                                    issueAdj.Comment__c = 'Trace Code location missing';
                                } 
                            }
                            
                            
                            // added 2023-01-05 - niel bernas
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'DC'){
                                if(relissue.Date_Code__c != null  && relissue.Date_Code__c != ''){
                                    DateCodeValidation(relissue,issueAdj);
                                    issueAdj.Status__c = 'Success';      
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    } 
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue);  
                                }else{
                                    issueAdj.Status__c = 'Fail';
                                    issueAdj.Comment__c = 'Invalid Date value';
                                }             
                            }
                            
                            // commented 2023-01-05 - niel bernas
                            /*
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'DC'){
                                if(relissue.Trace_Code_Location__c != null  && relissue.Trace_Code_Location__c != ''){
                                    DateCodeValidation(relissue,issueAdj);
                                    issueAdj.Status__c = 'Success';      
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    } 
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue);  
                                }else{
                                    issueAdj.Status__c = 'Fail';
                                    issueAdj.Comment__c = 'Trace Code location missing';
                                }             
                            }
                            */                                                    
                            
                            
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'CN'){
                                relissue.Comment__c = issueAdj.New_Value__c;
                                issueAdj.Status__c = 'Success';
                                if(!updateIssueNumber.contains(relissue.id)){
                                    updateIssueNumber.add(relissue.id);                                        
                                }
                                mapCases.remove(relissue.CaseNumber__c);
                                mapCases.put(relissue.CaseNumber__c,relissue); 
                            }
                            //Logic added by Dharmendra
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'ITL'){
                                relissue.Line__c = issueAdj.New_Value__c;
                                issueAdj.Status__c = 'Success';
                                flagLine = false;
                                 if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                   } 
                            }
                            
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'RID'){
                                if(issueAdj.New_Value__c.isNumeric()){                    
                                    relissue.Related_Issue__c = issueAdj.New_Value__c;
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    }
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue);  
                                }else{
                                    issueAdj.Status__c = 'Fail';
                                    issueAdj.Comment__c = 'Invalid Related Issue Number.';
                                }
                            }
                            
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'SCF'){
                                if(issueAdj.New_Value__c == '0'){
                                    relissue.Suspected_Counterfiet__c = false;
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    }                                
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue);     
                                }else if(issueAdj.New_Value__c == '1'){
                                    relissue.Suspected_Counterfiet__c = true;
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    }                                
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue); 
                                }else{
                                    issueAdj.Status__c = 'Fail';
                                    issueAdj.Comment__c = 'Invalid Suspected Counterfiet value';
                                }                                
                            }
                            
                            if(issueAdj.Adjustment_Code__c.toUpperCase() == 'ST'){
                                if(issueAdj.New_Value__c == '0'){
                                    relissue.Suspected_Tampering__c = false;
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    }                                
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue);     
                                }else if(issueAdj.New_Value__c == '1'){
                                    relissue.Suspected_Tampering__c = true;
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    }                                
                                    mapCases.remove(relissue.CaseNumber__c);
                                    mapCases.put(relissue.CaseNumber__c,relissue); 
                                }else{
                                    issueAdj.Status__c = 'Fail';
                                    issueAdj.Comment__c = 'Invalid Suspected Tampering value';
                                } 
                            }
                            
                            //Start: RITM2322487
                            if(mapIssueAdj.get(issueAdj.Adjustment_Code__c.toUpperCase()) != null) {
                                String adjustmentCode = issueAdj.Adjustment_Code__c.toUpperCase();
                                String newValue = issueAdj.New_Value__c;
                                
                                IssueAdjustmentMetadata__mdt issueAdjmdt = mapIssueAdj.get(adjustmentCode);
                                if(mapCases.get(issueAdj.IssueNumber__c) != null) {
                                    
                                    issueAdj.Status__c = 'Success';
                                    if(!updateIssueNumber.contains(relissue.id)){
                                        updateIssueNumber.add(relissue.id);                                        
                                    }
                                    
                                    if(adjustmentCode == 'ITVT' || adjustmentCode == 'ITVU' || adjustmentCode == 'FC') {
                                        If(newValue == 'Y' || newValue == 'N') {
                                            Boolean boolVal = newValue == 'Y' ? true : false;
                                            mapCases.get(issueAdj.IssueNumber__c).put(issueAdjmdt.Case_Field__c,boolVal);
                                        } else {
                                            issueAdj.Status__c = 'Fail';
                                            switch on adjustmentCode {
                                                when 'ITVT' {
                                                    issueAdj.Comment__c = 'Invalid Valid Trace Code value';
                                                }
                                                when 'ITVU' {
                                                    issueAdj.Comment__c = 'Invalid Valid UST Trace Code value';
                                                }
                                                when else {
                                                    issueAdj.Comment__c = 'Invalid value';
                                                }
                                            }
                                        }
                                    } else if(adjustmentCode == 'ITPD' || adjustmentCode == 'ITUD') {
                                        if(newValue == null || newValue == '') {
                                            mapCases.get(issueAdj.IssueNumber__c).put(issueAdjmdt.Case_Field__c, null);
                                        } else {
                                        
                                            // mm/dd/yyyy - IN USED AS PER LOCALE FORMAT
                                            Boolean newValueDateCheck = Pattern.matches('(0\\d{1}|1[0-2])\\/([0-2]\\d{1}|3[0-1])\\/(19|20)\\d{2}', newValue);
                                              
                                            // dd/mm/yyyy - NOT USED 
                                            // Boolean newValueDateCheck = Pattern.matches('^([0-2][0-9]|(3)[0-1])(\\/)(((0)[0-9])|((1)[0-2]))(\\/)\\d{4}$', newValue);
                                              
                                            if (newValueDateCheck) {
                                                Date newValueDate = date.parse(newValue); 
                                                mapCases.get(issueAdj.IssueNumber__c).put(issueAdjmdt.Case_Field__c, newValueDate);
                                            } else {
                                                issueAdj.Status__c = 'Fail';
                                                issueAdj.Comment__c = 'Invalid Date value';
                                            }
                                        }
                                    } else if(adjustmentCode == 'CCL') {
                                        Integer newValueCnt = newValue.length();
                                        if(newValueCnt <= 3){
                                            mapCases.get(issueAdj.IssueNumber__c).put(issueAdjmdt.Case_Field__c,newValue);
                                        } else {
                                            issueAdj.Status__c = 'Fail';
                                            issueAdj.Comment__c = 'Invalid Counterfeit Code Lookup value';
                                        }
                                    } else {
                                        mapCases.get(issueAdj.IssueNumber__c).put(issueAdjmdt.Case_Field__c,newValue);
                                    }
                                }
                            }
                            //End: RITM2322487
                        }
                    }
                }
            }
        }
       
        database.update(lstIssueAdjust);
        for(Case issue :mapCases.values()){
            if(updateIssueNumber.Contains(issue.id)){
                
                
				Case currIssue = [
					Select

					// START Contact fields
					Contact.ID,
					Contact.Name,
					Contact.CustomerID__c,
					Contact.RecordType.Name,
					Contact.CustomerConsumer__c,
					Contact.CustomerType__c,
					Contact.LastName,
					Contact.Zip_Code__c,
					// END Contact fields

					// START Case Fields
					Id,
					Transacation_Id__c,
					Survey__c,
					MasterId__c,
					Confirmed_Counterfeit__c,
					Suspected_Counterfiet__c,
					Test_Issue__c,
					DateCodeRptFactory__c,
					DateCodeUnit__c,
					Mfg_Trace_code__c,
					Product_Line__c,
					Operating_Company__c,

					ContactId
					From Case
					Where Id =: issue.id
					limit 1
				];
                if(flagLine){
                    system.debug('Issue Value is '+issue);
                    issue.Line__c = IssueAdjustmentFutureHelper.generateLineValue(issue);
                }
				
             
                lstCaseUpdate.add(issue);
            }
        }
        
        if(lstCaseUpdate != null && lstCaseUpdate.size() > 0){
            System.debug('test lstCaseUpdate '+lstCaseUpdate);
            list<Database.SaveResult> lstRes = Database.update(lstCaseUpdate);
        }
		
		
				/*	
        for(Case issue :mapCases.values()){
            if(updateIssueNumber.Contains(issue.id)){
                
				
				Case currIssue = [
					Select

					// START Contact fields
					Contact.ID,
					Contact.Name,
					Contact.CustomerID__c,
					Contact.RecordType.Name,
					Contact.CustomerConsumer__c,
					Contact.CustomerType__c,
					Contact.LastName,
					Contact.Zip_Code__c,
					// END Contact fields

					// START Case Fields
					Id,
					Transacation_Id__c,
					Survey__c,
					MasterId__c,
					Confirmed_Counterfeit__c,
					Suspected_Counterfiet__c,
					Test_Issue__c,
					DateCodeRptFactory__c,
					DateCodeUnit__c,
					Mfg_Trace_code__c,
					Product_Line__c,
					Operating_Company__c,

					ContactId
					From Case
					Where Id =: issue.id
					limit 1
				];
		
				currIssue.Line__c = IssueAdjustmentFutureHelper.generateLineValue(currIssue);
				//currIssue.Line__c = 'test 03';
				update currIssue;
				
            }
        }				
															
*/		
    }
    
    //Method to update issue hierarchy
    private static Boolean updateIssueHierarchy(Case caseObj, Issue_Adjustment__c issueAdj){
        List<Issue_Hierarchy__c> issuehObj = new List<Issue_Hierarchy__c>([select id,Issue_Type__r.Description__c,Product_Line__r.Name,Group__r.Description__c,Reason__r.Description__c,Cause__r.Description__c,
                                                                         Classification__r.Description__c 
                                                                         FROM Issue_Hierarchy__c 
                                                                         WHERE  Active__c = true and  Name =: issueAdj.New_Value__c]);
        if(!issuehObj.isEmpty() && issuehObj.size() >0){
            caseObj.Issue_Hierarchy_Code__c = issuehObj[0].id;
            caseObj.Issue_Type__c=issuehObj[0].Issue_Type__r.Description__c;
            caseObj.Reasontxt__c=issuehObj[0].Reason__r.Description__c;
            caseObj.Causetxt__c=issuehObj[0].Cause__r.Description__c;
            caseObj.Group_Code__c=issuehObj[0].Group__r.Description__c;
            caseObj.Classificationtxt__c=issuehObj[0].Classification__r.Description__c;
            return true;
        }else{            
            issueAdj.Comment__c = 'Invalid Issue Hierarchy.';
            return false;
        } 
    }
    
    //Method to update brand hierarchy
     private static Boolean updateBrandHierarchy(Case caseObj, Issue_Adjustment__c issueAdj){
         system.debug('-----issueAdj.New_Value__c------'+issueAdj.New_Value__c);
         List<Brand_Hierarchy__c> brandhObj = new List<Brand_Hierarchy__c>([select id,Product_Line_Code__c,Product_Line_Code__r.Name  , 
                                                                            UPC__c,Taste__c,Cut__c,Packaging__c,Filter__c,Brand_Code__r.Name,
                                                                            Length__c,Flavor__c,PaperType__c
                                                                            FROM Brand_Hierarchy__c 
                                                                            WHERE Active__c = true and Name =: issueAdj.New_Value__c]);
        if(!brandhObj.isEmpty() && brandhObj.size() >0){
            caseObj.Crc_Brand_Hierarchy_Code__c = brandhObj[0].id;    
            caseObj.UPC_code__c=brandhObj[0].UPC__c;
            caseObj.Filter__c=brandhObj[0].Filter__c;
            caseObj.Taste__c=brandhObj[0].Taste__c;
            caseObj.Packaging__c=brandhObj[0].Packaging__c;
            caseObj.Brandcode__c=brandhObj[0].Brand_Code__r.Name;
            caseObj.Length_Code__c=brandhObj[0].Length__c;
            caseObj.Flavor__c=brandhObj[0].Flavor__c;
            caseObj.Paper_Type__c=brandhObj[0].PaperType__c;
            caseObj.Cut__c=brandhObj[0].Cut__c;
            if(caseObj.Product_Line_Code__c != brandhObj[0].Product_Line_Code__c){
                caseObj.Product_Line_Code__c = brandhObj[0].Product_Line_Code__c;
                caseObj.Product_Line__c = brandhObj[0].Product_Line_Code__r.Name;
            }
            return true;
        }else{
            issueAdj.Status__c = 'Fail';
            issueAdj.Comment__c = 'Invalid Brand Hierarchy.';
            return false;            
        } 
    }
    
    //Method to validate date code
    private static void DateCodeValidation(Case issue, Issue_Adjustment__c issueAdj){
        issue.Date_Type__c = '';
        issue.Date__c = null;
        issue.ValidUstdateCode__c = false;
        issue.Date_Code__c = issueAdj.New_Value__c;        
        
        List<Product_Line__c> ProductLineCode = new List<Product_Line__c>([Select id, Name,code__c,Trace_Code_Location__c,Operating_Company__c,
                                                                         isValidDateCode__c 
                                                                         from Product_Line__c  
                                                                         where id =: issue.Product_Line_Code__c and isActive__c = true ]);  
        System.debug('issue.Product_Line_Code__c '+issue.Product_Line_Code__c);
        if(!ProductLineCode.isEmpty()){
            issue.DateCodeProductionDate__c = null; 
            issue.DateCodeLocation__c = null;
            issue.DateCodeShift__c = null;
            issue.DateCodeUnit__c = null;
            issue.DateCodeColdStorage__c = null;
            issue.DateCodeRptBay__c = null;
            issue.DateCodeRptFactory__c = null;
            issue.DateCodeMilitaryTime__c = null;
            issue.SpUstDateCode__c = null;
                          
            if(issue.Crc_Brand_Hierarchy_Code__c != null){                           
                if(ProductLineCode[0].Code__c != null && ProductLineCode[0].Operating_Company__c != null && issueAdj.New_Value__c != null){                         
                    UstDateCodeValidationHelper.ustTraceCode traceCodeObj = new UstDateCodeValidationHelper.ustTraceCode();
                    UstDateCodeValidationHelper  ustHelper = new UstDateCodeValidationHelper();
                    traceCodeObj = ustHelper.ustTraceCodeValidation(ProductLineCode[0].Code__c,issue.Date_Code__c ,ProductLineCode[0].Operating_Company__c, issue.Trace_Code_Location__c, issue.Crc_Brand_Hierarchy_Code__c);
                    if(traceCodeObj.FinalUstTraceCode != null && traceCodeObj.FinalUstTraceCode != ''){
                        if(traceCodeObj.ProductionDate != null && traceCodeObj.ProductionDate !=  '' && traceCodeObj.ProductionDate != 'fail'){
                            issue.Date__c =  date.parse(traceCodeObj.ProductionDate);                           
                        }
                         issue.ValidUstdateCode__c = true;
                        if(traceCodeObj.FinalUstTraceCode != null && traceCodeObj.FinalUstTraceCode != ''){
                            issue.Date_Type__c =  traceCodeObj.FinalUstTraceCode;
                        }
                    }else{
                        issue.Date__c = null;
                        issue.Date_Type__c =  '';
                        issue.ValidUstdateCode__c = false;
                    }        
                }          
            }                
            
            updateTraceCodeData(issue,ProductLineCode[0]);
        }
    }    
    
    //Method to validate trace code entered
    private static void TraceCodeValidation(Case caseObj, Issue_Adjustment__c issueAdj){
    
        caseObj.Production_date__c  = null;        
        caseObj.ValidTraceCode__c = false;
        caseObj.Mfg_Trace_code__c = issueAdj.New_Value__c;        
        caseObj.Suspected_Counterfiet__c = false;    
        List<Product_Line__c> ProductLineCode = new List<Product_Line__c>([Select id, Name,code__c,Trace_Code_Location__c,Operating_Company__c,
                                                                         isValidDateCode__c 
                                                                         from Product_Line__c  
                                                                         where id =: caseObj.Product_Line_Code__c and isActive__c = true]);  
        
        if(!ProductLineCode.isEmpty()){
            caseObj.DateCodeProductionDate__c = null; 
            caseObj.DateCodeLocation__c = null;
            caseObj.DateCodeShift__c = null;
            caseObj.DateCodeUnit__c = null;
            caseObj.DateCodeColdStorage__c = null;
            caseObj.DateCodeRptBay__c = null;
            caseObj.DateCodeRptFactory__c = null;
            caseObj.DateCodeMilitaryTime__c = null;
            caseObj.SpUstDateCode__c = null;
                
            Boolean counterFeit  = TraceCodeHelper.checkCounterfeitTraceCode(caseObj.Mfg_Trace_code__c);
            if(counterFeit){
                caseObj.Suspected_Counterfiet__c = true;
            }else{
                 caseObj.Suspected_Counterfiet__c = false;
            }
            
            TraceCodeHelper traceHelper = new TraceCodeHelper();
            String productionDate1 = traceHelper.traceCodeValidation(ProductLineCode[0].Code__c,caseObj.Mfg_Trace_code__c,ProductLineCode[0].Operating_Company__c, caseObj.Trace_Code_Location__c, null);
            if(productionDate1 != null &&  productionDate1 !=  '' && productionDate1 != 'fail'){
                productionDate1 = productionDate1.replace('null','');
                if(caseObj.Suspected_Counterfiet__c){
                    if(productionDate1 != null && productionDate1 !=  '' &&  productionDate1 != 'NODATE'){
                        caseObj.Production_date__c = date.parse(productionDate1);
                    }
                }else{
                    if(productionDate1 == 'NODATE'){
                        caseObj.Production_date__c = null;
                    }else{
                        caseObj.Production_date__c = date.parse(productionDate1);
                    }
                    caseObj.ValidTraceCode__c = true;
                }
            }else{
                caseObj.Production_date__c = null;
                caseObj.ValidTraceCode__c = false;
            } 
            updateTraceCodeData(caseObj,ProductLineCode[0]);                          
        }              
    }
    
    //Method to update trace code 
    private static void updateTraceCodeData(Case caseObj,Product_Line__c ProductLineCode){
        
            String ProductLineCode1 = '';
            if(ProductLineCode.Code__c != null){
                ProductLineCode1 = ProductLineCode.Code__c;
            }
            
            String TraceCodeObj = '';   
            if(caseObj.Mfg_Trace_code__c != null){
                TraceCodeObj = caseObj.Mfg_Trace_code__c;
            }            
            
            String TraceCodeLocation = '';
            if(caseObj.Trace_Code_Location__c  != null){
                TraceCodeLocation = caseObj.Trace_Code_Location__c;
            }
            
            String OpCompany = '';
            if(ProductLineCode.Operating_Company__c != null){
                OpCompany = ProductLineCode.Operating_Company__c;
            }                
            
            String UstDateCodeType = '';
            if(caseObj.Date_Type__c != null){
                UstDateCodeType= caseObj.Date_Type__c;
            }
            
            String UstDateCode = '';            
            if(caseObj.Date_Code__c != null){
                UstDateCode= caseObj.Date_Code__c;
            }   
            
            String ProductionDate = '';
            if(caseObj.Production_date__c != null)
                ProductionDate = caseObj.Production_date__c.format();
                
            
            TraceCodesDetailsHelper traceCodeHelpObj = new TraceCodesDetailsHelper();
            TraceCodesDetailsHelper.TraceCodeClass TraceCodeClassObj = new TraceCodesDetailsHelper.TraceCodeClass();
            
            try{
                TraceCodeClassObj = traceCodeHelpObj.getAllTraceCodeValues(
                    ProductLineCode1, 
                    TraceCodeObj,
                    OpCompany, 
                    TraceCodeLocation, 
                    UstDateCodeType,
                    UstDateCode,
                    null
                );
                    
                if(ProductLineCode1 == 'EV'){    
                    caseObj.Production_date__c = null;
                }                                                      
                caseObj.DateCodeProductionDate__c = TraceCodeClassObj.DateCodeProductionDate; 
                caseObj.DateCodeLocation__c = TraceCodeClassObj.DateCodeLocation;
                caseObj.DateCodeShift__c = TraceCodeClassObj.DateCodeShift;
                caseObj.DateCodeUnit__c = TraceCodeClassObj.DateCodeUnit;
                caseObj.DateCodeColdStorage__c = TraceCodeClassObj.DateCodeColdStorage;
                caseObj.DateCodeRptBay__c = TraceCodeClassObj.DateCodeRptBay;
                caseObj.DateCodeRptFactory__c = TraceCodeClassObj.DateCodeRptFactory;
                caseObj.DateCodeMilitaryTime__c = TraceCodeClassObj.DateCodeMilitaryTime;
                caseObj.SpUstDateCode__c = TraceCodeClassObj.SpUstDateCode;
				caseObj.Line__c = IssueAdjustmentFutureHelper.generateLineValue(caseObj);
                
            } catch(exception e){
        
            }
    }
    
    
    public static String generateLineValue(Case currIssue) {
        String lineValue = '';
        
        //Start: Line__c
        // commented: 2023-05-24
        // if (currIssue.DateCodeUnit__c != null) {

        String dcuMidValue = '';
        
        if (currIssue.DateCodeUnit__c != null) {
            dcuMidValue = currIssue.DateCodeUnit__c.mid(1, 1);
        }

        Integer mfgtcCnt = 0;
        List<String> mfgTraceCodeStrList = new List<String>();
        String mfgtcValue = '';
        if (currIssue.Mfg_Trace_code__c != null) {
            mfgTraceCodeStrList = currIssue.Mfg_Trace_code__c.split('');
            mfgtcValue = currIssue.Mfg_Trace_code__c;
            String mfgtcTrim = mfgtcValue.trim();
            mfgtcCnt = mfgtcTrim.length();
        }

        if (currIssue.Product_Line__c == 'TOBACCO DERIVED NICOTINE POUCH') {
            switch on currIssue.DateCodeUnit__c {
                when 'U' {
                    lineValue = 'Bay 9 – Line#1';
                }
                when 'J' {
                    lineValue = 'Bay 9 – Line#2';
                }
                when 'N' {
                    lineValue = 'Bay 9 – Line#3';
                }
                when 'P' {
                    lineValue = 'Bay 9 – Line#4';
                }
                when 'E' {
                    lineValue = 'Bay 9 – Line#5';
                }
                when
                else {
            		lineValue = '';
                }
            }
        } 
        
        else if (currIssue.DateCodeUnit__c != null && currIssue.DateCodeUnit__c !='' && currIssue.Product_Line__c == 'Cigarettes' && dcuMidValue != '0') {
            system.debug('current issue value is '+currIssue);
            lineValue = currIssue.DateCodeUnit__c.substring(0, 2);
        } 
        
        else if (currIssue.DateCodeUnit__c != null  && currIssue.DateCodeUnit__c !='' && currIssue.Product_Line__c == 'Cigarettes' && dcuMidValue == '0') {
            lineValue = currIssue.DateCodeUnit__c.substring(0, 2);
        } 
        
        else if (currIssue.Operating_Company__c != null && currIssue.Operating_Company__c == 'PMIP') {
            lineValue = currIssue.DateCodeUnit__c;
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c != ''  && currIssue.DateCodeRptFactory__c == 'MC_USSTC') {
            lineValue = generateLineValueDateCodeRptFactoryMCUSSTC(currIssue.DateCodeUnit__c);
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c != '' && currIssue.DateCodeRptFactory__c == 'MC_JMC' && mfgtcCnt == 9) {
            lineValue = currIssue.DateCodeUnit__c.mid(0, 2);
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c != '' && currIssue.DateCodeRptFactory__c == 'NS' && mfgTraceCodeStrList.size() > 2 && checkIsNumber(mfgTraceCodeStrList[1])) {
            lineValue = generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber(mfgTraceCodeStrList[4]);
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c != '' && currIssue.DateCodeRptFactory__c == 'NS' && mfgTraceCodeStrList.size() > 2 && checkIsAlpha(mfgTraceCodeStrList[1])) {
            lineValue = generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha(mfgTraceCodeStrList[8]);
        } 
        
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c != '' && currIssue.DateCodeRptFactory__c == 'FP' && mfgTraceCodeStrList.size() > 2 && checkIsNumber(mfgTraceCodeStrList[1])) {
            lineValue = generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber(mfgTraceCodeStrList[4]);
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c != '' && currIssue.DateCodeRptFactory__c == 'FP' && mfgTraceCodeStrList.size() > 2 && checkIsAlpha(mfgTraceCodeStrList[1])) {
            lineValue = generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha(mfgTraceCodeStrList[8]);
        } 
        
        else {
            lineValue = '';
        }
            
        return lineValue;
    }
    
    
    
    public static String generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber(String mfgtcMidValue) {
        String lineValue = '';
        
        
        switch on mfgtcMidValue {
            when 'A' {
                lineValue = 'POUCH LINE #1';
            }
            when 'B' {
                lineValue = 'POUCH LINE #2';
            }
            when 'C' {
                lineValue = 'SKOAL #8';
            }
            when 'E' {
                lineValue = 'CELL LINE A';
            }
            when 'H' {
                lineValue = 'COPE #3';
            }
            when 'I' {
                lineValue = 'SKOAL #7';
            }
            when 'L' {
                lineValue = 'SKOAL #6';
            }
            when 'M' {
                lineValue = 'SKOAL #9';
            }
            when 'N' {
                lineValue = 'COPE #1';
            }
            when 'P' {
                lineValue = 'HIGH SPEED CELL LINE #1';
            }
            when 'R' {
                lineValue = 'CELL LINE B';
            }
            when 'S' {
                lineValue = 'COPE #2';
            }
            when 'V' {
                lineValue = 'SKOAL #5';
            }
            when '2' {
                lineValue = 'MP - CELL LINE D';
            }
            when
                else {
                    lineValue = '';
                }
        }
        
        return lineValue;
    }
    
    public static String generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha(String mfgtcMidValue) {
        String lineValue = '';
        
        
        switch on mfgtcMidValue {
            when 'E' {
                lineValue = 'CELL LINE';
            }
            when 'H' {
                lineValue = 'COPE #3';
            }
            when 'I' {
                lineValue = 'SKOAL #4';
            }
            when 'L' {
                lineValue = 'SKOAL #6';
            }
            when 'N' {
                lineValue = 'COPE #1';
            }
            when 'S' {
                lineValue = 'COPE #2';
            }
            when 'V' {
                lineValue = 'SKOAL #5';
            }
            when '2' {
                lineValue = 'POUCH LINE #1';
            }
            when '3' {
                lineValue = 'POUCH LINE #2';
            }
            when '4' {
                lineValue = 'HIGH SPEED CAN LINE 1';
            }
            when '5' {
                lineValue = 'HIGH SPEED CAN LINE 2';
            }
            when
                else {
                    lineValue = '';
                }
        }
        
        return lineValue;
    }
    
    
    
    public static String generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber(String mfgtcMidValue) {
        String lineValue = '';
        
        
        switch on mfgtcMidValue {
            when 'E' {
                lineValue = 'CELL LINE A';
            }
            when 'F' {
                lineValue = 'COPE #2';
            }
            when 'G' {
                lineValue = 'COPE #3';
            }
            when 'J' {
                lineValue = 'GD CELL LINE';
            }
            when 'K' {
                lineValue = 'BANDIT #1';
            }
            when 'M' {
                lineValue = 'CELL LINE #1';
            }
            when 'O' {
                lineValue = 'COPE #1';
            }
            when 'W' {
                lineValue = 'BANDIT #2';
            }
            when 'X' {
                lineValue = 'READY PAK';
            }
            when 'Y' {
                lineValue = 'ODD BRAND';
            }
            when 'Z' {
                lineValue = 'OFF LINE';
            }
            when
                else {
                    lineValue = '';
                }
        }
        
        return lineValue;
    }
    
    
    public static String generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha(String mfgtcMidValue) {
        String lineValue = '';
        
        
        switch on mfgtcMidValue {
            when 'A' {
                lineValue = 'SKOAL #1';
            }
            when 'B' {
                lineValue = 'SKOAL #2';
            }
            when 'G' {
                lineValue = 'COPE #3';
            }
            when 'I' {
                lineValue = 'COPE #2';
            }
            when 'J' {
                lineValue = 'GD CELL LINE';
            }
            when 'K' {
                lineValue = 'BANDIT #1';
            }
            when 'M' {
                lineValue = 'CELL LINE #1';
            }
            when 'O' {
                lineValue = 'COPE #1';
            }
            when 'P' {
                lineValue = 'SKOAL #3';
            }
            when 'Y' {
                lineValue = 'ODD BRAND';
            }
            when 'R' {
                lineValue = 'CELL LINE #2';
            }
            when 'W' {
                lineValue = 'BANDIT #2';
            }
            when 'X' {
                lineValue = 'READY PAK';
            }
            when 'Z' {
                lineValue = 'OFF LINE';
            }
            when
                else {
                    lineValue = '';
                }
        }
        
        return lineValue;
    }
    
    public static String generateLineValueDateCodeRptFactoryMCUSSTC(String dateCodeUnit) {
        String lineValue = '';
        switch on dateCodeUnit {
            when 'K' {
                lineValue = 'MC LINE #1';
            }
            when 'G' {
                lineValue = 'MC LINE #2';
            }
            when 'T' {
                lineValue = 'MC LINE #3';
            }
            when 'Y' {
                lineValue = 'MC LINE #4';
            }
            when 'Z' {
                lineValue = 'MC POUCH LINE';
            } 
            when
                else {
                    lineValue = '';
                }
        }
        return lineValue;
    }
    
    public static Boolean checkIsAlpha(String strToCheck) {
        return strToCheck.isAlpha();
    }

    public static Boolean checkIsNumber(String strToCheck) {
        return strToCheck.isNumeric();
    }
}