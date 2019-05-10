({
	doInit: function(component, event, helper){
		helper.getThreshold(component);
		var siteId;
		if(component.get('v.siteOverride') == false || component.get('v.siteOverride') == undefined){
			siteId = component.get('v.recordId');
			component.set('v.siteId', siteId);
		}
	},

	closeModel: function(component, event, helper){
		var isFootPrintOpen = component.get('v.footPrintOpen');
		var isNewAddress = component.get('v.isNewAddress');
		if(isFootPrintOpen == true && isNewAddress){
			component.set('v.footPrintOpen', false);
			component.set('v.isOpen', true);
		}else if(component.get('v.siteOverride') == true){
			var navEvt = $A.get("e.force:navigateToSObject");
			navEvt.setParams({
				"recordId": component.get('v.siteId'),
				"slideDevName": "Detail"
			});
			navEvt.fire();	
		}else{
			var homeEvent = $A.get("e.force:navigateToObjectHome");
			homeEvent.setParams({
				"scope": "UPC_ADBASE__c"
			});
    		homeEvent.fire();
		}
	},
  
	moveNext : function(component,event,helper){
		 
	  // control the next button based on 'currentStep' attribute value    
	  var getCurrentStep = component.get("v.currentStep");
	  //var selectedAddress = component.get('v.selectedAddress');
	  var toast = component.find('toastError');
	  var divChange = component.find('bodyChange');
		 if(getCurrentStep == "1"){
			/* Commented on 04/12/2018 for PT7791
				if(selectedAddress != ''){
				component.set('v.hasLookup', true);
				$A.util.addClass(toast, 'slds-hide');
				helper.footPrintCheck(component, null);
			if(selectedAddress == ''){
				component.set('v.hasLookup', false);*/
			var fieldsToAddress = {};
			var streetName = component.find('street').get('v.value');
			var postCode = component.find('postcode').get('v.value');
			var city = component.find('city').get('v.value');
			if(streetName != '' && (postCode != '' || city != '')){
				fieldsToAddress.streetName = component.find('street').get('v.value');
				fieldsToAddress.streetNumber = component.find('number').get('v.value');
				fieldsToAddress.city = component.find('city').get('v.value');
				fieldsToAddress.countryCode2 = component.find('country').get('v.value');
				fieldsToAddress.buildingName = component.find('buildingName').get('v.value');
				if(component.find('postcode').get('v.value') != ''){
					fieldsToAddress.zip = component.find('postcode').get('v.value');
				}
				$A.util.addClass(toast, 'slds-hide');
				$A.util.removeClass(divChange, 'contentBodyChanged');
				$A.util.addClass(divChange, 'contentBody');
				helper.checkAddress(component, fieldsToAddress);
			}else{
				$A.util.removeClass(toast, 'slds-hide');
				$A.util.removeClass(divChange, 'contentBody');
				$A.util.addClass(divChange, 'contentBodyChanged');
				component.set('v.errorDescription', 'Required fields: Street Name and Postcode or Town');
			}						
		
			//helper.checkAddress(component);
		 }else if(getCurrentStep == "2" && component.get('v.rowsSelected') != ''){
			helper.footPrintCheck(component);		
		 }
	 },
	 
	 moveBack : function(component,event,helper){
	   // control the back button based on 'currentStep' attribute value    
		 var getCurrentStep = component.get("v.currentStep");
		 var data = component.get('v.data');
		  if(getCurrentStep == "2"){
			 component.set("v.currentStep", "1");
		  }
		  else if(getCurrentStep == "3" && data != null){
			 component.set("v.currentStep", "2");
		  }else if(getCurrentStep == "3" && data == null){
			 component.set("v.currentStep", "1");
		  }
	 },
	 
	 finish : function(component,event,helper){
		 helper.finishComponent(component);
	 },

	 updateSelectedRows: function(component,event,helper){
		 var selectedRows = event.getParam('selectedRows');
		 var currentStep = component.get('v.currentStep');  
		 var setRows = [];
		 for (var i = 0; i < selectedRows.length; i++){
			setRows.push(selectedRows[i]);
		 }
		 console.log(setRows);
		 if(currentStep == '2'){
			component.set("v.rowsSelected", setRows);
		 }
	 },
	
	// when user click direactly on step 1,step 2 or step 3 indicator then showing appropriate step using set 'currentStep'   
	/* selectFromHeaderStep1 : function(component,event,helper){
		 component.set("v.currentStep", "1");
	 },
	 selectFromHeaderStep2 : function(component,event,helper){
		 component.set("v.currentStep", "2");
		 //helper.checkAddress(component);
	 },
	 selectFromHeaderStep3 : function(component,event,helper){
		 component.set("v.currentStep", "3");
	 },*/

	 onLookupChange: function(component, event, helper){
		var fields = component.find("addressFields");
		var lookup = component.get('v.selectedAddress');
		if(lookup != ''){
			$A.util.addClass(fields, 'slds-hide');
		}else{
			$A.util.removeClass(fields, 'slds-hide');
		}
	 },

	 onChangeSearch: function(component, event, helper){
		component.set("v.recordsReturned", event.getParam('recordsReturned'));		 
	 },

	 updateColumnSorting: function(component, event, helper){
		var fieldName = event.getParam('fieldName');
		var sortDirection = event.getParam('sortDirection');
		component.set("v.sortedBy", fieldName);
		component.set("v.sortedDirection", sortDirection);
		helper.sortData(component, fieldName, sortDirection);
	 },

	 createFootprint: function(component, event, helper){
		 helper.validateFootprint(component);
	 }

 })