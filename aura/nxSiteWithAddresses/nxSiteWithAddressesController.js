({
	doInit : function(component, event, helper) {
		component.set('v.objectId', component.get('v.recordId'));
        component.set('v.objectName', component.get('v.sObjectName'));
        
        // First action to know if it is a community user
        var actionForCommunity = component.get("c.isCommunityUser");
        actionForCommunity.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                component.set("v.isCommunityUser", response.getReturnValue());

                // Second action to get the list of sites
                var action = component.get("c.getSites");
                action.setParams({
                    objectId: component.get("v.recordId")
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.sites", response.getReturnValue());
                        
                        // Change url for community users
                        if (component.get("v.isCommunityUser"))
                        {
                            component.get("v.sites").forEach(function(element) {
                                element.Site_Name__c = element.Site_Name__c.replace(/href=\"/g,"href=\"/Partner");
                                element.Site_Addresses__r.forEach(function(element) {
                                    element.UPC_Site_Address_Link__c = element.UPC_Site_Address_Link__c.replace(/href=\"/g,"href=\"/Partner");
                                });
                            });
                        }
                        
                        component.set("v.numberOfSites", response.getReturnValue().length);
                    }
                    else
                    {
                        console.log('Component initialisation error: accessing apex controller getSites');
                    }
                });
                $A.enqueueAction(action);

            }
            else
            {
                console.log('Component initialisation error: accessing apex controller isCommunityUser');
            }
        });
        $A.enqueueAction(actionForCommunity);
        

	},

	showSection : function(component, event, helper) {
		// Get clicked section
		var ctarget = event.currentTarget;
		var id_str = ctarget.dataset.value;
		var element = document.getElementById("accordion-details-" + id_str);
		var chevronopen = document.getElementById("chevron-open-" + id_str);
		var chevronclose = document.getElementById("chevron-close-" + id_str);
		var wasHidden = element.classList.contains("slds-hide");

		// Now that open/close state of clicked section is saved, close all sections
		var elements = document.getElementsByClassName("accordion-body");
        for (var i=0; i<elements.length; i++) {
			elements[i].classList.remove("slds-show");
			elements[i].classList.add("slds-hide");
		}
		var closeChevronElements = document.getElementsByClassName("chevron-close");
        for (var i=0; i<closeChevronElements.length; i++) {
			closeChevronElements[i].classList.remove("slds-hide");
			closeChevronElements[i].classList.add("slds-show");
		}
		var openChevronElements = document.getElementsByClassName("chevron-open");
        for (var i=0; i<openChevronElements.length; i++) {
			openChevronElements[i].classList.remove("slds-show");
			openChevronElements[i].classList.add("slds-hide");
        }

		// Show/hide clicked section
		if (wasHidden)
		{
			console.log('showing');
			element.classList.remove("slds-hide");
			element.classList.add("slds-show");
			chevronopen.classList.remove("slds-hide");
			chevronopen.classList.add("slds-show");
			chevronclose.classList.remove("slds-show");
			chevronclose.classList.add("slds-hide");
		}
		else
		{
			console.log('hiding');
			element.classList.remove("slds-show");
			element.classList.add("slds-hide");
			chevronopen.classList.remove("slds-show");
			chevronopen.classList.add("slds-hide");
			chevronclose.classList.remove("slds-hide");
			chevronclose.classList.add("slds-show");
		}
	},

	openModel: function(component, event, helper) {
		// for Display Model,set the "isOpen" attribute to "true"
		component.set("v.isOpen", true);
	 },
	 /*
	createSite : function (component, event, helper) {
		component.set("v.isOpen", true);
		var createRecordEvent = $A.get("e.force:createRecord");
		createRecordEvent.setParams({
			"entityApiName": "UPC_Site__c",
			"defaultFieldValues": {
				"UPC_Account__c" : component.get("v.recordId")
			}
		});
		createRecordEvent.fire();
	}*/

	
})