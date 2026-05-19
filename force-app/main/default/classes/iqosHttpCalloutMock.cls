/*
*   @Author: Gian Carlo Cutchon
*   @Date: 2/13/2018
*   @Apex Name: iqosHttpCalloutMock
*   @Description: This class is use to handle the mock response from IQOS Callout to be use in test classes.
*
*/
@isTest
public with sharing class iqosHttpCalloutMock implements HttpCalloutMock {
    //A single method that acts as a webservice to simulate 3rd party services
            
    public HTTPResponse respond(HTTPRequest req){
        System.debug('--- Inside iqosHttpCalloutMock ---');
        String mock = req.getEndpoint();
        System.debug('mock--->' +mock);
        
        //Authentication
        if(req.getEndpoint().endsWith('token')){
            System.debug('--- Inside Authentication Mock ---');
            IQOSResponseClass.jsonWrapper_Auth resAuth = new IQOSResponseClass.jsonWrapper_Auth();

            resAuth.token_type = 'token123';
            resAuth.expires_in = '1234';
            resAuth.ext_expires_in = '1234';
            resAuth.expires_on = '1234';
            resAuth.not_before = '1234';
            resAuth.resource = 'test';
            resAuth.access_token = 'test';
            
            httpResponse res = new httpResponse();

            //Set the Status
            res.setStatus('OK');

            //Set the StatusCode
            res.setStatusCode(200);
            res.setBody(JSON.serialize(resAuth));
            return res;
        }
        
        //Manufacturing Information
        //if(req.getEndpoint().endsWith('MJN5BZKRW1MY') || req.getEndpoint().endsWith('G86PHXF425GA')){
        if(mock.contains(Label.Core_Service_URL+'/products/v1/iqosproductinfo/serial/')){
            System.debug('--- Inside Manufacturing Information Mock ---');
            IQOSResponseClass.jsonWrapper_MI resKM = new IQOSResponseClass.jsonWrapper_MI();
            resKM.odataMetadata = 'http://test';
            resKM.value = new list<IQOSResponseClass.jsonWrapper_Value>{new IQOSResponseClass.jsonWrapper_Value()};
            resKM.value[0].ItemCode = 'MJN5BZKRW1MY';
            resKM.value[0].ProductionDateTime = '2015-05-20T14:09:00Z';
            resKM.value[0].Shift = '2';
            resKM.value[0].ProductionLine = new IQOSResponseClass.jsonWrapper_ProductionLine();
            resKM.value[0].ProductionLine.Code = '02';
            resKM.value[0].ProductionLine.Factory = new IQOSResponseClass.jsonWrapper_Factory();
            resKM.value[0].ProductionLine.Factory.code = 'OX Test';
            resKM.value[0].ProductionLine.Factory.Name = 'Venture Corporation Limited';
            resKM.value[0].ProductionLine.Factory.CityRomanized = 'Singapore Test';
            resKM.value[0].ProductionLine.Factory.CountryCode = 'SG Test';
            
            httpResponse res = new httpResponse();

            //Set the Status
            res.setStatus('OK');

            //Set the StatusCode
            res.setStatusCode(200);

            //Set the Body to the serialized form of the instance of the stackExchangeAPI.responseResource
            res.setBody(JSON.serialize(resKM));
            //Return the httpResponse
            return res;
        }
        
        //Kit Mapping
        //if(req.getEndpoint().endsWith('QGLLG12WBXSR2T')){
        if(mock.contains(Label.Core_Service_URL+'/products/v1/iqoscomponenttokitmapping/serial/MJN5BZKRW1MY')){
            System.debug('--- Inside Kit Mapping Mock No Kit Mapping---');
            IQOSResponseClass.jsonWrapper_KM resKM = new IQOSResponseClass.jsonWrapper_KM();
            resKM.odataMetadataKit = 'http://test';
            resKM.value = new list<IQOSResponseClass.jsonWrapper_Value_Kit>{new IQOSResponseClass.jsonWrapper_Value_Kit()};
            resKM.value.clear();
            httpResponse res = new httpResponse();

            //Set the Status
            res.setStatus('OK');

            //Set the StatusCode
            res.setStatusCode(200);

            //Set the Body to the serialized form of the instance of the stackExchangeAPI.responseResource
            res.setBody(JSON.serialize(resKM));
            system.debug('JSON.serialize(resKM) --->' + JSON.serialize(resKM));
            //Return the httpResponse
            return res;
        }
        if(mock.contains(Label.Core_Service_URL+'/products/v1/iqoscomponenttokitmapping/serial/') && !mock.contains('MJN5BZKRW1MY')){
            System.debug('--- Inside Kit Mapping Mock ---');
            IQOSResponseClass.jsonWrapper_KM resKM = new IQOSResponseClass.jsonWrapper_KM();
            resKM.odataMetadataKit = 'http://test';
            resKM.value = new list<IQOSResponseClass.jsonWrapper_Value_Kit>{new IQOSResponseClass.jsonWrapper_Value_Kit()};
            resKM.value[0].ItemId = '0';
            resKM.value[0].ItemKey = '0';
            resKM.value[0].InputItemCode = 'QGLLG12WBXSR2T';
            resKM.value[0].ItemCode = 'G86PHXF425GA';
            resKM.value[0].ItemTypeId = 0;
            resKM.value[0].PackagingLevelId = 12;
            resKM.value[0].ProductionLineId = 4;
            resKM.value[0].ProductId = 4;
            resKM.value[0].ProductionDateTime = '2015-05-20T13:19:00Z';
            resKM.value[0].ProductionDateTimeLocal = null;
            resKM.value[0].IgnoreErrors = true;
            resKM.value[0].RecordDate = '';
            resKM.value[0].Flags = 1;
            resKM.value[0].IsCounterfeited = true;
            resKM.value[0].NbItems = 0;
            resKM.value[0].Shift = 'test';
            resKM.value[0].LastUpdateDate = '0001-01-01T00:00:00Z';
            resKM.value[0].ParentItemId = null;
            resKM.value[0].Product = new IQOSResponseClass.jsonWrapper_Product_Kit();
            resKM.value[0].Product.Id = 4;
            resKM.value[0].Product.ProductCode = 'DK000008.00';
            resKM.value[0].Product.ProductCodeTypeId = 1;
            resKM.value[0].Product.SystemId = 1;
            resKM.value[0].Product.Description = 'Test';
            resKM.value[0].Product.AlternateInfo = 'Alternate Test';
            resKM.value[0].Product.ProductTypeId = 30;
            resKM.value[0].Product.ProductFamilyId = 0;
            resKM.value[0].Product.BrandOwnerId = 1;
            resKM.value[0].Product.RecordDate = '2015-05-20T07:27:54+02:00';
            resKM.value[0].Product.Flags = 0;
            resKM.value[0].Product.NoteObjectId = 'Test NoteObjectId';
            resKM.value[0].Product.LastUpdateDate = '2017-10-17T15:55:46+02:00';
            resKM.value[0].Product.DesignMarketId = 'DesignMarketId test' ;
            resKM.value[0].PackagingLevel = new IQOSResponseClass.jsonWrapper_PackagingLevel(); 
            resKM.value[0].PackagingLevel.Id = 12;
            resKM.value[0].PackagingLevel.PackagingLevelOrder = 2;
            resKM.value[0].PackagingLevel.Name = 'Test Kit';
        
            httpResponse res = new httpResponse();

            //Set the Status
            res.setStatus('OK');

            //Set the StatusCode
            res.setStatusCode(200);

            //Set the Body to the serialized form of the instance of the stackExchangeAPI.responseResource
            res.setBody(JSON.serialize(resKM));
            //Return the httpResponse
            return res;
        }
        //Product Registration
        //if(req.getEndpoint().endsWith('TNZNNJ01P64PCW')){
        if(mock.contains(Label.Core_Service_URL+'/products/v1/iqosdevicereg/type/deviceId/id/')){   
            System.debug('--- Inside Product Registration Mock ---');
            IQOSResponseClass.jsonWrapper_PR resPR = new IQOSResponseClass.jsonWrapper_PR();
            resPR.Status = new IQOSResponseClass.jsonWrapper_Status();
            resPR.Status.statusCode = '200';
            resPR.Status.statusMessage = 'Success';
            resPR.Status.errorDetails = null;
            resPR.payload = new list<IQOSResponseClass.jsonWrapper_Payload>{new IQOSResponseClass.jsonWrapper_Payload()};
            resPR.payload[0].deviceID = 'TNZNNJ01P64PCW';
            resPR.payload[0].deviceType = 'IQOS Holde Test';
            resPR.payload[0].ccn = '123456789';
            resPR.payload[0].registrationStatus = 'Active';
            resPR.payload[0].registrationType = 'Purchase';
            resPR.payload[0].registrationChannel = 'CEA';
            resPR.payload[0].registrationDate = '2017-11-09T17:32:01.122Z';
            
            httpResponse res = new httpResponse();

            //Set the Status
            res.setStatus('OK');

            //Set the StatusCode
            res.setStatusCode(200);
            res.setBody(JSON.serialize(resPR));
            return res;
        }
        //Order Information
        if(mock.contains(Label.Core_Service_URL+'/iqos/v1/orders')){
            System.debug('--- Inside Order Information Mock ---');
            IQOSResponseClass.jsonWrapper_OI resOI = new IQOSResponseClass.jsonWrapper_OI();
            resOI.pfsOMSOrderNumber = 1380963;
            resOI.pfsWebOrderNumber = '0';
            resOI.originalReturnOMSOrderNumber = '';
            resOI.originalReturnGMROrderNumber = '';
            resOI.gmrOrderNumber = 'G0520183AF835EE228142E69A';
            resOI.shipToState = '';
            resOI.shipping = 0;
            resOI.distributionChannel = 'Domestic Retail';
            resOI.ccn = '';
            resOI.warehouseLocation = '054';
            resOI.storageLocation = '2000';
            resOI.purchaseDate = '03/07/18';
            resOI.orderType = 'SO';
            resOI.orderReason = null;
            resOI.stateOfSale = 'WI';
            
            IQOSResponseClass.jsonWrapper_OrderItems orderItem1 = new IQOSResponseClass.jsonWrapper_OrderItems();
            IQOSResponseClass.jsonWrapper_OrderItems orderItem2 = new IQOSResponseClass.jsonWrapper_OrderItems();
            
            orderItem1.jdeLineNumber = 2;
            orderItem1.pfsItemNumber = 748300;
            orderItem1.pfsItemDescription = 'Marlboro Smooth Menthol HeatSt ick';
            orderItem1.brand = '';
            orderItem1.upc = '09750102';
            orderItem1.materialCode = 'C8001000000';
            orderItem1.quantityShipped = 10;
            orderItem1.unitOfMeasure = 'PCK';
            orderItem1.isBundle = true;
            orderItem1.basePrice = 40;
            orderItem1.priceDiscount = -8.57;
            orderItem1.productDiscount = 0;
            orderItem1.shipping = 0;
            orderItem1.salesTax = 1.6;
            orderItem1.totalPaidByCustomer = 33.03;
            orderItem1.firstTimeBuyer = false;
            orderItem1.serialNumbers = new list<IQOSResponseClass.jsonWrapper_SerialNumber>{new IQOSResponseClass.jsonWrapper_SerialNumber()};
            orderItem1.serialNumbers[0].lotNumber = 'e46';
            orderItem1.serialNumbers[0].serialNumber = 'MJN5BZKRW1MY';
            
            orderItem2.jdeLineNumber = 1;
            orderItem2.pfsItemNumber = 747518;
            orderItem2.pfsItemDescription = 'IQOS Device Kit - White';
            orderItem2.brand = 'IQOS';
            orderItem2.upc = '097000150309';
            orderItem2.materialCode = 'C8003000000';
            orderItem2.quantityShipped = 1;
            orderItem2.unitOfMeasure = 'KIT';
            orderItem2.isBundle = true;
            orderItem2.basePrice = 100;
            orderItem2.priceDiscount = -21.43;
            orderItem2.productDiscount = 0;
            orderItem2.shipping = 0;
            orderItem2.salesTax = 4.51;
            orderItem2.totalPaidByCustomer = 82.58;
            orderItem2.firstTimeBuyer = false;
            orderItem2.serialNumbers = new list<IQOSResponseClass.jsonWrapper_SerialNumber>{new IQOSResponseClass.jsonWrapper_SerialNumber()};
            orderItem2.serialNumbers[0].lotNumber = '9970002';
            orderItem2.serialNumbers[0].serialNumber = 'EWX52FCHFOZ8';
            
            resOI.OrderItems = new list<IQOSResponseClass.jsonWrapper_OrderItems>{orderItem1,orderItem2};
            httpResponse res = new httpResponse();

            //Set the Status
            res.setStatus('OK');

            //Set the StatusCode
            res.setStatusCode(200);
            res.setBody(JSON.serialize(new List<IQOSResponseClass.jsonWrapper_OI>{resOI}));
            return res;
            
        }   
        
            httpResponse res = new httpResponse();
            //Set the Status
            res.setStatus('No Content');
            //Set the StatusCode
            res.setStatusCode(204);
            return res;
    }   
}