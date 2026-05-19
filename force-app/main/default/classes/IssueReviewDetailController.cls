/* Created By: Infogain Pvt. Ltd.
   Created Date: 9/23/2016
   Purpose: Issue detail page controller class.
*/
public class IssueReviewDetailController {

    // Global declaration of variables
    public Case caseObj {
        get;
        set;
    }
    public Case currIssue {
        get;
        set;
    }
    public boolean isUpdateReasonVisible {
        get;
        set;
    }
    public String custName {
        get;
        set;
    }
    public string custId {
        get;
        set;
    }
    public Contact controllerContact {
        get;
        set;
    }
    public string customerRecType {
        get;
        set;
    }
    public List < Survey_Issue__c > IssueSurvyeList {
        get;
        set;
    }
    public String sortDir {
        get;
        set;
    }
    public String sortExp {
        get;
        set;
    }
    public boolean iqosTrue {
        get;
        set;
    }
    public string masterID {
        get;
        set;
    }

    // Constructor
    public IssueReviewDetailController(ApexPages.StandardController controller) {
        this.caseObj = (Case) controller.getRecord();
        IssueSurvyeList = new List < Survey_Issue__c > ();
        CheckValidation();
        custName = '';
        custId = '';
        masterID = '';
        getCustomerDetails();
        IssueSurveyData();
        if (ApexPages.currentPage().getParameters().get('sortDirection') != null && ApexPages.currentPage().getParameters().get('sortDirection') != '' && (ApexPages.currentPage().getParameters().get('sortDirection') == 'asc' || ApexPages.currentPage().getParameters().get('sortDirection') == 'desc')) {
            sortDir = ApexPages.currentPage().getParameters().get('sortDirection');
        } else {
            sortDir = 'asc';
        }
        if (ApexPages.currentPage().getParameters().get('sortExpression') != null && ApexPages.currentPage().getParameters().get('sortExpression') != '') {
            if (ApexPages.currentPage().getParameters().get('sortExpression') == 'cn') {
                sortExp = 'cn';
            } else if (ApexPages.currentPage().getParameters().get('sortExpression') == 'bc') {
                sortExp = 'bc';
            } else if (ApexPages.currentPage().getParameters().get('sortExpression') == 'pl') {
                sortExp = 'pl';
            } else if (ApexPages.currentPage().getParameters().get('sortExpression') == 'cl') {
                sortExp = 'cl';
            } else if (ApexPages.currentPage().getParameters().get('sortExpression') == 're') {
                sortExp = 're';
            } else if (ApexPages.currentPage().getParameters().get('sortExpression') == 'cs') {
                sortExp = 'cs';
            } else if (ApexPages.currentPage().getParameters().get('sortExpression') == 'contn') {
                sortExp = 'contn';
            } else {
                sortExp = 'cn';
            }
        } else {
            sortExp = 'cn';
        }

        //IQOS ---------------------------
        if (caseObj.Product_Line__c != null && caseObj.Product_Line__c != '') {
            Product_Line__c pl = [Select Id, Operating_Company__c, Name from Product_Line__c where Name =: caseObj.Product_Line__c limit 1];
            if (pl.Operating_Company__c != null && pl.Operating_Company__c != '') {
                if (pl.Operating_Company__c == 'PMIP') {
                    iqosTrue = true;
                } else {
                    iqosTrue = false;
                }
            }
        }
        //IQOS ---------------------------
    }

