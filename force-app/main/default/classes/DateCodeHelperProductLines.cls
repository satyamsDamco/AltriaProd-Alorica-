public class DateCodeHelperProductLines {

    // ---------------------------------------------------------------
    // GP (Cigars) product line logic extracted from DateCodeHelper
    // ---------------------------------------------------------------
    public static void processGP(DateCodeHelper h) {
        if(h.traceCode.length() == 7) {
            h.first_char    = h.traceCode.toUpperCase().subString(5, 7);
            h.second_char   = h.traceCode.toUpperCase().subString(2, 3);
            h.third_char    = h.traceCode.subString(3, 4);
            h.first_number  = h.traceCode.subString(0, 2);
            h.second_number = h.traceCode.subString(4, 5);

            if((h.first_number.substring(1,2)).isNumeric() && h.second_number.isNumeric()) {
                if(((h.first_number.substring(1,2)).isNumeric()==false) || (h.second_number.isNumeric()==false)) {
                    h.production_date = 'FAIL';
                }
                h.charSet.clear();
                h.charSet.add('X'); h.charSet.add('P');
                if(h.charSet.contains(h.first_number.substring(0,1))) {
                    h.CHECK = 1;
                }
                if(h.first_number.substring(0,1).isNumeric() == false && h.CHECK != 1) {
                    h.production_date = 'FAIL';
                }
                if((h.first_number.substring(1,2)).isNumeric() == false) {
                    h.production_date = 'FAIL';
                }
                if((h.first_number.substring(0,1)).isNumeric() && h.CHECK != 1) {
                    if(Integer.valueOf(h.first_number) < 1 || Integer.valueOf(h.first_number) > 15) {
                        h.production_date = 'FAIL';
                    }
                }
                if(h.CHECK != 1 && Integer.valueOf(h.second_number) < 1 || Integer.valueOf(h.second_number) > 3) {
                    h.production_date = 'FAIL';
                }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
                if(!h.charSet.contains(h.first_char.substring(0,1))) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
                if(!h.charSet.contains(h.first_char.substring(1,2))) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H','E','R'});
                if(!h.charSet.contains(h.second_char)) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
                if(!h.charSet.contains(h.third_char)) { h.production_date = 'FAIL'; }

                h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
                h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
                h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');

                if(h.lv_day.isNumeric() && Integer.valueOf(h.lv_day) > 31) { h.production_date = 'FAIL'; }
                if(Integer.valueOf(h.lv_month) > 12) { h.production_date = 'FAIL'; }
                h.intSet.clear();
                h.intSet.add(4); h.intSet.add(6); h.intSet.add(9); h.intSet.add(11);
                if(h.intSet.contains(Integer.valueOf(h.lv_month)) && Integer.valueOf(h.lv_day)>=31) { h.production_date = 'FAIL'; }

                if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                    h.lv_year2 = h.lv_cur_year.substring(2,3) + h.lv_year2.substring(1,2);
                    if(Integer.valueOf(h.lv_cur_year) == Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                        h.production_date = String.valueOf(h.lv_month) + '/' + String.valueOf(h.lv_day) + String.valueOf(h.lv_year1) + String.valueOf(h.lv_year2);
                        if(Date.valueOf(h.production_date) >= Date.today()) {
                            h.lv_year2 = h.lv_year.substring(2,3) + h.lv_year2.substring(1,2);
                        }
                    }
                } else {
                    h.lv_year2 = h.lv_year.substring(2,3) + h.lv_year2.substring(1,2);
                }
                h.year_leep = h.lv_year1.substring(1,3) + String.valueOf(h.lv_year2);
                if(Date.parse('02/28/' + String.valueOf(h.year_leep)).addDays(1).Month() == 2) {
                    if(Integer.valueOf(h.lv_month) == 2 && Integer.valueOf(h.lv_day) >= 30) { h.production_date = 'FAIL'; }
                } else {
                    if(Integer.valueOf(h.lv_month) == 2 && Integer.valueOf(h.lv_day) >= 29) { h.production_date = 'FAIL'; }
                }
                if(h.production_date != 'FAIL') {
                    h.production_date = String.valueOf(h.lv_month) + '/' + String.valueOf(h.lv_day) + String.valueOf(h.lv_year1) + String.valueOf(h.lv_year2);
                }
                if(h.production_date != 'FAIL') {
                    h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                }
                if(h.ln_days <= 0) { h.production_date = 'FAIL'; }
                h.lv_unit = h.first_number;
                if(h.first_number.substring(0,1) == 'X') { h.lv_location = '3rd PARTY MANUFACTURER'; }
                if(h.first_number.substring(0,1) != 'X') { h.lv_location = 'Limerick'; }
                if(Integer.valueOf(h.second_number) == 1)      { h.lv_shift = 'Shift1'; }
                else if(Integer.valueOf(h.second_number) == 2) { h.lv_shift = 'Shift2'; }
                else if(Integer.valueOf(h.second_number) == 3) { h.lv_shift = 'Shift3'; }
            } else {
                h.production_date = 'FAIL';
            }
        }
        else if(h.traceCode.length() == 5) {
            h.second_char   = h.traceCode.substring(0,1);
            h.third_char    = h.traceCode.substring(1,2);
            h.second_number = h.traceCode.substring(2,3);
            h.first_char    = h.traceCode.substring(3,5);
            if(h.second_number.isNumeric() == true) {
                if(Integer.valueOf(h.second_number) < 1 || Integer.valueOf(h.second_number) > 3) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
                if(!h.charSet.contains(h.first_char.substring(0,1))) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
                if(!h.charSet.contains(h.first_char.substring(1,2))) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H','E','R'});
                if(!h.charSet.contains(h.second_char)) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
                if(!h.charSet.contains(h.third_char)) { h.production_date = 'FAIL'; }

                h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
                h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
                h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');

                if(Integer.valueOf(h.lv_day) > 31)  { h.production_date = 'FAIL'; }
                if(Integer.valueOf(h.lv_month) > 12) { h.production_date = 'FAIL'; }

                if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                    h.lv_year2 = h.lv_cur_year.substring(2,3) + h.lv_year2.substring(1,2);
                } else {
                    h.lv_year2 = h.lv_year.substring(2,3) + h.lv_year2.substring(1,2);
                }
                h.year_leep = h.lv_year1.subString(1,3) + String.valueOf(h.lv_year2);
                if(date.parse(('02/28/' + String.valueOf(h.year_leep))).addDays(1).month() == 2) {
                    if(Integer.valueOf(h.lv_month) == 2 && Integer.valueOf(h.lv_day) >= 30) { h.production_date = 'fail'; }
                } else {
                    if(Integer.valueOf(h.lv_month) == 2 && Integer.valueOf(h.lv_day) >= 29) { h.production_date = 'fail'; }
                }
                if(Integer.valueOf(h.lv_month) == 4 || Integer.valueOf(h.lv_month) == 6 || Integer.valueOf(h.lv_month) == 9 || Integer.valueOf(h.lv_month) == 11) {
                    if(Integer.valueOf(h.lv_day) >= 31) { h.production_date = 'fail'; }
                }
                if(h.production_date != 'fail') {
                    h.production_date = String.valueOf(h.lv_month) + '/' + String.valueOf(h.lv_day) + String.valueOf(h.lv_year1) + String.valueOf(h.lv_year2);
                    h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                }
                if(h.ln_days <= 0) { h.production_date = 'FAIL'; }
                h.lv_unit = '';
                h.lv_location = 'Limerick';
                if(Integer.valueOf(h.second_number) == 1)      { h.lv_shift = 'Shift1'; }
                else if(Integer.valueOf(h.second_number) == 2) { h.lv_shift = 'Shift2'; }
                else if(Integer.valueOf(h.second_number) == 3) { h.lv_shift = 'Shift3'; }
            } else {
                h.production_date = 'FAIL';
            }
        }
        else if(h.traceCode.length() == 8) {
            h.first_char    = h.traceCode.substring(0,1);
            h.first_number  = h.traceCode.substring(1,4);
            h.second_char   = h.traceCode.substring(4,5);
            h.second_number = h.traceCode.substring(5,6);
            h.third_number  = h.traceCode.substring(6,8);
            if(h.second_char == 'X' || h.second_char == 'Y' || h.second_char == 'Z') { h.lv_shift = h.second_char; }
            h.cigar7position = h.traceCode.substring(6,7);
            h.cigar8position = h.traceCode.substring(7,8);
            if(h.third_number.isNumeric()) {
                h.lv_unit = h.third_number;
            } else {
                if(h.cigar7position == 'P' && h.cigar8position.isNumeric()) { h.lv_unit = h.third_number; }
            }
            if(h.first_number.isNumeric() || h.second_number.isNumeric() || h.third_number.isNumeric()) { h.production_date = 'FAIL'; }
            if(h.first_char=='J' || h.first_char=='Z' || h.first_char=='S' || h.first_char=='R') {
                h.lv_date_code_cold_storage = 'Y';
            } else {
                h.lv_date_code_cold_storage = 'N';
            }
            if(h.first_char=='T'||h.first_char=='N'||h.first_char=='A'||h.first_char=='B'||h.first_char=='C'
               ||h.first_char=='D'||h.first_char=='E'||h.first_char=='F'||h.first_char=='G'||h.first_char=='H'
               ||h.first_char=='I'||h.first_char=='K'||h.first_char=='M') {
                h.lv_location = 'Limerick';
            } else if(h.first_char=='X'||h.first_char=='Z'||h.first_char=='S') {
                h.lv_location = '3rd PARTY MANUFACTURER';
            } else if(h.first_char=='R'||h.first_char=='V') {
                h.lv_location = 'MC_JMC';
            }
            if((h.first_char=='A'||h.first_char=='B'||h.first_char=='C'||h.first_char=='D'||h.first_char=='E'
                ||h.first_char=='F'||h.first_char=='G'||h.first_char=='H'||h.first_char=='I'||h.first_char=='J'
                ||h.first_char=='K'||h.first_char=='L'||h.first_char=='M'||h.first_char=='N'||h.first_char=='S'
                ||h.first_char=='T'||h.first_char=='X'||h.first_char=='Z'||h.first_char=='R'||h.first_char=='V')
               && (h.second_char=='X'||h.second_char=='Y'||h.second_char=='Z')
               && Integer.valueOf(h.first_number)>=1 && Integer.valueOf(h.first_number)<=366
               && Integer.valueOf(h.second_number)>=0 && Integer.valueOf(h.second_number)<=9) {
                if(Integer.valueOf(h.second_number) == Integer.valueOf(h.ln_lastdigit_year)) {
                    h.lv_year = '01/01' + h.lv_year_new.substring(0,4) + h.second_number.substring(0,1);
                } else {
                    if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.second_number.substring(0,1))) {
                        h.lv_year = '01/01' + h.lv_year.substring(0,4) + h.second_number.substring(0,1);
                    } else {
                        h.lv_year = '01/01' + h.lv_year.substring(0,4) + h.second_number.substring(0,1);
                    }
                }
                if(h.second_number.length() >= 2) {
                    h.lv_leap_year = h.lv_leap_year + h.second_number.substring(1,2);
                } else {
                    String xx = '00';
                    h.lv_leap_year = h.lv_leap_year + xx.subString(0, 1-h.second_number.length()) + h.second_number;
                }
                Date dt8 = Date.parse('02/01/' + String.valueOf(h.lv_leap_year)).addMonths(1);
                h.ln_leap = String.valueOf(dt8.addDays(-dt8.day()).day());
                if(Integer.valueOf(h.ln_leap) == 28) {
                    if(Integer.valueOf(h.first_number) > 365) {
                        h.production_date = 'FAIL';
                    } else {
                        h.production_date = date.parse(h.lv_year).addDays(Integer.valueOf(h.first_number)-1).format();
                    }
                } else {
                    h.production_date = date.parse(h.lv_year).addDays(Integer.valueOf(h.first_number)-1).format();
                }
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) {
                    h.production_date = 'FAIL';
                }
                h.lv_shift = h.second_char;
                h.lv_unit  = h.third_number;
            } else {
                h.production_date = 'FAIL';
            }
        }
        else if(h.traceCode.length() == 11) {
            h.first_char    = h.traceCode.substring(0,1).toUpperCase();
            h.first_number  = h.traceCode.substring(1,4);
            h.second_char   = h.traceCode.substring(4,5).toUpperCase();
            h.second_number = h.traceCode.substring(5,6);
            h.third_char    = h.traceCode.substring(6,7);
            h.fifth_number  = h.traceCode.substring(7,11);
            Integer codeLen11 = h.traceCode.length();
            String p1c11     = h.first_char;
            String plc11     = h.ProductLineCode;
            for(Tracecode_Matrix_Table__c tmtt : [SELECT Production_Location__c, Factory__c, COLD_STORAGE__c
                                                  FROM Tracecode_Matrix_Table__c
                                                  WHERE Character_Length__c =: codeLen11
                                                  AND Position_1__c =: p1c11
                                                  AND Product_Line_Code__c =: plc11
                                                  ORDER BY CreatedDate DESC LIMIT 1]) {
                h.lv_location             = tmtt.Production_Location__c;
                h.lv_date_code_rpt_factory = tmtt.Factory__c;
                h.lv_date_code_cold_storage = tmtt.COLD_STORAGE__c;
            }
            if(String.isEmpty(h.lv_location))              { h.lv_location = 'DOMINICAN REPUBLIC'; }
            if(String.isEmpty(h.lv_date_code_rpt_factory)) { h.lv_date_code_rpt_factory = '3RD PARTY MANUFACTURER'; }
            if(h.second_char=='X'||h.second_char=='Y'||h.second_char=='Z') { h.lv_shift = h.second_char; }
            if(h.third_char.isAlpha()) { h.lv_unit = h.third_char; }
            if(h.fifth_number.isNumeric()) {
                String milHr11  = h.traceCode.substring(7,9);
                String milMin11 = h.traceCode.substring(9,11);
                if(Integer.valueOf(milHr11) < 24 && Integer.valueOf(milMin11) < 60) { h.lv_military_time = h.fifth_number; }
            }
            TraceCodeHelper tch11 = new TraceCodeHelper();
            h.production_date = tch11.ProductDateCalculator(h.traceCode, h.ProductLineCode.toUpperCase());
        }
        else if(h.traceCode.length() == 12) {
            h.first_char    = h.traceCode.substring(0,1).toUpperCase();
            h.first_number  = h.traceCode.substring(1,4);
            h.second_char   = h.traceCode.substring(4,5).toUpperCase();
            h.second_number = h.traceCode.substring(5,6);
            h.third_number  = h.traceCode.substring(6,8);
            h.fifth_number  = h.traceCode.substring(8,12);
            if(h.fifth_number.isNumeric()) {
                String milHr12  = h.traceCode.substring(8,10);
                String milMin12 = h.traceCode.substring(10,12);
                if(Integer.valueOf(milHr12) < 24 && Integer.valueOf(milMin12) < 60) { h.lv_military_time = h.fifth_number; }
            }
            Integer codeLen12 = h.traceCode.length();
            String p1c12 = h.first_char;
            String plc12 = h.ProductLineCode;
            Tracecode_Matrix_Table__c tmt12 = [SELECT Production_Location__c, Factory__c, COLD_STORAGE__c
                                               FROM Tracecode_Matrix_Table__c
                                               WHERE Character_Length__c =: codeLen12
                                               AND Position_1__c =: p1c12
                                               AND Product_Line_Code__c =: plc12
                                               ORDER BY CreatedDate DESC LIMIT 1];
            h.lv_location              = tmt12.Production_Location__c;
            h.lv_date_code_rpt_factory = tmt12.Factory__c;
            h.lv_date_code_cold_storage = tmt12.COLD_STORAGE__c;
            if(h.second_char=='X'||h.second_char=='Y'||h.second_char=='Z') { h.lv_shift = h.second_char; }
            h.cigar7position = h.traceCode.substring(6,7);
            h.cigar8position = h.traceCode.substring(7,8);
            if(h.third_number.isNumeric()) {
                h.lv_unit = h.third_number;
            } else {
                if(h.cigar7position == 'P' && h.cigar8position.isNumeric()) { h.lv_unit = h.third_number; }
            }
            TraceCodeHelper tch12 = new TraceCodeHelper();
            h.production_date = tch12.ProductDateCalculator(h.traceCode, h.ProductLineCode.toUpperCase());
        }
        else if(h.traceCode.length() == 9) {
            h.first_char    = h.traceCode.subString(0,1);
            h.first_number  = h.traceCode.subString(1,4);
            h.second_char   = h.traceCode.subString(4,5);
            h.second_number = h.traceCode.subString(5,6);
            h.third_number  = h.traceCode.subString(6,7);
            h.third_char    = h.traceCode.subString(7,8);
            h.fourth_number = h.traceCode.subString(8,9);
            Integer codeLen9 = h.traceCode.length();
            String p1c9 = h.first_char;
            String plc9 = h.ProductLineCode;
            Tracecode_Matrix_Table__c tmt9 = [SELECT Production_Location__c, Factory__c, COLD_STORAGE__c
                                              FROM Tracecode_Matrix_Table__c
                                              WHERE Character_Length__c =: codeLen9
                                              AND Position_1__c =: p1c9
                                              AND Product_Line_Code__c =: plc9
                                              ORDER BY CreatedDate DESC LIMIT 1];
            h.lv_location              = tmt9.Production_Location__c;
            h.lv_date_code_rpt_factory = tmt9.Factory__c;
            h.lv_date_code_cold_storage = tmt9.COLD_STORAGE__c;
            h.lv_shift = h.second_char;
            h.lv_unit  = h.third_number + h.third_char + h.fourth_number;
            TraceCodeHelper tch9 = new TraceCodeHelper();
            h.production_date = tch9.ProductDateCalculator(h.traceCode, h.ProductLineCode.toUpperCase());
        }
        else if(h.traceCode.length() == 1) {
            h.first_char = h.traceCode.subString(0,1);
            if(h.first_char=='L'||h.first_char=='P') {
                h.lv_location = 'Pennsylvania'; h.lv_date_code_rpt_factory = 'LIMERICK';
            } else if(h.first_char=='D'||h.first_char=='X') {
                h.lv_location = 'Dominican Republic'; h.lv_date_code_rpt_factory = '3RD PARTY MANUFACTURER';
            } else if(h.first_char=='V') {
                h.lv_location = 'Virginia'; h.lv_date_code_rpt_factory = 'MC_JMC';
            }
        }
    }

    // ---------------------------------------------------------------
    // PT (Pipe Tobacco) product line logic extracted from DateCodeHelper
    // ---------------------------------------------------------------
    public static void processPT(DateCodeHelper h) {
        if(h.traceCode.length() == 4) {
            String chk1 = h.traceCode.toUpperCase().subString(0,1);
            String chk2 = h.traceCode.toUpperCase().subString(1,2);
            String chk3 = h.traceCode.toUpperCase().subString(2,3);
            String chk4 = h.traceCode.toUpperCase().subString(3,4);
            if(!chk1.isNumeric() && !chk2.isNumeric() && !chk3.isNumeric() && !chk4.isNumeric()) {
                h.PTtraceCode4nonNumeric(h.traceCode);
            } else {
                h.PTtraceCode4Numeric(h.traceCode);
            }
        }
        else if(h.traceCode.length() == 6) {
            h.first_char    = h.traceCode.subString(0,1);
            h.second_number = h.traceCode.subString(1,4);
            String fifth_n  = h.traceCode.subString(4,5);
            String sixth_n  = h.traceCode.subString(5,6);
            if(!h.second_number.isNumeric() || !fifth_n.isNumeric() || !sixth_n.isNumeric()) { h.production_date = 'fail'; }
            if(Integer.valueOf(h.second_number) <= 0 || Integer.valueOf(h.second_number) > 366) { h.production_date = 'fail'; }
            if(h.first_char=='L'||h.first_char=='J'||h.first_char=='P'||h.first_char=='W') {
                if(h.first_char=='L')      { h.lv_location='LIMERICK'; h.lv_date_code_rpt_factory='LIMERICK'; h.lv_date_code_cold_storage='N'; }
                else if(h.first_char=='J') { h.lv_location='LIMERICK'; h.lv_date_code_rpt_factory='LIMERICK'; h.lv_date_code_cold_storage='Y'; }
                else if(h.first_char=='P') { h.lv_location='COLONIAL HEIGHTS'; h.lv_date_code_rpt_factory='PRECON_JMC'; h.lv_date_code_cold_storage='N'; }
                else if(h.first_char=='W') { h.lv_location='COLONIAL HEIGHTS'; h.lv_date_code_rpt_factory='PRECON_JMC'; h.lv_date_code_cold_storage='Y'; }
                h.lv_unit = sixth_n;
                String lvc6 = String.valueOf(System.today().year());
                Integer lvc6_4th = Integer.valueOf(lvc6.subString(3,4));
                Integer prodDate6;
                if(lvc6_4th == Integer.valueOf(fifth_n)) { prodDate6 = Integer.valueOf(lvc6); }
                else if(lvc6_4th < Integer.valueOf(fifth_n)) { prodDate6 = (Integer.valueOf(lvc6)-10) + (Integer.valueOf(fifth_n)-lvc6_4th); }
                else { prodDate6 = (Integer.valueOf(lvc6)-lvc6_4th) + Integer.valueOf(fifth_n); }
                h.lv_leap_year = '20';
                h.lv_year1 = '01/01' + h.lv_year1 + String.valueOf(prodDate6).substring(2,4);
                h.lv_leap_year = h.lv_leap_year + String.valueOf(prodDate6).substring(2,4);
                Date dt6 = Date.parse('02/01/' + String.valueOf(h.lv_leap_year)).addMonths(1);
                h.ln_leap = String.valueOf(dt6.addDays(-dt6.day()).day());
                if(Integer.valueOf(h.ln_leap) == 29) {
                    h.production_date = date.parse(h.lv_year1).addDays(Integer.valueOf(h.second_number)-1).format();
                } else {
                    h.production_date = date.parse(h.lv_year1).addDays(Integer.valueOf(h.second_number)-1).format();
                }
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) { h.production_date = 'fail'; }
            } else {
                h.production_date = 'fail';
            }
        }
        else if(h.traceCode.length() == 2) {
            h.first_char  = h.traceCode.toUpperCase().substring(1,2);
            h.second_char = h.traceCode.toUpperCase().substring(0,1);
            h.charSet.clear();
            h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H','E','R'});
            if(!h.charSet.contains(h.second_char)) { h.production_date = 'FAIL'; }
            h.charSet.clear();
            h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
            if(!h.charSet.contains(h.first_char)) { h.production_date = 'FAIL'; }
            h.lv_day  = '1';
            h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
            h.lv_year2 = h.first_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');
            if(Integer.valueOf(h.lv_day) > 31)  { h.production_date = 'FAIL'; }
            if(Integer.valueOf(h.lv_month) > 12) { h.production_date = 'FAIL'; }
            if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.substring(1,2))) {
                h.lv_year2 = h.lv_cur_year.substring(2,3) + h.lv_year2.substring(1,2);
            }
            h.year_leep = h.lv_year1.substring(1,3) + String.valueOf(h.lv_year2);
            if(Date.parse(String.valueOf(h.year_leep) + '0228').addDays(1).Month() == 2) {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { h.production_date = 'FAIL'; }
            } else if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) {
                h.production_date = 'FAIL';
            }
            h.intSet.clear(); h.intSet.add(4); h.intSet.add(6); h.intSet.add(9); h.intSet.add(11);
            if(h.intSet.contains(Integer.valueOf(h.lv_month)) && Integer.valueOf(h.lv_day)>=31) { h.production_date = 'FAIL'; }
            if(h.production_date != 'FAIL') {
                h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
            }
            h.ln_days = Date.parse(h.production_date).daysBetween(System.today());
            if(h.ln_days <= 0) { h.production_date = 'FAIL'; }
            h.lv_unit = '';
            h.lv_location = 'Limerick';
            h.lv_date_code_rpt_factory = 'Limerick';
        }
        else if(h.traceCode.length() == 7) {
            if(h.traceCode.substring(0,1) == 'J') { h.lv_date_code_cold_storage = 'Y'; } else { h.lv_date_code_cold_storage = 'N'; }
            h.lv_shift = h.traceCode.substring(4,5);
            if(h.traceCode.substring(6,7) == 'M' && h.traceCode.length() == 7) { h.lv_unit = 'M'; } else { h.lv_unit = h.traceCode.substring(6,7); }
            h.first_char  = h.traceCode.subString(1,3);
            h.second_char = h.traceCode.subString(3,4);
            h.third_char  = h.traceCode.subString(5,6);
            h.charSet.clear();
            h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
            if(!h.charSet.contains(h.first_char.substring(0,1))) { h.production_date = 'FAIL'; }
            h.charSet.clear();
            h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
            if(!h.charSet.contains(h.first_char.substring(1,2))) { h.production_date = 'FAIL'; }
            h.charSet.clear();
            h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H','E','R'});
            if(!h.charSet.contains(h.second_char)) { h.production_date = 'FAIL'; }
            h.charSet.clear();
            h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
            if(!h.charSet.contains(h.third_char)) { h.production_date = 'FAIL'; }
            h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
            h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
            h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');
            if(Integer.valueOf(h.lv_day) > 31)  { h.production_date = 'FAIL'; }
            if(Integer.valueOf(h.lv_month) > 12) { h.production_date = 'FAIL'; }
            if(Integer.valueOf(h.lv_cur_year) >= (Integer.valueOf('201' + h.lv_year2.substring(1,2)))) {
                h.lv_year2 = h.lv_cur_year.substring(2,3) + h.lv_year2.substring(1,2);
            } else {
                h.lv_year2 = h.lv_year.substring(2,3) + h.lv_year2.substring(1,2);
            }
            h.year_leep = h.lv_year1.subString(1,3) + String.valueOf(h.lv_year2);
            if(Date.parse(('02/28/' + String.valueOf(h.year_leep))).addDays(1).month() == 2) {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { h.production_date = 'fail'; }
            } else if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) {
                h.production_date = 'fail';
            }
            if(Integer.valueOf(h.lv_month)==4||Integer.valueOf(h.lv_month)==6||Integer.valueOf(h.lv_month)==9||Integer.valueOf(h.lv_month)==11) {
                if(Integer.valueOf(h.lv_day)>=31) { h.production_date = 'fail'; }
            }
            if(h.production_date != 'fail') {
                h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
            }
            if(h.ln_days <= 0) { h.production_date = 'FAIL'; }
            h.lv_location = 'Limerick';
            h.lv_date_code_rpt_factory = 'Limerick';
        }
        else if(h.traceCode.length() == 12) {
            h.first_char = h.traceCode.substring(0,1);
            String fifth_c  = h.traceCode.substring(4,5);
            String mod_c    = h.traceCode.substring(6,8);
            String mil_hr   = h.traceCode.substring(8,10);
            String mil_min  = h.traceCode.substring(10,12);
            TraceCodeHelper tch_pt12 = new TraceCodeHelper();
            h.production_date = tch_pt12.ProductDateCalculator(h.traceCode, h.ProductLineCode.toUpperCase());
            h.lv_location = 'Dominican Republic';
            h.lv_date_code_rpt_factory = '3RD PARTY MANUFACTURER';
            List<String> firstYes = new List<String>{'S','O','K'};
            List<String> firstNo  = new List<String>{'X','H','M'};
            if(firstYes.contains(h.first_char)) { h.lv_date_code_cold_storage = 'Y'; }
            else if(firstNo.contains(h.first_char)) { h.lv_date_code_cold_storage = 'N'; }
            if(fifth_c=='X'||fifth_c=='Y'||fifth_c=='Z') { h.lv_shift = fifth_c; }
            if(mod_c.isNumeric()) { h.lv_unit = mod_c; }
            if(mil_hr.isNumeric() && mil_min.isNumeric()) {
                if(Integer.valueOf(mil_hr) < 24 && Integer.valueOf(mil_min) < 60) { h.lv_military_time = mil_hr + mil_min; }
            }
        }
        else {
            h.first_char  = h.traceCode.subString(2,4);
            h.second_char = h.traceCode.subString(0,1);
            h.third_char  = h.traceCode.subString(1,2);
            h.first_number = h.traceCode.subString(4,5);
            if(h.first_number.isNumeric()) {
                if(Integer.valueOf(h.first_number)<1||Integer.valueOf(h.first_number)>4) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A'});
                if(!h.charSet.contains(h.first_char.substring(0,1))) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
                if(!h.charSet.contains(h.first_char.substring(1,2))) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H','E','R'});
                if(!h.charSet.contains(h.second_char)) { h.production_date = 'FAIL'; }
                h.charSet.clear();
                h.charSet.addAll(new List<String>{'B','L','A','C','K','S','M','I','T','H'});
                if(!h.charSet.contains(h.third_char)) { h.production_date = 'FAIL'; }
                h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
                h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
                h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');
                if(Integer.valueOf(h.lv_day) > 31)  { h.production_date = 'FAIL'; }
                if(Integer.valueOf(h.lv_month) > 12) { h.production_date = 'FAIL'; }
                if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.substring(1,2))) {
                    h.lv_year2 = h.lv_cur_year.substring(2,3) + h.lv_year2.substring(1,2);
                } else {
                    h.lv_year2 = h.lv_year.substring(2,3) + h.lv_year2.substring(1,2);
                }
                h.year_leep = h.lv_year1.substring(1,3) + String.valueOf(h.lv_year2);
                if(Date.parse(('02/28/' + String.valueOf(h.year_leep))).addDays(1).month() == 2) {
                    if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { h.production_date = 'FAIL'; }
                } else if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) {
                    h.production_date = 'FAIL';
                }
                h.intSet.clear(); h.intSet.add(4); h.intSet.add(6); h.intSet.add(9); h.intSet.add(11);
                if(h.intSet.contains(Integer.valueOf(h.lv_month)) && Integer.valueOf(h.lv_day)>=31) { h.production_date = 'FAIL'; }
                if(h.production_date != 'FAIL') {
                    h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
                }
                h.ln_days = Date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) { h.production_date = 'FAIL'; }
                h.lv_unit = h.first_number;
                h.lv_location = 'Limerick';
                h.lv_date_code_rpt_factory = 'Limerick';
            }
        }
    }

    // ---------------------------------------------------------------
    // EC (E-Cigarettes) product line logic extracted from DateCodeHelper
    // ---------------------------------------------------------------
    public static void processEC(DateCodeHelper h) {
        if(h.traceCode.length() == 8) {
            h.ln_lasttwodigit_year = Integer.valueOf(String.valueOf(System.today().year()).substring(2,4));
            h.first_char    = h.traceCode.subString(0,1);
            h.first_number  = h.traceCode.subString(1,3);
            h.second_char   = h.traceCode.subString(5,6);
            h.second_number = h.traceCode.subString(3,5);
            h.third_number  = h.traceCode.subString(6,8);
            if(!h.first_number.isNumeric() || !h.second_number.isNumeric()) { h.production_date = 'FAIL'; }
            if((h.first_char=='A'||h.first_char=='X'||h.first_char=='B'||h.first_char=='C'||h.first_char=='D'||h.first_char=='S')
               && (h.second_char=='A'||h.second_char=='B'||h.second_char=='C')
               && Integer.valueOf(h.first_number)>=0 && Integer.valueOf(h.first_number)<=99
               && Integer.valueOf(h.second_number)>=0 && Integer.valueOf(h.second_number)<=99) {
                if(Integer.valueOf(h.second_number) <= Integer.valueOf(h.ln_lasttwodigit_year)) {
                    h.lv_year = h.lv_year_new1.substring(0,2) + h.second_number.substring(0,2);
                } else {
                    h.lv_year = '19' + h.second_number.subString(0,2);
                }
                h.production_date = h.mondayDate(h.lv_year, h.first_number);
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) {
                    h.production_date = 'FAIL';
                } else {
                    h.lv_unit = h.third_number;
                    if(h.first_char=='A')      { h.lv_location='New2';   h.lv_date_code_rpt_factory='New2'; }
                    else if(h.first_char=='B') { h.lv_location='New3';   h.lv_date_code_rpt_factory='New3'; }
                    else if(h.first_char=='C') { h.lv_location='New4';   h.lv_date_code_rpt_factory='New4'; }
                    else if(h.first_char=='D') { h.lv_location='New5';   h.lv_date_code_rpt_factory='New5'; }
                    else if(h.first_char=='X') { h.lv_location='Existing 4'; h.lv_date_code_rpt_factory='Existing 4'; }
                    h.lv_shift = h.second_char;
                }
            } else {
                h.production_date = 'FAIL';
            }
        }
        if(h.traceCode.length() == 7) {
            h.ln_lasttwodigit_year = Integer.valueOf(String.valueOf(System.today().year()).substring(2,4));
            h.first_char    = h.traceCode.substring(0,1);
            h.second_char   = h.traceCode.substring(1,2);
            h.first_number  = h.traceCode.substring(2,4);
            h.second_number = h.traceCode.substring(4,6);
            h.third_number  = h.traceCode.substring(6,7);
            h.fiscal_week   = h.first_number + h.second_number;
            if(!h.first_number.isNumeric() || !h.second_number.isNumeric()) { h.production_date = 'FAIL'; }
            if(h.first_char.isAlphaNumeric() && (h.second_char=='A'||h.second_char=='B'||h.second_char=='C'||h.second_char=='D'||h.second_char=='X'||h.second_char=='S'||h.second_char=='G'||h.second_char=='J')
               && Integer.valueOf(h.first_number)>=0 && Integer.valueOf(h.first_number)<=52
               && Integer.valueOf(h.second_number)>=0 && Integer.valueOf(h.second_number)<=99
               && h.third_number.isAlphaNumeric()) {
                if(Integer.valueOf(h.second_number) <= Integer.valueOf(h.ln_lasttwodigit_year)) {
                    h.lv_year = h.lv_year_new1.substring(0,2) + h.second_number.substring(0,2);
                } else {
                    h.lv_year = '19' + h.second_number.substring(0,2);
                }
                String fwLocal7 = h.fiscal_week;
                if(fwLocal7 != '' || fwLocal7 != null) {
                    h.fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fwLocal7 limit 1];
                    if(h.fw != null) { h.production_date = h.fw.PRODUCTION_DATE__c; }
                }
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) {
                    h.production_date = 'FAIL';
                } else {
                    if(h.second_char=='A')      { h.lv_location='China'; h.lv_date_code_rpt_factory='New 2';  h.lv_unit=''; }
                    else if(h.second_char=='B') { h.lv_location='China'; h.lv_date_code_rpt_factory='New 3';  h.lv_unit=''; }
                    else if(h.second_char=='C') { h.lv_location='China'; h.lv_date_code_rpt_factory='New 4';  h.lv_unit=''; }
                    else if(h.second_char=='D') { h.lv_location='China'; h.lv_date_code_rpt_factory='New 5';  h.lv_unit=''; }
                    else if(h.second_char=='S') { h.lv_location='China'; h.lv_date_code_rpt_factory='SMOORE SONGGANG 3'; h.lv_unit=''; }
                    else if(h.second_char=='X') { h.lv_location='China'; h.lv_date_code_rpt_factory='Existing 4'; h.lv_unit=''; }
                    else if(h.second_char=='G') { h.lv_location='China'; h.lv_date_code_rpt_factory='Smaco Dongguan 3'; h.lv_unit=''; }
                    else if(h.second_char=='J') { h.lv_location='Virginia'; h.lv_date_code_rpt_factory='Manufacturing Center Bay 9'; h.lv_unit='Bay 9'; }
                    h.lv_shift = h.third_number;
                }
            } else {
                h.production_date = 'FAIL';
            }
        }
        if(h.traceCode.length() == 6) {
            h.ln_lasttwodigit_year = Integer.valueOf(String.valueOf(System.today().year()).substring(2,4));
            h.first_char    = h.traceCode.subString(0,1);
            h.first_number  = h.traceCode.subString(1,3);
            h.second_char   = h.traceCode.subString(3,4);
            h.second_number = h.traceCode.subString(4,6);
            h.fiscal_week   = h.first_number + h.second_number;
            if(!h.first_number.isNumeric() || !h.second_number.isNumeric()) { h.production_date = 'FAIL'; }
            if(h.first_char.isAlphaNumeric()
               && Integer.valueOf(h.first_number)>=1 && Integer.valueOf(h.first_number)<=53
               && Integer.valueOf(h.second_number)>=14) {
                if(Integer.valueOf(h.second_number) <= Integer.valueOf(h.ln_lasttwodigit_year)) {
                    h.lv_year = h.lv_year_new1.substring(0,2) + h.second_number.substring(0,2);
                } else {
                    h.lv_year = '19' + h.second_number.substring(0,2);
                }
                String fwLocal6 = h.fiscal_week;
                if(fwLocal6 != '' || fwLocal6 != null) {
                    h.fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fwLocal6 limit 1];
                    if(h.fw != null) { h.production_date = h.fw.PRODUCTION_DATE__c; }
                }
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) {
                    h.production_date = 'FAIL';
                } else {
                    if(h.first_char=='A')      { h.lv_location='New2';  h.lv_date_code_rpt_factory='New2'; }
                    else if(h.first_char=='B') { h.lv_location='New3';  h.lv_date_code_rpt_factory='New3'; }
                    else if(h.first_char=='C') { h.lv_location='New4';  h.lv_date_code_rpt_factory='New4'; }
                    else if(h.first_char=='D') { h.lv_location='New5';  h.lv_date_code_rpt_factory='New5'; }
                    else if(h.first_char=='G') { h.lv_location='Smaco Dongguan 3'; h.lv_date_code_rpt_factory='Smaco Dongguan 3'; }
                    else if(h.first_char=='S') { h.lv_location='Smaco Songgang 3'; h.lv_date_code_rpt_factory='Smoore Songgang 3'; }
                    else if(h.first_char=='X') { h.lv_location='Existing 4'; h.lv_date_code_rpt_factory='Existing 4'; }
                    h.lv_shift = h.second_char;
                }
            } else {
                h.production_date = 'FAIL';
            }
        }
        else if(h.traceCode.length() == 11) {
            h.ln_lasttwodigit_year = Integer.valueOf(String.valueOf(System.today().year()).substring(2,4));
            h.first_char    = h.traceCode.subString(0,1);
            h.first_number  = h.traceCode.subString(1,6);
            h.second_number = h.traceCode.subString(6,8);
            h.second_char   = h.traceCode.subString(8,9);
            h.third_number  = h.traceCode.subString(9,11);
            h.fiscal_week   = h.second_number + h.third_number;
            if(!h.first_number.isNumeric() || !h.second_number.isNumeric() || !h.third_number.isNumeric()) { h.production_date = 'FAIL'; }
            if(h.first_char.isAlphaNumeric()
               && Integer.valueOf(h.second_number)>=1 && Integer.valueOf(h.second_number)<=53
               && Integer.valueOf(h.third_number)>=14) {
                if(Integer.valueOf(h.third_number) <= Integer.valueOf(h.ln_lasttwodigit_year)) {
                    h.lv_year = h.lv_year_new1.substring(0,2) + h.third_number.substring(0,2);
                } else {
                    h.lv_year = '19' + h.third_number.substring(0,2);
                }
                String fwLocal11 = h.fiscal_week;
                if(fwLocal11 != '' || fwLocal11 != null) {
                    h.fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fwLocal11 limit 1];
                    if(h.fw != null) { h.production_date = h.fw.PRODUCTION_DATE__c; }
                }
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) {
                    h.production_date = 'FAIL';
                } else {
                    if(h.first_char=='A')      { h.lv_location='New2';  h.lv_date_code_rpt_factory='New2'; }
                    else if(h.first_char=='B') { h.lv_location='New3';  h.lv_date_code_rpt_factory='New3'; }
                    else if(h.first_char=='C') { h.lv_location='New4';  h.lv_date_code_rpt_factory='New4'; }
                    else if(h.first_char=='D') { h.lv_location='New5';  h.lv_date_code_rpt_factory='New5'; }
                    else if(h.first_char=='G') { h.lv_location='Smaco Dongguan 3'; h.lv_date_code_rpt_factory='Smaco Dongguan 3'; }
                    else if(h.first_char=='S') { h.lv_location='Smaco Songgang 3'; h.lv_date_code_rpt_factory='Smoore Songgang 3'; }
                    else if(h.first_char=='X') { h.lv_location='Existing 4'; h.lv_date_code_rpt_factory='Existing 4'; }
                    h.lv_shift = h.second_char;
                }
            } else {
                h.production_date = 'FAIL';
            }
        }
    }
}