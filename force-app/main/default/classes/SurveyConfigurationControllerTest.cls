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
  Test Class for SurveyConfigurationController Controller
  11/26/2016 Infogain – Created.
   */

//JD: Updated - 3/29/2021
//Description: Corrected all methods to resolve test fail
@isTest
public class SurveyConfigurationControllerTest {
    
    //Test method for pageInit,saveConfiguration,configData.
    
    private static testMethod void pageInitTest(){
        Answer__c testans=TestDataSetup.createAnswer('answer','answerID');
        testans.Active__c=true;
        insert testans;
        Question__c testqustFrom=TestDataSetup.createQuestion('question','questId','ty');
        testqustFrom.Active__c=true;
        insert testqustFrom;
        Question__c testqustTo=TestDataSetup.createQuestion('question1','questId1','ty1');
        testqustTo.Active__c=true;
        insert testqustTo;
        
        Survey__c testSurvey=TestDataSetup.createSurvey('Survey Name');
        insert testSurvey;
        
        Survey_Configuration__c surveyConfig=TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig.Question_Sequence__c=1;
        surveyConfig.Answer_Sequence__c=1;
        surveyConfig.CommentRequired__c=true;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=true;
        ApexPages.currentPage().getParameters().put('id',testSurvey.id);
        ApexPages.CurrentPage().getParameters().put('questionId',testqustFrom.id);
        Test.startTest();
        SurveyConfigurationController controller=new SurveyConfigurationController(new ApexPages.StandardController(surveyConfig));
        controller.pageInit();
        controller.configData();
        List<SelectOption> section = controller.getSection();
        Test.stopTest();
        
    }
    
    //Save Method.
    private static testMethod void saveMethodTest(){

        Answer__c testans=TestDataSetup.createAnswer('answer','answerID');
        testans.Active__c=true;
        insert testans;
        Question__c testqustFrom=TestDataSetup.createQuestion('question','questId','ty');
        testqustFrom.Active__c=true;
        insert testqustFrom;
        Question__c testqustTo=TestDataSetup.createQuestion('question1','questId1','ty1');
        testqustTo.Active__c=true;
        insert testqustTo;
        
        Survey__c testSurvey=TestDataSetup.createSurvey('Survey Name');
        insert testSurvey;
        
        Survey_Configuration__c surveyConfig=TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig.Question_Sequence__c=1;
        surveyConfig.Answer_Sequence__c=1;
        surveyConfig.CommentRequired__c=true;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=true;
        surveyConfig.End_Question__c=true;
        
        ApexPages.currentPage().getParameters().put('id',testSurvey.id);
        ApexPages.CurrentPage().getParameters().put('questionId',testqustFrom.id);
        Test.startTest();
        SurveyConfigurationController controller=new SurveyConfigurationController(new ApexPages.StandardController(surveyConfig));
       	controller.questionRequired = false;
        controller.questionStartQ = false;
        controller.questionSeq = 1;
        controller.pageInit();
        controller.saveConfiguration();
        controller.configData();
        Test.stopTest();
        
    }

