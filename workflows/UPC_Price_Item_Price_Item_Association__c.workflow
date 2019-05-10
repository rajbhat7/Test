<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CSCRM_Populate_Migration_Id</fullName>
        <field>CSCRM_Migration_Id__c</field>
        <formula>CASESAFEID($Organization.Id)+&apos;-&apos;+CASESAFEID(Id)</formula>
        <name>CSCRM Populate Migration Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CSCRM Populate Migration Id</fullName>
        <actions>
            <name>CSCRM_Populate_Migration_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates the external Migration Id; Used for deployments.</description>
        <formula>ISBLANK( CSCRM_Migration_Id__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
