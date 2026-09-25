@isTest
private class PLProductLineHelperTest {

    // ----------------------------------------------------------------
    // Day-restraints matrix verification for calculateProductionDate
    // Base prefix "UE2500000" = U (location) + E (module) + 2500000 (serial)
    // Char10='5' => 2025, Char11 => month, Char12 => day
    //
    // calculateProductionDate(traceCodeUpper, traceCodeOrig) takes the
    // uppercased code plus the original-case code (so lowercase 'd',
    // day 13, is preserved).
    // ----------------------------------------------------------------

    @isTest
    static void testCalculateProductionDate_31DayMonth_Day31_Valid() {
        // Char11='A'(Jan, 31-day month), Char12='0'(31) -> Date(2025,1,31)
        String code = 'UE25000005A0';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals(Date.newInstance(2025, 1, 31).format(), result);
    }

    @isTest
    static void testCalculateProductionDate_30DayMonth_Day31_Fails() {
        // Char11='D'(Apr, 30-day month), Char12='0'(31) -> Date(2025,4,31) is calendar-impossible
        String code = 'UE25000005D0';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    @isTest
    static void testCalculateProductionDate_Feb_Day28_Valid() {
        // Char11='B'(Feb), Char12='W'(28) -> Date(2025,2,28)
        String code = 'UE25000005BW';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals(Date.newInstance(2025, 2, 28).format(), result);
    }

    @isTest
    static void testCalculateProductionDate_Feb29_NonLeapYear_Fails() {
        // Char11='B'(Feb), Char12='X'(29), Char10='5'(2025, non-leap) -> calendar-impossible
        String code = 'UE25000005BX';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    @isTest
    static void testCalculateProductionDate_Feb30_Fails() {
        // Char11='B'(Feb), Char12='Y'(30) -> Date(2025,2,30) is calendar-impossible
        String code = 'UE25000005BY';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    @isTest
    static void testCalculateProductionDate_Feb31_Fails() {
        // Char11='B'(Feb), Char12='0'(31) -> Date(2025,2,31) is calendar-impossible
        String code = 'UE25000005B0';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    @isTest
    static void testCalculateProductionDate_LowercaseD_Day13_Valid() {
        // Char11='A'(Jan), Char12='d' (lowercase, day 13) -> Date(2025,1,13)
        String traceCodeOrig  = 'UE25000005Ad';
        String traceCodeUpper = traceCodeOrig.toUpperCase();
        String result = PLProductLineHelper.calculateProductionDate(traceCodeUpper, traceCodeOrig);
        System.assertEquals(Date.newInstance(2025, 1, 13).format(), result);
    }

    @isTest
    static void testCalculateProductionDate_UppercaseD_DayChar_Fails() {
        // Char12='D' (uppercase) is not present in the day mapping (only lowercase 'd' is)
        String code = 'UE25000005AD';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    // ----------------------------------------------------------------
    // calculateDateCode regression coverage
    // ----------------------------------------------------------------

    @isTest
    static void testCalculateDateCode_ValidCode_PopulatesFields() {
        String code = 'UE25000005A0';
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculateDateCode(code, code);
        System.assertEquals('INDONESIA', res.location);
        System.assertEquals('INDONESIA', res.factory);
        System.assertEquals('2500000', res.serialNumber);
        System.assertEquals('E', res.unit);
        System.assertEquals(Date.newInstance(2025, 1, 31).format(), res.productionDate);
    }

    @isTest
    static void testCalculateDateCode_InvalidCalendarDate_ReturnsFAIL() {
        // Char11='B'(Feb), Char12='Y'(30) -> calendar-impossible
        String code = 'UE25000005BY';
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculateDateCode(code, code);
        System.assertEquals('FAIL', res.productionDate);
    }

    // ================================================================
    // SCR 2026-07-07 - 9-character heatstick code
    //
    // Base fixture "R036V65B1":
    //   Char1='R'   cold stored, Virginia / MC_HORIZON
    //   Char2-4='036' Julian day 36 -> 05 February
    //   Char5='V'   hourly code -> shift Y, military time 2200
    //   Char6='6'   year digit -> 2026
    //   Char7-9='5B1' module 5B1, line "Line 5B", bay 5
    //
    // The year digit resolves against a rolling ten-year window, so '6' keeps
    // resolving to 2026 in every year from 2026 onward and this fixture stays
    // both on/after the 01/01/2026 floor and before the system date.
    // ================================================================

    private static final Date EXPECTED_9CHAR_DATE = Date.newInstance(2026, 2, 5);

    @isTest
    static void testCalculate9CharProductionDate_ValidR_ReturnsDate() {
        System.assertEquals(EXPECTED_9CHAR_DATE.format(),
            PLProductLineHelper.calculate9CharProductionDate('R036V65B1'));
    }

    @isTest
    static void testCalculate9CharProductionDate_LowercaseInput_ReturnsDate() {
        // 9-character codes have no case-sensitive position, so lower case is accepted
        System.assertEquals(EXPECTED_9CHAR_DATE.format(),
            PLProductLineHelper.calculate9CharProductionDate('r036v65b1'));
    }

    @isTest
    static void testCalculate9CharDateCode_R_5B1_PopulatesFields() {
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculate9CharDateCode('R036V65B1');
        System.assertEquals('Virginia',   res.location);
        System.assertEquals('MC_HORIZON', res.factory);
        System.assertEquals(EXPECTED_9CHAR_DATE.format(), res.productionDate);
        System.assertEquals('Y',       res.coldStorage);   // Char1 'R' -> cold stored
        System.assertEquals('5B1',     res.unit);
        //System.assertEquals('Line 5B', res.line);
        System.assertEquals('5',       res.bay);
        System.assertEquals('Y',       res.shift);         // Char5 'V'
        System.assertEquals('2200',    res.militaryTime);
    }

    @isTest
    static void testCalculate9CharDateCode_V_5C1_PopulatesFields() {
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculate9CharDateCode('V036A65C1');
        System.assertEquals('Virginia',   res.location);
        System.assertEquals('MC_HORIZON', res.factory);
        System.assertEquals(EXPECTED_9CHAR_DATE.format(), res.productionDate);
        System.assertEquals('N',       res.coldStorage);   // Char1 'V' -> not cold stored
        System.assertEquals('5C1',     res.unit);
        //System.assertEquals('Line 5C', res.line);
        System.assertEquals('5',       res.bay);
        System.assertEquals('Z',       res.shift);         // Char5 'A'
        System.assertEquals('0100',    res.militaryTime);
    }

    // ---- Char5: PMUSA hourly code mapping ----

    @isTest
    static void testCalculate9CharDateCode_HourlyCodeMapping() {
        Map<String, String> expectedShift = new Map<String, String>{
            'W' => 'Z', 'Z' => 'Z', 'A' => 'Z', 'G' => 'X', 'O' => 'Y', 'V' => 'Y'
        };
        Map<String, String> expectedTime = new Map<String, String>{
            'W' => '2300', 'Z' => '0000', 'A' => '0100', 'G' => '0700', 'O' => '1500', 'V' => '2200'
        };

        for (String hourly : expectedShift.keySet()) {
            PLProductLineHelper.PLResult res =
                PLProductLineHelper.calculate9CharDateCode('R036' + hourly + '65B1');
            System.assertEquals(EXPECTED_9CHAR_DATE.format(), res.productionDate,
                'Char5 ' + hourly + ' must not affect the production date');
            System.assertEquals(expectedShift.get(hourly), res.shift, 'shift for Char5 ' + hourly);
            System.assertEquals(expectedTime.get(hourly), res.militaryTime, 'military time for Char5 ' + hourly);
        }
    }

    @isTest
    static void testCalculate9CharDateCode_UnmappedHourlyCode_StillValid() {
        // 'X', 'Y' and digits carry no shift / military time in the PMUSA mapping,
        // but the SCR treats every alphanumeric Char5 as valid.
        for (String hourly : new List<String>{ 'X', 'Y', '1' }) {
            PLProductLineHelper.PLResult res =
                PLProductLineHelper.calculate9CharDateCode('R036' + hourly + '65B1');
            System.assertEquals(EXPECTED_9CHAR_DATE.format(), res.productionDate,
                'Char5 ' + hourly + ' must still produce a valid code');
            System.assert(String.isBlank(res.shift), 'shift must be blank for Char5 ' + hourly);
            System.assert(String.isBlank(res.militaryTime), 'military time must be blank for Char5 ' + hourly);
        }
    }

    // ---- Invalid 9-character codes ----

    @isTest
    static void testCalculate9CharProductionDate_InvalidPosition1_Fails() {
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('X036V65B1'));
    }

    @isTest
    static void testCalculate9CharProductionDate_InvalidJulianDay_Fails() {
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('R000V65B1'), 'Julian 000');
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('R367V65B1'), 'Julian 367');
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('RABCV65B1'), 'non-numeric Julian');
    }

    @isTest
    static void testCalculate9CharProductionDate_NonNumericYear_Fails() {
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('R036VX5B1'));
    }

