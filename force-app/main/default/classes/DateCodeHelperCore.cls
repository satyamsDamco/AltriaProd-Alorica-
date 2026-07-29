public virtual class DateCodeHelperCore {
    
    public virtual class DateCode {
        public string ProductionDate;
        public string DateCodeLocation;
        public string DateCodeShift;
        public string DateCodeUnit;
        public string DateCodeColdStorage;
        public string DateCodeRptBay;
        public string DateCodeRptFactory;
        public string DateCodeMilitaryTime;
        public string UstDateCode;
        public string SerialNumber;
    }
    
    public virtual class TraceCodeValue {
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
    public string lv_serial_number = '';
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
    public Set<string> charSet = new Set<string>();
    public Set<Integer> intSet = new Set<Integer>();
    public String fiscal_week = '';
    public Financial_Week__c fw = new Financial_Week__c();
    public DateCodeHelperCore.DateCode DateCodeObj;

    public DateCodeHelperCore() {
        DateCodeObj = new DateCodeHelperCore.DateCode();
    }
}