public class DateCodeHelperExtension {
    
    /*public class DateCode
{
public string ProductionDate;
public string DateCodeLocation;
public string DateCodeShift;
public string DateCodeUnit;
public string DateCodeColdStorage;
public string DateCodeRptBay;
public string DateCodeRptFactory;
public string DateCodeMilitaryTime;
public string UstDateCode;
}*/
    /* public class TraceCodeValue
{
public string ProductionDate;
public string lvLocation;
public string lvDateCodeRptFactory;
public string lvMilitaryTime;
public string lvDateCodeColdStorage;
public integer lnDays;
}*/
    
    public class Data{
        public string location1;    
        public String lv_unit1;
        public String first_char1;
        public String lv_date_code_rpt_factory1;
        public String production_date1;
        public String lv_shift1;
        public String lv_military_time1;
        
        
    }
    public string first_char;
    public string second_char;
    public string third_char;
    public string first_number;
    public string second_number;
    public string third_number;
    public string fourth_number;
    public string fifth_number;
    public string lv_year = '/201';
    public string lv_year1 = '/20';
    public string lv_year2;
    public string lv_day;
    public string lv_month;
    public Integer ln_cnt = 0;
    public string production_date = '';
    public string lv_location = '';
    public string lv_shift = '';
    public string lv_unit = '';
    public string lv_error_msg = '';
    public string lv_temp_year = null;
    public string lv_date_code_cold_storage = '';
    public string lv_date_code_rpt_bay = '';
    public string lv_date_code_rpt_factory = '';
    public string lv_military_time = '';
    public string lv_ust_date_code = '';
    public Integer ln_days = 0;
    public string ln_leap = '0';
    public string lv_leap_year = '20';
    public Integer ln_lastdigit_year;
    public string lv_year_new = '/202';
    public string lv_cur_year = '';
    public Integer Retcode = 0;
    public string RetDesc = 'SUCCESS';
    public string DebugMsg;
    public Integer CHECK = 0;
    public string Check2 = '';
    public string year_leep = '';
    public string lv_year_new1 = '20';
    public Integer ln_lasttwodigit_year;
    public string traceCode;
    public string ProductLineCode;
    public string ustDateType;
    public string ustDateCode;
    public string oprCompany;
    public string PrintVariable;
    public string cigar7position;
    public string cigar8position;
    Set<string> charSet = new  Set<string>();
    Set<Integer> intSet = new  Set<Integer>();
    String fiscal_week = '';
    Financial_Week__c fw = new Financial_Week__c();
    public DateCodeHelperExtension.Data DateCodeObj;
    
    public DateCodeHelperExtension()
    {
        DateCodeObj = new  DateCodeHelperExtension.Data();
    }
    
    
    public DateCodeHelperExtension.Data DateCodeFields(string productLineCode, string traceCode, string oprCompany, string TraceCodeLocation, string ustDateType, string ustDateCode, case caseObj){
        
        Data newdata = new Data();
        /* if(traceCode.length() == 1) 
{
first_char  =  traceCode.subString( 0, 1); 

//=============================
//-----------------------------
//Set Location, Factory
//-----------------------------

//Location and Factory will be populated whether invalid or valid
//
//
newdata.location1 = 'RICHMOND';
newdata.lv_date_code_rpt_factory1 = 'D_PILOT';
newdata.production_date1 = null; //Set to null to declare as an invalid tracecode

/*if(first_char == 'M'){
newdata.location1 = 'RICHMOND';
newdata.lv_date_code_rpt_factory1 = 'D_PILOT';
}
else if(first_char == 'S'){
newdata.location1 = 'RICHMOND';
newdata.lv_date_code_rpt_factory1 = 'D_PILOT';
}else{

}

}*/
        //End: RITM0846391 - SCR 20-11-17 Trace Codes
        /*   if(traceCode.length() == 7)
{ 
first_char  =  traceCode.subString( 0, 1); 
String shift  =  traceCode.subString( 2, 5);
//=============================
//-----------------------------
//Set Location, Factory, Shift
//-----------------------------

//Location and Factory is constant, invalid or valid will have the same value
newdata.location1 = 'RICHMOND';
newdata.lv_date_code_rpt_factory1 = 'D_PILOT';

//----------------
TraceCodeHelper tch = new TraceCodeHelper();
newdata.production_date1 = tch.ProductDateCalculator(tracecode,productLineCode);

if(shift.isNumeric() && newdata.production_date1 != null)
{
newdata.lv_shift1 = shift; //Should be numeric                         
}
else
{
//reset since invalid
newdata.lv_shift1 = '';
production_date = null; 
}
}*/
        if(traceCode.length() == 9)
        {
            first_char  =  traceCode.subString( 0, 1); 
            String module = traceCode.subString( 4, 5);
            String shift  =  traceCode.subString( 5, 9);
            
            //=====================================
            //-------------------------------------
            //Set Location, Factory, Module, Shift
            //-------------------------------------
            
            //Location and Factory is constant, invalid or valid will have the same value
            if(productLineCode == 'SNP'){
                newdata.location1 = 'RICHMOND';
                newdata.lv_date_code_rpt_factory1 = 'D_PILOT';
            }
            
            else {
                
                newdata.location1 = 'RICHMOND';
                newdata.lv_date_code_rpt_factory1 = 'USSTP – DPP_Ion';
                
            }
            TraceCodeHelper tch = new TraceCodeHelper();
            newdata.production_date1 = tch.ProductDateCalculator(tracecode,productLineCode);
            System.debug('Production date: ' + newdata.production_date1);
            if(newdata.production_date1 != null)
            {
                if(shift.isNumeric())
                {
                    
                    if(Integer.valueOf(shift.subString(0,2)) <= 23 && Integer.valueOf(shift.subString(2,4)) <= 59)
                    {
                        newdata.lv_military_time1 = shift; //assign military time
                        System.debug('Shift value' + shift);
                        Integer getShift;
                        getShift = Integer.valueOf(shift);
                        if(getShift >= 700 && getShift<=1459)
                        {
                            shift = '1';   
                        }
                        else if(getshift >=1300 && getShift<=2259)
                        {
                            shift = '2';
                        }
                        else if(getShift >= 2300 || getShift <= 659)
                        {
                            shift = '3';
                        }
                        
                        newdata.lv_shift1 = shift;
                    }
                    else
                    {
                        newdata.lv_shift1 = null;
                        newdata.lv_military_time1 = null;
                    }
                    
                }
                if(module.isAlpha()) newdata.lv_unit1 = module;
                //set all values to null if one of the validation is invalid
                if(newdata.lv_shift1 == null ||  newdata.lv_military_time1 == null || newdata.lv_unit1 == null)
                {
                    newdata.production_date1 = null;
                    newdata.lv_shift1 = null;
                    newdata.lv_military_time1 = null;
                    newdata.lv_unit1 = null;
                }
            }
            else 
            {
                //reset values if production date fails
                newdata.lv_shift1 = '';
                newdata.lv_military_time1 = '';
                newdata.lv_unit1 = '';            }
            //----------------
        }
        
        
        return newdata;
    }
    
    
}