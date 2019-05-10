({
	doInit : function(component, event) {
		
        var action = component.get("c.initClass");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(a) {			
			if( a.getReturnValue().successverifier ) {
				if( a.getReturnValue().UidCheck) {
					$A.get("e.force:closeQuickAction").fire();
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
					
					component.set('v.loaded', !component.get('v.loaded'));
					component.set('v.myMessage', a.getReturnValue().customexception );
					component.set('v.data', a.getReturnValue().zefixAccounts );
					component.set('v.columns', [
						{label: 'Account Name',initialWidth: 300, fieldName: 'Name', type: 'text'},
						{label: 'Legal Seat', fieldName: 'UPC_Zefix_Legal_Seat__c', type: 'text'},						
						{label: 'UID', fieldName: 'UPC_UID__c', type: 'text'}, 
						{label: 'Zefix Status', fieldName: 'UPC_Zefix_Status__c', type: 'text'} 
					]);
				}

			}
			else {
				$A.get("e.force:closeQuickAction").fire();
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
	
	updateSelectedText: function (component, event) {
		var selectedRows = event.getParam('selectedRows');
		component.set('v.selectedRowsList',  event.getParam('selectedRows') );
        component.set('v.selectedRowsCount', selectedRows.length);
	},
	
	updateAccount: function (component, event) { 
		var obj =  JSON.stringify(component.get("v.selectedRowsList"));
		var hasUID = true;
		console.log(obj);
		if(!obj.includes('UPC_UID__c')){
			hasUID = false;
		}
		var action = component.get("c.callforUID");
        action.setParams({
			"recordId": component.get("v.recordId"),
			"accJson": obj,
			"hasUID": hasUID
        });
        action.setCallback(this, function(a) {			
			if( a.getReturnValue().successverifier ) { 
				$A.get("e.force:closeQuickAction").fire();
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
				$A.get("e.force:closeQuickAction").fire();
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