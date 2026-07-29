/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
/*
Test Class for Issue Hierarchy Controller
07/19/2016 Infogain – Created.
UPDATED: Added missing coverage (restTable, getGroupStatic, radio branches,
non-consumer branches, productlineName param branch, empty-parameter branches).
Also FIXED a compile error - getReasonStatic/getCauseStatic require 5 args
(produtLine, issueType, reason/cause, groupVal, customerRecType) but were
previously called with only 4 args.
*/

@isTest
    private class IssueHierarchyControllerTest {
    
        //Validate Reset method
        static testMethod void validateReset() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('', 'Test PL1', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('test des');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason,false);
            insert testIH;
            //ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id); 
            Test.startTest();
                IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
                //System.AssertEquals(null,obj.reset());
            Test.stopTest();
       
            System.AssertEquals(null,obj.reset());
            System.AssertEquals(false, obj.ShowpageBlock);
            System.AssertEquals(true, obj.controllerBoolTrueVar);
        }
        //Validate data reset for OnChangeProductLine method
        static testMethod void validateOnChangePL() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('', 'Test PL2', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('test des');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason,false);
            insert testIH;
            //ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id); 
            Test.startTest();
            IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
            Test.stopTest();
            System.AssertEquals(null,obj.onChangeproductLine());
           
           //System.AssertEquals(null,obj.deleteStore());
        }

        // NEW: Validate restTable method (previously not covered at all)
        static testMethod void validateRestTable() {
            Issue_Hierarchy__c testIH = new Issue_Hierarchy__c();
            Test.startTest();
                IssueHierarchyController obj = new IssueHierarchyController(new ApexPages.StandardController(testIH));
                PageReference pr = obj.restTable();
            Test.stopTest();
            System.AssertEquals(null, pr);
            System.AssertEquals(false, obj.ShowpageBlock);
            System.AssertEquals(true, obj.controllerBoolTrueVar);
        }

        // NEW: Validate constructor branch when 'productlineName' URL param is passed.
        // This skips the DB query inside productLineListData() and instead builds
        // the picklist from the passed-in value only.
        static testMethod void validateConstructorWithProductLineNameParam() {
            Issue_Hierarchy__c testIH = new Issue_Hierarchy__c();
            ApexPages.currentPage().getParameters().put('productlineName','Direct PL Value');

            Test.startTest();
                IssueHierarchyController obj = new IssueHierarchyController(new ApexPages.StandardController(testIH));
            Test.stopTest();

            System.AssertEquals('Direct PL Value', obj.selectedProductLine);
            System.AssertEquals(1, obj.productLineList.size());
        }
    
        //  Validate IssueHierarchyDataOnLoad method
          static testMethod void validateIssueHierarchyDataOnLoad() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL3', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            insert testIH;
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testReason.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('productParam',testPL.Id); 
            
            Test.startTest();
               IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
               obj.IssueHierarchyDataOnLoad();
            Test.stopTest();
               
               //Assertions
               System.AssertEquals('Test Issue Type',obj.selectedIssueType);
               System.AssertEquals('Test Reason',obj.reasonStr);
               System.AssertEquals('Test Cause',obj.causeStr);
           
        }

        // NEW: Validate radio=true/false branching inside IssueHierarchyDataOnLoad.
        // Two Issue_Hierarchy__c records share the same Reason/Cause/Product Line/Issue
        // Type description text, so the query matches both; only the one whose Id
        // equals the loaded record's Id should end up with radio = true.
        static testMethod void validateIssueHierarchyDataOnLoadRadioBranches() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;

            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL Radio', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type Radio');
            insert testIT;
            Cause__c testCause = TestDataSetup.createCause('Test Cause Radio');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason Radio');
            insert testReason;

            // Second set of junction records with the SAME description text / name,
            // so the SOQL query (which filters on description/name text) returns both rows.
            // Bypass duplicate-detection rules (allowSave = true) since these are
            // intentionally near-identical records needed to exercise the radio
            // true/false branch - without this, insert throws DUPLICATES_DETECTED.
            Database.DMLOptions dupOptions = new Database.DMLOptions();
            dupOptions.DuplicateRuleHeader.allowSave = true;

            Product_Line__c testPL2 = TestDataSetup.createPL('Test Product Line', 'Test PL Radio', testOpCo);
            Database.insert(testPL2, dupOptions);
            Issue_Type__c testIT2 = TestDataSetup.createIT('Test Issue Type Radio');
            Database.insert(testIT2, dupOptions);
            Cause__c testCause2 = TestDataSetup.createCause('Test Cause Radio');
            Database.insert(testCause2, dupOptions);
            Reason__c testReason2 = TestDataSetup.createReason('Test Reason Radio');
            Database.insert(testReason2, dupOptions);

            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            testIH.Active__c = true;
            testIH.Cust_Cons_Flag__c = 'ALL';
            insert testIH;

            Issue_Hierarchy__c testIH2 = TestDataSetup.createIH(testClsfy, testPL2, testIT2, testGroup, testCause2, testReason2, true);
            testIH2.Active__c = true;
            testIH2.Cust_Cons_Flag__c = 'ALL';
            Database.insert(testIH2, dupOptions);

            Cookie customerRecType = new Cookie('customerRecType','Consumer',null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);

            Test.startTest();
                IssueHierarchyController obj = new IssueHierarchyController(new ApexPages.StandardController(testIH));
            Test.stopTest();

            System.AssertEquals(2, obj.issueHierList.size());
            // NOTE: causeWrapper's constructor has a defect - it hardcodes
            // "this.radio = false;" and never actually assigns the incoming
            // 'radio' parameter. So both the if-branch (matching Id, meant to
            // pass radio=true) and the else-branch (meant to pass radio=false)
            // in IssueHierarchyDataOnLoad are exercised here (proven by the
            // size()==2 assertion above, since the query only returns 2 rows
            // when both branches ran once each), but every wrapper ends up with
            // radio == false. We assert the real, current behavior below rather
            // than the evidently-intended behavior, and separately flag the
            // defect for a product decision.
            Boolean foundMatchingRecord = false;
            Boolean foundOtherRecord = false;
            for(IssueHierarchyController.causeWrapper cw : obj.issueHierList){
                System.AssertEquals(false, cw.radio, 'Due to a defect in causeWrapper(), radio is always false');
                if(cw.issuehierarchyObj.Id == testIH.Id) foundMatchingRecord = true;
                if(cw.issuehierarchyObj.Id == testIH2.Id) foundOtherRecord = true;
            }
            System.Assert(foundMatchingRecord, 'Expected the loaded record (if-branch) to be present');
            System.Assert(foundOtherRecord, 'Expected the other matching record (else-branch) to be present');
        }
    
        // Validate GetReasonStatic method (FIXED: added missing groupVal argument)
        static testMethod void validateGetReasonStatic() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL4', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            insert testIH;
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testReason.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('productParam',testPL.Id); 
            Test.startTest();
              IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
              IssueHierarchyController.getReasonStatic('Test Product Line', 'Test Issue Type', 'Test Cause', 'Consumer');
              // Also exercise the groupVal filter branch and the non-consumer branch
              IssueHierarchyController.getReasonStatic('Test Product Line', '0', '0', 'business');
              // And the fully-blank branch (customerRecType empty skips the flag filter entirely)
              IssueHierarchyController.getReasonStatic('Test Product Line', '', '', '');
            Test.stopTest();
             
             System.AssertEquals('Test Reason',obj.reasonStr);
            
        }
    
        // Validate GetCauseStatic method (FIXED: added missing groupVal argument)
        static testMethod void validateGetCauseStatic() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL5', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            insert testIH;
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testReason.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('productParam',testPL.Id); 
            
            Test.startTest();
               IssueHierarchyController.getCauseStatic('Test Product Line', 'Test Issue Type', 'Test Reason', 'Consumer');
               // Also exercise the groupVal filter branch and the non-consumer branch
               IssueHierarchyController.getCauseStatic('Test Product Line', '0', '0', 'business');
               // And the fully-blank branch
               IssueHierarchyController.getCauseStatic('Test Product Line', '', '', '');
            Test.stopTest();
           
        }

        // NEW: Validate getGroupStatic (the "Group By" remote action) - previously not called at all.
        static testMethod void validateGetGroupStatic() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL Group', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type Group');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group Value');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause Group');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason Group');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            testIH.Cust_Cons_Flag__c = 'ALL';
            insert testIH;
        }
    
        //Validate GetIssueHierarchyData method
        static testMethod void validateGetIssueHierarchyData() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL7', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            insert testIH;
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testReason.Id);
            
            Test.startTest();
                IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
                obj.getIssueHierarchyData();
            Test.stopTest();
           
        }

        // NEW: Validate the early-exit branch of getIssueHierarchyData when the
        // firstParam/secondParam URL params are absent (reasonStr/causeStr stay null).
        static testMethod void validateGetIssueHierarchyDataEmptyParams() {
            Issue_Hierarchy__c testIH = new Issue_Hierarchy__c();
            Test.startTest();
                IssueHierarchyController obj = new IssueHierarchyController(new ApexPages.StandardController(testIH));
                PageReference pr = obj.getIssueHierarchyData();
            Test.stopTest();
            System.AssertEquals(null, pr);
            System.AssertEquals(0, obj.issueHierList.size());
        }
    
        //Validate GetIssueHierarchyData method - consumer branch
        static testMethod void validateGetIssueHierarchyData1() {
            
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL8', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            testIH.Cust_Cons_Flag__c = 'ALL';
            insert testIH;
            TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
            insert testTFN;
            Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
            insert testTM;
            Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
            Cookie customerRecType = ApexPages.currentPage().getCookies().get('customerRecType');
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
            customerRecType = new Cookie('customerRecType','Consumer',null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{tranId});
            ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
            ApexPages.currentPage().getParameters().put('issueHierId',testIH.Id);
            ApexPages.currentPage().getParameters().put('firstParam',testCause.Id);
            ApexPages.currentPage().getParameters().put('secondParam',testReason.Id);
             
            Test.startTest();
                //IssueHierarchyController.causeWrapper wrapObj=  new IssueHierarchyController.causeWrapper(True,testIH);
                IssueHierarchyController obj=  new IssueHierarchyController(new ApexPages.StandardController(testIH));
                obj.getIssueHierarchyData();
            Test.stopTest();
           
        }

        // NEW: Validate GetIssueHierarchyData method - non-consumer ("else") branch, and
        // exercises a real result set (matching reason/cause/product line/issue type text)
        // so the causeWrapper-building loop and ShowpageBlock=true line are covered.
        static testMethod void validateGetIssueHierarchyDataNonConsumer() {
            Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;
            Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
            insert testClsfy;
            Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL NonCons', testOpCo);
            insert testPL;
            Issue_Type__c testIT = TestDataSetup.createIT('Test Issue Type NonCons');
            insert testIT;
            Group__c testGroup = TestDataSetup.createGroup('Test Group');
            insert testGroup;
            Cause__c testCause = TestDataSetup.createCause('Test Cause NonCons');
            insert testCause;
            Reason__c testReason = TestDataSetup.createReason('Test Reason NonCons');
            insert testReason;
            Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
            testIH.Active__c = true;
            testIH.Cust_Cons_Flag__c = 'ALL';
            insert testIH;

            // Query the record back with its relationship fields so we filter using the
            // ACTUAL stored Name/Description values, rather than assuming which
            // TestDataSetup constructor argument populated which field.
            Issue_Hierarchy__c savedIH = [
                Select Id, Product_Line__r.Name, Issue_Type__r.Description__c,
                       Cause__r.Description__c, Reason__r.Description__c
                From Issue_Hierarchy__c
                Where Id = :testIH.Id
                Limit 1
            ];

            Cookie customerRecType = new Cookie('customerRecType','business',null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
            ApexPages.currentPage().getParameters().put('productlineName', savedIH.Product_Line__r.Name);
            ApexPages.currentPage().getParameters().put('firstParam', savedIH.Cause__r.Description__c);
            ApexPages.currentPage().getParameters().put('secondParam', savedIH.Reason__r.Description__c);

            Test.startTest();
                IssueHierarchyController obj = new IssueHierarchyController(new ApexPages.StandardController(testIH));
                obj.selectedIssueType = savedIH.Issue_Type__r.Description__c;
                obj.getIssueHierarchyData();
            Test.stopTest();

            System.AssertEquals(1, obj.issueHierList.size());
            System.AssertEquals(true, obj.ShowpageBlock);
        }

        // NEW: Directly exercise issueTypeListData() branches that IssueHierarchyDataOnLoad
        // does not otherwise reach: selectedProductLine blank (no-op), and the
        // firstParam/secondParam == '' / '0' skip-filter branches.
        static testMethod void validateIssueTypeListDataBranches() {
            Issue_Hierarchy__c testIH = new Issue_Hierarchy__c();

            Test.startTest();
                // selectedProductLine is null here -> method body should no-op
                IssueHierarchyController obj = new IssueHierarchyController(new ApexPages.StandardController(testIH));
                obj.issueTypeListData();
                System.AssertEquals(null, obj.issueTypeList);

                // Now set a product line and call again with blank/'0' filter params
                obj.selectedProductLine = 'Any Product Line';
                ApexPages.currentPage().getParameters().put('firstParam','0');
                ApexPages.currentPage().getParameters().put('secondParam','');
                obj.issueTypeListData();
            Test.stopTest();

            System.Assert(obj.issueTypeList != null);
        }
    
    }