public class TraceCodeHelperSecondClass {
    
    public static string validateTraceCode(string workTraceCode){
        //RITM2890914
        Integer year=0;
        String productionDateStr;
        Integer strMilitaryHour;
        Integer strMilitaryMin;
        Date productionDate;
        boolean fifthCharValid = false;
        string firstCharacter = workTraceCode.substring(0,1);
        String productionDay = workTraceCode.substring(1,4);
        Integer julienDate = Integer.valueOf(productionDay);
        Date workDate = system.today();
        system.debug('Work Date is ' + workDate);
        Integer workYear = workDate.Year();
        system.debug('Work Year is ' + workYear);
        if (firstCharacter == 'K') {
            system.debug('Control in K ' + workYear);
            
            for (Integer i = 2023; i <= workYear;) {
                year = i;
                i += 4; // Corrected loop variable update
                system.debug('Year from K ' + year);
            }
            
            
        } else if (firstCharacter == 'O') {
            
            for (Integer i = 2024; i <= workYear; i += 4) {
                year = i;
                system.debug('Year from O ' + year);
            }
            
        } else if (firstCharacter == 'B') {
            for (Integer i = 2025; i <= workYear; i += 4) {
                year = i;
                system.debug('Year from B ' + year);
            }
            
        } else {
            for (Integer i = 2026; i <= workYear; i += 4) {
                year = i;
                system.debug('Year from A ' + year);
            }  
        }
        if (Year <= 0){
            return 'fail';
        }
        
        string fifthChar = workTraceCode.substring(4,5);
        if(fifthChar == 'G' || fifthChar == 'K' || fifthChar == 'O' || fifthChar == 'T' || fifthChar == 'Y' || fifthChar == 'U' || fifthChar == 'Z' )
        {
            fifthCharValid = true;
        }
        strMilitaryHour = Integer.ValueOf(workTraceCode.substring(5,7));
        strMilitaryMin = Integer.ValueOf(workTraceCode.substring(7,9));
        productionDate = Date.newInstance(year, 1, 1).addDays(julienDate - 1);
        productionDateStr = productionDate.format();
        System.debug('Production Date is ' + productionDateStr);
        
        
        
        if((strMilitaryHour > -1 && strMilitaryHour < 24) && (strMilitaryMin > -1 && strMilitaryMin < 60) && productionDate <=workDate && fifthCharValid ){
            return productionDateStr;
        }
        else{
            return 'fail';
        }
    }
    
    public static String ProductDateCalculator(String traceCode, String productCode)
    {
        
        //End 
        if (productCode != 'PT' && productCode != 'TDNS' && productCode != 'SNP') //productCode == 'AS' and productCode == 'GP'
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
        return 'fail';
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
    
    public static string NjoyTraceCode(String traceCode){
        
        Date productionDate;
        Date packingDate;
        string productionDateStr;
        String currentYear = String.valueOf(System.today().year()); 
        String lastCharacter = traceCode.substring(10, 11);
        String productionYear = currentYear.substring(0, 3) + lastCharacter;
        if(Integer.ValueOf(productionYear)> Integer.ValueOf(currentYear)){
            integer productionYearValue = (Integer.ValueOf(productionYear) - 10); 
            productionYear = String.ValueOf(productionYearValue);
            system.debug(productionYear);
        }
        String productionDay = traceCode.substring(0, 3);
        string PackingDay = traceCode.substring(7,10);
        Integer julienDateForProduction = Integer.valueOf(productionDay);
        Integer julienDateForPacking = Integer.valueOf(PackingDay);
        productionDate = Date.newInstance(Integer.ValueOf(productionYear), 1, 1).addDays(julienDateForProduction - 1);
        packingDate = Date.newInstance(Integer.ValueOf(productionYear), 1, 1).addDays(julienDateForPacking - 1);
        productionDateStr = productionDate.format();
        
        String foruthANdFifth =traceCode.substring(3, 5);
        String sixthAndSeventh = traceCode.substring(5,7);
        System.debug('productionYear : ' + productionYear);
        System.debug('PackingDay : ' + PackingDay);
        System.debug('packingDate : '+ packingDate);
        System.debug('productionDate : '+ productionDate);
        System.debug('julienDateForProduction : '+ julienDateForProduction);
        System.debug('julienDateForPacking : '+ julienDateForPacking);
        System.debug('sixthAndSeventh : '+ sixthAndSeventh);
        System.debug('foruthANdFifth : '+ foruthANdFifth);
        if (sixthAndSeventh == '00' ||  foruthANdFifth == '00' || julienDateForProduction > 366 || julienDateForPacking > 366) {
            System.debug('Control in null : ');
            return null;
        }
        
        if (productionDate <= System.today() ) {
            System.debug('Control in production Date : '+productionDate);
            return productionDateStr;
        }
        return null;
    }
    
    //SCR 2025-11-03: Helix ON 10 Character Codes - Validate 10-character TDNP trace code
    public static String validateTDNP10CharTraceCode(String traceCode) {
        if(traceCode == null || traceCode.length() != 10) {
            return null;
        }
        
        String prodYear = traceCode.substring(0,1);
        String prodDayAndMonth = traceCode.substring(1,4);
        String module = traceCode.substring(4,5);
        String shift = traceCode.substring(5,9);
        String machineCodeChar = traceCode.substring(9,10);
        
        Integer final_year = 0;
        Date dateToProcess = System.today();
        Date final_date;
        String productionDate = null;
        
        //Use custom label for testing with future dates
        if(Label.Override_date != 'yyyy-mm-dd') {
            dateToProcess = date.valueOf(Label.Override_date);
        }
        
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
        
        if(!JulianDateChecker(prodDayAndMonth, final_year)){
            System.debug('JulianDateChecker-->');
            return null; //Julian provided is invalid
        }
        
        final_date = date.newInstance(final_year,1,1);
        final_date = final_date.addDays(Integer.valueOf(prodDayAndMonth)-1);
        
        //Check if derived date is less than the system date
        if(final_date >= dateToProcess) {
            return null; //Production Date must be less than System Date
        }
        
        //Validate Shift (Military Time)
        if(shift.isNumeric()) {
            if(!(Integer.valueOf(shift.subString(0,2)) <= 23 && Integer.valueOf(shift.subString(2,4)) <= 59)) {
                return null; //Invalid Shift
            }
        } else {
            return null; //Shift must be numeric
        }
        
        //Validate Module (5th character)
        if(module != 'U' && module !='J' && module !='N' && module !='P' && module !='E' && module !='H'&&
           module != 'A' && module !='B' && module !='C' && module !='D' && module !='F')
        {
            return null; //Invalid Module
        }
        
        //Validate 10th character for Machine Code (valid values: 1, 2, 3, or 4)
        if(machineCodeChar != '1' && machineCodeChar != '2' && machineCodeChar != '3' && machineCodeChar != '4') {
            return null; //Invalid 10th character for Machine Code
        }
        
        //All validations passed, return production date
        productionDate = String.valueOf(final_date.format());
        return productionDate;
    }
    
}