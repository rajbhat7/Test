({
    doInit: function(component, event, helper) {
        //Set Iframe width dinamically
        var widthSize = document.documentElement.clientWidth;
        component.set('v.widthValue', widthSize * 0.30);
        
        //Check if it's a Community or Salesforce user
        helper.checkIfCommunity(component, helper);
    },
})