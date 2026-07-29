@isTest
private class TraceCodeHelperCoreTest {

    // Last digit of the previous calendar year - used to build codes whose
    // derived production date is always in the past.
    private static String prevYearDigit() {
        return String.valueOf(Math.mod(System.today().year() - 1, 10));
    }

    // Last digit of the current calendar year - used to build codes whose
    // derived production date lands in the current year (so we can push the
    // julian/day value forward and land in the future).
    private static String curYearDigit() {
        return String.valueOf(Math.mod(System.today().year(), 10));
    }

    // Mirrors the SNP/TDNS 4-year-cycle logic in TraceCodeHelperCore so we can
    // dynamically pick the D/R/C/M character that resolves to the CURRENT
    // year, regardless of what year the tests actually run in.
    private static String currentCycleYearChar() {
        Integer currentYear = System.today().year();
        Integer baseYear = currentYear - 2020;
        List<String> pattern = new List<String>{'D', 'R', 'C', 'M'};
        Integer addYears = 0;
        if (baseYear > 3) {
            Integer cycles = baseYear / 4;
            addYears = cycles * 4;
            baseYear = currentYear - (2020 + addYears);
        }
        return pattern[baseYear];
    }

    // Mirrors the PT 10-year-cycle logic so we can dynamically pick the
    // digit that resolves to the CURRENT year.
    private static String ptCurrentYearDigit() {
        Integer currentYear = System.today().year();
        Integer baseYear = currentYear - 2020;
        Integer addYears = 0;
        if (baseYear > 9) {
            Integer cycles = baseYear / 10;
            addYears = cycles * 10;
        }
        Integer digit = currentYear - 2020 - addYears;
        return String.valueOf(digit);
    }

    // ---------------- ProductDateCalculator : IQ ----------------

