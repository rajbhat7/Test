({
    checkIfCommunity: function(component, helper){
        var action = component.get('c.isCommunity');
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                var isCommunity = response.getReturnValue();
                component.set('v.isCommunity', isCommunity);
                var loading = component.get('v.loaded');
                if(loading == false){
                    helper.retrieveAccountSites(component, helper);
                }
            }
        });

        $A.enqueueAction(action);
    },

    retrieveAccountSites: function(component, helper){
        var action = component.get('c.getAccountSites');
        action.setParams({
            recordId: component.get('v.objectId')
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state:', state);
            if (state == "SUCCESS") {
                var listSites = JSON.parse(response.getReturnValue());
                if(listSites.length > 0){
                    var mapOptionsCenter;
                    if(listSites[0].site.UPC_Latitude__c != null && listSites[0].site.UPC_Longitude__c != null){
                        mapOptionsCenter = {"lat":parseFloat(listSites[0].site.UPC_Latitude__c), "lng":parseFloat(listSites[0].site.UPC_Longitude__c)};
                    }else{
                        mapOptionsCenter = {"lat":0, "lng":0, "address": listSites[0].site.UPC_Basic_Address__c};
                    }
                    
                    var mapData = Array();
                    //cmp.set("v.opportunities", response.getReturnValue());
                    for(var i=0; i<listSites.length; i++){
                        var siteData = {};
                        if(listSites[i].site.UPC_Latitude__c != null && listSites[i].site.UPC_Longitude__c != null){
                            siteData.lat = parseFloat(listSites[i].site.UPC_Latitude__c);
                            siteData.lng = parseFloat(listSites[i].site.UPC_Longitude__c);                            
                        }else{
                            siteData.lat = 0;
                            siteData.lng = 0;
                        }
                        siteData.Id = listSites[i].site.Id;
                        siteData.ftthColour = listSites[i].site.UPC_FTTH_Rollup__c;
                        siteData.hfcColour = listSites[i].site.UPC_HFC_Rollup__c;
                        siteData.address = listSites[i].site.UPC_Basic_Address__c;
                        siteData.markerText = listSites[i].site.Name;
                        siteData.listServices = listSites[i].listServices;
                        mapData.push(siteData);
                    
                    }
                    component.set('v.mapOptionsCenter', mapOptionsCenter);
                    component.set('v.mapData', mapData);
                                   
                    component.set('v.loaded', true); 
                    
                    component.set('v.lcHost', window.location.hostname);

                    helper.handleMapListener(component, event, helper);
                    }
                }

            });
        $A.enqueueAction(action);
    },

    sendToVF: function(component, helper) {
        //Prepare message in the format required in VF page
        var message = {
			            "loadGoogleMap" : true,
            			"mapData": component.get('v.mapData'), 
            			"mapOptions": component.get('v.mapOptions'),  
                        'mapOptionsCenter': component.get('v.mapOptionsCenter'),
                        'isClicked': component.get('v.isClicked'),
                        'objectId': component.get('v.objectId') 
        		} ;
        
        //Send message to VF
        helper.sendMessage(component, helper, message);
    },
    sendMessage: function(component, helper, message){
        //Send message to VF
        message.origin = window.location.hostname;
        console.log('here');
        
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        console.log('here1');
        vfWindow.postMessage(message, component.get("v.vfHost"));
                 
    },

    handleMapListener: function(component, event, helper){
        //Add message listener
        var eventListener = function(event) {
            //Can enable origin control for more security
            //if (event.origin != vfOrigin) {
                //console.log('Wrong Origin');
                // Not the expected origin: Reject the message!
                //return;
            //}
            
            // Handle the message
            console.log(event.data.vfHost);
            if(event.data.state == 'LOADED'){
                
                window.removeEventListener("message", eventListener);
                //Set vfHost which will be used later to send message
                component.set('v.vfHost', event.data.vfHost);
                
                //Send data to VF page to draw map
                helper.sendToVF(component, helper);
            }
        };

        window.addEventListener("message",eventListener);
    },

    processClick: function(component, event, helper){
        var siteID = event.currentTarget.dataset.siteid;
        console.log(siteID);
        var listSites = component.get('v.mapData');
        var choosenSite = listSites.find(x => x.Id == siteID);
        console.log(choosenSite);
        var mapOptionsCenter;
        if(choosenSite.lat != null && choosenSite.lng != null){
            mapOptionsCenter = {"lat":parseFloat(choosenSite.lat), "lng":parseFloat(choosenSite.lng)};
        }else{
            mapOptionsCenter = {"lat":0, "lng":0, "address": choosenSite.address};
        }

        component.set('v.mapOptionsCenter', mapOptionsCenter);
        component.set('v.isClicked', true);
        
        var iframe = component.find("vfFrame").getElement();        
        helper.handleMapListener(component, event, helper);
        
        iframe.src = iframe.src;
    }
})