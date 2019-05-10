({
    
    redirectTo : function (component) {
        
        var opptyId = component.get("v.recordId"); // Opportunity Id
       	var action = component.get("c.getPathPrefix"); // function on Apex class
        var redirect_page = "/cscrmCmtyNewBasketRedirectCntrl"; // custom VF page for the basket creation 
        
        action.setCallback(this, function(response) { 
            
            if (response.getState() === "SUCCESS"){
                var pathPrefix = response.getReturnValue().replace(/\/s$/, ""); // removing the /s
            	window.location.href = pathPrefix + redirect_page 
                + "?opptyId=" + opptyId 
            	+ "&retURL=" + pathPrefix;
            }
        });
       
        $A.enqueueAction(action);                   
    }
})