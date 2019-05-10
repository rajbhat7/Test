<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AccountDataForAcc_BDTV_Taifun</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">AccountDataForAcc_BDTV_Taifun</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">UPC_Account_Interfaces__c</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 10,
		&quot;name&quot;: &quot;UPC_ID__c&quot;,
		&quot;label&quot;: &quot;Customer Nr.&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 9,
		&quot;name&quot;: &quot;Account__r.Name&quot;,
		&quot;label&quot;: &quot;Customer Name&quot;
	},
{
		&quot;type&quot;: &quot;String&quot;,
		&quot;order&quot;: 11,
		&quot;name&quot;: &quot;UPC_External_ID__c&quot;,
		&quot;label&quot;: &quot;Debitor Nr.&quot;
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
        <value xsi:type="xsd:string">Account__c = {UPC_Order__r.csordtelcoa__Opportunity__r.AccountId} and UPC_System__c = &apos;Taifun&apos; and UPC_Primary_Account__c = true Order By CreatedDate desc LIMIT 1</value>
    </values>
</CustomMetadata>
