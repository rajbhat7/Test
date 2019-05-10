<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CaseCreditNote_Account</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">CaseCreditNote_Account</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">UPC_Credit_Note__c</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{ 
&quot;name&quot;: &quot;UPC_Customer_Account__r.Name&quot;,
&quot;label&quot;: &quot;Customer Name&quot;, 
&quot;order&quot;: 10, 
&quot;type&quot;: &quot;String&quot; 
},{ 
&quot;name&quot;: &quot;UPC_Customer_Number__c&quot;,
&quot;label&quot;: &quot;Field.UPC_Credit_Note__c.UPC_Customer_Number__c&quot;, 
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
        <value xsi:type="xsd:string">Id = {UPC_Credit_Note__c}</value>
    </values>
</CustomMetadata>
