<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>UPC_Campaign_Owner_Assignment_Email_Alert</fullName>
        <description>UPC Campaign Owner Assignment Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCAP__Approval_Process_Email_Templates/UPC_Campaign_Assignment_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Clean_New_Owner</fullName>
        <field>UPC_New_Campaign_Owner__c</field>
        <name>Clean New Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Former_Campaign_Owner</fullName>
        <field>UPC_Former_Campaign_Owner_Name__c</field>
        <formula>Owner.FirstName&amp;&apos; &apos;&amp;Owner.LastName</formula>
        <name>Update Former Campaign Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_Owner_Approved</fullName>
        <field>UPC_New_Campaign_Owner_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update New Owner Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_Owner_not_Approved</fullName>
        <field>UPC_New_Campaign_Owner_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Update New Owner not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
