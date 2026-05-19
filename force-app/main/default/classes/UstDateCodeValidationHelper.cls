Public class UstDateCodeValidationHelper{

    public class ustTraceCode{  
        public string ProductionDate;
        public string FinalUstTraceCode; 
        public string ustTraceCodeDisp;
    }
     
    //method to validate entered trace code
    public UstDateCodeValidationHelper.ustTraceCode ustTraceCodeValidation(string productLineCode, string dateCode, string oprCompany, string traceCodeLocation, string brandHierarchyId){
        
        Integer IndexValue = 0;
        String UstDateType = '';
        String UstProductLineCode1 = '';
        String UstProductLineCode2 = '';
        UstDateCodeValidationHelper.ustTraceCode traceCodeObj = new UstDateCodeValidationHelper.ustTraceCode();
        
        
        List<Brand_Hierarchy__c>  brandHierList = new List<Brand_Hierarchy__c>([Select id, Ust_Date_Type__c 
                                                                                from Brand_Hierarchy__c
                                                                                Where id = :brandHierarchyId]);
        if(!brandHierList.isEmpty() && brandHierList.size()>0){
            UstDateType = brandHierList[0].Ust_Date_Type__c;                                             
        }
        if(UstDateType != null && UstDateType.trim() != '' ){                                     
            IndexValue = UstDateType.indexOf('/',0);  //SB/GFU                                                                      
            
            If (IndexValue > 0){
            
              UstProductLineCode1 = UstDateType.subString(0,IndexValue);
              UstProductLineCode2 = UstDateType.subString(IndexValue+1,UstDateType.length());
              
              traceCodeObj.FinalUstTraceCode = UstProductLineCode1;
              
              TraceCodeHelper tc = new TraceCodeHelper(); 
              traceCodeObj.ProductionDate = tc.traceCodeValidation(UstProductLineCode1,dateCode,oprCompany,traceCodeLocation, null);
              
              If (traceCodeObj.ProductionDate == 'FAIL'){
                traceCodeObj.FinalUstTraceCode = UstProductLineCode2;
                tc = new TraceCodeHelper(); 
                traceCodeObj.ProductionDate = tc.traceCodeValidation(UstProductLineCode2,dateCode,oprCompany,traceCodeLocation, null);
              }
             
            }else{
                traceCodeObj.FinalUstTraceCode = UstDateType;
                TraceCodeHelper tc = new TraceCodeHelper(); 
                System.debug('testing '+UstDateType+','+dateCode+','+oprCompany+','+traceCodeLocation);
                traceCodeObj.ProductionDate = tc.traceCodeValidation(UstDateType,dateCode,oprCompany,traceCodeLocation, null);      
            }
        }
        
        if(traceCodeObj.FinalUstTraceCode == 'MD')
            traceCodeObj.UstTraceCodeDisp = 'Made Date';
        else if(traceCodeObj.FinalUstTraceCode == 'GFU')
            traceCodeObj.UstTraceCodeDisp = 'Guaranteed Fresh Until';
        else if(traceCodeObj.FinalUstTraceCode == 'CD')
            traceCodeObj.UstTraceCodeDisp = 'Code Date';
        else if(traceCodeObj.FinalUstTraceCode == 'SN')
            traceCodeObj.UstTraceCodeDisp = 'Snus Date Code';
        else if(traceCodeObj.FinalUstTraceCode == 'WB')
            traceCodeObj.UstTraceCodeDisp = 'WB Date Code';
        else if(traceCodeObj.FinalUstTraceCode == 'SB')
            traceCodeObj.UstTraceCodeDisp = 'Sell By';
        else
            traceCodeObj.UstTraceCodeDisp = '';
        
        return traceCodeObj;        
    }
}