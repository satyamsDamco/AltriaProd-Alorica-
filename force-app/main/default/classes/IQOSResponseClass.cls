/*
*   @Author: Gian Carlo Cutchon
*   @Date: 1/3/2018
*   @Apex Name: IQOSResponseClass
*   @Description: This class is use to handle the response from IQOS Callout.
*
*/
public class IQOSResponseClass{
    //JSON Wrapper for authentication callout
    public class jsonWrapper_Auth{
            public String token_type{get;set;}
            public String expires_in{get;set;}
            public String ext_expires_in{get;set;}
            public String expires_on{get;set;}
            public String not_before{get;set;}
            public String resource{get;set;}
            public String access_token{get;set;}
    }
    //---------------------------------------------
    
    //Core Service API ----------------------------
    //JSON Wrapper for Manufacturing Information
    public class jsonWrapper_MI{
        public string odataMetadata;
        public list<jsonWrapper_Value> value;
    }
    public class jsonWrapper_Value{
            public jsonWrapper_ProductionLine ProductionLine;
            public String ItemCode;
            public String ProductionDateTime;
            public String Shift;
    }
    //Product line
    public class jsonWrapper_ProductionLine{
            public jsonWrapper_Factory Factory;
            public String Code;
    }
    //Factory
    public class jsonWrapper_Factory{
            public String Code;
            public String Name;
            public String CityRomanized;
            public String CountryCode;
    }
    //------------------------------------------------
    
    // Kit Mapping
    public class jsonWrapper_KM{
        public string odataMetadataKit;
        public list<jsonWrapper_Value_Kit> value;
    }
    //value
    public class jsonWrapper_Value_Kit{
            public jsonWrapper_Product_Kit Product;
            public jsonWrapper_PackagingLevel PackagingLevel;
            public String ItemId;
            public String ItemKey;
            public String InputItemCode;
            public String ItemCode;
            public integer ItemTypeId;
            public integer PackagingLevelId;
            public integer ProductionLineId;
            public integer ProductId;
            public String ProductionDateTime;
            public String ProductionDateTimeLocal;
            public boolean IgnoreErrors;
            public String RecordDate;
            public integer Flags;
            public boolean IsCounterfeited;
            public integer NbItems;
            public String Shift;
            public String LastUpdateDate;
            public String ParentItemId;
            
    }
    //Product
    public class jsonWrapper_Product_Kit{
            public integer Id;
            public String ProductCode;
            public integer ProductCodeTypeId;
            public integer SystemId;
            public String Description;
            public String AlternateInfo;
            public integer ProductTypeId;
            public integer ProductFamilyId;
            public integer BrandOwnerId;
            public String RecordDate;
            public integer Flags;
            public String NoteObjectId;
            public String LastUpdateDate;
            public String DesignMarketId;
    }
    //PackagingLevel
    public class jsonWrapper_PackagingLevel{
        public integer Id;
        public integer PackagingLevelOrder;
        public string Name;
        
    }
    //-----------------------------------------------
    //Product Registration
    public class jsonWrapper_PR{
        public jsonWrapper_Status Status;
        public List<jsonWrapper_Payload> payload;
    }
    
    public class jsonWrapper_Status{
        public string statusCode;
        public string statusMessage;
        public string errorDetails;
    }
    
    public class jsonWrapper_Payload{
        public string deviceID;
        public string deviceType;
        public string ccn;
        public string registrationStatus;
        public string registrationType;
        public string registrationChannel;
        public string registrationDate;
    }
    
    //Order Information Body
    public class jsonWrapper_OrderBody{
        public string type;
        public string id;
    }
    
    //Order Information
    public class jsonWrapper_OI{
        public integer pfsOMSOrderNumber;
        public string pfsWebOrderNumber;
        public string originalReturnOMSOrderNumber;
        public string originalReturnGMROrderNumber;
        public string gmrOrderNumber;
        public string shipToState;
        public decimal shipping;
        public string distributionChannel;
        public string ccn;
        public string warehouseLocation;
        public string storageLocation;
        public string purchaseDate;
        public string orderType;
        public string orderReason;
        public string stateOfSale;
        public List<jsonWrapper_OrderItems> OrderItems;
    }
    public class jsonWrapper_OrderItems{
        public integer jdeLineNumber;
        public integer pfsItemNumber;
        public string pfsItemDescription;
        public string brand;
        public string upc;
        public string materialCode;
        public integer quantityShipped;
        public string unitOfMeasure;
        public boolean isBundle;
        public decimal basePrice;
        public decimal priceDiscount;
        public decimal productDiscount;
        public decimal shipping;
        public decimal salesTax;
        public decimal totalPaidByCustomer;
        public boolean firstTimeBuyer;
        public List<jsonWrapper_SerialNumber> serialNumbers;
    }
    public class jsonWrapper_SerialNumber{
        public string lotNumber;
        public string serialNumber;
    }
    //-----------------------------------------------
    //End of Core Service----------------------------
    
    
    //CEA----------------------------------------
    public class jsonWrapper_CEA{
        public jsonWrapper_CEA_Contact ContactInfo;
        public list<jsonWrapper_CEA_Issue> IssueInfo;
        public jsonWrapper_CEA_Store StoreInfo;
        
    }
    //Contact
    public class jsonWrapper_CEA_Contact{       
            public String firstName;
            public String lastName;
            public String prefix;
            public String suffix;
            public String addressLine1;
            public String addressLine2;
            public String zip;
            public String city; 
            public String state;
            public boolean addressVerified;
            public String telephone;
            public String mobilePhone;
            public String emailAddress; 
            public String alternateTelephone; 
            public String dob;
            public String avCode; 
            public boolean ageVerified;
            public String ccn;
    }
    //Issue
    public class jsonWrapper_CEA_Issue{
            public String BrandHierarchy;
            public String IssueHierarchy;
            public String AgentID;
            public String Comment;
            public String ComplaintSource;
            public String ReferenceID;
            public decimal PurchasePrice;
            public String ReimbursedOrRepIndicator;
            public decimal ThirdPartyRA;
            public String AffectedType;
            public decimal AffectedQuantity;
            public String ConsumerMentions;
            public String ExpectedType;
            public decimal ExpectedQuantity;
            public String InboundTracking;
            public String IncidentDate;
            public String OutboundTracking;
            public boolean ProductRetReqforReimbursement;
            public String PurchaseDate;
            public String PurchaseType;
            public decimal PurchaseQuantity;
            public decimal ReimbursementAmount;
            public String SerialNumber;
        	public String ProductLine;
        	public string ChannelContact;
        	public String SellByDate;
    }
    
    //Store 
    public class jsonWrapper_CEA_Store{
            public String StoreType;
            public String StoreName;
            public String StoreAddress1;
            public String StoreAddress2;
            public String StoreCity;
            public String StoreState;
            public String storezip;
            public String storecomments;
    }
    //End of CEA-------------------------------------------

    
}