    //Test method to cover @Remote Action methods.
    private static testMethod void questionLeftChangeTest(){

        Answer__c testans=TestDataSetup.createAnswer('answer','answerID');
        testans.Answer__c='test';
        testans.Active__c=true;
        insert testans;
        Question__c testqustFrom=TestDataSetup.createQuestion('question','questId','ty');
        testQustFrom.Question__c='TestQuestion';
        testqustFrom.Active__c=true;
        insert testqustFrom;
        Question__c testqustTo=TestDataSetup.createQuestion('question1','questId1','ty1');
        testqustTo.Active__c=true;
        insert testqustTo;
        
        Survey__c testSurvey=TestDataSetup.createSurvey('Survey Name');
        insert testSurvey;
        
        Survey_Configuration__c surveyConfig=TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig.Question_Sequence__c=1;
        surveyConfig.Answer_Sequence__c=1;
        surveyConfig.CommentRequired__c=true;
        surveyConfig.End_Question__c=true;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=true;
        surveyConfig.Answer_Sequence__c=12;
        surveyConfig.CommentRequired__c=true;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=true;
        insert surveyConfig;
        
        Test.startTest();
        SurveyConfigurationController.answerData answrapperTest=new  SurveyConfigurationController.answerData('idval','nameval');
        SurveyConfigurationController.wrapperAnswerSurveyConfig wrapansconfigtest= new SurveyConfigurationController.wrapperAnswerSurveyConfig(surveyConfig,testans);
        SurveyConfigurationController.wrapperAnswerSurveyConfig wrapansconfigtest1= new SurveyConfigurationController.wrapperAnswerSurveyConfig(surveyConfig);
        SurveyConfigurationController controller=new SurveyConfigurationController(new ApexPages.StandardController(testSurvey));
        SurveyConfigurationController.questionLeftChange(testqustFrom.id);
        SurveyConfigurationController.questionRightChange(testqustFrom.id,testSurvey.id);
        SurveyConfigurationController.SelectedAnswerChange(testans.id);
        Test.stopTest();
    }
    
    
    //Test method to cover refreshQuestion,removeConfiguration,deleteAnswer,clear,redirectSurvey.
    private static testMethod void saveMethodTest1(){

        Answer__c testans=TestDataSetup.createAnswer('answer','answerID');
        testans.Active__c=true;
        insert testans;
        Question__c testqustFrom=TestDataSetup.createQuestion('question','questId','ty');
        testqustFrom.Active__c=true;
        testqustFrom.Type__c='Comment';
        insert testqustFrom;
        Question__c testqustTo=TestDataSetup.createQuestion('question1','questId1','ty1');
       
        testqustTo.Active__c=true;
        insert testqustTo;
        Survey__c testSurvey=TestDataSetup.createSurvey('Survey Name');
        insert testSurvey;
        
        Survey_Configuration__c surveyConfig=TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig.Question_Sequence__c=1;
        surveyConfig.Answer_Sequence__c=1;
        surveyConfig.CommentRequired__c=true;
        surveyConfig.End_Question__c=true;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=true;
        surveyConfig.CommentRequired__c=true;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=true;
        surveyConfig.Active__c=true;
        insert surveyConfig;
        ApexPages.currentPage().getParameters().put('id',testSurvey.id);
        ApexPages.CurrentPage().getParameters().put('questionId',testqustFrom.id);
        ApexPages.currentPage().getParameters().put('CongId',surveyConfig.id);

        Test.startTest();
        SurveyConfigurationController controller=new SurveyConfigurationController(new ApexPages.StandardController(surveyConfig));
        controller.questionRequired = false;
        controller.questionStartQ = false;
        controller.questionSeq = 1;
        controller.pageInit();
        controller.configData();
        controller.refreshQuestion();
        controller.removeConfiguration();
        controller.deleteAnswer();
        controller.clear();
        controller.redirectSurvey();
        Test.stopTest();
        
    }

//Test method to cover Survey Configuration.    
     private static testMethod void saveMethodTest2(){

        Answer__c testans=TestDataSetup.createAnswer('answer','answerID');
        testans.Active__c=true;
        insert testans;
        Question__c testqustFrom=TestDataSetup.createQuestion('question','questId','ty');
        testqustFrom.Active__c=true;
        testqustFrom.Type__c='Comment';
        insert testqustFrom;
        Question__c testqustTo=TestDataSetup.createQuestion('question1','questId1','ty1');
       
        testqustTo.Active__c=true;
        insert testqustTo;
        Survey__c testSurvey=TestDataSetup.createSurvey('Survey Name');
        insert testSurvey;
        
        Survey_Configuration__c surveyConfig=TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig.Question_Sequence__c=1;
        surveyConfig.Answer_Sequence__c=1;
        surveyConfig.CommentRequired__c=true;
        surveyConfig.End_Question__c=true;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=true;
        surveyConfig.CommentRequired__c=true;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=true;
        surveyConfig.Active__c=true;
        insert surveyConfig;
        ApexPages.currentPage().getParameters().put('id',testSurvey.id);
        ApexPages.CurrentPage().getParameters().put('questionId',testqustFrom.id);
        ApexPages.currentPage().getParameters().put('confId',surveyConfig.id);

        Test.startTest();
        SurveyConfigurationController controller=new SurveyConfigurationController(new ApexPages.StandardController(surveyConfig));
        controller.questionRequired = false;
        controller.questionStartQ = false;
        controller.questionSeq = 1;
        controller.saveConfiguration();
        SurveyConfigurationController.SelectedAnswerEdit(surveyConfig.id);
        Test.stopTest();
        
    }
	
    // JD: Added 3/29/2021 
    private static testMethod void saveMethodTest3(){

        Answer__c testans=TestDataSetup.createAnswer('answer','answerID');
        testans.Active__c=true;
        insert testans;
        Question__c testqustFrom=TestDataSetup.createQuestion('question','questId','ty');
        testqustFrom.Active__c=true;
        testqustFrom.Type__c='Comment';
        insert testqustFrom;
        Question__c testqustTo=TestDataSetup.createQuestion('question1','questId1','ty1');
        testqustTo.Active__c=true;
        insert testqustTo;
        Survey__c testSurvey=TestDataSetup.createSurvey('Survey Name');
        insert testSurvey;
        
        Survey_Configuration__c surveyConfig=TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig.Question_Sequence__c=1;
        surveyConfig.Answer_Sequence__c=1;
        surveyConfig.CommentRequired__c=false;
        surveyConfig.End_Question__c=false;
        surveyConfig.Question_Required__c=true;
        surveyConfig.Starting_Question__c=false;
        surveyConfig.CommentRequired__c=false;
        surveyConfig.Starting_Question__c=true;
        surveyConfig.Active__c=true;
        insert surveyConfig;
        ApexPages.currentPage().getParameters().put('id',testSurvey.id);
        ApexPages.CurrentPage().getParameters().put('questionId',testqustFrom.id);
        ApexPages.currentPage().getParameters().put('confId',surveyConfig.id);

        Test.startTest();
        SurveyConfigurationController controller=new SurveyConfigurationController(new ApexPages.StandardController(surveyConfig));
        controller.questionRequired = false;
        controller.questionStartQ = false;
        controller.questionSeq = 1;
		controller.saveConfiguration();
        controller.newSurveyCong = surveyConfig;
        controller.congId = surveyConfig.id;
        controller.saveConfiguration();
        Test.stopTest();
        
    }

