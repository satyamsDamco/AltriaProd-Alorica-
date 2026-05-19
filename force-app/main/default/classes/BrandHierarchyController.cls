/*
Functionality to select the Brand Hierarchy
06/30/2016 Infogain – Created.
*/

public with sharing class BrandHierarchyController {

    public String selectedProductLine {get; set;} /* String to hold Product Line */
    public List<SelectOption> productLineList {get; set;} /* List to hold Product Line data */
    public boolean showTable {get;set;} /* Flag to set if the brand hierarchy table should be visible or not. */
    public List<Brand_Hierarchy__c> brandHierarchyList{get; set;} /* List to hold Brand Hierarchy data */
    public List<SelectOption> brandList {get; set;} /* List to hold Brand data */    
    public String upcData {get;set;} /* String to hold UPC number */
    public String brandHierId {get;set;} /* String to hold Brand Hierarchy ID */
    public String brandData {get; set;} /* String to hold Brand data */
    private String productLine = apexpages.currentpage().getparameters().get('productlineName'); /* String to get Product Line Name */
    public String selectedUpc {get;set;} /* String to hold selected UPC Number */ 
     
    public BrandHierarchyController(ApexPages.StandardController controller){
        showTable = false;    
        brandHierarchyList = new List<Brand_Hierarchy__c>();
        brandList = new List<SelectOption>();
        brandHierId =  apexpages.currentpage().getparameters().get('brandHierId');
        
        productLineListData();
        brandListData();
    }
    
    /* Product line list */
    public void productLineListData(){
        
        productLineList = new List<SelectOption>(); 
         
        
        if(productLine != null && productLine != ''){        
        
            selectedProductLine = productLine;
            productLineList.add(new SelectOption(productLine, productLine));        
            
        }else{
            productLineList.add(new SelectOption('0', '--Select Product Line--',false)); 
            
            List<Product_Line__c> productLineObj = new List<Product_Line__c>([Select id, Name from Product_Line__c where isActive__c = true]);  
            
            for(Product_Line__c pl :productLineObj){
                productLineList.add(new SelectOption(pl.name, pl.name));
            }          
        }             
    }
    
     @RemoteAction
     public static List<String> productbrandList(String productLine, String UPC){
         List<String> brands = new List<String>();
         
         If(UPC != null && UPC != '' && UPC != '0'){
               AggregateResult[] groupedResults = [Select Count(id), Brand_code__r.Name, Brand_code__r.BrandCode__c 
                                                    From Brand_Hierarchy__c 
                                                    Where Active__c = true and Product_Line_Code__r.Name =: productLine
                                                    and UPC__c = :UPC
                                                    Group by Brand_code__r.Name,Brand_code__r.BrandCode__c
                                                    order by Brand_code__r.Name asc];
        
                for (AggregateResult ar : groupedResults){
                    String brandName = String.ValueOf(ar.get('Name'));
                    brands.add(brandName);
                }
         }else{
             AggregateResult[] groupedResults = [Select Count(id), Brand_code__r.Name, Brand_code__r.BrandCode__c 
                                                        From Brand_Hierarchy__c 
                                                        Where Active__c = true and Product_Line_Code__r.Name =: productLine
                                                        Group by Brand_code__r.Name,Brand_code__r.BrandCode__c
                                                        order by Brand_code__r.Name asc];
            
            for (AggregateResult ar : groupedResults){
                String brandName = String.ValueOf(ar.get('Name'));
                brands.add(brandName);
            }
        }
         
         return brands;
     }
    
    /* Create the Brand List from Brand Hierarchy data using aggregate method */
    public PageReference brandListData()
    { 
        if(selectedProductLine   != null && selectedProductLine  !=  '' && selectedProductLine != '0'){   
            brandList= new List<SelectOption>(); 
            brandList.add(new SelectOption('0', '--Select Brand--'));           
           
                AggregateResult[] groupedResults = [Select Count(id), Brand_code__r.Name, Brand_code__r.BrandCode__c 
                                                    From Brand_Hierarchy__c 
                                                    Where Active__c = true and Product_Line_Code__r.Name =: selectedProductLine
                                                    Group by Brand_code__r.Name,Brand_code__r.BrandCode__c
                                                    order by Brand_code__r.Name asc];
        
                for (AggregateResult ar : groupedResults){
                    String brandName = String.ValueOf(ar.get('Name'));
                    brandList.add(new SelectOption(brandName, brandName));
                }
             
                if(brandHierId != null && brandHierId != '')
                    brandData = [Select Brand_code__r.Name From Brand_Hierarchy__c where Active__c = true and  id = :brandHierId ].Brand_code__r.Name;
                    
           brandHierData();
         }
         
         
         
         return null;                    
    }
    
    /* Initialize the Brand Hierarchy list */
    public void brandHierData(){
        brandHierarchyList=new List<Brand_Hierarchy__c> ();  
        upcData =  '';     
    }
    
    /* Fill the Brand Hierarchy data based on Product Line and UPC number */
    public Pagereference fillBrandHierarchy()
    {
        brandHierarchyList=new List<Brand_Hierarchy__c> ();
        brandHierarchyList = brandHierDataList('',productLine,'0','0','0','0','0','0','0',selectedUPC,'0','upcSearch');
        
        if(brandHierarchyList.size()<=1){
            showTable = false;    
        }else{
            showTable = true;    
        }
        if(selectedUPC != null && selectedUPC != '' && selectedUPC != '0'){
            if(brandHierarchyList.size()==0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'UPC Not Valid!!!'));
            }else if(brandHierarchyList.size()==1){
                ApexPages.getMessages().clear();
                brandData = brandHierarchyList[0].Brand_Code__r.Name;
            }
        }
        return null;
    }
    
    /* Select the Brand Hierarchy data based on Filter */
    @RemoteAction
    public static List<Brand_Hierarchy__c> brandHierDataList(string brandHierId, string productLine, string brand, string filter, string taste, string length, string packaging, string flavor, string paperType, string upc, string cut, string type){
        String query = 'Select Id, Brand_Code__c, Brand_Code__r.Name,Brand_Code__r.Description__c, Filter__c,Flavor__c, Length__c,Packaging__c,';
               query += ' Product_Line_Code__c,Product_Line_Code__r.Name, Cut__c, PaperType__c, Taste__c, UPC__c'; 
               query += ' From Brand_Hierarchy__c';

        if(brandHierId != null && brandHierId != '' && brandHierId!= '0'){
            query += ' where Active__c = true and id = \''+brandHierId +'\'';
        }else{
            query += ' where Active__c = true and Product_Line_Code__r.Name = \''+productline+'\'';
            
            if(brand != null && brand != '' && brand != '0'){
                query += ' and Brand_code__r.Name = \''+brand+'\'';
            }
            
            if(filter != null && filter != '' && filter != '0'){
                query += 'and Filter__c =\''+ filter +'\'';
            }
            
            if(taste != null && taste != '' && taste != '0'){
                query += 'and Taste__c =\''+ Taste +'\'';
            }
            
            if(upc  != null && upc  != '' && upc  != '0'){
                query += 'and UPC__c =\''+ upc +'\'';
            }
            
            if(length != null && length != '' && length != '0'){
                query += 'and Length__c =\''+ length  +'\'';
            }
            
            if(packaging != null && packaging != '' && packaging != '0'){
                query += 'and Packaging__c =\''+ packaging +'\'';
            }
            
            if(flavor != null && flavor != ''&& flavor != '0'){
                query += 'and Flavor__c =\''+ flavor+'\'';
            }
            
            if(paperType != null && paperType  != ''&& paperType != '0'){
                query += 'and PaperType__c =\''+ paperType+'\'';
            }
            
            if(cut != null && cut != ''&& cut != '0'){
                query += 'and Cut__c =\''+ cut+'\'';
            }
            
                   
            
        }
        System.debug('test '+query);
        List<Brand_Hierarchy__c> brandHierList = new List<Brand_Hierarchy__c>();
        if(type == 'upcSearch' && (upc  == null || upc  == '' || upc  == '0')){
            
        }else{
            List<sObject> sobjList = Database.query(query);
            brandHierList = (List<Brand_Hierarchy__c>)sobjList;
        } 
        
        System.debug('test brandHierList '+brandHierList);
        return brandHierList;
    }

    /* Reset Brand Hierarchy attributes */
    public PageReference reset() {
        showTable = false;    
        brandHierarchyList = new List<Brand_Hierarchy__c>();
        brandList = new List<SelectOption>();
        brandHierId =  '';
        
        productLineListData();
        brandListData();
        
        return null;
    }

}