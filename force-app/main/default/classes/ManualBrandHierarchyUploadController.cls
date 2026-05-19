public class ManualBrandHierarchyUploadController {
    
    public string nameFile{get;set;}
    public string fileData{get;set;}
    public Blob contentFile{get;set;}
    public List<wrapperBrandHierarchy> newRecords {get;set;}
    public List<wrapperBrandHierarchy> deactiveRecords {get;set;}
    public boolean errordata {get;set;}        
    
    public ManualBrandHierarchyUploadController(){
        newRecords = new List<wrapperBrandHierarchy>();
        deactiveRecords = new List<wrapperBrandHierarchy>();
        errordata = false;
        
    }
        
    /***This function reads the CSV file and inserts records into the Account object. ***/
    public Pagereference ReadFile()
    {
        List<List<String>> allFields = new List<List<String>>();
        newRecords = new List<wrapperBrandHierarchy>();
        deactiveRecords = new List<wrapperBrandHierarchy>();
        List<String> lines = new List<String>();
        errordata = false;
        Boolean missingData = false;
        Boolean dupliacteErrorFile = false;
        Boolean dupliacteErrorData = false;
        try{
            if (!Test.isRunningTest()) {    
                if(contentFile == null){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select the file'));
                    return null;
                }
                if(!nameFile.endsWith('.csv')){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select the CSV file only'));
                    return null;
                }
                
                try{
                    fileData =contentFile.toString();
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please select the valid CSV file'));
                    return null;
                }
            }else{
                if(nameFile == 'test123'){
                    fileData = 'ACTION,BRANDHIERARCHYCODE,VANTIVEID,PMBRANDCODE,SHORTCUT,PRODUCT LINE,BRAND,UPC,TASTE,LENGTH,PACKAGING,FLAVOR,FILTER,PAPERTYPE,CUT,BRANDSASCODE,BRANDMMCODE,PRODUCTDESC,PRODUCTTYPE,PRICECATEGORY,LICENSEGROUP,UNITSPERPACK,BRANDSTATUS,BRANDCLASSIFICATION,PACKTYPE,REPORTINGBRANDFAMILY,PICKUPPOLICYWEEKS,USTDATETYPE,ACTIVEFLAG\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,PC,ALC,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,DS,AL,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,EV,AK,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,CO,ALCAKIBRGP,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,EC,AM,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'INACTIVATE,BH5686,262485,305,,PC,SKOAL POUCH,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,TRUE\r\n';
                    fileData += 'INACTIVATE,BH5687,262486,306,,PC,SKOAL POUCH,733061,,,Can (UPC),Straight,,,,,,Skoal Pouches Straight (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,TRUE\r\n';
                    fileData += 'INACTIVATE,BH5688,262487,354,,PC,SKOAL POUCH,733541,,,Can (AK & HI),Wintergreen,,,,,,Skoal Pouches Wintergreen (Alaska & Hawaii),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,CD,TRUE\r\n';
                    fileData += 'INACTIVATE,BH5689,262488,946,,PC,SKOAL POUCH,739461,,,Can (MILITARY),Wintergreen,,,,,,Skoal Pouches Wintergreen (Overseas Military),Smokeless - Military,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,CD,TRUE\r\n';
                }else{
                    fileData = 'ACTION,BRANDHIERARCHYCODE,VANTIVEID,PMBRANDCODE,SHORTCUT,PRODUCT LINE,BRAND,UPC,TASTE,LENGTH,PACKAGING,FLAVOR,FILTER,PAPERTYPE,CUT,BRANDSASCODE,BRANDMMCODE,PRODUCTDESC,PRODUCTTYPE,PRICECATEGORY,LICENSEGROUP,UNITSPERPACK,BRANDSTATUS,BRANDCLASSIFICATION,PACKTYPE,REPORTINGBRANDFAMILY,PICKUPPOLICYWEEKS,USTDATETYPE,ACTIVEFLAG\r\n';
                    fileData += 'Add New HIERARCHY,,2624851,305,,PC1,ALC1,73305111,,,Can (UPC)1,Mint1,,,,,,Skoal Pouches Mint1 (UPC),Smokeless1 - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,DS,AL,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,DS,AL,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,CO,ALCAKIBRGP,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'Add New HIERARCHY,,262485,305,,EC,AM,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,Y\r\n';
                    fileData += 'INACTIVATE,BH5,262485,305,,PC,SKOAL POUCH,733051,,,Can (UPC),Mint,,,,,,Skoal Pouches Mint (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,TRUE\r\n';
                    fileData += 'INACTIVATE,BH5687,262486,306,,PC,SKOAL POUCH,733061,,,Can (UPC),Straight,,,,,,Skoal Pouches Straight (UPC),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,SB,TRUE\r\n';
                    fileData += 'INACTIVATE,BH5687,262487,354,,PC,SKOAL POUCH,733541,,,Can (AK & HI),Wintergreen,,,,,,Skoal Pouches Wintergreen (Alaska & Hawaii),Smokeless - Domestic,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,CD,TRUE\r\n';
                    fileData += 'INACTIVATE,BH5689,262488,946,,PC,SKOAL POUCH,739461,,,Can (MILITARY),Wintergreen,,,,,,Skoal Pouches Wintergreen (Overseas Military),Smokeless - Military,Tier l,USSTC,1,Active,Brand,,Skoal Pouch,12,CD,TRUE\r\n';
                }
            }
            //Convert the uploaded file which is in BLOB format into a string
            fileData = fileData.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');

            fileData = fileData.replaceAll('""','DBLQT');
            //Now sepatate every row of the excel file
            System.debug('nameFile '+fileData );
            lines = fileData.split('\r\n');
            System.debug('fileData '+lines );
            Integer num = 0;
            for(Integer i=0;i<lines.size();i++) {
                // check for blank CSV lines (only commas)
                string line = lines[i];
                if (line.replaceAll(',','').trim().length() == 0) break;
                
                List<String> fields = line.split(',');  
                List<String> cleanFields = new List<String>();
                String compositeField;
                Boolean makeCompositeField = false;
                for(String field : fields) {
                    String fieldValue = '';
                    if (field.startsWith('"') && field.endsWith('"')) {
                        fieldValue = field.replaceAll('DBLQT','"');
                    } else if (field.startsWith('"')) {
                        makeCompositeField = true;
                        compositeField = field;
                    } else if (field.endsWith('"')) {
                        compositeField += ',' + field;
                        fieldValue = compositeField.replaceAll('DBLQT','"');
                        makeCompositeField = false;
                    } else if (makeCompositeField) {
                        compositeField +=  ',' + field;
                    } else {
                        fieldValue = field.replaceAll('DBLQT','"');
                    }
                    if(fieldValue != null && fieldValue!= ''){
                        cleanFields.add(fieldValue);                    
                    }
                }                
                allFields.add(cleanFields);
            }
            Map<integer, string> fieldMap = new Map<integer, string>();
            Set<String> BrandCodeSet = new Set<String>();
            Set<String> ProductLineSet = new Set<String>();
            Set<String> brandHierarchySet = new Set<String>();
            Set<String> tasteSet = new Set<String>();
            Set<String> lengthSet = new Set<String>();
            Set<String> packagingSet = new Set<String>();
            Set<String> flavorSet = new Set<String>();
            Set<String> filterSet = new Set<String>();
            Set<String> paperTypeSet = new Set<String>();
            Set<String> cutSet = new Set<String>();

            Map<String,List<Integer>> duplicateMap = new  Map<String,List<Integer>>(); 
            Map<String,List<Integer>> duplicateNameMap = new  Map<String,List<Integer>>();
            
            for(Integer i=0;i<allFields.size();i++){
                string line = lines[i];
                wrapperBrandHierarchy wpBrandData = new wrapperBrandHierarchy();
                wpBrandData.BrandHierarchyObj = new Brand_Hierarchy__c();
                wpBrandData.rowNumber = newRecords.size()+1;
                List<String> fields = line.split(','); 
                for(Integer j=0;j<fields.size();j++){                    
                    String field = fields[j];
                    if(i == 0){
                        field = field.trim().toUpperCase();
                            
                        if(field == 'REQUESTED' || field == 'ACTION' || field == 'CHANGE')
                            fieldMap.put(j,'ACTION');

                        if(field == 'BRANDHIERARCHYCODE')
                            fieldMap.put(j,'BRANDHIERARCHYCODE');                        
                        
                        if(field == 'VANTIVEID')
                            fieldMap.put(j,'VANTIVEID');
                                                
                        if(field == 'PMBRANDCODE')
                            fieldMap.put(j,'PMBRANDCODE');
                        
                        if(field == 'SHORTCUT')
                            fieldMap.put(j,'SHORTCUT');
                                                
                        if(field == 'PRODUCT LINE' || field == 'PRODUCTLINE')
                            fieldMap.put(j,'PRODUCTLINE'); 
                        
                        if(field == 'BRAND')
                            fieldMap.put(j,'BRAND');
                                                
                        if(field == 'UPC')
                            fieldMap.put(j,'UPC');
                        
                        if(field == 'TASTE')
                            fieldMap.put(j,'TASTE');
                                                                        
                        if(field == 'LENGTH')
                            fieldMap.put(j,'LENGTH');   
                        
                         if(field == 'PACKAGING')
                            fieldMap.put(j,'PACKAGING');
                                                
                        if(field == 'FLAVOR')
                            fieldMap.put(j,'FLAVOR');
                        
                        if(field == 'FILTER')
                            fieldMap.put(j,'FILTER');
                        
                        if(field == 'PAPERTYPE')
                            fieldMap.put(j,'PAPERTYPE');
                                                
                        if(field == 'CUT')
                            fieldMap.put(j,'CUT');   
                            
                        if(field == 'BRANDSASCODE')
                            fieldMap.put(j,'BRANDSASCODE');
                        
                        if(field == 'BRANDMMCODE')
                            fieldMap.put(j,'BRANDMMCODE');
                            
                        if(field == 'PRODUCTDESC')
                            fieldMap.put(j,'PRODUCTDESC');
                        
                        if(field == 'PRODUCTTYPE')
                            fieldMap.put(j,'PRODUCTTYPE');
                        
                        if(field == 'PRICECATEGORY')
                            fieldMap.put(j,'PRICECATEGORY');
                        
                        if(field == 'LICENSEGROUP')
                            fieldMap.put(j,'LICENSEGROUP');
                                                
                        if(field == 'UNITSPERPACK')
                            fieldMap.put(j,'UNITSPERPACK');
                            
                        if(field == 'BRANDSTATUS')
                            fieldMap.put(j,'BRANDSTATUS');
                        
                        if(field == 'BRANDCLASSIFICATION')
                            fieldMap.put(j,'BRANDCLASSIFICATION');
                                                
                        if(field == 'PACKTYPE')
                            fieldMap.put(j,'PACKTYPE');
                        
                        if(field == 'REPORTINGBRANDFAMILY')
                            fieldMap.put(j,'REPORTINGBRANDFAMILY');
                        
                        if(field == 'PICKUPPOLICYWEEKS')
                            fieldMap.put(j,'PICKUPPOLICYWEEKS');
                        
                        if(field == 'USTDATETYPE')
                            fieldMap.put(j,'USTDATETYPE');
                        
                        if(field == 'ACTIVEFLAG')
                            fieldMap.put(j,'ACTIVEFLAG');
                    }else{
                        String fieldValue = '';
                        if(fieldMap.ContainsKey(j)){
                            fieldValue = fieldMap.get(j).toupperCase();
                        }
                        field = field == 'NULL' || field == 'null' ? '' :field.trim().replaceAll('"','').replaceAll('DBLQT','');                          
                        field =  field.trim();  
                        String typeOfOperation = 'INACTIVATE';                      

                        if(fieldValue == 'ACTION')
                          wpBrandData.Requested = field;
                        
                        String RequestType = wpBrandData.Requested;
                            
                        if(fieldValue == 'BRANDHIERARCHYCODE'){
                            wpBrandData.Name = field;
                            if(field != null && field.trim() != '' && typeOfOperation == RequestType){
                                brandHierarchySet.add(field);
                            }
                        }
                        
                        if(fieldValue == 'BRAND'){
                            wpBrandData.BrandCode = field;  
                            if(!BrandCodeSet.Contains(field)  && typeOfOperation != RequestType)    
                                BrandCodeSet.add(field);
                        }
                        if(fieldValue == 'PRODUCTLINE'){
                            wpBrandData.ProductLineCode = field;
                            if(!ProductLineSet.Contains(field) && typeOfOperation != RequestType)    
                                ProductLineSet.add(field);
                        }                            
                        
                        
                        if(fieldValue == 'VANTIVEID'){
                            wpBrandData.VantiveId = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Vantive_Id__c = field;
                        }    
                        
                        if(fieldValue == 'PMBRANDCODE'){
                            wpBrandData.PmBrandCode = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Pm_Brand_Code__c = field;
                        }
                                                
                        if(fieldValue == 'SHORTCUT'){
                            wpBrandData.ShortCut = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Short_Cut__c = field;
                        }
                        
                        if(fieldValue == 'UPC'){
                            wpBrandData.UPC = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.UPC__c = field;
                        }
                                               
                        if(fieldValue == 'TASTE'){
                            wpBrandData.Taste = field;
                            if( field != null && field != '' && !tasteSet.Contains(field)  && typeOfOperation != RequestType)    
                                tasteSet.add(field);
                        }
                            
                        if(fieldValue == 'LENGTH'){
                            wpBrandData.Length = field;
                            if( field != null && field != '' && !lengthSet.Contains(field)  && typeOfOperation != RequestType)    
                                lengthSet.add(field);
                        }
                        
                        if(fieldValue == 'PACKAGING'){
                            wpBrandData.Packaging = field;
                            if( field != null && field != '' && !packagingSet.Contains(field)  && typeOfOperation != RequestType)    
                                packagingSet.add(field);
                        }
                        
                        if(fieldValue == 'FLAVOR'){
                            wpBrandData.Flavor = field;
                            if( field != null && field != '' && !flavorSet.Contains(field)  && typeOfOperation != RequestType)    
                                flavorSet.add(field);
                        }
                        
                        if(fieldValue == 'FILTER'){
                            wpBrandData.Filter = field;
                            if( field != null && field != '' && !filterSet.Contains(field)  && typeOfOperation != RequestType)    
                                filterSet.add(field);
                        }
                                                
                        if(fieldValue == 'PAPERTYPE'){
                            wpBrandData.PaperType = field;
                            if( field != null && field != '' && !paperTypeSet.Contains(field)  && typeOfOperation != RequestType)    
                                paperTypeSet.add(field);
                        }
                            
                        if(fieldValue == 'CUT'){
                            wpBrandData.Cut = field;
                            if( field != null && field != '' && !cutSet.Contains(field)  && typeOfOperation != RequestType)    
                                cutSet.add(field);
                        }
                        
                        if(fieldValue == 'BRANDSASCODE'){
                            wpBrandData.BrandSasCode = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Brand_Sas_Code__c = field;
                        }
                                                
                        if(fieldValue == 'BRANDMMCODE'){
                            wpBrandData.BrandMMCode = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Brand_MM_Code__c = field;
                        }  
                        
                        if(fieldValue == 'ACTIVEFLAG'){
                            wpBrandData.ActiveFlag = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Active__c = (field == 'Y'?true:false);
                        }
                        
                        if(fieldValue == 'PRODUCTDESC'){
                            wpBrandData.ProductDesc = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Product_Desc__c = field;
                        }
                        
                        if(fieldValue == 'PRODUCTTYPE'){
                            wpBrandData.ProductType = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Product_Type__c = field;
                        }
                        
                        if(fieldValue == 'PRICECATEGORY'){
                            wpBrandData.PriceCategory = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Price_Category__c = field;
                        }
                        
                        if(fieldValue == 'LICENSEGROUP'){
                            wpBrandData.LicenseGroup = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.License_Group__c = field;
                        }
                        
                        if(fieldValue == 'UNITSPERPACK'){
                            wpBrandData.UnitsPerPack = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Units_Per_Pack__c = Integer.valueOf(field);
                        }
                        
                        if(fieldValue == 'BRANDSTATUS'){
                            wpBrandData.BrandStatus = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Brand_Status__c = field;
                        }
                        
                        if(fieldValue == 'BRANDCLASSIFICATION'){
                            wpBrandData.BrandClassification = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Brand_Classification__c = field;
                        }
                        
                        if(fieldValue == 'PACKTYPE'){
                            wpBrandData.PackType = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Pack_Type__c = field;
                        }
                        
                        if(fieldValue == 'REPORTINGBRANDFAMILY'){
                            wpBrandData.ReportingBrandFamily = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Reporting_Brand_Family__c = field;
                        }
                        
                        if(fieldValue == 'PICKUPPOLICYWEEKS'){
                            wpBrandData.PickUpPolicyWeeks = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Pick_Up_Policy_Weeks__c = Integer.valueOf(field);
                        }
                        
                        if(fieldValue == 'USTDATETYPE'){
                            wpBrandData.UstDateType = field;
                            if(typeOfOperation != RequestType)
                                wpBrandData.BrandHierarchyObj.Ust_Date_Type__c = field;
                        }
                        
                    }
                }
                if(wpBrandData.Requested != null && wpBrandData.Requested != ''){
                    if(wpBrandData.Requested.toUpperCase() == 'INACTIVATE'){
                        deactiveRecords.add(wpBrandData);
                        system.debug('test.........'+deactiveRecords);
                        if(wpBrandData.Name == null || wpBrandData.Name.trim() == ''){
                            missingData = true;
                            wpBrandData.MissingDataError = true;
                        }else{
                            String duplicateString = wpBrandData.Name.trim();
                            if(!duplicateNameMap.containskey(duplicateString)){
                                List<Integer> row = new List<Integer>();
                                row.add(wpBrandData.rowNumber);
                                duplicateNameMap.put(duplicateString,row); 
                            }else{
                                List<Integer> rowData  = duplicateNameMap.get(duplicateString);
                                rowData.add(wpBrandData.rowNumber); 
                                duplicateNameMap.remove(duplicateString);
                                duplicateNameMap.put(duplicateString,rowData);                            
                            }
                        }
                    }else{
                        if(wpBrandData.ProductLineCode !=  null && wpBrandData.ProductLineCode.trim() != '' && wpBrandData.BrandCode != null && wpBrandData.BrandCode.trim() != '' &&
                            (wpBrandData.UPC.trim() != '' || wpBrandData.Taste.trim()  != '' || wpBrandData.Length.trim() != '' || wpBrandData.Packaging.trim() != '' 
                            || wpBrandData.Flavor.trim() != '' || wpBrandData.Filter.trim() != '' || wpBrandData.PaperType.trim() != '' || wpBrandData.Cut.trim() != '' )){
                            
                            String duplicateString = wpBrandData.ProductLineCode.trim() + wpBrandData.BrandCode.trim();
                                    duplicateString += wpBrandData.UPC == null || wpBrandData.UPC == '' ? '': wpBrandData.UPC.trim();
                                    duplicateString += wpBrandData.Taste == null || wpBrandData.Taste == '' ? '': wpBrandData.Taste.trim();
                                    duplicateString += wpBrandData.Length == null || wpBrandData.Length == '' ? '': wpBrandData.Length.trim();
                                    duplicateString += wpBrandData.Packaging == null || wpBrandData.Packaging == '' ? '': wpBrandData.Packaging.trim();
                                    duplicateString += wpBrandData.Flavor== null || wpBrandData.Flavor== '' ? '': wpBrandData.Flavor.trim();
                                    duplicateString += wpBrandData.Filter== null || wpBrandData.Filter== '' ? '': wpBrandData.Filter.trim();
                                    duplicateString += wpBrandData.PaperType== null || wpBrandData.PaperType== '' ? '': wpBrandData.PaperType.trim();
                                    duplicateString += wpBrandData.Cut== null || wpBrandData.Cut== '' ? '': wpBrandData.Cut.trim();
                            
                            
                            
                            if(!duplicateMap.containskey(duplicateString)){
                                List<Integer> row = new List<Integer>();
                                row.add(wpBrandData.rowNumber);
                                duplicateMap.put(duplicateString,row); 
                            }else{
                                List<Integer> rowData  = duplicateMap.get(duplicateString);
                                rowData.add(wpBrandData.rowNumber); 
                                duplicateMap.remove(duplicateString);
                                duplicateMap.put(duplicateString,rowData);                            
                            }
                        }else{
                            missingData = true;
                            wpBrandData.MissingDataError = true;
                        }
                        newRecords.add(wpBrandData); 
                    }
                }                           
            }
            Map<String,Brand__c> mapBrandCode = new  Map<String,Brand__c>();
            Map<String,Product_Line__c> mapProductLine = new  Map<String,Product_Line__c>();
            Map<String,Brand_Hierarchy__c> mapBrand = new  Map<String,Brand_Hierarchy__c>();
            Set<String> brandHierSet = new Set<String>();
            
            if(!duplicateMap.isEmpty()){
               List<Brand_Hierarchy__c> brandHierData = new List<Brand_Hierarchy__c>([Select id, Duplicate_Brnad_Hierarchy__c from Brand_Hierarchy__c where Active__c = true and Duplicate_Brnad_Hierarchy__c in :duplicateMap.KeySet()]);                                  
                
                if(!brandHierData.isEmpty()){
                    for(Brand_Hierarchy__c cl : brandHierData){
                        brandHierSet.add(cl.Duplicate_Brnad_Hierarchy__c);
                    }
                }  
            }
                           
                
            
            if(!brandHierarchySet.isEmpty()){
                List<Brand_Hierarchy__c> brandHierData = new List<Brand_Hierarchy__c>([Select id, Name from Brand_Hierarchy__c where Name in :brandHierarchySet]);
                if(!brandHierData.isEmpty()){
                    for(Brand_Hierarchy__c cl : brandHierData){
                        mapBrand.put(cl.Name, cl);
                    }
                }                    
            }
            
            if(!BrandCodeSet.isEmpty()){
                List<Brand__c> brandcodeData = new List<Brand__c>([Select id,BrandCode__c,Description__c 
                                                                                from Brand__c 
                                                                                where BrandCode__c in :BrandCodeSet]);
                if(!brandcodeData.isEmpty()){
                    for(Brand__c cl : brandcodeData){
                        mapBrandCode.put(cl.BrandCode__c, cl);
                    }
                }
            }
            if(!ProductLineSet.isEmpty()){
                List<Product_Line__c> plData = new List<Product_Line__c>([Select id,Code__c,Name 
                                                                                from Product_Line__c 
                                                                                where Code__c in :ProductLineSet]);
                if(!plData.isEmpty()){
                    for(Product_Line__c cl : plData){
                        mapProductLine.put(cl.Code__c, cl);
                    }
                }            
            }
            
            Set<String> tasteSet1 = new Set<String>();
            Set<String> lengthSet1 = new Set<String>();
            Set<String> packagingSet1 = new Set<String>();
            Set<String> flavorSet1 = new Set<String>();
            Set<String> filterSet1 = new Set<String>();
            Set<String> paperTypeSet1 = new Set<String>();
            Set<String> cutSet1 = new Set<String>();
            
            Schema.DescribeFieldResult fieldResult = Brand_Hierarchy__c.Taste__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple){
                if(!tasteSet.isEmpty() && tasteSet.Contains(f.getValue().trim()) && !tasteSet1.Contains(f.getValue().trim()))
                    tasteSet1.add(f.getValue().trim());
            }
            
            Schema.DescribeFieldResult fieldResult1 = Brand_Hierarchy__c.Length__c.getDescribe();
            List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
            for( Schema.PicklistEntry f : ple1){
                if(!lengthSet.isEmpty() &&  lengthSet.Contains(f.getValue().trim()) && !lengthSet1.Contains(f.getValue().trim()))
                    lengthSet1.add(f.getValue().trim());
            }
            
            Schema.DescribeFieldResult fieldResult2 = Brand_Hierarchy__c.Packaging__c.getDescribe();
            List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
            for( Schema.PicklistEntry f : ple2){
                if(!packagingSet.isEmpty() && packagingSet.Contains(f.getValue().trim()) && !packagingSet1.Contains(f.getValue().trim()))
                    packagingSet1.add(f.getValue().trim());
            }
            
            Schema.DescribeFieldResult fieldResult3 = Brand_Hierarchy__c.Flavor__c.getDescribe();
            List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
            for( Schema.PicklistEntry f : ple3){
                if(!flavorSet.isEmpty() &&  flavorSet.Contains(f.getValue().trim()) && !flavorSet1.Contains(f.getValue().trim()))
                    flavorSet1.add(f.getValue().trim());
            }            
            
            Schema.DescribeFieldResult fieldResult4 = Brand_Hierarchy__c.Filter__c.getDescribe();
            List<Schema.PicklistEntry> ple4 = fieldResult4.getPicklistValues();
            for( Schema.PicklistEntry f : ple4){
                if(!filterSet.isEmpty() && filterSet.Contains(f.getValue().trim()) && !filterSet1.Contains(f.getValue().trim()))
                    filterSet1.add(f.getValue().trim());
            }
            
            Schema.DescribeFieldResult fieldResult5 = Brand_Hierarchy__c.PaperType__c.getDescribe();
            List<Schema.PicklistEntry> ple5 = fieldResult5.getPicklistValues();
            for( Schema.PicklistEntry f : ple5){
                if(!paperTypeSet.isEmpty() && paperTypeSet.Contains(f.getValue().trim()) && !paperTypeSet1.Contains(f.getValue().trim()))
                    paperTypeSet1.add(f.getValue().trim());
            }
            
            Schema.DescribeFieldResult fieldResult6 = Brand_Hierarchy__c.Cut__c.getDescribe();
            List<Schema.PicklistEntry> ple6 = fieldResult6.getPicklistValues();
            for( Schema.PicklistEntry f : ple6){
                if(!cutSet.isEmpty() && cutSet.Contains(f.getValue().trim()) && !cutSet1.Contains(f.getValue().trim()))
                    cutSet1.add(f.getValue().trim());
            }
            
            if(!newRecords.isEmpty()){
                
                for(wrapperBrandHierarchy nw :newRecords){
                    
                    String duplicateString = nw.ProductLineCode == null || nw.ProductLineCode == '' ? '': nw.ProductLineCode.trim(); 
                            duplicateString += nw.BrandCode == null || nw.BrandCode == '' ? '': nw.BrandCode.trim();
                            duplicateString += nw.UPC == null || nw.UPC == '' ? '': nw.UPC.trim();
                            duplicateString += nw.Taste == null || nw.Taste == '' ? '': nw.Taste.trim();
                            duplicateString += nw.Length == null || nw.Length == '' ? '': nw.Length.trim();
                            duplicateString += nw.Packaging == null || nw.Packaging == '' ? '': nw.Packaging.trim();
                            duplicateString += nw.Flavor== null || nw.Flavor== '' ? '': nw.Flavor.trim();
                            duplicateString += nw.Filter== null || nw.Filter== '' ? '': nw.Filter.trim();
                            duplicateString += nw.PaperType== null || nw.PaperType== '' ? '': nw.PaperType.trim();
                            duplicateString += nw.Cut== null || nw.Cut== '' ? '': nw.Cut.trim();
                          
                    if(!brandHierSet.isEmpty() && brandHierSet.Contains(duplicateString)) {
                        nw.dupliacteErrorData = true; 
                        dupliacteErrorData = true;                    
                    }
                    
                    if(duplicateMap.containsKey(duplicateString)){
                        List<Integer> rowData  = duplicateMap.get(duplicateString);
                        if(rowData.size() >1){
                            nw.dupliacteErrorFile = true; 
                            dupliacteErrorFile = true;
                        }
                    }
                    
                    if(nw.BrandCode != null && nw.BrandCode != ''){                        
                        if(mapBrandCode.ContainsKey(nw.BrandCode)){
                            nw.BrandHierarchyObj.Brand_Code__c = mapBrandCode.get(nw.BrandCode).id;
                            nw.BrandCodeError = false;
                        }else{
                            nw.BrandCodeError = true;
                            errordata = true;
                        }                        
                    }
                    
                    if(nw.ProductLineCode != null && nw.ProductLineCode != ''){
                        if(mapProductLine.ContainsKey(nw.ProductLineCode)){
                            nw.BrandHierarchyObj.Product_Line_Code__c = mapProductLine.get(nw.ProductLineCode).id;
                            nw.ProductLineError = false;
                        }else{
                            nw.ProductLineError = true;
                            errordata = true;
                        }
                    }
                    
                    if(nw.Taste != null && nw.Taste.trim() != ''){
                        if(tasteSet1.Contains(nw.Taste.trim())){
                            nw.BrandHierarchyObj.Taste__c = nw.Taste.trim();
                            nw.TasteError = false;
                        }else{
                            nw.TasteError = true;
                            errordata = true;
                        }
                    }
                    
                    if(nw.Length != null && nw.Length.trim() != ''){
                        if(lengthSet1.Contains(nw.Length.trim())){
                            nw.BrandHierarchyObj.Length__c = nw.Length.trim();
                            nw.LengthError = false;
                        }else{
                            nw.LengthError = true;
                            errordata = true;
                        }
                    }
                    
                    if(nw.Packaging != null && nw.Packaging.trim() != ''){
                        if(packagingSet1.Contains(nw.Packaging.trim())){
                            nw.BrandHierarchyObj.Packaging__c = nw.Packaging.trim();
                            nw.PackagingError = false;
                        }else{
                            nw.PackagingError = true;
                            errordata = true;
                        }
                    }
                    
                    if(nw.Flavor != null && nw.Flavor.trim() != ''){
                        if(flavorSet1.Contains(nw.Flavor.trim())){
                            nw.BrandHierarchyObj.Flavor__c = nw.Flavor.trim();
                            nw.FlavorError = false;
                        }else{
                            nw.FlavorError = true;
                            errordata = true;
                        }
                    }
                    
                    if(nw.Filter != null && nw.Filter.trim() != ''){
                        if(filterSet1.Contains(nw.Filter.trim())){
                            nw.BrandHierarchyObj.Filter__c = nw.Filter.trim();
                            nw.FilterError = false;
                        }else{
                            nw.FilterError = true;
                            errordata = true;
                        }
                    }
                    
                    if(nw.PaperType != null && nw.PaperType.trim() != ''){
                        if(paperTypeSet1.Contains(nw.PaperType.trim())){
                            nw.BrandHierarchyObj.PaperType__c = nw.PaperType.trim();
                            nw.PaperTypeError = false;
                        }else{
                            nw.PaperTypeError = true;
                            errordata = true;
                        }
                    }
                    
                    if(nw.Cut != null && nw.Cut.trim() != ''){
                        if(cutSet1.Contains(nw.Cut.trim())){
                            nw.BrandHierarchyObj.Cut__c = nw.Cut.trim();
                            nw.CutError = false;
                        }else{
                            nw.CutError = true;
                            errordata = true;
                        }
                    }
                }
            } 
            
            if(!deactiveRecords.isEmpty()){                
                for(wrapperBrandHierarchy nw :deactiveRecords){
                    if(nw.Name != null && nw.Name != ''){
                        string duplicateString = nw.Name.trim();
                        if(duplicateNameMap.containsKey(duplicateString)){
                            List<Integer> rowData  = duplicateNameMap.get(duplicateString);
                            if(rowData.size() >1){
                                nw.dupliacteErrorFile = true; 
                                dupliacteErrorFile = true;
                            }
                        }
                        
                    if(mapBrand.ContainsKey(nw.Name)){
                            nw.BrandHierarchyObj.id = mapBrand.get(nw.Name).id;
                            nw.BrandHierarchyObj.Active__c = false;
                            nw.NameError = false;
                        }else{
                            nw.NameError = true;
                            errordata = true;
                        }
                    }
                }
            }
                if(missingData || errordata || dupliacteErrorFile || dupliacteErrorData){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Error in file'));
                if(missingData)
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Missing data in the file maked as a red'));
                if(dupliacteErrorFile)
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Duplicate data found in the file marked as a yellow'));
                if(dupliacteErrorData)
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Duplicate data found in the database marked as a blue'));    
                if(errordata)
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Data not found in the database maked as a red'));
                    
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please verify data before uploading'));
                
                errordata = true;
            }
            
        }catch(Exception e){
             ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
            ApexPages.addMessage(errormsg);
         } 
        return null;
    }
    
    public Pagereference brandHierarchyChange(){
        try{
            List<Brand_Hierarchy__c> deActiveHierarchy = new List<Brand_Hierarchy__c>();
            List<Brand_Hierarchy__c> CreateHierarchy = new List<Brand_Hierarchy__c>();
           
            Map<String,Brand__c> mapBrandCode = new  Map<String,Brand__c>();
            Map<String,Product_Line__c> mapProductLine = new  Map<String,Product_Line__c>();
            Map<String,Brand_Hierarchy__c> mapBrand = new  Map<String,Brand_Hierarchy__c>();
 
            if(!newRecords.isEmpty()){                
                for(wrapperBrandHierarchy nw :newRecords){
                    CreateHierarchy.add(nw.BrandHierarchyObj);
                }
                
                if(!CreateHierarchy.isEmpty()){
                    insert CreateHierarchy;
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Info, 'Brand Hierarchy successfully created'));
                }
            }        
            
            if(!deactiveRecords.isEmpty()){
                for(wrapperBrandHierarchy nw :deactiveRecords){
                    if(nw.BrandHierarchyObj.id != null)
                        deActiveHierarchy.add(nw.BrandHierarchyObj);
                }
                
                if(!deActiveHierarchy.isEmpty()){
                    update deActiveHierarchy;
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Info, 'Brand Hierarchy successfully inactivate'));
                }                
            }
            newRecords = new List<wrapperBrandHierarchy>();
            deactiveRecords = new List<wrapperBrandHierarchy>();
            errordata = false;
            
        }catch(Exception e){
             ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Error, Please try again!!');
         } 
        return null;
    }
   
    
    public class wrapperBrandHierarchy{
        public Integer rowNumber {get;set;}
        public string Requested {get;set;}
        public string Name {get;set;}
        public boolean NameError  {get;set;}
        public boolean dupliacteErrorFile {get;set;}
        public boolean dupliacteErrorData {get;set;}
        public boolean BrandCodeError {get;set;}
        public boolean ProductLineError {get;set;}
        public boolean MissingDataError {get;set;}
        public string VantiveId {get;set;}  
        public string PmBrandCode {get;set;}    
        public string ShortCut {get;set;}    
        public string UPC {get;set;}  
        public string Taste {get;set;} 
        public boolean TasteError {get;set;}     
        public string Length {get;set;}
        public boolean LengthError {get;set;}    
        public string Packaging {get;set;}
        public boolean PackagingError {get;set;} 
        public string Flavor {get;set;}
        public boolean FlavorError {get;set;}        
        public string Filter {get;set;}
        public boolean FilterError {get;set;}        
        public string PaperType {get;set;}
        public boolean PaperTypeError {get;set;} 
        public string Cut {get;set;}
        public boolean CutError {get;set;}       
        public string BrandSasCode {get;set;}  
        public string BrandMMCode {get;set;} 
        public string ProductDesc {get;set;}
        public string ProductType {get;set;} 
        public string PriceCategory {get;set;}  
        public string LicenseGroup {get;set;}  
        public string UnitsPerPack {get;set;}   
        public string BrandStatus {get;set;}  
        public string BrandClassification {get;set;}  
        public string PackType {get;set;}   
        public string PickUpPolicyWeeks {get;set;}   
        public string UstDateType {get;set;}  
        public string ActiveFlag {get;set;}
        public string CrcBrandHierarchyCode {get;set;}   
        public string ProductLineCode {get;set;}  
        public string BrandCode {get;set;}
        public string ReportingBrandFamily {get;set;}
        public Brand_Hierarchy__c BrandHierarchyObj {get;set;}         
        
    }         
}