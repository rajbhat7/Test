<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BPEfon_TaifunSap_Service</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">BPEfon_TaifunSap_Service</value>
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
&quot;name&quot;: &quot;UPC_Taifun_SAP_Id__c&quot;, 
&quot;label&quot;: &quot;Taifun SAP&quot;, 
&quot;order&quot;: 5, 
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
        <value xsi:type="xsd:string">csord__Order__c={UPC_Order__c} and csordtelcoa__Product_Configuration__r.cscfga__Product_Definition__r.UPC_Product_Abbreviation__c=&apos;DPH&apos; and UPC_Taifun_SAP_Id__c!=null</value>
    </values>
</CustomMetadata>
