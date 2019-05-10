<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ShippingAddress_BDTV</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">ShippingAddress_BDTV</value>
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
		&quot;name&quot;: &quot;csordtelcoa__Product_Configuration__r.cscfga__Quantity__c&quot;,
		&quot;label&quot;: &quot;Quantity&quot;,
		&quot;order&quot;: 10,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;csordtelcoa__Product_Configuration__r.Name&quot;,
		&quot;label&quot;: &quot;Product with Option&quot;,
		&quot;order&quot;: 10,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;csordtelcoa__Product_Configuration__r.cscfga__total_one_off_charge__c&quot;,
		&quot;label&quot;: &quot;OTC&quot;,
		&quot;order&quot;: 12,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;csordtelcoa__Product_Configuration__r.cscfga__total_recurring_charge__c&quot;,
		&quot;label&quot;: &quot;MRC&quot;,
		&quot;order&quot;: 14,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;csordtelcoa__Product_Configuration__r.Shipping_Address__c&quot;,
		&quot;label&quot;: &quot;Shipping Address&quot;,
		&quot;order&quot;: 20,
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
