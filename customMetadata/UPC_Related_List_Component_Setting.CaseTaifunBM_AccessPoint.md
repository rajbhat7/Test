<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CaseTaifunBM_AccessPointAddress</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">CaseTaifunBM_AccessPointAddress</value>
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
&quot;name&quot;: &quot;BillingPostalCode&quot;,
&quot;label&quot;: &quot;Customer ZIP&quot;,
&quot;order&quot;: 10,
&quot;type&quot;: &quot;String&quot;
}, 
{
&quot;name&quot;: &quot;BillingCity&quot;,
&quot;label&quot;: &quot;Customer City&quot;,
&quot;order&quot;: 20,
&quot;type&quot;: &quot;String&quot;
}, 
{
&quot;name&quot;: &quot;BillingStreet&quot;,
&quot;label&quot;: &quot;Customer Street&quot;,
&quot;order&quot;: 30,
&quot;type&quot;: &quot;String&quot;
}, 
{
&quot;name&quot;: &quot;BillingCountry&quot;,
&quot;label&quot;: &quot;Customer Country&quot;,
&quot;order&quot;: 40,
&quot;type&quot;: &quot;String&quot;
}, 
{
&quot;name&quot;: &quot;Phone&quot;,
&quot;label&quot;: &quot;Customer Phone&quot;,
&quot;order&quot;: 50,
&quot;type&quot;: &quot;String&quot;
},
 {
&quot;name&quot;: &quot;UPC_email__c&quot;,
&quot;label&quot;: &quot;Customer Email&quot;,
&quot;order&quot;: 60,
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
        <value xsi:type="xsd:string">Id = {UPC_Order__r.csordtelcoa__Opportunity__r.AccountId}</value>
    </values>
</CustomMetadata>
