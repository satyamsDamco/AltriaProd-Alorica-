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
12/21/2016 Infogain – Created.
*/

@isTest()
    public class ArticleMappingControllerTest {
        
        static testMethod void ArticleMappingTest1() {
            
            /*
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
            testIH.Cust_Cons_Flag__c='ALL';
            insert testIH;
            
            Natural_Language__c natlangTest=New Natural_Language__c();
            natlangTest.Natural_Language__c='Natural Language';
            insert natlangTest;
            
            //FAQ__kav a1 = new FAQ__kav(Title = 'test apex',Summary = 'test from apex',URLName = 'test-apex');            
            //insert a1;
            
            // 2025-08-22: new line
            Knowledge__kav a1 = new Knowledge__kav( Title = 'test apex', Summary = 'test from apex', UrlName = 'test-apex', Language = 'en_US');
            insert a1;
            
            KnowledgeArticleVersion a = [SELECT KnowledgeArticleId,title FROM KnowledgeArticleVersion WHERE Id = :(Id) a1.get('id')];
            KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);
            
            Natural_Language_Knowledge_Junction__c natlangObj=new Natural_Language_Knowledge_Junction__c();
            natlangObj.Article_ID__c=a.KnowledgeArticleId;
            natlangObj.Natural_Language__c=natlangTest.id;
            natlangObj.Title__c='test apex';
            insert natlangObj;
            
            Natural_Language_Knowledge_Junction__c natlangObj1=new Natural_Language_Knowledge_Junction__c();
            natlangObj1.Article_ID__c=a.KnowledgeArticleId;
            natlangObj1.Natural_Language__c=natlangTest.id;
            natlangObj1.Title__c='test apex1';
            insert natlangObj1;
            
            IHNL_Association__c IHNLTest=New IHNL_Association__c();
            IHNLTest.Issue_Hierarchy__c=testIH.id;
            IHNLTest.Natural_Language__c=natlangTest.id;
            insert IHNLTest;
                        
            ApexPages.currentPage().getParameters().put('id',natlangTest.Id);
            
            Test.startTest();
            ArticleMappingController obj =  new ArticleMappingController(new ApexPages.StandardController(natlangTest));  
            obj.retrieveArticleNumber();
            string x = obj.leftArticleOptionsHidden;
            string y = obj.rightArticleOptionsHidden;
            obj.leftArticleOptionsHidden = natlangObj.id+'&'+natlangObj1.id;
            obj.leftArticleOptionsHidden = natlangObj1.id;
            obj.saveMe();
            obj.cancel();
            Test.stopTest();
            */
            
        }
        
    }