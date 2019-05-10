<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_not_Found_in_Zefix</fullName>
        <description>Account not Found in Zefix</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/UPC_Account_not_in_Zefix</template>
    </alerts>
    <alerts>
        <fullName>UPC_Account_Owner_Assignment_Email_Alert</fullName>
        <description>UPC Account Owner Assignment Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCAP__Approval_Process_Email_Templates/UPC_Account_Assignment_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Clean_New_Owner</fullName>
        <field>UPC_New_Account_Owner__c</field>
        <name>Clean New Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clean_Owner_change_Reason</fullName>
        <field>UPC_Reason_for_Changing_Owner__c</field>
        <name>Clean Owner change Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Context</fullName>
        <field>UPC_Zefix_Check_Context__c</field>
        <literalValue>0</literalValue>
        <name>Reset Context</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Former_Account_Owner</fullName>
        <field>UPC_Former_Account_Owner_Name__c</field>
        <formula>Owner.FirstName&amp;&apos; &apos;&amp;Owner.LastName</formula>
        <name>Update Former Account Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_Owner_Approved</fullName>
        <field>UPC_New_Account_Owner_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update New Owner Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_Owner_Rejected</fullName>
        <field>UPC_New_Owner_Rejected__c</field>
        <literalValue>1</literalValue>
        <name>Update New Owner Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_Owner_no_Approved</fullName>
        <field>UPC_New_Account_Owner_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Update New Owner not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_city</fullName>
        <field>BillingCity</field>
        <formula>ShippingCity</formula>
        <name>update city</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_country</fullName>
        <field>BillingCountry</field>
        <formula>ShippingCountry</formula>
        <name>update country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_state</fullName>
        <field>BillingStreet</field>
        <formula>ShippingState</formula>
        <name>update state</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_state2</fullName>
        <field>BillingState</field>
        <formula>ShippingState</formula>
        <name>update state</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_street</fullName>
        <field>BillingStreet</field>
        <formula>ShippingStreet</formula>
        <name>update street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_zip</fullName>
        <field>BillingPostalCode</field>
        <formula>ShippingPostalCode</formula>
        <name>update zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NX Sync Addresses</fullName>
        <actions>
            <name>update_city</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_state2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to sync Shipping and Billing Address.</description>
        <formula>OR(ISCHANGED( ShippingStreet ), 
ISCHANGED( UPC_Last_Zefix_Update__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reset Account Zefix Context</fullName>
        <actions>
            <name>Reset_Context</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.UPC_Zefix_Check_Context__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
