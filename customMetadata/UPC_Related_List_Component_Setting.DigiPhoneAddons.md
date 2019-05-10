<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>DigiPhoneAddons</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">DigiPhoneAddons</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">csord__Deliverable__c</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{
&quot;name&quot;: &quot;Name&quot;,
&quot;label&quot;: &quot;Addon&quot;,
&quot;order&quot;: 5,
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
        <value xsi:type="xsd:string">csord__related_service__r.csord__Subscription__c={UPC_Subscription__c} and (UPC_Addon_Abbreviation__c=&apos;SDN&apos; or UPC_Addon_Abbreviation__c=&apos;MOH&apos;)</value>
    </values>
</CustomMetadata>
