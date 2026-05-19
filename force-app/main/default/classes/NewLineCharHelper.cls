/* Created By: Infogain Pvt. Ltd.
Created Date: 11/11/2016
Purpose: New line character helper class. To replace the new line characters from all the text fields
*/
public class NewLineCharHelper{
    
    private static final Date CUTOVER_DATE = Date.newInstance(2026, 1, 1);
    public boolean skipTrigger = false;
    set<id> caseId=new set<id>();
    // Old method kept for backward compatibility
public void newlineCase(List<Case> caseUpdate) {
    newlineCase(caseUpdate, true, false, null);
}
    //method to update the text fields for feeds.
    public void newlineCase(List<Case> caseUpdate, Boolean isInsert, Boolean isUpdate, Map<Id, Case> oldMap) {
        
        for(case caseObj: caseUpdate){
            Integer i = 1;
            system.debug('control in 1st char');
            if(caseObj.Mfg_Trace_code__c != '' && caseObj.Mfg_Trace_code__c != null){
                system.debug('Size of trace code'+caseObj.Mfg_Trace_code__c.length());
                if(caseObj.Mfg_Trace_code__c.length() == 1 && i <= 1){
                    Helix1CharcterCode(caseUpdate);
                    system.debug('control in 1st char');
                    i++;
                }
            }
            
        }
        Helix6CharcterCode(caseUpdate);
        //Helix9CharcterCode(caseUpdate);
        //new changes as per RITM3562938 and RITM3595316
        Helix9CharcterCode(caseUpdate, isInsert, isUpdate, oldMap);
        usstc9CharacterTraceCode(caseUpdate);
        enjoyTraceCode(CaseUpdate);
        thirdPartyManufacture(caseUpdate);
        for(case caseObj:caseUpdate){
            caseId.add(caseObj.id);
            if(caseObj.Comment__c !=null){
                caseObj.CommentFeed__c = caseObj.Comment__c;
                caseObj.CommentFeed__c = caseObj.CommentFeed__c.replaceAll('\r\n', ' ');
                caseObj.CommentFeed__c = caseObj.CommentFeed__c.replaceAll('\n', ' ');
                caseObj.CommentFeed__c = caseObj.CommentFeed__c.replaceAll('\r', ' ');
                caseObj.CommentFeed__c = caseObj.CommentFeed__c.replaceAll(',', '`');
            }else{
                caseObj.CommentFeed__c = '';
            }
            
            if(caseObj.Update_Reason__c !=null){
                caseObj.UpdateReasonFeed__c=caseObj.Update_Reason__c;
                caseObj.UpdateReasonFeed__c=caseObj.UpdateReasonFeed__c.replaceAll('\r\n', ' ');
                caseObj.UpdateReasonFeed__c= caseObj.UpdateReasonFeed__c.replaceAll('\n', ' ');
                caseObj.UpdateReasonFeed__c= caseObj.UpdateReasonFeed__c.replaceAll('\r', ' ');
                caseObj.UpdateReasonFeed__c= caseObj.UpdateReasonFeed__c.replaceAll(',', '`');
            }else{
                caseObj.UpdateReasonFeed__c= '';
            }
            
        }
    }
    //method to update the text fields for feeds.
    public void newlineAnswer(list<Answer__c> answerUpdate){
        for(Answer__c ansObj:answerUpdate){
            
            if(ansObj.Answer__c!=NULL){
                ansObj.AnswerFeed__c = ansObj.Answer__c;
                ansObj.AnswerFeed__c=ansObj.AnswerFeed__c.replaceAll('\r\n', ' '); 
                ansObj.AnswerFeed__c= ansObj.AnswerFeed__c.replaceAll('\n', ' ');
                ansObj.AnswerFeed__c= ansObj.AnswerFeed__c.replaceAll('\r', ' ');
                ansObj.AnswerFeed__c= ansObj.AnswerFeed__c.replaceAll(',', '`');   
            }else{
                ansObj.AnswerFeed__c = '';
            }
        }
    } 
    //method to update the text fields for feeds.
    public void newlineAttDetail(list<Attachment_Detail__c> attdetailUpdate){
        for(Attachment_Detail__c attDetailObj:attdetailUpdate){
            if(attDetailObj.Description__c !=NULL){
                attDetailObj.DescriptionFeed__c= attDetailObj.Description__c;
                attDetailObj.DescriptionFeed__c= attDetailObj.DescriptionFeed__c.replaceAll('\r\n', ' ');    
                attDetailObj.DescriptionFeed__c= attDetailObj.DescriptionFeed__c.replaceAll('\n', ' ');
                attDetailObj.DescriptionFeed__c= attDetailObj.DescriptionFeed__c.replaceAll('\r', ' ');
                attDetailObj.DescriptionFeed__c= attDetailObj.DescriptionFeed__c.replaceAll(',', '`');   
            }else{
                attDetailObj.DescriptionFeed__c = '';
            }
        }
    } 
    //method to update the text fields for feeds.
    public void newlineBrandHier(list<Brand_Hierarchy__c> brandhierUpdate){
        for(Brand_Hierarchy__c brandHierObj:brandhierUpdate){
            if(brandHierObj.Price_Category__c !=null){
                brandHierObj.PriceCategoryFeed__c = brandHierObj.Price_Category__c;
                brandHierObj.PriceCategoryFeed__c= brandHierObj.PriceCategoryFeed__c.replaceAll('\r\n', ' ');
                brandHierObj.PriceCategoryFeed__c= brandHierObj.PriceCategoryFeed__c.replaceAll('\n', ' ');
                brandHierObj.PriceCategoryFeed__c= brandHierObj.PriceCategoryFeed__c.replaceAll('\r', ' ');
                brandHierObj.PriceCategoryFeed__c= brandHierObj.PriceCategoryFeed__c.replaceAll(',', '`'); 
            }else{
                brandHierObj.PriceCategoryFeed__c = ''; 
            }
            
            if(brandHierObj.Product_Desc__c !=null){
                brandHierObj.ProductDescFeed__c=brandHierObj.Product_Desc__c;
                brandHierObj.ProductDescFeed__c=brandHierObj.ProductDescFeed__c.replaceAll('\r\n', ' ');
                brandHierObj.ProductDescFeed__c= brandHierObj.ProductDescFeed__c.replaceAll('\n', ' ');
                brandHierObj.ProductDescFeed__c= brandHierObj.ProductDescFeed__c.replaceAll('\r', ' ');
                brandHierObj.ProductDescFeed__c= brandHierObj.ProductDescFeed__c.replaceAll(',', '`'); 
            }else{
                brandHierObj.ProductDescFeed__c = '';
            }
            
            if(brandHierObj.Product_Type__c !=null){
                brandHierObj.ProductTypeFeed__c=brandHierObj.Product_Type__c;
                brandHierObj.ProductTypeFeed__c=brandHierObj.ProductTypeFeed__c.replaceAll('\r\n', ' ');
                brandHierObj.ProductTypeFeed__c= brandHierObj.ProductTypeFeed__c.replaceAll('\n', ' ');
                brandHierObj.ProductTypeFeed__c= brandHierObj.ProductTypeFeed__c.replaceAll('\r', ' ');
                brandHierObj.ProductTypeFeed__c= brandHierObj.ProductTypeFeed__c.replaceAll(',', '`'); 
            }else{
                brandHierObj.ProductTypeFeed__c = '';
            }
        }
    }
    //method to update the text fields for feeds.
    public void newlineQuestion(list<Question__c> questionUpdate){
        for(Question__c questionObj:questionUpdate){
            
            if(questionObj.Question__c !=null){
                questionObj.QuestionFeed__c = questionObj.Question__c;
                questionObj.QuestionFeed__c= questionObj.QuestionFeed__c.replaceAll('\r\n', ' ');
                questionObj.QuestionFeed__c= questionObj.QuestionFeed__c.replaceAll('\n', ' ');
                questionObj.QuestionFeed__c= questionObj.QuestionFeed__c.replaceAll('\r', ' ');
                questionObj.QuestionFeed__c= questionObj.QuestionFeed__c.replaceAll(',', '`'); 
            }else{
                questionObj.QuestionFeed__c = '';
            }
        }
    }
    //method to update the text fields for feeds.
    public void newlineStore(list<Store__c> storeUpdate){
        for(Store__c storeObj:storeUpdate){
            
            if(storeObj.Store_Comment__c != null){
                storeObj.StoreCommentFeed__c = storeObj.Store_Comment__c;
                storeObj.StoreCommentFeed__c= storeObj.StoreCommentFeed__c.replaceAll('\r\n', ' ');
                storeObj.StoreCommentFeed__c= storeObj.StoreCommentFeed__c.replaceAll('\n', ' ');
                storeObj.StoreCommentFeed__c= storeObj.StoreCommentFeed__c.replaceAll('\r', ' ');
                storeObj.StoreCommentFeed__c= storeObj.StoreCommentFeed__c.replaceAll(',', '`');
            }else{
                storeObj.StoreCommentFeed__c = '';
            }
        }
    }
    //method to update the text fields for feeds.
    public void newlineSurveyIssue(list<Survey_Issue__c> surveyIssueUpdate){
        for(Survey_Issue__c surveyIssueObj:surveyIssueUpdate){
            if(surveyIssueObj.Issue__r.ExtractFromFeed__c == true){
                surveyIssueObj.isReviewed__c = true;
            }
            
            if(surveyIssueObj.Comment__c != null){
                surveyIssueObj.CommentFeed__c = surveyIssueObj.Comment__c;
                surveyIssueObj.CommentFeed__c=surveyIssueObj.CommentFeed__c.replaceAll('\r\n', ' ');
                surveyIssueObj.CommentFeed__c= surveyIssueObj.CommentFeed__c.replaceAll('\n', ' ');
                surveyIssueObj.CommentFeed__c= surveyIssueObj.CommentFeed__c.replaceAll('\r', ' ');
                surveyIssueObj.CommentFeed__c= surveyIssueObj.CommentFeed__c.replaceAll(',', '`');
            }else{
                surveyIssueObj.CommentFeed__c = '';
            }
        }
    }
    /**
* Method Name: updateIsReviewed
* Description: This method use update isReviewed to true when an survey added on the issue and when the issue ExtractFromFeed is true.
* @authoor: Gian Carlo Cutchon
* createdDate: 11/9/2017
**/
    public void updateIsReviewed(list<Survey_Issue__c> surveyIssueUpdate){
        list<Survey_Issue__c> surveyIssueToUpdate = new list<Survey_Issue__c>();
        Set<Id> issueIds = new Set<Id>();
        list<Case> caseList = new list<Case>();
        for(Survey_Issue__c surveyIssueObj:surveyIssueUpdate){
            if(surveyIssueObj.Issue__c != null){
                issueIds.add(surveyIssueObj.Issue__c);
            }
        }
        if(issueIds.size() > 0){
            caseList = [Select Id, ExtractFromFeed__c from Case where id in: issueIds];
        }
        if(caseList.size() > 0){
            for(Case c:caseList ){
                if(c.ExtractFromFeed__c == true){
                    for(Survey_Issue__c surveyIssueObj:surveyIssueUpdate){
                        if(surveyIssueObj.Issue__c == c.Id){
                            surveyIssueObj.isReviewed__c = true;
                        }
                    }
                }
            }
        }
    }
    
