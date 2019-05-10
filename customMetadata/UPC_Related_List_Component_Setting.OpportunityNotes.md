<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>OpportunityNotes</label>
    <protected>false</protected>
    <values>
        <field>UPC_Component_Setting_Key__c</field>
        <value xsi:type="xsd:string">OpportunityNotes</value>
    </values>
    <values>
        <field>UPC_Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>UPC_Display_Object__c</field>
        <value xsi:type="xsd:string">ContentDocumentLink</value>
    </values>
    <values>
        <field>UPC_Field_Definitions__c</field>
        <value xsi:type="xsd:string">[{&quot;name&quot;:&quot;ContentDocument.Title&quot;,
&quot;label&quot;:&quot;Title&quot;,
&quot;sort&quot;:10,
&quot;type&quot;:&quot;String&quot;},
{&quot;name&quot;:&quot;ContentDocument.Description&quot;,
&quot;label&quot;:&quot;Text Preview&quot;,
&quot;sort&quot;:11,
&quot;type&quot;:&quot;String&quot;},
{&quot;name&quot;:&quot;ContentDocument.CreatedBy.Name&quot;,
&quot;label&quot;:&quot;Created by&quot;,
&quot;sort&quot;:10,
&quot;type&quot;:&quot;String&quot;},
{&quot;name&quot;:&quot;ContentDocument.LastModifiedDate&quot;,
&quot;label&quot;:&quot;Last modified date&quot;,
&quot;sort&quot;:10,
&quot;type&quot;:&quot;String&quot;}
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
        <value xsi:type="xsd:string">LinkedEntityId = {UPC_Order__r.csordtelcoa__Opportunity__c} and ContentDocument.FileType=&apos;SNOTE&apos;</value>
    </values>
</CustomMetadata>
