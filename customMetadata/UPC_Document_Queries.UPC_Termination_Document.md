<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Termination Document</label>
    <protected>false</protected>
    <values>
        <field>UPC_Document__c</field>
        <value xsi:type="xsd:string">Termination</value>
    </values>
    <values>
        <field>UPC_Query__c</field>
        <value xsi:type="xsd:string">SELECT Id, Name, Date_of_Creation__c, CreatedDate, UPC_Termination_Wish_Date__c,UPC_Opportunity_Receipt_of_Termination__c FROM csord__Service__c WHERE csord__Order__c = :recordId AND csord__Service__c = NULL LIMIT 1</value>
    </values>
</CustomMetadata>