    /**
* Method Name: Helix6CharcterCode
* Description: This Method check 6 charcter Helix code If it is valid trace code then it will update product Location as 'SWEDEN', factory as 'Helsingborg', Production Date,
* 3rd position 6th digits of the trace code will be shifts, and set ValidTracecode value is true.
* If trace code is not valid then it will update on 3 field which is proudct location as 'SWEDEN', factory as 'Helsingborg' and validTraceCode value as False.
* @authoor: Dharmendra Yadav
* createdDate: 10/30/2023
**/
    
    public void Helix6CharcterCode(List<case> caseValue){
        
        Map<string,string> firstDigit = new Map<string,string>{
            'W' => '2019',
                'X' => '2020',
                'Y' => '2021',
                'Z' => '2022',
                'A' => '2023',
                'B' => '2024',
                'C' => '2025',
                'D' => '2026',
                'E' => '2027',
                'F' => '2028',
                'G' => '2029',
                'H' => '2030'
                };
                    
                    Map<string,String> secondDigit = new Map<string,string>{
                        'A' => '01',
                            'B' => '02',
                            'C' => '03',
                            'D' => '04',
                            'E' => '05',
                            'F' => '06',
                            'G' => '07',
                            'H' => '08',
                            'I' => '09',
                            'K' => '10',
                            'L' => '11',
                            'M' => '12'
                            };
                                
                                for(case caseObj:caseValue){
                                    System.debug('ProductCode__c: ' + caseObj.ProductCode__c);
                                    System.debug('Product_Line__c: ' + caseObj.Product_Line__c);
                                    System.debug('PLCode__c: ' + caseObj.PLCode__c);
                                    System.debug('Trace_Code_Location__c: ' + caseObj.Trace_Code_Location__c);
                                    If(caseObj.Mfg_Trace_code__c != null){
                                        if( (caseObj.Mfg_Trace_code__c).length() == 6  &&   caseObj.Product_Line__c == 'Tobacco Derived Nicotine pouch' && caseObj.PLCode__c == 'TDNP' && 
                                           (caseObj.Trace_Code_Location__c == 'Can' || caseObj.Trace_Code_Location__c == 'Carton' )){
                                               
                                               boolean validOrNot = true;
                                               string Month;
                                               string Year;
                                               String productCode = caseObj.Mfg_Trace_code__c;
                                               
                                               if(firstDigit.containsKey(productCode.substring(0, 1))){
                                                   Year = firstDigit.get(productCode.substring(0, 1));
                                                   system.debug('Year Value' + Year);
                                               }
                                               else{
                                                   validOrNot= false;
                                               }
                                               
                                               if(secondDigit.containsKey(productCode.substring(1, 2))){
                                                   Month = secondDigit.get(productCode.substring(1, 2));
                                                   system.debug('Month' + Month);
                                               }
                                               else{
                                                   validOrNot = false;
                                               } 
                                               string DateValue = Month +'/01/' +Year ;
                                               system.debug('Valid or Not '+ validOrNot);
                                               String numericSubstring = productCode.substring(2, 6);
                                               
                                               system.debug('Date is '+DateValue);
                                               if(validOrNot && Date.today() >= Date.parse(DateValue) && numericSubstring.isNumeric()) {
                                                   caseObj.DateCodeLocation__c = 'SWEDEN';
                                                   caseObj.DateCodeRptFactory__c = 'Helsingborg';
                                                   caseObj.Production_date__c = Date.parse(DateValue);
                                                   caseObj.DateCodeShift__c = productCode.substring(2, 6);
                                                   caseObj.ValidTraceCode__c = True;  
                                               }
                                               else{
                                                   caseObj.DateCodeLocation__c = 'SWEDEN';
                                                   caseObj.DateCodeRptFactory__c = 'Helsingborg';
                                                   caseObj.ValidTraceCode__c = False;  
                                               }
                                           }
                                    }
                                    
                                }
    }
    
