//Registering on event only if Number Porting non commercial schema context is selected
if (originalSchema.name && (originalSchema.name === 'Porting Block Numbers 10' ||
							originalSchema.name === 'Dialling Code Mandatory')) {
	registerHandler('onLoad', validatePortingBlock10Fields);
	registerHandler('onNewRow', validatePortingBlock10Fields);
	registerHandler('onInputChange', validatePortingBlock10Fields);
	registerHandler('onImport', validatePortingBlock10Fields);
	document.getElementById('saveBtnMultiple').disabled = true;
	document.getElementById('saveBtnSingle').disabled = true;
	console.log('Registering for ' + originalSchema.name);
}

function validatePortingBlock10Fields() {
	var jsonAttribute = originalSchema.attributes[0];
	var configValid = true;

	var items = jQuery('[data-id="' + jsonAttribute.name + '"]').length;

	// iterate over the rows, validating
	for (var i = 0; i < items - 1; i++) {
		configValid = configValid && checkValue(jQuery('[data-id="' + jsonAttribute.name + '"]')[i]);
	}

	if(configValid) {
		document.getElementById('saveBtnMultiple').disabled = false;
		document.getElementById('saveBtnSingle').disabled = false;
	} else {
		document.getElementById('saveBtnMultiple').disabled = true;
		document.getElementById('saveBtnSingle').disabled = true;
	}
}

function checkValue(element) {
	var value = element.value;
	if (value.startsWith('0') && value.length === 8) {
		jQuery(element).attr("style", "border: 1px solid #d8dde6 !important");
		return 1;
	} else {
		jQuery(element).attr("style", "border: 1px solid #c23934 !important");
		return 0;
	}
}