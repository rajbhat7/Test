({ 
	handleRecordUpdated: function (component, event, helper) {
		switch (event.getParams().changeType) {
			case "ERROR":
				// handle error
				break;
			case "LOADED":
				console.log(JSON.parse(JSON.stringify(component.get("v.record"))));
				console.log(JSON.parse(JSON.stringify(component.get("v.targetFields"))));
				console.log();
				component.set('v.mapLoaded', true); 
				if( component.get("v.targetFields")["UPC_MapStreet__c"] != null ) {
					console.log('Here');
					component.set('v.mapMarkers', [{
						location: {
							Street: component.get("v.targetFields")["UPC_MapStreet__c"],
							City: component.get("v.targetFields")["UPC_MapCity__c"], 
							PostalCode: component.get("v.targetFields")["UPC_MapPostCode__c"]
						},
						title: component.get("v.targetFields")["Site_Name__c"] 
					}]);
				}
				else {
					console.log('Latitude');
					component.set('v.mapMarkers', [{
						location: {
							Latitude: component.get("v.targetFields")["UPC_Geolocation__Latitude__s"] ,
   							Longitude: component.get("v.targetFields")["UPC_Geolocation__Longitude__s"] 
						},
						title: component.get("v.targetFields")["Site_Name__c"] 
					}]); 
					console.log( component.get("v.mapMarkers") );
				}
				
				component.set('v.zoomLevel', 16);
				break;
			case "REMOVED":
				// stuff
				break;
			case "CHANGED":
				// more stuff
				break;
		}
	}
})