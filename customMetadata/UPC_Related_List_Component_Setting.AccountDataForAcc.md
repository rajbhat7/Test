<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AccountDataForAcc</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">AccountDataForAcc</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">Account</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 10,
		&quot;name&quot;: &quot;UPC_UID_Does_Not_Exist__c&quot;,
		&quot;label&quot;: &quot;Private customer account&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 11,
		&quot;name&quot;: &quot;UPC_Segment_Channel__c&quot;,
		&quot;label&quot;: &quot;Segment&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 12,
		&quot;name&quot;: &quot;BillingPostalCode&quot;,
		&quot;label&quot;: &quot;ZIP&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 13,
		&quot;name&quot;: &quot;BillingCity&quot;,
		&quot;label&quot;: &quot;City&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 14,
		&quot;name&quot;: &quot;BillingStreet&quot;,
		&quot;label&quot;: &quot;Street&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 15,
		&quot;name&quot;: &quot;BillingCountry&quot;,
		&quot;label&quot;: &quot;Country&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 16,
		&quot;name&quot;: &quot;BillingState&quot;,
		&quot;label&quot;: &quot;Canton&quot;
	},		
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 17,
		&quot;name&quot;: &quot;Name&quot;,
		&quot;label&quot;: &quot;Account Name&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 17,
		&quot;name&quot;: &quot;UPC_UID__c&quot;,
		&quot;label&quot;: &quot;UID&quot;
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
        <value xsi:type="xsd:string">Id = {UPC_Order__r.csord__Account__c}</value>
    </values>
</CustomMetadata>
