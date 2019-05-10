({
	doInit : function(component, event) {
		
        var action = component.get("c.doTheCall");
        action.setParams({
            "upcAddress": component.get("v.recordId") 
        });
        action.setCallback(this, function(a) {
			$A.get("e.force:closeQuickAction").fire();
			if( a.getReturnValue().successverifier ) {
				if(a.getReturnValue().customexception == ''){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Success!",
						message: "Updated successfully!",
						type: "success"
					});
					toastEvent.fire();
					$A.get('e.force:refreshView').fire();
				}else{
					this.navigateToSObject(component, event, a.getReturnValue.customexception); //Added for PT7955 -> Redirect user when an equal UPC Address has been found
				}
				
			}
			else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: a.getReturnValue().customexception,
					type: "error"
				});
				toastEvent.fire();
			} 
            
        });
        $A.enqueueAction(action);
	},
	
	navigateToSObject: function(component, event, upcAddressId){
		var sObectEvent = $A.get("e.force:navigateToSObject");
		sObectEvent .setParams({
			"recordId": upcAddressId,
			"slideDevName": "detail"
		});
		sObectEvent.fire();
	}
})