/**
* This web service is used to inset/upsert data into cscrm__Address__c (Premise)
* 
* @author Petar Miletic
* @ticket SFDT-15
* @since  07/01/2016
*/
global class AddressCreation {
    /*
        Inserts/Upserts data into cscrm__Address__c. Used to store addresses from external system
    */   
    webservice static string setAddress(string accountId, string externalAddressId, string city, string houseNumber, string houseNumberExtension, string street, string postalCode) {
        system.debug('++++++entered setAddress method');
        List<cscrm__Address__c> addresses = [SELECT cscrm__Account__c,
                                                LG_AddressID__c,
                                                cscrm__Address_Details__c,
                                                cscrm__City__c,
                                                cscrm__Country__c,
                                                LG_HouseNumber__c,
                                                LG_HouseNumberExtension__c,
                                                cscrm__State_Province__c,
                                                cscrm__Street__c,
                                                cscrm__Zip_Postal_Code__c 
                                             FROM cscrm__Address__c 
                                             WHERE LG_AddressID__c = :externalAddressId and cscrm__Account__c = :accountId];

        if (addresses != null && addresses.size() > 0) {
            
            for (cscrm__Address__c a :addresses) {
                a.cscrm__Account__c = accountId;
                // a.LG_AddressID__c = externalAddressId;
                a.cscrm__City__c = city;
                //a.cscrm__Country__c = country;
                a.LG_HouseNumber__c = houseNumber;
                a.LG_HouseNumberExtension__c = houseNumberExtension;
                //a.cscrm__State_Province__c = province;
                a.cscrm__Street__c = street;
                a.cscrm__Zip_Postal_Code__c = postalCode;
            }
            
            upsert addresses;
        }
        else {
            
            cscrm__Address__c a = new cscrm__Address__c();
            
            a.cscrm__Account__c = accountId;
            a.LG_AddressID__c = externalAddressId;
            a.cscrm__City__c = city;
            //a.cscrm__Country__c = country;
            a.LG_HouseNumber__c = houseNumber;
            a.LG_HouseNumberExtension__c = houseNumberExtension;
            //a.cscrm__State_Province__c = province;
            a.cscrm__Street__c = street;
            a.cscrm__Zip_Postal_Code__c = postalCode;
            
            insert a;
        }
        Map<String, String> retMap = new Map<String, String>{'Result' => 'Excellent'};
        return JSON.serialize(retMap);
    }
}