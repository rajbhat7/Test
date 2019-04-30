/**
* This web service is used to query local data source
* and inset/upsert data into cscrm__Address__c (Premise)
*
* @author Petar Miletic
* @story SFDT-15
* @since  07/01/2016
*/
global class AddressCheck {

    /*
        Retrieves data from local system
    */
    webservice static String getAddresses(String street, String housenumber, String housenumberextension, String postcode, String city, String accountID) {

        String query;
        List<string> params = new List<string>();

        params.add('LG_AddressID__c != null');

        if (String.isNotBlank(street)) {
            params.add('cscrm__Street__c LIKE \'%' + String.escapeSingleQuotes(street) + '%\'');
        }

        if (String.isNotBlank(housenumber)) {
            params.add('LG_HouseNumber__c LIKE \'%' + String.escapeSingleQuotes(houseNumber) + '%\'');
        }

        if (String.isNotBlank(housenumberextension)) {
            params.add('LG_HouseNumberExtension__c LIKE \'%' + String.escapeSingleQuotes(housenumberextension) + '%\'');
        }

        if (String.isNotBlank(postcode)) {
            params.add('cscrm__Zip_Postal_Code__c LIKE \'%' + String.escapeSingleQuotes(Postcode) + '%\'');
        }

        if (String.isNotBlank(city)) {
            params.add('cscrm__City__c LIKE \'%' + String.escapeSingleQuotes(city) + '%\'');
        }


        if (String.isNotBlank(accountID)) {
            params.add('cscrm__Account__c =\'' + String.escapeSingleQuotes(accountID) + '\'');
        }

        // if (String.isNotBlank(country)) {
        //     params.add('cscrm__Country__c LIKE \'%' + String.escapeSingleQuotes(country) + '%\'');
        // }

        if (params.size() == 0) {
            query = 'SELECT Id, LG_AddressID__c, cscrm__Street__c, LG_HouseNumber__c, LG_HouseNumberExtension__c, cscrm__Geolocation__latitude__s, cscrm__Geolocation__longitude__s, cscrm__Zip_Postal_Code__c, cscrm__City__c, cscrm__State_Province__c FROM cscrm__Address__c WHERE LG_AddressID__c != null LIMIT 25';
        }
        else {
            String allParams = String.join(params, ' AND ');
            query = 'SELECT Id, LG_AddressID__c, cscrm__Street__c, LG_HouseNumber__c, LG_HouseNumberExtension__c, cscrm__Geolocation__latitude__s, cscrm__Geolocation__longitude__s, cscrm__Zip_Postal_Code__c, cscrm__City__c, cscrm__State_Province__c FROM cscrm__Address__c WHERE ' + allParams;
        }

        System.debug('+++query is ' + query);

        List<cscrm__Address__c> sl = Database.query(query);

        return JSON.serialize(sl);
    }

    /*
        Inserts/Upserts data into cscrm__Address__c. Used to store addresses from external system
    */
    webservice static string setAddress(string street, string houseNumber, string houseNumberExtension, string postCode, string city, string accountId, string externalAddressId, string country,string state) {
        system.debug('++++++setAddress method, accountId: ' + accountId + ', street: ' +street + ', houseNumber: ' + houseNumber + ', houseNumberExtension:' + houseNumberExtension + ', postCode: ' + postCode + ', city: ' + city);

        List<cscrm__Address__c> addresses = [SELECT id,
                                                cscrm__Account__c,
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
                                             WHERE LG_AddressID__c = :externalAddressId
                                             and cscrm__Account__c = :accountId];

        string addressId;
        if (addresses != null && addresses.size() > 0) {

            List<cscrm__Address__c> addressesToUpsert = new List<cscrm__Address__c>();

            for (cscrm__Address__c a :addresses) {
                boolean shouldUpsert = false;

                if (a.cscrm__Account__c != accountId)
                {
                    a.cscrm__Account__c = accountId;
                    shouldUpsert = true;
                }
                if (a.LG_AddressID__c != externalAddressId)
                {
                    a.LG_AddressID__c = externalAddressId;
                    shouldUpsert = true;
                }
                if (a.cscrm__City__c != city)
                {
                    a.cscrm__City__c = city;
                    shouldUpsert = true;
                }
                if (a.cscrm__State_Province__c != state)
                {
                    a.cscrm__State_Province__c = state;
                    shouldUpsert = true;
                }
                if (a.cscrm__Country__c != country)
                {
                    a.cscrm__Country__c = country;
                    shouldUpsert = true;
                }
                if (a.LG_HouseNumber__c != houseNumber)
                {
                    a.LG_HouseNumber__c = houseNumber;
                    shouldUpsert = true;
                }
                if (a.LG_HouseNumberExtension__c != houseNumberExtension)
                {
                    a.LG_HouseNumberExtension__c = houseNumberExtension;
                    shouldUpsert = true;
                }
                if (a.cscrm__Street__c != street)
                {
                    a.cscrm__Street__c = street;
                    shouldUpsert = true;
                }
                if (a.cscrm__Zip_Postal_Code__c != postCode)
                {
                    a.cscrm__Zip_Postal_Code__c = postCode;
                    shouldUpsert = true;
                }
                if (shouldUpsert)
                {
                    addressesToUpsert.add(a);
                }
                addressId = a.id;

            }

            if (!addressesToUpsert.isEmpty())
            {
                upsert addressesToUpsert;
            }

        }
        else {
            cscrm__Address__c a = new cscrm__Address__c();

            a.cscrm__Account__c = accountId;
            a.LG_AddressID__c = externalAddressId;
            a.cscrm__City__c = city;
            a.cscrm__Country__c = country;
            a.LG_HouseNumber__c = houseNumber;
            a.LG_HouseNumberExtension__c = houseNumberExtension;
            a.cscrm__Street__c = street;
            a.cscrm__Zip_Postal_Code__c = postCode;
            a.cscrm__State_Province__c = state;
            insert a;
            addressId = a.id;
        }
        Map<String, String> returnMap = new Map<String, String>{'SalesforceAddressId' => addressId};
        system.debug('+++++returnMap: ' + returnMap);
        return JSON.serialize(returnMap);
    }

    /*
     * Returns address manually entered by CSR when it does not exists in external address system
     * so that CSR can select it and it can be sent to RFS check. Address is not stored.
     *
     * @story SFDT-148
     */
    webservice static string getSameAddress(string street, string houseNumber, string houseNumberExtension, string postCode, string city, string accountId, string country) {
        system.debug('++++++getSameAddress method, accountId: ' + accountId + ', street: ' +street + ', houseNumber: ' + houseNumber + ', houseNumberExtension:' + houseNumberExtension + ', postCode: ' + postCode + ', city: ' + city);

        cscrm__Address__c address = new cscrm__Address__c();

        address.cscrm__Street__c = street;
        address.LG_HouseNumber__c = houseNumber;
        address.LG_HouseNumberExtension__c = houseNumberExtension;
        address.cscrm__Zip_Postal_Code__c = postCode;
        address.cscrm__City__c = city;
        address.cscrm__Account__c = accountId;
        address.cscrm__Country__c = country;

        system.debug('+++ entered address: ' + address);

        List<cscrm__Address__c> addressList = new List<cscrm__Address__c>();
        addressList.add(address);

        return JSON.serialize(addressList);
    }
}