    public void Helix9CharcterCode(List<Case> caseValue, Boolean isInsert, Boolean isUpdate, Map<Id, Case> oldMap) {
        
        // New mapping (Insert OR Update created >= 01/01/2026)
        Map<String, String> newLineMap = new Map<String, String>{
            'A' => 'USSTC Ric – Line A',
                'B' => 'USSTC Ric – Line B',
                'C' => 'USSTC Ric – Line C',
                'D' => 'USSTC Ric – Line D',
                'E' => 'USSTC Ric – Line E',
                'F' => 'USSTC Ric – Line F',
                'H' => 'USSTC Ric – Line H',
                'U' => 'Bay 9 – Line#1',
                'J' => 'Bay 9 – Line#2',
                'N' => 'Bay 9 – Line#3',
                'P' => 'Bay 9 – Line#4'
                };
                    
                    // Legacy mapping (Update created < 01/01/2026)
                    Map<String, String> legacyLineMap = new Map<String, String>{
                        'U' => 'Bay 9 – Line#1',
                            'J' => 'Bay 9 – Line#2',
                            'N' => 'Bay 9 – Line#3',
                            'P' => 'Bay 9 – Line#4',
                            'E' => 'Bay 9 – Line#5',
                            'F' => 'Bay 9 – Line#6',
                            'H' => 'USSTC Ric – Line H'
                            };
                                
                                for(case caseObj:caseValue){
                                    System.debug('ProductCode__c: ' + caseObj.ProductCode__c);
                                    System.debug('Product_Line__c: ' + caseObj.Product_Line__c);
                                    System.debug('PLCode__c: ' + caseObj.PLCode__c);
                                    System.debug('Trace_Code_Location__c: ' + caseObj.Trace_Code_Location__c);
                                    If(caseObj.Mfg_Trace_code__c != null){
                                        if( (caseObj.Mfg_Trace_code__c).length() == 9  &&   caseObj.Product_Line__c == 'Tobacco Derived Nicotine pouch' && caseObj.PLCode__c == 'TDNP' && 
                                           (caseObj.Trace_Code_Location__c == 'Can' || caseObj.Trace_Code_Location__c == 'Carton' ) ){
                                               
                                               Integer final_year = 0;
                                               Date dateToProcess = System.today();
                                               Date final_date;
                                               string productionDate;
                                               string prodYear = caseObj.Mfg_Trace_code__c.substring(0,1);
                                               string prodDayAndMonth = caseObj.Mfg_Trace_code__c.substring(1,4);
                                               Map<String, Integer> yearMapping = new Map<String, Integer>{
                                                   'R' => 2021, 'C' => 2022, 'M' => 2023, 'D' => 2024,
                                                       '5' => 2025, '6' => 2026, '7' => 2027, '8' => 2028, '9' => 2029,
                                                       '0' => 2030, '1' => 2031, '2' => 2032, '3' => 2033, '4' => 2034
                                                       };
                                                           
                                                           if (yearMapping.containsKey(prodYear)) {
                                                               final_year = yearMapping.get(prodYear);
                                                           }
                                               
                                               final_date = date.newInstance(final_year,1,1);
                                               final_date = final_date.addDays(Integer.valueOf(prodDayAndMonth)-1);
                                               system.debug('Final Date '+final_date);
                                               
                                               Boolean useLegacy = false;
                                               if (isUpdate) {
                                                   if (oldMap != null && oldMap.containsKey(caseObj.Id) && oldMap.get(caseObj.Id).CreatedDate != null) {
                                                       Date createdDateOnly = oldMap.get(caseObj.Id).CreatedDate.date();
                                                       if (createdDateOnly < CUTOVER_DATE) {
                                                           useLegacy = true;
                                                       }
                                                   }
                                               }
                                               
                                               Map<String, String> chosenMap = useLegacy ? legacyLineMap : newLineMap;
                                               
                                               if (chosenMap.containsKey(caseObj.Mfg_Trace_code__c.substring(4, 5))) {
                                                   caseObj.Line__c = chosenMap.get(caseObj.Mfg_Trace_code__c.substring(4, 5));
                                                   caseObj.DateCodeUnit__c = caseObj.Mfg_Trace_code__c.substring(4, 5);
                                               } else {
                                                   caseObj.Line__c = '';
                                                   caseObj.DateCodeUnit__c = '';
                                                   caseObj.Production_date__c = null;
                                                   caseObj.DateCodeMilitaryTime__c = '';
                                                   caseObj.DateCodeShift__c = '';
                                               }
                                               
                                           }
                                        //SCR 2025-11-03: Helix ON 10 Character Codes
                                        if( (caseObj.Mfg_Trace_code__c).length() == 10  &&   caseObj.Product_Line__c == 'Tobacco Derived Nicotine pouch' && caseObj.PLCode__c == 'TDNP' &&
                                           (caseObj.Trace_Code_Location__c == 'Can' || caseObj.Trace_Code_Location__c == 'Carton' ) ){
                                               
                                               Integer final_year = 0;
                                               Date dateToProcess = System.today();
                                               Date final_date;
                                               string productionDate;
                                               string prodYear = caseObj.Mfg_Trace_code__c.substring(0,1); //5
                                               string prodDayAndMonth = caseObj.Mfg_Trace_code__c.substring(1,4);//370
                                               string module = caseObj.Mfg_Trace_code__c.substring(4,5);
                                               string militaryTime = caseObj.Mfg_Trace_code__c.substring(5,9);
                                               string machineCodeChar = caseObj.Mfg_Trace_code__c.substring(9,10); //2
                                               
                                               Map<String, Integer> yearMapping = new Map<String, Integer>{
                                                   'R' => 2021, 'C' => 2022, 'M' => 2023, 'D' => 2024,
                                                       '5' => 2025, '6' => 2026, '7' => 2027, '8' => 2028, '9' => 2029,
                                                       '0' => 2030, '1' => 2031, '2' => 2032, '3' => 2033, '4' => 2034
                                                       };
                                                           
                                                           if (yearMapping.containsKey(prodYear)) {
                                                               final_year = yearMapping.get(prodYear);
                                                           }
                                               Boolean invalidProdDayMonth = false ;
                                               if(!TraceCodeHelperSecondClass.JulianDateChecker(prodDayAndMonth, final_year)){
                                                   invalidProdDayMonth = true;
                                               }
                                               
                                               if(module != 'U' && module !='J' && module !='N' && module !='P' && module !='E' && module !='H'&&
                                                  module != 'A' && module !='B' && module !='C' && module !='D' && module !='F')
                                               {
                                                   //return null; //Invalid Module
                                                   invalidProdDayMonth = true;
                                               }
                                               final_date = date.newInstance(final_year,1,1); //2025/01/01
                                               final_date = final_date.addDays(Integer.valueOf(prodDayAndMonth)-1); // 2026/01/05
                                               system.debug('Final Date (10-char) '+final_date);
                                               
                                               //Validate 10th character for Machine Code (valid values: 1, 2, 3, or 4)
                                               Boolean validMachineCodeChar = (machineCodeChar == '1' || machineCodeChar == '2' || machineCodeChar == '3' || machineCodeChar == '4');
                                               
                                               if(militaryTime.isNumeric())
                                               {
                                                   if(Integer.valueOf(militaryTime.subString(0,2)) <= 23 && Integer.valueOf(militaryTime.subString(2,4)) <= 59)
                                                   {	
                                                       //lv_military_time = militaryTime; //assign military time
                                                       
                                                       Integer getShift;
                                                       getShift = Integer.valueOf(militaryTime);
                                                       if(getShift >= 630 && getShift<=1429)
                                                       {
                                                           caseObj.DateCodeShift__c = '1';
                                                       }
                                                       else if(getshift >=1430 && getShift<=2229)
                                                       {
                                                           caseObj.DateCodeShift__c = '2';
                                                       }
                                                       else if(getShift >= 2230 || getShift <= 629)
                                                       {
                                                           caseObj.DateCodeShift__c = '3';
                                                       }
                                                       
                                                   }
                                                   
                                               }
                                               
                                               //Check if derived date is less than the system date and 10th char is valid
                                               if(final_date < dateToProcess && validMachineCodeChar)
                                               {
                                                   productionDate = String.valueOf(final_date.format());
                                                   caseObj.Production_date__c = final_date;
                                                   caseObj.DateCodeLocation__c = 'RICHMOND';
                                                   caseObj.DateCodeRptFactory__c = 'MC_HELIX';
                                                   caseObj.DateCodeMilitaryTime__c = militaryTime;
                                                   if(invalidProdDayMonth){
                                                       caseObj.ValidTraceCode__c = false;   
                                                   }
                                                   else{
                                                       caseObj.ValidTraceCode__c = True;  
                                                   }
                                                   
                                                   //Machine Code = 5th character + 10th character (e.g., E4)
                                                   caseObj.Machine_Code__c = module + machineCodeChar;
                                                   
                                                   //Set Line and DateCodeUnit based on 5th character (module)
                                                   if(module == 'U'){
                                                       caseObj.Line__c = 'Bay 9 – Line#1';
                                                       caseObj.DateCodeUnit__c = 'U';
                                                   }
                                                   if(module == 'J'){
                                                       caseObj.Line__c = 'Bay 9 – Line#2';
                                                       caseObj.DateCodeUnit__c = 'J';
                                                   }
                                                   if(module == 'N'){
                                                       caseObj.Line__c = 'Bay 9 – Line#3';
                                                       caseObj.DateCodeUnit__c = 'N';
                                                   }
                                                   if(module == 'P'){
                                                       caseObj.Line__c = 'Bay 9 – Line#4';
                                                       caseObj.DateCodeUnit__c = 'P';
                                                   }
                                                   if(module == 'H'){
                                                       caseObj.Line__c = 'USSTC Ric - Line H';
                                                       caseObj.DateCodeUnit__c = 'H';
                                                   }
                                                   if(module == 'E'){
                                                       caseObj.Line__c = 'USSTC Ric - Line E';
                                                       caseObj.DateCodeUnit__c = 'E';
                                                   }
                                                   if(module == 'A'){
                                                       caseObj.Line__c = 'USSTC Ric - Line A';
                                                       caseObj.DateCodeUnit__c = 'A';
                                                   }
                                                   if(module == 'B'){
                                                       caseObj.Line__c = 'USSTC Ric - Line B';
                                                       caseObj.DateCodeUnit__c = 'B';
                                                   }
                                                   if(module == 'C'){
                                                       caseObj.Line__c = 'USSTC Ric - Line C';
                                                       caseObj.DateCodeUnit__c = 'C';
                                                   }
                                                   if(module == 'D'){
                                                       caseObj.Line__c = 'USSTC Ric - Line D';
                                                       caseObj.DateCodeUnit__c = 'D';
                                                   }
                                                   if(module == 'F'){
                                                       caseObj.Line__c = 'USSTC Ric - Line F';
                                                       caseObj.DateCodeUnit__c = 'F';
                                                   }
                                               }
                                               else{
                                                   caseObj.Line__c = '';
                                                   caseObj.DateCodeUnit__c = '';
                                                   caseObj.Production_date__c = null;
                                                   caseObj.DateCodeMilitaryTime__c='';
                                                   caseObj.DateCodeShift__c = '';
                                                   caseObj.Machine_Code__c = '';
                                                   caseObj.ValidTraceCode__c = False;
                                               }
                                           }
                                    }
                                }
    }
    
