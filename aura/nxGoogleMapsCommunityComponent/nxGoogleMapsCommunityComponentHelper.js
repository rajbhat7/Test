({
    checkIfCommunity: function(component, helper){
        var action = component.get('c.isCommunity');
        action.setParams({
            recordId: component.get('v.recordId')
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                var isCommunity = response.getReturnValue();
                component.set('v.isCommunity', isCommunity);
                var loading = component.get('v.loaded');
                console.log(isCommunity);
                console.log(loading);
                if(loading == false){
                    /* If the user is in Community, it needs to retrieve the SObject name 
                        This functionality is not supported in Communities due to lack of support for force:hasSObjectName
                    */
                    if(isCommunity == true){
                        helper.retrieveSObjectName(component, helper);
                    }else{
                        helper.mapLocation(component, helper, component.get('v.sObjectName'));
                    }
                    
                }
            }
        });

        $A.enqueueAction(action);
    },

    retrieveSObjectName: function(component, helper){
        //Retrieve the SObject Name (Only needed when User is acessing component in a Community)
        var action = component.get('c.retrieveSObjectName');
        action.setParams({
            recordId: component.get('v.recordId')
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var sObjectName = response.getReturnValue();
                helper.mapLocation(component, helper, sObjectName);
            }
        });

        $A.enqueueAction(action);
    },

    mapLocation: function(component, helper, sObjectName){
        //Prepare the information to be displayed on the Map
        var mapOptionsCenter;
        var record = component.get('v.targetFields');
        var longitude;
        var latitude;
        var address;
        var name;
        console.log(sObjectName);
        if(sObjectName == 'UPC_Site__c'){
            longitude = record.UPC_Longitude__c;
            latitude = record.UPC_Latitude__c;
            address = record.UPC_Basic_Address__c;
            name = record.Site_Name__c;
        }else{            
            longitude = record.UPC_Geolocation__Longitude__s;
            latitude = record.UPC_Geolocation__Latitude__s;
            address = record.UPC_Address_Formula__c;
            name = record.UPC_Address_Formula__c;
        }

        console.log(longitude);

        if(latitude != null && longitude != null){
            mapOptionsCenter = {"lat":parseFloat(latitude), "lng":parseFloat(longitude)};
        }else{
            mapOptionsCenter = {"lat":0, "lng":0, "address": address};
        }

        var mapData = Array();

        var siteData = {};
        if(latitude != null && longitude != null){
            siteData.lat = parseFloat(latitude);
            siteData.lng = parseFloat(longitude);                            
        }else{
            siteData.lat = 0;
            siteData.lng = 0;
        }
        siteData.address = address;
        siteData.markerText = name;

        mapData.push(siteData);

        component.set('v.mapOptionsCenter', mapOptionsCenter);
        component.set('v.mapData', mapData);      
        component.set('v.loaded', true);
        component.set('v.lcHost', window.location.hostname);

        helper.handleMapListener(component, event, helper);
    },

    sendToVF: function(component, helper) {
        //Prepare message in the format required in VF page
        var message = {
			            "loadGoogleMap" : true,
            			"mapData": component.get('v.mapData'), 
            			"mapOptions": component.get('v.mapOptions'),  
                        'mapOptionsCenter': component.get('v.mapOptionsCenter'),
        		} ;
        
        //Send message to VF
        helper.sendMessage(component, helper, message);
    },
    sendMessage: function(component, helper, message){
        //Send message to VF
        message.origin = window.location.hostname;        
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
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
})