    //method to check whether issue is reviewed or not
    public void CheckValidation() {
        if (caseObj.IsReviewed__c == True) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Issue Reviewed'));
        }
    }

    //method to set customer record type
    public void getCustomerDetails() {
        currIssue = [
            Select

            // START Contact fields
            Contact.ID,
            Contact.Name,
            Contact.CustomerID__c,
            Contact.RecordType.Name,
            Contact.CustomerConsumer__c,
            Contact.CustomerType__c,
            Contact.LastName,
            Contact.Zip_Code__c,
            // END Contact fields

            // START Case Fields
            Id,
            Transacation_Id__c,
            Survey__c,
            MasterId__c,
            Confirmed_Counterfeit__c,
            Suspected_Counterfiet__c,
            Test_Issue__c,
            DateCodeRptFactory__c,
            DateCodeUnit__c,
            Mfg_Trace_code__c,
            Product_Line__c,
            Operating_Company__c,

            ContactId
            From Case
            Where Id =: this.caseObj.id
            limit 1
        ];

        if (currIssue.MasterId__c != null) {
            masterID = currIssue.MasterId__c;
        }
        if (currIssue.ContactId != null) {
            custName = currIssue.Contact.Name;
            custId = currIssue.Contact.CustomerID__c;
            controllerContact = currIssue.Contact;
            if (currIssue.Contact.RecordType.Name == 'Consumer') {
                customerRecType = 'consumer';
            } else {
                customerRecType = 'trade';
            }
        }
    }

    //Method to open the IssueReviewDetail page
    public PageReference setReview() {
        //gcutchon-11/8/2017: added error message for (RITM1540273 - SCR 17-05-11 Issue Review - Survey Must be Taken)
        if (caseObj.Survey__c == 'Required') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'This Issue has a pending survey. The survey must be taken before the Issue can be approved.'));
            return null;
        }
        //-----------
        caseObj.IsReviewed__c = True;

        //Start: 2023-03-21-22-01
        if (!String.isBlank(controllerContact.CustomerConsumer__c)) {
            if (caseObj.Confirmed_Counterfeit__c == true ||
                (caseObj.Suspected_Counterfiet__c == true &&
                    caseObj.Test_Issue__c == false &&
                    ConstantClass.CUSTOMERORCONSUMER_CONS.equalsIgnoreCase(controllerContact.CustomerConsumer__c)
                )
            ) {
                caseObj.CounterfeitCodeLookup__c = ConstantClass.COUNTERFEITCODE_ONE;
            } else if (caseObj.Test_Issue__c == true) {
                caseObj.CounterfeitCodeLookup__c = ConstantClass.COUNTERFEITCODE_TWO;
            } else {
                caseObj.CounterfeitCodeLookup__c = ConstantClass.COUNTERFEITCODE_ZERO;
            }
        }

        //Start: UCID 2023-03-23-00-43

        String UCIDValue = '';

        if (
            (
                controllerContact.CustomerType__c == 'PM EMPLOYEE' ||
                controllerContact.CustomerType__c == 'CONSUMER' ||
                controllerContact.CustomerType__c == 'USSTC EMPL' ||
                controllerContact.CustomerType__c == 'ATTORNEY' ||
                controllerContact.CustomerType__c == 'GOV AGENT' ||
                controllerContact.CustomerType__c == 'JMC EMPL' ||
                controllerContact.CustomerType__c == 'OTHER'
            ) &&
            controllerContact.LastName == 'DOE' &&
            controllerContact.Zip_Code__c == '15122'
        ) {
            UCIDValue = 'U' + masterID;
        } else if (
            controllerContact.CustomerType__c == 'RESEARCH PANELIST' ||
            controllerContact.CustomerType__c == 'WHOLESALER' ||
            controllerContact.CustomerType__c == 'RETAILER' ||
            controllerContact.CustomerType__c == 'FIELD SALES FORCE'
        ) {
            UCIDValue = 'U' + masterID;
        } else {
            UCIDValue = controllerContact.CustomerID__c;
        }

        caseObj.UCID__c = UCIDValue;
        //End: UCID 2023-03-23-00-43

        //End: UCID 2023-03-23-00-43
        caseObj.Line__c = generateLineValue(currIssue);
        //End: UCID 2023-03-23-00-43

        update caseObj;
        Database.SaveResult upsRst = Database.Update(caseObj);

        if (upsRst.isSuccess()) {

            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
            mgmtHelper.createTransactionMgmtHistoryRecord('ISSUE_APPROVED', String.valueOf(upsRst.getId()));

            Case issueReviewed = [Select Id, IsReviewed__c,
                (Select Id, isReviewed__c From Reimbursements__r where isReviewed__c = false),
                (Select Id, isReviewed__c From Stores__r where isReviewed__c = false),
                (Select id, isReviewed__c From Survey_Issues__r where isReviewed__c = false),
                (Select id, isReviewed__c From Attachment_Details__r where isReviewed__c = false)
                From Case Where Id =: this.caseObj.id
            ];
            list < Reimbursement__c > lstReimbUpdate = new list < Reimbursement__c > ();
            list < Store__c > lstStoreUpdate = new list < Store__c > ();
            list < Survey_Issue__c > lstSurveyissueUpdate = new list < Survey_Issue__c > ();
            list < Attachment_Detail__c > lstAttachmentDetUpdate = new list < Attachment_Detail__c > ();
            if (issueReviewed != null && issueReviewed.Reimbursements__r != null && issueReviewed.Reimbursements__r.size() > 0) {
                for (Reimbursement__c reimb: issueReviewed.Reimbursements__r) {
                    reimb.isReviewed__c = true;
                    lstReimbUpdate.add(reimb);
                }
                list < Database.SaveResult > reimbresult = Database.update(lstReimbUpdate);
            }
            if (issueReviewed != null && issueReviewed.Stores__r != null && issueReviewed.Stores__r.size() > 0) {
                for (Store__c store: issueReviewed.Stores__r) {
                    store.isReviewed__c = true;
                    lstStoreUpdate.add(store);
                }
                list < Database.SaveResult > storeresult = Database.update(lstStoreUpdate);
            }
            if (issueReviewed != null && issueReviewed.Survey_Issues__r != null && issueReviewed.Survey_Issues__r.size() > 0) {
                for (Survey_Issue__c survIssue: issueReviewed.Survey_Issues__r) {
                    survIssue.isReviewed__c = true;
                    lstSurveyissueUpdate.add(survIssue);
                }
                list < Database.SaveResult > siresult = Database.update(lstSurveyissueUpdate);
            }
            if (issueReviewed != null && issueReviewed.Attachment_Details__r != null && issueReviewed.Attachment_Details__r.size() > 0) {
                for (Attachment_Detail__c ad: issueReviewed.Attachment_Details__r) {
                    ad.isReviewed__c = true;
                    lstAttachmentDetUpdate.add(ad);
                }
                list < Database.SaveResult > adresult = Database.update(lstAttachmentDetUpdate);
            }
        }
        PageReference pg = new Pagereference('/apex/IssueReviewDetail?id=' + this.caseObj.id);
        pg.setRedirect(true);
        return pg;
    }

    //Method to get the survey issue associated to the issue records
    public Pagereference IssueSurveyData() {

        IssueSurvyeList = new List < Survey_Issue__c > ([SELECT id, Comment__c, Survey_Name__c, QuestionText__c, AnswerText__c
            FROM Survey_Issue__c
            Where isActive__c = true
            and Issue__c =: caseObj.id
            order by createddate asc limit 5
        ]);

        return null;
    }

    public String generateLineValue(Case currIssue) {
        String lineValue = '';

        
        //Start: Line__c
        // commented: 2023-05-24
        // if (currIssue.DateCodeUnit__c != null) {

        String dcuMidValue = '';
        
        if (currIssue.DateCodeUnit__c != null) {
            dcuMidValue = currIssue.DateCodeUnit__c.mid(1, 1);
        }

        Integer mfgtcCnt = 0;
        List<String> mfgTraceCodeStrList = new List<String>();
        String mfgtcValue = '';
        if (currIssue.Mfg_Trace_code__c != null) {
            mfgTraceCodeStrList = currIssue.Mfg_Trace_code__c.split('');
            mfgtcValue = currIssue.Mfg_Trace_code__c;
            String mfgtcTrim = mfgtcValue.trim();
            mfgtcCnt = mfgtcTrim.length();
        }

        if (currIssue.Product_Line__c == 'TOBACCO DERIVED NICOTINE POUCH') {
            switch on currIssue.DateCodeUnit__c {
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
                when
                else {
                    lineValue = '';
                }
            }
        } 
        
        else if (currIssue.DateCodeUnit__c != null && currIssue.Product_Line__c == 'Cigarettes' && dcuMidValue != '0') {
            lineValue = currIssue.DateCodeUnit__c.substring(0, 2);
        } 
        
        else if (currIssue.DateCodeUnit__c != null && currIssue.Product_Line__c == 'Cigarettes' && dcuMidValue == '0') {
            lineValue = currIssue.DateCodeUnit__c.substring(0, 2);
        } 
        
        else if (currIssue.Operating_Company__c != null && currIssue.Operating_Company__c == 'PMIP') {
            lineValue = currIssue.DateCodeUnit__c;
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c == 'MC_USSTC') {
            lineValue = generateLineValueDateCodeRptFactoryMCUSSTC(currIssue.DateCodeUnit__c);
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c == 'MC_JMC' && mfgtcCnt == 9) {
            lineValue = currIssue.DateCodeUnit__c.mid(0, 2);
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c == 'NS' && mfgTraceCodeStrList.size() > 2 && checkIsNumber(mfgTraceCodeStrList[1])) {
            lineValue = generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber(mfgTraceCodeStrList[4]);
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c == 'NS' && mfgTraceCodeStrList.size() > 2 && checkIsAlpha(mfgTraceCodeStrList[1])) {
            lineValue = generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha(mfgTraceCodeStrList[8]);
        } 
        
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c == 'FP' && mfgTraceCodeStrList.size() > 2 && checkIsNumber(mfgTraceCodeStrList[1])) {
            lineValue = generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber(mfgTraceCodeStrList[4]);
        } 
        
        else if (currIssue.DateCodeRptFactory__c != null && currIssue.DateCodeRptFactory__c == 'FP' && mfgTraceCodeStrList.size() > 2 && checkIsAlpha(mfgTraceCodeStrList[1])) {
            lineValue = generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha(mfgTraceCodeStrList[8]);
        } 
        
        else {
            lineValue = '';
        }
            
            
        // commented: 2023-05-24
        // } else {
        //    lineValue = '';
        // }

        return lineValue;
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
            when 'O' {
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
    
    public String generateLineValueDateCodeRptFactoryMCUSSTC(String dateCodeUnit) {
        String lineValue = '';
        switch on dateCodeUnit {
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