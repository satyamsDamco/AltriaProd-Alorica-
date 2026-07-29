public class TraceCodeHelperCore{
    
     public static String ProductDateCalculator(String traceCode, String productCode)
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
                productionDate = TraceCodeHelperCore.sixCharacterProductDate(traceCode);
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
                
                if(!TraceCodeHelperCore.JulianDateChecker(prodDayAndMonth,final_year)){
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
            
            if(!TraceCodeHelperCore.JulianDateChecker(julian_date,final_year)){
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
                
                if(!TraceCodeHelperCore.JulianDateChecker(prodDayAndMonth,final_year)){
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
                
                if(!TraceCodeHelperCore.JulianDateChecker(prodDayAndMonth,final_year)){
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
    
    public static String sixCharacterProductDate(string traceCode){
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
    
    public static Boolean JulianDateChecker(String julday, Integer calyear)
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
    
    public static Date convertProductDate(String production_date)
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
    public static date nextDay(string vDate, String vDay){
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
    
    public static string mondayDate(String year, String WeekNumber){
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
    public static string methodOne(String first_char,String first_number, String second_char, String second_number,String third_char, String third_number, String traceCode, Integer ln_lastdigit_year,String lv_year,String lv_year_new,string lv_cur_year, String production_date, Integer ln_days, String productLineCode, String lv_year1, string lv_month, string lv_temp_year){
        //One:
        
        if (first_char == 'L' ){
            
            first_char  =  traceCode.subString( 0, 1);
            first_number  = traceCode.subString( 1, 4);
            second_char  =  traceCode.subString( 4, 5);
            second_number  =  traceCode.subString( 5, 6);
            third_number  =  traceCode.subString( 6, 9);
            
            if (!first_number.isNumeric() || !second_number.isNumeric() || !third_number.isNumeric()){
                methodTwo( first_char, first_number, second_char, second_number, third_char, third_number,  traceCode, lv_year, lv_year_new, lv_cur_year, production_date, ln_days, productLineCode, lv_year1, lv_month, lv_temp_year);
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
                   methodTwo(first_char, first_number,  second_char,  second_number, third_char, third_number,  traceCode, lv_year, lv_year_new, lv_cur_year,  production_date,  ln_days,  productLineCode,  lv_year1,  lv_month,  lv_temp_year); 
               }
            
        }else{
            methodTwo(first_char, first_number,  second_char,  second_number, third_char, third_number,  traceCode, lv_year, lv_year_new, lv_cur_year,  production_date,  ln_days,  productLineCode,  lv_year1,  lv_month,  lv_temp_year);
        }
        return '';
    }
    
    public static string methodTwo(String first_char,String first_number, String second_char, String second_number,String third_char, String third_number, String traceCode,String lv_year,String lv_year_new,string lv_cur_year, String production_date, Integer ln_days, String productLineCode, String lv_year1, string lv_month, string lv_temp_year){
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