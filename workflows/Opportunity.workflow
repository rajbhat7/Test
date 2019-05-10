<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>UPC_Opportunity_Approved_Alert</fullName>
        <description>UPC Opportunity Approved Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Lead Qualifier</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pre-Sales Consultant</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/UPC_Opportunity_Approved_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>CSCRM_Update_Opportunity_Stage_to_Entry</fullName>
        <description>Updates the Opportunity StageName to Entry</description>
        <field>StageName</field>
        <literalValue>Entry</literalValue>
        <name>Update Opportunity Stage to Entry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage</fullName>
        <field>StageName</field>
        <literalValue>Negotiation Review</literalValue>
        <name>Update Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CSCRM_TerminationOppInsert</fullName>
        <actions>
            <name>CSCRM_Update_Opportunity_Stage_to_Entry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.csordtelcoa__Change_Type__c</field>
            <operation>equals</operation>
            <value>Termination</value>
        </criteriaItems>
        <description>Used for Termination Opportunity Insert</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NX_Opportunity_Move_Review_Not_Validated</fullName>
        <actions>
            <name>Update_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Order_Not_Validated_by_BackOffice_Review</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>AND(      UPC_Order_Not_Validated_Create_Task__c, ISCHANGED(UPC_Order_Not_Validated_Create_Task__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TEST</fullName>
        <active>false</active>
        <formula>AND(
CONTAINS($Profile.Name,&quot;Partner&quot;),
ISPICKVAL(CreatedBy.Contact.Account.UPC_Commissioning_Type__c,&quot;Recurring Commission&quot;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Order_Not_Validated_by_BackOffice_Review</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Order Not Validated by BackOffice - Review</subject>
    </tasks>
</Workflow>
