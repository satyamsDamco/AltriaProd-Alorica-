public class TraceCodesDetailsHelper{

    public class TraceCodeClass
    {
        public string DateCodeProductionDate;
        public string DateCodeLocation;
        public string DateCodeShift;
        public string DateCodeUnit;
        public string DateCodeColdStorage;
        public string DateCodeRptBay;
        public string DateCodeRptFactory;
        public string DateCodeMilitaryTime;
        public string SpUstDateCode;
    }

    public TraceCodesDetailsHelper.TraceCodeClass getAllTraceCodeValues(String ProductLineCode, String TraceCodeObj,String OpCompany, String TraceCodeLocation, 
                                                                    String UstDateCodeType,String UstDateCode, Case caseObj){
                                                                        
        TraceCodeClass TraceCodeClassObj = new TraceCodeClass();
        string pvalid;
        string pmsg;
        String TraceCode;
        TraceCode = TraceCodeObj.toUpperCase();
        try{            
            if(TraceCodeLocation.length() > 0){
                    if(TraceCode.length() > 0 ){
                        DateCodeHelper.DateCode dateCodeResult= new DateCodeHelper.DateCode();
                        DateCodeHelper helpCode1=new DateCodeHelper();
                        dateCodeResult=helpCode1.DateCodeFields(ProductLineCode,TraceCode,OpCompany, TraceCodeLocation,UstDateCodeType,UstDateCode,caseObj);
                        System.debug('test data '+ProductLineCode  +' ,'+ TraceCode +' ,'+ OpCompany +' ,'+ TraceCodeLocation +' ,'+ UstDateCodeType +' ,'+ UstDateCode);  
                        System.debug('test dateCodeResult '+dateCodeResult);
                        TraceCodeClassObj.DateCodeProductionDate = dateCodeResult.ProductionDate;
                        TraceCodeClassObj.DateCodeLocation = dateCodeResult.DateCodeLocation;
                        TraceCodeClassObj.DateCodeShift = dateCodeResult.DateCodeShift;
                        TraceCodeClassObj.DateCodeUnit = dateCodeResult.DateCodeUnit;
                        TraceCodeClassObj.DateCodeColdStorage = dateCodeResult.DateCodeColdStorage;
                        TraceCodeClassObj.DateCodeRptBay = dateCodeResult.DateCodeRptBay;
                        TraceCodeClassObj.DateCodeRptFactory = dateCodeResult.DateCodeRptFactory;
                        TraceCodeClassObj.DateCodeMilitaryTime = dateCodeResult.DateCodeMilitaryTime;
                        TraceCodeClassObj.SpUstDateCode = dateCodeResult.UstDateCode;
                    }
                    else{ 
                        if (ProductLineCode == 'GP') {          
                            TraceCodeClassObj.DateCodeLocation='Unknown';
                        }
                        else if (ProductLineCode == 'PT'){
                            TraceCodeClassObj.DateCodeLocation='Limerick';  
                            TraceCodeClassObj.DateCodeRptFactory ='Limerick';
                        }
                        else if (ProductLineCode == 'AS'){
                            TraceCodeClassObj.DateCodeLocation='Virginia'; 
                            TraceCodeClassObj.DateCodeRptFactory='MC';
                            TraceCodeClassObj.DateCodeShift='';
                        }
                    } 
            }
            else{
                if (ProductLineCode == 'AS'){
                    TraceCodeClassObj.DateCodeLocation='Virginia'; 
                    TraceCodeClassObj.DateCodeRptFactory='MC';
                    TraceCodeClassObj.DateCodeShift='';
                }
            }
            
            if(ProductLineCode == 'PT' && TraceCodeLocation == 'CAS' && TraceCode.length() == 7){ 
                DateCodeHelper.DateCode dateCodeResult= new DateCodeHelper.DateCode();
                DateCodeHelper helpCode1=new DateCodeHelper();
                dateCodeResult=helpCode1.DateCodeFields(ProductLineCode,TraceCode,OpCompany, TraceCodeLocation,UstDateCodeType,UstDateCode,caseObj);        
                  
                TraceCodeClassObj.DateCodeProductionDate = dateCodeResult.ProductionDate;
                TraceCodeClassObj.DateCodeLocation = dateCodeResult.DateCodeLocation;
                TraceCodeClassObj.DateCodeShift = dateCodeResult.DateCodeShift;
                TraceCodeClassObj.DateCodeUnit = dateCodeResult.DateCodeUnit;
                TraceCodeClassObj.DateCodeColdStorage = dateCodeResult.DateCodeColdStorage;
                TraceCodeClassObj.DateCodeRptBay = dateCodeResult.DateCodeRptBay;
                TraceCodeClassObj.DateCodeRptFactory = dateCodeResult.DateCodeRptFactory;
                TraceCodeClassObj.DateCodeMilitaryTime = dateCodeResult.DateCodeMilitaryTime;
                TraceCodeClassObj.SpUstDateCode = dateCodeResult.UstDateCode;
                        
            }
            if(ProductLineCode == 'GP' && TraceCode.length() != 9 && TraceCode.length() != 1 && TraceCode.length() != 12 && TraceCode.length() != 11){ //RITM2548147 - SCR 19-07-26 2019 Cigar v.05 - Jannel //INC0030109 - Issue on Factory field
                TraceCodeClassObj.DateCodeRptFactory = TraceCodeClassObj.DateCodeLocation;
            }else{
                TraceCodeClassObj.DateCodeRptFactory = TraceCodeClassObj.DateCodeRptFactory;
            }
           
            if(ProductLineCode  == 'NC'){
                TraceCodeClassObj.DateCodeLocation = 'GREENSBORO';
                TraceCodeClassObj.DateCodeRptFactory = 'GREENSBORO';
                TraceCodeClassObj.DateCodeColdStorage = 'N';
            }
            
        } catch(exception e){
        
        }   
        return TraceCodeClassObj;
    }
}