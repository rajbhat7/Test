({
	retrieveData : function(component) {
		var action = component.get('c.retrieveData');
		action.setParams({
			siteId: component.get('v.recordId')
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if(response.getState() == 'SUCCESS'){
				component.set("v.opportunities", response.getReturnValue());
				component.set("v.numberOfOpportunities", response.getReturnValue().length);
				console.log(response);
			} else {
				console.log('Component initialisation error: accessing apex controller');
			}
		});

		$A.enqueueAction(action);
	},
})