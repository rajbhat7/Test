<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NX_Update_Status_to_Reopen</fullName>
        <description>this workflow set case status to reopen if new message is true and case status is closed or on hold</description>
        <field>Status</field>
        <literalValue>Updated</literalValue>
        <name>NX Update Status to Reopen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>NX Set Case to Reopen</fullName>
        <actions>
            <name>NX_Update_Status_to_Reopen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold,Closed,In Progress</value>
        </criteriaItems>
        <description>this workflow set case status to reopen if new message is true and case status is closed or on hold</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
