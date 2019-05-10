({
	doInit : function(component, event) {
		
        var action = component.get("c.doTheCall");
        action.setParams({
            "upcSiteID": component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
			$A.get("e.force:closeQuickAction").fire();
			if( a.getReturnValue().successverifier ) {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success!",
					message: "Updated successfully!",
					type: "success"
				});
				toastEvent.fire();
				$A.get('e.force:refreshView').fire();
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
    } 
})