<aura:application extends="force:slds" implements="force:hasRecordId,force:hasSObjectName,flexipage:availableForRecordHome"> 
    <aura:attribute name="objectId" type="String"/>
    <aura:attribute name="width" type="Decimal"/>
    <aura:attribute name="height" type="Decimal"/>

    <c:nxGoogleMapsComponent objectId="{!v.objectId}" widthValue="{!v.width}"/>
    
</aura:application>