    @isTest
    static void testProductDateCalculator_IQ_Valid() {
        String code = 'AAAA' + prevYearDigit() + '123' + '12';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'IQ');
        Test.stopTest();
        System.assertNotEquals('fail', result, 'A previous-year IQ code with a valid julian day must succeed');
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testProductDateCalculator_IQ_InvalidJulian() {
        String code = 'AAAA' + prevYearDigit() + '999' + '12';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'IQ');
        Test.stopTest();
        System.assertEquals('fail', result, 'Julian day 999 is invalid for IQ');
    }

    @isTest
    static void testProductDateCalculator_IQ_DaysFail() {
        // Use the CURRENT year's digit with a julian day far enough forward
        // that the derived production date is not yet in the past.
        String code = 'AAAA' + curYearDigit() + '360' + '12';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'IQ');
        Test.stopTest();
        System.assertEquals('fail', result, 'A derived production date that is not in the past must fail for IQ');
    }

    @isTest
    static void testProductDateCalculator_IQ_PriorDecadeBranch() {
        // Covers the branch where second_number represents a year later than
        // the current year's last digit, which rolls the calculation back to
        // the prior decade. Skips (rather than risks a false assertion) in
        // the rare case the test happens to run in a year ending in 9.
        Integer curDigit = Math.mod(System.today().year(), 10);
        if (curDigit == 9) {
            return;
        }
        String code = 'AAAA' + '9' + '050' + '12';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'IQ');
        Test.stopTest();
        System.assertNotEquals('fail', result, 'A second_number greater than the current digit rolls back a decade and must still succeed');
        System.assertNotEquals(null, result);
    }

    // ---------------- ProductDateCalculator : TDNP ----------------

    @isTest
    static void testProductDateCalculator_TDNP_SingleChar() {
        Test.startTest();
        String rM = TraceCodeHelperCore.ProductDateCalculator('M', 'TDNP');
        String rA = TraceCodeHelperCore.ProductDateCalculator('A', 'TDNP');
        Test.stopTest();
        System.assertEquals('NODATE', rM, 'Single character M returns NODATE');
        System.assertEquals(null, rA, 'Single character outside M/U/S returns null');
    }

    @isTest
    static void testProductDateCalculator_TDNP_SixChar() {
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator('CA1234', 'TDNP');
        Test.stopTest();
        System.assertEquals('01/01/2025', result, 'C=2025 and A=January must produce 01/01/2025');
    }

    @isTest
    static void testProductDateCalculator_TDNP_SevenChar() {
        Test.startTest();
        String valid       = TraceCodeHelperCore.ProductDateCalculator('WA00000', 'TDNP');
        String badFirst    = TraceCodeHelperCore.ProductDateCalculator('QA00000', 'TDNP');
        String badSecond   = TraceCodeHelperCore.ProductDateCalculator('W100000', 'TDNP');
        Test.stopTest();
        System.assertEquals(Date.newInstance(2019, 1, 1).format(), valid, 'W=2019 and A=January must produce Jan 1 2019');
        System.assertEquals(null, badFirst, 'Invalid first character returns null');
        System.assertEquals(null, badSecond, 'Numeric month character returns null');
        // NOTE: the "final_date >= dateToProcess" (future date) branch for the
        // 7-character TDNP path is not exercised here. Every mapped year
        // letter (W/U/X/Y/Z) resolves to a fixed year of 2019-2022, which will
        // always be in the past for any realistic test-run date, and
        // Label.Override_date cannot be reassigned from a test class. That
        // line is effectively unreachable without a code change (e.g. adding
        // future year letters to the map, or making the override date
        // injectable) and is left uncovered intentionally.
    }

    @isTest
    static void testProductDateCalculator_TDNP_NineAndTenChar() {
        Test.startTest();
        String valid9      = TraceCodeHelperCore.ProductDateCalculator('5123AB123', 'TDNP');
        String badFirst9   = TraceCodeHelperCore.ProductDateCalculator('Q123AB123', 'TDNP');
        String badJulian9  = TraceCodeHelperCore.ProductDateCalculator('5000AB123', 'TDNP');
        String valid10     = TraceCodeHelperCore.ProductDateCalculator('D123AB1234', 'TDNP');
        Test.stopTest();
        System.assertNotEquals(null, valid9, '5=2025 with julian 123 must produce a date');
        System.assertEquals(null, badFirst9, 'Unmapped year character returns null');
        System.assertEquals(null, badJulian9, 'Julian 000 is invalid');
        System.assertNotEquals(null, valid10, '10-character codes use the 9-character date logic');
    }

    @isTest
    static void testProductDateCalculator_TDNP_NineChar_FutureDate() {
        // '9' maps to year 2029 in the fixed year dictionary, which will be
        // in the future for the foreseeable lifetime of this test.
        String code = '9001ABCDE';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'TDNP');
        Test.stopTest();
        System.assertEquals(null, result, 'A derived production date in the future must return null');
    }

    @isTest
    static void testProductDateCalculator_TDNP_UnhandledLength() {
        // A trace code whose length matches none of the handled cases
        // (1, 6, 7, 9, 10) falls through every block and returns the
        // still-null productionDate variable.
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator('AB', 'TDNP');
        Test.stopTest();
        System.assertEquals(null, result, 'An unhandled trace code length must return null');
    }

    // ---------------- ProductDateCalculator : PT ----------------

    @isTest
    static void testProductDateCalculator_PT() {
        Test.startTest();
        String valid     = TraceCodeHelperCore.ProductDateCalculator('A123B5CDEFGH', 'PT');
        String badYear   = TraceCodeHelperCore.ProductDateCalculator('A123BXCDEFGH', 'PT');
        String badJulian = TraceCodeHelperCore.ProductDateCalculator('A999B5CDEFGH', 'PT');
        Test.stopTest();
        System.assertNotEquals(null, valid, 'Year digit 5 with julian 123 must produce a date');
        System.assertEquals(null, badYear, 'Non-numeric year character returns null');
        System.assertEquals(null, badJulian, 'Julian 999 is invalid');
    }

    @isTest
    static void testProductDateCalculator_PT_FutureDate() {
        // Dynamically pick the digit that resolves to the CURRENT year, then
        // push the julian day far enough forward to land in the future.
        String code = 'A300B' + ptCurrentYearDigit() + 'CDEFGH';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'PT');
        Test.stopTest();
        System.assertEquals(null, result, 'A derived production date in the future must return null for PT');
    }

    // ---------------- ProductDateCalculator : SNP / TDNS ----------------

    @isTest
    static void testProductDateCalculator_SNP() {
        Test.startTest();
        String validD   = TraceCodeHelperCore.ProductDateCalculator('D001AB123', 'SNP');
        String validM   = TraceCodeHelperCore.ProductDateCalculator('M001AB123', 'SNP');
        String invalid  = TraceCodeHelperCore.ProductDateCalculator('X001AB123', 'SNP');
        Test.stopTest();
        System.assertNotEquals(null, validD, 'D-cycle SNP code with julian 001 must produce a date');
        System.assertNotEquals(null, validM, 'M-cycle SNP code with julian 001 must produce a date');
        System.assertEquals(null, invalid, 'Unmapped first character returns null');
    }

    @isTest
    static void testProductDateCalculator_SNP_InvalidJulian() {
        String code = currentCycleYearChar() + '000' + 'AB123';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'SNP');
        Test.stopTest();
        System.assertEquals(null, result, 'Julian day 000 is invalid for SNP');
    }

    @isTest
    static void testProductDateCalculator_SNP_FutureDate() {
        String code = currentCycleYearChar() + '360' + 'AB123';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'SNP');
        Test.stopTest();
        System.assertEquals(null, result, 'A derived production date in the future must return null for SNP');
    }

    @isTest
    static void testProductDateCalculator_TDNS() {
        Test.startTest();
        String valid   = TraceCodeHelperCore.ProductDateCalculator('D001AB123', 'TDNS');
        String invalid = TraceCodeHelperCore.ProductDateCalculator('X001AB123', 'TDNS');
        Test.stopTest();
        System.assertNotEquals(null, valid, 'D-cycle TDNS code with julian 001 must produce a date');
        System.assertEquals(null, invalid, 'Unmapped first character returns null');
    }

    @isTest
    static void testProductDateCalculator_TDNS_InvalidJulian() {
        String code = currentCycleYearChar() + '000' + 'AB123';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'TDNS');
        Test.stopTest();
        System.assertEquals(null, result, 'Julian day 000 is invalid for TDNS');
    }

    @isTest
    static void testProductDateCalculator_TDNS_FutureDate() {
        String code = currentCycleYearChar() + '360' + 'AB123';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'TDNS');
        Test.stopTest();
        System.assertEquals(null, result, 'A derived production date in the future must return null for TDNS');
    }

    // NOTE: SNP and TDNS both contain a secondary "firstChar is not valid"
    // check that is only reachable when first_cycle remains true, which
    // requires (currentYear - 2020) <= 3, i.e. running in calendar years
    // 2020-2023. Since these tests will run in 2024+ that branch is
    // permanently unreachable going forward and is left uncovered
    // intentionally (it is fully superseded by the earlier, always-active
    // "else { return null; }" check on the raw D/R/C/M character).

    // ---------------- ProductDateCalculator : AS / GP fallback ----------------

    @isTest
    static void testProductDateCalculator_ASAndGP() {
        String d = prevYearDigit();
        Test.startTest();
        String resultAS  = TraceCodeHelperCore.ProductDateCalculator('S123K' + d + 'A12', 'AS');
        String resultGP  = TraceCodeHelperCore.ProductDateCalculator('S123K' + d + 'A12', 'GP');
        String resultBad = TraceCodeHelperCore.ProductDateCalculator('S999K' + d + 'A12', 'GP');
        Test.stopTest();
        System.assertNotEquals('fail', resultAS, 'AS returns the derived date without a past-date check');
        System.assertNotEquals(null, resultAS);
        System.assertNotEquals('fail', resultGP, 'A previous-year GP code must succeed');
        System.assertNotEquals(null, resultGP);
        System.assertEquals('fail', resultBad, 'Julian day 999 must fail');
    }

    @isTest
    static void testProductDateCalculator_ASGP_NonLeapYearOverflow() {
        // second_number '1' maps the internal leap check to year "2001",
        // which is not a leap year, so a julian day of 366 must fail.
        String code = 'S366K1A12';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'GP');
        Test.stopTest();
        System.assertEquals('fail', result, 'Julian day 366 in a non-leap-mapped year must fail');
    }

    @isTest
    static void testProductDateCalculator_ASGP_LeapYearBranch() {
        // second_number '4' maps the internal leap check to year "2004",
        // which IS a leap year, exercising the alternate (non-28-day) branch.
        String code = 'S100K4A12';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'AS');
        Test.stopTest();
        System.assertNotEquals('fail', result, 'A leap-mapped year with a valid julian day must succeed');
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testProductDateCalculator_GP_FutureDateFails() {
        String code = 'S360K' + curYearDigit() + 'A12';
        Test.startTest();
        String result = TraceCodeHelperCore.ProductDateCalculator(code, 'GP');
        Test.stopTest();
        System.assertEquals('fail', result, 'A GP code whose derived date is not yet in the past must fail');
    }

    // ---------------- checkCounterfeitTraceCode ----------------

    @isTest
    static void testCheckCounterfeitTraceCode() {
        // Same record pattern as TraceCodeTest.TraceCodeMethodTest
        CounterfeitTraceCode__c counterFeit = new CounterfeitTraceCode__c();
        counterFeit.Trace_Code__c = 'CFTTEST123';
        counterFeit.Production_Date__c = Date.today();
        counterFeit.IsActive__c = true;
        insert counterFeit;

        Test.startTest();
        Boolean found    = TraceCodeHelperCore.checkCounterfeitTraceCode('CFTTEST123');
        Boolean notFound = TraceCodeHelperCore.checkCounterfeitTraceCode('NOMATCH999');
        Test.stopTest();

        System.assertEquals(true, found, 'An active counterfeit record must be detected');
        System.assertEquals(false, notFound, 'No record means not counterfeit');
    }

    // ---------------- sixCharacterProductDate ----------------

    @isTest
    static void testSixCharacterProductDate() {
        Test.startTest();
        String valid      = TraceCodeHelperCore.sixCharacterProductDate('CA1234');
        String badYear    = TraceCodeHelperCore.sixCharacterProductDate('QA1234');
        String badMonth   = TraceCodeHelperCore.sixCharacterProductDate('CQ1234');
        String badSerial  = TraceCodeHelperCore.sixCharacterProductDate('CA12AB');
        Test.stopTest();
        System.assertEquals('01/01/2025', valid, 'C=2025 and A=January must produce 01/01/2025');
        System.assertEquals(null, badYear, 'Unmapped year character returns null');
        System.assertEquals(null, badMonth, 'Unmapped month character returns null');
        System.assertEquals(null, badSerial, 'Non-numeric serial returns null');
    }

    @isTest
    static void testSixCharacterProductDate_FutureDate() {
        // H=2030, A=January: valid year/month/serial, but the resulting date
        // is in the future, exercising the "Date.today() >= parsed date" check.
        Test.startTest();
        String result = TraceCodeHelperCore.sixCharacterProductDate('HA1234');
        Test.stopTest();
        System.assertEquals(null, result, 'A future six-character production date must return null');
    }

    // ---------------- JulianDateChecker ----------------

    @isTest
    static void testJulianDateChecker() {
        System.assertEquals(true,  TraceCodeHelperCore.JulianDateChecker('100', 2023));
        System.assertEquals(false, TraceCodeHelperCore.JulianDateChecker('000', 2023), 'Day zero is invalid');
        System.assertEquals(true,  TraceCodeHelperCore.JulianDateChecker('366', 2024), 'Day 366 is valid in a leap year');
        System.assertEquals(false, TraceCodeHelperCore.JulianDateChecker('366', 2023), 'Day 366 is invalid in a non-leap year');
        System.assertEquals(false, TraceCodeHelperCore.JulianDateChecker('367', 2024), 'Day 367 is always invalid');
        System.assertEquals(false, TraceCodeHelperCore.JulianDateChecker('AB', 2023), 'Non-numeric julian is invalid');
    }

    // ---------------- convertProductDate / nextDay / mondayDate ----------------

    @isTest
    static void testConvertProductDate() {
        Test.startTest();
        Date converted = TraceCodeHelperCore.convertProductDate('03/10/2014');
        Test.stopTest();
        System.assertEquals(Date.newInstance(2014, 3, 10), converted);
    }

    @isTest
    static void testNextDay() {
        Test.startTest();
        Date nextMonday = TraceCodeHelperCore.nextDay('07/01/2026', 'MONDAY');
        Test.stopTest();
        System.assertEquals(Date.newInstance(2026, 7, 6), nextMonday, '07/01/2026 is a Wednesday; next Monday is 07/06');
    }

    @isTest
    static void testNextDay_NoMatchFallback() {
        // When vDay never matches any weekday name within the 7-day scan,
        // the loop exhausts (I reaches 8) and the method falls through to
        // the final "return vDate + I days" line.
        Test.startTest();
        Date result = TraceCodeHelperCore.nextDay('07/01/2026', 'FUNDAY');
        Test.stopTest();
        System.assertEquals(Date.newInstance(2026, 7, 9), result, 'No weekday match falls through to vDate + 8 days');
    }

    @isTest
    static void testMondayDate() {
        Test.startTest();
        String week1 = TraceCodeHelperCore.mondayDate('2015', '1');
        Test.stopTest();
        System.assertEquals(Date.newInstance(2014, 12, 29).format(), week1, 'Fiscal week 1 of 2015 starts Monday 12/29/2014');
    }

    @isTest
    static void testMondayDate_AllWeekdayBranches() {
        // Each of these years was chosen so that Dec 31 of the prior year
        // falls on a different day of the week, exercising every branch of
        // the WeekName if/else-if chain (MON/TUE/WED/THU/FRI/SAT/else-SUN).
        Test.startTest();
        String mon = TraceCodeHelperCore.mondayDate('2019', '1'); // Dec 31 2018 = Monday
        String tue = TraceCodeHelperCore.mondayDate('2020', '1'); // Dec 31 2019 = Tuesday
        String thu = TraceCodeHelperCore.mondayDate('2021', '1'); // Dec 31 2020 = Thursday
        String fri = TraceCodeHelperCore.mondayDate('2022', '1'); // Dec 31 2021 = Friday
        String sat = TraceCodeHelperCore.mondayDate('2017', '1'); // Dec 31 2016 = Saturday
        String sun = TraceCodeHelperCore.mondayDate('2018', '1'); // Dec 31 2017 = Sunday (else branch)
        Test.stopTest();

        System.assertEquals(Date.newInstance(2018, 12, 31).format(), mon, 'MON branch');
        System.assertEquals(Date.newInstance(2019, 12, 30).format(), tue, 'TUE branch');
        System.assertEquals(Date.newInstance(2020, 12, 28).format(), thu, 'THU branch');
        System.assertEquals(Date.newInstance(2021, 12, 27).format(), fri, 'FRI branch');
        System.assertEquals(Date.newInstance(2016, 12, 26).format(), sat, 'SAT branch');
        System.assertEquals(Date.newInstance(2017, 12, 25).format(), sun, 'Else (Sunday) branch');
    }

    // ---------------- methodOne / methodTwo ----------------

    @isTest
    static void testMethodOne_LCode() {
        String d = prevYearDigit();
        String cur = String.valueOf(System.today().year());
        String traceCode = 'L123X' + d + '000';

        Test.startTest();
        String result = TraceCodeHelperCore.methodOne(
            'L', '', '', '', '', '', traceCode,
            Math.mod(System.today().year(), 10),
            '/201', '/' + cur.substring(0, 3), cur,
            '', 0, 'GP', '/20', '', '');
        Test.stopTest();

        System.assertNotEquals('fail', result, 'A valid previous-year L code must succeed');
        System.assertNotEquals('', result, 'A valid L code must return a production date');
    }

    @isTest
    static void testMethodOne_LCode_CurrentYearFutureFails() {
        // second_number equal to ln_lastdigit_year exercises the "equal digit"
        // branch, and a julian day far in the future exercises the ln_days<=0
        // fail path inside the 'L' code block.
        String digit = curYearDigit();
        String cur = String.valueOf(System.today().year());
        String traceCode = 'L360X' + digit + '000';

        Test.startTest();
        String result = TraceCodeHelperCore.methodOne(
            'L', '', '', '', '', '', traceCode,
            Integer.valueOf(digit),
            '/201', '/' + cur.substring(0, 3), cur,
            '', 0, 'GP', '/20', '', '');
        Test.stopTest();

        System.assertEquals('fail', result, 'A future-dated current-year L code must fail');
    }

    @isTest
    static void testMethodOne_LCode_NonNumericThirdNumber() {
        // third_number is non-numeric ("abc" != '000'), so the outer L
        // condition evaluates false without throwing (third_number is only
        // ever compared with string equality, never parsed). This exercises
        // both the discarded internal methodTwo(...) call inside the
        // "!isNumeric" check and the discarded methodTwo(...) call in the
        // final else branch; both fall through to the trailing "return ''".
        String cur = String.valueOf(System.today().year());
        String traceCode = 'L123X5abc';

        Test.startTest();
        String result = TraceCodeHelperCore.methodOne(
            'L', '', '', '', '', '', traceCode,
            5,
            '/201', '/' + cur.substring(0, 3), cur,
            '', 0, 'GP', '/20', '', '');
        Test.stopTest();

        System.assertEquals('', result, 'A non-numeric third_number falls through to an empty return');
    }

    @isTest
    static void testMethodOne_LCode_InvalidSecondChar() {
        // All numeric portions are valid, but second_char ('A') is not X/Y/Z,
        // so the big condition is false and control falls to the else branch
        // (discarded methodTwo call) and then the trailing "return ''".
        String cur = String.valueOf(System.today().year());
        String traceCode = 'L123A5000';

        Test.startTest();
        String result = TraceCodeHelperCore.methodOne(
            'L', '', '', '', '', '', traceCode,
            5,
            '/201', '/' + cur.substring(0, 3), cur,
            '', 0, 'GP', '/20', '', '');
        Test.stopTest();

        System.assertEquals('', result, 'An invalid second_char falls through to an empty return');
    }

    @isTest
    static void testMethodOne_NonLCodeDelegates() {
        String cur = String.valueOf(System.today().year());
        Test.startTest();
        String result = TraceCodeHelperCore.methodOne(
            'A', '', '', '', '', '', 'A123X5000',
            Math.mod(System.today().year(), 10),
            '/201', '/' + cur.substring(0, 3), cur,
            '', 0, 'GP', '/20', '', '');
        Test.stopTest();
        System.assertEquals('', result, 'Non-L first character falls through to methodTwo and returns empty');
    }

    @isTest
    static void testMethodTwo_TPNashvilleValid() {
        String d = prevYearDigit();
        String cur = String.valueOf(System.today().year());
        String traceCode = 'NSH' + d + '06142';

        Test.startTest();
        String result = TraceCodeHelperCore.methodTwo(
            '', '', '', '', '', '', traceCode,
            '/201', '/' + cur.substring(0, 3), cur,
            '', 0, 'TP', '/20', '', '');
        Test.stopTest();

        System.assertNotEquals('fail', result, 'A valid previous-year Nashville TP code must succeed');
        System.assertNotEquals('', result);
    }

    @isTest
    static void testMethodTwo_TPFranklinParkValid() {
        String d = prevYearDigit();
        String cur = String.valueOf(System.today().year());
        String traceCode = 'FRP' + d + '0614A';

        Test.startTest();
        String result = TraceCodeHelperCore.methodTwo(
            '', '', '', '', '', '', traceCode,
            '/201', '/' + cur.substring(0, 3), cur,
            '', 0, 'TP', '/20', '', '');
        Test.stopTest();

        System.assertNotEquals('fail', result, 'A valid previous-year Franklin Park TP code must succeed');
        System.assertNotEquals('', result);
    }

    @isTest
    static void testMethodTwo_TP_FutureDateFails() {
        // "VEE" decodes (group1: E=6, V=3) to lv_month = "366" (the maximum
        // allowed value), and first_number = the CURRENT year's last digit,
        // so the derived date is the very last day of the current year -
        // safely in the future for this test's entire run window.
        String digit = curYearDigit();
        String cur = String.valueOf(System.today().year());
        String traceCode = 'VEE' + digit + '0614S';

        Test.startTest();
        String result = TraceCodeHelperCore.methodTwo(
            '', '', '', '', '', '', traceCode,
            '/201', '/' + cur.substring(0, 3), cur,
            '', 0, 'TP', '/20', '', '');
        Test.stopTest();

        System.assertEquals('fail', result, 'A future-dated current-year TP code must fail');
    }

    @isTest
    static void testMethodTwo_TP_Group1_PositionFailures() {
        String cur = String.valueOf(System.today().year());
        // third_char 'S' is in the N/S/H/V/I/L/E/2/3 group, which validates
        // first_char position-by-position. Position 0 failing is already
        // covered elsewhere ('ZZZ...'); these cover positions 1 and 2.
        String position1Fail = TraceCodeHelperCore.methodTwo(
            '', '', '', '', '', '', 'NZN506142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');
        String position2Fail = TraceCodeHelperCore.methodTwo(
            '', '', '', '', '', '', 'NSZ506142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');

        System.assertEquals('fail', position1Fail, 'Invalid character at first_char position 1 must fail');
        System.assertEquals('fail', position2Fail, 'Invalid character at first_char position 2 must fail');
    }

    @isTest
    static void testMethodTwo_TP_Group2_PositionFailures() {
        String cur = String.valueOf(System.today().year());
        // third_char 'A' is in the A/B/P/Y/O/F/G/Z/M/R/K/W/1/X group, which
        // validates first_char (F/R/P/K/G/Y/M/B/O/W) position-by-position.
        String position0Fail = TraceCodeHelperCore.methodTwo(
            '', '', '', '', '', '', 'ZFR506142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');
        String position1Fail = TraceCodeHelperCore.methodTwo(
            '', '', '', '', '', '', 'FZR506142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');
        String position2Fail = TraceCodeHelperCore.methodTwo(
            '', '', '', '', '', '', 'FRZ506142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');

        System.assertEquals('fail', position0Fail, 'Invalid character at first_char position 0 must fail');
        System.assertEquals('fail', position1Fail, 'Invalid character at first_char position 1 must fail');
        System.assertEquals('fail', position2Fail, 'Invalid character at first_char position 2 must fail');
    }

    @isTest
    static void testMethodTwo_FailurePaths() {
        String cur = String.valueOf(System.today().year());
        Test.startTest();
        String nonNumeric   = TraceCodeHelperCore.methodTwo('', '', '', '', '', '', 'NSH5AB142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');
        String badThirdChar = TraceCodeHelperCore.methodTwo('', '', '', '', '', '', 'NSH506147',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');
        String badFirstChar = TraceCodeHelperCore.methodTwo('', '', '', '', '', '', 'ZZZ506142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');
        String monthTooBig  = TraceCodeHelperCore.methodTwo('', '', '', '', '', '', 'QQQ506142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'TP', '/20', '', '');
        String notTP        = TraceCodeHelperCore.methodTwo('', '', '', '', '', '', 'NSH506142',
            '/201', '/' + cur.substring(0, 3), cur, '', 0, 'GP', '/20', '', '');
        Test.stopTest();

        System.assertEquals('fail', nonNumeric, 'Non-numeric hour characters must fail');
        System.assertEquals('fail', badThirdChar, 'Invalid 9th character must fail');
        System.assertEquals('fail', badFirstChar, 'Invalid month characters must fail');
        System.assertEquals('fail', monthTooBig, 'Decoded month above 366 must fail');
        System.assertEquals('', notTP, 'Non-TP product line returns empty');
    }

    // NOTE ON REMAINING UNCOVERED LINES:
    // A handful of lines in TraceCodeHelperCore are unreachable through any
    // legitimate input given the current implementation and are left
    // uncovered intentionally rather than forced with contrived test data
    // that would misrepresent real usage:
    //   1. TDNP 7-char "future date" branch - all mapped year letters
    //      (W/U/X/Y/Z) resolve to fixed past years (2019-2022).
    //   2. SNP/TDNS "firstChar not valid" secondary check - only reachable
    //      when (currentYear - 2020) <= 3, i.e. calendar years 2020-2023.
    //   3. methodOne's "lv_cur_year < '201'+digit" else-branch, and
    //      methodTwo's equivalent first_number branch - both assume a
    //      current year no later than 2019, which no longer holds.
    //   4. methodTwo's hour/minute range check
    //      "(hour < 0 && hour > 23) || (minute < 0 && minute > 23)" - this
    //      compound condition can never be true (a number cannot be both
    //      less than 0 and greater than 23 at the same time), so its "true"
    //      branch is dead code.
    //   5. methodTwo's "first_number not between 0 and 9" fail branch -
    //      first_number is always a single character; if it isn't numeric,
    //      Integer.valueOf throws before this check is reached, and if it is
    //      numeric a single digit is always within 0-9, so the branch can
    //      never be entered.
    // These are pre-existing design/date-assumption issues in
    // TraceCodeHelperCore itself, not gaps in the test suite.
}