({ 
	closeModel : function(component, event, helper) {
		helper.redirectUser(component);
	},

	handleNewRecord: function(component, event, helper){
		component.set('v.isOpen', false);
		component.set('v.footPrintOpen', true);
	},

	handleSubmit: function(component, event, helper){
		event.preventDefault();
		console.log('here');
		var fields = event.getParam('fields');
		fields['UPC_Shipping_Address__c'] = component.get('v.selectedAddress');
		component.find("form").submit(fields);
	},

	handleSuccess: function(component, event, helper){
		helper.redirectUser(component);
	},

	handleError: function(component, event, helper){
		var message = '';
		var billingChannel = component.find('billingChannel').get('v.value');
		if((component.get('v.selectedAddress') == '' || component.get('v.selectedAddress') == undefined) && billingChannel.includes('Paper Bill')) {
			message = 'When the Channel is Paper, the Shipping Address field is required.';
			$A.get('e.force:refreshView').fire();
		}else{
			message = 'Error creating Billing Account';
		}
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"type": 'error',
			"title": "Error!",
			"message": message
		});
		toastEvent.fire();
		
	}
})