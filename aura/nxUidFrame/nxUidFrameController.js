({
	doChange: function(component, event, helper) {
        if( component.get('v.simpleRecord.UPC_UID__c') ) {
            var formattedUid = component.get('v.simpleRecord.UPC_UID__c').replace(/-/g,'').replace(/\./g,'');
			component.set('v.uid', formattedUid);
        }		
	}
})