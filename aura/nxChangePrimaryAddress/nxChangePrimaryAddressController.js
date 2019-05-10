({
    doInit: function (component, event, helper) {
       helper.retriveData(component);
    },

    selectRow: function(component, event, helper) {
        helper.selectPrimaryAddress(component, event);
    },

    updateSite: function (component, event, helper) {
        helper.updatePrimaryAddressHelper(component);
    },

    closeModal: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
    
})