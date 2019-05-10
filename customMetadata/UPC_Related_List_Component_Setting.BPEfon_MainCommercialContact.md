<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BPEfon_MainCommercialContact</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">BPEfon_MainCommercialContact</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">UPC_Opportunity_Contact_Role__c</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[ {
		&quot;name&quot;: &quot;UPC_Contact__r.LastName&quot;,
		&quot;label&quot;: &quot;Last Name&quot;,
		&quot;order&quot;: 10,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;UPC_Contact__r.FirstName&quot;,
		&quot;label&quot;: &quot;First Name&quot;,
		&quot;order&quot;: 10,
		&quot;type&quot;: &quot;String&quot;
	},{
		&quot;name&quot;: &quot;UPC_Contact__r.Phone&quot;,
		&quot;label&quot;: &quot;Phone&quot;,
		&quot;order&quot;: 10,
		&quot;type&quot;: &quot;String&quot;
	},  {
		&quot;name&quot;: &quot;UPC_Contact__r.Email&quot;,
		&quot;label&quot;: &quot;Email&quot;,
		&quot;order&quot;: 10,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;UPC_Opportunity__r.Account.Name&quot;,
		&quot;label&quot;: &quot;Name&quot;,
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
        <value xsi:type="xsd:string">UPC_Opportunity__c = {UPC_Order__r.csordtelcoa__Opportunity__c} and UPC_Roles__c includes (&apos;Main Commercial Contact&apos;)</value>
    </values>
</CustomMetadata>
