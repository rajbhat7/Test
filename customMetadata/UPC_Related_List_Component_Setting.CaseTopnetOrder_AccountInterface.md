<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CaseTopnetOrder_AccountInterface</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">CaseTopnetOrder_AccountInterface</value>
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
&quot;name&quot;: &quot;Account__r.Name&quot;, 
&quot;label&quot;: &quot;Customer Name&quot;, 
&quot;order&quot;: 10, 
&quot;type&quot;: &quot;String&quot; 
}, { 
&quot;name&quot;: &quot;UPC_ID__c&quot;, 
&quot;label&quot;: &quot;Taifun-No.&quot;, 
&quot;order&quot;: 20, 
&quot;type&quot;: &quot;String&quot; 
}, { 
&quot;name&quot;: &quot;UPC_External_ID__c&quot;, 
&quot;label&quot;: &quot;Debitor number&quot;, 
&quot;order&quot;: 30, 
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
        <value xsi:type="xsd:string">Account__c = {UPC_Order__r.csordtelcoa__Opportunity__r.AccountId} and UPC_System__c = &apos;Taifun&apos; and UPC_Primary_Account__c=true Order By CreatedDate desc LIMIT 1</value>
    </values>
</CustomMetadata>
