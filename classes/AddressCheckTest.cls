/**
* 
* Test for AddressCheck service
* 
* @author Petar Miletic
* @ticket SFDT-15
* @since  07/01/2016
*/
@IsTest
public class AddressCheckTest {

    @testSetup 
    private static void setupTestData() {
        
        List<cscrm__Address__c> addressList = new List<cscrm__Address__c>();
        
        for (integer i = 1; i < 6; i++) {
            
            cscrm__Address__c a = new cscrm__Address__c(
                cscrm__Street__c = 'Street No ' + i,
                LG_HouseNumber__c = String.valueOf(i + 10),
                LG_HouseNumberExtension__c = 'A',
                LG_AddressID__c = 'TestID',
                cscrm__Zip_Postal_Code__c = String.valueOf(10000 * i),
                cscrm__City__c = 'Agram');
                
            addressList.add(a);
        }
        
        insert addressList;
    }
    
    @isTest
    public static void addressCheckServiceTest() {
        
        List<cscrm__Address__c> addressList;
        List<cscrm__Address__c> addressListAll;
        
        test.startTest();
        
        string addressListJSON = AddressCheck.getAddresses('Street No 1', '11', 'A', '10000', 'Agram', '');
        string addressListAllJSON = AddressCheck.getAddresses('', '', '', '', '', '');

        addressList = (List<cscrm__Address__c>)System.JSON.deserialize(addressListJSON, List<cscrm__Address__c>.class);
        addressListAll = (List<cscrm__Address__c>)System.JSON.deserialize(addressListAllJSON, List<cscrm__Address__c>.class);

        test.stopTest();
        
        System.assertEquals(1, addressList.size(), 'Invalid result for given request');
        System.assertEquals(5, addressListAll.size(), 'Invalid result for given request');
    }
    
    @isTest
    public static void setAddressInsertTest() {
        
        Account a = uth_Account.Create(true);
        List<cscrm__Address__c> addressList;

        test.startTest();

        //AddressCheck.setAddress(String.valueOf(a.Id), '99999999999999', 'Agram', 'Croatia', '99', 'AB2', 'Zagreb', 'Smuglianka', '10000');
        AddressCheck.setAddress('Smuglianka', '99', 'AB2', '10000', 'Agram', String.valueOf(a.Id), '99999999999999', 'Croatia','Zagreb');

        string addressListJSON = AddressCheck.getAddresses('Smuglianka', '99', 'AB2', '10000', 'Agram', String.valueOf(a.Id));
        addressList = (List<cscrm__Address__c>)System.JSON.deserialize(addressListJSON, List<cscrm__Address__c>.class);

        test.stopTest();
        
        System.assertEquals(1, addressList.size(), 'Invalid result for given request');
    }
    
    @isTest
    public static void setAddressUpsertTest() {

        Account a = uth_Account.Create(true);        
        List<cscrm__Address__c> addressListBefore;
        List<cscrm__Address__c> addressListAfter;

        test.startTest();

        AddressCheck.setAddress('Smuglianka', '99', 'AB2', '10000', 'Agram', String.valueOf(a.Id), '99999999999999', 'Croatia','Zagreb');

        string addressListJSON = AddressCheck.getAddresses('Smuglianka', '99', 'AB2', '10000', 'Agram', String.valueOf(a.Id));
        addressListBefore = (List<cscrm__Address__c>)System.JSON.deserialize(addressListJSON, List<cscrm__Address__c>.class);
        
        // AddressCheck.setAddress(String.valueOf(a.Id), '99999999999999', 'Agram', 'Croatia', '99', 'AB2', 'Zagreb', 'Smuglianka Polyushka', '10000');
        AddressCheck.setAddress('Smuglianka Polyushka', '990', 'AB23', '10001', 'Agram2', String.valueOf(a.Id), '99999999999999', 'Netherlands','Haarlem');
        
        addressListJSON = AddressCheck.getAddresses('Smuglianka Polyushka', '990', 'AB23', '10001', 'Agram2', String.valueOf(a.Id));
        addressListAfter = (List<cscrm__Address__c>)System.JSON.deserialize(addressListJSON, List<cscrm__Address__c>.class);
    
        test.stopTest();

        System.assertEquals(1, addressListBefore.size(), 'Invalid result for given request');
        System.assertEquals(1, addressListAfter.size(), 'Invalid result for given request');
    }
}