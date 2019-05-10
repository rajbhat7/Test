({
	doInit : function(component, event) {
		
        var action = component.get("c.processCreditCheckData");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            
            var account = a.getReturnValue().ccAccount;
            
			if( a.getReturnValue().success ) {
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success",
                    message: //"\nLast Credit Check: " + account.UPC_Last_Credit_Check__c, +
                             //"\nMax MRC: " + account.UPC_Max_MRC__c +
                             //"\nReject Reason Code: " + account.UPC_Reject_Reason_Code__c +
                             //"\nReject Reason: " + account.UPC_Reject_Reason__c +
                             //"\nRisk Code: " + account.UPC_Risk_Code__c +
                             "\nCredit Alert: " + account.UPC_Credit_Alert_Value__c,
                             
                    type: "success"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
			}
			else {
				$A.get("e.force:closeQuickAction").fire();
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error",
                    message: a.getReturnValue().message,
                    duration: '10000',
					type: "error"
				});
				toastEvent.fire();
			} 
            
        });
        $A.enqueueAction(action);
	}
})