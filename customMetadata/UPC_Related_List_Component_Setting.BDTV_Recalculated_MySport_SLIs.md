<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BDTV_Recalculated_MySport_SLIs</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">BDTV_Recalculated_MySport_SLIs</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">csord__Service_Line_Item__c</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{
&quot;name&quot;: &quot;Name&quot;,
&quot;label&quot;: &quot;Line Item Name&quot;,
&quot;order&quot;: 5,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;csord__Service__r.csord__Service__r.Name&quot;,
&quot;label&quot;: &quot;Service Name&quot;,
&quot;order&quot;: 10,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;csord__Service__r.csord__Service__r.UPC_Taifun_SAP_Id__c&quot;,
&quot;label&quot;: &quot;Taifun SAP&quot;,
&quot;order&quot;: 30,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;csord__Total_Price__c&quot;,
&quot;label&quot;: &quot;MRC&quot;,
&quot;order&quot;: 50,
&quot;type&quot;: &quot;String&quot;
}, {
&quot;name&quot;: &quot;CurrencyIsoCode&quot;,
&quot;label&quot;: &quot;Currency&quot;,
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
        <value xsi:type="xsd:string">Service</value>
    </values>
    <values>
        <field>UPC_WHERE_Clause__c</field>
        <value xsi:type="xsd:string">csord__Service__r.UPC_Account__c = {AccountId} AND UPC_Price_Recalculated__c = true</value>
    </values>
</CustomMetadata>
