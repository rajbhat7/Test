({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var action = component.get("c.resetOpportunityRT");
        action.setParams({"recordId": recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");

            if(component.isValid() && state == "SUCCESS"){
                toastEvent.setParams({
                    "type": 'success',
                    "title": "Success",
                    "message": "Opportunity record type was changed to Renewal"
                });
                console.log('Done');
            } else {
                toastEvent.setParams({
                    "type": 'error',
                    "title": "Error",
                    "message": "There was a problem changing the pportunity record type"
                });
                console.log('There was a problem : '+response.getError());
            }
            toastEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    }
})