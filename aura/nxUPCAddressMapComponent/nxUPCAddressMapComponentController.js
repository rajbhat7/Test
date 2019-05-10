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
				component.set('v.mapMarkers', [{
					location: {
						Street: component.get("v.targetFields")["UPC_MapStreet__c"],
						City: component.get("v.targetFields")["UPC_LOCATIONNAME1__c"], 
						PostalCode: component.get("v.targetFields")["UPC_POSTCODE__c"]
					},
					title: component.get("v.targetFields")["UPC_Address_Formula__c"] 
				}]);
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