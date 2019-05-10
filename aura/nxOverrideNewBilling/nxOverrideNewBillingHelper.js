({
	redirectUser : function(component) {
		var homeEvent = $A.get("e.force:navigateToSObject");
		homeEvent.setParams({
			"recordId": component.get('v.idAccount'),
			"slideDevName": "related"
		});
		homeEvent.fire();
	}
})