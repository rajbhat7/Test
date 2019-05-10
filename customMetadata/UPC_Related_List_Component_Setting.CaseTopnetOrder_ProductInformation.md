<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CaseTopnetOrder_ProductInformation</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">CaseTopnetOrder_ProductInformation</value>
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
&quot;name&quot;: &quot;csordtelcoa__Product_Configuration__r.Name&quot;, 
&quot;label&quot;: &quot;Product Configuration Name&quot;, 
&quot;order&quot;: 10, 
&quot;type&quot;: &quot;String&quot; 
},{ 
&quot;name&quot;: &quot;csordtelcoa__Product_Configuration__r.UPC_Customer_Whishdate__c&quot;, 
&quot;label&quot;: &quot;RFS Date&quot;, 
&quot;order&quot;: 20, 
&quot;type&quot;: &quot;String&quot; 
},{ 
&quot;name&quot;: &quot;csordtelcoa__Product_Configuration__r.UPC_Cable_Socket_Availability__c&quot;, 
&quot;label&quot;: &quot;Cable Socket Availability&quot;, 
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
        <value xsi:type="xsd:string">csord__Subscription__c= {UPC_Subscription__c} and csord__Service__c=null</value>
    </values>
</CustomMetadata>
