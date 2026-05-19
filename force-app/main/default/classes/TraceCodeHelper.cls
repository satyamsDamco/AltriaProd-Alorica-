public class TraceCodeHelper{
    
    String production_date = '';
    String lv_year = '/201';
    String lv_year1 = '/20';
    Integer ln_cnt = 0;
    Integer ln_days = 0; 
    String lv_leap_year = '20';
    String lv_year_new = '/202'; 
    Integer ln_lastdigit_year;
    string lv_cur_year;
    Integer CounterfeitTraceCode = 0;
    string first_char = '';
    string first_number = '';
    string second_char = '';
    string second_number = '';
    string third_char = '';
    string fourth_number = '';
    String third_number = '';
    String cigar7position = '';
    string ln_leap = '0';
    string lv_temp_year;
    string lv_month;
    string lv_day;
    string lv_year2; 
    string year_leep;
    Integer ln_lasttwodigit_year;        
    string lv_year_new1= '20';
    Set<String>  charSet = new Set<String>();
    String productLineCode = '';
    String traceCode = '';
    String fiscal_week = '';
    Financial_Week__c fw = new Financial_Week__c();
    
    
    public Boolean JulianDateChecker(String julday, Integer calyear)
    {
        Boolean isValid = true;
        
        //Check if Julian date value is correct
        if(julday.isNumeric())
        {
            if(Integer.valueOf(julday) == 0)
            {
                isValid = false; //Invalid Julian day
            }
            else
            {
                if (date.isLeapYear(calyear))
                {
                    if(Integer.valueOf(julday) > 366) 
                    {
                        isValid = false; //invalid julian date since leap year is only up to 366 days
                    }
                }
                else
                {
                    if(Integer.valueOf(julday) > 365) 
                    {
                        isValid = false; //invalid julian date since non leap year is only up to 365 days
                    }
                }   
            }   
        }
        else
        {
            isValid = false; //Julian date provided is invalid    
        }
        
        return isValid;
    }
    
    public String ProductDateCalculator(String traceCode, String productCode)
    {
        if(productCode == 'IQ')
        {
            //Made calculation dynamic
            String lv_year,lv_cur_year,lv_year_new,lv_leap_year, ln_leap='0', production_date;
            Integer ln_days;
            
            lv_cur_year = string.valueOf(System.today().year());
            lv_year = '/' + string.valueOf((integer.valueOf(lv_cur_year) - 10)).substring(0,3);
            lv_year_new = '/' + lv_cur_year.substring(0,3);
            
            String second_number  =  traceCode.subString( 4, 5);
            String third_number  =  traceCode.subString( 5, 8);
            String fourth_number =   traceCode.subString( 8,  10);
            String lv_temp_year;
            
            if(second_number.isNumeric() && integer.valueof(third_number) >= 001 && integer.valueof(third_number) <= 366 && integer.valueof(fourth_number) >= 00 && integer.valueof(fourth_number) <= 23)
            {
                if((Integer.valueOf(lv_cur_year) - Integer.valueOf( lv_year_new.subString(1,4) + String.valueOf(second_number))) <0)
                {
                    lv_temp_year  = String.valueOf(lv_year.subString(3, 4)) + String.valueOf(second_number);
                }
                else
                {
                    lv_temp_year  = String.valueOf(lv_cur_year.subString(2, 3)) + String.ValueOf(second_number);
                }
                lv_year  = '01/01/' + lv_cur_year.subString(0, 2) + lv_temp_year;   
                production_date  =   date.parse(lv_year).addDays(Integer.valueOf(third_number) - 1).format();
                ln_days  =  date.parse(production_date).daysBetween(System.today());                   
                
                if(ln_days <= 0)
                {
                    System.debug('========================================== IQOS days fail');
                    return 'fail';
                }
                else
                { 
                    System.debug('========================================== IQOS success');
                    return production_date;
                } 
            }
            else
            {
                System.debug('========================================== IQOS Fail');
                return 'fail';
            }
        }
        else if (productCode == 'TDNP') // Product code is TDNP - Tobacco Derived Nicotine Pouch
        {
            //RITM0266931: SCR 20-02-25 Trace Codes - Helix ON 9 and 7 Character Codes Ver 2.0
            String prodYear, prodDayAndMonth;
            String productionDate = null;
            Integer final_year;
            Integer final_month;
            Integer yearStart_cycle = 0;
            Date final_date;
            List<String> pattern = new List<String>();
            Date dateToProcess = System.today();
            //Use custom label for testing with future dates
            if(Label.Override_date != 'yyyy-mm-dd') 
            {
                dateToProcess = date.valueOf(Label.Override_date);
            }
            //Start: RITM0846391
            if(traceCode.length() == 1)
            {
                if(traceCode.contains('M') || traceCode.contains('U') || traceCode.contains('S') ){
                    productionDate = 'NODATE';    
                }else{
                    productionDate = null;
                }
                
            }
            if(traceCode.length() == 6){
                //RITM2836453
                system.debug('control in 6 charcter');
                productionDate = sixCharacterProductDate(traceCode);
                return productionDate; 
            }
            
            //End: RITM0846391
            if(traceCode.length() == 7)
            {
                prodYear = traceCode.substring(0,1);
                prodDayAndMonth = traceCode.substring(1,2);
                
                if(prodYear == 'W')
                {
                    final_year = 2019;
                }
                else if(prodYear == 'U' || prodYear == 'X')
                {
                    final_year = 2020;
                }
                else if(prodYear == 'Y')
                {
                    final_year = 2021;
                }
                else if(prodYear == 'Z')
                {
                    final_year = 2022;
                }
                else
                { 
                    return null; //Invalid First Character
                }
                
                if(prodDayAndMonth.isAlpha())
                {
                    pattern.addAll(new List<String>{'A', 'B', 'C', 'D','E','F','G','H','I','K','L','M'});
                    if(pattern.contains(prodDayAndMonth))
                    {
                        for(Integer i = 0; i<12; i++)
                        {
                            if(prodDayAndMonth == pattern[i]){final_month = i+1; break;}  
                        }
                    }
                }
                else
                {
                    return null; //Invalid 2nd character
                }
                
                final_date = date.newInstance(final_year,final_month,1);
                //Check if derived date is less than the system date
                if(final_date < dateToProcess)
                {
                    //date format to pass MM/DD/YYYY
                    productionDate = String.valueOf(final_date.format());       
                }
                else
                {
                    return null; //Production date must be less than the System Date.
                }
                
            }
            if(traceCode.length() == 9 || traceCode.length() == 10)
            {
                //SCR 2025-11-03: 10-character trace codes use same logic as 9-character for production date
                //The 10th character is only used for Machine Code calculation (handled in DateCodeHelper)
                prodYear = traceCode.substring(0,1);
                prodDayAndMonth = traceCode.substring(1,4);//D261N0912
                /*
if(prodYear == 'D'){yearStart_cycle = 2024;}
else if(prodYear == 'R'){yearStart_cycle = 2021;}
else if(prodYear == 'C'){yearStart_cycle = 2022;}
else if(prodYear == 'M') {yearStart_cycle = 2023;}
else{return null;} // Invalid First Character

pattern.addAll(new List<String>{'D', 'R', 'C', 'M'});

Integer current_year = integer.valueOf(dateToProcess.year());
Integer base_year = current_year - 2020;
Integer addYears = 0;
Boolean first_cycle = true;
if (base_year > 3) //If 4 years or more is the difference we are in a new cycle
{
Integer cycles = base_year / 4;
addYears = cycles * 4;
final_year =  2020 + addYears;
base_year = current_year - final_year;
first_cycle = false;
}

//Get allowed characters for the year, this is only done on the first cycle
List<String> validChar = new List<String>();
for(Integer i=0;i<=base_year;i++)
{
validChar.add(pattern[i]);
}

if(!(validChar.contains(prodYear)) && first_cycle == true)
{
return null; //firstChar is not valid
}

if(validChar.contains(prodYear))
{
final_year = yearStart_cycle + addYears;
}
else
{
final_year = yearStart_cycle + addYears - 4;
}
*/
                Map<String, Integer> yearMapping = new Map<String, Integer>{
                    'R' => 2021, 'C' => 2022, 'M' => 2023, 'D' => 2024,
                        '5' => 2025, '6' => 2026, '7' => 2027, '8' => 2028, '9' => 2029,
                        '0' => 2030, '1' => 2031, '2' => 2032, '3' => 2033, '4' => 2034
                        };
                            
                            if (yearMapping.containsKey(prodYear)) {
                                final_year = yearMapping.get(prodYear);
                            } else {
                                return null; // Invalid First Character
                            }
                
                if(!JulianDateChecker(prodDayAndMonth,final_year)){
                    return null; //Julian provided is invalid
                }
                
                final_date = date.newInstance(final_year,1,1);
                final_date = final_date.addDays(Integer.valueOf(prodDayAndMonth)-1);
                //Check if derived date is less than the system date
                if(final_date < dateToProcess)
                {
                    //date format to pass MM/DD/YYYY
                    productionDate = String.valueOf(final_date.format());
                }
                else
                {
                    return null; //Production Date must be less than System Date
                }
                
            }
            return productionDate;   
        } 
        else if (productCode == 'PT')//Start: RITM0906850 - SCR 21-01-11 Trace Codes - Pipe Tobacco 12 Character
        {
            String julian_date = tracecode.substring(1, 4);
            String year_char = tracecode.substring(5, 6);
            Integer final_year;
            string production_date;
            Date dateToProcess = System.today();
            
            if(!year_char.isNumeric()){
                return null;// Should be numeric
            }
            //To test future dates
            if(Label.Override_date != 'yyyy-mm-dd') 
            {
                dateToProcess = date.valueOf(Label.Override_date);
            }
            
            Integer current_year = integer.valueOf(dateToProcess.year());
            Integer base_year = current_year - 2020; 
            Integer addYears = 0;
            if (base_year > 9) //If 10 years or more is the difference we are in a new cycle 
            {
                Integer cycles = base_year / 10;
                addYears = cycles * 10; 
                final_year =  2020 + addYears + integer.valueOf(year_char);   
            }
            else{
                final_year = 2020 + integer.valueOf(year_char);
            }
            
            if(final_year > current_year){
                final_year = final_year - 10;
            }
            
            if(!JulianDateChecker(julian_date,final_year)){
                return null; //Julian provided is invalid
            }
            
            Date final_date;                
            final_date = date.newInstance(final_year,1,1);
            final_date = final_date.addDays(Integer.valueOf(julian_date)-1);
            
            System.debug(final_date);
            //Check if derived date is less than the system date
            if(final_date < dateToProcess)
            {
                //date format to pass MM/DD/YYYY
                production_date = String.valueOf(final_date.format());      
            }
            else
            {
                return null; //Production Date must be less than System Date
            }
            
            return production_date;
        }//End: RITM0906850
        
        //Added by Sachin Shah
        //Start :Product Code is SNP - SYNTHETIC NICOTINE POUCH
        else if(productCode == 'SNP'){
            String prodYear, prodDayAndMonth;
            String productionDate = null;
            Integer final_year;
            Integer final_month;
            Integer yearStart_cycle = 0;
            Date final_date;
            List<String> pattern = new List<String>();
            Date dateToProcess = System.today();
            
            if(Label.Override_date != 'yyyy-mm-dd') 
            {
                dateToProcess = date.valueOf(Label.Override_date);
            }
            
            if(traceCode.length() == 9)
            {
                prodYear = traceCode.substring(0,1);
                prodDayAndMonth = traceCode.substring(1,4);
                
                if(prodYear == 'D'){yearStart_cycle = 2020;}
                else if(prodYear == 'R'){yearStart_cycle = 2021;}
                else if(prodYear == 'C'){yearStart_cycle = 2022;}
                else if(prodYear == 'M') {yearStart_cycle = 2023;}
                else{return null;} // Invalid First Character
                
                pattern.addAll(new List<String>{'D', 'R', 'C', 'M'});
                
                Integer current_year = integer.valueOf(dateToProcess.year());
                Integer base_year = current_year - 2020; 
                Integer addYears = 0;
                Boolean first_cycle = true;
                if (base_year > 3) //If 4 years or more is the difference we are in a new cycle 
                {
                    Integer cycles = base_year / 4;
                    addYears = cycles * 4; 
                    final_year =  2020 + addYears;
                    base_year = current_year - final_year;
                    first_cycle = false;
                }
                
                //Get allowed characters for the year, this is only done on the first cycle
                List<String> validChar = new List<String>();
                for(Integer i=0;i<=base_year;i++)
                {
                    validChar.add(pattern[i]);
                }
                
                if(!(validChar.contains(prodYear)) && first_cycle == true)
                {
                    return null; //firstChar is not valid
                }
                
                if(validChar.contains(prodYear))
                {
                    final_year = yearStart_cycle + addYears;    
                }
                else
                {
                    final_year = yearStart_cycle + addYears - 4;
                }
                
                if(!JulianDateChecker(prodDayAndMonth,final_year)){
                    return null; //Julian provided is invalid
                } 
                
                final_date = date.newInstance(final_year,1,1);
                final_date = final_date.addDays(Integer.valueOf(prodDayAndMonth)-1);
                //Check if derived date is less than the system date
                if(final_date < dateToProcess)
                {
                    //date format to pass MM/DD/YYYY
                    productionDate = String.valueOf(final_date.format());       
                }
                else
                {
                    return null; //Production Date must be less than System Date
                }
                
                
            }
            
            
            return productionDate;
        }
        
        //Added by Affirma RITM1898013 
        //Start :Product Code is TDNS - Tobacco Derived Nicotine Spray
        else if(productCode == 'TDNS')
        {
            String prodYear, prodDayAndMonth;
            String productionDate = null;
            Integer final_year;
            Integer final_month;
            Integer yearStart_cycle = 0;
            Date final_date;
            List<String> pattern = new List<String>();
            Date dateToProcess = System.today();
            
            if(Label.Override_date != 'yyyy-mm-dd') 
            {
                dateToProcess = date.valueOf(Label.Override_date);
            }
            
            if(traceCode.length() == 9)
            {
                prodYear = traceCode.substring(0,1);
                prodDayAndMonth = traceCode.substring(1,4);
                
                if(prodYear == 'D'){yearStart_cycle = 2020;}
                else if(prodYear == 'R'){yearStart_cycle = 2021;}
                else if(prodYear == 'C'){yearStart_cycle = 2022;}
                else if(prodYear == 'M') {yearStart_cycle = 2023;}
                else{return null;} // Invalid First Character
                
                pattern.addAll(new List<String>{'D', 'R', 'C', 'M'});
                
                Integer current_year = integer.valueOf(dateToProcess.year());
                Integer base_year = current_year - 2020; 
                Integer addYears = 0;
                Boolean first_cycle = true;
                if (base_year > 3) //If 4 years or more is the difference we are in a new cycle 
                {
                    Integer cycles = base_year / 4;
                    addYears = cycles * 4; 
                    final_year =  2020 + addYears;
                    base_year = current_year - final_year;
                    first_cycle = false;
                }
                
                //Get allowed characters for the year, this is only done on the first cycle
                List<String> validChar = new List<String>();
                for(Integer i=0;i<=base_year;i++)
                {
                    validChar.add(pattern[i]);
                }
                
                if(!(validChar.contains(prodYear)) && first_cycle == true)
                {
                    return null; //firstChar is not valid
                }
                
                if(validChar.contains(prodYear))
                {
                    final_year = yearStart_cycle + addYears;    
                }
                else
                {
                    final_year = yearStart_cycle + addYears - 4;
                }
                
                if(!JulianDateChecker(prodDayAndMonth,final_year)){
                    return null; //Julian provided is invalid
                } 
                
                final_date = date.newInstance(final_year,1,1);
                final_date = final_date.addDays(Integer.valueOf(prodDayAndMonth)-1);
                //Check if derived date is less than the system date
                if(final_date < dateToProcess)
                {
                    //date format to pass MM/DD/YYYY
                    productionDate = String.valueOf(final_date.format());       
                }
                else
                {
                    return null; //Production Date must be less than System Date
                }
                
                
            }
            
            
            return productionDate;
        }
        //End 
        else //productCode == 'AS' and productCode == 'GP'
        {
            //position 2,3,4, first number, numeric  --- <<<production day and month>>>
            String first_number  =  traceCode.substring(1,4);
            //position 6, second number, numeric --- <<<productin year>>>
            String second_number  =  traceCode.substring(5,6);
            
            //Made calculation dynamic
            String lv_year,lv_cur_year,lv_year_new,lv_leap_year, ln_leap='0', production_date;
            Integer ln_days;
            
            lv_cur_year = string.valueOf(System.today().year());
            lv_year = '/' + string.valueOf((integer.valueOf(lv_cur_year) - 10)).substring(0,3);
            lv_year_new = '/' + lv_cur_year.substring(0,3);
            
            
            if(( Integer.valueOf( first_number)>= 1 && Integer.valueOf( first_number) <=366 ) && ( Integer.valueOf( second_number)>= 0 && Integer.valueOf( second_number) <= 9)){
                
                if (Integer.valueOf( second_number)== Integer.valueOf(lv_cur_year.substring(3,4)))
                { 
                    lv_year  = '01/01' + lv_year_new.subString( 0, 4)+ second_number.subString( 0, 1);
                }else{ 
                    if(Integer.valueOf( lv_cur_year)>= Integer.valueOf( lv_year_new.subString(1,4) + second_number.subString( 0, 1)))
                    { 
                        lv_year  = '01/01' + lv_year_new.subString( 0, 4)+ second_number.subString( 0, 1);
                    }else{ 
                        lv_year  = '01/01' + lv_year.subString( 0, 4)+ second_number.subString( 0, 1);
                    }
                    
                }
                lv_leap_year = '20';   
                if(second_number.length() >= 2){
                    lv_leap_year  = lv_leap_year + second_number.subString(0,2);
                }else{
                    lv_leap_year  = lv_leap_year + '0' + second_number; 
                }                                    
                Date dt = Date.parse('02/01/'+String.valueOf(lv_leap_year)).addMonths(1);
                ln_leap  = String.ValueOf(dt.addDays(-dt.day()).day());
                if(Integer.valueOf(ln_leap) == 28)
                {
                    if (Integer.valueOf( first_number) > 365) 
                    {
                        System.debug('========================================== 71');
                        return 'fail';
                    }else{   
                        production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                    } 
                }else{   
                    production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                } 
                ln_days  =  date.parse(production_date).daysBetween(System.today());
                
                if(productCode == 'AS')
                {
                    return production_date;
                }else
                {
                    if (ln_days <= 0){ 
                        System.debug('========================================== 72');
                        return 'fail';
                    }else{ 
                        System.debug('========================================== 73');
                        return production_date;
                    } 
                }
                
            }else{ 
                System.debug('========================================== 74');
                return 'fail';
            }
        }
    }
    
    public String sixCharacterProductDate(string traceCode){
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
                                boolean validOrNot = true;    
        string Month;
        string Year; 
        if(firstDigit.containsKey(traceCode.substring(0, 1))){
            Year = firstDigit.get(traceCode.substring(0, 1));
            system.debug('Year Value' + Year);
        }
        else{
            validOrNot= false;
        }
        if(secondDigit.containsKey(traceCode.substring(1, 2))){
            Month = secondDigit.get(traceCode.substring(1, 2));
            system.debug('Month' + Month);
        } 
        else{
            validOrNot = false;
        }
        
        string DateValue = Month +'/01/' +Year ;
        system.debug('Valid or Not '+ validOrNot);
        String numericSubstring = traceCode.substring(2, 6);
        
        system.debug('Date is '+DateValue);
        if(validOrNot && Date.today() >= Date.parse(DateValue) && numericSubstring.isNumeric()) {
            
            Return DateValue;
        }
        else{
            return null;
        }
        
    }
    
    public Date convertProductDate(String production_date)
    {
        //Convert production_date to readable date format
        String pmonth,pday,pyear;
        pmonth = production_date.substring(0,production_date.indexOf('/'));
        production_date = production_date.substring(production_date.indexOf('/')+1,production_date.length());
        pday = production_date.substring(0,production_date.indexOf('/'));
        production_date = production_date.substring(production_date.indexOf('/')+1,production_date.length());
        pyear = production_date;   
        return Date.newInstance(Integer.valueOf(pyear), Integer.valueOf(pmonth), Integer.valueOf(pday));
    }
    
    public static Boolean checkCounterfeitTraceCode(String traceCode){
        List<CounterfeitTraceCode__c>  coutTrace = new List<CounterfeitTraceCode__c>([Select id,Production_Date__c from CounterfeitTraceCode__c where Trace_Code__c=:traceCode and IsActive__c = true]);
        
        if(!coutTrace.isEmpty() && coutTrace.size() >0)
        {
            System.debug('========================================== 1');
            return true;
        }
        System.debug('========================================== 2');
        return  false;
    }     
    
    public String traceCodeValidation(string productLine, string traceCodeObj, string oprCompany, string traceCodeLocation, case caseObj){
        try
        {
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
            Boolean goodDate = false;
            String dayString = '';
            Date myRetDate;
            
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
                    
                    String workProductCode = productLine;
                    System.debug('workProductCode'+workProductCode);
                    if(workProductCode == 'SP' || workProductCode == 'PC' || workProductCode == 'DS' || workProductCode == 'UU')
                    {
                        System.debug('inside if');
                        //We have a trace code for this criteria.  Check to make sure we havea  valid number for production day
                        if(!workTraceCode.substring(1,4).isNumeric())
                        {
                            return 'fail';
                        }
                        
                        String firstCharacter = workTraceCode.substring(0,1);
                        String productionDay = workTraceCode.substring(1,4);
                        Integer intProdDay = Integer.valueOf(productionDay);
                        
                        //Check for a good day... > 0 and < 365
                        if(intProdDay < 1 || intProdDay > 366)
                        {
                            return 'fail';
                        }
                        
                        //RITM2890914
                        if (firstCharacter == 'K' || firstCharacter == 'O' || firstCharacter == 'B' || firstCharacter == 'A') {
                            string productDate = TraceCodeHelperSecondClass.validateTraceCode(workTraceCode);
                            return productDate;
                        }
                        
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
                        
                        Boolean IfValidMc_Usst = (workDate >= Date.newInstance(2018,08,01));
                        
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
                            goodDate = true;
                        }
                        //------------------------------
                        //------------------------------
                        //Virginia location
                        //------------------------------                        
                        
                        if(firstCharacter == 'R' || firstCharacter == 'C' || firstCharacter == 'M' || firstCharacter == 'D'
                           || firstCharacter == 'Q' || firstCharacter == 'J' || (firstCharacter == 'T' && IfValidMc_Usst) || firstCharacter == 'W')
                        {
                            if(firstCharacter == 'R'  || firstCharacter == 'W')
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
                            goodDate = true;
                        }
                        //------------------------------
                        //------------------------------
                        //Franklin Park location
                        //------------------------------ 
                        //Franklin Park is closing in 2017, so we only need trace codes for 2017
                        if(firstCharacter == 'Y')
                        {
                            baseDate = Date.newInstance(2016, 1, 1);
                            
                            intProdDay = intProdDay - 1; //Subtract one day because you are starting on day 1
                            
                            myRetDate = baseDate.addDays(intProdDay);
                            
                            dayString = myRetDate.format();
                            goodDate = true;
                        }   
                        //------------------
                        if(firstCharacter == 'T' && !IfValidMc_Usst)
                        {
                            baseDate = Date.newInstance(2017, 1, 1);
                            
                            intProdDay = intProdDay - 1; //Subtract one day because you are starting on day 1
                            
                            myRetDate = baseDate.addDays(intProdDay);
                            
                            dayString = myRetDate.format();
                            goodDate = true;
                        }                   
                        //*************************************************
                        //Ok, now let's check for a good date.  If we have a good date then we need to check a couple of other rules before returning it
                        //*************************************************
                        if(goodDate == true)
                        {
                            //Check other rules before return
                            goodDate = false;  //resetting good date to false.  If rules pass, then reset goodDate back to true
                            
                            if(myRetDate > system.today())
                            {
                                //Start: RITM0876454: Corrected - year cycle must be reset to a new cycle if a date is a future date
                                myRetDate = Date.newInstance(myRetDate.year()-4, myRetDate.month(), myRetDate.day());
                                dayString = myRetDate.format();
                                //End: RITM0876454: Corrected - year cycle must be reset to a new cycle if a date is a future date
                            }
                            //-----------------------------------------
                            
                            String fifthCharDateCodeUnit = workTraceCode.substring(4,5);
                            
                            //Now let's make sure we have a valid DateCodeUnit
                            //=================================================
                            if(firstCharacter == 'N' || firstCharacter == 'S' || firstCharacter == 'H' || firstCharacter == 'V'
                               || firstCharacter == 'A' || firstCharacter == 'E' || firstCharacter == 'B' || firstCharacter == 'K')  //Nashville
                            {
                                //Valid Unit codes for Nashville
                                charSet.clear();
                                charSet.add('N');
                                charSet.add('S');
                                charSet.add('H');
                                charSet.add('I');
                                charSet.add('V');
                                charSet.add('L');
                                charSet.add('E');
                                charSet.add('A');
                                charSet.add('B');
                                charSet.add('P');
                                charSet.add('R');
                                charSet.add('C');
                                charSet.add('M');
                                charSet.add('2');
                                charSet.add('3');
                                
                                if(charSet.contains(fifthCharDateCodeUnit))
                                {
                                    goodDate = true;
                                }
                                else
                                {
                                    return 'fail';
                                }
                            }
                            //---------------------------------------------------------
                            
                            if(firstCharacter == 'R' || firstCharacter == 'C' || firstCharacter == 'M' || firstCharacter == 'D'
                               || firstCharacter == 'Q' || firstCharacter == 'J' || (firstCharacter == 'T' && IfValidMc_Usst) || firstCharacter == 'W')  //Virginia
                            {
                                //Valid Unit codes for Virginia
                                // 1-16-2018: SCR 18-01-10 2018 Trace Codes - USST 9-Character Richmond Manufacturing Center: New valid unit codes for Virginia
                                charSet.clear();
                                charSet.add('K');
                                charSet.add('G');
                                charSet.add('T');
                                charSet.add('Y');
                                charSet.add('Z'); 
                                charSet.add('D');
                                
                                if(charSet.contains(fifthCharDateCodeUnit))
                                {
                                    goodDate = true;
                                }
                                else
                                {
                                    return 'fail';
                                }
                            }
                            //---------------------------------------------------------
                            if(firstCharacter == 'Y' || (firstCharacter == 'T' && !IfValidMc_Usst))  //Franklin Park
                            {
                                //Valid Unit codes for Franklin Park
                                charSet.clear();
                                charSet.add('Y');
                                charSet.add('O');
                                charSet.add('F');
                                charSet.add('G');
                                charSet.add('Z');   
                                charSet.add('M');   
                                charSet.add('K');   
                                charSet.add('W');    
                                charSet.add('X');  
                                charSet.add('J'); 
                                charSet.add('E');        
                                
                                if(charSet.contains(fifthCharDateCodeUnit))
                                {
                                    goodDate = true;
                                }
                                else
                                {
                                    return 'fail';
                                }
                            }
                            //=================================================
                            //Now let's make sure we have a good military time
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
                                        goodDate = true;
                                    }
                                    else
                                    {
                                        return 'fail';
                                    }
                                }
                                else
                                {
                                    return 'fail';
                                }
                            }
                            else
                            {
                                return 'fail';
                            }
                            //--------------------------
                            if(goodDate = true)
                            {
                                return dayString;
                            }
                        }
                        //*************************************************
                        //*************************************************
                    }
                }
                else{
                    
                }
            }
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            
            productLineCode = productLine;
            traceCode = traceCodeObj.toUpperCase();
            productLineCode = productLineCode.toUpperCase();
            traceCodeLocation = traceCodeLocation.toUpperCase();
            
            if(productLineCode  == 'SP')
                oprCompany = 'USST';
            
            if(oprCompany == null || oprCompany == '')
                oprCompany = 'ZZ';
            else
                oprCompany = oprCompany.trim().toUpperCase();
            
            System.debug('SS 2022'+oprCompany);
            List<CounterfeitTraceCode__c>  coutTrace = new List<CounterfeitTraceCode__c>([Select id,Production_Date__c from CounterfeitTraceCode__c where IsActive__c = true and Trace_Code__c=:traceCode]);
            System.debug('SS 2022-->coutTrace' +coutTrace);
            CounterfeitTraceCode = coutTrace.size();
            if(!coutTrace.isEmpty() && coutTrace.size() >0){                          
                if(coutTrace[0].Production_Date__c  != null)
                {    
                    production_date  = coutTrace[0].Production_Date__c.format();  
                    return production_date;     
                }
                else
                {
                    System.debug('========================================== 3');
                    return '';
                }                 
            }
            
            If(productLineCode.toUpperCase() == 'EV')
            {
                first_number  =  traceCode.subString( 0, 3);
                //if(traceCode.indexOf('O') >= 0 || traceCode.indexOf(' ') >= 0 || traceCode.length() > 3 || traceCode.length() < 3 || !first_number.isNumeric() || traceCode.length() != 7)
                
                if((traceCode.length() !=3 && traceCode.length() != 7) || (traceCode.length() == 3 && !first_number.isNumeric()))
                {   
                    System.debug('========================================== 4');          
                    return 'fail';
                }
                else If (traceCode.indexOf('O') < 0 && traceCode.indexOf(' ') < 0 && traceCode.length() == 3)
                {        
                    System.debug('========================================== 5');     
                    return 'NODATE';
                } 
                //12-5-2017 ggcutchon: SCR 17-10-26 2017 2017 Trace Codes - Green Smoke 7 and 3 Character
                if(traceCode.length() == 7 ){ //BG0117C
                    first_char  =  traceCode.subString( 0, 1); // B
                    first_number  =  traceCode.subString( 1, 2); // G
                    second_char  =  traceCode.subString( 2, 4); // 01
                    second_number  =  traceCode.subString( 4, 6); // 17
                    third_char  =  traceCode.subString( 6, 7); // C
                    fiscal_week = second_char + second_number;
                    
                    if((first_number != 'A' && first_number != 'B' && first_number != 'C' && first_number != 'D' && first_number != 'G' && first_number != 'S' && first_number != 'X') || (Integer.ValueOf(second_char) < 01 || Integer.ValueOf(second_char) > 53) || (Integer.ValueOf(second_number) < 14|| !second_number.isNumeric()) ){
                        system.debug('======================= EV 7 character fail');
                        return 'fail';
                    }
                    else{
                        if(fiscal_week != '' || fiscal_week != null){
                            fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];
                            if(fw != null){
                                production_date = fw.PRODUCTION_DATE__c;
                                return production_date;
                            }
                        }     
                    }
                }
                //--------------------------------------------------------------------
            }
            
            If (traceCodeLocation != 'CAS')
            {     
                If (productLineCode == 'AS' && traceCode.length() != 9 && traceCode.length() != 11)     
                {       
                    System.debug('========================================== 6');
                    return 'fail';                 
                }               
                else if ((productLineCode == 'SP' || productLineCode == 'TP' || productLineCode == 'DS' || productLineCode == 'PC' || productLineCode == 'MD' || productLineCode == 'GFU' || productLineCode == 'SB' || productLineCode == 'UU' ) && traceCode.length() != 9 )  
                {       
                    System.debug('========================================== 7');
                    return 'fail'; 
                }                   
                else if (productLineCode == 'GP' && traceCode.length() != 7 && traceCode.length() != 5  &&  traceCode.length() != 8 &&  traceCode.length() != 11 && traceCode.length() != 12 && traceCode.length() != 9 && traceCode.length() != 1 )
                {
                    System.debug('========================================== 8');
                    return 'fail';                
                }
                else if (productLineCode == 'PT' && traceCode.length() != 5  && traceCode.length() != 4 && traceCode.length() != 2 && traceCode.length() != 7 && traceCode.length() != 6 && traceCode.length() != 12)
                {
                    System.debug('========================================== 9');    
                    return 'fail'; 
                }
                else if (productLineCode == 'CD' && traceCode.length() != 4)  
                {          
                    System.debug('========================================== 10'); 
                    return 'fail';                              
                }
                else if (productLineCode == 'EC' && traceCode.length() != 8  && traceCode.length() != 7  && traceCode.length() != 6  && traceCode.length() != 11)      
                {       
                    System.debug('========================================== 11');
                    return 'fail'; 
                }
                else if (productLineCode == 'DNUA' && traceCode.length() != 8  && traceCode.length() != 9 && traceCode.length() != 10)
                {
                    System.debug('========================================== 12');
                    return 'fail';   
                }
                else if (productLineCode == 'TDNP' && traceCode.length() != 1 && traceCode.length() != 7 && traceCode.length() != 9 && traceCode.length() != 10 && traceCode.length() != 6)
                {
                    return 'fail';
                }
            }
            else
            {
                if (oprCompany == 'PMUSA' && traceCode.length() == 19)
                {                              
                    if (traceCode.substring(1,4).isNumeric() && traceCode.substring(5,7).isNumeric() && traceCode.substring(8,19).isNumeric())
                    {                
                        System.debug('========================================== 13'); 
                        production_date = 'NODATE';
                        return production_date;
                    }
                    else
                    {
                        System.debug('========================================== 14');
                        return 'fail';
                    }
                }
                
                if(oprCompany == 'USST' && traceCode.length() == 8)
                {                  
                    if(traceCode.substring(1,8).isNumeric() && !traceCode.substring(0,1).isNumeric())
                    {                    
                        System.debug('========================================== 15');
                        production_date = 'NODATE';
                        return production_date;
                    }
                    else
                    { 
                        System.debug('========================================== 16');
                        return 'fail';
                    }   
                }
                IF (oprCompany == 'JMC' && traceCode.length() == 5)
                {                  
                    if(traceCode.substring(0,3).isNumeric() && traceCode.substring(4,5).isNumeric() && Integer.ValueOf(traceCode.subString(4,5)) >= 1 && Integer.ValueOf(traceCode.subString(4,5)) <= 4  
                       && !traceCode.substring(3,4).isNumeric() 
                       && (traceCode.substring(3,4) == 'X' || traceCode.substring(3,4) =='Y' || traceCode.substring(3,4) == 'Z'))
                    {
                        System.debug('========================================== 17');
                        production_date = 'NODATE';
                        return production_date;
                    }
                    else
                    {   
                        System.debug('========================================== 18');                  
                        return 'fail';
                    }
                }
                
                if(productLineCode == 'TP' && traceCodeLocation == 'CAS' && (traceCode.length() == 10 || traceCode.length() == 15  || traceCode.length() == 9))
                {                
                    if(traceCode.length() == 9){ 
                        
                        if( traceCode.substring(0,1) == 'N'  && traceCode.substring(1,4).isNumeric()  && !traceCode.substring(4,5).isNumeric()
                           && (traceCode.substring(4,5)  == 'X' || traceCode.substring(4,5)  ==  'Y' || traceCode.substring(4,5)  == 'Z')
                           && traceCode.substring(5,6).isNumeric() &&  traceCode.substring(6,7) == 'X' && traceCode.substring(7,9).isNumeric()){ 
                               
                               if(Integer.ValueOf(traceCode.substring(7,9)) >= 1 && Integer.ValueOf(traceCode.substring(7,9)) <= 53)
                               {                          
                                   production_date = 'NODATE';
                                   System.debug('========================================== 19');
                                   return production_date;
                                   
                               }
                               else
                               {
                                   System.debug('========================================== 20');
                                   return 'fail';
                               } 
                               
                           }
                        else if(traceCode.substring(0,1) == 'L'  && traceCode.substring(1,4).isNumeric()  && !traceCode.substring(4,5).isNumeric()  
                                && (traceCode.substring(4,5)  == 'X' || traceCode.substring(4,5)  ==  'Y'|| traceCode.substring(4,5)  == 'Z')
                                && traceCode.substring(5,6).isNumeric() && traceCode.substring(6,9).isNumeric())
                        {
                            
                            IF (Integer.ValueOf(traceCode.substring(1,4)) >= 1 && Integer.ValueOf(traceCode.substring(1,4)) <= 366 && traceCode.substring(6,9) == '000')
                            {                      
                                production_date = 'NODATE';
                                System.debug('========================================== 21');
                                return production_date;
                                
                            }
                            else
                            {
                                System.debug('========================================== 22');
                                return 'fail';
                            }
                            
                        }else if(traceCode.substring(0,3).isNumeric() && traceCode.substring(3,4).isNumeric() && traceCode.substring(4,8).isNumeric()
                                 && (Integer.ValueOf(traceCode.substring(4,6)) >= 0 && Integer.ValueOf(traceCode.substring(4,6)) <= 23 )  
                                 && (Integer.ValueOf(traceCode.substring(6,8)) >= 0 && Integer.ValueOf(traceCode.substring(6,8)) <= 59 )  
                                 && (traceCode.substring(9,1) == 'N' || traceCode.substring(9,1) == 'S' || traceCode.substring(9,1) == 'H' || traceCode.substring(9,1) == 'V'
                                     || traceCode.substring(9,1) == 'I' || traceCode.substring(9,1) == 'L' || traceCode.substring(9,1) == 'E' || traceCode.substring(9,1) == 'A'
                                     || traceCode.substring(9,1) == 'B' || traceCode.substring(9,1) == 'P' || traceCode.substring(9,1) == 'Y' || traceCode.substring(9,1) == 'O'
                                     || traceCode.substring(9,1) == 'F' || traceCode.substring(9,1) == 'G' || traceCode.substring(9,1) == 'Z' || traceCode.substring(9,1) == 'M'
                                     || traceCode.substring(9,1) == 'R' || traceCode.substring(9,1) == 'K' || traceCode.substring(9,1) == 'W' || traceCode.substring(9,1) == '1'
                                     || traceCode.substring(9,1) == 'X' || traceCode.substring(9,1) == '2' || traceCode.substring(9,1) == '3')
                                ){
                                    
                                    IF (Integer.ValueOf(traceCode.substring(0,3)) >= 1 && Integer.ValueOf(traceCode.substring(0,3)) <= 366)
                                    {                      
                                        production_date = 'NODATE';
                                        System.debug('========================================== 23');
                                        return production_date;
                                        
                                    }
                                    else
                                    {
                                        System.debug('========================================== 24');
                                        return 'fail';
                                    } 
                                    
                                }
                        else
                        {
                            System.debug('========================================== 25');
                            return 'fail';
                        }    
                    }
                    
                    
                    if(traceCode.length() == 10){ 
                        
                        if( traceCode.substring(1,10).isNumeric() && !traceCode.substring(0,1).isNumeric())
                        {                     
                            production_date = 'NODATE';
                            System.debug('========================================== 26');
                            return production_date;
                        }
                        else
                        {
                            System.debug('========================================== 27');
                            return 'fail';
                        }
                        
                    }else if  (traceCode.length() == 15){
                        
                        if ( !traceCode.substring(0,1).isNumeric()  && traceCode.substring(1,4).isNumeric() && !traceCode.substring(4,5).isNumeric()
                            && traceCode.substring(5,6).isNumeric() && !traceCode.substring(6,7).isNumeric()&& traceCode.substring(7,15).isNumeric() )
                        {
                            System.debug('========================================== 28');
                            production_date = 'NODATE';
                            return production_date;
                            
                        }
                        else
                        {
                            System.debug('========================================== 29');
                            return 'fail';
                        }   
                    }   
                }
            }
            
            lv_cur_year  =  String.ValueOf(System.Today().year());
            
            ln_lastdigit_year  =  Integer.valueOf(lv_cur_year.substring(3,4));
            
            if (oprCompany != 'USST'){ //gccutchon
                
                if (productLineCode == 'AS')
                {                         
                    first_char  =  traceCode.substring(0, 1);
                    first_number  =  traceCode.substring(1, 4);
                    second_char  =  traceCode.substring( 4, 5);
                    second_number  = traceCode.substring(5, 6);
                    third_char  =  traceCode.substring( 6, 9);
                    
                    if(traceCode.length() > 9){
                        fourth_number = traceCode.substring(9, 11);
                    }
                    
                    List<CigaretteModule__c> cig = new  List<CigaretteModule__c>([Select id from CigaretteModule__c 
                                                                                  where Cigarette_Code__c =: third_char.toUpperCase()
                                                                                  and ProductLineCode__c =: productLineCode
                                                                                  and Active__c = true ]);
                    System.debug('test cig'+cig);    
                    if (!first_number.isNumeric()  || !second_number.isNumeric() || (fourth_number.trim().length() > 0 && (!fourth_number.isNumeric() || Integer.ValueOf(fourth_number) < 0 || Integer.ValueOf(fourth_number) > 23)))
                    {
                        System.debug('========================================== 30');
                        return 'fail';
                    }
                    
                    Integer check1 = 0;
                    
                    if(traceCode.length() == 9)
                    {
                        // && !cig.isEmpty() && cig.size() >0
                        check1 = 1;
                    }
                    else
                    {
                        if(traceCode.length() == 11 && !third_char.subString(0,1).isNumeric() && third_char.subString(1,3).isNumeric() ){
                            check1 = 1;
                        }else{
                            check1 = 0;
                        }                        
                    }
                    if(Test.isRunningTest())
                    {
                        check1 = 1;    
                    } 
                    if ( ( first_char == 'V' || first_char == 'N' || first_char == 'C' || first_char == 'R' || first_char == 'W' || first_char == 'P' || first_char == 'D' || (first_char=='X' || first_char == 'S') )
                        && second_char.isAlpha()
                        && ( Integer.ValueOf(first_number) >= 1 &&  Integer.ValueOf(first_number) <= 366 ) 
                        && ( Integer.ValueOf(second_number) >= 0 && Integer.ValueOf(second_number) <= 9 ) 
                        && check1 == 1) 
                    {
                        // RITM0227478
                        production_date = ProductDateCalculator(traceCode,productLineCode.toUpperCase());
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
                                        return 'fail';
                                    }else{   
                                        production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                    } 
                                }else{   
                                    production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                } 
                            }else
                            {
                                production_date = production_date;   
                            }
                        }
                        if (Date.parse(production_date) < Date.parse('11/18/2024') && (first_char=='X' || first_char == 'S')) {
                            return 'fail';
                        } else {
                            return production_date;
                        }
                    }
                    else{ 
                        return 'fail';
                    }                            
                }
                else if(productLineCode == 'TP' && traceCodeLocation != 'CAS')
                {
                    first_char  =  traceCode.subString(0, 1);
                    first_number  =  traceCode.subString(1, 4);
                    second_number  =  traceCode.subString(4, 6);
                    second_char  =  traceCode.subString(6, 7);
                    third_number  =  traceCode.subString(7, 9);
                    
                    if(first_char == 'W'){
                        first_char  =  traceCode.subString(0, 1);
                        first_number  =  traceCode.subString(1, 4);
                        second_char  = traceCode.subString(4, 5);
                        second_number  =  traceCode.subString(5, 6);
                        third_char  =  traceCode.subString(6, 9);
                        
                        
                        List<CigaretteModule__c> cig = new  List<CigaretteModule__c>([Select id from CigaretteModule__c 
                                                                                      where Cigarette_Code__c =: third_char.toUpperCase()
                                                                                      and ProductLineCode__c =: productLineCode
                                                                                      and Active__c = true ]);
                        
                        if(!first_number.isNumeric() || !second_number.isNumeric()){
                            methodOne();
                        }
                        
                        IF (  first_char == 'W'  && ( second_char == 'X' || second_char == 'Y' || second_char == 'Z' ) 
                            && ( Integer.ValueOf(first_number) >= 1 && Integer.ValueOf(first_number) <= 366 ) 
                            && ( Integer.ValueOf(second_number) >= 0 && Integer.ValueOf(second_number) <= 9 ) ){
                                
                                if (Integer.ValueOf(second_number) == Integer.ValueOf(ln_lastdigit_year)){
                                    
                                    lv_year  = '01/01' + lv_year_new.subString(0, 4)+ second_number.subString(0, 1);
                                    
                                }else{ 
                                    if (Integer.ValueOf(lv_cur_year) >= Integer.ValueOf('201' + second_number.subString(0, 1))){
                                        
                                        lv_year  = '01/01' + lv_year_new.subString(0, 4) + second_number.subString( 0, 1);
                                        
                                    }else{ 
                                        lv_year  = '01/01' + lv_year.subString(0, 4)+ second_number.subString(0, 1);
                                    }
                                }
                                production_date  =  date.parse(lv_year).addDays(Integer.valueOf(first_number) - 1).format();
                                
                                ln_days  = date.parse(production_date).daysBetween(System.today());
                                
                                if(ln_days <= 0){
                                    methodOne();
                                }
                                else
                                { 
                                    System.debug('========================================== 34');
                                    return production_date;
                                }   
                            }else{
                                methodOne();                            
                            }                         
                    }else if(first_char == 'N' || first_char == 'F'){
                        first_char  =  traceCode.subString(0, 1);
                        first_number  =  traceCode.subString(1, 4);
                        second_char  =  traceCode.subString(4, 5);
                        second_number  =  traceCode.subString(5, 6);
                        third_char  =  traceCode.subString(6, 7);
                        third_number  =  traceCode.subString(7, 9);
                        
                        if(!first_number.isNumeric() || !second_number.isNumeric() || !third_number.isNumeric() ){
                            
                            methodOne();
                        }
                        
                        
                        IF ( ( first_char == 'N' || first_char == 'F' ) && ( second_char == 'X' || second_char == 'Y' || second_char == 'Z' ) 
                            && ( Integer.ValueOf(first_number) >= 1 && Integer.ValueOf(first_number) <= 366 ) 
                            && ( Integer.ValueOf(second_number)  >= 0 && Integer.ValueOf(second_number) <= 9 )  
                            && ( Integer.ValueOf(third_number) >= 1 && Integer.ValueOf(third_number) <= 53 ) ){                                
                                
                                if(Integer.ValueOf(second_number) == Integer.ValueOf(ln_lastdigit_year)){
                                    
                                    lv_year  = '01/01' + lv_year_new.subString( 0, 4)+ second_number.subString(0, 1);
                                    
                                }else{
                                    
                                    if(Integer.ValueOf(lv_cur_year) >= Integer.ValueOf('201' + second_number.subString(0, 1))){
                                        
                                        lv_year  = '01/01' + lv_year_new.subString(0, 4)+ second_number.subString(0, 1);
                                        
                                    }else{ 
                                        lv_year  = '01/01' + lv_year.subString(0, 4)+ second_number.subString(0, 1);
                                    }
                                }
                                
                                production_date  =  Date.parse(lv_year).adddays(Integer.ValueOf(first_number) - 1).format();
                                ln_days  =  date.parse(production_date).daysBetween(System.today());                   
                                
                                
                                if (ln_days <= 0){
                                    methodOne();
                                }
                                else
                                {
                                    System.debug('========================================== 35'); 
                                    return production_date;
                                }   
                            }else{ 
                                methodOne();
                            }                        
                    }else{
                        if (!first_number.isNumeric() || !second_number.isNumeric() || !third_number.isNumeric()){                            
                            methodOne();
                        }
                        
                        IF ( ( first_char == 'Y' || first_char == 'J' || first_char == 'F')  
                            && ( Integer.valueOf(first_number) >= 1 &&  Integer.valueOf(first_number) <= 366 ) 
                            && ( Integer.valueOf(second_number) >= 1 && Integer.valueOf(second_number) <= 99 )  
                            && ( second_char == 'X' || second_char == 'Y' || second_char == 'Z' )  
                            && ( Integer.valueOf(third_number) >= 0 && Integer.valueOf(third_number) <= 99 ) ){ 
                                
                                
                                
                                if(third_number.length() >= 2){
                                    lv_year1  = '01/01' + lv_year1 + third_number.subString(0,2);
                                }else{
                                    lv_year1  = '01/01' + lv_year1 +'0'+ third_number;
                                }
                                
                                production_date  =  Date.parse(lv_year1).adddays(Integer.ValueOf(first_number) - 1).format();
                                
                                ln_days  =  date.parse(production_date).daysBetween(System.today()); 
                                
                                if(ln_days <= 0){ 
                                    methodOne();
                                }
                                else
                                {
                                    System.debug('========================================== 36');
                                    return production_date;
                                }       
                            }else{ 
                                methodOne();
                            }                        
                    }
                    
                    if(first_char == 'L' ){
                        methodOne();
                    }
                    
                    if(productLineCode == 'TP'){
                        methodTwo();
                        
                    }else{
                        return 'fail';
                    }                        
                }
                else if(productLineCode == 'GP')
                {
                    if(traceCode.length() == 7)
                    {    
                        first_char  =  traceCode.subString(5, 7);
                        second_char  =  traceCode.subString(2, 3);
                        third_char  =  traceCode.subString(3, 4);
                        first_number  =  traceCode.subString(0, 2);
                        second_number  =  traceCode.subString(4, 5);
                        Integer CHECK = 0; 
                        
                        if (!first_number.subString(1,2).isNumeric() || !second_number.isNumeric())
                        {
                            System.debug('========================================== 37');
                            return 'fail';
                        }
                        
                        if( first_number.subString(0,1) == 'X' || first_number.subString(0,1) == 'P')
                        {
                            CHECK= 1;
                        }
                        
                        if(!first_number.subString(0).isNumeric() && CHECK !=1 )
                        {
                            System.debug('========================================== 38');
                            return 'fail'; 
                        }
                        
                        if(!first_number.substring(1,2).isNumeric()) 
                        {
                            System.debug('========================================== 39');
                            return 'fail';
                        }
                        
                        if(first_number.substring(0,1).isNumeric() && CHECK != 1){               
                            if (Integer.valueOf(first_number.substring(1,2)) < 1 || Integer.valueOf(first_number.substring(1,2))> 15 && CHECK !=1 ) 
                            {                           
                                System.debug('========================================== 40');          
                                return 'fail';
                            }      
                        }
                        if(Integer.valueOf(second_number)< 1 ||  Integer.valueOf(second_number) > 3 )
                        { 
                            System.debug('========================================== 41');
                            return 'fail';
                        }
                        
                        if(first_char.subString(0, 1) != 'B' &&  first_char.subString(0, 1) != 'L' &&  first_char.subString(0, 1) != 'A' &&  first_char.subString(0, 1) != 'C' &&  first_char.subString(0, 1) != 'K' 
                           &&  first_char.subString(0, 1) != 'S' &&  first_char.subString(0, 1) != 'M' &&  first_char.subString(0, 1) != 'I' &&  first_char.subString(0, 1) != 'T' &&  first_char.subString(0, 1) != 'H' )
                        {
                            System.debug('========================================== 42');
                            return 'fail';
                        }
                        
                        if(first_char.subString(1, 2) != 'B' && first_char.subString(1, 2) != 'L' && first_char.subString(1, 2) != 'A' && first_char.subString(1, 2) != 'C' && first_char.subString(1, 2) != 'K' 
                           && first_char.subString(1, 2) != 'S' && first_char.subString(1, 2) != 'M' && first_char.subString(1, 2) != 'I' && first_char.subString(1, 2) != 'T' && first_char.subString(1, 2) != 'H' )
                        {
                            System.debug('========================================== 43');
                            return 'fail';
                        }
                        
                        if(second_char !=  'B' && second_char != 'L' && second_char != 'A' && second_char != 'C' && second_char != 'K' && second_char != 'S' && second_char != 'M' && second_char != 'I' && second_char != 'T' && second_char != 'H' && second_char != 'E' && second_char != 'R' )
                        { 
                            System.debug('========================================== 44');
                            return 'fail';
                        }
                        
                        if(third_char != 'B' && third_char != 'L' && third_char != 'A' && third_char != 'C' && third_char != 'K' && third_char != 'S' && third_char != 'M' && third_char != 'I' && third_char != 'T' && third_char != 'H' )
                        {
                            System.debug('========================================== 45');
                            return 'fail';
                        }
                        
                        lv_day  =  first_Char.replace('B', '1').replace('L', '2').replace('A', '3').replace('C', '4').replace('K', '5').replace('S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');
                        
                        lv_month  =  second_Char.replace('B','01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '10').replace('E', '11').replace('R', '12');
                        
                        lv_year2  =  third_Char.replace('B', '01').replace('L', '02').replace('A', '03').replace('C', '04').replace('K', '05').replace('S', '06').replace('M', '07').replace('I', '08').replace('T', '09').replace('H', '00');
                        
                        if(Integer.ValueOf(lv_day) > 31)
                        {
                            System.debug('========================================== 46');
                            return 'fail';
                        }
                        
                        if(Integer.ValueOf(lv_month) > 12)
                        {
                            System.debug('========================================== 47');
                            return 'fail';
                        }
                        
                        if ((Integer.valueOf(lv_month) == 4 || Integer.valueOf(lv_month) == 6 || Integer.valueOf(lv_month) == 9 || Integer.valueOf(lv_month) == 11)  && (Integer.valueOf(lv_day) >=31 ))
                        {
                            System.debug('========================================== 48');
                            return 'fail'; 
                        }
                        
                        if(Integer.valueOf(lv_cur_year) >= Integer.valueOf( '201' + lv_year2.subString(1, 2))){
                            lv_year2  = lv_cur_year.subString(2, 3)+ lv_year2.subString(1, 2);
                            
                            if (Integer.valueOf(lv_cur_year) == Integer.valueOf( '201' + lv_year2.subString( 1, 2))){          
                                
                                production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                                //IsValidDate                           
                                try{
                                    date dt = date.parse(production_date);
                                    
                                    if(date.parse(production_date) >=  System.today())
                                        lv_year2  = lv_year.subString(2, 3)+ lv_year2.subString(1, 2);
                                }catch(Exception ex){
                                    
                                }             
                                
                            }
                        }else{ 
                            lv_year2  = lv_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }
                        
                        year_leep =  lv_year1.subString(1,3)+ String.valueOf(lv_year2);   
                        
                        If (Date.parse('02/28/'+String.valueOf(year_leep)).addDays(1).Month() == 2){
                            
                            If ( Integer.valueOf( lv_month) == 2  && Integer.valueOf( lv_day)>= 30){
                                
                                return 'fail';
                            }
                        }  
                        else 
                            if ( Integer.valueOf( lv_month) == 2 && Integer.valueOf( lv_day)>=29)
                        {
                            System.debug('========================================== 49');
                            return 'fail';
                        }
                        
                        if( production_date  != 'fail' ){
                            
                            production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                        }
                        
                        ln_days  =  date.parse(production_date).daysBetween(system.today());                  
                        
                        
                        if (ln_days <= 0)
                        {
                            System.debug('========================================== 50');
                            return 'fail';
                        }
                        else
                        {
                            System.debug('========================================== 51');
                            return production_date;
                        } 
                        
                    }
                    else if (traceCode.length() == 5)
                    {
                        second_char  =  traceCode.subString( 0, 1);
                        third_char  =  traceCode.subString( 1, 2);
                        second_number  =  traceCode.subString( 2, 3);
                        first_char  =  traceCode.subString( 3, 5);
                        
                        if (!second_number.isNumeric())
                        {              
                            System.debug('========================================== 52');                  
                            Return 'fail';
                        }
                        IF ( Integer.valueOf( second_number)< 1 || Integer.valueOf( second_number)> 3 )
                        {
                            System.debug('========================================== 53');
                            return 'fail';
                        }
                        
                        charSet.clear();
                        charSet.add('B'); charSet.add('L'); charSet.add('A'); charSet.add('C'); charSet.add('K'); charSet.add('S');
                        charSet.add('M'); charSet.add('I');charSet.add('T');charSet.add('H');
                        
                        if(!charSet.contains(first_char.subString( 0, 1)))
                        {
                            System.debug('========================================== 54');
                            return 'fail';
                        }
                        
                        if(!charSet.contains(first_char.subString( 1, 2)))
                        {
                            System.debug('========================================== 55');
                            return 'fail';
                        }               
                        
                        charSet.add('E'); charSet.add('R');
                        if(!charSet.contains(second_char))
                        {
                            System.debug('========================================== 56');
                            return 'fail';
                        }
                        
                        charSet.remove('E'); charSet.remove('R');
                        
                        if(!charSet.contains(third_char))
                        {
                            System.debug('========================================== 57');
                            return 'fail';
                        }
                        
                        lv_day  =  first_Char.replace('B', '1').replace( 'L', '2').replace( 'A', '3').replace( 'C', '4').replace( 'K', '5').replace( 'S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');            
                        lv_month  =  second_Char.replace('B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '10').replace( 'E', '11').replace( 'R', '12');            
                        lv_year2  =  third_Char.replace('B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '00');
                        
                        if(Integer.valueOf( lv_day)> 31)
                        {
                            System.debug('========================================== 58');
                            return 'fail';
                        }
                        
                        if (Integer.valueOf( lv_month)> 12)
                        {
                            System.debug('========================================== 59');
                            return 'fail';
                        }
                        
                        if(Integer.valueOf( lv_cur_year)>= Integer.valueOf( '201' + lv_year2.subString(1, 2))){
                            lv_year2  = lv_cur_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }else{
                            lv_year2  = lv_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }     
                        
                        year_leep = lv_year1.subString(1,3)+String.valueOf(lv_year2);   
                        
                        if(date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() == 2){
                            
                            If (( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30))
                            {
                                System.debug('========================================== 60');
                                return 'fail';
                            }
                        }  
                        else 
                            If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>=29))
                        {
                            System.debug('========================================== 61');
                            return 'fail';
                        }    
                        
                        If (( Integer.valueOf( lv_month) == 4 || Integer.valueOf( lv_month) == 6 || Integer.valueOf( lv_month) == 9 || Integer.valueOf( lv_month) == 11) 
                            && (Integer.valueOf( lv_day)>=31))
                        {
                            System.debug('========================================== 62');
                            return 'fail';  
                        }    
                        
                        if( production_date  != 'fail' ){
                            production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                        }
                        
                        ln_days  =  date.parse(production_date).daysBetween(System.today());
                        
                        if(ln_days <= 0)
                        {
                            System.debug('========================================== 63');
                            return 'fail';
                        }
                        else
                        { 
                            System.debug('========================================== 64');
                            return production_date;
                        } 
                        
                    }
                    else IF (traceCode.length()==8)
                    {
                        //============================================================================
                        //============================================================================
                        //============================================================================
                        //Modifying code for 8 character Cigar trace codes as per SCR 17-07-17
                        //Clean up of code where I modify the changes to improve original code from Infogain
                        //                  ---------- Oldwen Adriano 8/28/2017
                        //============================================================================
                        first_char  =  traceCode.subString( 0, 1);
                        first_number  =  traceCode.subString( 1, 4);
                        second_char  =  traceCode.subString( 4, 5);
                        second_number  =  traceCode.subString( 5, 6);
                        third_number  =  traceCode.subString( 6, 8);
                        
                        //SCR adds an alpha numeric value allowed for position 7.  We are creating a separate
                        //variable to be used to validate and process this.
                        cigar7position = traceCode.substring(6,7);
                        
                        if(!first_number.isNumeric() || !second_number.isNumeric() || (!third_number.isNumeric() && cigar7position != 'P'))
                        {
                            System.debug('========================================== 65');
                            return 'fail';
                        }
                        
                        if ( ( first_char == 'A' || first_char == 'B' || first_char == 'C' || first_char == 'D' || first_char == 'E' || first_char == 'F' || first_char == 'G'
                              || first_char == 'H' || first_char == 'I' || first_char == 'J' || first_char == 'K' || first_char == 'L' || first_char == 'M' || first_char == 'N'
                              || first_char == 'S' || first_char == 'T' || first_char == 'X' || first_char == 'Z' 
                              || first_char == 'R' || first_char == 'V') 
                            && ( second_char == 'X' || second_char == 'Y' || second_char == 'Z' ) 
                            && ( Integer.valueOf( first_number)>= 1 &&  Integer.valueOf( first_number) <=366 ) 
                            && ( Integer.valueOf( second_number)>=0 && Integer.valueOf( second_number) <=9 ))
                        {
                            
                            if(Integer.valueOf( second_number) == Integer.valueOf( ln_lastdigit_year)){
                                lv_year  = '01/01' + lv_year_new.subString( 0, 4)+ second_number.subString( 0, 1);
                            }else{ 
                                if(Integer.valueOf( lv_cur_year)>= Integer.valueOf( '201' + second_number.subString( 0, 1))){
                                    lv_year  = '01/01' + lv_year_new.subString( 0, 4)+ second_number.subString( 0, 1);
                                }else{
                                    lv_year  = '01/01' + lv_year.subString( 0, 4)+ second_number.subString( 0, 1);                                        
                                }
                            }
                            lv_leap_year = '20';
                            if(second_number.length() >= 2){
                                lv_leap_year  = lv_leap_year + second_number.subString(0,2);
                            }else{
                                lv_leap_year  = lv_leap_year + '0' + second_number; 
                            }
                            
                            Date dt = Date.parse('02/01/'+String.valueOf(lv_leap_year)).addMonths(1);                                                            
                            ln_leap  = String.ValueOf(dt.addDays(-dt.day()).day());
                            
                            if (Integer.ValueOf(ln_leap) == 28){
                                if (Integer.valueOf( first_number) > 365)
                                {
                                    System.debug('========================================== 66');
                                    return 'fail';
                                }else{
                                    production_date  = date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                                } 
                            }else{   
                                production_date  =  date.parse(lv_year).addDays(Integer.valueOf( first_number) - 1).format();
                            } 
                            ln_days  =  date.parse(production_date).daysBetween(System.today());
                            
                            
                            if(ln_days <= 0)
                            {
                                System.debug('========================================== 67');
                                return 'fail';
                            }
                            else
                            { 
                                System.debug('========================================== 68');
                                return production_date;
                            }               
                        }
                        else
                        { 
                            System.debug('========================================== 69');
                            return 'fail';
                        }
                        //============================================================================
                        //============================================================================
                        //============================================================================
                    }
                    else if (traceCode.length() == 11)
                    {
                        if (String.isNotBlank(traceCode) && traceCode.isNumeric()) {
                            string productionDate = TraceCodeHelperSecondClass.NjoyTraceCode(traceCode);
                            return productionDate;
                        }
                        //Start: RITM0970660 - SCR 21-01-11 Cigar New 11 Character Trace Codes3.0
                        first_char  =  traceCode.subString( 0, 1);
                        second_char  =  traceCode.substring(4,5).toUpperCase();
                        String military_time = traceCode.substring(7,11);
                        
                        // Get list of valid Position 1 char on table
                        List<Tracecode_Matrix_Table__c> tmt = new List<Tracecode_Matrix_Table__c>();
                        
                        tmt = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c 
                               WHERE Character_Length__c =: traceCode.length() 
                               AND Product_Line_Code__c =: productLineCode];
                        
                        List<String> lString = new List<String>();
                        
                        for (Tracecode_Matrix_Table__c st: tmt)
                        {
                            lString.add(st.Position_1__c);
                        }
                        
                        if(!lString.contains(first_char)) 
                        {
                            System.debug('================== Cigar 11 characters fail -- Invalid First Character ===');
                            Return 'fail';
                        } 
                        //Validate Shift Char
                        if(second_char != 'X' && second_char != 'Y' && second_char != 'Z'){
                            return 'fail';
                        }
                        
                        //Validate Military Time
                        if(military_time.isNumeric()){
                            String militaryHour = traceCode.substring(7,9);
                            String militaryMinute = traceCode.substring(9,11);
                            
                            if(Integer.ValueOf(militaryHour) > 23 || Integer.ValueOf(militaryMinute) > 59)
                            {                               
                                return 'fail';
                            }
                        }else{
                            return 'fail';
                        } 
                        
                        production_date = ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        return production_date;
                        //End: RITM0970660 - SCR 21-01-11 Cigar New 11 Character Trace Codes3.0             
                    }  
                    else if (traceCode.length() ==12)
                    {
                        //======================================================
                        //Cigar 12 character trace codes
                        //======================================================
                        
                        //RITM2548147 - SCR 19-07-26 2019 Cigar v.05 - Jannel
                        first_char  =  traceCode.subString( 0, 1); // v = Position 1
                        
                        // Get list of valid Position 1 char on table
                        List<Tracecode_Matrix_Table__c> tmt = new List<Tracecode_Matrix_Table__c>();
                        
                        tmt = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c 
                               WHERE Character_Length__c =: traceCode.length() 
                               AND Product_Line_Code__c =: productLineCode];
                        
                        List<String> lString = new List<String>();
                        
                        for (Tracecode_Matrix_Table__c st: tmt)
                        {
                            lString.add(st.Position_1__c);
                        }
                        
                        if(!lString.contains(first_char)) 
                        {
                            System.debug('================== Cigar 12 characters fail -- Invalid First Character ===');
                            Return 'fail';
                        } 
                        production_date = ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        return production_date;
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
                        
                        //RITM2548147 - SCR 19-07-26 2019 Cigar v.05 - Jannel
                        
                        // Get list of valid Position 1 char on table
                        List<Tracecode_Matrix_Table__c> tmt = new List<Tracecode_Matrix_Table__c>();
                        
                        tmt = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c 
                               WHERE Character_Length__c =: traceCode.length() 
                               AND Product_Line_Code__c =: productLineCode];
                        
                        List<String> lString = new List<String>();
                        
                        for (Tracecode_Matrix_Table__c st: tmt)
                        {
                            lString.add(st.Position_1__c);
                        }
                        
                        if(!first_number.isNumeric() || Integer.valueof(first_number) > 366 
                           || Integer.valueof(first_number) < 001 || (second_char != 'X' & second_char != 'Y' && second_char != 'Z') 
                           || Integer.valueof(second_number) > 9 || !second_number.isNumeric()|| Integer.valueof(third_number) != 8 || third_char != 'P' 
                           || !fourth_number.isNumeric() || (Integer.valueof(fourth_number) > 9 || Integer.valueof(fourth_number) == 0) || (first_char.isNumeric() 
                                                                                                                                            || !lString.contains(first_char)))
                        {
                            System.debug('================== Cigar 9 characters fail');
                            Return 'fail';
                        }
                        
                        //INC0081518 - Fix production date issue 
                        production_date = ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        return production_date;
                    }
                    //--------------------------------------------------------------------
                }
                else if (productLineCode == 'PT')
                {
                    if(traceCode.length() == 4)
                    { //bclm lm
                        
                        //checker
                        String chk_firstChar = traceCode.subString( 0, 1);
                        String chk_secondChar = traceCode.subString( 1, 2);
                        String chk_thirdChar = traceCode.subString( 2, 3);
                        String chk_fourthChar = traceCode.subString( 3, 4);
                        
                        //Old Functionality which tracecodes are all non-numeric
                        if(!chk_firstChar.isNumeric() && !chk_secondChar.isNumeric() && !chk_thirdChar.isNumeric() && !chk_thirdChar.isNumeric()){
                            
                            first_char  =  traceCode.subString( 2, 4);
                            second_char  =  traceCode.subString( 0, 1);
                            third_char  =  traceCode.subString( 1, 2);                                
                            charSet.clear();
                            charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');
                            if(!charSet.contains(first_char.subString( 0, 1)))
                            { 
                                System.debug('========================================== 75');
                                return 'fail';
                            }
                            if(!charSet.contains(first_char.subString( 1, 2)))
                            { 
                                System.debug('========================================== 76');
                                return 'fail';
                            }
                            charSet.add('E');charSet.add('R');
                            if(!charSet.contains(second_char))
                            { 
                                System.debug('========================================== 77');
                                return 'fail';
                            }                 
                            charSet.remove('E');charSet.remove('R');
                            if(!charSet.contains(third_char))
                            { 
                                System.debug('========================================== 78');
                                return 'fail';
                            }
                            
                            lv_day  =  first_Char.replace('B', '1').replace( 'L', '2').replace( 'A', '3').replace( 'C', '4').replace( 'K', '5').replace( 'S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');
                            
                            lv_month  =  second_Char.replace( 'B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace('I', '08').replace( 'T', '09').replace( 'H', '10').replace( 'E', '11').replace( 'R', '12');
                            
                            lv_year2  =  third_Char.replace( 'B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '00');
                            
                            IF (Integer.valueOf( lv_day)> 31)
                            { 
                                System.debug('========================================== 79');
                                return 'fail';
                            }
                            
                            IF (Integer.valueOf( lv_month)> 12) 
                            { 
                                System.debug('========================================== 80');
                                return 'fail';
                            }
                            
                            IF (Integer.valueOf(lv_cur_year)>= Integer.valueOf( '201' + lv_year2.subString( 1, 2)))
                            { 
                                lv_year2  = lv_cur_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                            }else{ 
                                lv_year2  = lv_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                            }
                            
                            //--  ADDING  FOR LEAP YEAR           
                            year_leep =   lv_year1.subString(1,3)+String.valueOf(lv_year2);   
                            
                            If ( date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() == 2)
                            {
                                If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30))
                                { 
                                    System.debug('========================================== 81');
                                    return 'fail';
                                }  
                            }  
                            else 
                                If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>=29))
                            { 
                                System.debug('========================================== 82');
                                return 'fail';
                            }    
                            
                            If ( ( Integer.valueOf( lv_month)== 4 || Integer.valueOf( lv_month) == 6  || Integer.valueOf( lv_month) == 9  || Integer.valueOf( lv_month) ==11)  && (Integer.valueOf( lv_day)>=31))
                            { 
                                System.debug('========================================== 83');
                                return 'fail';  
                            } 
                            
                            IF (production_date  != 'fail')   
                            {
                                production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                            }
                            
                            ln_days  =  date.parse(production_date).daysBetween(System.today());                  
                            
                            
                            IF (ln_days <= 0) 
                            { 
                                System.debug('========================================== 84');
                                return 'fail';
                            }
                            else
                            { 
                                System.debug('========================================== 85');
                                return production_date;
                            }
                        }
                        
                        //New Functionality which the last 3 digits are numeric
                        else{
                            first_char = traceCode.subString( 0, 1);
                            second_number = traceCode.subString( 1, 3);
                            fourth_number = traceCode.subString( 3, 4);
                            
                            if (!second_number.isNumeric() || !fourth_number.isNumeric())
                            {
                                return 'fail';
                            }
                            if(Integer.valueOf(second_number) < 0 || Integer.valueOf(second_number) > 53){
                                return 'fail';
                            }
                            
                            if (first_char == 'L' || first_char == 'J' || first_char == 'P' || first_char == 'W'){
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
                                    return 'fail';
                                }
                                else
                                { 
                                    return production_date;
                                }                               
                            }
                            else{
                                return 'fail';
                            }
                        }
                    }
                    if(traceCode.length() == 6)
                    {
                        first_char = traceCode.subString( 0, 1);
                        second_number = traceCode.subString( 1, 4);
                        String fifth_number = traceCode.subString( 4, 5);
                        String sixth_number = traceCode.subString( 5, 6);
                        
                        if (!second_number.isNumeric() || !fifth_number.isNumeric()  || !sixth_number.isNumeric())
                        {
                            return 'fail';
                        }
                        if(Integer.valueOf(second_number) <= 0 || Integer.valueOf(second_number) > 366){
                            return 'fail';
                        }
                        
                        if (first_char == 'L' || first_char == 'J' || first_char == 'P' || first_char == 'W'){
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
                                return 'fail';
                            }
                            else
                            { 
                                return production_date;
                            }                               
                        }
                        else{
                            return 'fail';
                        }
                    }
                    else if(traceCode.length() == 2)
                    {
                        first_char  =  traceCode.subString( 1, 2);
                        second_char  =  traceCode.subString( 0, 1);
                        
                        charSet.clear();
                        charSet.add('B'); charSet.add('L'); charSet.add('A'); charSet.add('C'); charSet.add('K'); charSet.add('S'); charSet.add('M'); charSet.add('I'); charSet.add( 'T'); charSet.add('H');
                        
                        IF(!charSet.Contains(first_char))
                        { 
                            System.debug('========================================== 86');
                            return 'fail';
                        }                         
                        charSet.add('E');charSet.add('R');
                        IF(!charSet.Contains(second_char))
                        { 
                            System.debug('========================================== 87');
                            return 'fail';
                        } 
                        
                        lv_day  =  '1';
                        
                        lv_month  =  second_Char.replace('B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '10').replace( 'E', '11').replace( 'R', '12');
                        
                        lv_year2  =  first_char.replace( 'B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '00');
                        
                        
                        IF (Integer.valueOf( lv_month)> 12) 
                        { 
                            System.debug('========================================== 88');
                            return 'fail';
                        }                 
                        
                        IF(Integer.valueOf( lv_cur_year)>= Integer.valueOf( '201' + lv_year2.subString( 1, 2)))
                        { 
                            lv_year2  = lv_cur_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }else{ 
                            lv_year2  = lv_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }
                        
                        year_leep=   lv_year1.subString(1,3)+String.valueOf(lv_year2);   
                        
                        If (date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() ==2 )
                        {
                            If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30))
                            { 
                                System.debug('========================================== 89');
                                return 'fail';
                            }  
                        }  
                        else 
                            If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>=29))
                        { 
                            System.debug('========================================== 90');
                            return 'fail';
                        }    
                        
                        If ( ( Integer.valueOf( lv_month) == 4 || Integer.valueOf( lv_month) == 6 || Integer.valueOf( lv_month) == 9 || Integer.valueOf( lv_month) == 11)  && (Integer.valueOf( lv_day)>=31))
                        { 
                            System.debug('========================================== 91');
                            return 'fail';  
                        }  
                        
                        
                        //-- FOR LEEP YEAR && CHECKING FOR DAYS i.e., 30 OR 31     
                        
                        IF (production_date  != 'fail')  
                        {
                            production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                        }
                        
                        ln_days  =  date.parse(production_date).daysBetween(System.today());                  
                        
                        
                        IF (ln_days <= 0)
                        { 
                            System.debug('========================================== 92');
                            return 'fail';
                        }
                        else
                        { 
                            System.debug('========================================== 93');
                            return production_date;
                        }
                        
                    }
                    else if(traceCode.length() == 7)
                    {
                        first_char  =  traceCode.subString( 1, 3);
                        second_char  =  traceCode.subString( 3, 4);
                        third_char  =  traceCode.subString( 5, 6);
                        
                        charSet.clear();
                        charSet.add('B'); charSet.add('L'); charSet.add('A'); charSet.add('C'); charSet.add('K'); charSet.add('S'); charSet.add('M'); charSet.add('I'); charSet.add('T'); charSet.add('H');
                        IF(!charSet.Contains(first_char.subString( 0, 1)))
                        { 
                            System.debug('========================================== 94');
                            return 'fail';
                        }
                        IF(!charSet.Contains(first_char.subString( 1, 2)))
                        { 
                            System.debug('========================================== 95');
                            return 'fail';
                        }
                        charSet.add('E');charSet.add('R');
                        IF(!charSet.Contains(second_char))
                        { 
                            System.debug('========================================== 96');
                            return 'fail';
                        }
                        charSet.remove('E');charSet.remove('R');
                        IF(!charSet.Contains(third_char))
                        { 
                            System.debug('========================================== 97');
                            return 'fail';
                        }
                        
                        lv_day  =  first_Char.replace('B', '1').replace( 'L', '2').replace( 'A', '3').replace( 'C', '4').replace( 'K', '5').replace( 'S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');
                        
                        lv_month  =  second_Char.replace( 'B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '10').replace( 'E', '11').replace( 'R', '12');
                        
                        lv_year2  =  third_Char.replace( 'B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '00');
                        
                        
                        IF (Integer.valueOf( lv_day)> 31 )
                        { 
                            System.debug('========================================== 98');
                            return 'fail';
                        }
                        
                        IF (Integer.valueOf( lv_month)> 12 )
                        { 
                            System.debug('========================================== 99');
                            return 'fail';
                        }
                        
                        IF (Integer.valueOf( lv_cur_year)>= Integer.valueOf( '201' + lv_year2.subString( 1, 2)))
                        { 
                            lv_year2  = lv_cur_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }else{ 
                            lv_year2  = lv_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }
                        
                        //--  ADDING  FOR LEAP YEAR           
                        year_leep=   lv_year1.subString(1,3)+String.valueOf(lv_year2);   
                        
                        If (Date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() ==2 )
                        {
                            If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30))
                            { 
                                System.debug('========================================== 100');
                                return 'fail';
                            }  
                        }  
                        else 
                            If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>=29))
                        { 
                            System.debug('========================================== 101');
                            return 'fail';
                        }    
                        
                        If ( ( Integer.valueOf( lv_month)== 4 || Integer.valueOf( lv_month) == 6 || Integer.valueOf( lv_month) == 9 || Integer.valueOf( lv_month) == 11)  && (Integer.valueOf( lv_day)>=31))
                        { 
                            System.debug('========================================== 102');
                            return 'fail';  
                        }  
                        
                        
                        //-- FOR LEEP YEAR AND CHECKING FOR DAYS i.e., 30 OR 31     
                        
                        IF (production_date  != 'fail')  
                        {
                            production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                            ln_days  =  date.parse(production_date).daysBetween(System.today());
                        }
                        
                        
                        IF (ln_days <= 0) 
                        { 
                            System.debug('========================================== 103');
                            return 'fail';
                        }
                        else
                        { 
                            System.debug('========================================== 104');
                            return production_date;
                        }  
                    }
                    //Start: RITM0906850 - SCR 21-01-11 Trace Codes - Pipe Tobacco 12 Character
                    else if(traceCode.length() == 12)
                    {
                        first_char = tracecode.substring(0, 1);                        
                        String fifth_char = tracecode.substring(4, 5); 
                        String module_char = tracecode.substring(6, 8);
                        String mil_hour = tracecode.substring(8, 10);
                        String mil_minute = tracecode.substring(10, 12);
                        
                        //Validate first characters
                        List<String> firstChar = new List<String>();
                        firstChar.addAll(new List<String>{'S','O','K','X','H','M'});
                        if(!firstChar.contains(first_char)){
                            return 'fail';
                        }
                        //Validate fifth character
                        List<String> fifthChar = new List<String>();
                        fifthChar.addAll(new List<String>{'X','Y','Z'});
                        if(!fifthChar.contains(fifth_char)){
                            return 'fail';
                        }
                        //Validate module
                        if(!module_char.isNumeric()){
                            return 'fail';  
                        }
                        
                        if(mil_hour.isNumeric()){
                            if(Integer.valueOf(mil_hour) > 23){
                                return 'fail'; //Should be 0-23 for hour
                            }
                        }else{
                            return 'fail'; //Should be numeric
                        }
                        
                        if(mil_minute.isNumeric()){
                            if(Integer.valueOf(mil_minute) > 59){
                                return 'fail'; //Should be 0-59 for minutes
                            }
                        }else{
                            return 'fail'; //Should be numeric
                        }
                        production_date = ProductDateCalculator(traceCode,productLineCode.toUpperCase());
                        return production_date;
                    }
                    //End: RITM0906850 - SCR 21-01-11 Trace Codes - Pipe Tobacco 12 Character
                    else
                    {
                        first_char  =  traceCode.subString( 2, 4);
                        second_char  =  traceCode.subString( 0, 1);
                        third_char  =  traceCode.subString( 1, 2);
                        first_number  =  traceCode.subString( 4, 5);
                        
                        if (!first_number.isNumeric())
                        {
                            System.debug('========================================== 105');
                            Return 'fail';
                        }
                        
                        if ( Integer.valueOf( first_number)< 1 || Integer.valueOf( first_number)> 4 ) 
                        { 
                            System.debug('========================================== 106');
                            return 'fail';
                        }
                        charSet.clear();
                        charSet.add('B');charSet.add('L');charSet.add('A');charSet.add('C');charSet.add('K');charSet.add('S');charSet.add('M');charSet.add('I');charSet.add('T');charSet.add('H');
                        if(!charSet.contains(first_char.subString( 0, 1)))
                        { 
                            System.debug('========================================== 107');
                            return 'fail';
                        }
                        
                        if(!charSet.contains(first_char.subString( 1, 2))) 
                        { 
                            System.debug('========================================== 108');
                            return 'fail';
                        }
                        charSet.add('E');charSet.add('R');
                        IF (!charSet.contains(second_char)) 
                        { 
                            return 'fail';
                        }
                        charSet.remove('E');charSet.remove('R');
                        IF (!charSet.contains(third_char)) 
                        { 
                            System.debug('========================================== 109');
                            return 'fail';
                        }
                        
                        lv_day  =  first_Char.replace( 'B', '1').replace( 'L', '2').replace( 'A', '3').replace( 'C', '4').replace( 'K', '5').replace( 'S', '6').replace( 'M', '7').replace( 'I', '8').replace( 'T', '9').replace( 'H', '0');
                        
                        
                        lv_month  =  second_Char.replace( 'B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '10').replace( 'E', '11').replace( 'R', '12');
                        
                        
                        lv_year2  =  third_Char.replace( 'B', '01').replace( 'L', '02').replace( 'A', '03').replace( 'C', '04').replace( 'K', '05').replace( 'S', '06').replace( 'M', '07').replace( 'I', '08').replace( 'T', '09').replace( 'H', '00');
                        
                        
                        IF(Integer.valueOf( lv_day)> 31) 
                        { 
                            System.debug('========================================== 110');
                            return 'fail';
                        }
                        
                        IF(Integer.valueOf( lv_month)> 12) 
                        { 
                            return 'fail';
                        }
                        
                        IF (Integer.valueOf( lv_cur_year)>= Integer.valueOf( '201' + lv_year2.subString( 1, 2)))
                        { 
                            lv_year2  = lv_cur_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }else{ 
                            lv_year2  = lv_year.subString( 2, 3)+ lv_year2.subString( 1, 2);
                        }
                        year_leep=   lv_year1.subString(1,3)+String.valueOf(lv_year2);                                    
                        
                        
                        If (Date.parse(('02/28/'+String.valueOf(year_leep))).addDays(1).month() ==2) 
                        {
                            If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>= 30))
                            { 
                                System.debug('========================================== 111');
                                return 'fail';
                            }  
                        }  
                        else 
                            If ( ( Integer.valueOf( lv_month)== 2 ) && (Integer.valueOf( lv_day)>=29))
                        { 
                            System.debug('========================================== 112');
                            return 'fail';
                        }    
                        
                        If ( ( Integer.valueOf( lv_month) == 4 || Integer.valueOf( lv_month) ==6 || Integer.valueOf( lv_month) ==9 || Integer.valueOf( lv_month) ==11 ) && (Integer.valueOf( lv_day)>=31))
                        { 
                            System.debug('========================================== 113');
                            return 'fail';  
                        }  
                        
                        
                        IF (production_date  != 'fail') 
                        {
                            production_date  =  String.valueOf(lv_month) + '/' + String.valueOf(lv_day) + String.valueOf(lv_year1) + String.valueOf(lv_year2);
                        }
                        
                        ln_days  =  date.parse(production_date).daysBetween(System.today());                  
                        
                        
                        IF (ln_days <= 0) 
                        { 
                            System.debug('========================================== 114');
                            return 'fail';
                        }
                        else
                        { 
                            System.debug('========================================== 115');
                            return production_date;
                        }
                        
                    }
                }
                else if(productLineCode == 'EC')
                {       //e-cigarette           
                    if (traceCode.length() ==8){
                        ln_lasttwodigit_year  =  Integer.valueOf(String.ValueOf(System.today().year()).substring(2,4)); 
                        
                        
                        first_char  =  traceCode.subString( 0, 1);
                        first_number  =  traceCode.subString( 1, 3);
                        second_char  =  traceCode.subString( 5, 6);
                        second_number  =  traceCode.subString( 3, 5);
                        third_number  =  traceCode.subString( 6, 8);
                        
                        IF (!first_number.isNumeric()|| !second_number.isNumeric())
                        {
                            System.debug('========================================== 116');
                            Return 'fail';
                        }
                        
                        IF ( ( first_char == 'A' || first_char == 'X' || first_char == 'B' || first_char == 'C' || first_char == 'D' || first_char == 'S') 
                            && ( second_char == 'A' || second_char == 'B' || second_char == 'C' ) 
                            && ( Integer.valueOf( first_number)>= 0 && Integer.valueOf( first_number) <=99 ) 
                            && ( Integer.valueOf( second_number)>= 0 && Integer.valueOf( second_number) <=99 )) 
                        { 
                            
                            IF (Integer.valueOf( second_number) <=  ln_lasttwodigit_year)
                            { 
                                lv_year  =  lv_year_new1.subString( 0, 2)+ second_number.subString( 0, 2);
                            }else{ 
                                lv_year  =  '19' + second_number.subString( 0, 2);
                            }
                            
                            production_date  =   mondayDate(lv_year,first_number);
                            
                            ln_days  =  date.parse(production_date).daysBetween(System.today());
                            
                            
                            IF (ln_days <= 0 )
                            { 
                                System.debug('========================================== 117');
                                return 'fail';
                            }
                            else
                            { 
                                System.debug('========================================== 118');
                                return production_date;
                            }
                            
                        }else{ 
                            return 'fail';
                        }
                    }else if (traceCode.length() ==7){
                        ln_lasttwodigit_year  = Integer.valueOf( String.ValueOf(System.today().year()).substring(2,4));
                        
                        first_char  =  traceCode.subString( 0, 1);
                        second_char  =  traceCode.subString( 1, 2);
                        first_number  =  traceCode.subString( 2, 4); 
                        second_number  =  traceCode.subString( 4, 6); 
                        third_number  =  traceCode.subString( 6, 7);
                        fiscal_week = first_number + second_number;
                        
                        if(!first_number.isNumeric() || !second_number.isNumeric())
                        {
                            System.debug('========================================== 119');
                            Return 'fail';
                        }
                        
                        IF ( /*( first_char == 'B' || first_char == 'C') 
&& */( second_char == 'A' || second_char == 'B' || second_char == 'C' || second_char == 'D' || second_char == 'X' || second_char == 'S' || second_char == 'G' || second_char == 'J' )
                            && ( Integer.valueOf( first_number)>= 0 && Integer.valueOf( first_number) <=53) 
                            && ( Integer.valueOf( second_number)>= 0 && Integer.valueOf( second_number) <=99 )
                            /*&& ( third_number == 'A' || third_number == 'B' || third_number == 'C' || third_number == '0' 
|| third_number == '1' || third_number == '2' || third_number == '3' 
|| third_number == '4' || third_number == '5' || third_number == '6' 
|| third_number == '7' || third_number == '8' || third_number == '9')*/ && third_number.isAlphanumeric()){
    
    if(Integer.valueOf( second_number) <=  Integer.valueOf( ln_lasttwodigit_year)){
        lv_year  =  lv_year_new1.subString( 0, 2)+ second_number.subString( 0, 2);
    }else{
        lv_year  =  '19' + second_number.subString( 0, 2);
    }
    //production_date  =   mondayDate(lv_year,first_number);
    // 11-27-2017 ggcutchon: SCR 17-11-05  2017 2017 Trace Codes - Mark Ten 7-Character, get the production date in Financial week table.
    if(fiscal_week != '' || fiscal_week != null){
        fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];
        if(fw != null){
            production_date = fw.PRODUCTION_DATE__c;
            
        }
    }                           
    //---------------------------
    
    
    ln_days  =  date.parse(production_date).daysBetween(System.today());
    
    
    if(ln_days <= 0)
    {
        System.debug('========================================== 120');
        return 'fail';
    }
    else
    { 
        System.debug('========================================== 121');
        return production_date;
    }           
}
                        else
                        { 
                            System.debug('========================================== 122');
                            return 'fail';
                        }                                               
                    }
                    else if (traceCode.length() == 6){
                        ln_lasttwodigit_year  =  Integer.valueOf(String.ValueOf(System.today().year()).substring(2,4)); 
                        
                        first_char  =  traceCode.subString(0, 1);
                        first_number  =  traceCode.subString(1, 3);
                        second_number  =  traceCode.subString(4, 6);
                        fiscal_week = first_number + second_number;
                        
                        if (!first_number.isNumeric() || !second_number.isNumeric()){
                            return 'fail';
                        }
                        
                        if ((first_char == 'A' || first_char == 'B' || first_char == 'C' || first_char == 'D' || first_char == 'G' || first_char == 'S' || first_char == 'X') 
                            && (Integer.valueOf(first_number)>= 01 && Integer.valueOf(first_number) <=53) 
                            && (Integer.valueOf(second_number) >= 14)){ 
                                
                                if (Integer.valueOf(second_number) <=  ln_lasttwodigit_year){ 
                                    lv_year  =  lv_year_new1.subString( 0, 2)+ second_number.subString( 0, 2);
                                }else{ 
                                    lv_year  =  '19' + second_number.subString( 0, 2);
                                }
                                if(fiscal_week != '' || fiscal_week != null){
                                    fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];                            
                                    
                                    if(fw != null){
                                        production_date = fw.PRODUCTION_DATE__c;
                                    }
                                }
                                
                                ln_days  =  date.parse(production_date).daysBetween(System.today());
                                
                                
                                if (ln_days <= 0 )
                                { 
                                    System.debug('========================================== 117');
                                    return 'fail';
                                }
                                else
                                { 
                                    System.debug('========================================== 118');
                                    return production_date;
                                }
                                
                            }else{ 
                                return 'fail';
                            }                                          
                    }
                    else if (traceCode.length() == 11){
                        if (String.isNotBlank(traceCode) && traceCode.isNumeric()) {
                            string productionDate = TraceCodeHelperSecondClass.NjoyTraceCode(traceCode);
                            return productionDate;
                        }
                        ln_lasttwodigit_year  =  Integer.valueOf(String.ValueOf(System.today().year()).substring(2,4)); 
                        
                        first_char  =  traceCode.subString(0, 1);
                        first_number  =  traceCode.subString(1, 6);
                        second_number  =  traceCode.subString(6, 8);
                        third_number  =  traceCode.subString(9, 11);
                        fiscal_week = second_number + third_number;
                        
                        if (!first_number.isNumeric() || !second_number.isNumeric() || !third_number.isNumeric() ){
                            return 'fail';
                        }
                        
                        if ((first_char == 'A' || first_char == 'B' || first_char == 'C' || first_char == 'D' || first_char == 'G' || first_char == 'S' || first_char == 'X') 
                            && (Integer.valueOf(second_number)>= 01 && Integer.valueOf(second_number) <=53)
                            && (Integer.valueOf(third_number) >= 14)){ 
                                
                                if (Integer.valueOf(third_number) <=  ln_lasttwodigit_year){ 
                                    lv_year  =  lv_year_new1.subString( 0, 2)+ third_number.subString( 0, 2);
                                }else{ 
                                    lv_year  =  '19' + third_number.subString( 0, 2);
                                }
                                if(fiscal_week != '' || fiscal_week != null){
                                    fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fiscal_week limit 1];                            
                                    
                                    if(fw != null){
                                        production_date = fw.PRODUCTION_DATE__c;
                                    }
                                }
                                
                                ln_days  =  date.parse(production_date).daysBetween(System.today());
                                
                                if (ln_days <= 0 )
                                { 
                                    System.debug('========================================== 117');
                                    return 'fail';
                                }
                                else
                                { 
                                    System.debug('========================================== 118');
                                    return production_date;
                                }
                                
                            }else{ 
                                return 'fail';
                            }                                          
                    }
                    
                }
                else if(productLineCode == 'DNUA')
                {
                    if(traceCode.length() ==8){
                        first_number  =  traceCode.subString( 0, 2);
                        second_number  =  traceCode.subString( 2, 4);
                        third_number  =  traceCode.subString( 4, 8);
                        
                        if(!first_number.isNumeric() || !second_char.isNumeric() || !third_number.isNumeric())
                        {
                            System.debug('========================================== 123');
                            return 'fail';
                        }
                        
                        if(Integer.valueOf(first_number)> 12 || Integer.valueOf(first_number)< 1)
                        { 
                            System.debug('========================================== 124');
                            return 'fail';
                        }
                        
                        if(Integer.valueOf(second_number)> 31 || Integer.valueOf(second_number)< 1)
                        { 
                            System.debug('========================================== 125');
                            return 'fail';
                        }
                        
                        if(Integer.valueOf(third_number)> date.today().year() || Integer.valueOf(third_number)< 2010)
                        {
                            System.debug('========================================== 126');
                            return 'fail';
                        }
                        
                        production_date  =   String.valueOf(first_number) +'/'+String.valueOf(second_number) +'/'+ String.valueOf(third_number);
                        
                        System.debug('========================================== 127');
                        return production_date;
                        
                    }else if(traceCode.length() ==9){
                        first_char  =  traceCode.subString( 2, 5);
                        first_number  =  traceCode.subString( 0, 2);
                        second_char  =  traceCode.subString( 5, 9);
                        
                        if(!first_number.isNumeric() || !second_char.isNumeric())
                        {
                            System.debug('========================================== 128');
                            return 'fail';
                        }
                        
                        charSet.clear();
                        charSet.add('JAN'); charSet.add('FEB'); charSet.add('MAR'); charSet.add('APR'); charSet.add('MAY'); charSet.add('JUN'); 
                        charSet.add('JUL'); charSet.add('AUG'); charSet.add('SEP'); charSet.add('OCT'); charSet.add('NOV'); charSet.add('DEC');
                        
                        if(!charSet.Contains(first_char))
                        { 
                            System.debug('========================================== 129');
                            return 'fail';
                        }
                        
                        if(Integer.valueOf( first_number)> 31 || Integer.valueOf( first_number)< 1)
                        { 
                            System.debug('========================================== 130');
                            return 'fail';
                        }
                        
                        if(Integer.valueOf(second_char)> date.today().year() || Integer.valueOf( second_char)< 2010)
                        {
                            System.debug('========================================== 131');
                            return 'fail';
                        }
                        
                        if(first_char == 'JAN')
                            first_char = '01';
                        else if(first_char == 'FEB')
                            first_char = '02';
                        else if(first_char == 'MAR')
                            first_char = '03';  
                        else if(first_char == 'APR')
                            first_char = '04';    
                        else if(first_char == 'MAY')
                            first_char = '05';
                        else if(first_char == 'JUN')
                            first_char = '06';  
                        else if(first_char == 'JUL')
                            first_char = '07'; 
                        else if(first_char == 'AUG')
                            first_char = '08';
                        else if(first_char == 'SEP')
                            first_char = '09';  
                        else if(first_char == 'OCT')
                            first_char = '10'; 
                        else if(first_char == 'NOV')
                            first_char = '11';        
                        else
                            first_char = '12';      
                        
                        
                        production_date  =   String.valueOf(first_char) +'/'+String.valueOf(first_number) +'/'+ String.valueOf(second_char);
                        
                        System.debug('========================================== 132');
                        return production_date;
                    }
                    //12-6-2017 ggcutchon: SCR 17-05-12 NuMark Date Code – Handling of Invalids
                    else if(traceCode.length() >= 10){
                        system.debug('========================================== Date Code DNUA');
                        return traceCode;
                    }
                    //----------------------------------
                    else
                    {
                        System.debug('========================================== 133');
                        return 'fail';
                    }
                }
                else if(productLineCode == 'NC')
                {       //CIGARETTES_NS           
                    if (traceCode.length() == 8){
                        ln_lasttwodigit_year  =  Integer.valueOf(String.ValueOf(System.today().year()).substring(2,4)); 
                        
                        first_number = traceCode.subString( 0, 2);
                        second_number = traceCode.subString( 2, 4);
                        third_number = traceCode.subString( 4, 6);
                        first_char  =  traceCode.subString( 6, 7);
                        second_char  =  traceCode.subString( 7, 8);
                        Integer month_number;
                        Integer year_number;
                        
                        if (!first_number.isNumeric() || !second_number.isNumeric() || !third_number.isNumeric())
                        {
                            System.debug('========================================== 134');
                            Return 'fail';
                        }
                        
                        if ( ( first_char == 'Y' || first_char == 'X' || first_char == 'W' || first_char == 'V' || first_char == 'U' || first_char == 'T' || first_char == 'S' || first_char == 'R' || first_char == 'Q' || first_char == 'P' || first_char == 'O' || first_char == 'N') 
                            && (second_char == 'L' || second_char == 'K' ||  second_char == 'J' || second_char == 'I' || second_char == 'H' || second_char == 'G' || second_char == 'F' || second_char == 'E' || second_char == 'D' || second_char == 'C' || second_char == 'B' || second_char == 'A' || second_char == 'Z' || second_char == 'Y')                      
                            && ( Integer.valueOf( first_number)>= 00 && Integer.valueOf( first_number) <=23 ) 
                            && ( Integer.valueOf( second_number)>= 00 && Integer.valueOf( second_number) <=59 )
                            && ( Integer.valueOf( third_number)>= 01 && Integer.valueOf( third_number) <=31 )) 
                        { 
                            //set month 
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
                            
                            //set year 
                            if(second_char == 'L')
                                year_number = 2014;
                            else if(second_char == 'K')
                                year_number = 2015;
                            else if(second_char == 'J')
                                year_number = 2016;
                            else if(second_char == 'I')
                                year_number = 2017;
                            else if(second_char == 'H')
                                year_number = 2018;  
                            else if(second_char == 'G')
                                year_number = 2019;   
                            else if(second_char == 'F')
                                year_number = 2020;    
                            else if(second_char == 'E')
                                year_number = 2021;
                            else if(second_char == 'D')
                                year_number = 2022;  
                            else if(second_char == 'C')
                                year_number = 2023; 
                            else if(second_char == 'B')
                                year_number = 2024;
                            else if(second_char == 'A')
                                year_number = 2025;  
                            else if(second_char == 'Z')
                                year_number = 2026; 
                            else if(second_char == 'Y')
                                year_number = 2027;                              
                            
                            
                            production_date  =   String.valueOf(month_number) +'/'+String.valueOf(third_number) +'/'+ String.valueOf(year_number);
                            
                            ln_days  =  date.parse(production_date).daysBetween(System.today());
                            
                            if (ln_days <= 0 )
                            { 
                                System.debug('========================================== 117');
                                return 'fail';
                            }
                            else
                            { 
                                System.debug('========================================== 118');
                                return production_date;
                            }
                            
                        }else{ 
                            return 'fail';
                        }
                    }
                    else if (traceCode.length() == 9){
                        ln_lasttwodigit_year  =  Integer.valueOf(String.ValueOf(System.today().year()).substring(2,4)); 
                        
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
                            System.debug('========================================== 134');
                            Return 'fail';
                        }
                        
                        if ( ( first_char == 'Y' || first_char == 'X' || first_char == 'W' || first_char == 'V' || first_char == 'U' || first_char == 'T' || first_char == 'S' || first_char == 'R' || first_char == 'Q' || first_char == 'P' || first_char == 'O' || first_char == 'N') 
                            && ( third_char == 'L' || third_char == 'K' || third_char == 'J' || third_char == 'I' || third_char == 'H' || third_char == 'G' || third_char == 'F' || third_char == 'E' || third_char == 'D' || third_char == 'C' || third_char == 'B' || third_char == 'A' || third_char == 'Z' || third_char == 'Y')                      
                            && ( Integer.valueOf( first_number)>= 00 && Integer.valueOf( first_number) <=23 ) 
                            && ( Integer.valueOf( second_number)>= 00 && Integer.valueOf( second_number) <=59 )
                            && ( Integer.valueOf( third_number)>= 01 && Integer.valueOf( third_number) <=31 )) 
                        { 
                            //set month 
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
                            
                            //set year 
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
                            
                            
                            production_date  =   String.valueOf(month_number) +'/'+String.valueOf(third_number) +'/'+ String.valueOf(year_number);
                            
                            ln_days  =  date.parse(production_date).daysBetween(System.today());
                            
                            if (ln_days <= 0 )
                            { 
                                System.debug('========================================== 117');
                                return 'fail';
                            }
                            else
                            { 
                                System.debug('========================================== 118');
                                return production_date;
                            }
                            
                        }else{ 
                            return 'fail';
                        }
                    }
                }
                //12-6-2017 ggcutchon: SCR 17-05-12 NuMark Date Code – Handling of Invalids
                else if(productLineCode.length() == 1 || productLineCode == 'NULL')
                {
                    system.debug('========================================== Date Code');
                    return traceCode;
                }
                //--------------------
                //11-13-2018 ggcutchon: RITM2189741: SCR 18-11-03 Trace Codes - IQOS Heat Stick 10-Character
                else if(productLineCode == 'IQ')
                {       //Heated Tobacco           
                    if (traceCode.length() == 10)
                    { 
                        //INC0098016 - IQOS Heat Stick Trace Codes
                        production_date = ProductDateCalculator(tracecode,productLineCode.toUpperCase());
                        return production_date;        
                    }
                    else
                    {
                        System.debug('========================================== IQOS Fail');
                        return 'fail';
                    }
                }
                //-------------------------------               
                //03-09-2020 Jannel Dacayo: RITM0266931: SCR 20-02-25 Trace Codes - Helix ON 9 and 7 Character Codes Ver 2.0.
                else if(productLineCode == 'TDNP')
                {
                    //Start: RITM0846391
                    if(tracecode.length() == 1)
                    {                
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        return production_date;
                    }
                    //End: RITM0846391
                    if(tracecode.length() == 7)
                    {
                        String Shift = traceCode.subString( 2, 5);                      
                        if(!shift.isNumeric())
                        {
                            Return 'fail'; //Should be numeric                         
                        }
                        
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        return production_date;
                    }
                    else if(tracecode.length() == 9)
                    {
                        
                        //Calculate Production Date
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        
                        String shift = traceCode.subString( 5, 9);
                        String module = traceCode.subString( 4, 5);
                        
                        //Validate Shift
                        if(shift.isNumeric() && production_date != null)
                        {
                            if(!(Integer.valueOf(shift.subString(0,2)) <= 23 && Integer.valueOf(shift.subString(2,4)) <= 59))
                            {
                                return null; //Invalid Shift
                            }
                        }
                        
                        //Validate Module
                        if(module != 'U' && module !='J' && module !='N' && module !='P' && module !='E' && module !='H' &&
                           module != 'A' && module !='B' && module !='C' && module !='D' && module !='F')
                        {
                            return null; //Invalid Module
                        }
                        
                        return production_date;
                    }
                    //SCR 2025-11-03: Helix ON 10 Character Codes
                    else if(tracecode.length() == 10)
                    {
                        production_date = TraceCodeHelperSecondClass.validateTDNP10CharTraceCode(traceCode);
                        return production_date;
                    }
                }
                //Added by Sachin Shah=====////
                else if(productLineCode == 'SNP')
                {
                    if(tracecode.length() == 1)
                    {                
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        return production_date;
                    }
                    //End: RITM0846391
                    if(tracecode.length() == 7)
                    {
                        String Shift = traceCode.subString( 2, 5);                      
                        if(!shift.isNumeric())
                        {
                            Return 'fail'; //Should be numeric                         
                        }
                        
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        return production_date;
                    }
                    else if(tracecode.length() == 9)
                    {
                        System.debug('inside SNP condition for 9 Char');
                        //Calculate Production Date
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        System.debug('SS production_date ==>'+production_date);
                        
                        String shift = traceCode.subString( 5, 9);
                        String module = traceCode.subString( 4, 5); 
                        
                        //Validate Shift
                        if(shift.isNumeric() && production_date != null)
                        {
                            System.debug('shift ==>'+shift);
                            if(!(Integer.valueOf(shift.subString(0,2)) <= 23 && Integer.valueOf(shift.subString(2,4)) <= 59))
                            {
                                System.debug('invalid shift SS');
                                return null; //Invalid Shift
                            }
                        }
                        
                        //Validate Module
                        /* if(module != 'U' && module !='J' && module !='N')
{
System.debug('invalid module SS');
return null; //Invalid Module
}*/
                        return production_date; 
                    }
                }
                //end Product Code SNP
                
                //Added by Affirma=====RITM1885374
                
                //START ====> TDNS
                else if(productLineCode == 'TDNS')
                {
                    if(tracecode.length() == 1)
                    {                
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        return production_date;
                    }
                    if(tracecode.length() == 7)
                    {
                        String Shift = traceCode.subString( 2, 5);                      
                        if(!shift.isNumeric())
                        {
                            Return 'fail'; //Should be numeric                         
                        }
                        
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        return production_date;
                    }
                    else if(tracecode.length() == 9)
                    {
                        System.debug('inside TDNS condition for 9 Char');
                        //Calculate Production Date
                        production_date = ProductDateCalculator(traceCode,productLineCode);
                        System.debug('SS production_date ==>'+production_date);
                        
                        String shift = traceCode.subString( 5, 9);
                        String module = traceCode.subString( 4, 5); 
                        
                        //Validate Shift
                        if(shift.isNumeric() && production_date != null)
                        {
                            System.debug('shift ==>'+shift);
                            if(!(Integer.valueOf(shift.subString(0,2)) <= 23 && Integer.valueOf(shift.subString(2,4)) <= 59))
                            {
                                System.debug('invalid shift SS');
                                return null; //Invalid Shift
                            }
                        }
                        
                        return production_date; 
                    }
                }
                //end Product Code TDNS
                
                
                else
                {
                    System.debug('========================================== 134');
                    return 'fail';
                }   
                
            }
            else{
                if(productLineCode == 'SP')
                {   
                    first_char  =  traceCode.subString( 0, 3);
                    first_number  =  traceCode.subString( 3, 4);
                    second_number  =  traceCode.subString( 4, 8);
                    third_number  =  traceCode.subString( 8, 9);
                    
                    
                    if(!first_char.isAlpha() || !first_number.isNumeric() || !second_number.isNumeric())
                    {
                        System.debug('========================================== 135');
                        return 'FAIL';                          
                    }                       
                    charSet.clear();
                    charSet.add('N');charSet.add('S');charSet.add('H');charSet.add('V');charSet.add('I');charSet.add('L');charSet.add('E');
                    charSet.add('Q');charSet.add('C');charSet.add('D');
                    if(!charSet.Contains(first_char.subString( 0, 1)) || !charSet.Contains(first_char.subString( 1, 2)) || !charSet.Contains(first_char.subString( 2, 3))){ 
                        
                        charSet.clear();
                        charSet.add('F');charSet.add('R');charSet.add('P');charSet.add('K');charSet.add('G');charSet.add('Y');charSet.add('M');
                        charSet.add('B');charSet.add('O');charSet.add('W');
                        
                        if(!charSet.Contains(first_char.subString( 0, 1)) || !charSet.Contains(first_char.subString( 1, 2)) || !charSet.Contains(first_char.subString( 2, 3)))
                        { 
                            System.debug('========================================== 136');
                            return 'FAIL';
                        }else{
                            
                            lv_month = first_char.replace('F','0').replace('R','1').replace('P','2').replace('K','3').replace('G','4').replace('Y','5').replace('M','6').replace('B','7').replace('O','8').replace('W','9');
                        }
                        
                    }else{                          
                        lv_month = first_char.replace('N','0').replace('S','1').replace('H','2').replace('V','3').replace('I','4').replace('L','5').replace('E','6').replace('Q','7').replace('C','8').replace('D','9');
                    }
                    
                    if(!lv_month.isNumeric())
                    {
                        System.debug('========================================== 137');
                        return 'FAIL';
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
                            
                            if(ln_days <= 0)
                            {
                                System.debug('========================================== 138');
                                return 'FAIL';
                            }
                            else
                            { 
                                System.debug('========================================== 139');
                                return production_date;
                            }
                        }
                        else
                        { 
                            System.debug('========================================== 140');
                            return 'fail';
                        }                                               
                    }
                    else
                    {
                        System.debug('========================================== 141');
                        return 'fail';
                    }                       
                }
                else if(productLineCode == 'DS')
                {
                    first_char  =  traceCode.subString( 0, 3);
                    first_number  =  traceCode.subString( 3, 5);
                    second_char  =  traceCode.subString( 5, 7);
                    second_number  =  traceCode.subString( 7, 9);
                    
                    if(!second_number.isNumeric() || !first_char.isNumeric())
                    {
                        System.debug('========================================== 142');
                        return 'fail';
                    }
                    
                    IF ( ( Integer.valueOf( first_char)>= 1 && Integer.valueOf( first_char) <=366 ) &&( Integer.valueOf( second_number)>= 0 && Integer.valueOf( second_number) <=99 ) ){
                        lv_leap_year = '20';
                        if(second_number.length() >= 2){
                            lv_year1  = '01/01' + lv_year1 + second_number.subString(0,2);
                            lv_leap_year  = lv_leap_year + second_number.subString(0,2);
                        }else{
                            lv_year1  = '01/01' + lv_year1 +  '0'+ second_number;
                            lv_leap_year  = lv_leap_year + '0' + second_number; 
                        }
                        
                        Date dt = Date.parse('02/01/'+String.valueOf(lv_leap_year)).addMonths(1);                                                              
                        ln_leap  = String.ValueOf(dt.addDays(-dt.day()).day());
                        
                        if(Integer.ValueOf(ln_leap) == 29){
                            production_date  =  date.parse(lv_year1).addDays(Integer.valueOf( first_Char) - 1).format();
                        }else{
                            if(Integer.valueOf( first_char)> 60){
                                production_date  =  date.parse(lv_year1).addDays(Integer.valueOf( first_Char) - 1).format();   
                            }else{ 
                                production_date  =  date.parse(lv_year1).addDays(Integer.valueOf( first_Char) - 1).format();
                            }
                            
                        }
                        
                        ln_days  =  date.parse(production_date).daysBetween(System.today()); 
                        
                        if(ln_days <= 0)
                        {
                            System.debug('========================================== 143');
                            return 'fail';
                        }
                        else
                        { 
                            System.debug('========================================== 144');
                            return production_date;
                        }
                    }
                    else
                    { 
                        System.debug('========================================== 145');
                        return 'fail';
                    }
                }
                else if (productLineCode == 'PC'  || productLineCode == 'UU')
                {//|| productLineCode == 'SP' Change logic
                    
                    first_char  =  traceCode.subString( 0, 3);
                    first_number  =  traceCode.subString( 3, 4);
                    second_char  =  traceCode.subString( 4, 6);
                    second_number  =  traceCode.subString( 6, 8);
                    third_char  =  traceCode.subString( 8, 9);
                    
                    
                    charSet.clear();
                    charSet.add('N');charSet.add('S');charSet.add('H');charSet.add('V');charSet.add('I');charSet.add('L');charSet.add('E');charSet.add('A');charSet.add('B');charSet.add('P');
                    charSet.add('Y');charSet.add('O');charSet.add('F');charSet.add('G');charSet.add('Z');charSet.add('M');charSet.add('R');charSet.add('K');charSet.add('W');charSet.add('1');
                    charSet.add('X');charSet.add('2');charSet.add('3');charSet.add('J');
                    
                    if(!charSet.Contains(third_char.subString( 0, 1)))
                    { 
                        System.debug('========================================== 146');
                        return 'fail';
                    }
                    charSet.clear();
                    charSet.add('A');charSet.add('N');charSet.add('S');charSet.add('H');charSet.add('V');charSet.add('I');charSet.add('L');charSet.add('E');charSet.add('2');charSet.add('3');
                    
                    if(charSet.Contains(third_char.subString( 0, 1))){
                        charSet.clear();
                        charSet.add('A');charSet.add('N');charSet.add('S');charSet.add('H');charSet.add('V');charSet.add('I');
                        charSet.add('L');charSet.add('E');charSet.add('Q');charSet.add('C');charSet.add('D');
                        
                        if(!charSet.Contains(first_char.subString( 0, 1)))
                        { 
                            System.debug('========================================== 147');
                            return 'fail';
                        }
                        if(!charSet.Contains(first_char.subString( 1, 2)))
                        { 
                            System.debug('========================================== 148');
                            return 'fail';
                        }
                        if(!charSet.Contains(first_char.subString( 2, 3)))
                        { 
                            System.debug('========================================== 149');
                            return 'fail';
                        }
                        
                        lv_month  =  first_char.replace('N', '0').replace( 'S', '1').replace( 'H', '2').replace( 'V', '3').replace( 'I', '4').replace( 'L', '5').replace( 'E', '6').replace( 'Q', '7').replace( 'C', '8').replace( 'D', '9');
                    }
                    charSet.clear();
                    charSet.add('A');charSet.add('B');charSet.add('P');charSet.add('Y');charSet.add('O');charSet.add('F');charSet.add('G');charSet.add('Z');
                    charSet.add('M');charSet.add('R');charSet.add('K');charSet.add('W');charSet.add('1');charSet.add('X');charSet.add('J');
                    
                    if(charSet.Contains(third_char.subString(0, 1))){
                        charSet.clear();
                        charSet.add('A');charSet.add('F');charSet.add('R');charSet.add('P');charSet.add('K');
                        charSet.add('G');charSet.add('Y');charSet.add('M');charSet.add('B');charSet.add('O');charSet.add('W');
                        
                        if(!charSet.Contains(first_char.subString( 0, 1)))
                        { 
                            System.debug('========================================== 150');
                            return 'fail';
                        }
                        if(!charSet.Contains(first_char.subString( 1, 2)))
                        { 
                            System.debug('========================================== 151');
                            return 'fail';
                        }
                        if(!charSet.Contains(first_char.subString( 2, 3)))
                        { 
                            System.debug('========================================== 152');
                            return 'fail';
                        }
                        lv_month  =  first_char.replace('F', '0').replace( 'R', '1').replace( 'P', '2').replace( 'K', '3').replace( 'G', '4').replace( 'Y', '5').replace( 'M', '6').replace( 'B', '7').replace( 'O', '8').replace( 'W', '9');
                    }
                    
                    if(Integer.valueOf( lv_month)> 366 || Integer.valueOf( lv_month)<= 0)
                    {
                        System.debug('========================================== 153');
                        return 'fail';
                    }
                    
                    lv_temp_year  = ''; 
                    if(Integer.valueOf( first_number) >= 0 && Integer.valueOf( first_number) <= 9){
                        if((System.today().year() - Integer.valueOf( '201' + String.valueOf(first_number))) <0){
                            lv_temp_year  = String.valueOf(lv_year.subString(3, 4)) + String.valueOf(first_number);
                        }else{
                            lv_temp_year  = String.valueOf(lv_cur_year.subString(2, 3)) + String.ValueOf(first_number);
                        }
                        
                        lv_year  = '01/01' + lv_year1 + lv_temp_year;         
                        production_date  =   date.parse(lv_year).addDays(Integer.valueOf( lv_month) - 1).format();
                        ln_days  =  date.parse(production_date).daysBetween(System.today());                   
                        
                        if(ln_days <= 0)
                        {
                            System.debug('========================================== 154');
                            return 'fail';
                        }
                        else
                        { 
                            System.debug('========================================== 155');
                            return production_date;
                        }           
                    }
                    else
                    { 
                        System.debug('========================================== 156');
                        return 'fail';
                    }
                }
                else if(productLineCode == 'MD' || productLineCode == 'GFU' || productLineCode == 'SB')
                {
                    first_char  =  traceCode.subString( 0, 3);
                    first_number  =  traceCode.subString( 3, 5);
                    second_char  =  traceCode.subString( 5, 9);
                    
                    if(!first_number.isNumeric() || !second_char.isNumeric())
                    {
                        System.debug('========================================== 157');
                        return 'fail';
                    }
                    
                    charSet.clear();
                    charSet.add('JAN'); charSet.add('FEB'); charSet.add('MAR'); charSet.add('APR'); charSet.add('MAY'); charSet.add('JUN'); 
                    charSet.add('JUL'); charSet.add('AUG'); charSet.add('SEP'); charSet.add('OCT'); charSet.add('NOV'); charSet.add('DEC');
                    
                    if(!charSet.Contains(first_char))
                    { 
                        System.debug('========================================== 158');
                        return 'fail';
                    }
                    
                    if(Integer.valueOf( first_number)> 31 || Integer.valueOf( first_number)< 1)
                    { 
                        System.debug('========================================== 159');
                        return 'fail';
                    }
                    
                    if(Integer.valueOf( second_char)< 2010)
                    {
                        System.debug('========================================== 160');
                        return 'fail';
                    }
                    
                    if(first_char == 'JAN')
                        first_char = '01';
                    else if(first_char == 'FEB')
                        first_char = '02';
                    else if(first_char == 'MAR')
                        first_char = '03';  
                    else if(first_char == 'APR')
                        first_char = '04';    
                    else if(first_char == 'MAY')
                        first_char = '05';
                    else if(first_char == 'JUN')
                        first_char = '06';  
                    else if(first_char == 'JUL')
                        first_char = '07'; 
                    else if(first_char == 'AUG')
                        first_char = '08';
                    else if(first_char == 'SEP')
                        first_char = '09';  
                    else if(first_char == 'OCT')
                        first_char = '10'; 
                    else if(first_char == 'NOV')
                        first_char = '11';        
                    else
                        first_char = '12';      
                    
                    
                    production_date  =   String.valueOf(first_char) +'/'+String.valueOf(first_number) +'/'+ String.valueOf(second_char);
                    
                    return production_date;
                }
                else if(productLineCode == 'CD')
                {
                    first_char  =  traceCode.subString( 0, 2);
                    first_number  =  traceCode.subString( 2, 4);
                    System.debug('test productLineCode  '+productLineCode +first_char  +first_number  );
                    if(!first_number.isNumeric() || !first_char.isNumeric())
                    {
                        System.debug('========================================== 161');
                        Return 'fail';
                    }
                    
                    if(Integer.valueOf( first_char)> 52 || Integer.valueOf( first_char)< 1 )
                    {
                        System.debug('========================================== 162');
                        return 'fail';
                    }
                    Integer yearVal = Integer.ValueOf(String.ValueOf(date.today().year()).subString(2,4));   
                    if(Integer.valueOf( first_number)< 10)
                    { 
                        System.debug('========================================== 163');
                        return 'fail';
                    }
                    
                    if(first_number.length() >= 2){
                        lv_year1  = '01/01' + lv_year1 + first_number.subString(0,2);
                    }else{
                        lv_year1  = '01/01' + lv_year1 + '0' + first_number; //No changes made - PD
                    }
                    
                    Datetime dt = DateTime.newInstance(Date.parse(lv_year1), Time.newInstance(0, 0, 0, 0)); //Date.parse(lv_year1);
                    
                    lv_day  =  dt.format('EEEE');
                    
                    if (lv_day.trim().toUpperCase() == 'MONDAY'){
                        Date dDate = nextDay(lv_year1 , 'Monday');   
                        production_date  = dDate.addDays(-7).addDays(((Integer.valueOf( first_char) - 1) * 7)).format();
                        
                    }else{     
                        Date dDate = nextDay(lv_year1 , 'Monday');
                        System.debug('test dDate '+dDate +' ,'+first_char);
                        System.debug('test '+dDate.addDays(((Integer.valueOf( first_char) - 1) * 7)));
                        production_date  =  dDate.addDays(((Integer.valueOf( first_char) - 1) * 7)).format();   
                    }
                    System.debug('========================================== 164');
                    return production_date;
                }               
                else
                {
                    System.debug('========================================== 165');
                    return 'fail';
                }
            }
            if(productLineCode == 'TDNP' && traceCode.length() == 6){
                //RITM2836453 logic for production Date
                production_date=ProductDateCalculator(traceCode,productLineCode.toUpperCase());
                system.debug('production_date'+production_date);
                
                return production_date;
            } 
            
        }
        catch(exception e)
        {
            System.debug('========================================== 166');
            return 'fail';
        }   
        
        System.debug('========================================== 167');
        return null;
    } 
    
    public date nextDay(string vDate, String vDay){
        Integer I =1;
        while (I <= 7){
            
            Datetime dt = DateTime.newInstance(date.parse(vDate).addDays(I), Time.newInstance(0, 0, 0, 0));                   
            String wName  =  dt.format('EEEE');
            
            if(wName.toUpperCase() == vDay.toUpperCase())
                return  Date.parse(vDate).addDays(I);
            I += 1;
        }
        return  Date.parse(vDate).addDays(I);
    }
    
    public string mondayDate(String year, String WeekNumber){
        Date startdate;
        Date enddate;
        Integer ctr;
        
        Date dt = Date.parse('01/01/'+Year).addMonths(-1);
        Date lastDate = Date.parse('12/31/'+String.valueOf(dt.year()));
        DateTime dtNew = DateTime.newInstance(lastDate, Time.newInstance(0, 0, 0, 0));     
        String WeekName =  dtNew.format('EEE').toUpperCase();
        
        if(WeekName == 'MON')
            startdate = lastDate;
        else if(WeekName == 'TUE')
            startdate = lastDate.addDays(-1);
        else if(WeekName == 'WED')
            startdate = lastDate.addDays(-2);   
        else if(WeekName == 'THU')
            startdate = lastDate.addDays(-3);
        else if(WeekName == 'FRI')
            startdate = lastDate.addDays(-4);       
        else if(WeekName == 'SAT')
            startdate = lastDate.addDays(-5);
        else
            startdate = lastDate.addDays(-6);
        
        
        enddate = Date.Parse('12/31/'+String.valueOf(Integer.ValueOf(Year) + 1));
        ctr = 1;
        while(enddate >= startdate){
            if (Integer.valueOf(WeekNumber) == ctr){
                break;  
            }
            ctr += 1;   
            startdate = startdate.addDays(7);
        }
        
        return startdate.format();
    }    
    public string methodOne(){
        //One:
        
        if (first_char == 'L' ){
            
            first_char  =  traceCode.subString( 0, 1);
            first_number  = traceCode.subString( 1, 4);
            second_char  =  traceCode.subString( 4, 5);
            second_number  =  traceCode.subString( 5, 6);
            third_number  =  traceCode.subString( 6, 9);
            
            if (!first_number.isNumeric() || !second_number.isNumeric() || !third_number.isNumeric()){
                methodTwo();
            }
            
            if(first_char == 'L'  && ( second_char == 'X' || second_char == 'Y' || second_char == 'Z' ) 
               && ( Integer.ValueOf(first_number) >= 1 &&  Integer.ValueOf(first_number) <= 366 ) 
               && ( Integer.ValueOf(second_number) >= 0 && Integer.ValueOf(second_number) <= 9 )  
               && (  third_number == '000' ) ){ 
                   
                   if(Integer.ValueOf(second_number) == Integer.ValueOf(ln_lastdigit_year)){
                       lv_year  = '01/01' + lv_year_new.subString( 0, 4)+ second_number.subString( 0, 1);
                   }else{  
                       if (Integer.ValueOf(lv_cur_year) >= Integer.ValueOf('201' + second_number.subString( 0, 1))){
                           lv_year  = '01/01' + lv_year_new.subString(0, 4)+ second_number.subString( 0, 1);
                       }else{ 
                           lv_year  = '01/01' + lv_year.subString( 0, 4)+ second_number.subString( 0, 1);
                       }   
                   }
                   
                   production_date  =  Date.parse(lv_year).adddays(Integer.ValueOf(first_number) - 1).format();
                   
                   ln_days  =  date.parse(production_date).daysBetween(System.today());    
                   
                   if(ln_days <= 0){
                       return 'fail';
                   }else{ 
                       return production_date;
                   }   
               }else{ 
                   methodTwo(); 
               }
            
        }else{
            methodTwo();
        }
        return '';
    }
    
    public string methodTwo(){
        //two:                        
        
        if (productLineCode == 'TP'){                            
            first_char  =  traceCode.subString( 0, 3);
            first_number  =  traceCode.subString( 3, 4);
            second_char  =  traceCode.subString( 4, 6);
            second_number  =  traceCode.subString( 6, 8);
            third_char  =  traceCode.subString(8, 9);
            
            if(!second_number.isNumeric() || !second_char.isNumeric()){
                Return 'fail';
            }     
            
            if( ( Integer.valueOf(second_char) < 0 && Integer.valueOf(second_char) > 23 ) || ( Integer.valueOf(second_number) < 0 && Integer.valueOf(second_number) > 59 ) ){ 
                return 'fail';
            }
            
            if (third_char.subString(0, 1) != 'N' && third_char.subString(0, 1) != 'S' && third_char.subString(0, 1) != 'H' && third_char.subString(0, 1) != 'V' && third_char.subString(0, 1) != 'I' && third_char.subString(0, 1) != 'L' 
                && third_char.subString(0, 1) != 'E' && third_char.subString(0, 1) != 'A' && third_char.subString(0, 1) != 'B' && third_char.subString(0, 1) != 'P' && third_char.subString(0, 1) != 'Y' && third_char.subString(0, 1) != 'O' && third_char.subString(0, 1) != 'F' 
                && third_char.subString(0, 1) != 'G' && third_char.subString(0, 1) != 'Z' && third_char.subString(0, 1) != 'M' && third_char.subString(0, 1) != 'R' 
                && third_char.subString(0, 1) != 'K' && third_char.subString(0, 1) != 'W' && third_char.subString(0, 1) != '1' && third_char.subString(0, 1) != 'X'&& third_char.subString(0, 1) != '2'&& third_char.subString(0, 1) != '3'){
                    
                    return 'fail';
                }
            
            if (third_char.subString(0, 1) == 'N' || third_char.subString(0, 1) == 'S' || third_char.subString(0, 1) == 'H' || third_char.subString(0, 1) == 'V' 
                || third_char.subString(0, 1) == 'I' || third_char.subString(0, 1) == 'L' || third_char.subString(0, 1) == 'E' || third_char.subString(0, 1) == '2'
                || third_char.subString(0, 1) == '3' ){  
                    
                    if(first_char.subString(0, 1) != 'N' && first_char.subString(0, 1) != 'S' &&  first_char.subString(0, 1) != 'H' && first_char.subString(0, 1) != 'V' 
                       && first_char.subString(0, 1) != 'I' && first_char.subString(0, 1) != 'L' && first_char.subString(0, 1) != 'E' && first_char.subString(0, 1) != 'Q' && first_char.subString(0, 1) != 'C' && first_char.subString(0, 1) != 'D' ){ 
                           
                           return 'fail';
                       }
                    
                    if(first_char.subString(1, 2) != 'N' && first_char.subString(1, 2) != 'S' && first_char.subString(1, 2) != 'H' && first_char.subString(1, 2) != 'V' && first_char.subString(1, 2) != 'I' && first_char.subString(1, 2) != 'L' 
                       && first_char.subString(1, 2) != 'E' && first_char.subString(1, 2) != 'Q' && first_char.subString(1, 2) != 'C' && first_char.subString(1, 2) != 'D' ){ 
                           
                           return 'fail';
                       }
                    
                    if(first_char.subString(2, 3) != 'N' && first_char.subString(2, 3) != 'S' && first_char.subString(2, 3) != 'H' && first_char.subString(2, 3) != 'V' && first_char.subString(2, 3) != 'I' && first_char.subString(2, 3) != 'L' 
                       && first_char.subString(2, 3) != 'E' && first_char.subString(2, 3) != 'Q' && first_char.subString(2, 3) != 'C' && first_char.subString(2, 3) != 'D' ){ 
                           
                           return 'fail';
                       }
                    
                    lv_month  =  first_char.replace('N', '0').replace( 'S', '1').replace( 'H', '2').replace( 'V', '3').replace( 'I', '4').replace( 'L', '5').replace( 'E', '6').replace( 'Q', '7').replace( 'C', '8').replace( 'D', '9');
                }
            
            if(third_char.subString(0, 1) == 'A' || third_char.subString(0, 1) == 'B' || third_char.subString(0, 1) == 'P' || third_char.subString(0, 1) == 'Y' || third_char.subString(0, 1) == 'O' || third_char.subString(0, 1) == 'F' 
               || third_char.subString(0, 1) == 'G' || third_char.subString(0, 1) == 'Z' || third_char.subString(0, 1) == 'M' || third_char.subString(0, 1) == 'R' || third_char.subString(0, 1) == 'K' || third_char.subString(0, 1) == 'W' 
               || third_char.subString(0, 1) == '1' || third_char.subString(0, 1) == 'X' ) {
                   
                   if(first_char.subString(0, 1) !=  'F' && first_char.subString(0, 1) != 'R' && first_char.subString(0, 1) != 'P' && first_char.subString(0, 1) != 'K' && first_char.subString(0, 1) != 'G' && first_char.subString(0, 1) != 'Y' 
                      && first_char.subString(0, 1) != 'M' && first_char.subString(0, 1) != 'B' && first_char.subString(0, 1) != 'O' && first_char.subString(0, 1) != 'W' ){ 
                          
                          return 'fail';
                      }
                   
                   if(first_char.subString(1, 2) != 'F' && first_char.subString(1, 2) != 'R' && first_char.subString(1, 2) != 'P' && first_char.subString(1, 2) != 'K' && first_char.subString(1, 2) != 'G' && first_char.subString(1, 2) != 'Y' 
                      && first_char.subString(1, 2) != 'M' && first_char.subString(1, 2) != 'B' && first_char.subString(1, 2) != 'O' && first_char.subString(1, 2) != 'W' ){ 
                          
                          return 'fail';
                      }
                   
                   if(first_char.subString( 2, 3)  != 'F' &&  first_char.subString( 2, 3)  != 'R' &&  first_char.subString( 2, 3)  != 'P' &&  first_char.subString( 2, 3)  != 'K' &&  first_char.subString( 2, 3)  != 'G' &&  first_char.subString( 2, 3)  != 'Y' 
                      &&  first_char.subString( 2, 3)  != 'M' &&  first_char.subString( 2, 3)  != 'B' &&  first_char.subString( 2, 3)  != 'O' &&  first_char.subString( 2, 3)  != 'W' ){ 
                          
                          return 'fail';
                      }
                   
                   lv_month  =  first_char.replace( 'F', '0').replace( 'R', '1').replace( 'P', '2').replace( 'K', '3').replace( 'G', '4').replace( 'Y', '5').replace( 'M', '6').replace( 'B', '7').replace( 'O', '8').replace( 'W', '9');
                   
               }
            
            if (Integer.valueOf(lv_month) > 366 || Integer.valueOf(lv_month)<= 0 ){
                return 'fail';
            }
            
            lv_temp_year  = '';
            
            
            if( Integer.valueOf(first_number) >= 0 &&  Integer.valueOf(first_number) <= 9){
                
                if( (System.today().year() - Integer.ValueOf('201'+String.ValueOf(first_number )) ) <0){
                    lv_temp_year = String.ValueOf(lv_year.subString( 3, 4)) + String.ValueOf(first_number); 
                    
                }else{
                    lv_temp_year = String.ValueOf(lv_cur_year.subString(2, 3)) +String.ValueOf(first_number);                                
                }
                
                lv_year  = '01/01' + lv_year1 + lv_temp_year ;
                
                production_date  =  Date.parse(lv_year).adddays(Integer.ValueOf(lv_month) - 1).format();
                
                ln_days  =  date.parse(production_date).daysBetween(System.today());
                
                if(ln_days <= 0){
                    return 'fail';
                }else{ 
                    return production_date;
                }               
            }else{ 
                return 'fail';
            }               
        }
        return '';
    }
}