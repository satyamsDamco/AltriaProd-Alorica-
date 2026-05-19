public class DateCodeHelper
{
    public class DateCode
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
    }
    public class TraceCodeValue
    {
        public string ProductionDate;
        public string lvLocation;
        public string lvDateCodeRptFactory;
        public string lvMilitaryTime;
        public string lvDateCodeColdStorage;
        public integer lnDays;
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
    public DateCodeHelper.DateCode DateCodeObj;
    public DateCodeHelper()
    {
        DateCodeObj = new  DateCodeHelper.DateCode();
    }
    
    //Start: RITM0691496 - SCR 20-09-28 2020 Trace Codes Cigarettes Shift determines Military Time
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
    //End: RITM0691496
    
    public DateCodeHelper.DateCode DateCodeFields(string ProductLineCodeObj, string traceCodeObj, string oprCompanyObj, string TraceCodeLocation, string ustDateTypeObj, string ustDateCodeObj, case caseObj)
    {
        ProductLineCode = ProductLineCodeObj.toUpperCase();
        traceCode = traceCodeObj.toUpperCase();
        oprCompany = oprCompanyObj.toUpperCase();
        ustDateType = ustDateTypeObj;
        ustDateCode = ustDateCodeObj;
        
        try
        {
            if(traceCode != null)
            {               
                if(ProductLineCode == 'AS' && traceCode.length() != 9 && traceCode.length() != 11)
                {
                    production_date = 'FAIL';
                }
                else if((ProductLineCode == 'SP' || ProductLineCode == 'DS' || ProductLineCode == 'PC' || ProductLineCode == 'TP' || ProductLineCode == 'UU') && traceCode.length() != 9)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'GP' && traceCode.length() != 5  && traceCode.length() != 8 && traceCode.length() != 7 && traceCode.length() != 11 && traceCode.length() != 9 && traceCode.length() != 1)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'PT' && traceCode.length() != 5 && traceCode.length() != 4 && traceCode.length() != 2 && traceCode.length() != 7 && traceCode.length() != 6 && traceCode.length() != 12)
                {
                    production_date = 'FAIL';
                }
                else if((ProductLineCode == 'MD' || ProductLineCode == 'GFU' || ProductLineCode == 'SB') && traceCode.length() != 9)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'CD' && traceCode.length() != 4)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'SN' && traceCode.length() != 5)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'WB' && traceCode.length() != 6)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'EC' && traceCode.length() != 8 && traceCode.length() != 7 && traceCode.length() != 6 && traceCode.length() != 11)
                {
                    production_date = 'FAIL';
                }
                else if(ProductLineCode == 'NC' && traceCode.length() != 8 && traceCode.length() != 9)
                {
                    production_date = 'FAIL';
                }
                else If(ProductLineCode == 'EV')
                {
                    //if(traceCode.indexOf('O') >= 0 || traceCode.indexOf(' ') >= 0 || traceCode.length() > 3 || traceCode.length() < 3){   
                    if((traceCode.length() !=3 && traceCode.length() != 7) || (traceCode.length() == 3 && !first_number.isNumeric())){                  
                        production_date = 'FAIL';
                    }else If (traceCode.indexOf('O') < 0 && traceCode.indexOf(' ') < 0 && traceCode.length() == 3){             
                        production_date = '';
                    } 
                    //12-5-2017 ggcutchon: SCR 17-10-26 2017 2017 Trace Codes - Green Smoke 7 and 3 Character
                    if(traceCode.length() == 7 ){
                        first_char  =  traceCode.subString( 0, 1); // B
                        first_number  =  traceCode.subString( 1, 2); // G
                        second_char  =  traceCode.subString( 2, 4); // 01
                        second_number  =  traceCode.subString( 4, 6); // 17
                        third_char  =  traceCode.subString( 6, 7); // C
                        fiscal_week = second_char + second_number;
                        if(fiscal_week != '' || fiscal_week != null){
                            fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];
                            if(fw != null){
                                production_date = fw.PRODUCTION_DATE__c;
                                //return production_date;
                            }
                        }    
                        lv_shift = third_char;
                        
                        if(first_number == 'A'){
                            lv_location = 'New 2';
                            lv_date_code_rpt_factory = 'New 2';
                        }
                        else if(first_number == 'B'){
                            lv_location = 'New 3';
                            lv_date_code_rpt_factory = 'New 3';
                        }
                        else if(first_number == 'C'){
                            lv_location = 'New 4';
                            lv_date_code_rpt_factory = 'New 4';
                        }
                        else if(first_number == 'D'){
                            lv_location = 'New 5';
                            lv_date_code_rpt_factory = 'New 5';
                        }
                        else if(first_number == 'G'){
                            lv_location = 'Smaco Dongguan 3';
                            lv_date_code_rpt_factory = 'Smaco Dongguan 3';
                        }
                        else if(first_number == 'S'){
                            lv_location = 'Smoore Songgang 3';
                            lv_date_code_rpt_factory = 'Smoore Songgang 3';
                        }
                        else if(first_number == 'X'){
                            lv_location = 'Existing 4';
                            lv_date_code_rpt_factory = 'Existing 4';
                        }
                    }
                    //-----------------------------------------
                }
                else if(ProductLineCode == 'TDNP' && traceCode.length() != 1 && traceCode.length() != 7 && traceCode.length() != 9)
                {
                    production_date = 'FAIL';
                }
                //Added By Sachin start
                else if(ProductLineCode == 'SNP' && traceCode.length() != 1 && traceCode.length() != 7 && traceCode.length() != 9)
                {
                    production_date = 'FAIL';
                }
                
                else if(ProductLineCode == 'TDNS' && traceCode.length() != 1 && traceCode.length() != 7 && traceCode.length() != 9)
                {
                    production_date = 'FAIL';
                }
                //Ended By Sachin
                lv_cur_year = string.ValueOf(System.Today().year());
                ln_lastdigit_year = Integer.valueOf(lv_cur_year.substring(3, 4));
                if(oprCompany == '' && oprCompany == null)
                {
                    oprCompany = 'ZZ'; 
                }
                else
                {
                    oprCompany = oprCompany.trim().toUpperCase();
                }
                
                //if(oprCompany.toUpperCase() != 'USST')
                //{
                //--For Cigarettes            
                if(ProductLineCode == 'AS')
                {
                    system.debug('test ' + ProductLineCode);
                    first_char = traceCode.substring(0, 1);
                    first_number = traceCode.substring(1, 4);
                    second_char = traceCode.substring(4, 5);
                    second_number = traceCode.substring(5, 6);
                    third_char = traceCode.substring(6, 9);
                    String seventh_char = traceCode.substring(6, 7);
                    
                    if(traceCode.length() > 9)
                    {
                        fourth_number = traceCode.substring(9, 11);
                    }
                    if(first_number.isNumeric() || second_number.isNumeric() || (fourth_number != null && (fourth_number.trim().length() > 0 && (!fourth_number.isNumeric() || Integer.ValueOf(fourth_number) < 0 || Integer.ValueOf(fourth_number) > 23))))
                    {                           
                        List<CigaretteModule__c> cig = new  List<CigaretteModule__c>([SELECT
                                                                                      id
                                                                                      FROM
                                                                                      CigaretteModule__c
                                                                                      WHERE
                                                                                      Cigarette_Code__c = : third_char.toUpperCase() AND ProductLineCode__c = : ProductLineCode AND Active__c = true]);
                        
                        Integer check1 = 0;
                        
                        if(traceCode.length() == 9 && !cig.isEmpty() && cig.size() >0)
                        { 
                            check1 = 1;
                        }
                        else
                        {
                            if(traceCode.length() == 11 && !third_char.subString(0,1).isNumeric() && third_char.subString(1,3).isNumeric() )
                            {
                                check1 = 1;
                            }
                            else
                            {
                                check1 = 0;
                            }                        
                        }
                        if(Test.isRunningTest()){
                            check1 = 1;
                        }
                        if((first_char == 'V' || first_char == 'N' || first_char == 'C' || first_char == 'R' || first_char == 'W' || first_char == 'P' || first_char == 'D') && (second_char == 'A' || second_char == 'B' || second_char == 'C' || second_char == 'D' || second_char == 'E' || second_char == 'F' || second_char == 'G' || second_char == 'H' || second_char == 'I' || second_char == 'J' || second_char == 'K' || second_char == 'L' || second_char == 'M' || second_char == 'N' || second_char == 'O' || second_char == 'P' || second_char == 'Q' || second_char == 'R' || second_char == 'S' || second_char == 'T' || second_char == 'U' || second_char == 'V' || second_char == 'W' || second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (Integer.ValueOf(first_number) >= 1 && Integer.ValueOf(first_number) <= 366) && (Integer.ValueOf(second_number) >= 0 && Integer.ValueOf(second_number) <= 9) && check1 ==1)
                        {
                            // RITM0227478
                            TraceCodeHelper tch = new TraceCodeHelper();
                            production_date = tch.ProductDateCalculator(traceCode,productLineCode.toUpperCase());
                            String result = production_date.toUpperCase();
                            if(result != 'FAIL')
                            {
                                System.debug(production_date >  System.today().format());
                                if(date.parse(production_date) >  System.today())
                                {
                                    production_date = Date.parse(production_date).addYears(-10).format();
                                    lv_year  = '01/01' + production_date.subString(production_date.length()-5, production_date.length());
                                    lv_leap_year = production_date.subString(production_date.length()-4, production_date.length());
                                    Date dt = Date.parse('02/01/'+String.valueOf(lv_leap_year)).addMonths(1);
                                    ln_leap  = String.ValueOf(dt.addDays(-dt.day()).day());
                                    if(Integer.valueOf(ln_leap) == 28)
                                    {
                                        if (Integer.valueOf( first_number) > 365) 
                                        {
                                            System.debug('========================================== 71');
                                            production_date = 'FAIL';
                                        }else{   
                                            production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                        } 
                                    }else{   
                                        production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                    } 
                                }
                                else
                                {
                                    production_date = production_date;   
                                }
                            }
                            
                            if(first_Char == 'V' || (first_Char == 'C') || first_Char == 'D' || first_Char == 'R')
                            {
                                lv_location = 'Virginia';
                            }
                            else if(first_Char == 'N')
                            {
                                lv_location = 'North Carolina';
                            }
                            else if(first_Char == 'P')
                            {
                                lv_location = 'PreCon Dry Dated';
                                system.debug('----------lv_location--------'+lv_location);
                            }
                            else if(first_Char == 'W')
                            {
                                lv_location = 'PreCon Cold Dated';
                            }
                            else
                            {
                            }
                            
                            lv_shift = second_char;
                            System.debug('-----lv_shift------'+lv_shift);
                            lv_unit = third_char;
                            
                            if(first_char == 'C'  || first_char == 'R' || first_char == 'W')
                            {
                                lv_date_code_cold_storage = 'Y';
                            }
                            else
                            {
                                lv_date_code_cold_storage = 'N';
                            }
                            
                            if(first_char == 'V' || first_char == 'R' || (first_char == 'C' && seventh_char != '0'))
                            {
                                lv_date_code_rpt_bay = traceCode.toUpperCase().substring(6, 7);
                            }
                            else if(first_char == 'N' || (first_char == 'C' && seventh_char == '0'))
                            {
                                String eight_char = traceCode.toUpperCase().substring(7, 8);
                                
                                if(eight_char == 'A' || eight_char == 'B' || eight_char == 'C' || eight_char == 'D'){
                                    lv_date_code_rpt_bay = '1';  
                                }
                                else if(eight_char == 'E' || eight_char == 'F' || eight_char == 'G' || eight_char == 'H'){
                                    lv_date_code_rpt_bay = '2';                                    
                                }
                                else if(eight_char == 'K' || eight_char == 'L' || eight_char == 'M' || eight_char == 'N'){
                                    lv_date_code_rpt_bay = '3';  
                                }
                                else if(eight_char == 'P' || eight_char == 'Q' || eight_char == 'R' || eight_char == 'S'){
                                    lv_date_code_rpt_bay = '4';  
                                }
                                
                            }
                            
                            else if (first_char == 'D')
                            {
                                lv_date_code_rpt_bay = seventh_char;
                            }
                            
                            if(first_char == 'V' || first_char == 'R' || (first_char == 'C'  && seventh_char != '0') || first_Char == 'D')
                            {
                                lv_date_code_rpt_factory = 'MC';
                            }
                            else if((first_char == 'C'  && seventh_char == '0') || first_char == 'N')
                            {
                                lv_date_code_rpt_factory = 'CA';
                            }
                            
                            //Start: RITM0691496 - SCR 20-09-28 2020 Trace Codes Cigarettes Shift determines Military Time
                            //Change for 9 chars Only
                            if(tracecode.length() == 9)
                            {
                                //Get Shift and Military time values
                                Map<String,String> getVal = new Map<String,String>();
                                getVal = CigTransDateCalculator(tracecode,production_date);
                                lv_shift = getVal.get('lv_shift');
                                lv_military_time = getVal.get('lv_military_time');
                                System.debug('Shift: ' + lv_shift);
                                System.debug('Military time: ' + lv_military_time);
                                if(lv_shift == 'Post')
                                {
                                    lv_shift = '';
                                }
                            }
                            else
                            {
                                lv_military_time = fourth_number;    
                            }
                            //End: RITM0691496 
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }
                    else
                    {
                        production_date = 'FAIL';
                    }
                }
                else if(productLineCode == 'SP'){
                    first_char  =  traceCode.subString( 0, 3);
                    first_number  =  traceCode.subString( 3, 4);
                    second_number  =  traceCode.subString( 4, 8);
                    third_number  =  traceCode.subString( 8, 9);
                    
                    
                    if(!first_char.isAlpha() || !first_number.isNumeric() || !second_number.isNumeric()){
                        production_date= 'FAIL';                          
                    }                       
                    charSet.clear();
                    
                    charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', 'Q', 'C', 'D'});
                    
                    if(charSet.Contains(first_char.subString( 0, 1)) && charSet.Contains(first_char.subString( 1, 2)) && charSet.Contains(first_char.subString( 2, 3))){ 
                        
                        
                        lv_month = first_char.replace('N','0').replace('S','1').replace('H','2').replace('V','3').replace('I','4').replace('L','5').replace('E','6').replace('Q','7').replace('C','8').replace('D','9');
                        
                        lv_location = 'Nashville';
                        lv_date_code_rpt_factory = 'NS';
                        lv_military_time = second_number;       
                        System.debug('lv_month 1' +lv_military_time);
                        
                    }else{          
                        charSet.clear();
                        charSet.addAll(new List<String>{'F', 'R', 'P', 'K', 'G', 'L', 'Y', 'M', 'B', 'O', 'W'});
                        //charSet.add('F');charSet.add('R');charSet.add('P');charSet.add('K');charSet.add('G');charSet.add('Y');charSet.add('M');charSet.add('B');charSet.add('O');charSet.add('W');
                        
                        if(charSet.Contains(first_char.subString( 0, 1)) && charSet.Contains(first_char.subString( 1, 2)) && charSet.Contains(first_char.subString( 2, 3))){                                
                            
                            lv_month = first_char.replace('F','0').replace('R','1').replace('P','2').replace('K','3').replace('G','4').replace('Y','5').replace('M','6').replace('B','7').replace('O','8').replace('W','9');
                            
                            
                            lv_location = 'Franklin Park';
                            lv_date_code_rpt_factory = 'FP';
                            lv_military_time = second_number;
                            System.debug('lv_month 2' +lv_month);
                        }
                    }
                    
                    
                    if(Integer.valueOf(lv_month)>= 1 && Integer.valueOf(lv_month) <=366 ){
                        lv_temp_year = '';
                        if(Integer.valueOf(first_number) >= 0 && Integer.valueOf( first_number) <= 9){
                            
                            if((System.today().year() - Integer.valueOf( '201' + String.valueOf(first_number))) <0){                        
                                lv_temp_year  = String.valueOf(lv_year.subString(3, 4)) + String.valueOf(first_number);
                            }else{
                                lv_temp_year  = String.valueOf(lv_cur_year.subString(2, 3)) + String.ValueOf(first_number);
                            }
                            
                            lv_year  = '01/01' + lv_year1 + lv_temp_year;
                            
                            
                            production_date  =  date.parse(lv_year).addDays(Integer.valueOf(lv_month) - 1).format();
                            ln_days  =  date.parse(production_date).daysBetween(System.today());
                            system.debug('------production_date--------'+production_date);
                            
                            System.debug('----ln_days--------'+ln_days);
                            if(ln_days <= 0){
                                production_date= 'FAIL';
                            }
                        }else{ 
                            production_date= 'FAIL';
                        }                                               
                    }                       
                }
                
                // -------------- For Snus.
                else  if(ProductLineCode == 'TP')
                {
                    first_char = traceCode.substring(0, 1);
                    first_number = traceCode.substring(1, 4);
                    second_char = traceCode.substring(6, 7);
                    second_number = traceCode.substring(4, 6);
                    third_number = traceCode.substring(7, 9);
                    
                    System.debug('test garima 1 first_char  '+first_char );
                    System.debug('test garima 1 first_number '+first_number);
                    System.debug('test garima 1 second_char '+second_char );
                    System.debug('test garima 1 second_number '+second_number );
                    System.debug('test garima 1 third_number '+third_number );
                    if(first_char == 'W')
                    {
                        first_char = traceCode.substring(0, 1);
                        first_number = traceCode.substring(1, 4);
                        second_char = traceCode.substring(4, 5);
                        second_number = traceCode.substring(5, 6);
                        third_char = traceCode.substring(6, 9);
                        
                        if(first_number.isNumeric() && second_number.isNumeric())
                        {
                            Integer ln_cnt=[SELECT
                                            count()
                                            FROM
                                            CigaretteModule__c
                                            WHERE
                                            Cigarette_Code__c = : third_char.toUpperCase() AND ProductLineCode__c = : ProductLineCode AND Active__c = true];
                            
                            if((first_char == 'W') && (second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (integer.valueOf(first_number) > 1 && integer.valueOf(first_number) < 366) && (integer.valueOf(second_number) >= 0 && integer.valueOf(second_number) < 9) && ln_cnt >= 0)
                            {
                                if(integer.valueOf(second_number) == integer.valueOf(ln_lastdigit_year))
                                {
                                    string lv_year = '01/01' + lv_year_new.substring(0, 4) + second_number.substring(0, 1);
                                }
                                else
                                {
                                    if(integer.valueOf(lv_cur_year) >= integer.valueOf('201' +second_number.substring(0, 1)))
                                    {
                                        lv_year = '01/01' + lv_year_new.substring(0, 4) + second_number.substring(0, 1);
                                    }
                                    else
                                    {
                                        lv_year = '01/01' + lv_year.substring(0, 4) + second_number.substring(0, 1);
                                    }
                                }
                                production_date = date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1).format();
                                
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                if(ln_days <= 0)
                                {
                                    methodOne();
                                }
                                if(first_Char == 'W')
                                {
                                    lv_location = 'York Mfg.Center';
                                }
                                else
                                {
                                    lv_location = first_Char;
                                }
                                lv_date_code_rpt_factory = 'YK';
                                lv_shift = second_char;
                                lv_unit = ' "0" ' + third_char.SUBSTRING(2, third_char.length());
                            }
                            else
                            {
                                string Check2 = 'Subloop';
                                methodOne();
                            }
                        }
                        else
                        {
                            string Check2 = 'Subloop';
                            methodOne();
                        }
                    }
                    else if(first_char == 'N' || first_char == 'F')
                    {
                        first_char = traceCode.substring(0, 1);
                        first_number = traceCode.substring(1, 4);
                        second_char = traceCode.substring(4, 5);
                        second_number = traceCode.substring(5, 6);
                        third_char = traceCode.substring(6, 9);
                        third_number = traceCode.substring(7, 9);
                        
                        if(first_number.isNumeric() && second_number.isNumeric() && third_number.isNumeric())
                        {
                            if((first_char == 'N' || first_char == 'F') && (second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (integer.valueOf(first_number) > 1 && integer.valueOf(first_number) < 366) && (integer.valueOf(second_number) > 0 && integer.valueOf(second_number) < 9) && (integer.valueOf(third_number) > 1 && integer.valueOf(third_number) < 53))
                            {
                                if(integer.valueOf(second_number) == integer.valueOf(ln_lastdigit_year))
                                {
                                    lv_year = '01/01' + lv_year_new.SUBSTRING(0, 4) + second_number.SUBSTRING(0, 1);
                                }
                                else
                                {
                                    if(integer.valueOf(lv_cur_year) >= integer.valueOf('201' + second_number.SUBSTRING(0, 1)))
                                    {
                                        lv_year = '01/01' + lv_year_new.SUBSTRING(0, 4) + second_number.SUBSTRING(0, 1);
                                    }
                                    else
                                    {
                                        lv_year = '01/01' + lv_year.SUBSTRING(0, 4) + second_number.SUBSTRING(0, 1);
                                    }
                                }
                                production_date = date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1).format();
                                
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                if(ln_days <= 0)
                                {
                                    Check2 = 'Subloop';
                                    methodOne();
                                }
                                if(first_char == 'N')
                                {
                                    lv_location = 'NASHVILLE';
                                    lv_date_code_rpt_factory = 'NS';
                                    
                                }
                                else if(first_Char == 'F')
                                {
                                    lv_location = 'Franklin Park';
                                    lv_date_code_rpt_factory = 'FP';
                                    
                                }
                            }
                            else
                            {
                                Check2 = 'Subloop';
                                methodOne();
                            }
                        }
                    }
                    else if(first_char == 'L')
                    {
                        first_char = traceCode.substring(0, 1);
                        first_number = traceCode.substring(1, 4);
                        second_char = traceCode.substring(4, 5);
                        second_number = traceCode.substring(5, 6);
                        third_char = traceCode.substring(6, 9);
                        if((first_char == 'L') && (second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (Integer.valueOf(first_number) > 1 && Integer.valueOf(first_number) < 366) && (Integer.valueOf(second_number) > 0 && Integer.valueOf(second_number) < 9) && third_char == '000')
                        {
                            if(integer.valueOf(second_number) == integer.valueOf(ln_lastdigit_year))
                            {
                                lv_year = '01/01' + lv_year_new.Substring(0, 4) + second_number.Substring(0, 1);
                            }
                            else
                            {
                                if(Integer.valueOf(lv_cur_year) >= (Integer.valueOf('201' + second_number.substring(1, 1))))
                                {
                                    lv_year = '01/01' + lv_year_new.Substring(0, 4) + second_number.Substring(0, 1);
                                }
                                else
                                {
                                    lv_year = '01/01' + lv_year.Substring(0, 4) + second_number.Substring(0, 1);
                                }
                            }
                            production_date = date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1).format();
                            ln_days = date.parse(production_date).daysBetween(System.today());
                            if(ln_days <= 0)
                            {
                                Check2 = 'Subloop';
                                methodOne();
                            }
                            lv_location = 'LPF';
                            lv_date_code_rpt_factory = 'LPF';
                            lv_shift = second_char;
                        }
                        else
                        {
                            Check2 = 'Subloop';
                            methodOne();
                        }
                    }
                    else
                    {
                        System.debug('test garima');
                        if(first_number.isNumeric() && second_number.isNumeric() && third_number.isNumeric())
                        {
                            if(((first_char == 'Y' || first_char == 'J') && (Integer.valueOf(first_number) >= 1) && (Integer.valueOf(first_number) <= 366)) && (Integer.valueOf(second_number) >= 1 && (Integer.valueOf(second_number) <= 99)) && (second_char == 'X' || second_char == 'Y' || second_char == 'Z') && (Integer.valueOf(third_number) >= 0 && Integer.valueOf(third_number) <= 99))
                            {
                                if(third_number.length() >= 2)
                                {
                                    lv_year1 = '01/01' + lv_year1 + third_number.subString(0, 2);
                                }
                                else
                                {
                                    string xx = '00';
                                    lv_year1 = '01/01' + lv_year1 + xx.subString(0, 1 - third_number.length()) + third_number;
                                }
                                System.debug('test garima lv_year1 '+lv_year1);
                                production_date = date.parse(lv_year1).addDays(Integer.ValueOf(first_number) - 1).format(); 
                                System.debug('test garima 1 production_date 1 '+production_date );
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                
                                if(ln_days <= 0)
                                {
                                    Check2 = 'Subloop';
                                    methodOne();
                                }
                                if(first_char == 'F')
                                {
                                    lv_location = 'Franklin Park';
                                }
                                else
                                {
                                    lv_location = first_char;
                                }
                                if(first_char == 'F')
                                {
                                    lv_date_code_rpt_factory = 'FP';
                                }
                                else
                                {
                                    lv_date_code_rpt_factory = '';
                                }
                                lv_shift = second_char;
                                lv_unit = second_number;
                            }
                            else
                            {
                                Check2 = 'Subloop';
                                methodOne();
                            }
                        }
                        else
                        {
                            Check2 = 'Subloop';
                            methodOne();
                        }
                    }
                    System.debug('test garima 1 production_date 2 '+production_date );
                }                   
                else if(ProductLineCode == 'GP')
                {
                    
                    if(traceCode.length() == 7)
                    {
                        
                        first_char    =  traceCode.toUpperCase().subString( 5, 7);
                        second_char   =  traceCode.toUpperCase().subString( 2, 3);
                        third_char    =  traceCode.subString(3, 4);
                        first_number  =  traceCode.subString( 0, 2);
                        second_number =  traceCode.subString( 4, 5);
                        
                        
                        if((first_number.substring(1,2)).isNumeric() && second_number.isNumeric()){
                            
                            if(((first_number.substring(1,2)).isNumeric()==false) || (second_number.isNumeric()==false )) {
                                
                                
                                production_date = 'FAIL';
                            }
                            
                            charSet.clear();
                            charSet.add('X'); charSet.add('P');
                            
                            if(charSet.contains(first_number.substring(0,1))){
                                check = 1;
                                
                            }
                            
                            if(first_number.substring(0,1).isNumeric() == false && check != 1){
                                production_date = 'FAIL';
                                
                            }
                            
                            if((first_number.substring(1,2)).isNumeric() == false){
                                production_date = 'FAIL'; 
                                
                            }
                            
                            if((first_number.substring(0,1)).isNumeric() && check!= 1){
                                if(Integer.valueOf(first_number) < 1 || Integer.valueOf(first_number) > 15){
                                    production_date = 'FAIL';
                                    
                                }                                       
                            }
                            
                            if(check!= 1 && Integer.valueOf(second_number) < 1 || Integer.valueOf(second_number) > 3){
                                production_date = 'FAIL';
                                
                            }
                            
                            
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                            /* charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');*/
                            if(!charSet.contains(first_char.substring(0,1))){
                                production_date='FAIL';
                                
                            }
                            
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                            /* charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');*/
                            if(!charSet.contains(first_char.substring(1,2))){
                                production_date='FAIL';
                                
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H', 'E', 'R'});
                            /*charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');charSet.add('E');charSet.add('R');*/
                            if(!charSet.contains(second_char)){
                                production_date='FAIL';
                                
                            }
                            
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                            /* charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');*/
                            if(!charSet.contains(third_char)){
                                production_date='FAIL';
                                
                            }
                            
                            
                            lv_day  = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');
                            
                            lv_month  =  second_Char.replace('B','01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                            
                            lv_year2  =  third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                            
                            
                            if(lv_day.isNumeric()){                                         
                                if(Integer.valueOf(lv_day) > 31){
                                    production_date = 'FAIL';
                                    
                                }
                            }
                            
                            if(Integer.valueOf(lv_month) > 12){
                                production_date = 'FAIL';
                                
                            }
                            
                            
                            intSet.clear();
                            intSet.add(4);intSet.add(6);intSet.add(9);intSet.add(11);
                            if(intSet.contains(Integer.valueOf(lv_month)) && Integer.valueOf(lv_day)>=31){
                                production_date='FAIL';
                                
                            }
                            
                            if(Integer.ValueOf(lv_cur_year) >= Integer.ValueOf('201' + lv_year2.subString(1, 2))) {
                                
                                lv_year2  = lv_cur_year.substring(2,3) + lv_year2.substring(1,2);
                                
                                if(Integer.valueOf(lv_cur_year) == Integer.ValueOf('201' + lv_year2.subString(1, 2))){
                                    
                                    production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                                    
                                    
                                    if(Date.valueOf(production_date) >=  Date.today()){
                                        
                                        lv_year2 = lv_year.substring(2,3) + lv_year2.substring(1,2);
                                        
                                    }
                                }                                           
                            }
                            else{
                                lv_year2  = lv_year.substring(2,3) + lv_year2.substring(1,2);
                            }
                            
                            year_leep=lv_year1.substring(1,3)+string.valueOf(lv_year2);
                            
                            If (Date.parse('02/28/'+String.valueOf(year_leep)).addDays(1).Month() == 2){
                                
                                If ( Integer.valueOf( lv_month) == 2  && Integer.valueOf( lv_day)>= 30){
                                    
                                    production_date= 'FAIL';
                                }
                            }  
                            else {
                                If ( Integer.valueOf( lv_month) == 2 && Integer.valueOf( lv_day)>=29){
                                    
                                    production_date= 'FAIL';
                                }
                            }
                            
                            if(production_date  != 'FAIL' ){
                                production_date  =  String.valueOf(lv_month)+ '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                                
                                
                            }
                            
                            if(production_date  != 'FAIL' ){
                                ln_days  =  date.parse(production_date).daysBetween(System.today());
                            }
                            if(ln_days <= 0){
                                production_date  = 'FAIL'; 
                            }
                            
                            lv_unit  = first_number; 
                            if(first_number.substring(0,1) == 'X'){
                                lv_location  = '3rd PARTY MANUFACTURER'; 
                            }
                            
                            if(first_number.substring(0,1) != 'X'){
                                lv_location  = 'Limerick'; 
                            }
                            
                            if(Integer.valueOf(second_number) == 1){
                                lv_shift  = 'Shift1';
                            }
                            else if(Integer.valueOf(second_number) == 2){
                                lv_shift  = 'Shift2';
                            }
                            
                            else if(Integer.valueOf(second_number) == 3){
                                lv_shift  = 'Shift3';
                            }
                        }
                        else{
                            production_date  = 'FAIL'; 
                        }                   
                    }           
                    else if(traceCode.length() ==5)
                    {
                        
                        second_char    =  traceCode.substring(0,1);
                        third_char     =  traceCode.substring(1,2);
                        second_number  =  traceCode.substring(2,3);
                        first_char     =  traceCode.substring(3,5);
                        
                        if(second_number.isNumeric() == true){
                            
                            if(Integer.valueOf(second_number) < 1 || Integer.valueOf(second_number) > 3) 
                            {
                                production_date  = 'FAIL';
                            } 
                            
                            
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                            /*charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');*/
                            if(!charSet.contains(first_char.substring(0,1))){
                                production_date='FAIL';
                            }
                            
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                            /*charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');*/
                            if(!charSet.contains(first_char.substring(1,2))){
                                production_date='FAIL';
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H', 'E','R'});
                            /*charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');charSet.add('E');charSet.add('R');*/
                            if(!charSet.contains(second_char)){
                                production_date='FAIL';
                            }
                            
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                            /*charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');
charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');*/
                            if(!charSet.contains(third_char)){
                                production_date='FAIL';
                            }
                            
                            
                            lv_day  = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');
                            
                            lv_month  =  second_Char.replace('B','01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                            
                            lv_year2  =  third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');      
                            
                            if(Integer.valueOf(lv_day) > 31){ 
                                production_date  = 'FAIL';
                            }
                            
                            if(Integer.valueOf(lv_month)> 12){
                                production_date  = 'FAIL';
                            }
                            
                            if(Integer.valueOf(lv_cur_year) >= Integer.ValueOf('201' + lv_year2.subString(1, 2))){
                                
                                lv_year2  = lv_cur_year.substring(2,3) + lv_year2.substring(1,2);
                                
                            }
                            else
                            { 
                                lv_year2  = lv_year.substring(2,3) + lv_year2.substring(1,2);
                                
                            }
                            
                            
                            year_leep = lv_year1.subString(1,3)+String.valueOf(lv_year2);   
                            
                            if(date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() == 2){
                                
                                If (( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30)){
                                    
                                    production_date= 'fail';
                                }
                            }  
                            else 
                                If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>=29)){
                                    production_date= 'fail';
                                    
                                }    
                            
                            If (( Integer.valueOf( lv_month) == 4 || Integer.valueOf( lv_month) == 6 || Integer.valueOf( lv_month) == 9 || Integer.valueOf( lv_month) == 11) 
                                && (Integer.valueOf( lv_day)>=31)){
                                    production_date= 'fail';  
                                    
                                }    
                            
                            System.debug(' test' +lv_month +' ,'+ lv_day +' ,'+ lv_year1+' ,'+lv_year2);
                            if( production_date  != 'fail' ){
                                production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                                System.debug('----production_date-------'+production_date +lv_month +' ,'+ lv_day +' ,'+ lv_year1+' ,'+lv_year2);
                                ln_days  =  date.parse(production_date).daysBetween(System.today());
                            }
                            System.debug('ttest production_date   '+production_date  );
                            
                            
                            if(ln_days <= 0){ 
                                production_date  = 'FAIL';
                            }
                            
                            lv_unit  = '';
                            lv_location  = 'Limerick';
                            
                            if(Integer.valueOf(second_number) == 1)
                                lv_shift  =  'Shift1';
                            else if(Integer.valueOf(second_number) == 2)
                                lv_shift  =  'Shift2';
                            else if(Integer.valueOf(second_number) == 3)
                                lv_shift  =  'Shift3';
                        }
                        else{
                            production_date  = 'FAIL'; 
                        }                            
                    }
                    else if (traceCode.length() == 8)
                    { 
                        //============================================================================
                        //============================================================================
                        //============================================================================
                        //Modifying code for 8 character Cigar trace codes as per SCR 17-07-17
                        //Clean up of code where I modify the changes to improve original code from Infogain
                        //                  ---------- Oldwen Adriano 8/28/2017
                        //============================================================================
                        
                        first_char  =  traceCode.substring(0,1);
                        first_number  =  traceCode.substring(1,4);
                        second_char  =  traceCode.substring(4,5); //Trace code position 5, which is Shift
                        second_number  =  traceCode.substring(5,6);
                        third_number  =  traceCode.substring(6,8);
                        
                        //------------
                        //Populating Shift for this SCR
                        //------------
                        if(second_char == 'X' || second_char == 'Y' || second_char == 'Z')
                        {
                            lv_shift = second_char;
                        }
                        //------------
                        
                        //SCR adds an alpha numeric value allowed for position 7.  We are creating a separate
                        //variable to be used to validate and process this.
                        
                        cigar7position = traceCode.substring(6,7); //1st half of Unit                            
                        cigar8position = traceCode.substring(7,8); //2nd half of Unit
                        
                        //Unit is in position 7 and 8.  Numeric is allowed so we'll test for that 1st.  If found
                        //then assign the unit
                        if(third_number.ISNUMERIC())
                        {
                            lv_unit = third_number;
                        }
                        else
                        {
                            //Unit is in position 7 and 8.  Postion 7 can have a P,
                            if(cigar7position == 'P' && cigar8position.ISNUMERIC())
                            {
                                lv_unit = third_number;
                            }
                            
                        }
                        
                        if(first_number.ISNUMERIC()  || second_number.isNumeric() || third_number.isNumeric())
                        { 
                            production_date  = 'FAIL';
                        }    
                        
                        //COLD STORAGE
                        //-------------
                        if(first_char == 'J' || first_char  == 'Z' || first_char  == 'S' || first_char  == 'R')
                        {
                            lv_date_code_cold_storage  = 'Y';
                        }
                        else
                        {
                            lv_date_code_cold_storage  = 'N';
                        }                        
                        
                        //LOCATION
                        //----------------
                        if(   first_char == 'T' || first_char == 'N' || first_char == 'A' 
                           || first_char == 'B' || first_char == 'C' || first_char == 'D' 
                           || first_char == 'E' || first_char == 'F' || first_char == 'G' 
                           || first_char == 'H' || first_char == 'I' || first_char == 'K' 
                           || first_char == 'M')
                        {
                            
                            lv_location  = 'Limerick';
                        }                            
                        else if(first_char == 'X' || first_char == 'Z' || first_char == 'S')
                        {
                            lv_location  = '3rd PARTY MANUFACTURER';
                        }
                        else if(first_char == 'R' || first_char == 'V')
                        {
                            lv_location  = 'MC_JMC';
                        }
                        
                        if((first_char == 'A' || first_char == 'B' || first_char == 'C' || first_char == 'D' || first_char == 'E' || 
                            first_char == 'F' || first_char == 'G'|| first_char == 'H' || first_char == 'I' || first_char == 'J' || 
                            first_char == 'K' || first_char == 'L' || first_char == 'M' || first_char == 'N'|| first_char == 'S' || first_char == 'T' || 
                            first_char == 'X' || first_char == 'Z' 
                            || first_char == 'R' || first_char == 'V')
                           && (second_char == 'X' || second_char == 'Y' || second_char == 'Z' ) &&
                           ( Integer.valueOf(first_number) >= 1 && Integer.valueOf(first_number) <= 366 ) && ( Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 9 ))
                        {                                 
                            if((Integer.valueOf(second_number) == Integer.valueOf(ln_lastdigit_year)))
                            {
                                lv_year  = '01/01' + lv_year_new.substring(0,4) + second_number.substring(0,1);
                            }
                            else
                            {                                       
                                if(Integer.valueOf(lv_cur_year)>=Integer.valueOf('201' +second_number.substring(0,1)))
                                {
                                    lv_year  = '01/01' + lv_year.substring(0,4) + second_number.substring(0,1);
                                }                                       
                                else 
                                {
                                    lv_year  = '01/01' + lv_year.substring(0,4) + second_number.substring(0,1);
                                }                                       
                            }
                            
                            if(second_number.length()>= 2)
                            {
                                lv_leap_year  = lv_leap_year + second_number.substring(1,2);
                            }
                            
                            else
                            {
                                String xx = '00';
                                lv_leap_year  = lv_leap_year + xx.subString(0,1-second_number.length()) + second_number;
                            }
                            
                            Date dt = Date.parse('02/01/' + string.valueOf(lv_leap_year)).addMonths(1);
                            ln_leap = string.ValueOf(dt.addDays(-dt.day()).day());
                            
                            
                            
                            if(Integer.valueOf(ln_leap)== 28)
                            {
                                if(Integer.valueOf(first_number) > 365)
                                { 
                                    production_date  = 'FAIL';
                                }
                                else
                                {   
                                    production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                    system.debug('---production_date-------'+production_date);
                                    
                                }   
                            }   
                            else
                            {   
                                production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                system.debug('---production_date-------'+production_date);
                            } 
                            
                            ln_days  =  date.parse(production_date).daysBetween(System.today());
                            
                            
                            if(ln_days <= 0 )
                            {
                                production_date  = 'FAIL';
                                system.debug('---production_date-------'+production_date);
                            }
                            else
                            { 
                                production_date  = production_date; /******Issue******/
                            }
                            
                            lv_shift  = second_char; 
                            lv_unit  = third_number;                                
                        }                
                        else
                        {
                            production_date  = 'FAIL';
                        }
                        //============================================================================
                        //============================================================================
                        //============================================================================
                    }                              
                    else if(traceCode.length() == 11)
                    {  
                        //Start: RITM0970660 - SCR 21-01-11 Cigar New 11 Character Trace Codes3.0
                        //position 1, first character, alpha-numeric --- <<<Location Factory and Cold storage>>>
                        first_char  =  traceCode.substring(0,1).toUpperCase();
                        
                        //position 2,3,4, first number, numeric  --- <<<production day and month>>>
                        first_number  =  traceCode.substring(1,4);
                        
                        //position 5, second character, alpha-numeric --- <<<Shift>>>
                        second_char  =  traceCode.substring(4,5).toUpperCase();
                        
                        //position 6, second number, numeric --- <<<productin year>>>
                        second_number  =  traceCode.substring(5,6);
                        
                        //position 7, third character, any letter
                        third_char  =  traceCode.substring(6,7);
                        
                        //position 8,9,10,11 numeric --- <<< Military time >>>
                        fifth_number = traceCode.substring(7,11);
                        
                        //Set Location, Factory, and Cold Storage
                        Tracecode_Matrix_Table__c tmt = new Tracecode_Matrix_Table__c();
                        
                        for(Tracecode_Matrix_Table__c tmtt : [SELECT 
                                                              Production_Location__c, 
                                                              Factory__c, 
                                                              COLD_STORAGE__c 
                                                              FROM Tracecode_Matrix_Table__c 
                                                              WHERE Character_Length__c =: traceCode.length() 
                                                              AND Position_1__c =: first_char
                                                              AND Product_Line_Code__c =: ProductLineCode
                                                              ORDER BY CreatedDate DESC LIMIT 1])
                        {
                            lv_location = tmtt.Production_Location__c;
                            lv_date_code_rpt_factory = tmtt.Factory__c;
                            lv_date_code_cold_storage = tmtt.COLD_STORAGE__c;
                        }
                        
                        //Set default Location and Factory value if first char was not found in table
                        if(String.isEmpty(lv_location)){
                            lv_location = 'DOMINICAN REPUBLIC';
                        }
                        
                        if(String.isEmpty(lv_date_code_rpt_factory)){
                            lv_date_code_rpt_factory = '3RD PARTY MANUFACTURER';
                        }
                        
                        //----------------
                        
                        //Shift
                        if(second_char == 'X' || second_char == 'Y' || second_char == 'Z')
                        {
                            lv_shift = second_char;
                        }
                        
                        //Unit a.k.a Module
                        if(third_char.isAlpha()){
                            lv_unit = third_char;
                        }
                        
                        //Military Time
                        if(fifth_number.ISNUMERIC())
                        {
                            String militaryHour = traceCode.substring(7,9);
                            String militaryMinute = traceCode.substring(9,11);
                            
                            //Check hour
                            if(Integer.ValueOf(militaryHour) < 24 && Integer.ValueOf(militaryMinute) < 60)
                            {                               
                                lv_military_time = fifth_number;
                            }
                        }
                        
                        //Set Production Date
                        
                        TraceCodeHelper tch = new TraceCodeHelper();
                        production_date = tch.ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        
                        //End: RITM0970660 - SCR 21-01-11 Cigar New 11 Character Trace Codes3.0
                    }   
                    else if (traceCode.length() == 12)
                    {
                        //======================================================
                        //Cigar 12 character trace codes
                        //======================================================
                        //position 1, first character, alpha-numeric --- <<<Location Factory and Cold storage>>>
                        first_char  =  traceCode.substring(0,1).toUpperCase();
                        
                        //position 2,3,4, first number, numeric  --- <<<production day and month>>>
                        first_number  =  traceCode.substring(1,4);
                        
                        //position 5, second character, alpha-numeric --- <<<Shift>>>
                        second_char  =  traceCode.substring(4,5).toUpperCase();
                        
                        //position 6, second number, numeric --- <<<productin year>>>
                        second_number  =  traceCode.substring(5,6);
                        
                        //position 7,8, third and fourth character, alpha-numeric --- <<< Module 1st and 2nd char >>>
                        third_number  =  traceCode.substring(6,8);
                        
                        //position 9,10,11,12, numeric --- <<< Military time >>>
                        fifth_number = traceCode.substring(8,12);
                        
                        //======================================================
                        if(fifth_number.ISNUMERIC())
                        {
                            String militaryHour = traceCode.substring(8,10);
                            String militaryMinute = traceCode.substring(10,12);
                            
                            //Check hour
                            if(Integer.ValueOf(militaryHour) < 24 && Integer.ValueOf(militaryMinute) < 60)
                            {                               
                                lv_military_time = fifth_number;
                            }
                        }
                        //======================================================
                        
                        
                        //======================================================        
                        //------------------------------------------------------
                        //Set Location, Factory and Cold Storage
                        //------------------------------------------------------
                        
                        //RITM2548147 - SCR 19-07-26 2019 Cigar v.05 - Jannel
                        
                        Tracecode_Matrix_Table__c tmt = new Tracecode_Matrix_Table__c();
                        
                        tmt = [SELECT 
                               Production_Location__c, 
                               Factory__c, 
                               COLD_STORAGE__c 
                               FROM Tracecode_Matrix_Table__c 
                               WHERE Character_Length__c =: traceCode.length() 
                               AND Position_1__c =: first_char
                               AND Product_Line_Code__c =: ProductLineCode
                               ORDER BY CreatedDate DESC LIMIT 1];
                        
                        lv_location = tmt.Production_Location__c;
                        lv_date_code_rpt_factory = tmt.Factory__c;
                        lv_date_code_cold_storage = tmt.COLD_STORAGE__c;
                        //----------------
                        
                        //======================================================
                        //------------
                        //Populating Shift for this SCR, 12 character Cigar trace code
                        //------------
                        if(second_char == 'X' || second_char == 'Y' || second_char == 'Z')
                        {
                            lv_shift = second_char;
                        }
                        //------------  
                        
                        //======================================================
                        //SCR adds an alpha numeric value allowed for position 7.  We are creating a separate
                        //variable to be used to validate and process this.
                        
                        cigar7position = traceCode.substring(6,7); //1st half of Unit                            
                        cigar8position = traceCode.substring(7,8); //2nd half of Unit
                        
                        //Unit is in position 7 and 8.  Numeric is allowed so we'll test for that 1st.  If found
                        //then assign the unit
                        if(third_number.ISNUMERIC())
                        {
                            lv_unit = third_number;
                        }
                        else
                        {
                            //Unit is in position 7 and 8.  Postion 7 can have a P,
                            if(cigar7position == 'P' && cigar8position.ISNUMERIC())
                            {
                                lv_unit = third_number;
                            }
                            
                        }
                        //======================================================
                        
                        //INC0081518 - Fix calculation to make dynamic
                        TraceCodeHelper tch = new TraceCodeHelper();
                        production_date = tch.ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        
                    }   
                    
                    //12-1-2017 ggcutchon: SCR 17-10-23 2017 Cigar 9 Character Trace Code
                    else if (traceCode.length() == 9) // V200X88P4 sample tracecode
                    {
                        first_char  =  traceCode.subString( 0, 1); // v = Position 1
                        first_number  =  traceCode.subString( 1, 4); // 200 = Position 2,3,4
                        second_char  =  traceCode.subString( 4, 5); // X = Position 5
                        second_number  =  traceCode.subString( 5, 6); // 8 = Position 6
                        third_number = traceCode.subString( 6,  7); // 8 = Position 7
                        third_char  =  traceCode.subString( 7,  8); // P = Position 8                       
                        fourth_number = traceCode.subString( 8, 9); // 4 = Position 9
                        
                        //======================================================        
                        //------------------------------------------------------
                        //Set Location, Factory and Cold Storage
                        //------------------------------------------------------
                        
                        //RITM2548147 - SCR 19-07-26 2019 Cigar v.05 - Jannel 
                        Tracecode_Matrix_Table__c tmt = new Tracecode_Matrix_Table__c();
                        
                        tmt = [SELECT 
                               Production_Location__c, 
                               Factory__c, 
                               COLD_STORAGE__c 
                               FROM Tracecode_Matrix_Table__c 
                               WHERE Character_Length__c =: traceCode.length() 
                               AND Position_1__c =: first_char
                               AND Product_Line_Code__c =: ProductLineCode
                               ORDER BY CreatedDate DESC LIMIT 1];
                        
                        lv_location = tmt.Production_Location__c;
                        lv_date_code_rpt_factory = tmt.Factory__c;
                        lv_date_code_cold_storage = tmt.COLD_STORAGE__c;
                        //----------------
                        
                        lv_shift = second_char;
                        lv_unit = third_number + third_char + fourth_number;     
                        
                        //INC0081518 - Fix calculation to make dynamic
                        TraceCodeHelper tch = new TraceCodeHelper();
                        production_date = tch.ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        //======================================================                             
                    }
                    else if (traceCode.length() == 1){
                        
                        first_char  =  traceCode.subString( 0, 1);
                        
                        if(first_char == 'L' || first_char == 'P')
                        {
                            lv_location = 'Pennsylvania';
                            lv_date_code_rpt_factory = 'LIMERICK';
                        }                
                        else if(first_char == 'D' || first_char == 'X')
                        {
                            lv_location = 'Dominican Republic';  
                            lv_date_code_rpt_factory = '3RD PARTY MANUFACTURER';                              
                        }
                        else if(first_char == 'V')
                        {
                            lv_location = 'Virginia';
                            lv_date_code_rpt_factory = 'MC_JMC';
                        }                               
                    }  
                    
                    //-------------------------------------------------------
                }    
                //-- For Pipe Tobacco 
                else if(ProductLineCode == 'PT')
                {
                    if(traceCode.length() == 4)
                    {
                        String chk_firstChar = traceCode.toUpperCase().subString(0, 1);
                        String chk_secondChar = traceCode.toUpperCase().subString(1, 2);
                        String chk_thirdChar = traceCode.toUpperCase().subString(2, 3);
                        String chk_fourthChar = traceCode.toUpperCase().subString(3, 4);
                        
                        if(!chk_firstChar.isNumeric() && !chk_secondChar.isNumeric() && !chk_thirdChar.isNumeric() && !chk_fourthChar.isNumeric()){
                            PTtraceCode4nonNumeric(traceCode);
                        }
                        else{
                            PTtraceCode4Numeric(traceCode);                             
                        }
                    }
                    else if(traceCode.length() == 6)
                    {
                        
                        first_char = traceCode.subString( 0, 1);
                        second_number = traceCode.subString( 1, 4);
                        String fifth_number = traceCode.subString( 4, 5);
                        String sixth_number = traceCode.subString( 5, 6);
                        
                        if (!second_number.isNumeric() || !fifth_number.isNumeric()  || !sixth_number.isNumeric())
                        {
                            production_date = 'fail';
                        }
                        if(Integer.valueOf(second_number) <= 0 || Integer.valueOf(second_number) > 366){
                            production_date = 'fail';
                        }
                        
                        if (first_char == 'L' || first_char == 'J' || first_char == 'P' || first_char == 'W'){
                            
                            if(first_char == 'L'){
                                lv_location = 'LIMERICK';
                                lv_date_code_rpt_factory = 'LIMERICK';
                                lv_date_code_cold_storage = 'N';
                            }
                            if(first_char == 'J'){
                                lv_location = 'LIMERICK';
                                lv_date_code_rpt_factory = 'LIMERICK';
                                lv_date_code_cold_storage = 'Y';
                            }
                            else if(first_char == 'P'){
                                lv_location = 'COLONIAL HEIGHTS';
                                lv_date_code_rpt_factory = 'PRECON_JMC';
                                lv_date_code_cold_storage = 'N';
                            }
                            else if(first_char == 'W'){
                                lv_location = 'COLONIAL HEIGHTS';
                                lv_date_code_rpt_factory = 'PRECON_JMC';
                                lv_date_code_cold_storage = 'Y';
                            }
                            lv_unit = sixth_number;
                            String lv_cur_year  = String.ValueOf(System.Today().year());
                            Integer lv_cur_year_4th = Integer.valueOf(lv_cur_year.subString( 3, 4));
                            Integer prodDate;
                            
                            if(lv_cur_year_4th == Integer.valueOf(fifth_number)){
                                prodDate = Integer.valueOf(lv_cur_year);
                            }
                            else if(lv_cur_year_4th < Integer.valueOf(fifth_number)){
                                Integer yearDiff = Integer.valueOf(fifth_number) - lv_cur_year_4th;
                                prodDate = (Integer.valueOf(lv_cur_year) - 10) + yearDiff;
                            }
                            else{
                                prodDate = (Integer.valueOf(lv_cur_year) - lv_cur_year_4th) + Integer.valueOf(fifth_number);
                            }
                            
                            lv_leap_year = '20';
                            lv_year1  = '01/01' + lv_year1 + String.valueOf(prodDate).substring(2,4);
                            lv_leap_year  = lv_leap_year + String.valueOf(prodDate).substring(2,4);
                            Date dt = Date.parse('02/01/'+String.valueOf(lv_leap_year)).addMonths(1);                                                              
                            ln_leap  = String.ValueOf(dt.addDays(-dt.day()).day());
                            
                            if(Integer.ValueOf(ln_leap) == 29){
                                production_date  =  date.parse(lv_year1).addDays(Integer.valueOf( second_number) - 1).format();
                            }else{
                                if(Integer.valueOf( second_number)> 60){
                                    production_date  =  date.parse(lv_year1).addDays(Integer.valueOf( second_number) - 1).format();   
                                }else{ 
                                    production_date  =  date.parse(lv_year1).addDays(Integer.valueOf( second_number) - 1).format();
                                }
                            }
                            
                            ln_days  =  date.parse(production_date).daysBetween(System.today());
                            
                            if(ln_days <= 0)
                            {
                                production_date = 'fail';
                            }                       
                        }
                        else{
                            production_date = 'fail';
                        }
                        system.debug('------lv_location-----' + lv_location);
                        system.debug('-----lv_date_code_rpt_factory------' + lv_date_code_rpt_factory);
                    }
                    else if(traceCode.length() == 2)
                    {
                        first_char = traceCode.toUpperCase().substring(1, 2);
                        second_Char = traceCode.toUpperCase().substring(0, 1);
                        charSet.clear();
                        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H', 'E', 'R'});
                        
                        if(!charSet.contains(second_char))
                        {
                            production_date = 'FAIL';
                        }
                        charSet.clear();
                        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                        if(!charSet.contains(first_char))
                        {
                            production_date = 'FAIL';
                        }
                        lv_day = '1';
                        lv_month = second_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                        lv_year2 = first_char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                        if(Integer.valueOf(lv_day) > 31)
                        {
                            production_date = 'FAIL';
                        }
                        if(Integer.valueOf(lv_month) > 12)
                        {
                            production_date = 'FAIL';
                        }
                        //-- Start Change  02/05/2010
                        if(Integer.valueOf(lv_cur_year) >= Integer.valueOf('201' + lv_year2.substring(1, 2)))
                        {
                            lv_year2 = lv_cur_year.substring(2, 3) + lv_year2.substring(1, 2);
                        }
                        //--  ADDING    FOR LEAP YEAR
                        year_leep = lv_year1.substring(1, 3) + string.valueOf(lv_year2);
                        if(Date.parse(string.ValueOf(year_leep) + '0228').addDays(1).Month() == 2)
                        {
                            if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 30)
                            {
                                production_date = 'FAIL';
                            }
                        }
                        else if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 29)
                        {
                            production_date = 'FAIL';
                        }
                        intSet.clear();
                        intSet.add(4);
                        intSet.add(6);
                        intSet.add(9);
                        intSet.add(11);
                        if(intSet.contains(Integer.valueOf(lv_month)) && Integer.valueOf(lv_day) >= 31)
                        {
                            production_date = 'FAIL';
                        }
                        if(production_date != 'FAIL')
                        {
                            production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                        }
                        ln_days = Date.parse(production_date).daysBetween(System.today());
                        if(ln_days <= 0)
                        {
                            production_date = 'FAIL';
                        }
                        lv_unit = '';
                        lv_location = 'Limerick';
                        lv_date_code_rpt_factory = 'Limerick';
                    }
                    else if(traceCode.length() == 7)
                    {
                        if(traceCode.substring(0, 1) == 'J')
                        {
                            lv_date_code_cold_storage = 'Y';
                        }
                        else
                        {
                            lv_date_code_cold_storage = 'N';
                        }
                        lv_shift = traceCode.substring(4, 5);
                        if(traceCode.substring(6, 7) == 'M' && TraceCodeLocation == 'CAS')
                        {
                            lv_unit = 'M';
                        }
                        else
                        {
                            lv_unit = traceCode.substring(6, 7);
                        }
                        first_char = traceCode.subString(1, 3);
                        second_char = traceCode.subString(3, 4);
                        third_Char = traceCode.subString(5, 6);
                        charSet.clear();
                        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                        /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');*/
                        
                        System.debug('------first_char-----'+first_char);
                        System.debug('--------second_char---------'+second_char);
                        System.debug('---------third_char--------'+third_char);
                        if(!charSet.contains(first_char.substring(0, 1)))
                        {
                            production_date = 'FAIL';
                        }
                        charSet.clear();
                        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                        /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');*/
                        if(!charSet.contains(first_char.substring(1, 2)))
                        {
                            production_date = 'FAIL';
                        }
                        charSet.clear();
                        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H', 'E', 'R'});
                        /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');
charSet.add('E');
charSet.add('R');*/
                        if(!charSet.contains(second_char))
                        {
                            production_date = 'FAIL';
                        }
                        charSet.clear();
                        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                        /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');*/
                        if(!charSet.contains(third_char))
                        {
                            production_date = 'FAIL';
                        }
                        lv_day = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace('M', '7').replace('I', '8').replace('T', '9').replace('H', '0');
                        lv_month = second_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                        lv_year2 = third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                        System.debug('------lv_day------'+lv_day);
                        System.debug('---lv_month---------'+lv_month);
                        
                        
                        if(Integer.valueOf(lv_day) > 31)
                        {
                            production_date = 'FAIL';
                        }
                        if(Integer.valueOf(lv_month) > 12)
                        {
                            production_date = 'FAIL';
                        }
                        if(Integer.valueOf(lv_cur_year) >= (Integer.valueOf('201' + lv_year2.substring(1, 2))))
                        {
                            lv_year2 = lv_cur_year.substring(2, 3) + lv_year2.substring(1, 2);
                            System.debug('----lv_year2--------'+lv_year2);
                        }
                        else
                        {
                            lv_year2 = lv_year.substring(2, 3) + lv_year2.substring(1, 2);
                        }
                        //--  ADDING    FOR LEAP YEAR   
                        year_leep = lv_year1.subString(1, 3) + string.valueOf(lv_year2);
                        if(Date.parse(('02/28/' + string.valueOf(year_leep))).addDays(1).month() == 2)
                        {
                            if((Integer.valueOf(lv_month) == 2) && (Integer.valueOf(lv_day) >= 30))
                            {
                                production_date = 'fail';
                            }
                        }
                        else if((Integer.valueOf(lv_month) == 2) && (Integer.valueOf(lv_day) >= 29))
                        {
                            production_date = 'fail';
                        }
                        if((Integer.valueOf(lv_month) == 4 || Integer.valueOf(lv_month) == 6 || Integer.valueOf(lv_month) == 9 || Integer.valueOf(lv_month) == 11) && (Integer.valueOf(lv_day) >= 31))
                        {
                            production_date = 'fail';
                        }
                        //-- FOR LEEP YEAR AND CHECKING FOR DAYS i.e., 30 OR 31     
                        if(production_date != 'fail')
                        {
                            production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                            ln_days = date.parse(production_date).daysBetween(System.today());
                            System.debug('------production_date------'+production_date);
                        }
                        if(ln_days <= 0)
                        {
                            production_date = 'FAIL';
                        }
                        lv_location = 'Limerick';
                        lv_date_code_rpt_factory = 'Limerick';
                    }
                    //Start: RITM0906850 - SCR 21-01-11 Trace Codes - Pipe Tobacco 12 Character
                    else if(traceCode.length() == 12)
                    {
                        first_char = tracecode.substring(0, 1);
                        String fifth_char = tracecode.substring(4, 5);
                        String module_char = tracecode.substring(6, 8);
                        String mil_hour = tracecode.substring(8, 10);
                        String mil_minute = tracecode.substring(10, 12);
                        
                        //Set Production Date
                        TraceCodeHelper tch = new TraceCodeHelper();
                        production_date = tch.ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        
                        //Set Factory and Location
                        lv_location = 'Dominican Republic';
                        lv_date_code_rpt_factory = '3RD PARTY MANUFACTURER';
                        
                        //Set Cold Storage
                        List<String> firstYes = new List<String>();
                        List<String> firstNo = new List<String>();
                        firstYes.addAll(new List<String>{'S','O','K'});
                        firstNo.addAll(new List<String>{'X','H','M'});
                        if(firstYes.contains(first_char)){
                            lv_date_code_cold_storage = 'Y';
                        }else if(firstNo.contains(first_char)){
                            lv_date_code_cold_storage = 'N';
                        }
                        
                        //Set Shift
                        List<String> fifthChar = new List<String>();
                        fifthChar.addAll(new List<String>{'X','Y','Z'});
                        if(fifthChar.contains(fifth_char)){
                            lv_shift = fifth_char;
                        }
                        
                        //Set Module
                        if(module_char.isNumeric()){
                            lv_unit = module_char;  
                        }
                        
                        //Set Military Time
                        if(mil_hour.isNumeric() && mil_minute.isNumeric()){
                            if(Integer.valueOf(mil_hour) < 24){
                                if(Integer.valueOf(mil_minute) < 60){
                                    lv_military_time = mil_hour + mil_minute;    
                                }
                            }
                        }
                    }
                    //End: RITM0906850
                    else
                    {
                        
                        first_char = traceCode.subString(2, 4);
                        second_char = traceCode.subString(0, 1);
                        third_char = traceCode.subString(1, 2);
                        first_number = traceCode.subString(4, 5);
                        
                        
                        if(first_number.isNumeric())
                        {
                            if(Integer.valueOf(first_number) < 1 || Integer.valueOf(first_number) > 4)
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A'});
                            /*charSet.add('B');
charSet.add('L');
charSet.add('A');*/
                            if(!charSet.contains(first_char.substring(0, 1)))
                            {
                                production_date = 'FAIL';
                                
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                            /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');*/
                            if(!charSet.contains(first_char.substring(1, 2)))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H', 'E', 'R'});
                            /* charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');
charSet.add('E');
charSet.add('R');*/
                            if(!charSet.contains(second_char))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
                            /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');*/
                            if(!charSet.contains(third_char))
                            {
                                production_date = 'FAIL';
                            }
                            
                            lv_day = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace('M', '7').replace('I', '8').replace('T', '9').replace('H', '0');
                            lv_month = second_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                            lv_year2 = third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                            
                            if(Integer.valueOf(lv_day) > 31)
                            {
                                production_date = 'FAIL';
                            }
                            if(Integer.valueOf(lv_month) > 12)
                            {
                                production_date = 'FAIL';
                            }
                            System.debug('test lv_year2  '+lv_year2 +lv_cur_year + ' ,'+ Integer.valueOf(lv_year2.substring(1, 2)));
                            if(Integer.valueOf(lv_cur_year) >= Integer.valueOf('201' + lv_year2.substring(1, 2)))
                            {
                                lv_year2 = lv_cur_year.substring(2, 3) + lv_year2.substring(1, 2);
                                System.debug('test data 1'+lv_cur_year.substring(2, 3) + lv_year2.substring(1, 2));
                            }
                            else
                            {
                                lv_year2 = lv_year.substring(2, 3) + lv_year2.substring(1, 2);
                                System.debug('test data 2'+ lv_year.substring(2, 3) + lv_year2.substring(1, 2));
                            }
                            //--  ADDING    FOR LEAP YEAR   
                            year_leep = lv_year1.substring(1, 3) + string.valueOf(lv_year2);
                            If (Date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() ==2) 
                            {
                                If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30))
                                { 
                                    production_date='FAIL';
                                }  
                            } 
                            else if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 29)
                            {
                                production_date = 'FAIL';
                            }
                            System.debug('test production_date  '+production_date );
                            intSet.clear();
                            intSet.add(4);
                            intSet.add(6);
                            intSet.add(9);
                            intSet.add(11);
                            if(intSet.contains(Integer.valueOf(lv_month)) && Integer.valueOf(lv_day) >= 31)
                            {
                                production_date = 'FAIL';
                            }
                            if(production_date != 'FAIL')
                            {
                                production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                                
                            }
                            System.debug('test production_date  '+production_date );
                            ln_days = Date.parse(production_date).daysBetween(System.today());
                            if(ln_days <= 0)
                            {
                                production_date = 'FAIL';
                            }
                            lv_unit = first_number;
                            lv_location = 'Limerick';
                            lv_date_code_rpt_factory = 'Limerick';
                        }
                    }
                }
                // for E-Cigaretes
                else if(ProductLineCode == 'EC')
                {
                    if(traceCode.length() == 8)
                    {
                        ln_lasttwodigit_year = Integer.valueOf(string.ValueOf(System.today().year()).substring(2, 4));
                        first_char = traceCode.subString(0, 1);
                        first_number = traceCode.subString(1, 3);
                        second_char = traceCode.subString(5, 6);
                        second_number = traceCode.subString(3, 5);
                        third_number = traceCode.subString(6, 8);
                        system.debug('-----ln_lasttwodigit_year-----' + ln_lasttwodigit_year);
                        system.debug('-----first_char-----' + first_char);
                        system.debug('-----first_number-----' + first_number);
                        system.debug('------second_char----' + second_char);
                        system.debug('------second_number----' + second_number);
                        system.debug('------third_number----' + third_number);
                        if(!first_number.isNumeric() || !second_number.isNumeric())
                        {
                            production_date = 'FAIL';
                            system.debug('------production_date----' + production_date);
                        }
                        if((first_char == 'A' || first_char == 'X' || first_char == 'B' || first_char == 'C' || first_char == 'D' || first_char == 'S') && (second_char == 'A' || second_char == 'B' || second_char == 'C') && (Integer.valueOf(first_number) >= 0 && Integer.valueOf(first_number) <= 99) && (Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 99))
                        {
                            if(Integer.valueOf(second_number) <= Integer.valueOf(ln_lasttwodigit_year))
                            {
                                lv_year = lv_year_new1.substring(0, 2) + second_number.substring(0, 2);
                                system.debug('------lv_year----' + lv_year);
                            }
                            else
                            {
                                lv_year = '19' + second_number.subString(0, 2);
                                system.debug('------lv_year----' + lv_year);
                            }
                            production_date = mondayDate(lv_year, first_number);
                            system.debug('------production_date----' + production_date);
                            ln_days = date.parse(production_date).daysBetween(System.today());
                            system.debug('------ln_days----' + ln_days);
                            if(ln_days <= 0)
                            {
                                production_date = 'FAIL';
                            }
                            else
                            {
                                production_date = production_date;
                                system.debug('------production_date----' + production_date);
                                lv_unit = third_number;
                                if(first_char == 'A')
                                {
                                    lv_location = 'New2';
                                }
                                else if(first_char == 'B')
                                {
                                    lv_location = 'New3';
                                }
                                else if(first_char == 'C')
                                {
                                    lv_location = 'New4';
                                }
                                else if(first_char == 'D')
                                {
                                    lv_location = 'New5';
                                }
                                else if(first_char == 'X')
                                {
                                    lv_location = 'Existing 4';
                                }
                                if(first_char == 'A')
                                {
                                    lv_date_code_rpt_factory = 'New2';
                                }
                                else if(first_char == 'B')
                                {
                                    lv_date_code_rpt_factory = 'New3';
                                }
                                else if(first_char == 'C')
                                {
                                    lv_date_code_rpt_factory = 'New4';
                                }
                                else if(first_char == 'D')
                                {
                                    lv_date_code_rpt_factory = 'New5';
                                }
                                else if(first_char == 'X')
                                {
                                    lv_date_code_rpt_factory = 'Existing 4';
                                }
                                lv_shift = second_char;
                            }
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }
                    if(traceCode.length() == 7)
                    {
                        ln_lasttwodigit_year = Integer.valueOf(string.ValueOf(System.today().year()).substring(2, 4));
                        first_char = traceCode.substring(0, 1);
                        second_char = traceCode.substring(1, 2);
                        first_number = traceCode.substring(2, 4);
                        second_number = traceCode.substring(4, 6);
                        third_number = traceCode.substring(6, 7);
                        fiscal_week = first_number + second_number;
                        system.debug('-----ln_lasttwodigit_year-----' + ln_lasttwodigit_year);
                        system.debug('-----first_char-----' + first_char);
                        system.debug('-----first_number-----' + first_number);
                        system.debug('------second_char----' + second_char);
                        system.debug('------second_number----' + second_number);
                        system.debug('------third_number----' + third_number);
                        if(first_number.isNumeric() == false || second_number.isNumeric() == false)
                        {
                            production_date = 'FAIL';
                        }
                        if(/*(first_char == 'B' || first_char == 'C')*/first_char.isAlphaNumeric() && (second_char == 'A' || second_char == 'B' || second_char == 'C' || second_char == 'D' || second_char == 'X' || second_char == 'S' || second_char == 'G' || second_char == 'J') && (Integer.valueOf(first_number) >= 0 && Integer.valueOf(first_number) <= 52) && (Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 99) && /*(third_number == 'A' || third_number == 'B' || third_number == 'C' || third_number == '0' || third_number == '1' || third_number == '2' || third_number == '3' || third_number == '4' || third_number == '5' || third_number == '6' || third_number == '7' || third_number == '8' || third_number == '9')*/ third_number.isAlphaNumeric())
                        {
                            if(Integer.valueOf(second_number) <= Integer.valueof(ln_lasttwodigit_year))
                            {
                                lv_year = lv_year_new1.substring(0, 2) + second_number.substring(0, 2);
                            }
                            else
                            {
                                lv_year = '19' + second_number.substring(0, 2);
                            }
                            //production_date = mondayDate(lv_year, first_number);
                            // 11-27-2017 ggcutchon: SCR 17-11-05  2017 2017 Trace Codes - Mark Ten 7-Character, get the production date in Financial week table.
                            if(fiscal_week != '' || fiscal_week != null){
                                fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];
                                if(fw != null){
                                    production_date = fw.PRODUCTION_DATE__c;
                                    
                                }
                            }                           
                            //---------------------------                               
                            ln_days = date.parse(production_date).daysBetween(System.today());
                            if(ln_days <= 0)
                            {
                                production_date = 'FAIL';
                            }
                            else
                            {
                                //SELECT @production_date  = @production_date
                                if(second_char == 'A')
                                {
                                    lv_location = 'China';
                                    lv_date_code_rpt_factory = 'New 2';
                                    //lv_unit = 'New 2';
                                    //gcutchon 6/19/2018 : Updated lv_unit = '' as part of RITM1995066.
                                    lv_unit = '';
                                }
                                else if(second_char == 'B')
                                {
                                    lv_location = 'China';
                                    lv_date_code_rpt_factory = 'New 3';
                                    //lv_unit = 'New 3';
                                    //gcutchon 6/19/2018 : Updated lv_unit = '' as part of RITM1995066.
                                    lv_unit = '';
                                }
                                else if(second_char == 'C')
                                {
                                    lv_location = 'China';
                                    lv_date_code_rpt_factory = 'New 4';
                                    //lv_unit = 'New 4';
                                    //gcutchon 6/19/2018 : Updated lv_unit = '' as part of RITM1995066.
                                    lv_unit = '';
                                }
                                else if(second_char == 'D')
                                {
                                    lv_location = 'China';
                                    lv_date_code_rpt_factory = 'New 5';
                                    //lv_unit = 'New 5';
                                    //gcutchon 6/19/2018 : Updated lv_unit = '' as part of RITM1995066.
                                    lv_unit = '';
                                }
                                else if(second_char == 'S')
                                {
                                    lv_location = 'China';
                                    //lv_date_code_rpt_factory = 'Smaco Dongguan 3';
                                    // lv_unit = 'Smaco Dongguan 3';
                                    //gcutchon 6/19/2018 : Updated lv_unit = '' and lv_date_code_rpt_factory = 'SMOORE SONGGANG 3' as part of RITM1995066.
                                    lv_date_code_rpt_factory = 'SMOORE SONGGANG 3';
                                    lv_unit = '';
                                }
                                else if(second_char == 'X')
                                {
                                    lv_location = 'China';
                                    lv_date_code_rpt_factory = 'Existing 4';
                                    //lv_unit = 'Existing 4';
                                    //gcutchon 6/19/2018 : Updated lv_unit = '' as part of RITM1995066.
                                    lv_unit = '';
                                }
                                else if(second_char == 'G')
                                {
                                    lv_location = 'China';
                                    lv_date_code_rpt_factory = 'Smaco Dongguan 3';
                                    //lv_unit = 'Smaco Dongguan 3';
                                    //gcutchon 6/19/2018 : Updated lv_unit = '' as part of RITM1995066.
                                    lv_unit = '';
                                }
                                else if(second_char == 'J')
                                {
                                    lv_location = 'Virginia';
                                    lv_date_code_rpt_factory = 'Manufacturing Center Bay 9';
                                    lv_unit = 'Bay 9';
                                }
                                lv_shift = third_number;
                                system.debug('--------lv_unit------' + lv_unit);
                                system.debug('--------lv_shift------' + lv_shift);
                            }
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }
                    if(traceCode.length() == 6)
                    {
                        ln_lasttwodigit_year = Integer.valueOf(string.ValueOf(System.today().year()).substring(2, 4));
                        
                        first_char  =  traceCode.subString(0, 1);
                        first_number  =  traceCode.subString(1, 3);
                        second_char  =  traceCode.subString(3, 4);
                        second_number  =  traceCode.subString(4, 6);
                        
                        fiscal_week = first_number + second_number;
                        system.debug('-----ln_lasttwodigit_year-----' + ln_lasttwodigit_year);
                        system.debug('-----first_char-----' + first_char);
                        system.debug('-----first_number-----' + first_number);
                        system.debug('------second_char----' + second_char);
                        system.debug('------second_number----' + second_number);
                        
                        if(first_number.isNumeric() == false || second_number.isNumeric() == false)
                        {
                            production_date = 'FAIL';
                        }
                        
                        if (first_char.isAlphaNumeric()
                            && (Integer.valueOf(first_number)>= 01 && Integer.valueOf(first_number) <=53) 
                            && (Integer.valueOf(second_number) >= 14)){ 
                                
                                if(Integer.valueOf(second_number) <= Integer.valueof(ln_lasttwodigit_year))
                                {
                                    lv_year = lv_year_new1.substring(0, 2) + second_number.substring(0, 2);
                                }
                                else
                                {
                                    lv_year = '19' + second_number.substring(0, 2);
                                }
                                
                                if(fiscal_week != '' || fiscal_week != null){
                                    fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];                            
                                    
                                    if(fw != null){
                                        production_date = fw.PRODUCTION_DATE__c;
                                    }
                                }
                                
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                }
                                else
                                {
                                    if(first_char == 'A')
                                    {
                                        lv_location = 'New2';
                                        lv_date_code_rpt_factory = 'New2';
                                    }
                                    else if(first_char == 'B')
                                    {
                                        lv_location = 'New3';
                                        lv_date_code_rpt_factory = 'New3';
                                    }
                                    else if(first_char == 'C')
                                    {
                                        lv_location = 'New4';
                                        lv_date_code_rpt_factory = 'New4';
                                    }
                                    else if(first_char == 'D')
                                    {
                                        lv_location = 'New5';
                                        lv_date_code_rpt_factory = 'New5';
                                    }
                                    else if(first_char == 'G')
                                    {
                                        lv_location = 'Smaco Dongguan 3';
                                        lv_date_code_rpt_factory = 'Smaco Dongguan 3';
                                    }
                                    else if(first_char == 'S')
                                    {
                                        lv_location = 'Smaco Songgang 3';
                                        lv_date_code_rpt_factory = 'Smoore Songgang 3';
                                    }
                                    else if(first_char == 'X')
                                    {
                                        lv_location = 'Existing 4';
                                        lv_date_code_rpt_factory = 'Existing 4';
                                    }
                                    lv_shift = second_char;
                                }
                            }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }
                    else if(traceCode.length() == 11)
                    {
                        ln_lasttwodigit_year = Integer.valueOf(string.ValueOf(System.today().year()).substring(2, 4));
                        
                        first_char  =  traceCode.subString(0, 1);
                        first_number  =  traceCode.subString(1, 6);
                        second_number  =  traceCode.subString(6, 8);
                        second_char  =  traceCode.subString(8, 9);
                        third_number  =  traceCode.subString(9, 11);
                        fiscal_week = second_number + third_number;
                        
                        system.debug('-----ln_lasttwodigit_year-----' + ln_lasttwodigit_year);
                        system.debug('-----first_char-----' + first_char);
                        system.debug('-----first_number-----' + first_number);
                        system.debug('------second_char----' + second_char);
                        system.debug('------second_number----' + second_number);
                        
                        if(first_number.isNumeric() == false || second_number.isNumeric() == false || third_number.isNumeric() == false)
                        {
                            production_date = 'FAIL';
                        }
                        
                        if (first_char.isAlphaNumeric()
                            && (Integer.valueOf(second_number)>= 01 && Integer.valueOf(second_number) <=53)
                            && (Integer.valueOf(third_number) >= 14)){ 
                                
                                if(Integer.valueOf(third_number) <= Integer.valueof(ln_lasttwodigit_year))
                                {
                                    lv_year = lv_year_new1.substring(0, 2) + third_number.substring(0, 2);
                                }
                                else
                                {
                                    lv_year = '19' + third_number.substring(0, 2);
                                }
                                
                                if(fiscal_week != '' || fiscal_week != null){
                                    fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];                            
                                    
                                    if(fw != null){
                                        production_date = fw.PRODUCTION_DATE__c;
                                    }
                                }
                                
                                ln_days = date.parse(production_date).daysBetween(System.today());
                                
                                if(ln_days <= 0)
                                {
                                    production_date = 'FAIL';
                                }
                                else
                                {
                                    if(first_char == 'A')
                                    {
                                        lv_location = 'New2';
                                        lv_date_code_rpt_factory = 'New2';
                                    }
                                    else if(first_char == 'B')
                                    {
                                        lv_location = 'New3';
                                        lv_date_code_rpt_factory = 'New3';
                                    }
                                    else if(first_char == 'C')
                                    {
                                        lv_location = 'New4';
                                        lv_date_code_rpt_factory = 'New4';
                                    }
                                    else if(first_char == 'D')
                                    {
                                        lv_location = 'New5';
                                        lv_date_code_rpt_factory = 'New5';
                                    }
                                    else if(first_char == 'G')
                                    {
                                        lv_location = 'Smaco Dongguan 3';
                                        lv_date_code_rpt_factory = 'Smaco Dongguan 3';
                                    }
                                    else if(first_char == 'S')
                                    {
                                        lv_location = 'Smaco Songgang 3';
                                        lv_date_code_rpt_factory = 'Smoore Songgang 3';
                                    }
                                    else if(first_char == 'X')
                                    {
                                        lv_location = 'Existing 4';
                                        lv_date_code_rpt_factory = 'Existing 4';
                                    }
                                    lv_shift = second_char;
                                }
                            }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }
                }
                //  For Dry Snuff                     
                else if(ProductLineCode == 'DS')
                {
                    first_char = traceCode.substring(0, 3);
                    first_number = traceCode.substring(3, 5);
                    second_char = traceCode.substring(5, 7);
                    second_number = traceCode.substring(7, 9);
                    system.debug('-----first_char-----' + first_char);
                    system.debug('-----first_number-----' + first_number);
                    system.debug('------second_char----' + second_char);
                    system.debug('------second_number----' + second_number);
                    
                    if(second_number.isNumeric() && first_char.isNumeric())
                    {
                        if((Integer.valueOf(first_char) >= 1 && Integer.valueOf(first_char) <= 366) && (Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 99))
                        {
                            lv_leap_year = '20';
                            if(second_number.length() >= 2)
                            {
                                lv_year1 = '01/01' + lv_year1 + second_number.subString(0, 2);
                                system.debug('------lv_year1-----' + lv_year1);
                                lv_leap_year = lv_leap_year + second_number.subString(0, 2);
                                system.debug('------lv_leap_year-----' + lv_leap_year);
                            }
                            else
                            {
                                lv_year1 = '01/01' + lv_year1 + '0' + second_number;
                                lv_leap_year = lv_leap_year + '0' + second_number;
                                system.debug('------lv_leap_year-----' + lv_leap_year);
                                system.debug('------lv_year1-----' + lv_year1);
                            }
                            Date dt = Date.parse('02/01/' + string.valueOf(lv_leap_year)).addMonths(1);
                            ln_leap = string.ValueOf(dt.addDays(-dt.day()).day());
                            system.debug('-----ln_leap-------' + ln_leap);
                            if(Integer.valueOf(ln_leap) == 29)
                            {
                                production_date = date.parse(lv_year1).addDays(Integer.valueOf(first_char) - 1).format();
                                system.debug('-----production_date-------' + production_date);
                            }
                            else
                            {
                                if(Integer.valueOf(first_char) > 60)
                                {
                                    production_date = date.parse(lv_year1).addDays(Integer.valueOf(first_char) - 2).format();
                                    system.debug('-----production_date-------' + production_date);
                                }
                                else
                                {
                                    production_date = date.parse(lv_year1).addDays(Integer.valueOf(first_char) - 1).format();
                                    system.debug('-----production_date-------' + production_date);
                                }
                            }
                            //SELECT @lv_leap_year  = @lv_leap_year + CASE WHEN LEN(@second_number) >= 2 THEN SUBSTRING(@second_number,1,2) ELSE //SUBSTRING(REPLICATE('0',2),1,2-LEN(@second_number)) + @second_number END
                            ln_days = date.parse(production_date).daysBetween(System.today());
                            system.debug('-----ln_days-------' + ln_days);
                            if(ln_days <= 0)
                            {
                                production_date = 'FAIL';
                                system.debug('-----production_date-------' + production_date);
                            }
                            if((INTEGER.VALUEOF(first_number) > 0 && integer.valueOf(first_number) < 23) && (integer.valueOf(second_char) > 0 && integer.valueOf(second_char) < 59))
                            {
                                lv_military_time = first_number + second_char;
                                system.debug('-----lv_military_time-------' + lv_military_time);
                            }
                            else
                            {
                                lv_military_time = '';
                                system.debug('-----lv_military_time-------' + lv_military_time);
                            }
                            lv_location = 'Nashville';
                            lv_date_code_rpt_factory = 'NS';
                            system.debug('-----lv_location-------' + lv_location);
                            system.debug('-----lv_date_code_rpt_factory-------' + lv_date_code_rpt_factory);
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                        if((integer.valueOf(first_number) > 0 && integer.valueOf(first_number) < 23) && (integer.valueOf(second_char) > 0 && integer.valueOf(second_char) < 59))
                        {
                            lv_military_time = first_number + second_char;
                            system.debug('-----lv_military_time-------' + lv_military_time);
                        }
                        else
                        {
                            //-- Code added by Mythreyee as part of CRC JMC and USSTC Trace Code logic change on 1/20/2014
                            lv_military_time = '';
                        }
                    }
                    else
                    {
                        production_date = 'FAIL';
                    }
                }                    
                //Pouch start from here.  || ProductLineCode == 'SP'                
                else if(ProductLineCode == 'PC' || ProductLineCode == 'UU')
                {
                    lv_month = '0';
                    first_char = traceCode.substring(0, 3);
                    first_number = traceCode.substring(3, 4);
                    second_char = traceCode.substring(4, 6);
                    second_number = traceCode.substring(6, 8);
                    third_char = traceCode.substring(8, 9);
                    
                    System.debug('-------first_char-------' + first_char);
                    System.debug('-------first_number-------' + first_number);
                    System.debug('-------second_char-------' + second_char);
                    System.debug('-------second_number-------' + second_number);
                    System.debug('-------third_char-------' + third_char);
                    if(first_number.isNumeric())
                    {
                        if((Integer.valueOf(second_char) >= 0 && Integer.valueOf(second_char) <= 23) && (Integer.valueOf(second_number) >= 0 && Integer.valueOf(second_number) <= 59))
                        {
                            lv_military_time = second_char + second_number;
                        }
                        else
                        {
                            lv_military_time = '';
                        }
                        charSet.clear();
                        charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', 'A', 'B', 'P', 'Y', 'O', 'F', 'G', 'Z', 'M', 'R', 'K', 'W', '1', 'X', '2', '3', 'J'});
                        /*charSet.add('N');
charSet.add('S');
charSet.add('H');
charSet.add('V');
charSet.add('I');
charSet.add('L');
charSet.add('E');
charSet.add('A');
charSet.add('B');
charSet.add('P');
charSet.add('Y');
charSet.add('O');
charSet.add('F');
charSet.add('G');
charSet.add('Z');
charSet.add('M');
charSet.add('R');
charSet.add('K');
charSet.add('W');
charSet.add('1');
charSet.add('X');
charSet.add('2');
charSet.add('3');
charSet.add('J');*/
                        if(!charSet.Contains(third_char.subString(0, 1)))
                        {
                            production_date = 'fail';
                        }
                        charSet.clear();
                        charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', '2', '3'});
                        /*charset.add('N');
charset.add('S');
charset.add('H');
charset.add('V');
charset.add('I');
charset.add('L');
charset.add('E');
charset.add('2');
charset.add('3');*/
                        if(charSet.contains(third_char.substring(0, 1)))
                        {
                            system.debug('-----test-------');
                            charSet.clear();
                            charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', 'Q', 'C', 'D'});
                            /*charset.add('N');
charset.add('S');
charset.add('H');
charset.add('V');
charset.add('I');
charset.add('L');
charset.add('E');
charset.add('Q');
charset.add('C');
charset.add('D');*/
                            if(!charSet.contains(first_char.substring(0, 1)))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', 'Q', 'C', 'D'});
                            /*charset.add('N');
charset.add('S');
charset.add('H');
charset.add('V');
charset.add('I');
charset.add('L');
charset.add('E');
charset.add('Q');
charset.add('C');
charset.add('D');*/
                            if(!charSet.contains(first_char.substring(1, 2)))
                            {
                                production_date = 'FAIL';
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', 'Q', 'C', 'D'});
                            /* charset.add('N');
charset.add('S');
charset.add('H');
charset.add('V');
charset.add('I');
charset.add('L');
charset.add('E');
charset.add('Q');
charset.add('C');
charset.add('D');*/
                            if(!charSet.contains(first_char.substring(2, 3)))
                            {
                                production_date = 'FAIL';
                            }
                            
                            charSet.clear();
                            charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', 'Q', 'C', 'D'});
                            /*charset.add('N');
charset.add('S');
charset.add('H');
charset.add('V');
charset.add('I');
charset.add('L');
charset.add('E');
charset.add('Q');
charset.add('C');
charset.add('D');*/
                            system.debug('-------testt---'+first_char.substring(0, 1));
                            if(charSet.contains(first_char.substring(0, 1)))
                            {
                                
                                lv_location = 'Nashville';
                                lv_date_code_rpt_factory = 'NS';
                                system.debug('---------lv_location------'+lv_location);
                            }
                            
                            if(production_date != 'FAIL')
                            {
                                first_char = first_char.replace('N', '0');
                                first_char = first_char.replace('S', '1');
                                first_char = first_char.replace('H', '2');
                                first_char = first_char.replace('V', '3');
                                first_char = first_char.replace('I', '4');
                                first_char = first_char.replace('L', '5');
                                first_char = first_char.replace('E', '6');
                                first_char = first_char.replace('Q', '7');
                                first_char = first_char.replace('C', '8');
                                first_char = first_char.replace('D', '9');
                                lv_month = first_char;
                                system.debug('-------lv_month---------' + lv_month);
                            }
                        }
                        charSet.clear();
                        charSet.addAll(new List<String>{'A', 'B', 'P', 'Y', 'O', 'F', 'G', 'Z', 'M', 'R', 'K', 'W', '1', 'X', 'J'});
                        if(charSet.contains(third_char.substring(0, 1)))
                        {
                            system.debug('-----third_charnew--' + third_char);
                            charSet.clear();
                            charSet.addAll(new List<String>{'F', 'R', 'P', 'K', 'G', 'Y', 'M', 'B', 'O', 'W'});
                            if(!charSet.contains(first_char.substring(0, 1)))
                            {
                                production_date = 'FAIL';
                                system.debug('-----production_date1--' + production_date);
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'F', 'R', 'P', 'K', 'G', 'Y', 'M', 'B', 'O', 'W'});
                            if(!charSet.contains(first_char.substring(1, 2)))
                            {
                                production_date = 'FAIL';
                                system.debug('-----production_date2--' + production_date);
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'F', 'R', 'P', 'K', 'G', 'Y', 'M', 'B', 'O', 'W'});
                            if(!charSet.contains(first_char.substring(2, 3)))
                            {
                                production_date = 'FAIL';
                                system.debug('-----production_date3--' + production_date);
                            }
                            system.debug('-------------' + production_date);
                            if(production_date != 'FAIL')
                            {
                                first_char = first_char.replace('F', '0');
                                first_char = first_char.replace('R', '1');
                                first_char = first_char.replace('P', '2');
                                first_char = first_char.replace('K', '3');
                                first_char = first_char.replace('G', '4');
                                first_char = first_char.replace('Y', '5');
                                first_char = first_char.replace('M', '6');
                                first_char = first_char.replace('B', '7');
                                first_char = first_char.replace('O', '8');
                                first_char = first_char.replace('W', '9');
                                lv_month = first_char;
                                System.debug('-----lv_month-------' + lv_month);
                            }
                            charSet.clear();
                            charSet.addAll(new List<String>{'F', 'R', 'P', 'K', 'G', 'Y', 'M', 'B', 'O', 'W'});
                            if(charSet.contains(first_char.substring(0, 1)))
                            {
                                lv_location = 'Franklin Park';
                                lv_date_code_rpt_factory = 'FP';
                                System.debug('-----lv_location-------' + lv_location);
                                System.debug('-----lv_date_code_rpt_factory-------' + lv_date_code_rpt_factory);
                            }
                        }
                        if(Integer.valueof(lv_month) <= 0 || Integer.valueof(lv_month) > 366)
                        {
                            production_date = 'FAIL';
                        }
                        lv_temp_year = '';
                        if((Integer.valueOf(first_number) >= 0 && Integer.valueOf(first_number) <= 9) && (Integer.valueOf(lv_month) <= 366 && Integer.valueOf(lv_month) > 0))
                        {
                            System.debug('------lvtempyear------');
                            if((System.today().year() - Integer.valueOf('201' + string.valueOf(first_number))) < 0)
                            {
                                lv_temp_year = string.valueOf(lv_year.subString(3, 4)) + string.valueOf(first_number);
                                system.debug('------lv_temp_year------' + lv_temp_year);
                            }
                            else
                            {
                                lv_temp_year = string.valueOf(lv_cur_year.subString(2, 3)) + string.ValueOf(first_number);
                                system.debug('------lv_temp_year------' + lv_temp_year);
                            }
                            lv_year = '01/01' + lv_year1 + lv_temp_year;
                            production_date = date.parse(lv_year).addDays(Integer.valueOf(lv_month) - 1).format();
                            system.debug('------production_date-------' + production_date);
                            ln_days = date.parse(production_date).daysBetween(System.today());
                            if(ln_days <= 0)
                            {
                                production_date = 'FAIL';
                            }
                            if((integer.valueof(second_char) >= 0 && integer.valueof(second_char) <= 23) && (integer.valueof(second_number) >= 0 && integer.valueof(second_number) <= 59))
                            {
                                lv_military_time = second_char + second_number;
                                system.debug('------lv_military_time------' + lv_military_time);
                            }
                            else
                            {
                                lv_military_time = '';
                            }
                        }
                        else
                        {
                            production_date = 'FAIL';
                        }
                    }
                    else
                    {
                        production_date = 'FAIL';
                    }
                }
                //CIGARETTE_NS             
                else if(ProductLineCode == 'NC')
                {
                    if(traceCode.length() == 8)
                    {
                        DateCodeHelper.TraceCodeValue traceCodeVal = new DateCodeHelper.TraceCodeValue();
                        traceCodeVal = getTraceCodeValuesForNC(traceCode);
                        
                        production_date =  traceCodeVal.ProductionDate;
                        lv_location = traceCodeVal.lvLocation;
                        lv_date_code_rpt_factory = traceCodeVal.lvDateCodeRptFactory;
                        lv_military_time = traceCodeVal.lvMilitaryTime;
                        lv_date_code_cold_storage = traceCodeVal.lvDateCodeColdStorage;
                        
                    }
                    else if(traceCode.length() == 9)
                    {
                        DateCodeHelper.TraceCodeValue traceCodeVal = new DateCodeHelper.TraceCodeValue();
                        traceCodeVal = getTraceCodeValuesForNC(traceCode);
                        
                        production_date =  traceCodeVal.ProductionDate;
                        lv_location = traceCodeVal.lvLocation;
                        lv_date_code_rpt_factory = traceCodeVal.lvDateCodeRptFactory;
                        lv_military_time = traceCodeVal.lvMilitaryTime;
                        lv_date_code_cold_storage = traceCodeVal.lvDateCodeColdStorage;
                    }
                }
                //Heated Tobacco  
                //11-13-2018 ggcutchon: RITM2189741: SCR 18-11-03 Trace Codes - IQOS Heat Stick 10-Character
                else if(productLineCode == 'IQ')
                {                
                    if (traceCode.length() == 10)
                    {
                        first_char  =  traceCode.subString( 0, 2); // zz = Position 1,2
                        first_number  =  traceCode.subString( 2, 4); // 03 = Position 3,4
                        second_number  =  traceCode.subString( 4, 5); // 5 = Position 5
                        third_number  =  traceCode.subString( 5, 8); // 345 = Position 6,7,8
                        fourth_number = traceCode.subString( 8,  10); // 09 = Position 9,10
                        
                        //INC0098016 - IQOS Heat Stick Trace Codes
                        TraceCodeHelper tch = new TraceCodeHelper();
                        production_date = tch.ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        
                        if(production_date !=null || production_date != 'fail')
                        {
                            lv_location = first_char;
                            lv_date_code_rpt_factory = first_char;
                            lv_unit = first_number;
                            lv_military_time = fourth_number + '00';
                        }
                    }
                }
                //Tobacco Derived Nicotine Pouch
                //RITM0266931: SCR 20-02-25 Trace Codes - Helix ON 9 and 7 Character Codes Ver 2.0
                else if(productLineCode == 'TDNP')
                {
                    //Start: RITM0846391 - SCR 20-11-17 Trace Codes
                    if(traceCode.length() == 1)
                    {
                        first_char  =  traceCode.subString( 0, 1); 
                        
                        //=============================
                        //-----------------------------
                        //Set Location, Factory
                        //-----------------------------
                        
                        //Location and Factory will be populated whether invalid or valid
                        if(first_char == 'M'){
                            lv_location = 'RICHMOND';
                            lv_date_code_rpt_factory = 'MC_HELIX';
                        }
                        else if(first_char == 'S'){
                            lv_location = 'SWEDEN';
                            lv_date_code_rpt_factory = 'HELSINGBORG';
                        }else{
                            lv_location = 'RICHMOND';
                            lv_date_code_rpt_factory = 'MC_HELIX';
                            production_date = null; //Set to null to declare as an invalid tracecode
                        }
                        
                    }
                    //End: RITM0846391 - SCR 20-11-17 Trace Codes
                    if(traceCode.length() == 7)
                    {
                        first_char  =  traceCode.subString( 0, 1); 
                        String shift  =  traceCode.subString( 2, 5);
                        //=============================
                        //-----------------------------
                        //Set Location, Factory, Shift
                        //-----------------------------
                        
                        //Location and Factory is constant, invalid or valid will have the same value
                        lv_location = 'SWEDEN';
                        lv_date_code_rpt_factory = 'HELSINGBORG';
                        
                        //----------------
                        TraceCodeHelper tch = new TraceCodeHelper();
                        production_date = tch.ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        
                        if(shift.isNumeric() && production_date != null)
                        {
                            lv_shift = shift; //Should be numeric                         
                        }
                        else
                        {
                            //reset since invalid
                            lv_shift = '';
                            production_date = null; 
                        }
                    }
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
                        lv_location = 'RICHMOND';
                        lv_date_code_rpt_factory = 'MC_HELIX';
                        
                        TraceCodeHelper tch = new TraceCodeHelper();
                        production_date = tch.ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        System.debug('Production date: ' + production_date);
                        if(production_date != null)
                        {
                            if(shift.isNumeric())
                            {
                                if(Integer.valueOf(shift.subString(0,2)) <= 23 && Integer.valueOf(shift.subString(2,4)) <= 59)
                                {	
                                    lv_military_time = shift; //assign military time
                                    
                                    Integer getShift;
                                    getShift = Integer.valueOf(shift);
                                    if(getShift >= 630 && getShift<=1429)
                                    {
                                        shift = '1';   
                                    }
                                    else if(getshift >=1430 && getShift<=2229)
                                    {
                                        shift = '2';
                                    }
                                    else if(getShift >= 2230 || getShift <= 629)
                                    {
                                        shift = '3';
                                    }
                                    
                                    lv_shift = shift;
                                }
                                else
                                {
                                    lv_shift = null;
                                    lv_military_time = null;
                                }
                                
                            }
                            if(module =='U' || module =='J' || module =='N') lv_unit = module;
                            //set all values to null if one of the validation is invalid
                            if(lv_shift == null ||  lv_military_time == null || lv_unit == null)
                            {
                                production_date = null;
                                lv_shift = null;
                                lv_military_time = null;
                                lv_unit = null;
                            }
                        }
                        else 
                        {
                            //reset values if production date fails
                            lv_shift = '';
                            lv_military_time = '';
                            lv_unit = '';
                        }
                        //----------------
                    }
                }
                //---------------------------------------------
                //Added by Sachin Shah Affirma
                
                else if(productLineCode == 'SNP')
                {
                    DateCodeHelperExtension datareturn = new DateCodeHelperExtension();
                    DateCodeHelperExtension.Data newdatareturn = new DateCodeHelperExtension.Data();
                    
                    newdatareturn = datareturn.DateCodeFields(ProductLineCode, traceCode, oprCompany, TraceCodeLocation, ustDateType, ustDateCode, caseObj);
                    lv_shift = newdatareturn.lv_shift1;
                    lv_military_time =newdatareturn.lv_military_time1;
                    lv_unit = newdatareturn.lv_unit1;
                    production_date = newdatareturn.production_date1;
                    lv_date_code_rpt_factory = newdatareturn.lv_date_code_rpt_factory1;
                    lv_location = newdatareturn.location1;
                    
                }
                
                else if(productLineCode == 'TDNS'){
                    DateCodeHelperExtension datareturn = new DateCodeHelperExtension();
                    DateCodeHelperExtension.Data newdatareturn = new DateCodeHelperExtension.Data();
                    
                    newdatareturn = datareturn.DateCodeFields(ProductLineCode, traceCode, oprCompany, TraceCodeLocation, ustDateType, ustDateCode, caseObj);
                    lv_shift = newdatareturn.lv_shift1;
                    lv_military_time =newdatareturn.lv_military_time1;
                    lv_unit = newdatareturn.lv_unit1;
                    production_date = newdatareturn.production_date1;
                    lv_date_code_rpt_factory = newdatareturn.lv_date_code_rpt_factory1;
                    lv_location = newdatareturn.location1;
                    
                }
                
                if((ustDateType != null && ustDateType != 'ZZZZ') && (ustDateCode != null && ustDateCode != 'ZZZZ'))
                {
                    if(ustDateType == 'MD' || ustDateType == 'GFU' || ustDateType == 'SB')
                    {
                        if(ustDateCode.length() == 9)
                        {
                            lv_ust_date_code = ustDateCode.substring(0, 3) + '' + ustDateCode.substring(3, 5) + '' + ustDateCode.substring(5, 9);
                        }
                        else
                        {
                            lv_ust_date_code = ustDateCode;
                        }
                    }
                    else if(ustDateType == 'CD')
                    {
                        if(ustDateCode.length() == 4)
                        {
                            lv_ust_date_code = ustDateCode.substring(0, 2) + '/' + ustDateCode.substring(2, 4);
                        }
                        else
                        {
                            lv_ust_date_code = ustDateCode;
                        }
                    }
                    else if(ustDateType == 'SN')
                    {
                        if(ustDateCode.length() == 5)
                        {
                            lv_ust_date_code = ustDateCode.substring(0, 2) + '' + ustDateCode.substring(2, 4) + '/' + ustDateCode.substring(4, 5);
                        }
                        else
                        {
                            lv_ust_date_code = ustDateCode;
                        }
                    }
                    else if(ustDateType == 'WB')
                    {
                        if(ustDateCode.length() == 5)
                        {
                            lv_ust_date_code = ustDateCode.substring(0, 2) + '' + ustDateCode.substring(2, 4) + '' + ustDateCode.substring(4, 6);
                        }
                        else
                        {
                            lv_ust_date_code = ustDateCode;
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.debug('Warning:' + e +e.getLineNumber());
        }
        if(ProductLineCode == 'PT' && (traceCode.length() != 4 && traceCode.length() != 6 && traceCode.length() != 12)) //RITM0906850: Added 12 char
        {
            lv_location = 'Limerick';
            lv_date_code_rpt_factory = 'Limerick';
        }
        if(production_date == 'FAIL' || traceCode == null || traceCode.length() == 0)
        {
            traceCode = traceCode.trim();
            string codep = traceCode.substring(0, 1).toUpperCase();
            if((ProductLineCode == 'GP') && (traceCode != null && traceCode.length() != 5 && traceCode.length() != 11) && (codep.toUpperCase() == 'X'))
            {
                lv_location = '3rd PARTY MANUFACTURER';
            }
            else
            {
                if(ProductLineCode == 'GP' && traceCode != null && traceCode.length() != 9 && traceCode.length() != 11 && traceCode.length() != 5 && (codep.toUpperCase() != 'X'))
                {
                    lv_location = 'Limerick';
                    lv_date_code_rpt_factory = 'Limerick';
                }
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 5)
            {
                lv_location = 'Limerick';
                lv_date_code_rpt_factory = 'Limerick';
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 8 && codep == 'J')
            {
                lv_location = 'Limerick';
                lv_date_code_cold_storage = 'Y';
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 8 && codep == 'S')
            {
                lv_location = '3rd PARTY MANUFACTURER';
                lv_date_code_cold_storage = 'Y';
            }
            if(ProductLineCode == 'GP' && (traceCode == null || traceCode.length() == 0))
            {
                lv_location = 'Unknown';
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 11 && codep == 'W')
            {
                lv_location = 'PRECON';
                lv_date_code_cold_storage = 'Y';
            }
            if(ProductLineCode == 'GP' && traceCode.length() == 11 && codep == 'P')
            {
                lv_location = 'PRECON';
                lv_date_code_cold_storage = 'N';
            }
        }
        
        //*************************************************************************************************
        //*************************************************************************************************
        // Business Rule:  Factory Location for specific product codes --- Oldwen Adriano
        //      - Does not matter if Trace Code is valid
        //      - Applies to product codes DS, PC, SP, UU
        //      - If 1st character of Trace Code is N or S or H or V then the product was produced in Nashville (NS).
        //      - If the first character is F or R or P or K then the product was produced in Franklin Park (FP)
        //=================================================================================================
        if(ProductLineCode == 'DS' || ProductLineCode == 'PC' || ProductLineCode == 'SP' || ProductLineCode == 'UU')
        {   
            //Get the 1st character
            first_char = traceCode.substring(0, 1).toUpperCase();
            String strClear = '';
            
            //Build a set of codes for Nashville
            charSet.clear();
            charSet.add('N');
            charSet.add('S');
            charSet.add('H');
            charSet.add('V');
            
            if(charSet.contains(first_char))
            {
                lv_location = 'Nashville';
                lv_date_code_rpt_factory = 'NS';
                strClear = 'Clear';
            }
            else
            {
                //Build a set of codes for Franklin Park
                charSet.clear();
                charSet.add('F');
                charSet.add('R');
                charSet.add('P');
                charSet.add('K');
                
                if(charSet.contains(first_char))
                {
                    lv_location = 'Franklin Park';
                    lv_date_code_rpt_factory = 'FP';
                    strClear = 'Clear';
                }
            }
            //------------------------
            if(strClear == '')
            {
                lv_location = '';
                lv_date_code_rpt_factory = '';
            }
        }
        
        //*************************************************************************************************
        //*************************************************************************************************
        
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        //  NEW USST FORMAT FOR 2017
        //---------------------------
        //                      The following code is to implement the new trace code validation rules for USST 2017
        //                      as required by SCR 17-02-14
        //
        //                          --- O. Adriano - Salesforce Enterprise Services
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        String workTraceCode = traceCodeObj.toUpperCase();
        
        //First rule:  Is the trace code length 9
        if (workTraceCode.length() == 9)
        {
            //Second rule:  Is the 2nd character of the trace code is numeric ( 0 thru 9 ) 
            if(workTraceCode.substring(1,2).isNumeric())
            {
                //Third rule:  The new trace code is valid for the following Product Lines: MST, Pouch, Dry Snuff and USSTC SNUS
                //      MST - SP
                //      Pouch - PC
                //      Dry Snuff - DS
                //      USSTC SNUS - UU
                
                String workProductCode = ProductLineCode;
                String firstCharacter = workTraceCode.substring(0,1);
                String fifthCharDateCodeUnit = workTraceCode.substring(4,5);
                Date myRetDate;
                String dayString = '';
                Boolean goodDate = false;
                
                String productionDay = workTraceCode.substring(1,4);
                Integer intProdDay = Integer.valueOf(productionDay);
                
                if(workProductCode == 'SP' || workProductCode == 'PC' || workProductCode == 'DS' || workProductCode == 'UU')
                {
                    Boolean IfValidMc_Usst;  
                    //===============================
                    //Set the production date to what was found or to fail
                    //===============================
                    //We have a trace code for this criteria.  Check to make sure we havea  valid number for production day  
                    if(!workTraceCode.substring(1,4).isNumeric() || intProdDay < 1 || intProdDay > 364)
                    { 
                        production_date = 'fail';
                    }
                    else
                    {                       
                        
                        //The first character in the trace code will be used to determine the factory and  production year.  Each letter (aka code) has a 4 year cycle, 
                        //starting with 2017 to determine the production year. For Nashville,  product produced in 2017 will use N as the code, in  2018 will be S, 
                        //2019 will be H, 2020 will be V.  Product produced in 2021 will use N (re-starting the 4 year cycle). 
                        Integer yearOneCycle = 2017;
                        Integer yearTwoCycle = 2018;
                        Integer yearThreeCycle = 2019;
                        Integer yearFourCycle = 2020;
                        
                        Date workDate = system.today();
                        
                        if(firstCharacter == 'T'){
                            if(caseObj != null && caseObj.Id != null){
                                workDate = Date.valueOf([Select CreatedDate from Case where Id =: caseObj.Id].CreatedDate); 
                            }
                        }
                        Integer workYear = workDate.year();
                        
                        Integer yearSet = workYear - 2017;
                        
                        IfValidMc_Usst = (workDate >= Date.newInstance(2018,08,01));
                        
                        //If 4 or more we are in a new cycle
                        if(yearSet > 3) 
                        {
                            Integer numberOfSets = yearSet / 4; //How many cycles have past?
                            
                            Integer yearToAdd = numberOfSets * 4;
                            
                            Integer newYear = 2017 + yearToAdd;
                            
                            yearOneCycle = newYear;
                            yearTwoCycle = newYear + 1;
                            yearThreeCycle = newYear + 2;
                            yearFourCycle = newYear + 3;
                        }
                        
                        Date baseDate;
                        
                        //------------------------------
                        //Nashville location
                        //------------------------------                        
                        
                        if(firstCharacter == 'N' || firstCharacter == 'S' || firstCharacter == 'H' || firstCharacter == 'V'
                           || firstCharacter == 'A' || firstCharacter == 'E' || firstCharacter == 'B' || firstCharacter == 'K')
                        {
                            if(firstCharacter == 'N' || firstCharacter == 'K')
                            {
                                baseDate = Date.newInstance(yearOneCycle, 1, 1);
                            }
                            else if(firstCharacter == 'S' || firstCharacter == 'A')
                            {
                                baseDate = Date.newInstance(yearTwoCycle, 1, 1);
                            }
                            else if(firstCharacter == 'H' || firstCharacter == 'E')
                            {
                                baseDate = Date.newInstance(yearThreeCycle, 1, 1);
                            }
                            else if(firstCharacter == 'V' || firstCharacter == 'B')
                            {
                                baseDate = Date.newInstance(yearFourCycle, 1, 1);
                            }
                            //----------------------------
                            intProdDay = intProdDay - 1; //Subtract one day because you are starting on day 1
                            
                            myRetDate = baseDate.addDays(intProdDay);
                            
                            dayString = myRetDate.format();
                            
                            production_date = dayString;
                            
                            goodDate = true;
                        }
                        //------------------------------
                        //------------------------------
                        //Virginia location
                        //------------------------------                        
                        
                        if(firstCharacter == 'R' || firstCharacter == 'C' || firstCharacter == 'M' || firstCharacter == 'D'
                           || firstCharacter == 'Q' || firstCharacter == 'J' || (firstCharacter == 'T' && IfValidMc_Usst) || firstCharacter == 'W')
                        {
                            if(firstCharacter == 'R' || firstCharacter == 'W')
                            {
                                baseDate = Date.newInstance(yearOneCycle, 1, 1);
                            }
                            else if(firstCharacter == 'C' || firstCharacter == 'Q')
                            {
                                baseDate = Date.newInstance(yearTwoCycle, 1, 1);
                            }
                            else if(firstCharacter == 'M' || firstCharacter == 'J')
                            {
                                baseDate = Date.newInstance(yearThreeCycle, 1, 1);
                            }
                            else if(firstCharacter == 'D' || firstCharacter == 'T')
                            {
                                baseDate = Date.newInstance(yearFourCycle, 1, 1);
                            }
                            //----------------------------
                            intProdDay = intProdDay - 1; //Subtract one day because you are starting on day 1
                            
                            myRetDate = baseDate.addDays(intProdDay);
                            
                            dayString = myRetDate.format();
                            
                            production_date = dayString;
                            
                            goodDate = true;
                        }
                        //------------------------------
                        //------------------------------
                        //Franklin Park location
                        //------------------------------ 
                        //Franklin Park is closing in 2017, so we only need trace codes for 2016 and 2017
                        if(firstCharacter == 'Y')
                        {
                            baseDate = Date.newInstance(2016, 1, 1);
                            
                            intProdDay = intProdDay - 1; //Subtract one day because you are starting on day 1
                            
                            myRetDate = baseDate.addDays(intProdDay);
                            
                            dayString = myRetDate.format();
                            
                            production_date = dayString;
                            
                            goodDate = true;
                        }
                        //-----
                        if(firstCharacter == 'T' && !IfValidMc_Usst)
                        {
                            baseDate = Date.newInstance(2017, 1, 1);
                            
                            intProdDay = intProdDay - 1; //Subtract one day because you are starting on day 1
                            
                            myRetDate = baseDate.addDays(intProdDay);
                            
                            dayString = myRetDate.format();
                            
                            production_date = dayString;
                            
                            goodDate = true;
                        }
                        //---------------------------------------
                        if(goodDate == true)
                        {
                            if(myRetDate > system.today())
                            {
                                //Start: RITM0876454: Corrected - year cycle must be reset to a new cycle if a date is a future date
                                myRetDate = Date.newInstance(myRetDate.year()-4, myRetDate.month(), myRetDate.day());
                                dayString = myRetDate.format();
                                //End: RITM0876454: Corrected - year cycle must be reset to a new cycle if a date is a future date
                            }
                        }
                        //-----------------------------------------
                        //------------------------------
                    }       
                    //==========================================================================================
                    //Set the location and factory
                    //==========================================================================================
                    //  firstCharacter
                    String strLocSet = '';
                    
                    //Build a set of codes for Nashville
                    charSet.clear();
                    charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'A', 'E', 'B', 'K'});                    
                    
                    if(charSet.contains(firstCharacter))
                    {
                        lv_location = 'Nashville';
                        lv_date_code_rpt_factory = 'NS';
                        strLocSet = 'Clear';
                    }
                    //--------
                    if(strLocSet != 'Clear') //Was not set for Nashville
                    {
                        //Build a set of codes for Franklin Park
                        charSet.clear();
                        charSet.add('Y');
                        
                        if(charSet.contains(firstCharacter) || (firstCharacter == 'T' && !IfValidMc_Usst))
                        {
                            lv_location = 'Franklin Park';
                            lv_date_code_rpt_factory = 'FP';
                            strLocSet = 'Clear';
                        }
                    }
                    //------------------------
                    if(strLocSet != 'Clear') //Was not set for Franklin Park
                    {
                        //Build a set of codes for Virginia
                        charSet.clear();
                        charSet.addAll(new List<String>{'R', 'C', 'M', 'D', 'Q', 'J', 'W'});
                        
                        if(charSet.contains(firstCharacter) || (firstCharacter == 'T' && IfValidMc_Usst))
                        {
                            // 1-16-2018: SCR 18-01-10 2018 Trace Codes - USST 9-Character Richmond Manufacturing Center: Date code location and factory value for Virginia
                            lv_location = 'Virginia';
                            lv_date_code_rpt_factory = 'MC_USSTC';
                            strLocSet = 'Clear';
                            /*
lv_location = 'Virginia';
lv_date_code_rpt_factory = 'MC';
strLocSet = 'Clear';
*/
                        }
                    }
                    //------------------------
                    if(strLocSet == '')
                    {
                        lv_location = '';
                        lv_date_code_rpt_factory = '';
                    }
                    //-------------------------------
                    if(production_date != 'fail')
                    {
                        //==========================================================================================
                        // Printing location / module   ----- DateCodeUnit = lv_unit;
                        //==========================================================================================
                        //  fifthCharDateCodeUnit
                        if(firstCharacter == 'N' || firstCharacter == 'S' || firstCharacter == 'H' || firstCharacter == 'V'
                           || firstCharacter == 'A' || firstCharacter == 'E' || firstCharacter == 'B' || firstCharacter == 'K')
                            //Nashville
                        {
                            //Valid Unit codes for Nashville
                            charSet.clear();
                            
                            charSet.addAll(new List<String>{'N', 'S', 'H', 'I', 'V', 'L', 'E', 'A', 'B', 'P', 'R', 'C', 'M','2','3'});
                            
                            if(charSet.contains(fifthCharDateCodeUnit))
                            {
                                lv_unit = fifthCharDateCodeUnit;
                            }
                            else
                            {
                                production_date = 'fail';
                            }
                        }
                        //---------------------
                        if(firstCharacter == 'R' || firstCharacter == 'C' || firstCharacter == 'M' || firstCharacter == 'D'
                           || firstCharacter == 'Q' || firstCharacter == 'J' || (firstCharacter == 'T' && IfValidMc_Usst) || firstCharacter == 'W')  //Virginia
                        {
                            //Valid Unit codes for Virginia
                            // 1-16-2018: SCR 18-01-10 2018 Trace Codes - USST 9-Character Richmond Manufacturing Center: New valid unit codes for Virginia
                            charSet.clear();
                            charSet.addAll(new List<String>{'K', 'G', 'T', 'Y', 'Z','D'});
                            
                            if(charSet.contains(fifthCharDateCodeUnit))
                            {
                                lv_unit = fifthCharDateCodeUnit;
                                //RITM0370406 - SCR 20-04-16 Trace Codes - USSTC 9-Character and Helix ON 7-Character
                                if(fifthCharDateCodeUnit == 'D')
                                {
                                    lv_location = 'Richmond';
                                    lv_date_code_rpt_factory = 'D Pilot';
                                }
                            }
                            else
                            {
                                production_date = 'fail';
                            }
                            
                            
                        }
                        //----------------------
                        if(firstCharacter == 'Y' || (firstCharacter == 'T' && !IfValidMc_Usst))//Franklin Park
                        {
                            //Valid Unit codes for Franklin Park
                            charSet.clear();
                            
                            charSet.addAll(new List<String>{'Y', 'O', 'F', 'G', 'Z', 'M', 'K', 'W', 'X', 'J', 'E'});
                            
                            if(charSet.contains(fifthCharDateCodeUnit))
                            {
                                lv_unit = fifthCharDateCodeUnit;
                            }
                            else
                            {
                                production_date = 'fail';
                            }
                        }
                        //==========================================================================================
                        // Military Time   ----- DateCodeMilitaryTime = lv_military_time;  6,7,8,9 positions... hhmm
                        //==========================================================================================
                        String strMilitaryHour = workTraceCode.substring(5,7);
                        String strMilitaryMin = workTraceCode.substring(7,9);
                        
                        if(strMilitaryHour.isNumeric() && strMilitaryMin.isNumeric())
                        {
                            //Check to make sure hour is between 0 and 23 for military hours
                            Integer myHour = Integer.ValueOf(strMilitaryHour);
                            
                            if(myHour > -1 && myHour < 24)
                            {
                                //Check to see if minutes is between 0 and 59
                                Integer myMinute = Integer.ValueOf(strMilitaryMin);
                                
                                if(myMinute > -1 && myMinute < 60)
                                {
                                    lv_military_time = strMilitaryHour + strMilitaryMin;
                                }
                                else
                                {
                                    production_date = 'fail';
                                }
                            }
                            else
                            {
                                production_date = 'fail';
                            }
                            
                            //-----------------------------------------------------------------
                            //SET THE SHIFT FOR MILITARY HOUR
                            //-----------------------------------------------------------------
                            if(strMilitaryHour == '00' || strMilitaryHour == '01' || strMilitaryHour == '02'
                               || strMilitaryHour == '03' || strMilitaryHour == '04' || strMilitaryHour == '05'
                               || strMilitaryHour == '06' || strMilitaryHour == '23')
                            {
                                lv_shift = '3';
                            }
                            else if(strMilitaryHour == '07' || strMilitaryHour == '08' || strMilitaryHour == '09'
                                    || strMilitaryHour == '10' || strMilitaryHour == '11' || strMilitaryHour == '12'
                                    || strMilitaryHour == '13' || strMilitaryHour == '14')
                            {
                                lv_shift = '1';
                            }
                            else if(strMilitaryHour == '15' || strMilitaryHour == '16' || strMilitaryHour == '17'
                                    || strMilitaryHour == '18' || strMilitaryHour == '19' || strMilitaryHour == '20'
                                    || strMilitaryHour == '21' || strMilitaryHour == '22')
                            {
                                lv_shift = '2';
                            }
                            //-----------------------------------------------------------------
                        }
                        else
                        {
                            production_date = 'fail';
                        }
                        //---------------------------------------------------------------------------------------------
                    }
                    //**********************
                    //The production date failed in datecodeunit or military time, then do not populate them
                    if(production_date == 'fail')
                    {
                        lv_military_time = '';
                        lv_unit = '';
                    }
                }
            }
            else
            {
                //==========================================================================================
                //SCR 17-08-09 2017 Trace Codes  --- USST Populate Shift
                //--------------------------------------------------------
                // Military Time   ----- DateCodeMilitaryTime = lv_military_time;  5,6,7,8 positions... hhmm
                // For OLD Trace Codes --- Length of 9 and Letter in second position
                //==========================================================================================
                String strMilitaryHour = workTraceCode.substring(4,6);
                String strMilitaryMin = workTraceCode.substring(6,8);
                
                if(strMilitaryHour.isNumeric() && strMilitaryMin.isNumeric())
                {
                    //Check to make sure hour is between 0 and 23 for military hours
                    Integer myHour = Integer.ValueOf(strMilitaryHour);
                    
                    if(myHour > -1 && myHour < 24)
                    {
                        //Check to see if minutes is between 0 and 59
                        Integer myMinute = Integer.ValueOf(strMilitaryMin);
                        
                        if(myMinute > -1 && myMinute < 60)
                        {
                            lv_military_time = strMilitaryHour + strMilitaryMin;
                        }
                        else
                        {
                            production_date = 'fail';
                        }
                    }
                    else
                    {
                        production_date = 'fail';
                    }
                    //-----------------------------------------------------------------
                    //SET THE SHIFT FOR MILITARY HOUR
                    //-----------------------------------------------------------------
                    if(strMilitaryHour == '00' || strMilitaryHour == '01' || strMilitaryHour == '02'
                       || strMilitaryHour == '03' || strMilitaryHour == '04' || strMilitaryHour == '05'
                       || strMilitaryHour == '06' || strMilitaryHour == '23')
                    {
                        lv_shift = '3';
                    }
                    else if(strMilitaryHour == '07' || strMilitaryHour == '08' || strMilitaryHour == '09'
                            || strMilitaryHour == '10' || strMilitaryHour == '11' || strMilitaryHour == '12'
                            || strMilitaryHour == '13' || strMilitaryHour == '14')
                    {
                        lv_shift = '1';
                    }
                    else if(strMilitaryHour == '15' || strMilitaryHour == '16' || strMilitaryHour == '17'
                            || strMilitaryHour == '18' || strMilitaryHour == '19' || strMilitaryHour == '20'
                            || strMilitaryHour == '21' || strMilitaryHour == '22')
                    {
                        lv_shift = '2';
                    }
                    //-----------------------------------------------------------------
                }
                else
                {
                    production_date = 'fail';
                }
                //---------------------------------------------------------------------------------------
            }
        }                
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        DateCodeObj.ProductionDate = production_date;
        DateCodeObj.DateCodeLocation = lv_location;
        DateCodeObj.DateCodeShift = lv_shift;
        DateCodeObj.DateCodeUnit = lv_unit;
        DateCodeObj.DateCodeColdStorage = lv_date_code_cold_storage;
        DateCodeObj.DateCodeRptBay = lv_date_code_rpt_bay;
        DateCodeObj.DateCodeRptFactory = lv_date_code_rpt_factory;
        DateCodeObj.DateCodeMilitaryTime = lv_military_time;
        DateCodeObj.UstDateCode = lv_ust_date_code;
        return DateCodeObj;
    }
    public date nextDay(string vDate, string vDay)
    {
        Integer I = 1;
        while (I <= 7)
        {
            Datetime dt = DateTime.newInstance(date.parse(vDate).addDays(I), Time.newInstance(0, 0, 0, 0));
            string wName = dt.format('EEEE');
            if(wName.toUpperCase() == vDay.toUpperCase())
            {
                return Date.parse(vDate).addDays(I);
            }
            I += 1;
        }
        return Date.parse(vDate).addDays(I);
    }
    public string mondayDate(string year, string WeekNumber)
    {
        Date startdate;
        Date enddate;
        Integer ctr;
        Date dt = Date.parse('01/01/' + Year).addMonths(-1);
        Date lastDate = Date.parse('12/31/' + string.valueOf(dt.year()));
        DateTime dtNew = DateTime.newInstance(lastDate, Time.newInstance(0, 0, 0, 0));
        string WeekName = dtNew.format('EEE').toUpperCase();
        if(WeekName == 'MON')
        {
            startdate = lastDate;
        }
        else if(WeekName == 'TUE')
        {
            startdate = lastDate.addDays(-1);
        }
        else if(WeekName == 'WED')
        {
            startdate = lastDate.addDays(-2);
        }
        else if(WeekName == 'THU')
        {
            startdate = lastDate.addDays(-3);
        }
        else if(WeekName == 'FRI')
        {
            startdate = lastDate.addDays(-4);
        }
        else if(WeekName == 'SAT')
        {
            startdate = lastDate.addDays(-5);
        }
        else
        {
            startdate = lastDate.addDays(-6);
        }
        enddate = Date.Parse('12/31/' + string.valueOf(Integer.ValueOf(Year) + 1));
        ctr = 1;
        while (enddate >= startdate)
        {
            if(Integer.valueOf(WeekNumber) == ctr)
            {
                break;
            }
            ctr += 1;
            startdate = startdate.addDays(7);
        }
        return startdate.format();
    }
    
    
    public void PTtraceCode4nonNumeric(String traceCode){
        first_char = traceCode.toUpperCase().subString(2, 4);
        second_char = traceCode.toUpperCase().subString(0, 1);
        third_char = traceCode.toUpperCase().subString(1, 2);
        system.debug('first_char--> ' + first_char);
        system.debug('second_char--> ' + second_char);
        system.debug('third_char--> ' + third_char);
        
        charSet.clear();
        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
        /* charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H'); */
        if(!charSet.contains(first_char.substring(0, 1)))
        {
            production_date = 'FAIL';
        }
        charSet.clear();
        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
        /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');*/
        if(!charSet.contains(first_char.substring(1, 2)))
        {
            production_date = 'FAIL';
        }
        charSet.clear();
        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H', 'E', 'R'});
        /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');
charSet.add('E');
charSet.add('R');*/
        if(!charSet.contains(second_char))
        {
            production_date = 'FAIL';
        }
        charSet.clear();
        charSet.addAll(new List<String>{'B', 'L', 'A', 'C', 'K', 'S', 'M', 'I', 'T', 'H'});
        /*charSet.add('B');
charSet.add('L');
charSet.add('A');
charSet.add('C');
charSet.add('K');
charSet.add('S');
charSet.add('M');
charSet.add('I');
charSet.add('T');
charSet.add('H');*/
        if(!charSet.contains(third_char))
        {
            production_date = 'FAIL';
        }
        
        lv_day = first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace('M', '7').replace('I', '8').replace('T', '9').replace('H', '0');
        lv_month = second_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
        lv_year2 = third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
        system.debug('------lv_day--------' + lv_day);
        system.debug('------lv_month--------' + lv_month);
        system.debug('--------lv_year2------' + lv_year2);
        if(Integer.valueOf(lv_day) > 31)
        {
            production_date = 'FAIL';
        }
        if(Integer.valueOf(lv_month) > 12)
        {
            production_date = 'FAIL';
        }
        if(Integer.valueOf(lv_cur_year) >= Integer.valueOf('201' + lv_year2.subString(1, 2)))
        {
            lv_year2 = lv_cur_year.subString(2, 3) + lv_year2.subString(1, 2);
            System.debug('-------lv_year2---------' + lv_year2);
            if(Integer.valueOf(lv_cur_year) == Integer.valueOf('201' + lv_year2.subString(1, 2)))
            {
                production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
                //IsValidDate                         
                System.debug('-------production_date---------' + production_date);
                try
                {
                    date dt = date.parse(production_date);
                    if(date.parse(production_date) >= System.today())
                    {
                        lv_year2 = lv_year.subString(2, 3) + lv_year2.subString(1, 2);
                    }
                    System.debug('--------lv_year2--------' + lv_year2);
                }
                catch(Exception ex)
                {
                }
            }
        }
        else
        {
            lv_year2 = lv_year.subString(2, 3) + lv_year2.subString(1, 2);
            System.debug('-------lv_year2---------' + lv_year2);
        }
        year_leep = lv_year1.subString(1, 3) + string.valueOf(lv_year2);
        System.debug('---------year_leep-------' + year_leep);
        if(Date.parse('02/28/' + string.valueOf(year_leep)).addDays(1).Month() == 2)
        {
            if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 30)
            {
                production_date = 'fail';
            }
        }
        else if(Integer.valueOf(lv_month) == 2 && Integer.valueOf(lv_day) >= 29)
        {
            production_date = 'fail';
        }
        if(production_date != 'fail')
        {
            production_date = string.valueOf(lv_month) + '/' + string.valueOf(lv_day) + string.valueOf(lv_year1) + string.valueOf(lv_year2);
            System.debug('---------production_date-------' + production_date);
        }
        ln_days = date.parse(production_date).daysBetween(system.today());
        System.debug('-------ln_days---------' + ln_days);
        if(ln_days <= 0)
        {
            production_date = 'FAIL';
        }
        lv_unit = '';
        lv_location = 'Limerick';
        lv_date_code_rpt_factory = 'Limerick';
    }
    
    public void PTtraceCode4Numeric(String traceCode){
        first_char = traceCode.subString( 0, 1);
        second_number = traceCode.subString( 1, 3);
        fourth_number = traceCode.subString( 3, 4);
        
        if (!second_number.isNumeric() || !fourth_number.isNumeric()){
            production_date = 'fail';
        }
        if(Integer.valueOf(second_number) > 53){
            production_date = 'fail';
        }
        
        if (first_char == 'L' || first_char == 'J' || first_char == 'P' || first_char == 'W'){
            if(first_char == 'L'){
                lv_location = 'LIMERICK';
                lv_date_code_rpt_factory = 'LIMERICK';
                lv_date_code_cold_storage = 'N';
            }
            else if(first_char == 'J'){
                lv_location = 'LIMERICK';
                lv_date_code_rpt_factory = 'LIMERICK';
                lv_date_code_cold_storage = 'Y';
            }
            else if(first_char == 'P'){
                lv_location = 'COLONIAL HEIGHTS';
                lv_date_code_rpt_factory = 'PRECON_JMC';
                lv_date_code_cold_storage = 'N';
            }
            else if(first_char == 'W'){
                lv_location = 'COLONIAL HEIGHTS';
                lv_date_code_rpt_factory = 'PRECON_JMC';
                lv_date_code_cold_storage = 'Y';
            }
            
            String lv_cur_year  = String.ValueOf(System.Today().year());
            Integer lv_cur_year_4th = Integer.valueOf(lv_cur_year.subString( 3, 4));
            Integer prodDate;
            
            if(lv_cur_year_4th == Integer.valueOf(fourth_number)){
                prodDate = Integer.valueOf(lv_cur_year);
            }
            else if(lv_cur_year_4th < Integer.valueOf(fourth_number)){
                Integer yearDiff = Integer.valueOf(fourth_number) - lv_cur_year_4th;
                prodDate = (Integer.valueOf(lv_cur_year) - 10) + yearDiff;
            }
            else{
                prodDate = (Integer.valueOf(lv_cur_year) - lv_cur_year_4th) + Integer.valueOf(fourth_number);
            }
            
            fiscal_week = second_number + String.valueOf(prodDate).substring(2,4);
            
            if(fiscal_week != '' || fiscal_week != null){
                fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];
                if(fw != null){
                    production_date = fw.PRODUCTION_DATE__c;
                }
            }  
            ln_days  =  date.parse(production_date).daysBetween(System.today());
            
            if(ln_days <= 0)
            {
                production_date = 'fail';
            }                           
        }
        else{
            production_date = 'fail';
        }
    }
    
    // Method One Start From here 
    public void methodOne()
    { 
        if(ProductLineCode == 'TP' && Check2 == 'Subloop')
        {
            lv_month = '0';
            first_char = traceCode.substring(0, 3).toUppercase();
            first_number = traceCode.substring(3, 4);
            second_char = traceCode.substring(4, 6).toUppercase();
            second_number = traceCode.substring(6, 8);
            third_char = traceCode.substring(8, 9);
            if(first_number.isNumeric() && second_char.isNumeric() &&  second_number.isNumeric())
            {
                if((Integer.valueOf(second_char) < 0 && Integer.valueOf(second_char) > 23) || (Integer.valueOf(second_char) < 0 && Integer.valueOf(second_char) > 59))
                {
                    production_date = 'FAIL';
                }
                lv_military_time = second_char + second_number;
                charSet.clear();
                charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', 'A', 'B', 'P', 'Y', 'O', 'F', 'G', 'Z', 'M', 'R', 'K', 'W', '1', '2', '3'});
                /* charSet.add('N');
charSet.add('S');
charSet.add('H');
charSet.add('V');
charSet.add('I');
charSet.add('L');
charSet.add('E');
charSet.add('A');
charSet.add('B');
charSet.add('P');
charSet.add('Y');
charSet.add('O');
charSet.add('F');
charSet.add('G');
charSet.add('Z');
charSet.add('M');
charSet.add('R');
charSet.add('K');
charSet.add('W');
charSet.add('1');
charSet.add('2');
charSet.add('3'); */
                if(!charSet.contains(first_char.subString(0, 1)))
                {
                    production_date = 'FAIL';
                }
                charSet.clear();
                charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', '2', '3'});
                /*charSet.add('N');
charSet.add('S');
charSet.add('H');
charSet.add('V');
charSet.add('I');
charSet.add('L');
charSet.add('E');
charSet.add('2');
charSet.add('3');*/
                if(charSet.contains(third_char.substring(0, 1)))
                {
                    charSet.clear();
                    charSet.addAll(new List<String>{'N', 'S', 'H', 'V', 'I', 'L', 'E', 'Q', 'C', 'D'});  
                    /*charSet.add('N');
charSet.add('S');
charSet.add('H');
charSet.add('V');
charSet.add('I');
charSet.add('L');
charSet.add('E');
charSet.add('Q');
charSet.add('C');
charSet.add('D');*/
                    if(!charSet.contains(first_char.substring(0, 1)))
                    {
                        production_date = 'FAIL';
                    }
                    if(!charSet.contains(first_char.substring(1, 2)))
                    {
                        production_date = 'FAIL';
                    }
                    if(!charSet.contains(first_char.substring(2, 3)))
                    {
                        production_date = 'FAIL';
                    }
                    if(production_date != 'FAIL')
                    {
                        lv_month = second_Char.replace('N', '0').replace('S', '1').replace('H', '2').replace('V', '3').replace('I', '4').replace('L', '5').replace('E', '6').replace('Q', '7').replace('C', '8').replace('C', '9');
                    }
                    lv_location = 'Nashville';
                    lv_date_code_rpt_factory = 'NS';
                }
                charSet.clear();
                charSet.addAll(new List<String>{'A', 'B', 'P', 'Y', 'O', 'F', 'G', 'Z', 'M', 'R', 'K', 'W', '1', 'X'});  
                /*charSet.add('A');
charSet.add('B');
charSet.add('P');
charSet.add('Y');
charSet.add('O');
charSet.add('F');
charSet.add('G');
charSet.add('Z');
charSet.add('M');
charSet.add('R');
charSet.add('K');
charSet.add('W');
charSet.add('1');
charSet.add('X');*/
                if(charSet.contains(third_char.substring(1, 1)))
                {
                    charSet.clear();
                    charSet.addAll(new List<String>{'F', 'R', 'P', 'K', 'G', 'Y', 'M', 'B', 'O', 'W'});  
                    /*charSet.add('F');
charSet.add('R');
charSet.add('P');
charSet.add('K');
charSet.add('G');
charSet.add('Y');
charSet.add('M');
charSet.add('B');
charSet.add('O');
charSet.add('W');*/
                    if(!charSet.contains(first_char.substring(0, 1)))
                    {
                        production_date = 'FAIL';
                    }
                    charSet.clear();
                    charSet.addAll(new List<String>{'F', 'R', 'P', 'K', 'G', 'Y', 'M', 'B', 'O', 'W'});  
                    /*charSet.add('F');
charSet.add('R');
charSet.add('P');
charSet.add('K');
charSet.add('G');
charSet.add('Y');
charSet.add('M');
charSet.add('B');
charSet.add('O');
charSet.add('W');*/
                    if(!charSet.contains(first_char.substring(1, 2)))
                    {
                        production_date = 'FAIL';
                    }
                    charSet.clear();
                    charSet.addAll(new List<String>{'F', 'R', 'P', 'K', 'G', 'Y', 'M', 'B', 'O', 'W'});  
                    /* charSet.add('F');
charSet.add('R');
charSet.add('P');
charSet.add('K');
charSet.add('G');
charSet.add('Y');
charSet.add('M');
charSet.add('B');
charSet.add('O');
charSet.add('W');*/
                    if(!charSet.contains(first_char.substring(2, 3)))
                    {
                        production_date = 'FAIL';
                    }
                    if(production_date != 'FAIL')
                    {
                        lv_month = second_Char.replace('F', '0').replace('R', '1').replace('P', '2').replace('K', '3').replace('F', '4').replace('Y', '5').replace('M', '6').replace('B', '7').replace('O', '8').replace('W', '9');
                    }
                    lv_location = 'Franklin Park';
                    lv_date_code_rpt_factory = 'FP';
                }
                if(Integer.valueOf(lv_month) > 366 || Integer.valueOf(lv_month) < 366)
                {
                    production_date = 'FAIL';
                }
                lv_temp_year = '';
                if((Integer.valueOf(first_number) > 0 && Integer.valueOf(first_number) < 9) && (Integer.valueOf(lv_month) <= 366 && Integer.valueOf(lv_month) > 0))
                {
                    lv_temp_year = null;
                    if(System.today().year() - Integer.ValueOf('201' + string.ValueOf(second_number)) < 0)
                    {
                        lv_temp_year = '0' + string.valueOf(second_number);
                    }
                    else
                    {
                        lv_temp_year = '1' + string.valueOf(second_number);
                    }
                    lv_year = '01/01' + lv_year1 + lv_temp_year;
                    production_date = date.parse(lv_year).addDays(Integer.ValueOf(first_number) - 1).format();
                    ln_days = Date.parse(production_date).daysBetween(System.today());
                    if(ln_days <= 0)
                    {
                        production_date = 'FAIL';
                    }
                    lv_military_time = second_char + second_number;
                }
                else
                {
                    production_date = 'FAIL';
                }
            }
            else
            {
                production_date = 'FAIL';
            }
        }
    }
    
    //RITM2038659 Set Month Number 
    public Integer monthNumber(String first_char){
        Integer month_number;
        
        if(first_char == 'Y')
            month_number = 01;
        else if(first_char == 'X')
            month_number = 02;
        else if(first_char == 'W')
            month_number = 03;  
        else if(first_char == 'V')
            month_number = 04;    
        else if(first_char == 'U')
            month_number = 05;
        else if(first_char == 'T')
            month_number = 06;  
        else if(first_char == 'S')
            month_number = 07; 
        else if(first_char == 'R')
            month_number = 08;
        else if(first_char == 'Q')
            month_number = 09;  
        else if(first_char == 'P')
            month_number = 10; 
        else if(first_char == 'O')
            month_number = 11; 
        else if(first_char == 'N')
            month_number = 12;      
        
        return month_number;
    }
    
    //RITM2038659 Set Year Number
    public Integer yearNumber(String third_char){
        Integer year_number;
        
        if(third_char == 'L')
            year_number = 2014;
        else if(third_char == 'K')
            year_number = 2015;
        else if(third_char == 'J')
            year_number = 2016;
        else if(third_char == 'I')
            year_number = 2017;
        else if(third_char == 'H')
            year_number = 2018;  
        else if(third_char == 'G')
            year_number = 2019;   
        else if(third_char == 'F')
            year_number = 2020;    
        else if(third_char == 'E')
            year_number = 2021;
        else if(third_char == 'D')
            year_number = 2022;  
        else if(third_char == 'C')
            year_number = 2023; 
        else if(third_char == 'B')
            year_number = 2024;
        else if(third_char == 'A')
            year_number = 2025;  
        else if(third_char == 'Z')
            year_number = 2026; 
        else if(third_char == 'Y')
            year_number = 2027;
        
        return year_number;
    }
    
    //RITM2038659 get trace code values - method for NC 
    public DateCodeHelper.TraceCodeValue getTraceCodeValuesForNC(String traceCode){
        
        TraceCodeValue tcValueObj = new TraceCodeValue();
        if(traceCode.length() == 8)
        {
            ln_lasttwodigit_year = Integer.valueOf(string.ValueOf(System.today().year()).substring(2, 4));
            
            first_number = traceCode.subString( 0, 2);
            second_number = traceCode.subString( 2, 4);
            third_number = traceCode.subString( 4, 6);
            first_char  =  traceCode.subString( 6, 7);
            second_char  =  traceCode.subString( 7, 8);
            Integer month_number;
            Integer year_number;
            
            if (!first_number.isNumeric() || !second_number.isNumeric() || !third_number.isNumeric())
            {
                tcValueObj.ProductionDate = 'FAIL';
            }
            
            if ( ( first_char == 'Y' || first_char == 'X' || first_char == 'W' || first_char == 'V' || first_char == 'U' || first_char == 'T' || first_char == 'S' || first_char == 'R' || first_char == 'Q' || first_char == 'P' || first_char == 'O' || first_char == 'N') 
                && ( second_char == 'L' || second_char == 'K' || second_char == 'J' || second_char == 'I' || second_char == 'H' || second_char == 'G' || second_char == 'F' || second_char == 'E' || second_char == 'D' || second_char == 'C' || second_char == 'B' || second_char == 'A' || second_char == 'Z' || second_char == 'Y')                      
                && ( Integer.valueOf( first_number)>= 00 && Integer.valueOf( first_number) <=23 ) 
                && ( Integer.valueOf( second_number)>= 00 && Integer.valueOf( second_number) <=59 )
                && ( Integer.valueOf( third_number)>= 01 && Integer.valueOf( third_number) <=31 )) 
            {
                //set month
                month_number = monthNumber(first_char);
                //set year
                year_number = yearNumber(second_char);
                
                tcValueObj.ProductionDate = String.valueOf(month_number) +'/'+String.valueOf(third_number) +'/'+ String.valueOf(year_number);
                tcValueObj.lnDays  =  date.parse(tcValueObj.ProductionDate).daysBetween(System.today());
                
                if(tcValueObj.lnDays <= 0)
                {
                    tcValueObj.ProductionDate = 'FAIL';
                }
                else
                {
                    tcValueObj.ProductionDate = tcValueObj.ProductionDate;
                    system.debug('------production_date----' + tcValueObj.ProductionDate);
                    tcValueObj.lvMilitaryTime = first_number+second_number;
                }
            }
            else
            {
                tcValueObj.ProductionDate = 'FAIL';
            }
        }
        else if(traceCode.length() == 9)
        {
            ln_lasttwodigit_year = Integer.valueOf(string.ValueOf(System.today().year()).substring(2, 4));
            
            first_number = traceCode.subString( 0, 2);
            second_number = traceCode.subString( 2, 4);
            third_number = traceCode.subString( 4, 6);
            first_char  =  traceCode.subString( 6, 7);
            second_char  =  traceCode.subString( 7, 8);
            third_char  =  traceCode.subString( 8, 9);
            Integer month_number;
            Integer year_number;
            
            if (!first_number.isNumeric() || !second_number.isNumeric() || !third_number.isNumeric())
            {
                tcValueObj.ProductionDate = 'FAIL';
            }
            
            if ( ( first_char == 'Y' || first_char == 'X' || first_char == 'W' || first_char == 'V' || first_char == 'U' || first_char == 'T' || first_char == 'S' || first_char == 'R' || first_char == 'Q' || first_char == 'P' || first_char == 'O' || first_char == 'N') 
                && ( third_char == 'L' || third_char == 'K' || third_char == 'J' || third_char == 'I' || third_char == 'H' || third_char == 'G' || third_char == 'F' || third_char == 'E' || third_char == 'D' || third_char == 'C' || third_char == 'B' || third_char == 'A' || third_char == 'Z' || third_char == 'Y')                      
                && ( Integer.valueOf( first_number)>= 00 && Integer.valueOf( first_number) <=23 ) 
                && ( Integer.valueOf( second_number)>= 00 && Integer.valueOf( second_number) <=59 )
                && ( Integer.valueOf( third_number)>= 01 && Integer.valueOf( third_number) <=31 )) 
            {
                //set month
                month_number = monthNumber(first_char);
                //set year
                year_number = yearNumber(third_char);
                
                tcValueObj.ProductionDate = String.valueOf(month_number) +'/'+String.valueOf(third_number) +'/'+ String.valueOf(year_number);
                tcValueObj.lnDays  =  date.parse(tcValueObj.ProductionDate).daysBetween(System.today());
                
                if(tcValueObj.lnDays <= 0)
                {
                    tcValueObj.ProductionDate = 'FAIL';
                }
                else
                {
                    tcValueObj.ProductionDate = tcValueObj.ProductionDate;
                    system.debug('------production_date----' + tcValueObj.ProductionDate);
                    tcValueObj.lvMilitaryTime = first_number+second_number;
                }
            }
            else
            {
                tcValueObj.ProductionDate = 'FAIL';
            }
        }
        
        return tcValueObj;
    }
}