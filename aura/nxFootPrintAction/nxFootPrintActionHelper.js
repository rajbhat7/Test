({
	getThreshold: function(component){
		var action = component.get('c.retrieveThreshold');
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") {
				var threshold = response.getReturnValue();
				component.set('v.threshold', threshold);
			}
		});

		$A.enqueueAction(action);
	},

	checkAddress : function(component, fieldsToAddress) {
		var self = this;
		var action = component.get('c.callWS');
		action.setParams({
			'fieldsToAddress': JSON.stringify(fieldsToAddress)
		});
		action.setCallback(this, function(response){
			var returnValues = response.getReturnValue();
			console.log(returnValues);
			if( returnValues.successverifier ) {
				component.set('v.isFootprint', false);
				var address = JSON.parse(returnValues.addresses);
				var threshold = component.get('v.threshold');
				if(address.length == 0){
					alert('No Addresses found');
				}else if(address.length > threshold){
					console.log(address);
					//component.set("v.sortedBy", event.getParam("buildingId"));
					//component.set("v.sortedDirection", event.getParam("sortDirection"));
					component.set('v.data', address);
					component.set('v.columns', [
						{label: 'Building Id', sortable:true, fieldName: 'buildingId', type: "number", initialWidth: 125},
						{label: 'Address', fieldName: 'fullAddress', type: "text"},
						{label: 'Status', fieldName: 'buildingStatusName', type:"text"}
					]);
					this.sortData(component, 'buildingId', 'asc');
					
					component.set("v.currentStep", "2");
					
				}else{
					component.set('v.rowsSelected', address);
					self.footPrintCheck(component);	
				}		
			}else{
				component.set('v.isFootprint', true);
				var toast = component.find('toastError');
				$A.util.removeClass(toast, 'slds-hide');
				component.set('v.errorDescription', returnValues.customexception);
			}
		});

		$A.enqueueAction(action);
	},

	footPrintCheck: function(component){
		var self = this;
	
		var action = component.get('c.callFootPrintWS');
		action.setParams({
			'addressesChecked': JSON.stringify(component.get('v.rowsSelected'))
		});
		
		action.setCallback(this, function(response){
			var state = response.getState();
			var returnValues = response.getReturnValue();
            if (state === "SUCCESS") {
				if(returnValues.successverifier){				
					var listFootprints = JSON.parse(returnValues.footprintChecker);
					console.log(listFootprints);
					component.set('v.footPrintData', listFootprints);
					component.set("v.currentStep", "3");
				}else{
					var toast = component.find('toastError');
					$A.util.removeClass(toast, 'slds-hide');
					component.set('v.errorDescription', returnValues.customexception); 
				}
			}
		});
		$A.enqueueAction(action);
	},

	finishComponent: function(component){
		var self = this;
		var buildingId = document.querySelector('input[name="options"]:checked').id;
		var footPrintList = component.get('v.footPrintData');
		var listToSend = [];
		var isNewAddress = component.get('v.isNewAddress');
		if(footPrintList.length > 1){
			listToSend = footPrintList.filter(obj => {
				return obj.buildingId == buildingId
			  });
		}else if(footPrintList.length == 1){
			listToSend = footPrintList;
		}
		console.log(listToSend);
		
		var action = component.get('c.saveAddress');
		action.setParams({
			'fpSelected': JSON.stringify(listToSend),
			//'upcAddressId': component.get('v.selectedAddress'),
			'siteId': component.get('v.siteId'),
			'isNewAddress': isNewAddress
			//'hasLookup': component.get('v.hasLookup')
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			var control = response.getReturnValue();
			if (state === "SUCCESS") {
				if(!control.includes('Error:') ){
					if(isNewAddress == false){
						self.showToast('Success Message', 'success', 'Address updated');
						$A.get("e.force:closeQuickAction").fire();
						$A.get('e.force:refreshView').fire();
						//Case new site in Account or Opportunity
					}else if(isNewAddress == true && component.get('v.footPrintOpen') == true){
						component.set('v.selectedAddress', response.getReturnValue());
						component.set('v.footPrintOpen', false);
						component.set('v.isOpen', true);
						// Case new Address
					}else if(isNewAddress == true && component.get('v.siteOverride') == true){
						this.updateSite(component, control);
					}else{
						var navEvt = $A.get("e.force:navigateToSObject");
						navEvt.setParams({
						"recordId": control,
						"slideDevName": "Detail"
						});
						navEvt.fire();
					}
				}else{
					var toast = component.find('toastError');
					$A.util.removeClass(toast, 'slds-hide');
					component.set('v.errorDescription', control); 
				}
			}
		})
		$A.enqueueAction(action);
		
	},

	showToast: function(title, type, message){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : title,
			message: message,
			messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
			duration:' 5000',
			key: 'info_alt',
			type: type,
			mode: 'pester'
		});
		toastEvent.fire(); 
	},

	sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';

        data = Object.assign([],
            data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
        );
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer
            ? function(x) { return primer(x[field]) }
            : function(x) { return x[field] };

        return function (a, b) {
            var A = key(a);
            var B = key(b); 
            return reverse * ((A > B) - (B > A));
        };
	},
	
	validateFootprint: function(component){
		var streetName = component.find('street').get('v.value');
		var streetNumber = component.find('number').get('v.value');
		var city = component.find('city').get('v.value');
		var countryCode2 = component.find('country').get('v.value');
		var buildingName = component.find('buildingName').get('v.value');
		var zip = component.find('postcode').get('v.value');
		if((streetName != '' || buildingName != '') && zip != '' && city != '' && countryCode2 != ''){
			var fieldsToAddress = {};
			fieldsToAddress.UPC_STREETNAME1__c = streetName;
			fieldsToAddress.UPC_BUILDING_NUMBER__c = streetNumber;
			fieldsToAddress.UPC_LOCATIONNAME1__c = city
			fieldsToAddress.UPC_COUNTRYCODEA2__c = countryCode2;
			fieldsToAddress.UPC_BUILDINGNAME__c = buildingName;
			fieldsToAddress.UPC_POSTCODE__c = zip;
			this.footprintInsertion(component, JSON.stringify(fieldsToAddress));
		}else{
			component.set('v.errorDescription', 'Required fields: StreetName or Building Name, Postcode, Town and Country');
		}
	},

	footprintInsertion: function(component, serializedFields){
		var action = component.get('c.saveFootprintAddress');
		var isNewAddress = component.get('v.isNewAddress');
		action.setParams({
			fpSelected: serializedFields,
			siteId: component.get('v.siteId'),
			isNewAddress: isNewAddress
		});

		action.setCallback(this, function(response){
			var state = response.getState();
			if(state === 'SUCCESS'){
				var control = response.getReturnValue();
				if(!control.includes('Error:') ){
					if(isNewAddress == false){
						this.showToast('Success Message', 'success', 'Footprint address created');
						$A.get("e.force:closeQuickAction").fire();
						$A.get('e.force:refreshView').fire();
						//Case new site in Account or Opportunity
					}else if(isNewAddress == true && component.get('v.footPrintOpen') == true){
						component.set('v.selectedAddress', response.getReturnValue());
						component.set('v.footPrintOpen', false);
						component.set('v.isOpen', true);
						// Case new Address
					}else if(isNewAddress == true && component.get('v.siteOverride') == true){
						this.updateSite(component, control);
					}else{
						var navEvt = $A.get("e.force:navigateToSObject");
						navEvt.setParams({
						"recordId": control,
						"slideDevName": "Detail"
						});
						navEvt.fire();
					}
				}else{
					var toast = component.find('toastError');
					$A.util.removeClass(toast, 'slds-hide');
					component.set('v.errorDescription', control); 
				}
			}
		});
		
		$A.enqueueAction(action);
	},

	updateSite: function(component, addressId){
		var action = component.get('c.updateSiteOverride');
		action.setParams({
			siteId: component.get('v.siteId'),
			upcAddressId: addressId
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if(state === 'SUCCESS'){
				var navEvt = $A.get("e.force:navigateToSObject");
				navEvt.setParams({
					"recordId": component.get('v.siteId'),
					"slideDevName": "Detail"
				});
				navEvt.fire();	
			}
		});

		$A.enqueueAction(action);
	}
})