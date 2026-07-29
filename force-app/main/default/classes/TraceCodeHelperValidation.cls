public class TraceCodeHelperValidation {

    // ---------------------------------------------------------------
    // GP (Cigars) validation logic extracted from TraceCodeHelper
    // ---------------------------------------------------------------
    public static String processGP(TraceCodeHelper h) {

        if(h.traceCode.length() == 7) {
            h.first_char    = h.traceCode.subString(5, 7);
            h.second_char   = h.traceCode.subString(2, 3);
            h.third_char    = h.traceCode.subString(3, 4);
            h.first_number  = h.traceCode.subString(0, 2);
            h.second_number = h.traceCode.subString(4, 5);
            Integer CHECK = 0;

            if(!h.first_number.subString(1,2).isNumeric() || !h.second_number.isNumeric()) {
                System.debug('========================================== 37');
                return 'fail';
            }
            if(h.first_number.subString(0,1) == 'X' || h.first_number.subString(0,1) == 'P') { CHECK = 1; }
            if(!h.first_number.subString(0).isNumeric() && CHECK != 1) {
                System.debug('========================================== 38');
                return 'fail';
            }
            if(!h.first_number.substring(1,2).isNumeric()) {
                System.debug('========================================== 39');
                return 'fail';
            }
            if(h.first_number.substring(0,1).isNumeric() && CHECK != 1) {
                if(Integer.valueOf(h.first_number.substring(1,2)) < 1 || Integer.valueOf(h.first_number.substring(1,2)) > 15 && CHECK != 1) {
                    System.debug('========================================== 40');
                    return 'fail';
                }
            }
            if(Integer.valueOf(h.second_number) < 1 || Integer.valueOf(h.second_number) > 3) {
                System.debug('========================================== 41');
                return 'fail';
            }
            if(h.first_char.subString(0,1)!='B'&&h.first_char.subString(0,1)!='L'&&h.first_char.subString(0,1)!='A'&&h.first_char.subString(0,1)!='C'&&h.first_char.subString(0,1)!='K'&&h.first_char.subString(0,1)!='S'&&h.first_char.subString(0,1)!='M'&&h.first_char.subString(0,1)!='I'&&h.first_char.subString(0,1)!='T'&&h.first_char.subString(0,1)!='H') {
                System.debug('========================================== 42'); return 'fail';
            }
            if(h.first_char.subString(1,2)!='B'&&h.first_char.subString(1,2)!='L'&&h.first_char.subString(1,2)!='A'&&h.first_char.subString(1,2)!='C'&&h.first_char.subString(1,2)!='K'&&h.first_char.subString(1,2)!='S'&&h.first_char.subString(1,2)!='M'&&h.first_char.subString(1,2)!='I'&&h.first_char.subString(1,2)!='T'&&h.first_char.subString(1,2)!='H') {
                System.debug('========================================== 43'); return 'fail';
            }
            if(h.second_char!='B'&&h.second_char!='L'&&h.second_char!='A'&&h.second_char!='C'&&h.second_char!='K'&&h.second_char!='S'&&h.second_char!='M'&&h.second_char!='I'&&h.second_char!='T'&&h.second_char!='H'&&h.second_char!='E'&&h.second_char!='R') {
                System.debug('========================================== 44'); return 'fail';
            }
            if(h.third_char!='B'&&h.third_char!='L'&&h.third_char!='A'&&h.third_char!='C'&&h.third_char!='K'&&h.third_char!='S'&&h.third_char!='M'&&h.third_char!='I'&&h.third_char!='T'&&h.third_char!='H') {
                System.debug('========================================== 45'); return 'fail';
            }

            h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
            h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
            h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');

            if(Integer.valueOf(h.lv_day) > 31)  { System.debug('========================================== 46'); return 'fail'; }
            if(Integer.valueOf(h.lv_month) > 12) { System.debug('========================================== 47'); return 'fail'; }
            if((Integer.valueOf(h.lv_month)==4||Integer.valueOf(h.lv_month)==6||Integer.valueOf(h.lv_month)==9||Integer.valueOf(h.lv_month)==11) && Integer.valueOf(h.lv_day)>=31) {
                System.debug('========================================== 48'); return 'fail';
            }

            if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                h.lv_year2 = h.lv_cur_year.subString(2,3) + h.lv_year2.subString(1,2);
                if(Integer.valueOf(h.lv_cur_year) == Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                    h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
                    try {
                        date dt = date.parse(h.production_date);
                        if(date.parse(h.production_date) >= System.today()) {
                            h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
                        }
                    } catch(Exception ex) {}
                }
            } else {
                h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
            }
            h.year_leep = h.lv_year1.subString(1,3) + String.valueOf(h.lv_year2);
            if(Date.parse('02/28/'+String.valueOf(h.year_leep)).addDays(1).Month() == 2) {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { return 'fail'; }
            } else {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) { System.debug('========================================== 49'); return 'fail'; }
            }
            if(h.production_date != 'fail') {
                h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
            }
            h.ln_days = date.parse(h.production_date).daysBetween(system.today());
            if(h.ln_days <= 0) { System.debug('========================================== 50'); return 'fail'; }
            else { System.debug('========================================== 51'); return h.production_date; }
        }
        else if(h.traceCode.length() == 5) {
            h.second_char   = h.traceCode.subString(0,1);
            h.third_char    = h.traceCode.subString(1,2);
            h.second_number = h.traceCode.subString(2,3);
            h.first_char    = h.traceCode.subString(3,5);
            if(!h.second_number.isNumeric()) { System.debug('========================================== 52'); return 'fail'; }
            if(Integer.valueOf(h.second_number)<1 || Integer.valueOf(h.second_number)>3) { System.debug('========================================== 53'); return 'fail'; }
            h.charSet.clear();
            h.charSet.add('B');h.charSet.add('L');h.charSet.add('A');h.charSet.add('C');h.charSet.add('K');h.charSet.add('S');h.charSet.add('M');h.charSet.add('I');h.charSet.add('T');h.charSet.add('H');
            if(!h.charSet.contains(h.first_char.subString(0,1))) { System.debug('========================================== 54'); return 'fail'; }
            if(!h.charSet.contains(h.first_char.subString(1,2))) { System.debug('========================================== 55'); return 'fail'; }
            h.charSet.add('E'); h.charSet.add('R');
            if(!h.charSet.contains(h.second_char)) { System.debug('========================================== 56'); return 'fail'; }
            h.charSet.remove('E'); h.charSet.remove('R');
            if(!h.charSet.contains(h.third_char)) { System.debug('========================================== 57'); return 'fail'; }
            h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
            h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
            h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');
            if(Integer.valueOf(h.lv_day) > 31) { System.debug('========================================== 58'); return 'fail'; }
            if(Integer.valueOf(h.lv_month) > 12) { System.debug('========================================== 59'); return 'fail'; }
            if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                h.lv_year2 = h.lv_cur_year.subString(2,3) + h.lv_year2.subString(1,2);
            } else {
                h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
            }
            h.year_leep = h.lv_year1.subString(1,3) + String.valueOf(h.lv_year2);
            if(date.parse(('02/28/'+String.valueOf(h.year_leep))).addDays(1).month() == 2) {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { System.debug('========================================== 60'); return 'fail'; }
            } else {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) { System.debug('========================================== 61'); return 'fail'; }
            }
            if((Integer.valueOf(h.lv_month)==4||Integer.valueOf(h.lv_month)==6||Integer.valueOf(h.lv_month)==9||Integer.valueOf(h.lv_month)==11) && Integer.valueOf(h.lv_day)>=31) {
                System.debug('========================================== 62'); return 'fail';
            }
            if(h.production_date != 'fail') {
                h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
            }
            h.ln_days = date.parse(h.production_date).daysBetween(System.today());
            if(h.ln_days <= 0) { System.debug('========================================== 63'); return 'fail'; }
            else { System.debug('========================================== 64'); return h.production_date; }
        }
        else if(h.traceCode.length() == 8) {
            h.first_char    = h.traceCode.subString(0,1);
            h.first_number  = h.traceCode.subString(1,4);
            h.second_char   = h.traceCode.subString(4,5);
            h.second_number = h.traceCode.subString(5,6);
            h.third_number  = h.traceCode.subString(6,8);
            h.cigar7position = h.traceCode.substring(6,7);
            if(!h.first_number.isNumeric() || !h.second_number.isNumeric() || (!h.third_number.isNumeric() && h.cigar7position != 'P')) {
                System.debug('========================================== 65');
                return 'fail';
            }
            if((h.first_char=='A'||h.first_char=='B'||h.first_char=='C'||h.first_char=='D'||h.first_char=='E'||h.first_char=='F'||h.first_char=='G'||h.first_char=='H'||h.first_char=='I'||h.first_char=='J'||h.first_char=='K'||h.first_char=='L'||h.first_char=='M'||h.first_char=='N'||h.first_char=='S'||h.first_char=='T'||h.first_char=='X'||h.first_char=='Z'||h.first_char=='R'||h.first_char=='V')
               && (h.second_char=='X'||h.second_char=='Y'||h.second_char=='Z')
               && Integer.valueOf(h.first_number)>=1 && Integer.valueOf(h.first_number)<=366
               && Integer.valueOf(h.second_number)>=0 && Integer.valueOf(h.second_number)<=9) {
                if(Integer.valueOf(h.second_number) == Integer.valueOf(h.ln_lastdigit_year)) {
                    h.lv_year = '01/01' + h.lv_year_new.subString(0,4) + h.second_number.subString(0,1);
                } else {
                    if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.second_number.subString(0,1))) {
                        h.lv_year = '01/01' + h.lv_year_new.subString(0,4) + h.second_number.subString(0,1);
                    } else {
                        h.lv_year = '01/01' + h.lv_year.subString(0,4) + h.second_number.subString(0,1);
                    }
                }
                h.lv_leap_year = '20';
                if(h.second_number.length() >= 2) {
                    h.lv_leap_year = h.lv_leap_year + h.second_number.subString(0,2);
                } else {
                    h.lv_leap_year = h.lv_leap_year + '0' + h.second_number;
                }
                Date dt8 = Date.parse('02/01/'+String.valueOf(h.lv_leap_year)).addMonths(1);
                h.ln_leap = String.valueOf(dt8.addDays(-dt8.day()).day());
                if(Integer.valueOf(h.ln_leap) == 28) {
                    if(Integer.valueOf(h.first_number) > 365) { System.debug('========================================== 66'); return 'fail'; }
                    else { h.production_date = date.parse(h.lv_year).addDays(Integer.valueOf(h.first_number)-1).format(); }
                } else {
                    h.production_date = date.parse(h.lv_year).addDays(Integer.valueOf(h.first_number)-1).format();
                }
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) { System.debug('========================================== 67'); return 'fail'; }
                else { System.debug('========================================== 68'); return h.production_date; }
            } else {
                System.debug('========================================== 69'); return 'fail';
            }
        }
        else if(h.traceCode.length() == 11) {
            if(String.isNotBlank(h.traceCode) && h.traceCode.isNumeric()) {
                return TraceCodeHelperSecondClass.NjoyTraceCode(h.traceCode);
            }
            h.first_char  = h.traceCode.subString(0,1);
            h.second_char = h.traceCode.substring(4,5).toUpperCase();
            String military_time11 = h.traceCode.substring(7,11);
            Integer codeLen11 = h.traceCode.length();
            String plc11 = h.productLineCode;
            List<Tracecode_Matrix_Table__c> tmt11 = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c
                                                     WHERE Character_Length__c =: codeLen11
                                                     AND Product_Line_Code__c =: plc11];
            List<String> lString11 = new List<String>();
            for(Tracecode_Matrix_Table__c st : tmt11) { lString11.add(st.Position_1__c); }
            if(!lString11.contains(h.first_char)) { System.debug('================== Cigar 11 characters fail -- Invalid First Character ==='); return 'fail'; }
            if(h.second_char!='X' && h.second_char!='Y' && h.second_char!='Z') { return 'fail'; }
            if(military_time11.isNumeric()) {
                if(Integer.valueOf(military_time11.substring(0,2)) > 23 || Integer.valueOf(military_time11.substring(2,4)) > 59) { return 'fail'; }
            } else { return 'fail'; }
            h.production_date = h.ProductDateCalculator(h.traceCode, h.productLineCode.toUpperCase());
            return h.production_date;
        }
        else if(h.traceCode.length() == 12) {
            h.first_char = h.traceCode.subString(0,1);
            Integer codeLen12 = h.traceCode.length();
            String plc12 = h.productLineCode;
            List<Tracecode_Matrix_Table__c> tmt12 = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c
                                                     WHERE Character_Length__c =: codeLen12
                                                     AND Product_Line_Code__c =: plc12];
            List<String> lString12 = new List<String>();
            for(Tracecode_Matrix_Table__c st : tmt12) { lString12.add(st.Position_1__c); }
            if(!lString12.contains(h.first_char)) { System.debug('================== Cigar 12 characters fail -- Invalid First Character ==='); return 'fail'; }
            h.production_date = h.ProductDateCalculator(h.traceCode, h.productLineCode.toUpperCase());
            return h.production_date;
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
            String plc9 = h.productLineCode;
            List<Tracecode_Matrix_Table__c> tmt9 = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c
                                                    WHERE Character_Length__c =: codeLen9
                                                    AND Product_Line_Code__c =: plc9];
            List<String> lString9 = new List<String>();
            for(Tracecode_Matrix_Table__c st : tmt9) { lString9.add(st.Position_1__c); }
            if(!h.first_number.isNumeric() || Integer.valueOf(h.first_number)>366 || Integer.valueOf(h.first_number)<1
               || (h.second_char!='X' && h.second_char!='Y' && h.second_char!='Z')
               || Integer.valueOf(h.second_number)>9 || !h.second_number.isNumeric()
               || Integer.valueOf(h.third_number)!=8 || h.third_char!='P'
               || !h.fourth_number.isNumeric() || Integer.valueOf(h.fourth_number)>9 || Integer.valueOf(h.fourth_number)==0
               || h.first_char.isNumeric() || !lString9.contains(h.first_char)) {
                System.debug('================== Cigar 9 characters fail'); return 'fail';
            }
            h.production_date = h.ProductDateCalculator(h.traceCode, h.productLineCode.toUpperCase());
            return h.production_date;
        }
        return null;
    }

    // ---------------------------------------------------------------
    // PT (Pipe Tobacco) validation logic extracted from TraceCodeHelper
    // ---------------------------------------------------------------
    public static String processPT(TraceCodeHelper h) {
        if(h.traceCode.length() == 4) {
            String chk1 = h.traceCode.subString(0,1);
            String chk2 = h.traceCode.subString(1,2);
            String chk3 = h.traceCode.subString(2,3);
            String chk4 = h.traceCode.subString(3,4);
            if(!chk1.isNumeric() && !chk2.isNumeric() && !chk3.isNumeric() && !chk4.isNumeric()) {
                h.first_char  = h.traceCode.subString(2,4);
                h.second_char = h.traceCode.subString(0,1);
                h.third_char  = h.traceCode.subString(1,2);
                h.charSet.clear();
                h.charSet.add('B');h.charSet.add('L');h.charSet.add('A');h.charSet.add('C');h.charSet.add('K');h.charSet.add('S');h.charSet.add('M');h.charSet.add('I');h.charSet.add('T');h.charSet.add('H');
                if(!h.charSet.contains(h.first_char.subString(0,1))) { System.debug('========================================== 75'); return 'fail'; }
                if(!h.charSet.contains(h.first_char.subString(1,2))) { System.debug('========================================== 76'); return 'fail'; }
                h.charSet.add('E'); h.charSet.add('R');
                if(!h.charSet.contains(h.second_char)) { System.debug('========================================== 77'); return 'fail'; }
                h.charSet.remove('E'); h.charSet.remove('R');
                if(!h.charSet.contains(h.third_char)) { System.debug('========================================== 78'); return 'fail'; }
                h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
                h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
                h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');
                if(Integer.valueOf(h.lv_day) > 31) { System.debug('========================================== 79'); return 'fail'; }
                if(Integer.valueOf(h.lv_month) > 12) { System.debug('========================================== 80'); return 'fail'; }
                if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                    h.lv_year2 = h.lv_cur_year.subString(2,3) + h.lv_year2.subString(1,2);
                } else {
                    h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
                }
                h.year_leep = h.lv_year1.subString(1,3) + String.valueOf(h.lv_year2);
                if(date.parse(('02/28/'+String.valueOf(h.year_leep))).addDays(1).month() == 2) {
                    if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { System.debug('========================================== 81'); return 'fail'; }
                } else {
                    if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) { System.debug('========================================== 82'); return 'fail'; }
                }
                if((Integer.valueOf(h.lv_month)==4||Integer.valueOf(h.lv_month)==6||Integer.valueOf(h.lv_month)==9||Integer.valueOf(h.lv_month)==11) && Integer.valueOf(h.lv_day)>=31) {
                    System.debug('========================================== 83'); return 'fail';
                }
                if(h.production_date != 'fail') {
                    h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
                }
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) { System.debug('========================================== 84'); return 'fail'; }
                else { System.debug('========================================== 85'); return h.production_date; }
            } else {
                h.first_char    = h.traceCode.subString(0,1);
                h.second_number = h.traceCode.subString(1,3);
                h.fourth_number = h.traceCode.subString(3,4);
                if(!h.second_number.isNumeric() || !h.fourth_number.isNumeric()) { return 'fail'; }
                if(Integer.valueOf(h.second_number)<0 || Integer.valueOf(h.second_number)>53) { return 'fail'; }
                if(h.first_char=='L'||h.first_char=='J'||h.first_char=='P'||h.first_char=='W') {
                    String lvc4 = String.valueOf(System.today().year());
                    Integer lvc4_4th = Integer.valueOf(lvc4.subString(3,4));
                    Integer prodDate4;
                    if(lvc4_4th == Integer.valueOf(h.fourth_number)) { prodDate4 = Integer.valueOf(lvc4); }
                    else if(lvc4_4th < Integer.valueOf(h.fourth_number)) { prodDate4 = (Integer.valueOf(lvc4)-10) + (Integer.valueOf(h.fourth_number)-lvc4_4th); }
                    else { prodDate4 = (Integer.valueOf(lvc4)-lvc4_4th) + Integer.valueOf(h.fourth_number); }
                    h.fiscal_week = h.second_number + String.valueOf(prodDate4).substring(2,4);
                    String fwLocal4 = h.fiscal_week;
                    if(fwLocal4 != '' || fwLocal4 != null) {
                        h.fw = [Select PRODUCTION_DATE__c, FISCAL_WEEK_YEAR__c from Financial_Week__c where FISCAL_WEEK_YEAR__c =: fwLocal4 limit 1];
                        if(h.fw != null) { h.production_date = h.fw.PRODUCTION_DATE__c; }
                    }
                    h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                    if(h.ln_days <= 0) { return 'fail'; }
                    else { return h.production_date; }
                } else { return 'fail'; }
            }
        }
        else if(h.traceCode.length() == 6) {
            h.first_char    = h.traceCode.subString(0,1);
            h.second_number = h.traceCode.subString(1,4);
            String fifth_n  = h.traceCode.subString(4,5);
            String sixth_n  = h.traceCode.subString(5,6);
            if(!h.second_number.isNumeric() || !fifth_n.isNumeric() || !sixth_n.isNumeric()) { return 'fail'; }
            if(Integer.valueOf(h.second_number)<=0 || Integer.valueOf(h.second_number)>366) { return 'fail'; }
            if(h.first_char=='L'||h.first_char=='J'||h.first_char=='P'||h.first_char=='W') {
                String lvc6 = String.valueOf(System.today().year());
                Integer lvc6_4th = Integer.valueOf(lvc6.subString(3,4));
                Integer prodDate6;
                if(lvc6_4th == Integer.valueOf(fifth_n)) { prodDate6 = Integer.valueOf(lvc6); }
                else if(lvc6_4th < Integer.valueOf(fifth_n)) { prodDate6 = (Integer.valueOf(lvc6)-10) + (Integer.valueOf(fifth_n)-lvc6_4th); }
                else { prodDate6 = (Integer.valueOf(lvc6)-lvc6_4th) + Integer.valueOf(fifth_n); }
                h.lv_leap_year = '20';
                h.lv_year1 = '01/01' + h.lv_year1 + String.valueOf(prodDate6).substring(2,4);
                h.lv_leap_year = h.lv_leap_year + String.valueOf(prodDate6).substring(2,4);
                Date dt6 = Date.parse('02/01/'+String.valueOf(h.lv_leap_year)).addMonths(1);
                h.ln_leap = String.valueOf(dt6.addDays(-dt6.day()).day());
                if(Integer.valueOf(h.ln_leap) == 29) {
                    h.production_date = date.parse(h.lv_year1).addDays(Integer.valueOf(h.second_number)-1).format();
                } else {
                    h.production_date = date.parse(h.lv_year1).addDays(Integer.valueOf(h.second_number)-1).format();
                }
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
                if(h.ln_days <= 0) { return 'fail'; }
                else { return h.production_date; }
            } else { return 'fail'; }
        }
        else if(h.traceCode.length() == 2) {
            h.first_char  = h.traceCode.subString(1,2);
            h.second_char = h.traceCode.subString(0,1);
            h.charSet.clear();
            h.charSet.add('B');h.charSet.add('L');h.charSet.add('A');h.charSet.add('C');h.charSet.add('K');h.charSet.add('S');h.charSet.add('M');h.charSet.add('I');h.charSet.add('T');h.charSet.add('H');
            if(!h.charSet.contains(h.first_char)) { System.debug('========================================== 86'); return 'fail'; }
            h.charSet.add('E'); h.charSet.add('R');
            if(!h.charSet.contains(h.second_char)) { System.debug('========================================== 87'); return 'fail'; }
            h.lv_day = '1';
            h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
            h.lv_year2 = h.first_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');
            if(Integer.valueOf(h.lv_month) > 12) { System.debug('========================================== 88'); return 'fail'; }
            if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                h.lv_year2 = h.lv_cur_year.subString(2,3) + h.lv_year2.subString(1,2);
            } else {
                h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
            }
            h.year_leep = h.lv_year1.subString(1,3) + String.valueOf(h.lv_year2);
            if(date.parse(('02/28/'+String.valueOf(h.year_leep))).addDays(1).month() == 2) {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { System.debug('========================================== 89'); return 'fail'; }
            } else {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) { System.debug('========================================== 90'); return 'fail'; }
            }
            if((Integer.valueOf(h.lv_month)==4||Integer.valueOf(h.lv_month)==6||Integer.valueOf(h.lv_month)==9||Integer.valueOf(h.lv_month)==11) && Integer.valueOf(h.lv_day)>=31) {
                System.debug('========================================== 91'); return 'fail';
            }
            if(h.production_date != 'fail') {
                h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
            }
            h.ln_days = date.parse(h.production_date).daysBetween(System.today());
            if(h.ln_days <= 0) { System.debug('========================================== 92'); return 'fail'; }
            else { System.debug('========================================== 93'); return h.production_date; }
        }
        else if(h.traceCode.length() == 7) {
            h.first_char  = h.traceCode.subString(1,3);
            h.second_char = h.traceCode.subString(3,4);
            h.third_char  = h.traceCode.subString(5,6);
            h.charSet.clear();
            h.charSet.add('B');h.charSet.add('L');h.charSet.add('A');h.charSet.add('C');h.charSet.add('K');h.charSet.add('S');h.charSet.add('M');h.charSet.add('I');h.charSet.add('T');h.charSet.add('H');
            if(!h.charSet.contains(h.first_char.subString(0,1))) { System.debug('========================================== 94'); return 'fail'; }
            if(!h.charSet.contains(h.first_char.subString(1,2))) { System.debug('========================================== 95'); return 'fail'; }
            h.charSet.add('E'); h.charSet.add('R');
            if(!h.charSet.contains(h.second_char)) { System.debug('========================================== 96'); return 'fail'; }
            h.charSet.remove('E'); h.charSet.remove('R');
            if(!h.charSet.contains(h.third_char)) { System.debug('========================================== 97'); return 'fail'; }
            h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
            h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
            h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');
            if(Integer.valueOf(h.lv_day) > 31)  { System.debug('========================================== 98'); return 'fail'; }
            if(Integer.valueOf(h.lv_month) > 12) { System.debug('========================================== 99'); return 'fail'; }
            if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                h.lv_year2 = h.lv_cur_year.subString(2,3) + h.lv_year2.subString(1,2);
            } else {
                h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
            }
            h.year_leep = h.lv_year1.subString(1,3) + String.valueOf(h.lv_year2);
            if(Date.parse(('02/28/'+String.valueOf(h.year_leep))).addDays(1).month() == 2) {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { System.debug('========================================== 100'); return 'fail'; }
            } else {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) { System.debug('========================================== 101'); return 'fail'; }
            }
            if((Integer.valueOf(h.lv_month)==4||Integer.valueOf(h.lv_month)==6||Integer.valueOf(h.lv_month)==9||Integer.valueOf(h.lv_month)==11) && Integer.valueOf(h.lv_day)>=31) {
                System.debug('========================================== 102'); return 'fail';
            }
            if(h.production_date != 'fail') {
                h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
                h.ln_days = date.parse(h.production_date).daysBetween(System.today());
            }
            if(h.ln_days <= 0) { System.debug('========================================== 103'); return 'fail'; }
            else { System.debug('========================================== 104'); return h.production_date; }
        }
        else if(h.traceCode.length() == 12) {
            h.first_char = h.traceCode.substring(0,1);
            String fifth_c  = h.traceCode.substring(4,5);
            String mod_c    = h.traceCode.substring(6,8);
            String mil_hr   = h.traceCode.substring(8,10);
            String mil_min  = h.traceCode.substring(10,12);
            List<String> firstCharPT = new List<String>{'S','O','K','X','H','M'};
            if(!firstCharPT.contains(h.first_char)) { return 'fail'; }
            List<String> fifthCharPT = new List<String>{'X','Y','Z'};
            if(!fifthCharPT.contains(fifth_c)) { return 'fail'; }
            if(!mod_c.isNumeric()) { return 'fail'; }
            if(mil_hr.isNumeric()) { if(Integer.valueOf(mil_hr) > 23) { return 'fail'; } } else { return 'fail'; }
            if(mil_min.isNumeric()) { if(Integer.valueOf(mil_min) > 59) { return 'fail'; } } else { return 'fail'; }
            h.production_date = h.ProductDateCalculator(h.traceCode, h.productLineCode.toUpperCase());
            return h.production_date;
        }
        else {
            h.first_char  = h.traceCode.subString(2,4);
            h.second_char = h.traceCode.subString(0,1);
            h.third_char  = h.traceCode.subString(1,2);
            h.first_number = h.traceCode.subString(4,5);
            if(!h.first_number.isNumeric()) { System.debug('========================================== 105'); return 'fail'; }
            if(Integer.valueOf(h.first_number)<1 || Integer.valueOf(h.first_number)>4) { System.debug('========================================== 106'); return 'fail'; }
            h.charSet.clear();
            h.charSet.add('B');h.charSet.add('L');h.charSet.add('A');h.charSet.add('C');h.charSet.add('K');h.charSet.add('S');h.charSet.add('M');h.charSet.add('I');h.charSet.add('T');h.charSet.add('H');
            if(!h.charSet.contains(h.first_char.subString(0,1))) { System.debug('========================================== 107'); return 'fail'; }
            if(!h.charSet.contains(h.first_char.subString(1,2))) { System.debug('========================================== 108'); return 'fail'; }
            h.charSet.add('E'); h.charSet.add('R');
            if(!h.charSet.contains(h.second_char)) { return 'fail'; }
            h.charSet.remove('E'); h.charSet.remove('R');
            if(!h.charSet.contains(h.third_char)) { System.debug('========================================== 109'); return 'fail'; }
            h.lv_day   = h.first_char.replace('B','1').replace('L','2').replace('A','3').replace('C','4').replace('K','5').replace('S','6').replace('M','7').replace('I','8').replace('T','9').replace('H','0');
            h.lv_month = h.second_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','10').replace('E','11').replace('R','12');
            h.lv_year2 = h.third_char.replace('B','01').replace('L','02').replace('A','03').replace('C','04').replace('K','05').replace('S','06').replace('M','07').replace('I','08').replace('T','09').replace('H','00');
            if(Integer.valueOf(h.lv_day) > 31)  { System.debug('========================================== 110'); return 'fail'; }
            if(Integer.valueOf(h.lv_month) > 12) { return 'fail'; }
            if(Integer.valueOf(h.lv_cur_year) >= Integer.valueOf('201' + h.lv_year2.subString(1,2))) {
                h.lv_year2 = h.lv_cur_year.subString(2,3) + h.lv_year2.subString(1,2);
            } else {
                h.lv_year2 = h.lv_year.subString(2,3) + h.lv_year2.subString(1,2);
            }
            h.year_leep = h.lv_year1.subString(1,3) + String.valueOf(h.lv_year2);
            if(Date.parse(('02/28/'+String.valueOf(h.year_leep))).addDays(1).month() == 2) {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=30) { System.debug('========================================== 111'); return 'fail'; }
            } else {
                if(Integer.valueOf(h.lv_month)==2 && Integer.valueOf(h.lv_day)>=29) { System.debug('========================================== 112'); return 'fail'; }
            }
            if((Integer.valueOf(h.lv_month)==4||Integer.valueOf(h.lv_month)==6||Integer.valueOf(h.lv_month)==9||Integer.valueOf(h.lv_month)==11) && Integer.valueOf(h.lv_day)>=31) {
                System.debug('========================================== 113'); return 'fail';
            }
            if(h.production_date != 'fail') {
                h.production_date = String.valueOf(h.lv_month)+'/'+String.valueOf(h.lv_day)+String.valueOf(h.lv_year1)+String.valueOf(h.lv_year2);
            }
            h.ln_days = date.parse(h.production_date).daysBetween(System.today());
            if(h.ln_days <= 0) { System.debug('========================================== 114'); return 'fail'; }
            return h.production_date;
        }
    }
}