    public void usstc9CharacterTraceCode(List<case> caseValue){
        for(case caseObj:caseValue){
            
            If(caseObj.Mfg_Trace_code__c != null){
                if( (caseObj.Mfg_Trace_code__c).length() == 9  &&   (caseObj.PLCode__c == 'SP'  || caseObj.PLCode__c == 'PC' || caseObj.PLCode__c == 'DS' || caseObj.PLCode__c == 'UU')){
                    string prdouctionDate = TraceCodeHelperSecondClass.validateTraceCode(caseObj.Mfg_Trace_code__c);
                    if(prdouctionDate != 'fail'){
                        caseObj.DateCodeLocation__c = 'Hopkinsville';
                        caseObj.DateCodeRptFactory__c = 'Baker One';
                        caseObj.Production_date__c = Date.parse(prdouctionDate);
                        caseObj.DateCodeMilitaryTime__c = caseObj.Mfg_Trace_code__c.substring(5,9);
                        caseObj.ValidTraceCode__c = True;  
                        Integer hours = Integer.valueOf(caseObj.Mfg_Trace_code__c.substring(5,7));
                        if(hours < 7 || hours > 22 ){
                            caseObj.DateCodeShift__c = '3';
                        }
                        else if(hours > 6 && hours <= 15 ){
                            caseObj.DateCodeShift__c = '1';
                        }
                        else if(hours > 14 && hours < 23 ){
                            caseObj.DateCodeShift__c = '2';
                        }
                    }
                    
                    if(caseObj.Mfg_Trace_code__c.substring(4, 5) == 'G'){
                        caseObj.Line__c = 'LINE 1A';
                        caseObj.DateCodeUnit__c = 'G';
                    }
                    if(caseObj.Mfg_Trace_code__c.substring(4, 5) == 'K'){
                        caseObj.Line__c = 'LINE 1B';
                        caseObj.DateCodeUnit__c = 'K';
                    }
                    if(caseObj.Mfg_Trace_code__c.substring(4, 5) == 'O'){
                        caseObj.Line__c = 'LINE 2A';
                        caseObj.DateCodeUnit__c = 'O';
                    }
                    if(caseObj.Mfg_Trace_code__c.substring(4, 5) == 'T'){
                        caseObj.Line__c = 'LINE 2B';
                        caseObj.DateCodeUnit__c = 'T';
                    }
                    if(caseObj.Mfg_Trace_code__c.substring(4, 5) == 'Y'){
                        caseObj.Line__c = 'LINE 3A';
                        caseObj.DateCodeUnit__c = 'Y';
                    }
                    if(caseObj.Mfg_Trace_code__c.substring(4, 5) == 'U'){
                        caseObj.Line__c = 'LINE 3B';
                        caseObj.DateCodeUnit__c = 'U';
                    }
                    if(caseObj.Mfg_Trace_code__c.substring(4, 5) == 'Z'){
                        caseObj.Line__c = 'POUCH';
                        caseObj.DateCodeUnit__c = 'Z';
                    }
                }
            }
            
        } 
    }
    public void enjoyTraceCode(List<case> caseValue){
        for(case caseObj:caseValue){
            
            If(caseObj.Mfg_Trace_code__c != null){
                
                if( (caseObj.Mfg_Trace_code__c).length() == 11  && caseObj.Mfg_Trace_code__c.isNumeric()){
                    string prdouctionDate = TraceCodeHelperSecondClass.NjoyTraceCode(caseObj.Mfg_Trace_code__c);
                    string fourthAndFifthString = caseObj.Mfg_Trace_code__c.substring(3, 5);
                    Integer fourthAndFifth = Integer.ValueOf(fourthAndFifthString);
                    Integer sixthAndSeventh = Integer.ValueOf(caseObj.Mfg_Trace_code__c.substring(5, 7));
                    system.debug('fourthAndFifth from trigger: '+fourthAndFifth);
                    if(prdouctionDate != null ){
                        caseObj.Production_date__c = Date.parse(prdouctionDate);
                        caseObj.ValidTraceCode__c = True;  
                    }
                    if (fourthANdFifth > 0 && fourthAndFifth < 100) {
                        if (fourthAndFifth == 20) {
                            if (Date.parse(prdouctionDate) >= Date.newInstance(2023, 6, 1)) {
                                caseObj.DateCodeLocation__c = 'China';
                                caseObj.DateCodeRptFactory__c = 'Cape';
                            } else {
                                caseObj.DateCodeLocation__c = 'Unknown';
                                caseObj.DateCodeRptFactory__c = 'Unknown';
                            }
                            
                            caseObj.Line__c = fourthAndFifthString;
                        } else if (fourthAndFifth < 20) {
                            caseObj.DateCodeLocation__c = 'China';
                            caseObj.DateCodeRptFactory__c = 'Smoore - China';
                            caseObj.Line__c = fourthAndFifthString;
                        } else if (fourthAndFifth <= 80) {
                            caseObj.DateCodeLocation__c = 'China';
                            caseObj.DateCodeRptFactory__c = 'Cape';
                            caseObj.Line__c =fourthAndFifthString;
                        } else {
                            caseObj.DateCodeLocation__c = 'Indonesia';
                            caseObj.DateCodeRptFactory__c = 'Smoore - Indonesia';
                            caseObj.Line__c = fourthAndFifthString;
                        }
                    }
                    else{
                        caseObj.DateCodeLocation__c = 'PAC';
                        caseObj.DateCodeRptFactory__c = '';
                        caseObj.Line__c ='';
                    }
                    
                }
            }
        }
    }
    