    // JD: Added 7/2/2026
    // Covers: configData() else branch (no questionId param), "Please enter Question Section"
    // validation branch (Survey.Section__c = true, questionSection blank), and the
    // removeConfiguration() true branch (deactivating an existing active configuration).
    private static testMethod void saveMethodTest4(){

        Answer__c testans = TestDataSetup.createAnswer('answer','answerID');
        testans.Active__c = true;
        insert testans;
        Question__c testqustFrom = TestDataSetup.createQuestion('question','questId','ty');
        testqustFrom.Active__c = true;
        insert testqustFrom;
        Question__c testqustTo = TestDataSetup.createQuestion('question1','questId1','ty1');
        testqustTo.Active__c = true;
        insert testqustTo;

        Survey__c testSurvey = TestDataSetup.createSurvey('Survey Name');
        testSurvey.Section__c = true;
        insert testSurvey;

        Survey_Configuration__c surveyConfig = TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig.Question_Sequence__c = 1;
        surveyConfig.Answer_Sequence__c = 1;
        surveyConfig.CommentRequired__c = true;
        surveyConfig.Question_Required__c = true;
        surveyConfig.Starting_Question__c = true;
        surveyConfig.Section__c = '1';
        surveyConfig.Active__c = true;
        insert surveyConfig;

        ApexPages.currentPage().getParameters().put('id',testSurvey.id);
        //Intentionally not setting the 'questionId' param here so configData() hits its else branch

        Test.startTest();
        SurveyConfigurationController controller = new SurveyConfigurationController(new ApexPages.StandardController(surveyConfig));
        controller.configData();

        //Covers the "Please enter Question Section" validation message
        controller.questionRequired = false;
        controller.questionStartQ = false;
        controller.questionSeq = 1;
        controller.questionSection = null;
        controller.newSurveyCong = new Survey_Configuration__c();
        controller.saveConfiguration();

        //Covers removeConfiguration() true branch - deactivating an existing active config
        controller.SelectedQuestionRight = testqustFrom.id;
        controller.removeConfiguration();
        Test.stopTest();
    }

    // JD: Added 7/2/2026
    // Covers the saveConfiguration() update-path loop that syncs sibling
    // Survey_Configuration__c records sharing the same QuestionFrom__c
    // (sequence / required / starting question / section change detection).
    private static testMethod void saveMethodTest5(){

        Answer__c testans = TestDataSetup.createAnswer('answer','answerID');
        testans.Active__c = true;
        insert testans;
        Question__c testqustFrom = TestDataSetup.createQuestion('question','questId','ty');
        testqustFrom.Active__c = true;
        insert testqustFrom;
        Question__c testqustTo = TestDataSetup.createQuestion('question1','questId1','ty1');
        testqustTo.Active__c = true;
        insert testqustTo;

        Survey__c testSurvey = TestDataSetup.createSurvey('Survey Name');
        testSurvey.Section__c = true;
        insert testSurvey;

        Survey_Configuration__c surveyConfig1 = TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig1.Question_Sequence__c = 1;
        surveyConfig1.Answer_Sequence__c = 1;
        surveyConfig1.CommentRequired__c = true;
        surveyConfig1.Question_Required__c = false;
        surveyConfig1.Starting_Question__c = false;
        surveyConfig1.Section__c = '1';
        surveyConfig1.Active__c = true;
        insert surveyConfig1;

        Survey_Configuration__c surveyConfig2 = TestDataSetup.createSurveyConfig(testSurvey,testqustFrom,testans,testqustTo);
        surveyConfig2.Question_Sequence__c = 2;
        surveyConfig2.Answer_Sequence__c = 2;
        surveyConfig2.CommentRequired__c = false;
        surveyConfig2.Question_Required__c = false;
        surveyConfig2.Starting_Question__c = false;
        surveyConfig2.Section__c = '2';
        surveyConfig2.Active__c = true;
        insert surveyConfig2;

        ApexPages.currentPage().getParameters().put('id',testSurvey.id);
        ApexPages.CurrentPage().getParameters().put('questionId',testqustFrom.id);

        Test.startTest();
        SurveyConfigurationController controller = new SurveyConfigurationController(new ApexPages.StandardController(surveyConfig1));
        //Values deliberately differ from surveyConfig2 so the sibling-sync loop in
        //saveConfiguration() detects changes on every field it checks.
        controller.questionRequired = true;
        controller.questionStartQ = true;
        controller.questionSeq = 5;
        controller.questionSection = '3';
        controller.congId = surveyConfig1.id;
        controller.newSurveyCong = surveyConfig1;
        controller.saveConfiguration();
        Test.stopTest();
    }

}