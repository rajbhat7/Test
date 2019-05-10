//Registering on event only if Number Porting non commercial schema context is selected
if (originalSchema.name 
	&& (originalSchema.name === 'Analog Number'
		|| originalSchema.name === 'Portings Block Numbers 100'
		|| originalSchema.name === 'CLIP Number')) {
	registerHandler('onLoad', validatePortingFields);
	registerHandler('onNewRow', validatePortingFields);
	registerHandler('onInputChange', validatePortingFields);
	registerHandler('onImport', validatePortingFields);
	document.getElementById('saveBtnMultiple').disabled = true;
	console.log('Registering for ' + originalSchema.name);
}


if (originalSchema.name 
	&& (originalSchema.name === 'MSN Block Numbers'
		|| originalSchema.name === 'Backup Number')) {
	registerHandler('onLoad', validateMSNFields);
	registerHandler('onNewRow', validateMSNFields);
	registerHandler('onInputChange', validateMSNFields);
	registerHandler('onImport', validateMSNFields);
	document.getElementById('saveBtnMultiple').disabled = true;
	console.log('Registering for ' + originalSchema.name);
}

function validateMSNFields() {
	var jsonAttribute = originalSchema.attributes[0];
	var items = jQuery('[data-id="' + jsonAttribute.name + '"]').length;
	var configValid = true;

	for (var i = 0; i < items; i++) {
		for(var j = 0; j < originalSchema.attributes.length; j++) {
			var attName = originalSchema.attributes[j].name;
            var att = getAttribute(attName, i);
            if (att.type.toLowerCase() === "text") {
                configValid = configValid && (checkValueLength(att, 10) || att.value === '' || att.value === undefined);
            }
		}
	}

	if(configValid) {
		document.getElementById('saveBtnMultiple').disabled = false;
	} else {
		document.getElementById('saveBtnMultiple').disabled = true;
	}
}

function getAttribute(attName, rowNumber) {
	return jQuery('[data-id="' + attName + '"]')[rowNumber];
}

function validatePortingFields() {
	var jsonAttribute = originalSchema.attributes[0];
	var configValid = true;

	var items = jQuery('[data-id="' + jsonAttribute.name + '"]').length;
	if(originalSchema.name === 'Analog Number' || originalSchema.name === 'CLIP Number') {
		expectedLength = 10;
	} else if(originalSchema.name === 'Portings Block Numbers 100') {
		expectedLength = 8;
	}

	// iterate over the rows, validating
	for (var i = 0; i < items; i++) {
		configValid = configValid && checkValueLength(jQuery('[data-id="' + jsonAttribute.name + '"]')[i], expectedLength);
	}

	if(configValid) {
		document.getElementById('saveBtnMultiple').disabled = false;
	} else {
		document.getElementById('saveBtnMultiple').disabled = true;
	}
}

function checkValueLength(element, length) {
	var value = element.value;
	if (value.length === length) {
		jQuery(element).attr("style", "border: 1px solid #d8dde6 !important");
		return true;
	} else {
		jQuery(element).attr("style", "border: 1px solid #c23934 !important");
		return false;
	}
}