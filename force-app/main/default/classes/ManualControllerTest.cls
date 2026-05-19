@isTest(seeAllData=true)
private class ManualControllerTest {
  
    static testMethod void ManualConstructor() {
        
        ManualFeedFileUploadController mp = new ManualFeedFileUploadController();
        mp.UploadPage();
        mp.option ='Brand Hierarchy';
        mp.UploadPage();
        
        ManualBrandHierarchyUploadController MB = new ManualBrandHierarchyUploadController();
        MB.nameFile = 'test123';
        MB.contentFile = Blob.ValueOf('test123');
        MB.ReadFile();
        MB.brandHierarchyChange();
        
        MB.nameFile = 'test1234';
        MB.contentFile = Blob.ValueOf('test123');
        MB.ReadFile();
        MB.brandHierarchyChange();
        
        
        mp.option ='Issue Hierarchy';
        mp.UploadPage();
        
        ManualIssueHierarchyUploadController MI = new ManualIssueHierarchyUploadController();
        MI.nameFile = 'test123';
        MI.contentFile = Blob.ValueOf('test123');
        MI.ReadFile();
        MI.issueHierarchyChange();
        
        MI.nameFile = 'test1234';
        MI.contentFile = Blob.ValueOf('test123');
        MI.ReadFile();
        MI.issueHierarchyChange();
    }
}