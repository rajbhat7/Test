<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CustomerDataForAcc</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">CustomerDataForAcc</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">AccountContactRelation</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{ 
&quot;type&quot;: &quot;String&quot;, 
&quot;order&quot;: 17, 
&quot;name&quot;: &quot;UPC_Salutations__c&quot;, 
&quot;label&quot;: &quot;Salutation&quot; 
}, 
{
&quot;type&quot;: &quot;String&quot;,
&quot;order&quot;: 17,
&quot;name&quot;: &quot;UPC_Contact_First_Name__c&quot;,
&quot;label&quot;: &quot;First Name&quot;
},
{
&quot;type&quot;: &quot;String&quot;,
&quot;order&quot;: 17,
&quot;name&quot;: &quot;UPC_Contact_Last_Name__c&quot;,
&quot;label&quot;: &quot;Last Name&quot;
},
{ 
&quot;type&quot;: &quot;String&quot;, 
&quot;order&quot;: 17, 
&quot;name&quot;: &quot;UPC_Phone__c&quot;, 
&quot;label&quot;: &quot;Phone&quot; 
}, 
{
&quot;type&quot;: &quot;String&quot;,
&quot;order&quot;: 17,
&quot;name&quot;: &quot;UPC_Mobile__c&quot;,
&quot;label&quot;: &quot;Mobile&quot;
},
{
&quot;type&quot;: &quot;String&quot;,
&quot;order&quot;: 17,
&quot;name&quot;: &quot;UPC_Account_Contact_Email__c&quot;,
&quot;label&quot;: &quot;Email&quot;
},
{
&quot;type&quot;: &quot;String&quot;,
&quot;order&quot;: 17,
&quot;name&quot;: &quot;Contact.UPC_Preferred_Language__c&quot;,
&quot;label&quot;: &quot;Language&quot;
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
        <value xsi:type="xsd:string">AccountId = {UPC_Order__r.csord__Account__c} AND Roles includes (&apos;Mobile Admin&apos;)</value>
    </values>
</CustomMetadata>