    public void thirdPartyManufacture(List<case> caseValue){
        string first_char = '';
        string first_number = '';
        string second_char = '';
        string second_number = '';
        string third_char = '';
        string fourth_number = '';
        String third_number = '';
        
        for(case caseObj:caseValue){
            
            system.debug('caseObj.Mfg_Trace_code__c : ' + caseObj.Mfg_Trace_code__c);
            
            system.debug('caseObj.PLCode__c.toUpperCase(): ' +caseObj.PLCode__c);
            if(caseObj.Mfg_Trace_code__c != null && caseObj.Mfg_Trace_code__c != '' && caseObj.PLCode__c != ''  && caseObj.PLCode__c != null) {
                
                If(caseObj.Mfg_Trace_code__c.length() == 9 && caseObj.PLCode__c.toUpperCase() == 'AS') {
                    string production_date,lv_leap_year,lv_year,ln_leap;
                    first_char  =  caseObj.Mfg_Trace_code__c.substring(0, 1);
                    third_char  = caseObj.Mfg_Trace_code__c.substring( 6, 9);
                    first_number  = caseObj.Mfg_Trace_code__c.substring(1, 4);
                    second_char  = caseObj.Mfg_Trace_code__c.substring( 4, 5);
                    second_number = caseObj.Mfg_Trace_code__c.substring(5, 6);
                    system.debug('Prdouct line code is '+caseObj.PLCode__c.toUpperCase());
                    production_date = TraceCodeHelperSecondClass.ProductDateCalculator(caseObj.Mfg_Trace_code__c,caseObj.PLCode__c.toUpperCase());
                    system.debug('Date code unit '+third_char);
                    system.debug('first char is '+first_char);
                    system.debug('caseObj.Product_Line__c '+caseObj.PLCode__c.toUpperCase());
                    system.debug('caseObj.Operating_Company__c '+ caseObj.Operating_Company__c);
                    String result = production_date.toUpperCase();
                    system.debug('control in first if case');
                    
                    if( first_char == 'X' || first_char == 'S') {
                        
                        if(result != 'FAIL' && date.parse(production_date) >= date.parse ('11/18/2024') &&  date.parse(production_date) <= system.today()) {
                            
                            if (third_char == '9S1' || third_char == '9S2' || third_char == '9S3' || third_char == '9S4' || third_char == '9S5' || third_char == '9S6'){
                                system.debug('control in first 2nd if case');
                                production_date = production_date; 
                                system.debug('Date code unit '+third_char);
                                caseObj.DateCodeRptBay__c = '9';
                                caseObj.Line__c = caseObj.Mfg_Trace_code__c.substring(6, 8);
                                caseObj.DateCodeUnit__c = third_char;    
                            }
                            caseObj.ValidTraceCode__c = true;
                            caseObj.DateCodeRptFactory__c = '3RD PARTY MANUFACTURER';
                            caseObj.DateCodeLocation__c = 'Dominican Republic';
                            system.debug('Line__c value is  '+caseObj.Line__c);
                            caseobj.Production_date__c = date.parse(production_date);
                            Map<string,string> shiftCodeAndMilitryTime = CigTransDateCalculator(caseObj.Mfg_Trace_code__c,production_date);
                            caseObj.DateCodeShift__c = shiftCodeAndMilitryTime.get('lv_shift');
                            caseObj.DateCodeMilitaryTime__c = shiftCodeAndMilitryTime.get('lv_military_time');
                            system.debug('Date code shift '+caseObj.DateCodeShift__c );
                            system.debug('DateCodeMilitaryTime__c '+caseObj.DateCodeMilitaryTime__c );
                            if(first_char == 'X' ){
                                caseObj.DateCodeColdStorage__c = 'N';
                            }
                            if(first_char == 'S' ){
                                caseObj.DateCodeColdStorage__c ='Y';
                            }
                        }
                        
                        else {
                            caseObj.DateCodeRptBay__c = '';
                            caseObj.Line__c = '';
                            caseObj.DateCodeUnit__c = '';
                            caseObj.ValidTraceCode__c = false;
                            caseObj.DateCodeRptFactory__c = '';
                            caseObj.DateCodeLocation__c = '';
                            system.debug('Line__c value is  '+caseObj.Line__c);
                            caseobj.Production_date__c = null;
                            //Map<string,string> shiftCodeAndMilitryTime = CigTransDateCalculator(caseObj.Mfg_Trace_code__c,production_date);
                            caseObj.DateCodeShift__c = '';
                            caseObj.DateCodeMilitaryTime__c = '';
                            system.debug('Date code shift '+caseObj.DateCodeShift__c );
                            system.debug('DateCodeMilitaryTime__c '+caseObj.DateCodeMilitaryTime__c );
                            caseObj.DateCodeColdStorage__c ='';
                        }
                    }  
                }
                
                if(System.today() >= date.parse ('11/18/2024')  && caseObj.PLCode__c.toUpperCase() == 'AS' && caseObj.Mfg_Trace_code__c != null){
                    if (String.isNotBlank(caseObj.Mfg_Trace_code__c) && caseObj.Mfg_Trace_code__c.length() == 1) {
                        String firstChar = caseObj.Mfg_Trace_code__c;
                        
                        switch on firstChar {
                            when 'V' {
                                caseObj.DateCodeLocation__c = 'Virginia';
                                caseObj.DateCodeRptFactory__c = 'MC';
                                caseObj.ValidTraceCode__c = true;
                                caseObj.Production_date__c = null;
                                caseObj.DateCodeColdStorage__c = '';
                            }
                            when 'X' {
                                caseObj.DateCodeLocation__c = 'Dominican Republic';
                                caseObj.DateCodeRptFactory__c = '3RD PARTY MANUFACTURER';
                                caseObj.ValidTraceCode__c = true;
                                caseObj.Production_date__c = null;
                                caseObj.DateCodeColdStorage__c = '';
                            }
                            when 'U' {
                                caseObj.DateCodeLocation__c = 'UNKNOWN';
                                caseObj.DateCodeRptFactory__c = 'UNKNOWN';
                                caseObj.ValidTraceCode__c = true;
                                caseObj.Production_date__c = null;
                                caseObj.DateCodeColdStorage__c = '';
                            }
                            
                        }
                    } 
                    else if( (String.isBlank(caseObj.Mfg_Trace_code__c))) 
                    {
                        caseObj.DateCodeLocation__c = 'Virginia';
                        caseObj.DateCodeRptFactory__c = 'MC';
                        caseObj.DateCodeColdStorage__c = ' ';
                        caseObj.ValidTraceCode__c = false;
                        caseObj.DateCodeColdStorage__c = '';
                    }
                    
                }
                
            }
            
        }
        
    }
    
