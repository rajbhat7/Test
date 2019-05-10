({
    doInit: function(component, event, helper) {
        //Set Iframe width dinamically
        var objectId = component.get('v.objectId');
        if(objectId == undefined){
            component.set('v.objectId', component.get('v.recordId'));
            var widthSize = document.documentElement.clientWidth;
            component.set('v.widthValue', widthSize * 0.30);
        }
        //Check if it's a Community or Salesforce user
        helper.checkIfCommunity(component, helper);
    },

    siteClicked: function(component, event, helper){
        //Get clicked Site Id
        helper.processClick(component, event, helper); 
    },
    	
})