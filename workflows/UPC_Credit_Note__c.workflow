<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSCRM_DE_Credit_Note_Approved_Notification</fullName>
        <description>CSCRM DE Credit Note Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCRM_Email_Templates/UPC_DE_Credit_Notes_Confiirmation_Email</template>
    </alerts>
    <alerts>
        <fullName>CSCRM_EN_Credit_Note_Approved_Notification</fullName>
        <description>CSCRM EN Credit Note Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCRM_Email_Templates/UPC_EN_Credit_Notes_Confiirmation_Email</template>
    </alerts>
    <alerts>
        <fullName>CSCRM_FR_Credit_Note_Approved_Notification</fullName>
        <description>CSCRM FR Credit Note Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCRM_Email_Templates/UPC_FR_Credit_Notes_Confiirmation_Email</template>
    </alerts>
    <alerts>
        <fullName>CSCRM_Final_Rejection_Action</fullName>
        <description>CSCRM Final Rejection Action</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCRM_Email_Templates/UPC_Credit_Notes_Approval_Rejected</template>
    </alerts>
    <alerts>
        <fullName>CSCRM_IT_Credit_Note_Approved_Notification</fullName>
        <description>CSCRM IT Credit Note Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCRM_Email_Templates/UPC_IT_Credit_Notes_Confiirmation_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>UPC_Credit_Note_Pending_Approval</fullName>
        <field>UPC_Approval_Status__c</field>
        <literalValue>Pending approval</literalValue>
        <name>UPC Credit Note Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPC_Credit_Note_Set_To_Approved</fullName>
        <field>UPC_Approved__c</field>
        <literalValue>1</literalValue>
        <name>UPC Credit Note Set To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPC_Credit_Notes_Approved</fullName>
        <field>UPC_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>UPC Credit Notes Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPC_Credit_Notes_Recalled</fullName>
        <field>UPC_Approval_Status__c</field>
        <name>UPC Credit Notes Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPC_Credit_Notes_Rejected</fullName>
        <field>UPC_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>UPC Credit Notes Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CSCRM DE Credit Note Approved</fullName>
        <actions>
            <name>CSCRM_DE_Credit_Note_Approved_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Once Credit Note is approved, notification is being sent to the credit note owner/end customer.</description>
        <formula>!ISPICKVAL( UPC_Main_Commercial_Contact__r.UPC_Preferred_Language__c , &apos;EN&apos;) &amp;&amp;
!ISPICKVAL( UPC_Main_Commercial_Contact__r.UPC_Preferred_Language__c , &apos;FR&apos;) &amp;&amp;
!ISPICKVAL( UPC_Main_Commercial_Contact__r.UPC_Preferred_Language__c , &apos;IT&apos;) &amp;&amp;  UPC_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSCRM EN Credit Note Approved</fullName>
        <actions>
            <name>CSCRM_EN_Credit_Note_Approved_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Once Credit Note is approved, notification is being sent to the credit note owner/end customer.</description>
        <formula>ISPICKVAL( UPC_Main_Commercial_Contact__r.UPC_Preferred_Language__c , &apos;EN&apos;) &amp;&amp;  UPC_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSCRM FR Credit Note Approved</fullName>
        <actions>
            <name>CSCRM_FR_Credit_Note_Approved_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Once Credit Note is approved, notification is being sent to the credit note owner/end customer.</description>
        <formula>ISPICKVAL( UPC_Main_Commercial_Contact__r.UPC_Preferred_Language__c , &apos;FR&apos;) &amp;&amp;  UPC_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSCRM IT Credit Note Approved</fullName>
        <actions>
            <name>CSCRM_IT_Credit_Note_Approved_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Once Credit Note is approved, notification is being sent to the credit note owner/end customer.</description>
        <formula>ISPICKVAL( UPC_Main_Commercial_Contact__r.UPC_Preferred_Language__c , &apos;IT&apos;) &amp;&amp;  UPC_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