    public void Helix1CharcterCode(List<case> caseUpdate){
        for(case caseObj:caseUpdate){
            if((caseObj.Mfg_Trace_code__c).length() == 1  &&   caseObj.Product_Line__c == 'Tobacco Derived Nicotine pouch' && caseObj.PLCode__c == 'TDNP' && 
               (caseObj.Trace_Code_Location__c == 'Can' || caseObj.Trace_Code_Location__c == 'Carton' ) ){
                   if((caseObj.Mfg_Trace_code__c).substring(0,1) == 'M'){
                       caseObj.DateCodeRptFactory__c = 'MC_HELIX'; 
                       caseObj.DateCodeLocation__c ='RICHMOND';
                       caseObj.ValidTraceCode__c = True;
                   }else if((caseObj.Mfg_Trace_code__c).substring(0,1) == 'S'){
                       caseObj.DateCodeRptFactory__c = 'HELSINGBORG'; 
                       caseObj.DateCodeLocation__c ='SWEDEN';
                       caseObj.ValidTraceCode__c = True;
                   } else if((caseObj.Mfg_Trace_code__c).substring(0,1) == 'U'){
                       caseObj.DateCodeRptFactory__c = 'UNKNOWN'; 
                       caseObj.DateCodeLocation__c ='UNKNOWN';
                       caseObj.ValidTraceCode__c = True;
                   }
               }
        }
    }
    
