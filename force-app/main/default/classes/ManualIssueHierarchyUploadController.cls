public class ManualIssueHierarchyUploadController{

    public string nameFile{get;set;}
    public string fileData{get;set;}
    public Blob contentFile{get;set;}
    public List<wrapperIssueHierarchy> newRecords {get;set;}
    public List<wrapperIssueHierarchy> deactiveRecords {get;set;}
    public boolean errordata {get;set;}
    List<Classification__c> classDataList;
    List<Cause__c> causeDataList;
    List<Reason__c> reasonDataList;
    List<Group__c> groupDataList;
    List<Issue_Type__c> issueTypeDataList;
    
    public ManualIssueHierarchyUploadController(){
        newRecords = new List<wrapperIssueHierarchy>();
        deactiveRecords = new List<wrapperIssueHierarchy>();
        classDataList = new List<Classification__c>();
        causeDataList = new List<Cause__c>();
        reasonDataList = new List<Reason__c>();
        groupDataList = new List<Group__c>();
        issueTypeDataList = new List<Issue_Type__c>();
        errordata = false;
    }
        
    /***This function reads the CSV file and inserts records into the Account object. ***/
    public Pagereference ReadFile(){
    
        List<List<String>> allFields = new List<List<String>>();
        newRecords = new List<wrapperIssueHierarchy>();
        deactiveRecords = new List<wrapperIssueHierarchy>();
        List<String> lines = new List<String>();
        errordata = false;
        Boolean missingData = false;
        Boolean dupliacteErrorFile = false;
        Boolean dupliacteErrorData = false;
        try{
            if (!Test.isRunningTest()) { 
                if(contentFile == null){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select the file'));
                    return null;
                }
                
                if(!nameFile.endsWith('.csv')){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select the CSV file only'));
                    return null;
                }
                
                try{
                    fileData =contentFile.toString();
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select the valid CSV file'));
                    return null;
                } 
            }else{
                if(nameFile == 'test123'){
                    fileData = ' Action,ISSUEHIERARCHYCODE,Classification,Product Line,Cause ID,Issue Type,Group,Reason,Cause,RptCategory,ActiveFlag,EscalateFlag,IssueAssociation,Rollup,Factory Controllable Flag,PQRBRTPCATEGORY,Visible,Select,ProductReturnLevel,AlertDistribution,AlcsInvestigationLevel,ManfInvestigationLevel,ThresholdWithManfInfo,ThresholdWithProdDescOnly,SurveyRequirements,Display Flag\r\n';
                    fileData += 'Add New Hierarchy,,,MST,1600004,Test1,Brand Ads1,Brand Ads2,Brand Ads1,Advertising,Y,0,Brand,Brand Ads,0,Not A Complaint,N,N,0,NULL,1,0,99,99,NULL,ALL\r\n';
                    fileData += 'INACTIVATE,IH100,Not a Complaint2,MST,1600031,Other,Industry,Against,Against,Other,Y,0,Brand,Industry,0,Not A Complaint,N,N,0,NULL,1,0,99,99,NULL,ALL\r\n';
                    fileData += 'Add New Hierarchy,,Not a Complaint test1,MST,1600004,Test1,Brand Ads1,Brand Ads2,Brand Ads1,Advertising,Y,0,Brand,Brand Ads,0,Not A Complaint,N,N,0,NULL,1,0,99,99,NULL,ALL\r\n';
                    fileData += 'Add New Hierarchy,,Not a Complaint test2,MST,1600004,Test1,Brand Ads1,Brand Ads2,Brand Ads1,Advertising,Y,0,Brand,Brand Ads,0,Not A Complaint,N,N,0,NULL,1,0,99,99,NULL,ALL\r\n';
                    fileData += 'Add New Hierarchy,,Not a Complaint test2,MST,1600004,Test1,Brand Ads1,Brand Ads2,Brand Ads1,Advertising,Y,0,Brand,Brand Ads,0,Not A Complaint,N,N,0,NULL,1,0,99,99,NULL,ALL\r\n';
                    fileData += 'INACTIVATE,IH100,Not a Complaint2,MST,1600031,Other,Industry,Against,Against,Other,Y,0,Brand,Industry,0,Not A Complaint,N,N,0,NULL,1,0,99,99,NULL,ALL\r\n';
                    fileData += 'INACTIVATE,,Not a Complaint2,MST,1600031,Other,Industry,Against,Against,Other,Y,0,Brand,Industry,0,Not A Complaint,N,N,0,NULL,1,0,99,99,NULL,ALL\r\n';
                }else{
                
                    fileData = ' Action,ISSUEHIERARCHYCODE,CLASSIFICATION,PRODUCT LINE,CAUSE ID,ISSUE TYPE,GROUP,REASON,CAUSE,RPTCATEGORY,ACTIVEFLAG,ESCALATEFLAG,ISSUEASSOCIATION,ROLLUP,FACTORY CONTROLLABLE FLAG,PQRB RTP CATEGORY (REPORTING GROUPING),VISIBLE,SELECT,PRODUCTRETURNLEVEL,ALERTDISTRIBUTION,ALCSINVESTIGATIONLEVEL,MANFINVESTIGATIONLEVEL,THRESHOLDWITHMANFINFO,THRESHOLDWITHPRODDESCONLY,SURVEYREQUIREMENTS,DISPLAY FLAG\r\n';
                    fileData += 'Add New Hierarchy,,APE,Cigarettes,1101015,Advertising,Administrative,Can Falling Apart,NPRM In Filler/String,Packaging Related,Y,0,Brand,General Complaint Carton,0,Packaging,Y,N,0,,1,0,2,,,ALL\r\n';
                    fileData += 'Add New Hierarchy,,Not a Complaint,Cigars,1101015,Product,Are Materials Recyclable,Tight Film,Tear / Hole Display Box,Packaging Related,Y,0,Brand,General Complaint Carton,0,Packaging,Y,N,0,,1,0,2,,,ALL\r\n';
                    fileData += 'Add New Hierarchy,,OAC,Corporate,1101015,Promotions,Pipe Tobacco Case,Pack Wet,Distribution Case Damage,Packaging Related,Y,0,Brand,General Complaint Carton,0,Packaging,Y,N,0,,1,0,2,,,ALL\r\n';
                    fileData += 'Add New Hierarchy,,Select APE,Dry Snuff,1101015,Questions/ Requests,Pipe Tobacco Distribution,No Presenting Cause,Retailer Selling Complimentary Cigars,Packaging Related,Y,0,Brand,General Complaint Carton,0,Packaging,Y,N,0,,1,0,2,,,ALL\r\n';
                    fileData += 'Add New Hierarchy,,Select OAC,E-Cigarette,1101015,Regulatory,Pipe Tobacco Pack,Taste/Odor/Stale,Incorrect Cigar In Pack,Packaging Related,Y,0,Brand,General Complaint Carton,0,Packaging,Y,N,0,,1,0,2,,,ALL\r\n';
                    fileData += 'INACTIVATE,IH16617,APE,MST,16054,Complaints,Packaging Quality,Case Damaged,Case Damage General,Packaging Related,Y,0,Brand,Case Damaged,0,Packaging,Y,N,0,,1,0,2,99,,ALL\r\n';
                    fileData += 'INACTIVATE,IH16651,APE,USSTC Snus,16163,Complaints,Packaging Quality,Case Damaged,Case Damage General,Packaging Related,Y,0,Brand,Case Damaged,0,Packaging,Y,N,0,,1,0,2,99,,ALL\r\n';
                    fileData += 'INACTIVATE,IH16688,APE,Loose Leaf,16352,Complaints,Packaging Quality,Case Damaged,Case Damage General,Packaging Related,Y,0,Brand,Case Damaged,0,Packaging,Y,N,0,,1,0,2,99,,ALL\r\n';
                    fileData += 'INACTIVATE,IH72,APE,Cigarettes,7067,Complaints,Case,Case Damaged,Case Hole,Distribution,Y,0,Brand,Case Hole,0,Packaging,Y,N,0,,1,0,2,,,CUST\r\n';
                    fileData += 'INACTIVATE,IH16637,APE,Pouch,16131,Complaints,Packaging Quality,Case Damaged,Case Hole,Packaging Related,Y,0,Brand,Case Damaged,0,Packaging,Y,N,0,,1,0,2,99,,ALL\r\n';

                
                }
            }
            //Convert the uploaded file which is in BLOB format into a string
            
            fileData = fileData.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');

            fileData = fileData.replaceAll('""','DBLQT');
            //Now sepatate every row of the excel file
            System.debug('fileData '+fileData );
            lines = fileData.split('\r\n');
            System.debug('fileData '+lines );
            Integer num = 0;
            for(Integer i=0;i<lines.size();i++) {
                // check for blank CSV lines (only commas)
                string line = lines[i];
                if (line.replaceAll(',','').trim().length() == 0) break;
                
                List<String> fields = line.split(',');  
                List<String> cleanFields = new List<String>();
                String compositeField;
                Boolean makeCompositeField = false;
                for(String field : fields) {
                    String fieldValue = '';
                    if (field.startsWith('"') && field.endsWith('"')) {
                        fieldValue = field.replaceAll('DBLQT','"');
                    } else if (field.startsWith('"')) {
                        makeCompositeField = true;
                        compositeField = field;
                    } else if (field.endsWith('"')) {
                        compositeField += ',' + field;
                        fieldValue = compositeField.replaceAll('DBLQT','"');
                        makeCompositeField = false;
                    } else if (makeCompositeField) {
                        compositeField +=  ',' + field;
                    } else {
                        fieldValue = field.replaceAll('DBLQT','"');
                    }
                    if(fieldValue != null && fieldValue!= ''){
                        cleanFields.add(fieldValue);                    
                    }
                }                
                allFields.add(cleanFields);
            }
            Map<integer, string> fieldMap = new Map<integer, string>();
            Set<String> ClassificationSet = new Set<String>();
            Set<String> ProductLineSet = new Set<String>();
            Set<String> IssueTypeSet = new Set<String>();
            Set<String> GroupSet = new Set<String>();
            Set<String> ReasonSet = new Set<String>();
            Set<String> CauseSet = new Set<String>();           
            
            Set<String> issueHierarchySet = new Set<String>();
            Map<String,List<Integer>> duplicateMap = new  Map<String,List<Integer>>(); 
            Map<String,List<Integer>> duplicateNameMap = new  Map<String,List<Integer>>(); 
            
            for(Integer i=0;i<allFields.size();i++){
                string line = lines[i];
                wrapperIssueHierarchy wpIssueData = new wrapperIssueHierarchy();
                wpIssueData.IssueHierarchyObj = new Issue_Hierarchy__c();
                wpIssueData.rowNumber = newRecords.size()+1;
                List<String> fields = line.split(','); 
                for(Integer j=0;j<fields.size();j++){                    
                    String field = fields[j];
                    if(i == 0){
                        field = field.trim().toUpperCase();
                            
                        if(field == 'REQUESTED' || field == 'ACTION' || field == 'CHANGE')
                            fieldMap.put(j,'ACTION');
                            
                         if(field == 'ISSUEHIERARCHYCODE')
                            fieldMap.put(j,'ISSUEHIERARCHYCODE');
                        
                        if(field == 'CLASSIFICATION')
                            fieldMap.put(j,'CLASSIFICATION');                        
                        
                        if(field == 'PRODUCT LINE' || field == 'PRODUCTLINE')
                            fieldMap.put(j,'PRODUCTLINE');
                                                
                        if(field == 'CAUSE ID' || field == 'CAUSEID')
                            fieldMap.put(j,'CAUSEID');
                        
                        if(field == 'ISSUETYPE' || field == 'ISSUE TYPE')
                            fieldMap.put(j,'ISSUETYPE');
                                                
                        if(field == 'GROUP')
                            fieldMap.put(j,'GROUP'); 
                        
                        if(field == 'REASON')
                            fieldMap.put(j,'REASON');
                                                
                        if(field == 'CAUSE')
                            fieldMap.put(j,'CAUSE');
                        
                        if(field == 'RPTCATEGORY')
                            fieldMap.put(j,'RPTCATEGORY');
                                                                        
                        if(field == 'ACTIVEFLAG' || field == 'ACTIVE FLAG')
                            fieldMap.put(j,'ACTIVEFLAG');   
                        
                         if(field == 'ESCALATEFLAG' || field == 'ESCALATE FLAG')
                            fieldMap.put(j,'ESCALATEFLAG');
                                                
                        if(field == 'ISSUEASSOCIATION')
                            fieldMap.put(j,'ISSUEASSOCIATION');
                        
                        if(field == 'ROLLUP')
                            fieldMap.put(j,'ROLLUP');
                        
                        if(field == 'FACTORY CONTROLLABLE FLAG' || field ==  'FACTORYCONTROLLABLEFLAG')
                            fieldMap.put(j,'FACTORYCONTROLLABLEFLAG');
                                                
                        if(field == 'PQRB RTP CATEGORY' || field == 'PQRBRTPCATEGORY' || field == 'PQRB RTP CATEGORY (REPORTING GROUPING)')
                            fieldMap.put(j,'PQRBRTPCATEGORY');   
                            
                        if(field == 'VISIBLE')
                            fieldMap.put(j,'VISIBLE');
                        
                        if(field == 'SELECT')
                            fieldMap.put(j,'SELECT');
                            
                        if(field == 'PRODUCTRETURNLEVEL')
                            fieldMap.put(j,'PRODUCTRETURNLEVEL');
                        
                        if(field == 'ALERTDISTRIBUTION')
                            fieldMap.put(j,'ALERTDISTRIBUTION');
                        
                        if(field == 'ALCSINVESTIGATIONLEVEL')
                            fieldMap.put(j,'ALCSINVESTIGATIONLEVEL');
                        
                        if(field == 'MANFINVESTIGATIONLEVEL')
                            fieldMap.put(j,'MANFINVESTIGATIONLEVEL');
                                                
                        if(field == 'THRESHOLDWITHMANFINFO')
                            fieldMap.put(j,'THRESHOLDWITHMANFINFO');
                            
                        if(field == 'THRESHOLDWITHPRODDESCONLY')
                            fieldMap.put(j,'THRESHOLDWITHPRODDESCONLY');
                        
                        if(field == 'SURVEYREQUIREMENTS')
                            fieldMap.put(j,'SURVEYREQUIREMENTS');
                                                
                        if(field == 'DISPLAYFLAG' || field == 'DISPLAY FLAG')
                            fieldMap.put(j,'DISPLAYFLAG');
                    }else{
                        String fieldValue = '';
                        if(fieldMap.ContainsKey(j)){
                            fieldValue = fieldMap.get(j).toupperCase();
                        }
                        field = field == 'NULL' || field == 'null' ? '' :field.trim().replaceAll('"','').replaceAll('DBLQT','');
                        field =  field.trim();                         
                        String typeOfOperation = 'INACTIVATE'; 
                                                    
                        if(fieldValue == 'ACTION')
                            wpIssueData.Requested = field;
                        
                        String RequestType = wpIssueData.Requested;
                        
                        if(fieldValue == 'ISSUEHIERARCHYCODE'){
                            wpIssueData.Name = field;
                            if(field != null && field.trim() != '' && typeOfOperation == RequestType){
                                issueHierarchySet.add(field);
                            }
                        }
                        
                        if(fieldValue == 'CLASSIFICATION'){
                            wpIssueData.Classification = field;  
                            if(!ClassificationSet.Contains(field)  && typeOfOperation != RequestType)    
                                ClassificationSet.add(field);
                        }
                        if(fieldValue == 'PRODUCTLINE'){
                            wpIssueData.ProductLine = field;
                            if(!ProductLineSet.Contains(field) && typeOfOperation != RequestType)    
                                ProductLineSet.add(field);
                        }    
                        
                        if(fieldValue == 'ISSUETYPE'){
                            wpIssueData.IssueType = field;
                            if(!IssueTypeSet.Contains(field) && typeOfOperation != RequestType)    
                                IssueTypeSet.add(field);
                        }
                                                
                        if(fieldValue == 'GROUP'){
                            wpIssueData.GroupVal = field;
                            if(!GroupSet.Contains(field) && typeOfOperation != RequestType)    
                                GroupSet.add(field);
                        }
                        
                        if(fieldValue == 'REASON'){
                            wpIssueData.Reason = field;
                            if(!ReasonSet.Contains(field) && typeOfOperation != RequestType)    
                                ReasonSet.add(field);
                        }
                                                
                        if(fieldValue == 'CAUSE'){
                            wpIssueData.Cause = field;
                            if(!CauseSet.Contains(field) && typeOfOperation != RequestType)    
                                CauseSet.add(field);
                        }
                        
                        if(fieldValue == 'CAUSEID'){
                            wpIssueData.CauseID = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.CauseId__c = field;
                        }    
                        
                        if(fieldValue == 'RPTCATEGORY'){
                            wpIssueData.RptCategory = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.RptCategory__c = field;
                        }
                                                
                        if(fieldValue == 'ISSUEASSOCIATION'){
                            wpIssueData.IssueAssociation = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Issue_Association__c = field;
                        }
                        
                        if(fieldValue == 'ROLLUP'){
                            wpIssueData.Rollup = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Issue_Rollup__c = field;
                        }
                                               
                        if(fieldValue == 'PQRBRTPCATEGORY'){
                            wpIssueData.PqrbRtpCategory = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Pqrb_Rtp_Category__c = field;
                        }
                            
                        if(fieldValue == 'PRODUCTRETURNLEVEL'){
                            wpIssueData.ProductReturnLevel = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Product_Return_Level__c = field;
                        }
                        
                        if(fieldValue == 'ALERTDISTRIBUTION'){
                            wpIssueData.AlertDistribution = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Alert_Distribution__c = field;
                        }
                        
                        if(fieldValue == 'ALCSINVESTIGATIONLEVEL'){
                            wpIssueData.AlcsInvestigationLevel = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Alcs_Investigation_Level__c = field;
                        }
                        
                        if(fieldValue == 'MANFINVESTIGATIONLEVEL'){
                            wpIssueData.ManfInvestigationLevel = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Manf_Investigation_Level__c = field;
                        }
                                                
                        if(fieldValue == 'THRESHOLDWITHMANFINFO'){
                            wpIssueData.ThresholdWithManfInfo = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Threshold_With_Manf_Info__c = field;
                        }
                            
                        if(fieldValue == 'THRESHOLDWITHPRODDESCONLY'){
                            wpIssueData.ThresholdWithProdDescOnly = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Threshold_With_Prod_Desc_Only__c = field;
                        }
                        
                        if(fieldValue == 'SURVEYREQUIREMENTS'){
                            wpIssueData.SurveyRequirements = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Survey_Requirements__c = field;
                        }
                                                
                        if(fieldValue == 'DISPLAYFLAG'){
                            wpIssueData.DisplayFlag = field;
                        }  
                        
                        if(fieldValue == 'ACTIVEFLAG'){
                            wpIssueData.ActiveFlag = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Active__c = (field == 'Y'?true:false);
                        }
                        
                        if(fieldValue == 'ESCALATEFLAG'){
                            wpIssueData.EscalateFlag = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Escalate_Flag__c = (field == '1'?true:false);
                        }
                        
                        if(fieldValue == 'FACTORYCONTROLLABLEFLAG'){
                            wpIssueData.FactoryControllableFlag = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Factory_Controllable_Flag__c = (field == '1'?true:false);
                        }
                        
                        if(fieldValue == 'SELECT'){
                            wpIssueData.SelectVal = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Select__c = (field == 'Y'?true:false);
                        }
                        
                        if(fieldValue == 'VISIBLE'){
                            wpIssueData.Visible = field;
                            if(typeOfOperation != RequestType)
                                wpIssueData.IssueHierarchyObj.Visible__c = (field == 'Y'?true:false);
                        }   
                    }
                }
                
                if(wpIssueData.Requested != null && wpIssueData.Requested != ''){
                    if(wpIssueData.Requested.toUpperCase() == 'INACTIVATE'){
                        deactiveRecords.add(wpIssueData);
                        if(wpIssueData.Name == null || wpIssueData.Name.trim() == ''){
                            missingData = true;
                            wpIssueData.MissingDataError = true;
                        }else{
                            String duplicateString = wpIssueData.Name.trim();
                            if(!duplicateNameMap.containskey(duplicateString)){
                                List<Integer> row = new List<Integer>();
                                row.add(wpIssueData.rowNumber);
                                duplicateNameMap.put(duplicateString,row); 
                            }else{
                                List<Integer> rowData  = duplicateNameMap.get(duplicateString);
                                rowData.add(wpIssueData.rowNumber); 
                                duplicateNameMap.remove(duplicateString);
                                duplicateNameMap.put(duplicateString,rowData);                            
                            }
                        }
                    }else{
                        if(wpIssueData.Classification !=  null && wpIssueData.Classification != '' && wpIssueData.ProductLine != null && wpIssueData.ProductLine != '' && wpIssueData.IssueType != null && wpIssueData.IssueType != '' 
                            && wpIssueData.GroupVal != null && wpIssueData.GroupVal != '' && wpIssueData.Reason != null && wpIssueData.Reason != '' && wpIssueData.Cause != null && wpIssueData.Cause != ''){
                            String duplicateString = wpIssueData.Classification + wpIssueData.ProductLine + wpIssueData.IssueType + wpIssueData.GroupVal + wpIssueData.Reason + wpIssueData.Cause;
                            
                            if(!duplicateMap.containskey(duplicateString)){
                                List<Integer> row = new List<Integer>();
                                row.add(wpIssueData.rowNumber);
                                duplicateMap.put(duplicateString,row); 
                            }else{
                                List<Integer> rowData  = duplicateMap.get(duplicateString);
                                rowData.add(wpIssueData.rowNumber); 
                                duplicateMap.remove(duplicateString);
                                duplicateMap.put(duplicateString,rowData);                            
                            }
                        }else{
                            missingData = true;
                            wpIssueData.MissingDataError = true;
                        }
                        wpIssueData.IssueHierarchyObj.Cust_Cons_Flag__c = 'ALL';
                        newRecords.add(wpIssueData); 
                    }
                }                           
            }
            Map<String,Classification__c> mapClassification = new  Map<String,Classification__c>();
            Map<String,Product_Line__c> mapProductLine = new  Map<String,Product_Line__c>();
            Map<String,Issue_Type__c> mapIssueType = new  Map<String,Issue_Type__c>();
            Map<String,Group__c> mapGroup = new  Map<String,Group__c>();
            Map<String,Reason__c> mapReason = new  Map<String,Reason__c>();
            Map<String,Cause__c> mapCause = new  Map<String,Cause__c>();
            Map<String,Issue_Hierarchy__c> mapIssue = new  Map<String,Issue_Hierarchy__c>();
            Set<String> issueHierSet = new Set<String>();
            
            if(!duplicateMap.isEmpty()){
               List<Issue_Hierarchy__c> issueHierData = new List<Issue_Hierarchy__c>([Select id, Duplicate_Issue_Hierarchy__c from Issue_Hierarchy__c where Active__c = true and Duplicate_Issue_Hierarchy__c in :duplicateMap.KeySet()]);                                  
                
                if(!issueHierData.isEmpty()){
                    for(Issue_Hierarchy__c cl : issueHierData){
                        issueHierSet.add(cl.Duplicate_Issue_Hierarchy__c);
                    }
                }  
            }
            
            if(!issueHierarchySet.isEmpty()){
                List<Issue_Hierarchy__c> issueHierData = new List<Issue_Hierarchy__c>([Select id, Name from Issue_Hierarchy__c where Active__c = true and Name in :issueHierarchySet]);
                if(!issueHierData.isEmpty()){
                    for(Issue_Hierarchy__c cl : issueHierData){
                        mapIssue.put(cl.Name, cl);
                    }
                } 
                System.debug('test mapIssue '+mapIssue);                   
            }
            
            if(!ClassificationSet.isEmpty()){
                List<Classification__c> classData = new List<Classification__c>([Select id,Name,Description__c 
                                                                                from Classification__c 
                                                                                where Description__c in :ClassificationSet]);
                if(!classData.isEmpty()){
                    for(Classification__c cl : classData){
                        mapClassification.put(cl.Description__c, cl);
                    }
                }
            }
            if(!ProductLineSet.isEmpty()){
                List<Product_Line__c> plData = new List<Product_Line__c>([Select id,Name 
                                                                                from Product_Line__c 
                                                                                where Name in :ProductLineSet]);
                if(!plData.isEmpty()){
                    for(Product_Line__c cl : plData){
                        mapProductLine.put(cl.Name, cl);
                    }
                }            
            }
            if(!IssueTypeSet.isEmpty()){
                List<Issue_Type__c> issueTypeData = new List<Issue_Type__c>([Select id,Name,Description__c 
                                                                                from Issue_Type__c 
                                                                                where Description__c in :IssueTypeSet]);
                if(!issueTypeData.isEmpty()){
                    for(Issue_Type__c cl : issueTypeData){
                        mapIssueType.put(cl.Description__c, cl);
                    }
                }
            
            }
            if(!GroupSet.isEmpty()){
                List<Group__c> groupData = new List<Group__c>([Select id,Name,Description__c 
                                                                from Group__c 
                                                                where Description__c in :GroupSet]);
                if(!groupData.isEmpty()){
                    for(Group__c cl : groupData){
                        mapGroup.put(cl.Description__c, cl);
                    }
                }
            
            }
            if(!ReasonSet.isEmpty()){
                List<Reason__c> reasonData = new List<Reason__c>([Select id,Name,Description__c 
                                                                    from Reason__c 
                                                                    where Description__c in :ReasonSet]);
                if(!reasonData.isEmpty()){
                    for(Reason__c cl : reasonData){
                        mapReason.put(cl.Description__c, cl);
                    }
                }
            
            }
            if(!CauseSet.isEmpty()){
                List<Cause__c> causeData = new List<Cause__c>([Select id,Name,Description__c 
                                                                                from Cause__c 
                                                                                where Description__c in :CauseSet]);
                if(!causeData.isEmpty()){
                    for(Cause__c cl : causeData){
                        mapCause.put(cl.Description__c, cl);
                    }
                }            
            } 
            classDataList = new List<Classification__c>();
            causeDataList = new List<Cause__c>();
            reasonDataList = new List<Reason__c>();
            groupDataList = new List<Group__c>();
            issueTypeDataList = new List<Issue_Type__c>();
            
            
            if(!newRecords.isEmpty()){                
                for(wrapperIssueHierarchy nw :newRecords){
                    
                    String duplicateString = nw.Classification + nw.ProductLine + nw.IssueType + nw.GroupVal + nw.Reason + nw.Cause;
                    if(!issueHierSet.isEmpty() && issueHierSet.Contains(duplicateString)) {
                        nw.dupliacteErrorData = true; 
                        dupliacteErrorData = true;                    
                    }
                    
                    if(duplicateMap.containsKey(duplicateString)){
                        List<Integer> rowData  = duplicateMap.get(duplicateString);
                        if(rowData.size() >1){
                            nw.dupliacteErrorFile = true; 
                            dupliacteErrorFile = true;
                        }
                    }
                    if(nw.Classification != null && nw.Classification != ''){       
                        if(mapClassification.ContainsKey(nw.Classification)){
                            nw.IssueHierarchyObj.Classification__c = mapClassification.get(nw.Classification).id;
                            nw.ClassificationError = false;
                        }else{
                            nw.ClassificationError = true;
                            classDataList.add(new Classification__c(Description__c = nw.Classification));
                        }
                    }
                    if(nw.ProductLine != null && nw.ProductLine != ''){
                        if(mapProductLine.ContainsKey(nw.ProductLine)){
                            nw.IssueHierarchyObj.Product_Line__c = mapProductLine.get(nw.ProductLine).id;
                            nw.ProductLineError = false;
                        }else{
                            nw.ProductLineError = true;
                            errordata = true;
                        }
                    }
                    if(nw.IssueType != null && nw.IssueType != ''){
                        if(mapIssueType.ContainsKey(nw.IssueType)){
                            nw.IssueHierarchyObj.Issue_Type__c = mapIssueType.get(nw.IssueType).id;
                            nw.IssueTypeError = false;
                        }else{
                            nw.IssueTypeError = true;
                            issueTypeDataList.add(new Issue_Type__c(Description__c = nw.IssueType));
                        }
                    }
                    if(nw.GroupVal != null && nw.GroupVal != ''){
                        if(mapGroup.ContainsKey(nw.GroupVal)){
                            nw.IssueHierarchyObj.Group__c = mapGroup.get(nw.GroupVal).id;
                            nw.GroupError = false;
                        }else{
                            nw.GroupError = true;
                            GroupDataList.add(new Group__c(Description__c = nw.GroupVal));
                        }
                    }
                    if(nw.Reason != null && nw.Reason != ''){
                        if(mapReason.ContainsKey(nw.Reason)){
                            nw.IssueHierarchyObj.Reason__c = mapReason.get(nw.Reason).id;
                            nw.ReasonError = false;
                        }else{
                            nw.ReasonError = true;
                            ReasonDataList.add(new Reason__c(Description__c = nw.Reason));
                        }
                    }
                    if(nw.Cause != null && nw.Cause != ''){
                        if(mapCause.ContainsKey(nw.Cause)){
                            nw.IssueHierarchyObj.Cause__c = mapCause.get(nw.Cause).id;
                            nw.CauseError = false;
                        }else{
                            nw.CauseError = true;
                            CauseDataList.add(new Cause__c(Description__c = nw.Cause));
                        }
                    }                    
                }
                
            } 
            
            if(!deactiveRecords.isEmpty()){                
                for(wrapperIssueHierarchy nw :deactiveRecords){
                    if(nw.Name != null && nw.Name != ''){
                        string duplicateString = nw.Name.trim();
                         if(duplicateNameMap.containsKey(duplicateString)){
                            List<Integer> rowData  = duplicateNameMap.get(duplicateString);
                            if(rowData.size() >1){
                                nw.dupliacteErrorFile = true; 
                                dupliacteErrorFile = true;
                            }
                        }
                        
                        if(mapIssue.ContainsKey(nw.Name)){
                            nw.IssueHierarchyObj.id = mapIssue.get(nw.Name).id;
                            nw.IssueHierarchyObj.Active__c = false;
                            nw.NameError = false;
                        }else{
                            nw.NameError = true;
                            errordata = true;
                        }
                    }
                }
            }
            if(missingData || errordata || dupliacteErrorFile || dupliacteErrorData){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Error in file'));
                if(missingData)
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Missing data in the file maked as a red'));
                if(dupliacteErrorFile)
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Duplicate data found in the file marked as a yellow'));
                if(dupliacteErrorData)
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Duplicate data found in the database marked as a blue'));    
                if(errordata)
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Data not found in the database maked as a red'));
                    
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please verify data before uploading'));
                
                errordata = true;
            }
                        
        }catch(Exception e){
             ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getLineNumber());
            ApexPages.addMessage(errormsg);
         } 
        return null;
    }
    
    public Pagereference issueHierarchyChange(){
        try{
            List<Issue_Hierarchy__c> deActiveHierarchy = new List<Issue_Hierarchy__c>();
            List<Issue_Hierarchy__c> CreateHierarchy = new List<Issue_Hierarchy__c>();
           
            Map<String,Classification__c> mapClassification = new  Map<String,Classification__c>();
            Map<String,Product_Line__c> mapProductLine = new  Map<String,Product_Line__c>();
            Map<String,Issue_Type__c> mapIssueType = new  Map<String,Issue_Type__c>();
            Map<String,Group__c> mapGroup = new  Map<String,Group__c>();
            Map<String,Reason__c> mapReason = new  Map<String,Reason__c>();
            Map<String,Cause__c> mapCause = new  Map<String,Cause__c>();
            Map<String,Issue_Hierarchy__c> mapIssue = new  Map<String,Issue_Hierarchy__c>();
            
            
            if(!classDataList.isEmpty()){
                insert classDataList;
                List<Classification__c> classData = new List<Classification__c>([Select id,Name,Description__c 
                                                                                from Classification__c 
                                                                                where id in : classDataList]);
                if(!classData.isEmpty()){
                    for(Classification__c cl : classData){
                        mapClassification.put(cl.Description__c, cl);
                    }
                }
            }
            
            
            if(!issueTypeDataList.isEmpty()){
                insert issueTypeDataList;
                List<Issue_Type__c> issueTypeData = new List<Issue_Type__c>([Select id,Name,Description__c 
                                                                                from Issue_Type__c 
                                                                                where id in :issueTypeDataList]);
                if(!issueTypeData.isEmpty()){
                    for(Issue_Type__c cl : issueTypeData){
                        mapIssueType.put(cl.Description__c, cl);
                    }
                }
            
            }
            if(!groupDataList.isEmpty()){
                insert groupDataList;
                List<Group__c> groupData = new List<Group__c>([Select id,Name,Description__c 
                                                                from Group__c 
                                                                where id in :groupDataList]);
                if(!groupData.isEmpty()){
                    for(Group__c cl : groupData){
                        mapGroup.put(cl.Description__c, cl);
                    }
                }
            
            }
            if(!reasonDataList.isEmpty()){
                insert  reasonDataList;
                List<Reason__c> reasonData = new List<Reason__c>([Select id,Name,Description__c 
                                                                    from Reason__c 
                                                                    where Id in :reasonDataList]);
                if(!reasonData.isEmpty()){
                    for(Reason__c cl : reasonData){
                        mapReason.put(cl.Description__c, cl);
                    }
                }
            
            }
            if(!causeDataList.isEmpty()){
                insert causeDataList;
                List<Cause__c> causeData = new List<Cause__c>([Select id,Name,Description__c 
                                                                                from Cause__c 
                                                                                where id in :causeDataList]);
                if(!causeData.isEmpty()){
                    for(Cause__c cl : causeData){
                        mapCause.put(cl.Description__c, cl);
                    }
                }            
            }         
            
            if(!newRecords.isEmpty()){
                
                for(wrapperIssueHierarchy nw :newRecords){
                    if(nw.ClassificationError){
                        nw.IssueHierarchyObj.Classification__c = mapClassification.get(nw.Classification).id;                    
                    }                
                    
                    if(nw.IssueTypeError){
                        nw.IssueHierarchyObj.Issue_Type__c = mapIssueType.get(nw.IssueType).id;
                    }
                    
                    if(nw.GroupError){
                        nw.IssueHierarchyObj.Group__c = mapGroup.get(nw.GroupVal).id;
                    }
                    
                    if(nw.ReasonError){
                        nw.IssueHierarchyObj.Reason__c = mapReason.get(nw.Reason).id;
                    }
                    
                    if(nw.CauseError){
                        nw.IssueHierarchyObj.Cause__c = mapCause.get(nw.Cause).id;
                    }
                    
                    CreateHierarchy.add(nw.IssueHierarchyObj);
                }
                
                if(!CreateHierarchy.isEmpty()){
                    insert CreateHierarchy;
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Info, 'Issue Hierarchy successfully created'));
                }
            }        
            
            if(!deactiveRecords.isEmpty()){
                for(wrapperIssueHierarchy nw :deactiveRecords){
                    if(nw.IssueHierarchyObj.id != null)
                        deActiveHierarchy.add(nw.IssueHierarchyObj);
                }
                
                if(!deActiveHierarchy.isEmpty()){
                    update deActiveHierarchy;
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Info, 'Issue Hierarchy successfully inactivate'));
                }                
            }
            newRecords = new List<wrapperIssueHierarchy>();
            deactiveRecords = new List<wrapperIssueHierarchy>();
            classDataList = new List<Classification__c>();
            causeDataList = new List<Cause__c>();
            reasonDataList = new List<Reason__c>();
            groupDataList = new List<Group__c>();
            issueTypeDataList = new List<Issue_Type__c>();
            errordata = false;
            
        }catch(Exception e){
             ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Error, Please try again!!');
         } 
        return null;
    }
    
    public class wrapperIssueHierarchy{
        public Integer rowNumber {get;set;}
        public string Name {get;set;}
        public boolean dupliacteErrorFile {get;set;}
        public boolean dupliacteErrorData {get;set;}
        public boolean MissingDataError {get;set;}
        public boolean NameError  {get;set;}
        public boolean ClassificationError {get;set;}
        public boolean ProductLineError {get;set;}
        public boolean IssueTypeError {get;set;}
        public boolean GroupError {get;set;}
        public boolean ReasonError {get;set;}
        public boolean CauseError {get;set;}
        public string Requested {get;set;}  
        public string Classification {get;set;}  
        public string ProductLine {get;set;}    
        public string CauseID {get;set;}    
        public string IssueType {get;set;}  
        public string GroupVal {get;set;}   
        public string Reason {get;set;}  
        public string Cause {get;set;}   
        public string RptCategory {get;set;} 
        public string ActiveFlag {get;set;}  
        public string EscalateFlag {get;set;}    
        public string IssueAssociation {get;set;}   
        public string Rollup {get;set;}  
        public string FactoryControllableFlag {get;set;} 
        public string PqrbRtpCategory {get;set;}
        public string Visible {get;set;} 
        public string SelectVal {get;set;}  
        public string ProductReturnLevel {get;set;}  
        public string AlertDistribution {get;set;}   
        public string AlcsInvestigationLevel {get;set;}  
        public string ManfInvestigationLevel {get;set;}  
        public string ThresholdWithManfInfo {get;set;}   
        public string ThresholdWithProdDescOnly {get;set;}   
        public string SurveyRequirements {get;set;}  
        public string DisplayFlag {get;set;}  
        public Issue_Hierarchy__c IssueHierarchyObj {get;set;}         
        
    }         
}