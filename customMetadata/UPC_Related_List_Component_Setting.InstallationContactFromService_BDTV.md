<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>InstallationContactFromService_BDTV</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">InstallationContactFromService_BDTV</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">csord__Service__c</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{
		&quot;name&quot;: &quot;UPC_Installation_Contact__r.Salutation&quot;,
		&quot;label&quot;: &quot;Salutation&quot;,
		&quot;order&quot;: 10,
		&quot;type&quot;: &quot;String&quot;
	}, {
&quot;name&quot;: &quot;UPC_Installation_Contact__r.FirstName&quot;,
&quot;label&quot;: &quot;First Name&quot;,
&quot;order&quot;: 10,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;UPC_Installation_Contact__r.Name&quot;,
&quot;label&quot;: &quot;Last Name&quot;,
&quot;order&quot;: 10,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;UPC_Installation_Contact__r.Phone&quot;,
&quot;label&quot;: &quot;Phone&quot;,
&quot;order&quot;: 10,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;UPC_Installation_Contact__r.MobilePhone&quot;,
&quot;label&quot;: &quot;Mobile&quot;,
&quot;order&quot;: 10,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;UPC_Installation_Contact__r.Email&quot;,
&quot;label&quot;: &quot;Email&quot;,
&quot;order&quot;: 10,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;UPC_Installation_Contact__r.UPC_Preferred_Language__c&quot;,
&quot;label&quot;: &quot;Language&quot;,
&quot;order&quot;: 10,
&quot;type&quot;: &quot;String&quot;
}
]</value>
    </values>
    <values>
        <field>UPC_OE_Data__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>UPC_OE_Object_Type__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_WHERE_Clause__c</field>
        <value xsi:type="xsd:string">csord__Order__c={UPC_Order__c} and csord__Service__c=null and csord__Subscription__r.csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.UPC_Product_Abbreviation__c=&apos;BDTV&apos; and UPC_Process_Terms__c={UPC_Process_Terms__c}</value>
    </values>
</CustomMetadata>
