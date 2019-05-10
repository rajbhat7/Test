<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CaseTaifunCustomer_Account</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">CaseTaifunCustomer_Account</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{
		&quot;name&quot;: &quot;Account.Name&quot;,
		&quot;label&quot;: &quot;Company Name&quot;,
		&quot;order&quot;: 10,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;Account.UPC_Account_ID__c&quot;,
		&quot;label&quot;: &quot;Salesforce Account ID&quot;,
		&quot;order&quot;: 20,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;Account.UPC_Segment_Channel__c&quot;,
		&quot;label&quot;: &quot;Sales Segment&quot;,
		&quot;order&quot;: 30,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;Account.UPC_NOGA_Codes_Formatted__c&quot;,
		&quot;label&quot;: &quot;Sector&quot;,
		&quot;order&quot;: 40,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;Account.Owner.Full_name__c&quot;,
		&quot;label&quot;: &quot;Account Manager&quot;,
		&quot;order&quot;: 50,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;Account.BillingState&quot;,
		&quot;label&quot;: &quot;County&quot;,
		&quot;order&quot;: 60,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;Account.UPC_Full_Billing_Address__c&quot;,
		&quot;label&quot;: &quot;Contract Address&quot;,
		&quot;order&quot;: 70,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;Account.Phone&quot;,
		&quot;label&quot;: &quot;Phone Number&quot;,
		&quot;order&quot;: 80,
		&quot;type&quot;: &quot;String&quot;
	}, {
		&quot;name&quot;: &quot;Account.UPC_email__c&quot;,
		&quot;label&quot;: &quot;eMail Address&quot;,
		&quot;order&quot;: 90,
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
        <value xsi:type="xsd:string">Id  = {UPC_Order__r.csordtelcoa__Opportunity__c}</value>
    </values>
</CustomMetadata>