    @isTest
    static void testCalculate9CharProductionDate_DateBefore2026_Fails() {
        // Year digit '5' resolves to 2025, which is before the 01/01/2026 floor
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('R036V55B1'));
    }

    @isTest
    static void testCalculate9CharProductionDate_FutureDate_Fails() {
        // Built from tomorrow so the code is always ahead of the system date
        Date future = System.today().addDays(1);
        Integer julianDay = Date.newInstance(future.year(), 1, 1).daysBetween(future) + 1;
        String code = 'R' + String.valueOf(julianDay).leftPad(3, '0')
                    + 'V' + String.valueOf(future.year()).substring(3, 4) + '5B1';
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate(code));
    }

    @isTest
    static void testCalculate9CharProductionDate_InvalidModule_Fails() {
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('R036V65D1'), '5D1');
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('R036V65B2'), '5B2');
    }

    @isTest
    static void testCalculate9CharProductionDate_NullAndWrongLength_Fail() {
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate(null));
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate(''));
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('R036V65B'));
        System.assertEquals('fail', PLProductLineHelper.calculate9CharProductionDate('R036V65B12'));
    }

    @isTest
    static void testCalculate9CharDateCode_Invalid_StillSetsLocationAndFactory() {
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculate9CharDateCode('X036V65B1');
        System.assertEquals('Virginia',   res.location, 'Location populates for invalid codes too');
        System.assertEquals('MC_HORIZON', res.factory,  'Factory populates for invalid codes too');
        System.assertEquals('FAIL', res.productionDate);
        System.assertEquals(null, res.unit);
        System.assertEquals(null, res.line);
        System.assertEquals(null, res.bay);
        System.assertEquals(null, res.coldStorage);
        System.assertEquals(null, res.shift);
        System.assertEquals(null, res.militaryTime);
    }

    // ================================================================
    // SCR 2026-07-07 - 1-character code
    // ================================================================

    @isTest
    static void testCalculate1CharProductionDate_ValidChars_ReturnNoDate() {
        System.assertEquals('NODATE', PLProductLineHelper.calculate1CharProductionDate('H'));
        System.assertEquals('NODATE', PLProductLineHelper.calculate1CharProductionDate('D'));
        System.assertEquals('NODATE', PLProductLineHelper.calculate1CharProductionDate('h'));
    }

    @isTest
    static void testCalculate1CharProductionDate_InvalidChars_Fail() {
        System.assertEquals('fail', PLProductLineHelper.calculate1CharProductionDate('X'));
        System.assertEquals('fail', PLProductLineHelper.calculate1CharProductionDate('1'));
        System.assertEquals('fail', PLProductLineHelper.calculate1CharProductionDate(null));
        System.assertEquals('fail', PLProductLineHelper.calculate1CharProductionDate(''));
        System.assertEquals('fail', PLProductLineHelper.calculate1CharProductionDate('HD'));
    }

    @isTest
    static void testCalculate1CharDateCode_H_Virginia() {
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculate1CharDateCode('H');
        System.assertEquals('Virginia',   res.location);
        System.assertEquals('MC_HORIZON', res.factory);
        System.assertEquals('NODATE',     res.productionDate);
    }

    @isTest
    static void testCalculate1CharDateCode_D_Indonesia() {
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculate1CharDateCode('D');
        System.assertEquals('INDONESIA', res.location);
        System.assertEquals('INDONESIA', res.factory);
        System.assertEquals('NODATE',    res.productionDate);
    }

    @isTest
    static void testCalculate1CharDateCode_InvalidChar_ReturnsFAIL() {
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculate1CharDateCode('X');
        System.assertEquals('FAIL', res.productionDate);
        // Location and Factory are derived from the character itself, so there is
        // nothing to default to when it is not one of the valid values.
        System.assertEquals(null, res.location);
        System.assertEquals(null, res.factory);
    }
}