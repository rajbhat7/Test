require(['cs_js/cs-full'], function(CS) {
	var NUMBER_DETAILS_DEFINITION_NAME = 'Number_Details';
	var OE_TYPE_ATTRIBUTE_NAME = 'OE_Type_0';
	var QUANTITY_ATTRIBUTE_NAME = 'Quantity_0';
	var DEVICES_DEFINITION_NAME = 'Devices';
	var ADDITIONAL_ADD_ONS_DEFINITION_NAME = 'DigiPhone_Options';
	var NUMBER_PORTING_ATTR_NAME = 'Number_Portings_0';
	var NUMBER_PORTING_SHADOW_ATTR_NAME = 'Number_Portings_shadow_0';
	var DIGIPHONE_DEFINITION_NUMBER = 'Business Digital Phone';
	var BIFP_DEFINITION_NAME = 'Business Internet Fiber Power';
	var totalRecurringChargeAttributeName = 'Total_MRC_0';
	var totalOneOffChargeAttributeName = 'Total_OTC_0';
	var numberOfSubscriptionsAttributeName = 'Number_Of_Subscriptions_0';
	var NUMBER_DETAILS_ATTRIBUTE_NAME = 'Number_Details_Add_On_0';
	var DEVICES_ATTRIBUTE_NAME = 'Devices_Add_On_0';
	var ADDITIONAL_ADDONS_ATTRIBUTE_NAME = 'Additional_Add_Ons_0';
	var BUSINESS_MOBILE_DEFINITION_NAME = 'Business Mobile';
	var BUSINESS_DIGITAL_TV_DEFINITON_NAME = 'Business Digital TV';
	var ADDON_ABBREVIATION_ATTRIBUTE_NAME = 'Addon_Abbreviation_0';
	var EXTERNAL_DIRECT_DIAL_ATTRIBUTE_NAME = 'External_direct_dial_0';
	var BUSINESS_VOICE_DEFINITION_NAME = 'Business Voice';
	var ADDITIONAL_NUMBERS_DEFINITION_NAME = 'Additional_Numbers';
	var NUMBER_PORTING_DEFINITION_NAME = 'Number_Porting';
	var SPECIAL_ARRANGEMENT_DEFINITION_NAME = 'Special_Arrangement';
	var BACKUP_NUMBER_DEFINITION_NAME = 'Backup_Number';
	var COMMUNICATION_PROTOCOL_ATTR_NAME = 'Communication_protocol_0';
	var COMMUNICATION_PROTOCOL_SHADOW_ATTR_NAME = 'Communication_protocol_shadow_0'

	CS.EventHandler.subscribe(
		CS.EventHandler.Event.CONFIGURATOR_READY,
		function(payload){
			console.log('Event Subscription: CONFIGURATOR_READY');
			var myBasketId = CS.params.basketId;
			if(CS.getAttributeWrapper('Basket_id_temp_0') !== undefined) {
				CS.setAttributeValue('Basket_id_temp_0', myBasketId);
			}

			if (CS.getAttributeValue('Basket_Approval_Status_0') === 'Approved' || 
				CS.getAttributeValue('Basket_Approval_Status_0') === 'Basket is Pending Approval' || 
				CS.getAttributeValue('Basket_Approval_Status_0') === 'Rejected') {
				addOverlay();
			}

			loadOEForParentProducts();
			loadOEForRelatedProducts();
			hideAttributeFromBasketScreenBDTV();
		}
	);

	CS.EventHandler.subscribe(
		CS.EventHandler.Event.RULES_FINISHED, 
		function(payload) {
			console.log('Event Subscription: RULES_FINISHED');
			// This is needed if OE is dependent on some attribute value.
			// If it is load once and forget then no additional action is needed.
			updateOEForParentProducts();
			//loadOEForRelatedProducts();
			checkForNumberForwarding();
			calculateTotalPrices();
			loadPW();
			checkForExpressInstallation();
			performLimitedAddOnsValidation();
			setOETabsQuantity();
			hideExternalDialNumberForAdditionalAddons();
		}
	);

	CS.EventHandler.subscribe(
		CS.EventHandler.Event.AFTER_FINISH_ACTION,
		function(payload) {
			console.log('Event Subscription: AFTER_FINISH_ACTION');
			loadPW();
		}
	);

	CS.EventHandler.subscribe(
		CS.EventHandler.Event.AFTER_CONTINUE_ACTION, 
		function(payload) {
			console.log('Event Subscription: AFTER_CONTINUE_ACTION');
			loadOEForParentProducts();
		}
	);

	CS.EventHandler.subscribe(
		CS.EventHandler.Event.AFTER_CANCEL_ACTION, 
		function(payload) {
			console.log('Event Subscription: AFTER_CONTINUE_ACTION');
			loadOEForParentProducts();
		}
	);

	CS.EventHandler.subscribe(
		CS.EventHandler.Event.AFTER_EDIT_RELATED_PRODUCT_ACTION, 
		function(payload) {
			console.log('Event Subscription: AFTER_EDIT_RELATED_PRODUCT_ACTION');
			loadOEForParentProducts();
			loadOEForRelatedProducts();
			checkForNumberForwarding();
		}
	);
	
	function hideAttributeFromBasketScreenBDTV() {
	    var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(BUSINESS_DIGITAL_TV_DEFINITON_NAME)) {
			if (document.getElementById('BDTV:Details:Availability_Check_Required_0') !== null && CS.getAttributeValue('Basket_id_temp_0') !== "") { 
                var availabilityCheckRequiredTrParent = document.getElementById('BDTV:Details:Availability_Check_Required_0').parentElement.parentElement.parentElement.parentElement.parentElement; 
                availabilityCheckRequiredTrParent.style.display = 'none'; 
            }
		}
	}

	function calculateTotalPrices() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(DIGIPHONE_DEFINITION_NUMBER)
			|| currentConfigReference.includes(BUSINESS_VOICE_DEFINITION_NAME)) {
			setTotalRecurring(true);
			setTotalOneOff(true);
		}
	}

	function loadPW() {
		var customPluginJsonObject = {}; 
		// show or hide widget button 
		customPluginJsonObject.hideWidgetButton = false; 

		customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName = 'CS_AddOn'; 
		customPluginJsonObject.addOnPriceItemAttributeName = '_AddOnPriceItemMain_';  
		customPluginJsonObject.useDependencyEngine = true;

		CS.EAPI.initializeWidget(CS.UI.getCurrentInstance().getCurrentConfigReference(), customPluginJsonObject);
	}

	function loadOEForParentProducts() {
		if(CS.UI.getCurrentInstance().getCurrentConfigReference() === '') {
			loadOEForDigiPhone();
			loadOEForBusinessMobile();
			loadOEForBusinessVoice();
		}
	}

	function loadOEForRelatedProducts() {
		loadOEForNumbersRelatedProduct();
		loadOEForDevicesRelatedProduct();
		loadOEForAdditionalDetailsRelatedProduct();
	}

	function updateOEForParentProducts() {
		updateOEForDigiPhone();
		updateOEForBusinessVoice();
	}

	function updateOEForDigiPhone() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(DIGIPHONE_DEFINITION_NUMBER)) {
			var display = [];
			var internalPorting = CS.getAttributeValue(NUMBER_PORTING_ATTR_NAME);
			var internalPortingShadow = CS.getAttributeValue(NUMBER_PORTING_SHADOW_ATTR_NAME);

			if(internalPortingShadow !== internalPorting) {
				loadOEForDigiPhone();
				CS.setAttributeValue(NUMBER_PORTING_SHADOW_ATTR_NAME,internalPorting,true);
			}
		}
	}

	function loadOEForDigiPhone() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(DIGIPHONE_DEFINITION_NUMBER)) {
			var display = [];
			var internalPorting = CS.getAttributeValue(NUMBER_PORTING_ATTR_NAME);
			removeTechnicalPart();

			if(internalPorting === 'Yes_Internal' || internalPorting === 'Yes_External') {
				display.push('Number Porting for Phone');
			}

			CS.setAttributeValue(NUMBER_PORTING_SHADOW_ATTR_NAME,internalPorting,true);

			if(display.length > 0) {
				SPM.loadNonCommercialDefinitions(null, display, 'renderTabs');
			}
		}
	}

	function updateOEForBusinessVoice() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(BUSINESS_VOICE_DEFINITION_NAME)) {
			var internalPorting = CS.getAttributeValue(NUMBER_PORTING_ATTR_NAME);
			var internalPortingShadow = CS.getAttributeValue(NUMBER_PORTING_SHADOW_ATTR_NAME);
			var communicationProtocol = CS.getAttributeValue(COMMUNICATION_PROTOCOL_ATTR_NAME);
			var communicationProtocolShadow = CS.getAttributeValue(COMMUNICATION_PROTOCOL_SHADOW_ATTR_NAME);

			if(internalPorting !== internalPortingShadow 
				|| communicationProtocol !== communicationProtocolShadow) {
				loadOEForBusinessVoice();
			}
		}
	}

	function loadOEForBusinessVoice() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(BUSINESS_VOICE_DEFINITION_NAME)) {
			var display = ['Shipping Address'];
			var internalPorting = CS.getAttributeValue(NUMBER_PORTING_ATTR_NAME);
			var communicationProtocol = CS.getAttributeValue(COMMUNICATION_PROTOCOL_ATTR_NAME);
			removeTechnicalPart();

			if(internalPorting === 'Yes_Internal' || internalPorting === 'Yes_External') {
				display.push('Number Porting for Phone');
			}

			if(communicationProtocol === 'IP') {
				display.push('IP PBX Details');
			}

			CS.setAttributeValue(NUMBER_PORTING_SHADOW_ATTR_NAME,internalPorting,true);
			CS.setAttributeValue(COMMUNICATION_PROTOCOL_SHADOW_ATTR_NAME,communicationProtocol,true);

			if(display.length > 0) {
				SPM.loadNonCommercialDefinitions(null, display, 'renderTabs');
			}
		}
	}

	function loadOEForBusinessMobile() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(BUSINESS_MOBILE_DEFINITION_NAME)) {
			jQuery('#technicalConfigFrame').remove();
			var targetSrc = jQuery('.screen-footer')[0];
			targetSrc = jQuery(targetSrc).prev()[0];
			var screenContent = targetSrc;
			jQuery(screenContent).attr("data-tech", '');

			var display = ['Shipping Address','Number Porting'];

			SPM.loadNonCommercialDefinitions(null, display, 'renderTabs');

			SPM.registerOnLoad("Number Porting", setOETabsQuantity);
		}
	}

	function setOETabsQuantity() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(BUSINESS_MOBILE_DEFINITION_NAME)) {
			var numberOfPortings = CS.getAttributeValue('Number_Of_Subscriptions_0');
			if(numberOfPortings > 0) {
				SPM.setQuantity('Number Porting', 0, numberOfPortings);
			}
		}
	}

	function loadOEForNumbersRelatedProduct() {
		var currentConfigReference = CS.UI.getCurrentInstance().getCurrentConfigReference();
		if(currentConfigReference.includes(NUMBER_DETAILS_DEFINITION_NAME)
			|| currentConfigReference.includes(ADDITIONAL_NUMBERS_DEFINITION_NAME)
			|| currentConfigReference.includes(NUMBER_PORTING_DEFINITION_NAME)
			|| currentConfigReference.includes(SPECIAL_ARRANGEMENT_DEFINITION_NAME)
			|| currentConfigReference.includes(BACKUP_NUMBER_DEFINITION_NAME)) {
			var display = [];
			var oeType = CS.getAttributeValue(currentConfigReference + ':' + OE_TYPE_ATTRIBUTE_NAME);
			removeTechnicalPart();

			if(oeType === 'Block 10') {
				display.push('Porting Block Numbers 10');
			} else if(oeType === 'Block 100') {
				display.push('Portings Block Numbers 100');
			} else if(oeType === 'Analog') {
				display.push('Analog Number');
			} else if(oeType === 'MSN') {
				display.push('MSN Block Numbers');
			} else if(oeType === 'New Number') {
				display.push('Dialling Code');
			} else if(oeType === 'New Number Code Required') {
				display.push('Diallings Code Mandatory');
			} else if(oeType === 'CLIP Number') {
				display.push('CLIP Number');
			} else if(oeType === 'Backup Number') {
				display.push('Backup Number');
			}

			if(display.length > 0) {
				SPM.loadNonCommercialDefinitionsOnRp(null, display, 'renderTabs', null);
			}
		}
	}

	function loadOEForDevicesRelatedProduct() {
		var currentConfigReference = CS.UI.getCurrentInstance().getCurrentConfigReference();
		if(currentConfigReference.includes(DEVICES_DEFINITION_NAME)) {
			removeTechnicalPart();
			var display = ['Device Number'];
			SPM.loadNonCommercialDefinitionsOnRp(null, display, 'renderTabs', null);
		}
	}

	function checkForExpressInstallation() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(BIFP_DEFINITION_NAME)) {
			var el = Object.keys(CS.Service.config).find(a =>a.includes("Express_Installation_Addon_0:"));

			if(el !== undefined) {
				CS.setAttributeValue('Has_EI_AO_0','Yes',false);
			} else {
				CS.setAttributeValue('Has_EI_AO_0','No',false);
			}
		}
	}

	function loadOEForAdditionalDetailsRelatedProduct() {
		var currentConfigReference = CS.UI.getCurrentInstance().getCurrentConfigReference();
		if(currentConfigReference.includes(ADDITIONAL_ADD_ONS_DEFINITION_NAME)) {
			removeTechnicalPart();
			var display = [];
			var oeType = CS.getAttributeValue(currentConfigReference + ':' + OE_TYPE_ATTRIBUTE_NAME);
			var quantity = CS.getAttributeValue(currentConfigReference + ':' + QUANTITY_ATTRIBUTE_NAME);

			if(oeType === 'Call Forwarding') {
				display.push('Hunt group planner (call forwarding)');
			}

			if(display.length > 0) {
				SPM.loadNonCommercialDefinitionsOnRp(null, display, 'renderTabs', null);
			}

			SPM.registerOnLoad("Hunt group planner (call forwarding)", prepopulateRowsParent);
		}
	}

	function hideExternalDialNumberForAdditionalAddons() {
		var currentConfigReference = CS.UI.getCurrentInstance().getCurrentConfigReference();
		if(currentConfigReference.includes(ADDITIONAL_ADD_ONS_DEFINITION_NAME)) {
			var attrName = CS.Service.getCurrentConfigRef() + ':' + EXTERNAL_DIRECT_DIAL_ATTRIBUTE_NAME;
			if(CS.getAttributeValue(ADDON_ABBREVIATION_ATTRIBUTE_NAME) !== 'CFW') {
				hideAttribute(attrName);
			} else {
				showAttribute(attrName);
			}
		}
	}

	function hideAttribute(attrName) {
		jQuery("td:has([name='" + attrName + "'])").hide();
	}

	function showAttribute(attrName) {
		jQuery("td:has([name='" + attrName + "'])").show();
	}

	function prepopulateRowsParent() {
		SPM.executeAction("Hunt group planner (call forwarding)", 'prepopulateRows', null);
	}

	function checkForNumberForwarding() {
		var currentConfigReference = CS.UI.getCurrentInstance().getCurrentConfigReference();
		if(currentConfigReference.includes(ADDITIONAL_ADD_ONS_DEFINITION_NAME) && CS.getAttributeValue(ADDON_ABBREVIATION_ATTRIBUTE_NAME) === 'CFW') {
			if(CS.getAttributeValue('External_direct_dial_0') != null) {
				SPM.executeAction("Hunt group planner (call forwarding)", 'updateDirectDial', {directDial:CS.getAttributeValue('External_direct_dial_0')});
			}
		}
	}

	function removeTechnicalPart() {
		jQuery('#technicalConfigFrame').remove();
		var targetSrc = jQuery('.screen-footer')[0];
		targetSrc = jQuery(targetSrc).prev()[0];
		var screenContent = targetSrc;
		jQuery(screenContent).attr("data-tech", '');
	}

	function addOverlay(){jQuery("<div id='overlay' ></div>").css({
		position: "absolute",
		width: "100%",
		height: "100%",
		opacity: 0.2,
		top: 0,
		left: 0,
		background: "#cccc"
		}).appendTo(jQuery(".screen-content").css("position", "relative"));
	}

	function removeOverlay() {
		jQuery("#overlay").remove();
	}

	function performLimitedAddOnsValidation() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(DIGIPHONE_DEFINITION_NUMBER)) {
			limitedAddOnsValidation();
		}
	}

	function limitedAddOnsValidation() {
		var count = [];
		_.each(CS.Service.config, function(it) {
			if(it.attr && it.attr.Name && it.attr.Name.includes('Addon Abbreviation') 
				&& it.attr.cscfga__Value__c && it.attr.cscfga__Value__c.includes('Limited')) {
				if(count[it.attr.cscfga__Value__c] === undefined) {
					count[it.attr.cscfga__Value__c] = 0;
				}

				count[it.attr.cscfga__Value__c]++;
			}
		});

		var invalidData = '';
		_.each(Object.keys(count), function(key) {
			var keyList = key.split('-');
			var max = CS.getAttributeValue(keyList[2]);
			if(count[key] > max) {
				invalidData += 'Number of ' + keyList[3] + ' (' + count[key] + ') exceeds allowed quantity (' + max + '). ';
			}
		});

		if(invalidData !== '') {
			CS.markConfigurationInvalid(invalidData);
		}
	}

	function setTotalRecurring(suppressEvent) {
		let lineItems = _.filter(CS.Service.config, function(it) {
			return it.attr &&
			it.attr.cscfga__Is_Line_Item__c &&
			it.attr.cscfga__Recurring__c;
		});

		let lineItemSum = _.reduce(lineItems, function(sum, it) {
			var price = 0;
			if (it.attr.cscfga__Price__c) {
				price = it.attr.cscfga__Price__c;
			}
			return sum + price;
		}, 0);

		var numberOfSubs = CS.getAttributeValue(numberOfSubscriptionsAttributeName);
		if(numberOfSubs === undefined) {
			numberOfSubs = 1;
		}

		console.log('Setting Total MRC to: ' + lineItemSum * numberOfSubs);
		CS.setAttributeValue(totalRecurringChargeAttributeName, lineItemSum * numberOfSubs, suppressEvent);
	}

	function setTotalOneOff(suppressEvent) {
		let lineItems = _.filter(CS.Service.config, function(it) {
			return it.attr &&
				it.attr.cscfga__Is_Line_Item__c &&
				!it.attr.cscfga__Recurring__c;
		});

		let lineItemSum = _.reduce(lineItems, function(sum, it) {
			var price = 0;
			if (it.attr.cscfga__Price__c) {
				price = it.attr.cscfga__Price__c;
			}
			return sum + price;
		}, 0);

		var numberOfSubs = CS.getAttributeValue(numberOfSubscriptionsAttributeName);
		if(numberOfSubs === undefined) {
			numberOfSubs = 1;
		}

		console.log('Setting Total OTC to: ' + lineItemSum * numberOfSubs);
		CS.setAttributeValue(totalOneOffChargeAttributeName, lineItemSum * numberOfSubs, suppressEvent);
	}

	function hideColumnsInTheRelatedList() {
		var currentConfigReference = CS.Service.config[""].config.cscfga__Product_Family__c;
		if(currentConfigReference.includes(DIGIPHONE_DEFINITION_NUMBER)) {
			hideColumnsForRelatedProduct(NUMBER_DETAILS_ATTRIBUTE_NAME);
			hideColumnsForRelatedProduct(DEVICES_ATTRIBUTE_NAME);
			hideColumnsForRelatedProduct(ADDITIONAL_ADDONS_ATTRIBUTE_NAME);
		}
	}

	function hideColumnsForRelatedProduct(relatedProductAttrName) {
		var rows = jQuery('table[data-cs-binding="' + relatedProductAttrName + '"]').find('tr');
		var headerColumns = rows.eq(0).find('th');
		headerColumns.eq(1).hide();
		headerColumns.eq(2).hide();
		for(i = 1; i < rows.length; i++) {
			var recordColumns = rows.eq(i).find('td');
			recordColumns.eq(1).hide();
			recordColumns.eq(2).hide();
		}
	}
});