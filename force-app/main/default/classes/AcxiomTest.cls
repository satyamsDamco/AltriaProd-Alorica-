@isTest
public class AcxiomTest {
    
    static testmethod void testAcxiomClasses(){
        
        AcxiomClasses.OpCoQualification aaTest = new AcxiomClasses.OpCoQualification();
        List<AcxiomClasses.OpCoQualification> qIList = new List<AcxiomClasses.OpCoQualification>();
        qIList.add(aaTest);
        AcxiomClasses.QualificationData QAD = new AcxiomClasses.QualificationData();
        QAD.OpCoQualification = qIList;
        
        AcxiomClasses.ContactInfo testcontact = new AcxiomClasses.ContactInfo();
        List<AcxiomClasses.ContactInfo> clist = new List<AcxiomClasses.ContactInfo>();
        clist.add(testcontact);
        AcxiomClasses.AddressType ad = new AcxiomClasses.AddressType();
        ad.ContactInfo = clist;
        
        List<AcxiomClasses.AddressType> adList = new List<AcxiomClasses.AddressType>();
        adList.add(ad);
        
        
        AcxiomClasses.ChannelLevel cl = new AcxiomClasses.ChannelLevel();
        cl.AddressType = adList;
        
        List<AcxiomClasses.ChannelLevel> clSt = new List<AcxiomClasses.ChannelLevel>();
        clSt.add(cl);
        
        AcxiomClasses.Channel cc = new AcxiomClasses.Channel();
        cc.ChannelLevel = clSt;
        
        List<AcxiomClasses.Channel> ccList = new List<AcxiomClasses.Channel>();
        ccList.add(cc);
        
        AcxiomClasses.ChannelData ccData = new AcxiomClasses.ChannelData();
        ccData.Channel = ccList;
        
        AcxiomClasses.Individual inData = new  AcxiomClasses.Individual();
        inData.PID = '1234';
        
        List<AcxiomClasses.AuthenticationData> ad1 = new List<AcxiomClasses.AuthenticationData>();
        
        AcxiomClasses.ConsumerFullSearchResponse fullSrch = new AcxiomClasses.ConsumerFullSearchResponse();
        fullSrch.QualificationData = QAD;
        fullSrch.ChannelData = ccData;
        fullSrch.AuthenticationData = ad1;
        
        AcxiomClasses.CCNLookupResponse cnnSrch = new AcxiomClasses.CCNLookupResponse();
        cnnSrch.QualificationData = QAD;
        cnnSrch.ChannelData = ccData;
		cnnSrch.Individual = inData;
	}
    
    static testmethod void testAcxiomServices(){
        
        IntegrationLog__c iL = new IntegrationLog__c();
        iL = AcxiomServices.getAccessToken();
        
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Test.startTest();
        AcxiomClasses.ConsumerFinalResponse cfr = new AcxiomClasses.ConsumerFinalResponse();
        cfr = AcxiomServices.FullSearchLookupRequest('test', testTM.id, 'test');
        
        AcxiomClasses.CCNLookupFinalResponse ccfr = new AcxiomClasses.CCNLookupFinalResponse();
        ccfr = AcxiomServices.CCNLookupRequest('test', 'test',testTM.id, 'test');
        Test.stopTest();
    }
}