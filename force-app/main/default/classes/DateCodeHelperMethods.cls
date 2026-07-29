public class DateCodeHelperMethods {

    public static Map<String,String> CigTransDateCalculator(String traceCode, String production_date)
    {
        TraceCodeHelper tch = new TraceCodeHelper();
        Date ManufacturedDate = tch.convertProductDate(production_date);
        System.debug('Manufactured Date: ' + ManufacturedDate);
        
        Map<String,String> retVal = new Map<String,String>();
        String lv_shift = '', lv_military_time = '';
        String second_char = traceCode.substring(4, 5);
        
        Date transMT_startDate = Date.valueOf(Label.CIG_Trans_MT_Start_Date);
        Date transMT_endDate = Date.valueOf(Label.CIG_Trans_MT_End_Date);
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
        
        if(traceCode.length() == 9)
        {
            if(ManufacturedDate < transMT_startDate)
            {
                retVal.put('lv_shift',second_char);
            }
            else if(ManufacturedDate >= transMT_startDate && ManufacturedDate <= transMT_endDate)
            {
                if(fifthPosZ.contains(second_char))
                {
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
                            if(second_char==fifthPosZ[i]) break;
                        }
                        lv_military_time = '0' + String.valueOf(tmpMilitary);
                    }
                    retVal.put('lv_military_time',lv_military_time);
                }
                else if(fifthPosX.contains(second_char))
                {
                    retVal.put('lv_shift','X');
                    tmpMilitary = 700;
                    for(integer i=0;i<fifthPosX.size();i++)
                    {
                        if(second_char==fifthPosX[i]) break;
                        tmpMilitary = tmpMilitary + 100;
                    }
                    if(tmpMilitary<1000)
                        lv_military_time = '0' + String.valueOf(tmpMilitary);
                    else
                        lv_military_time = String.valueOf(tmpMilitary);
                    retVal.put('lv_military_time',lv_military_time);
                }
                else if(fifthPosY.contains(second_char))
                {
                    retVal.put('lv_shift','Y');
                    tmpMilitary = 1500;
                    for(integer i=0;i<fifthPosY.size();i++)
                    {
                        if(second_char==fifthPosY[i]) break;
                        tmpMilitary = tmpMilitary + 100;
                    }
                    lv_military_time = String.valueOf(tmpMilitary);
                    retVal.put('lv_military_time',lv_military_time);
                }
                else
                {
                    if(second_char.isAlpha())
                    {
                        retVal.put('lv_shift',second_char);
                        retVal.put('lv_military_time', null);
                    }
                }
            }
            else if(ManufacturedDate > transMT_endDate)
            {
                if(fifthPosZ.contains(second_char))
                {
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
                            if(second_char==fifthPosZ[i]) break;
                        }
                        lv_military_time = '0' + String.valueOf(tmpMilitary);
                    }
                    retVal.put('lv_military_time',lv_military_time);
                }
                else if(fifthPosX.contains(second_char))
                {
                    retVal.put('lv_shift','X');
                    tmpMilitary = 700;
                    for(integer i=0;i<fifthPosX.size();i++)
                    {
                        if(second_char==fifthPosX[i]) break;
                        tmpMilitary = tmpMilitary + 100;
                    }
                    if(tmpMilitary<1000)
                        lv_military_time = '0' + String.valueOf(tmpMilitary);
                    else
                        lv_military_time = String.valueOf(tmpMilitary);
                    retVal.put('lv_military_time',lv_military_time);
                }
                else if(fifthPosY.contains(second_char))
                {
                    retVal.put('lv_shift','Y');
                    tmpMilitary = 1500;
                    for(integer i=0;i<fifthPosY.size();i++)
                    {
                        if(second_char==fifthPosY[i]) break;
                        tmpMilitary = tmpMilitary + 100;
                    }
                    lv_military_time = String.valueOf(tmpMilitary);
                    retVal.put('lv_military_time',lv_military_time);
                }
                else
                {
                    if(second_char.isAlpha())
                    {
                        retVal.put('lv_shift','Post');
                        retVal.put('lv_military_time', null);
                    }
                }
            }
        }
        return retVal;
    }

    public static Date nextDay(String vDate, String vDay)
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

    public static String mondayDate(String year, String WeekNumber)
    {
        Date startdate;
        Date enddate;
        Integer ctr;
        Date dt = Date.parse('01/01/' + Year).addMonths(-1);
        Date lastDate = Date.parse('12/31/' + string.valueOf(dt.year()));
        DateTime dtNew = DateTime.newInstance(lastDate, Time.newInstance(0, 0, 0, 0));
        string WeekName = dtNew.format('EEE').toUpperCase();
        if(WeekName == 'MON')      { startdate = lastDate; }
        else if(WeekName == 'TUE') { startdate = lastDate.addDays(-1); }
        else if(WeekName == 'WED') { startdate = lastDate.addDays(-2); }
        else if(WeekName == 'THU') { startdate = lastDate.addDays(-3); }
        else if(WeekName == 'FRI') { startdate = lastDate.addDays(-4); }
        else if(WeekName == 'SAT') { startdate = lastDate.addDays(-5); }
        else                       { startdate = lastDate.addDays(-6); }
        enddate = Date.Parse('12/31/' + string.valueOf(Integer.ValueOf(Year) + 1));
        ctr = 1;
        while (enddate >= startdate)
        {
            if(Integer.valueOf(WeekNumber) == ctr) break;
            ctr += 1;
            startdate = startdate.addDays(7);
        }
        return startdate.format();
    }

    public static Integer monthNumber(String first_char)
    {
        Integer month_number;
        if      (first_char == 'Y') month_number = 01;
        else if (first_char == 'X') month_number = 02;
        else if (first_char == 'W') month_number = 03;
        else if (first_char == 'V') month_number = 04;
        else if (first_char == 'U') month_number = 05;
        else if (first_char == 'T') month_number = 06;
        else if (first_char == 'S') month_number = 07;
        else if (first_char == 'R') month_number = 08;
        else if (first_char == 'Q') month_number = 09;
        else if (first_char == 'P') month_number = 10;
        else if (first_char == 'O') month_number = 11;
        else if (first_char == 'N') month_number = 12;
        return month_number;
    }

    public static Integer yearNumber(String third_char)
    {
        Integer year_number;
        if      (third_char == 'L') year_number = 2014;
        else if (third_char == 'K') year_number = 2015;
        else if (third_char == 'J') year_number = 2016;
        else if (third_char == 'I') year_number = 2017;
        else if (third_char == 'H') year_number = 2018;
        else if (third_char == 'G') year_number = 2019;
        else if (third_char == 'F') year_number = 2020;
        else if (third_char == 'E') year_number = 2021;
        else if (third_char == 'D') year_number = 2022;
        else if (third_char == 'C') year_number = 2023;
        else if (third_char == 'B') year_number = 2024;
        else if (third_char == 'A') year_number = 2025;
        else if (third_char == 'Z') year_number = 2026;
        else if (third_char == 'Y') year_number = 2027;
        return year_number;
    }

    public static DateCodeHelperCore.TraceCodeValue getTraceCodeValuesForNC(
        String traceCode,
        String p_first_number, String p_second_number, String p_third_number,
        String p_first_char,   String p_second_char,   String p_third_char)
    {
        DateCodeHelperCore.TraceCodeValue tcValueObj = new DateCodeHelperCore.TraceCodeValue();
        
        if(traceCode.length() == 8)
        {
            if(!p_first_number.isNumeric() || !p_second_number.isNumeric() || !p_third_number.isNumeric())
            {
                tcValueObj.ProductionDate = 'FAIL';
            }
            if((p_first_char=='Y'||p_first_char=='X'||p_first_char=='W'||p_first_char=='V'
                ||p_first_char=='U'||p_first_char=='T'||p_first_char=='S'||p_first_char=='R'
                ||p_first_char=='Q'||p_first_char=='P'||p_first_char=='O'||p_first_char=='N')
               &&(p_second_char=='L'||p_second_char=='K'||p_second_char=='J'||p_second_char=='I'
                  ||p_second_char=='H'||p_second_char=='G'||p_second_char=='F'||p_second_char=='E'
                  ||p_second_char=='D'||p_second_char=='C'||p_second_char=='B'||p_second_char=='A'
                  ||p_second_char=='Z'||p_second_char=='Y')
               &&(Integer.valueOf(p_first_number)>=00 && Integer.valueOf(p_first_number)<=23)
               &&(Integer.valueOf(p_second_number)>=00 && Integer.valueOf(p_second_number)<=59)
               &&(Integer.valueOf(p_third_number)>=01 && Integer.valueOf(p_third_number)<=31))
            {
                Integer month_number = monthNumber(p_first_char);
                Integer year_number  = yearNumber(p_second_char);
                tcValueObj.ProductionDate = String.valueOf(month_number)+'/'+String.valueOf(p_third_number)+'/'+String.valueOf(year_number);
                tcValueObj.lnDays = date.parse(tcValueObj.ProductionDate).daysBetween(System.today());
                if(tcValueObj.lnDays <= 0)
                {
                    tcValueObj.ProductionDate = 'FAIL';
                }
                else
                {
                    system.debug('------production_date----' + tcValueObj.ProductionDate);
                    tcValueObj.lvMilitaryTime = p_first_number + p_second_number;
                }
            }
            else
            {
                tcValueObj.ProductionDate = 'FAIL';
            }
        }
        else if(traceCode.length() == 9)
        {
            if(!p_first_number.isNumeric() || !p_second_number.isNumeric() || !p_third_number.isNumeric())
            {
                tcValueObj.ProductionDate = 'FAIL';
            }
            if((p_first_char=='Y'||p_first_char=='X'||p_first_char=='W'||p_first_char=='V'
                ||p_first_char=='U'||p_first_char=='T'||p_first_char=='S'||p_first_char=='R'
                ||p_first_char=='Q'||p_first_char=='P'||p_first_char=='O'||p_first_char=='N')
               &&(p_third_char=='L'||p_third_char=='K'||p_third_char=='J'||p_third_char=='I'
                  ||p_third_char=='H'||p_third_char=='G'||p_third_char=='F'||p_third_char=='E'
                  ||p_third_char=='D'||p_third_char=='C'||p_third_char=='B'||p_third_char=='A'
                  ||p_third_char=='Z'||p_third_char=='Y')
               &&(Integer.valueOf(p_first_number)>=00 && Integer.valueOf(p_first_number)<=23)
               &&(Integer.valueOf(p_second_number)>=00 && Integer.valueOf(p_second_number)<=59)
               &&(Integer.valueOf(p_third_number)>=01 && Integer.valueOf(p_third_number)<=31))
            {
                Integer month_number = monthNumber(p_first_char);
                Integer year_number  = yearNumber(p_third_char);
                tcValueObj.ProductionDate = String.valueOf(month_number)+'/'+String.valueOf(p_third_number)+'/'+String.valueOf(year_number);
                tcValueObj.lnDays = date.parse(tcValueObj.ProductionDate).daysBetween(System.today());
                if(tcValueObj.lnDays <= 0)
                {
                    tcValueObj.ProductionDate = 'FAIL';
                }
                else
                {
                    system.debug('------production_date----' + tcValueObj.ProductionDate);
                    tcValueObj.lvMilitaryTime = p_first_number + p_second_number;
                }
            }
            else
            {
                tcValueObj.ProductionDate = 'FAIL';
            }
        }
        return tcValueObj;
    }

    public static void PTtraceCode4nonNumeric(String traceCode, DateCodeHelperCore h)
    {
        h.first_char  = traceCode.toUpperCase().subString(2, 4);
        h.second_char = traceCode.toUpperCase().subString(0, 1);
        h.third_char  = traceCode.toUpperCase().subString(1, 2);
        system.debug('first_char--> '  + h.first_char);
        system.debug('second_char--> ' + h.second_char);
        system.debug('third_char--> '  + h.third_char);
        
        h.charSet.clear();
        h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
        if(!h.charSet.contains(h.first_char.substring(0,1))) h.production_date = 'FAIL';
        h.charSet.clear();
        h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
        if(!h.charSet.contains(h.first_char.substring(1,2))) h.production_date = 'FAIL';
        h.charSet.clear();
        h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H','E','R'});
        if(!h.charSet.contains(h.second_char)) h.production_date = 'FAIL';
        h.charSet.clear();
        h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
        if(!h.charSet.contains(h.third_char)) h.production_date = 'FAIL';
        
        h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3')
                       .replace('C','4').replace('K','5').replace('S','6')
                       .replace('M','7').replace('I','8').replace('T','9').replace('H','0');
        h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03')
                       .replace('C','04').replace('K','05').replace('S','06')
                       .replace('M','07').replace('I','08').replace('T','09')
                       .replace('H','10').replace('E','11').replace('R','12');
        h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03')
                       .replace('C','04').replace('K','05').replace('S','06')
                       .replace('M','07').replace('I','08').replace('T','09').replace('H','00');
        system.debug('------lv_day--------'   + h.lv_day);
        system.debug('------lv_month--------' + h.lv_month);
        system.debug('--------lv_year2------' + h.lv_year2);
        
        if(Integer.valueOf(h.lv_day)   > 31) h.production_date = 'FAIL';
        if(Integer.valueOf(h.lv_month) > 12) h.production_date = 'FAIL';
        
        if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2)))
        {
            h.lv_year2 = h.lv_cur_year.subString(2,3) + h.lv_year2.subString(1,2);
            System.debug('-------lv_year2---------' + h.lv_year2);
            if(Integer.valueOf(h.lv_cur_year) == Integer.valueOf('201' + h.lv_year2.subString(1,2)))
            {
                h.production_date = string.valueOf(h.lv_month)+'/'+string.valueOf(h.lv_day)
                    +string.valueOf(h.lv_year1)+string.valueOf(h.lv_year2);
                System.debug('-------production_date---------' + h.production_date);
                try
                {
                    date dt = date.parse(h.production_date);
                    if(date.parse(h.production_date) >= System.today())
                    {
                        h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
                    }
                    System.debug('--------lv_year2--------' + h.lv_year2);
                }
                catch(Exception ex) {}
            }
        }
        else
        {
            h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
            System.debug('-------lv_year2---------' + h.lv_year2);
        }
        h.year_leep = h.lv_year1.subString(1,3) + string.valueOf(h.lv_year2);
        System.debug('---------year_leep-------' + h.year_leep);
        if(Date.parse('02/28/'+string.valueOf(h.year_leep)).addDays(1).Month() == 2)
        {
            if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30)
                h.production_date = 'fail';
        }
        else if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29)
        {
            h.production_date = 'fail';
        }
        if(h.production_date != 'fail')
        {
            h.production_date = string.valueOf(h.lv_month)+'/'+string.valueOf(h.lv_day)
                +string.valueOf(h.lv_year1)+string.valueOf(h.lv_year2);
            System.debug('---------production_date-------' + h.production_date);
        }
        h.ln_days = date.parse(h.production_date).daysBetween(system.today());
        System.debug('-------ln_days---------' + h.ln_days);
        if(h.ln_days <= 0) h.production_date = 'FAIL';
        h.lv_unit                  = '';
        h.lv_location              = 'Limerick';
        h.lv_date_code_rpt_factory = 'Limerick';
    }

    public static void PTtraceCode4Numeric(String traceCode, DateCodeHelperCore h)
    {
        h.first_char    = traceCode.subString(0,1);
        h.second_number = traceCode.subString(1,3);
        h.fourth_number = traceCode.subString(3,4);
        
        if(!h.second_number.isNumeric() || !h.fourth_number.isNumeric())
            h.production_date = 'fail';
        if(Integer.valueOf(h.second_number) > 53)
            h.production_date = 'fail';
        
        if(h.first_char=='L' || h.first_char=='J' || h.first_char=='P' || h.first_char=='W')
        {
            if(h.first_char=='L')      { h.lv_location='LIMERICK';         h.lv_date_code_rpt_factory='LIMERICK';    h.lv_date_code_cold_storage='N'; }
            else if(h.first_char=='J') { h.lv_location='LIMERICK';         h.lv_date_code_rpt_factory='LIMERICK';    h.lv_date_code_cold_storage='Y'; }
            else if(h.first_char=='P') { h.lv_location='COLONIAL HEIGHTS'; h.lv_date_code_rpt_factory='PRECON_JMC'; h.lv_date_code_cold_storage='N'; }
            else if(h.first_char=='W') { h.lv_location='COLONIAL HEIGHTS'; h.lv_date_code_rpt_factory='PRECON_JMC'; h.lv_date_code_cold_storage='Y'; }
            
            String lv_cur_year_local = String.valueOf(System.today().year());
            Integer lv_cur_year_4th  = Integer.valueOf(lv_cur_year_local.subString(3,4));
            Integer prodDate;
            if(lv_cur_year_4th == Integer.valueOf(h.fourth_number))
                prodDate = Integer.valueOf(lv_cur_year_local);
            else if(lv_cur_year_4th < Integer.valueOf(h.fourth_number))
                prodDate = (Integer.valueOf(lv_cur_year_local)-10)
                           +(Integer.valueOf(h.fourth_number)-lv_cur_year_4th);
            else
                prodDate = (Integer.valueOf(lv_cur_year_local)-lv_cur_year_4th)
                           +Integer.valueOf(h.fourth_number);
            
            h.fiscal_week = h.second_number + String.valueOf(prodDate).substring(2,4);
            if(h.fiscal_week!='' || h.fiscal_week!=null)
            {
                h.fw = [SELECT PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c
                        FROM Financial_Week__c
                        WHERE FISCAL_WEEK_YEAR__c = :h.fiscal_week LIMIT 1];
                if(h.fw!=null) h.production_date = h.fw.PRODUCTION_DATE__c;
            }
            h.ln_days = date.parse(h.production_date).daysBetween(System.today());
            if(h.ln_days <= 0) h.production_date = 'fail';
        }
        else
        {
            h.production_date = 'fail';
        }
    }

    public static void methodOne(DateCodeHelperCore h)
    {
        if(h.ProductLineCode=='TP' && h.Check2=='Subloop')
        {
            h.lv_month      = '0';
            h.first_char    = h.traceCode.substring(0,3).toUpperCase();
            h.first_number  = h.traceCode.substring(3,4);
            h.second_char   = h.traceCode.substring(4,6).toUpperCase();
            h.second_number = h.traceCode.substring(6,8);
            h.third_char    = h.traceCode.substring(8,9);
            
            if(h.first_number.isNumeric() && h.second_char.isNumeric() && h.second_number.isNumeric())
            {
                if((Integer.valueOf(h.second_char)<0 && Integer.valueOf(h.second_char)>23)
                   ||(Integer.valueOf(h.second_char)<0 && Integer.valueOf(h.second_char)>59))
                {
                    h.production_date = 'FAIL';
                }
                h.lv_military_time = h.second_char + h.second_number;
                
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'N','S','H','V','I','L','E','A','B','P','Y','O','F','G','Z','M','R','K','W','1','2','3'});
                if(!h.charSet.contains(h.first_char.subString(0,1))) h.production_date='FAIL';
                
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'N','S','H','V','I','L','E','2','3'});
                if(h.charSet.contains(h.third_char.substring(0,1)))
                {
                    h.charSet.clear();
                    h.charSet.addAll(new List<String>{'N','S','H','V','I','L','E','Q','C','D'});
                    if(!h.charSet.contains(h.first_char.substring(0,1))) h.production_date='FAIL';
                    if(!h.charSet.contains(h.first_char.substring(1,2))) h.production_date='FAIL';
                    if(!h.charSet.contains(h.first_char.substring(2,3))) h.production_date='FAIL';
                    if(h.production_date!='FAIL')
                    {
                        h.lv_month = h.second_char
                            .replace('N','0').replace('S','1').replace('H','2')
                            .replace('V','3').replace('I','4').replace('L','5')
                            .replace('E','6').replace('Q','7').replace('C','8').replace('C','9');
                    }
                    h.lv_location='Nashville';
                    h.lv_date_code_rpt_factory='NS';
                }
                
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'A','B','P','Y','O','F','G','Z','M','R','K','W','1','X'});
                if(h.charSet.contains(h.third_char.substring(1,1)))
                {
                    h.charSet.clear();
                    h.charSet.addAll(new List<String>{'F','R','P','K','G','Y','M','B','O','W'});
                    if(!h.charSet.contains(h.first_char.substring(0,1))) h.production_date='FAIL';
                    h.charSet.clear();
                    h.charSet.addAll(new List<String>{'F','R','P','K','G','Y','M','B','O','W'});
                    if(!h.charSet.contains(h.first_char.substring(1,2))) h.production_date='FAIL';
                    h.charSet.clear();
                    h.charSet.addAll(new List<String>{'F','R','P','K','G','Y','M','B','O','W'});
                    if(!h.charSet.contains(h.first_char.substring(2,3))) h.production_date='FAIL';
                    if(h.production_date!='FAIL')
                    {
                        h.lv_month = h.second_char
                            .replace('F','0').replace('R','1').replace('P','2')
                            .replace('K','3').replace('F','4').replace('Y','5')
                            .replace('M','6').replace('B','7').replace('O','8').replace('W','9');
                    }
                    h.lv_location='Franklin Park';
                    h.lv_date_code_rpt_factory='FP';
                }
                
                if(Integer.valueOf(h.lv_month)>366 || Integer.valueOf(h.lv_month)<366)
                    h.production_date='FAIL';
                
                h.lv_temp_year='';
                if((Integer.valueOf(h.first_number)>0 && Integer.valueOf(h.first_number)<9)
                   &&(Integer.valueOf(h.lv_month)<=366 && Integer.valueOf(h.lv_month)>0))
                {
                    h.lv_temp_year=null;
                    if(System.today().year()-Integer.valueOf('201'+String.valueOf(h.second_number))<0)
                        h.lv_temp_year='0'+String.valueOf(h.second_number);
                    else
                        h.lv_temp_year='1'+String.valueOf(h.second_number);
                    h.lv_year=('01/01'+h.lv_year1+h.lv_temp_year);
                    h.production_date=date.parse(h.lv_year).addDays(Integer.valueOf(h.first_number)-1).format();
                    h.ln_days=Date.parse(h.production_date).daysBetween(System.today());
                    if(h.ln_days<=0) h.production_date='FAIL';
                    h.lv_military_time=h.second_char+h.second_number;
                }
                else
                {
                    h.production_date='FAIL';
                }
            }
            else
            {
                h.production_date='FAIL';
            }
        }
    }
}