({
    retriveData : function(component) {
        var action = component.get('c.retrieveSiteAddress');
        action.setParams({
            siteId: component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log('here');
                component.set('v.data', a.getReturnValue());
                component.set('v.columns', [
                    {label: 'Site Address Name', fieldName:'UPC_Site_Address_Name__c', type: 'text'}
                ]);
            }
        });

        $A.enqueueAction(action);
    },

    selectPrimaryAddress : function(component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedPrimaryAddress', selectedRows[0].UPC_Address__c);
    },
 
    updatePrimaryAddressHelper : function (component, event) {
        var action = component.get('c.updatePrimaryAddress');
        action.setParams({
            siteId: component.get("v.recordId"),
            upcAddress: component.get("v.selectedPrimaryAddress")
        });

        action.setCallback(this, function (a) {
           
            var state = a.getState();
            if (state === "SUCCESS") {
                var error = a.getReturnValue();
                if(error == ''){
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Success!",
                        message: "Updated successfully!",
                        type: "success"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    
                } else{
                    var toast = component.find('toastError');
                    $A.util.removeClass(toast, 'slds-hide');
                    component.set('v.errorDescription', error);
                }
            }
        });

        $A.enqueueAction(action);
    }
})