    public Map<String,String> CigTransDateCalculator(String traceCode, String production_date)
    {
        TraceCodeHelper tch = new TraceCodeHelper();
        Date ManufacturedDate = tch.convertProductDate(production_date);
        System.debug('Manufactured Date: ' + ManufacturedDate);
        
        Map<String,String> retVal = new Map<String,String>();
        String lv_shift = '', lv_military_time = '';
        String second_char = traceCode.substring(4, 5);
        
        Date transMT_startDate = Date.valueOf(Label.CIG_Trans_MT_Start_Date);//Start of Transition Period  
        Date transMT_endDate = Date.valueOf(Label.CIG_Trans_MT_End_Date);//End of Transition Period  
        System.debug('Trans Start Date: ' + transMT_startDate);
        System.debug('Trans End Date: ' + transMT_endDate);
        if(Test.isRunningTest()){
            transMT_startDate = Date.valueOf('2019-10-18');
            transMT_endDate = Date.valueOf('2019-10-20');
        }
        List<String> fifthPosZ = new List<String>{'W','Z','A','B','C','D','E','F'};
            List<String> fifthPosX = new List<String>{'G','H','I','J','K','L','M','N'};
                List<String> fifthPosY = new List<String>{'O','P','Q','R','S','T','U','V'};
                    Integer tmpMilitary = 0;
        if(tracecode.length() == 9)
        {
            //Manufacturing date is in Pre-Transition Period
            if(ManufacturedDate < transMT_startDate)
            {
                retVal.put('lv_shift',second_char);
            }
            //Manufacturing date is in Transition Period
            else if(ManufacturedDate >= transMT_startDate 
                    && ManufacturedDate <= transMT_endDate)
            {
                if(fifthPosZ.contains(second_char))
                {
                    //Shift = Z and Military time starts from 2300 - 0600
                    retVal.put('lv_shift','Z');
                    if(second_char=='W')
                    {
                        lv_military_time = '2300';
                    }
                    else if(second_char=='Z')
                    {
                        lv_military_time = '0000';
                    }
                    else
                    {
                        for(integer i=2;i<fifthPosZ.size();i++)
                        {
                            tmpMilitary = tmpMilitary + 100;
                            if(second_char==fifthPosZ[i])
                            {
                                break;
                            }
                        }
                        lv_military_time = '0' + String.valueOf(tmpMilitary);            
                    }
                    retVal.put('lv_military_time',lv_military_time);
                }
                else if(fifthPosX.contains(second_char))
                {
                    //Shift = X and Military time starts from 0700 - 1400
                    retVal.put('lv_shift','X');
                    tmpMilitary = 700;
                    for(integer i=0;i<fifthPosX.size();i++)
                    {
                        if(second_char==fifthPosX[i])
                        {
                            break;
                        }
                        tmpMilitary = tmpMilitary + 100;
                    }
                    if(tmpMilitary<1000)
                    {
                        lv_military_time = '0' + String.valueOf(tmpMilitary);
                    }
                    else
                    {
                        lv_military_time = String.valueOf(tmpMilitary);
                    }
                    retVal.put('lv_military_time',lv_military_time);
                }
                else if(fifthPosY.contains(second_char))
                {
                    //Shift = Y and Military time starts from 1500 - 2200
                    retVal.put('lv_shift','Y');
                    tmpMilitary = 1500;
                    for(integer i=0;i<fifthPosY.size();i++)
                    { 
                        if(second_char==fifthPosY[i])
                        {
                            break;
                        }
                        tmpMilitary = tmpMilitary + 100;
                    }
                    lv_military_time = String.valueOf(tmpMilitary);
                    retVal.put('lv_military_time',lv_military_time);
                }
                else
                {
                    //For X and Y, Shift value is the same char and military time is null
                    if(second_char.isAlpha())
                    {
                        retVal.put('lv_shift',second_char);
                        retVal.put('lv_military_time', null);
                    }
                }
            }
            //Manufacturing date is in Post Transition Period
            else if(ManufacturedDate > transMT_endDate)
            {
                if(fifthPosZ.contains(second_char))
                {
                    //Shift = Z and Military time starts from 2300 - 0600
                    retVal.put('lv_shift','Z');
                    if(second_char=='W')
                    {
                        lv_military_time = '2300';
                    }
                    else if(second_char=='Z')
                    {
                        lv_military_time = '0000';
                    }
                    else
                    {
                        for(integer i=2;i<fifthPosZ.size();i++)
                        {
                            tmpMilitary = tmpMilitary + 100;
                            if(second_char==fifthPosZ[i])
                            {
                                break;
                            }
                        }
                        lv_military_time = '0' + String.valueOf(tmpMilitary);            
                    }
                    retVal.put('lv_military_time',lv_military_time);
                }
                else if(fifthPosX.contains(second_char))
                {
                    //Shift = X and Military time starts from 0700 - 1400
                    retVal.put('lv_shift','X');
                    tmpMilitary = 700;
                    for(integer i=0;i<fifthPosX.size();i++)
                    {
                        if(second_char==fifthPosX[i])
                        {
                            break;
                        }
                        tmpMilitary = tmpMilitary + 100;
                    }
                    if(tmpMilitary<1000)
                    {
                        lv_military_time = '0' + String.valueOf(tmpMilitary);
                    }
                    else
                    {
                        lv_military_time = String.valueOf(tmpMilitary);
                    }
                    retVal.put('lv_military_time',lv_military_time);
                }
                else if(fifthPosY.contains(second_char))
                {
                    //Shift = Y and Military time starts from 1500 - 2200
                    retVal.put('lv_shift','Y');
                    tmpMilitary = 1500;
                    for(integer i=0;i<fifthPosY.size();i++)
                    { 
                        if(second_char==fifthPosY[i])
                        {
                            break;
                        }
                        tmpMilitary = tmpMilitary + 100;
                    }
                    lv_military_time = String.valueOf(tmpMilitary);
                    retVal.put('lv_military_time',lv_military_time);
                }
                else
                {
                    //For X and Y, Shift value is will be null and military time is null for Post transition
                    if(second_char.isAlpha())
                    {
                        retVal.put('lv_shift','Post');
                        retVal.put('lv_military_time', null);
                    }
                }
            }
            else
            {
                //Do nothing
            }
        }
        return retVal;
    }
    // Backward compatibility wrapper - DO NOT REMOVE
public void Helix9CharcterCode(List<Case> caseValue) {

    Helix9CharcterCode(
        caseValue,
        true,
        false,
        null
    );
}
}