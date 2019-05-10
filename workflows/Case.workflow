<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_creating_in_Remedy</fullName>
        <ccEmails>steeve.seidel@nexell.net</ccEmails>
        <description>Case creating in Remedy</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/UPC_Remedy_Case_Sending</template>
    </alerts>
    <alerts>
        <fullName>UPC_Case_creating_in_Remedy</fullName>
        <ccEmails>steeve.seidel@nexell.net</ccEmails>
        <description>UPC Case creating in Remedy</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/UPC_Remedy_Case_Sending</template>
    </alerts>
    <fieldUpdates>
        <fullName>CSCRM_Populate_Orch_Case_Origin</fullName>
        <description>Populates the Case Origin as Order Orchestration if created from the Orchestrator</description>
        <field>Origin</field>
        <literalValue>Order orchestration</literalValue>
        <name>Populate Orch Case Origin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSCRM_Update_Case_Termination_Wish_Date</fullName>
        <description>Updates the Case Termination Wish Date with the value from the Order field.</description>
        <field>UPC_Termination_Wish_Date__c</field>
        <formula>UPC_Order__r.UPC_Termination_Wish_Date__c</formula>
        <name>Update Case Termination Wish Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NX_Update_Owner_to_internal_kmu_upc_ch</fullName>
        <description>this workflow update the owner of a case to internal@upc.ch if the webmail contain @upc.ch</description>
        <field>OwnerId</field>
        <lookupValue>internal_kmu_upc_ch</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NX Update Owner to internal.kmu@upc.ch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NX_Update_Owner_to_internal_pme_upc_ch</fullName>
        <description>this workflow update the owner of a case to internal@upc.ch if the webmail contain @upc.ch</description>
        <field>OwnerId</field>
        <lookupValue>internal_pme_upc_ch</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NX Update Owner to internal.pme@upc.ch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NX_Update_Owner_to_internal_sales_admin</fullName>
        <description>this workflow update the owner of a case to internal@upc.ch if the webmail contain @upc.ch</description>
        <field>OwnerId</field>
        <lookupValue>internal_sales_admin_upc_ch</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NX Update Owner to internal.sales.admin@</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NX_Update_Owner_to_internal_solution_adm</fullName>
        <description>this workflow update the owner of a case to internal@upc.ch if the webmail contain @upc.ch</description>
        <field>OwnerId</field>
        <lookupValue>internal_solution_admin_upc_ch</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NX Update Owner to internal.solution.adm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NX_Update_internal_business_admin_upc_ch</fullName>
        <description>this workflow update the owner of a case to internal@upc.ch if the webmail contain @upc.ch</description>
        <field>OwnerId</field>
        <lookupValue>internal_business_admin_upc_ch</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NX Update Owner to internal.business.adm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NX_Update_reason_to_cancellation</fullName>
        <description>NX Update reason to cancellation</description>
        <field>Reason</field>
        <literalValue>Cancellation Request</literalValue>
        <name>NX Update reason to cancellation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject_Bearer_Service</fullName>
        <description>Update the Case Subject with Bearer Service</description>
        <field>Reason</field>
        <literalValue>Bearer Service</literalValue>
        <name>Update Subject Bearer Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CSCRM_On_Termination_Cases_Insert</fullName>
        <actions>
            <name>CSCRM_Update_Case_Termination_Wish_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName == &apos;Taifun_Termination_Order_Entry&apos; || RecordType.DeveloperName == &apos;Taifun_Termination_Order_Completion&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CSCRM_Populate_Orch_Case_Origin</fullName>
        <actions>
            <name>CSCRM_Populate_Orch_Case_Origin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Case is created from the Orchestrator, update the Case Origin.</description>
        <formula>!ISBLANK( CSPOFA__Orchestration_Step__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NX_Change business%2Eadmin%40upc%2Ech owner UPC Queue</fullName>
        <actions>
            <name>NX_Update_internal_business_admin_upc_ch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@upc.ch</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>business.admin@upc.ch</value>
        </criteriaItems>
        <description>this workflow update the owner of a case to internal queue if the webmail contain @upc.ch</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NX_Change case reason if p_onp%40upc%2Ech</fullName>
        <actions>
            <name>NX_Update_reason_to_cancellation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>p_onp@upc.ch</value>
        </criteriaItems>
        <description>change status if p_onp@upc.ch to cancellation</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NX_Change kmu%40upc%2Ech owner UPC Queue</fullName>
        <actions>
            <name>NX_Update_Owner_to_internal_kmu_upc_ch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@upc.ch</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>kmu@upc.ch</value>
        </criteriaItems>
        <description>this workflow update the owner of a case to internal queue if the webmail contain @upc.ch</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NX_Change pme%40upc%2Ech owner UPC Queue</fullName>
        <actions>
            <name>NX_Update_Owner_to_internal_pme_upc_ch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@upc.ch</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>pme@upc.ch</value>
        </criteriaItems>
        <description>this workflow update the owner of a case to internal queue if the webmail contain @upc.ch</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NX_Change sales%2Eadmin%40upc%2Ech owner UPC Queue</fullName>
        <actions>
            <name>NX_Update_Owner_to_internal_sales_admin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@upc.ch</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>sales.admin@upc.ch</value>
        </criteriaItems>
        <description>this workflow update the owner of a case to internal queue if the webmail contain @upc.ch</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NX_Change solution%2Eadmin%40upc%2Ech owner UPC Queue</fullName>
        <actions>
            <name>NX_Update_Owner_to_internal_solution_adm</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@upc.ch</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>solution.admin@upc.ch</value>
        </criteriaItems>
        <description>this workflow update the owner of a case to internal queue if the webmail contain @upc.ch</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NX_Set_Case_Reason</fullName>
        <actions>
            <name>Update_Subject_Bearer_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Träger SAP,Bearer SAP,Traeger SAP,Neuer SAP für Träger</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Case BCSE Standard</value>
        </criteriaItems>
        <description>Set Case reason to Bearer Service if some words are found in subject</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
