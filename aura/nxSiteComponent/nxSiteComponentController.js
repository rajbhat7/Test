({
	doInit: function (component, event, helper) {
		component.set('v.idOpp', component.get('v.recordId'));
		helper.initHelper(component);
	},

	handleChange: function (component, event) {
		// This will contain an array of the "value" attribute of the selected options
		var selectedOptionValue = event.getParam("value");
		component.set("v.ListValues", selectedOptionValue);
	},

	handleNew: function (component, event) {
		component.set('v.isOpen', true);
		/*	
		var windowRedirect = window.location.href; // Current Page URL
		var createRecordEvent = $A.get("e.force:createRecord");
		createRecordEvent.setParams({
			"entityApiName": "UPC_Site__c",
			"defaultFieldValues": {
				"UPC_Account__c": component.get("v.accid"),
				"UPC_HelperField__c": true,
				"UPC_HelperOppId__c": component.get("v.recordId")
			},
		"panelOnDestroyCallback": function(event) {
			window.location.href = windowRedirect; // Return to the page where the record was created
		}
	});
	createRecordEvent.fire();
		*/
	},

	handleSave: function (component, event) {
		var action = component.get("c.saveMethod");
		action.setParams({
			"oppid": component.get("v.recordId"),
			"oppvalues": component.get("v.ListValues")
		});
		action.setCallback(this, function (a) {
			var state = a.getState();
			console.log(state);
			if (state === "SUCCESS") {
				var dismissActionPanel = $A.get("e.force:closeQuickAction");
				if (dismissActionPanel) {
					dismissActionPanel.fire();
				}
				var toastEvent = $A.get("e.force:showToast");			 
				toastEvent.setParams({
					"title": "Success!",
					"type": "success",
					"message": "Update Successfull."
				});
				toastEvent.fire();
				$A.get('e.force:refreshView').fire();
		

			} else if (state === "INCOMPLETE") {

			} else if (state === "ERROR") {
				var errors = a.getError();
			}
		});

		$A.enqueueAction(action);

	},



})