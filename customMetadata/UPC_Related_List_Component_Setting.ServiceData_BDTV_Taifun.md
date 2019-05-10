<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ServiceData_BDTV_Taifun</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">ServiceData_BDTV_Taifun</value>
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
&quot;name&quot;: &quot;csord__Order__r.csordtelcoa__Opportunity__r.Name&quot;, 
&quot;label&quot;: &quot;Opportunity Name&quot;, 
&quot;order&quot;: 10, 
&quot;type&quot;: &quot;String&quot; 
},{ 
&quot;name&quot;: &quot;csord__Order__r.csordtelcoa__Opportunity__r.Id&quot;, 
&quot;label&quot;: &quot;Opportunity ID&quot;, 
&quot;order&quot;: 11, 
&quot;type&quot;: &quot;String&quot; 
}, { 
&quot;name&quot;: &quot;Name&quot;, 
&quot;label&quot;: &quot;Product Name&quot;,
&quot;order&quot;: 20, 
&quot;type&quot;: &quot;String&quot; 
}, { 
&quot;name&quot;: &quot;Contract_Term__c&quot;, 
&quot;label&quot;: &quot;Binding Period&quot;,
&quot;order&quot;: 30, 
&quot;type&quot;: &quot;String&quot; 
}]</value>
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
        <value xsi:type="xsd:string">csord__Order__c={UPC_Order__c} and csord__Service__c=null and UPC_Process_Terms__c={UPC_Process_Terms__c}</value>
    </values>
</CustomMetadata>
