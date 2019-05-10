({

	doInit: function(component, event, helper){
		var sObjectName = component.get('v.objectName');
		switch (sObjectName){
			case 'Lead':
				component.find('leadField').set('v.value', component.get('v.idval'));
				break;
			case 'Account':
			case 'Opportunity':
				component.find('accountField').set('v.value', component.get('v.idval'));
				break;
			
		}
	},
	handleNewRecord: function(component, event, helper){
		component.set("v.isOpen", false);
		component.set("v.footPrintOpen", true);
	},

	handleSubmit: function(component, event, helper){
		event.preventDefault();
		var oppId = component.get('v.idOpp');
		var fields = event.getParam('fields');
		fields['UPC_ADBASE_Address__c'] = component.get('v.selectedAddress');
		if(oppId != ''){
			fields['UPC_HelperOppId__c'] = oppId;
			fields["UPC_HelperField__c"] = true;
		}
		component.find("form").submit(fields);
	},

	handleSuccess: function(component, event, helper){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			'type': 'success',
			"title": "Add Site",
			"message": "Site created with success!"
		});
		toastEvent.fire();
		$A.get('e.force:refreshView').fire();
		var e = component.getEvent("siteUpdateEvent");
		e.fire();
		component.set('v.isOpen', false);

		if(component.get('v.idOpp') != null){
			var dismissActionPanel = $A.get("e.force:closeQuickAction");
			if (dismissActionPanel) {
				dismissActionPanel.fire();
			}
		}
		
	},

	handleError: function(component, event, helper){
		/*var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"type": 'error',
			"title": "Error!",
			"message": "Attempt to create a duplicate Site record"
		});
		toastEvent.fire();
		
		component.set('v.isOpen', false);

		if(component.get('v.idOpp') != null){
			var dismissActionPanel = $A.get("e.force:closeQuickAction");
			if (dismissActionPanel) {
				dismissActionPanel.fire();
			}
		}*/
	},

	closeModel: function(component, event, helper) {
		// for Hide/Close Model,set the "isOpen" attribute to "Fasle"
		if(component.get('v.override') == true){
			var homeEvent = $A.get("e.force:navigateToObjectHome");
			homeEvent.setParams({
				"scope": "UPC_Site__c"
			});
    		homeEvent.fire();
		}else{
			component.set("v.isOpen", false);
		}
	 }
	
})