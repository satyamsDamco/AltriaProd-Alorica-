trigger convertDateFormat on CounterfeitTraceCode__c (before insert,before update) {
    
   Public Map<String, Integer> monthsMap = new Map<String, Integer>();
                    monthsMap.put('JAN',01);
                    monthsMap.put('FEB',02);
                    monthsMap.put('MAR',03);
                    monthsMap.put('APR',04);
                    monthsMap.put('MAY',05);
                    monthsMap.put('JUN',06);
                    monthsMap.put('JUL',07);
                    monthsMap.put('AUG',08);
                    monthsMap.put('SEP',09);
                    monthsMap.put('OCT',10);
                    monthsMap.put('NOV',11);
                    monthsMap.put('DEC',12);
                    
     for(CounterfeitTraceCode__c counObj:Trigger.new){
          if(counObj.MfgDateFeed__c != null && counObj.MfgDateFeed__c != '' && counObj.Year__c != null && String.ValueOf(counObj.Year__c).length() == 4){
              String[] spiltDate = counObj.MfgDateFeed__c.split('-'); //07-Jul-16
              
              if(spiltDate != null && spiltDate.size() == 3 && monthsMap.ContainsKey(spiltDate[1].toUpperCase())){
                  date d = Date.newInstance(Integer.ValueOf(counObj.Year__c), Integer.ValueOf(monthsMap.get(spiltDate[1].toUpperCase())),Integer.ValueOf(spiltDate[0]));
                  counObj.Production_Date__c = d;
              }                        
          }
     }
}