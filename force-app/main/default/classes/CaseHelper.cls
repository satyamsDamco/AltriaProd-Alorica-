public class CaseHelper{
    
    public static Boolean isFirstTime = true;
    
    /* Calculate overage age for case Object. */
    public void calculateOverage(list<Case> lstCaseUpdate){
        DateTime date1;
        Datetime date2;
        Datetime date3;
        Datetime date4;
        Datetime date5;
        set<string> setUstDateCodeType = new set<string>();//Set of ustDateCodeType.
        setUstDateCodeType.add('CD');
        setUstDateCodeType.add('MD'); 
        setUstDateCodeType.add('SN');
        setUstDateCodeType.add('WB');
        list<Id> lstBHId = new list<Id>();// List of Brand hierarchy's ID.
        set<string> setProdLine = new set<string>();//Set of Product Line's Name. 
        Map<Case, String> mapCaseBH = new Map<Case, String>();//Map of Case as ID and pickUpPolicyWeeks from BH as value.
        integer pickUpPolicyWeeks ;
        
        for(Case c : lstCaseUpdate){
            lstBHId.add(c.Crc_Brand_Hierarchy_Code__c);
        }
        
        list<Brand_Hierarchy__c> lstBH = [Select Id, Pick_Up_Policy_Weeks__c From Brand_Hierarchy__c Where id in: lstBHId];
        
        List<Product_Line__c> lstProdLine = [Select Id, Name, isActive__c From Product_Line__c];
        for(Product_Line__c overagePL : lstProdLine){
            setProdLine.add(overagePL.Name);
        }
        
        for(case issue : lstCaseUpdate){
            for(Brand_Hierarchy__c bh : lstBH){
                if(bh.Id == issue.Crc_Brand_Hierarchy_Code__c && bh.Pick_Up_Policy_Weeks__c != null && String.valueOf(bh.Pick_Up_Policy_Weeks__c).trim() != ''){
                    mapCaseBH.put(issue, String.ValueOf(bh.Pick_Up_Policy_Weeks__c));
                }
            }
        }
       
        
        for(case issue : lstCaseUpdate){ 
            pickUpPolicyWeeks = 0;
            if(mapCaseBH != null && mapCaseBH.get(issue) != null && mapCaseBH.get(issue) != 'NULL'){
                pickUpPolicyWeeks = Integer.valueof(mapCaseBH.get(issue));
            }
            
           
            /* Validation for Date fields. */
            //if(setProdLine.contains(issue.Product_Line__c)){
                if(issue.Incident_Date__c != null){
                    date1 = issue.Incident_Date__c;
                }else if(issue.createddate != null){
                    date1 = issue.createddate;
                }else{
                    date1 = Datetime.newInstance(1900, 1, 1);
                } 
                
                if(issue.Date__c != null ){
                    date2 = issue.Date__c.addDays(0);
                    date3 = issue.Date__c.addDays(pickUpPolicyWeeks*7+4);
                }else{ 
                    date2 = Datetime.newInstance(1900, 1, 1);
                    date3 = Datetime.newInstance(1900, 1, 1);
                }
                
                if(issue.Date__c != null){
                    date4 = issue.Date__c;
                }else if(issue.createddate != null){
                    date4 = issue.createddate;
                }else{
                    date4 = issue.Incident_Date__c;
                }
                
                if(issue.createddate != null){
                    date5 = issue.createddate;
                }else{
                    date5 = issue.Incident_Date__c;
                }
                
                if(issue.Date_Code__c == null || (issue.Date_Code__c != null && issue.Date_Code__c.trim() == '') || issue.Date_Type__c == null || (issue.Date_Type__c != null && issue.Date_Type__c.trim() == '') || issue.Date__c == null || issue.Date_Code__c == 'WB'){
                    
                    issue.Overage__c = '';
                }else if(issue.Date_Code__c == 'SB'){
                    
                    if(issue.Date__c != NULL ){
                        issue.Overage__c = '';
                        
                    }else if(date1 != null && date2 != null && date1 > date2){
                        issue.Overage__c = 'Y';
                        
                    }else{
                        issue.Overage__c = 'N';
                        
                    }
                }else{
                    
                    if(issue.Date_Code__c != null && issue.Date_Code__c.touppercase() == 'CD'){
                       
                        if(issue.Date__c == NULL){
                            issue.Overage__c = '';
                            
                        }else if(date1 != null && date3 != null && date1 > date3){
                            issue.Overage__c = 'Y';
                            
                        }else{
                            issue.Overage__c = 'N';
                            
                        }
                    }else{
                        
                        if(date4 != null && date5 != null && (Date.valueOf(date4)).daysBetween(Date.valueOf(date5)) > 0){
                            
                            issue.Overage__c = 'Y';
                        }else{
                            
                            issue.Overage__c = 'N';
                        }
                    }
                }
            //}
        }
    }
    
    public void setFieldValues(List<Case> triggerNewList,List<Case>  triggerOldList, System.TriggerOperation triggerOperationType) {
        
        Map<String,Case> updateCaseMap = new Map<String,Case>();
        String lineValue = '';
        Map<String,Case> contactIdMap = new Map<String,Case>();
        String UCIDValue = '';
        Set<String> caseIdSet = new Set<String>();
        
        if(triggerOperationType == System.triggerOperation.AFTER_INSERT) {
            
            for(Case caseRec : triggerNewList) {
                
                // Start: Line__c
                // commented: 2023-05-24
                // if(caseRec.DateCodeUnit__c != null) {
                    
                String dcuValue = '';
                List<String> dateCodeUnitStrList = new List<String>();
                
                if(caseRec.DateCodeUnit__c != null) {
                    dcuValue = caseRec.DateCodeUnit__c;
                    dateCodeUnitStrList = caseRec.DateCodeUnit__c.split('');
                }
                
                String dcuMidValue = dcuValue.mid(1,1);
                Integer mfgtcCnt = 0;
                String mfgtcValue = '';
                if(caseRec.Mfg_Trace_code__c != null) {
                    mfgtcValue = caseRec.Mfg_Trace_code__c;
                    String mfgtcTrim = mfgtcValue.trim();
                    mfgtcCnt = mfgtcTrim.length();
                }
                
                if(caseRec.Product_Line__c == 'TOBACCO DERIVED NICOTINE POUCH') {
                    switch on dcuValue {
                        when 'U' {
                            lineValue = 'Bay 9 – Line#1';
                        }
                        when 'J' {
                            lineValue = 'Bay 9 – Line#2';
                        }
                        when 'N' {
                            lineValue = 'Bay 9 – Line#3';
                        }
                        when 'P' {
                            lineValue = 'Bay 9 – Line#4';
                        }
                        when 'E' {
                            lineValue = 'Bay 9 – Line#5';
                        }
                        when else {
                            lineValue = '';
                        }
                    }
                } else if(caseRec.DateCodeUnit__c != null && caseRec.Product_Line__c == 'Cigarettes' && dcuMidValue != '0') {
                    lineValue = dcuValue.substring(0,2);
                } else if(caseRec.DateCodeUnit__c != null && caseRec.Product_Line__c == 'Cigarettes' && dcuMidValue == '0') {
                    lineValue = dcuValue.substring(0,2);
                } else if(caseRec.Operating_Company__c != null && caseRec.Operating_Company__c == 'PMIP') {
                    lineValue = caseRec.DateCodeUnit__c;
                } else if(caseRec.DateCodeRptFactory__c != null && caseRec.DateCodeRptFactory__c == 'MC_USSTC') {
                    switch on dcuValue {
                        when 'K' {
                            lineValue = 'MC LINE #1';
                        }
                        when 'G' {
                            lineValue = 'MC LINE #2';
                        }
                        when 'T' {
                            lineValue = 'MC LINE #3';
                        }
                        when 'Y' {
                            lineValue = 'MC LINE #4';
                        }
                        when 'Z' {
                            lineValue = 'MC POUCH LINE';
                        }
                        when else {
                            lineValue = '';
                        }
                    }
                } else if(caseRec.DateCodeRptFactory__c != null && caseRec.DateCodeRptFactory__c == 'MC_JMC' && mfgtcCnt == 9) {
                    lineValue = dcuValue.mid(0,2);
                } 
                
                else if(caseRec.DateCodeRptFactory__c != null && caseRec.DateCodeRptFactory__c == 'NS' && dateCodeUnitStrList.size() > 2 && checkIsNumber(dateCodeUnitStrList[1])) {
                    String mfgtcMidValue = mfgtcValue.mid(5,1);
                    lineValue = generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber(mfgtcMidValue);
                } 
                
                else if(caseRec.DateCodeRptFactory__c != null && caseRec.DateCodeRptFactory__c == 'NS' &&  dateCodeUnitStrList.size() > 2 && checkIsAlpha(dateCodeUnitStrList[1])) {
                    String mfgtcMidValue = mfgtcValue.mid(9,1);
                    lineValue = generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha(mfgtcMidValue);
                } 
                
                else if(caseRec.DateCodeRptFactory__c != null && caseRec.DateCodeRptFactory__c == 'FP' && dateCodeUnitStrList.size() > 2  && checkIsNumber(dateCodeUnitStrList[1])) {
                    String mfgtcMidValue = mfgtcValue.mid(5,1);
                    lineValue = generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber(mfgtcMidValue);
                } 
                
                else if(caseRec.DateCodeRptFactory__c != null && caseRec.DateCodeRptFactory__c == 'FP' && dateCodeUnitStrList.size() > 2  && checkIsAlpha(dateCodeUnitStrList[1])) {
                    String mfgtcMidValue = mfgtcValue.mid(9,1);
                    lineValue = generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha(mfgtcMidValue);
                } 
                
                else {
                    lineValue = '';
                }
                
                Case updateCase = new Case(Id=caseRec.Id, Line__c=lineValue);
                updateCaseMap.put(caseRec.Id,updateCase);
                
                // commented 2023-05-24
                // }
                //End: Line__c
                
                if(contactIdMap.get(caseRec.Id) == null) {
                    contactIdMap.put(caseRec.ContactId, caseRec);
                }
                
                caseIdSet.add(caseRec.Id);
            }
            
            //Start: UCID
            if(!contactIdMap.isEmpty()) {
                List<Contact> conList = [SELECT Id, CustomerType__c, LastName, Zip_Code__c, CustomerID__c FROM Contact WHERE Id IN : contactIdMap.keyset()];
                for(Contact con : conList) {
                    if(
                        (
                            con.CustomerType__c == 'PM EMPLOYEE'
                            || con.CustomerType__c == 'CONSUMER'
                            || con.CustomerType__c == 'USSTC EMPL'
                            || con.CustomerType__c == 'ATTORNEY'
                            || con.CustomerType__c == 'GOV AGENT'
                            || con.CustomerType__c == 'JMC EMPL'
                            || con.CustomerType__c == 'OTHER'
                        )
                       && con.LastName == 'DOE' 
                       && con.Zip_Code__c == '15122'
                    ) {
                        UCIDValue = 'U' + contactIdMap.get(con.Id).MasterId__c;
                    } 
                    else if(
                        con.CustomerType__c == 'RESEARCH PANELIST'
                        || con.CustomerType__c == 'WHOLESALER'
                        || con.CustomerType__c == 'RETAILER'
                        || con.CustomerType__c == 'FIELD SALES FORCE'
                    ) {
                        UCIDValue = 'U' + contactIdMap.get(con.Id).MasterId__c;
                    } 
                    else {
                        UCIDValue = con.CustomerID__c;
                    }
                    
                     if(updateCaseMap.get(contactIdMap.get(con.Id).Id) != null) {
                        updateCaseMap.get(contactIdMap.get(con.Id).Id).put('UCID__c',UCIDValue);
                    } else {
                        Case updateCase = new Case(Id=contactIdMap.get(con.Id).Id, UCID__c=UCIDValue);
                        updateCaseMap.put(contactIdMap.get(con.Id).Id,updateCase);
                    }
                }
            }
            //End: UCID
        
            if(!caseIdSet.isEmpty()) {
                for(Case caseRec : [SELECT Id, Issue_Hierarchy_Code__c, Issue_Hierarchy_Code__r.Factory_Controllable_Flag__c, Crc_Brand_Hierarchy_Code__c, Crc_Brand_Hierarchy_Code__r.Short_Cut__c FROM Case WHERE Id IN :caseIdSet]) {
                    
                    //Start: PMUSA Factory Controllable1
                    if(caseRec.Issue_Hierarchy_Code__c != null) {
                        Boolean FCFValue = caseRec.Issue_Hierarchy_Code__r.Factory_Controllable_Flag__c;
                        
                        if(updateCaseMap.get(caseRec.Id) != null) {
                            updateCaseMap.get(caseRec.Id).put('PMUSA_Factory_Controllable1__c',FCFValue);
                        } else {
                            Case updateCase = new Case(Id=caseRec.Id, PMUSA_Factory_Controllable1__c=FCFValue);
                            updateCaseMap.put(caseRec.Id,updateCase);
                        }
                    }
                    //End: PMUSA Factory Controllable1
                    
                    //Start: Shortcut
                    if(caseRec.Crc_Brand_Hierarchy_Code__c != null && caseRec.Crc_Brand_Hierarchy_Code__r.Short_Cut__c != null) {
                        String Shortcut = caseRec.Crc_Brand_Hierarchy_Code__r.Short_Cut__c;
                        
                        if(updateCaseMap.get(caseRec.Id) != null) {
                            updateCaseMap.get(caseRec.Id).put('Shortcut1__c',Shortcut);
                        } else {
                            Case updateCase = new Case(Id=caseRec.Id, Shortcut1__c=Shortcut);
                            updateCaseMap.put(caseRec.Id,updateCase);
                        }
                    }
                    //End: Shortcut
                }
            }
        }

        System.debug('updateCaseMap: ' + updateCaseMap);
        If(!updateCaseMap.isEmpty()) {
            update updateCaseMap.values();
        }
    }
    
    
    
    
    public String generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber(String mfgtcMidValue) {
        String lineValue = '';
        
        
        switch on mfgtcMidValue {
            when 'A' {
                lineValue = 'POUCH LINE #1';
            }
            when 'B' {
                lineValue = 'POUCH LINE #2';
            }
            when 'C' {
                lineValue = 'SKOAL #8';
            }
            when 'E' {
                lineValue = 'CELL LINE A';
            }
            when 'H' {
                lineValue = 'COPE #3';
            }
            when 'I' {
                lineValue = 'SKOAL #7';
            }
            when 'L' {
                lineValue = 'SKOAL #6';
            }
            when 'M' {
                lineValue = 'SKOAL #9';
            }
            when 'N' {
                lineValue = 'COPE #1';
            }
            when 'P' {
                lineValue = 'HIGH SPEED CELL LINE #1';
            }
            when 'R' {
                lineValue = 'CELL LINE B';
            }
            when 'S' {
                lineValue = 'COPE #2';
            }
            when 'V' {
                lineValue = 'SKOAL #5';
            }
            when '2' {
                lineValue = 'MP - CELL LINE D';
            }
            when
                else {
                    lineValue = '';
                }
        }
        
        return lineValue;
    }
    
    public String generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha(String mfgtcMidValue) {
        String lineValue = '';
        
        
        switch on mfgtcMidValue {
            when 'E' {
                lineValue = 'CELL LINE';
            }
            when 'H' {
                lineValue = 'COPE #3';
            }
            when 'I' {
                lineValue = 'SKOAL #4';
            }
            when 'L' {
                lineValue = 'SKOAL #6';
            }
            when 'N' {
                lineValue = 'COPE #1';
            }
            when 'S' {
                lineValue = 'COPE #2';
            }
            when 'V' {
                lineValue = 'SKOAL #5';
            }
            when '2' {
                lineValue = 'POUCH LINE #1';
            }
            when '3' {
                lineValue = 'POUCH LINE #2';
            }
            when '4' {
                lineValue = 'HIGH SPEED CAN LINE 1';
            }
            when '5' {
                lineValue = 'HIGH SPEED CAN LINE 2';
            }
            when
                else {
                    lineValue = '';
                }
        }
        
        return lineValue;
    }
    
    
    
    public String generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber(String mfgtcMidValue) {
        String lineValue = '';
        
        
        switch on mfgtcMidValue {
            when 'E' {
                lineValue = 'CELL LINE A';
            }
            when 'F' {
                lineValue = 'COPE #2';
            }
            when 'G' {
                lineValue = 'COPE #3';
            }
            when 'J' {
                lineValue = 'GD CELL LINE';
            }
            when 'K' {
                lineValue = 'BANDIT #1';
            }
            when 'M' {
                lineValue = 'CELL LINE #1';
            }
            when '0' {
                lineValue = 'COPE #1';
            }
            when 'W' {
                lineValue = 'BANDIT #2';
            }
            when 'X' {
                lineValue = 'READY PAK';
            }
            when 'Y' {
                lineValue = 'ODD BRAND';
            }
            when 'Z' {
                lineValue = 'OFF LINE';
            }
            when
                else {
                    lineValue = '';
                }
        }
        
        return lineValue;
    }
    
    
    public String generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha(String mfgtcMidValue) {
        String lineValue = '';
        
        
        switch on mfgtcMidValue {
            when 'A' {
                lineValue = 'SKOAL #1';
            }
            when 'B' {
                lineValue = 'SKOAL #2';
            }
            when 'G' {
                lineValue = 'COPE #3';
            }
            when 'I' {
                lineValue = 'COPE #2';
            }
            when 'J' {
                lineValue = 'GD CELL LINE';
            }
            when 'K' {
                lineValue = 'BANDIT #1';
            }
            when 'M' {
                lineValue = 'CELL LINE #1';
            }
            when 'O' {
                lineValue = 'COPE #1';
            }
            when 'P' {
                lineValue = 'SKOAL #3';
            }
            when 'Y' {
                lineValue = 'ODD BRAND';
            }
            when 'R' {
                lineValue = 'CELL LINE #2';
            }
            when 'W' {
                lineValue = 'BANDIT #2';
            }
            when 'X' {
                lineValue = 'READY PAK';
            }
            when 'Z' {
                lineValue = 'OFF LINE';
            }
            when
                else {
                    lineValue = '';
                }
        }
        
        return lineValue;
    }
    
    public Boolean checkIsAlpha(String strToCheck) {
        return strToCheck.isAlpha();
    }

    public Boolean checkIsNumber(String strToCheck) {
        return strToCheck.isNumeric();
    }
}