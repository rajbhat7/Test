/**
 * Controller for add on widget component
 */
global class AddOnWidgetController {

    /**
     * Remote action to query all available add ons for particular price item - add on custom setting combination
     * @param Id priceItem  price item Id
     * @param String category  name of widget custom setting
     * @param Id configId  Id of configuration - used for fetching existing add ons
     */
    @RemoteAction
    global static String getAvaialbleAddOns(Id priceItem, String category, Id configId) {
        String retVal = '';

        try {
            List<cspmb__Price_Item_Add_On_Price_Item_Association__c> addOnAssociations = [
                select Id, cspmb__Add_On_Price_Item__c, cspmb__Price_Item__c
                from cspmb__Price_Item_Add_On_Price_Item_Association__c
                where cspmb__Price_Item__c = :priceItem
            ];
            if (!addOnAssociations.isEmpty()) {
                Set<Id> addOnIds = new Set<Id>();

                for (cspmb__Price_Item_Add_On_Price_Item_Association__c addOnAssoc : addOnAssociations) {
                    addOnIds.add(addOnAssoc.cspmb__Add_On_Price_Item__c);
                }
                //Building query for Add On Price Items
                String queryString = 'select ';
                queryString += 'Id, Name,';
                Add_On_Widget_Settings__c settings = Add_On_Widget_Settings__c.getValues(category);
                if (settings != null && settings.Add_On_Fields__c != null) {
                    queryString += settings.Add_On_Fields__c;
                }
                if (settings != null && settings.Image__c != null && settings.Image__c != '') { // ZD
                    queryString += ',' + settings.Image__c;
                }
                queryString += ' from cspmb__Add_On_Price_Item__c';
                queryString += ' where Id in :addOnIds';
                if (settings != null && settings.Product_Definition__c != null) {
                    queryString += ' and cspmb__Product_Definition_Name__c = \'' + settings.Product_Definition__c + '\'';
                }
                if (settings != null && settings.Record_Type_Name__c != null) {
                    Id recordTypeId = Schema.SObjectType.cspmb__Add_On_Price_Item__c.RecordTypeInfosByName.get(settings.Record_Type_Name__c).RecordTypeId;
                    queryString += ' and RecordTypeId = :recordTypeId';
                }
                queryString += ' ORDER BY Name ASC';

                //Fetching already selected Add Ons
                Map<String,String> mapSelectedAddOns = new Map<String,String>();
                String selectedAddOnsQuery;
                if (settings != null && settings.Add_On_Definition__c != null) {
                    selectedAddOnsQuery = 'SELECT Add_On__c nameOfAddOn, COUNT(Id) cnt ' +
                                          'FROM cscfga__Product_Configuration__c ' +
                                          'WHERE cscfga__Root_Configuration__c =: configId AND cscfga__Product_Definition__r.Name = \'' + settings.Add_On_Definition__c + '\' GROUP BY Add_On__c';
                }

                System.debug(selectedAddOnsQuery);

                List<AggregateResult> selectedAddOns = Database.query(selectedAddOnsQuery);
                for(sObject sAddOns : selectedAddOns) {
                    mapSelectedAddOns.put((String) sAddOns.get('nameOfAddOn'), String.valueOf((Integer) sAddOns.get('cnt')));
                }

                // brosa
                List<cspmb__Price_Item_Add_On_Price_Item_Association__c> lstIncludedAddOnPriceItem = [
                    select cspmb__Add_On_Price_Item__c
                    from cspmb__Price_Item_Add_On_Price_Item_Association__c
                    where cspmb__Add_On_Price_Item__c IN: addOnIds AND Included__c = 'Yes'
                    AND cspmb__Price_Item__c = :priceItem
                ];
                Set<Id> setIncludedAddOnPriceItem = new Set<Id>();
                if(lstIncludedAddOnPriceItem != null && !lstIncludedAddOnPriceItem.isEmpty()) {
                    for(cspmb__Price_Item_Add_On_Price_Item_Association__c tmpAss : lstIncludedAddOnPriceItem)
                        setIncludedAddOnPriceItem.add(tmpAss.cspmb__Add_On_Price_Item__c);
                }

                //Building JSON response from queried Add On Price Items
                List<Object> retList = new List<Object>();
                List<cspmb__Add_On_Price_Item__c> addOns = Database.query(queryString);
                for (cspmb__Add_On_Price_Item__c addon : addOns) {
                    Map<String, String> addOnValues = new Map<String, String>();
                    if (settings != null && settings.Add_On_Fields__c != null) {
                        List<String> flds = settings.Add_On_Fields__c.split(',');
                        for (String fld : flds) {
                            String label = cspmb__Add_On_Price_Item__c.SObjectType.getDescribe().fields.getMap().get(fld).getDescribe().getLabel();
                            String value = addon.get(fld) != null ? String.valueOf(addon.get(fld)) : '';
                            addOnValues.put(label, value);
                        }
                    }
                    if (settings != null && settings.Quantity__c) {
                        addOnValues.put('Quantity', String.valueOf(true));
                    } else {
                        addOnValues.put('Quantity', String.valueOf(false));
                    }
                    if (settings != null && settings.Image__c != null && settings.Image__c != '') {
                        String imageUrl = addOn.get(settings.Image__c) != null && addOn.get(settings.Image__c) != ''? String.valueOf(addOn.get(settings.Image__c)) : '';
                        addOnValues.put('Image', imageUrl);
                    } else {
                        addOnValues.put('Image', '');
                    }
                    addOnValues.put('category', category);
                    if (!mapSelectedAddOns.isEmpty()) {
                        addOnValues.put('Selected', mapSelectedAddOns.containsKey(addon.Id) ? mapSelectedAddOns.get(addon.Id) : '0');
                    } else {
                        addOnValues.put('Selected', '0');
                    }
                    addOnValues.put('Name', addon.Name);
                    addOnValues.put('Id', addon.Id);
                    retList.add(addOnValues);
                }

                // 
                Map<String, Object> includedAddOns = new Map<String, Object>();
                includedAddOns.put('incAddOns', setIncludedAddOnPriceItem);
                retList.add(includedAddOns);

                retVal = JSON.serialize(retList);
            }
        } catch(Exception e) {
            retVal = 'Error - ' + e.getTypeName() + ': ' + e.getMessage() + ' : Line number: ' + e.getLineNumber();
        }
        //System.debug(retVal);
        return retVal;
    }

}