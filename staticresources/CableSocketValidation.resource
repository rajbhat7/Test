//Registering on event only if Shipping address non commercial schema context is selected
if (	originalSchema.name && originalSchema.name === 'Cable Socket') {
	    registerHandler('onInputChange', validateCableSocketFields);
	    document.getElementById('saveBtnSingle').disabled = true;
}

function validateCableSocketFields() {
	var jsonAttribute = originalSchema.attributes[0];
	var configValid = true;
	if(jQuery('[data-id="' + jsonAttribute.name + '"]').val() == '-') {
		configValid = false;
	}

	if(configValid) {
    	document.getElementById('saveBtnSingle').disabled = false;
    	jQuery('[data-id="' + jsonAttribute.name + '"]').css("background-color", "");
    	jQuery('.validationError_socket').remove();
	} else {
		jQuery('[data-id="' + jsonAttribute.name + '"]').css("background-color", "#ffbaba");
        jQuery('[for="element' + jsonAttribute.name + '"]').append("<span class='validationError_socket' style='color: rgb(255, 0, 0); font-size: 85%;'> " + '<br/>' + "Please select a value!</span>");
    	document.getElementById('saveBtnSingle').disabled = true;
    }
}

String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.split(search).join(replacement);
};

/*function validateCableSocketFields() {
	console.log('Started Cable Socket validation');
	var label = 'Is a TV Socket available at the installation address?';
	var message = 'Please select the value for the missing field(s).';
	if(getAttribute(label) === '-') {
		console.log('Cable Socket is invalid ' + getAttribute(label));
		addValidationMessageToAttribute(label, message);
	} else {
		console.log('Cable Socket is valid ' + getAttribute(label));
		removeValidationMessageFromAttribute(label);
		enableSave();
	}
}

// Not for multirow!
function getAttribute(attName) {
	return jQuery('[data-id="' + attName + '"]').val();
}

function addValidationMessageToAttribute(fieldLabel, validationMessage) {
	var fieldLabelNoSpaces = fieldLabel.replace(/\s/g, "_");
	jQuery('[data-id="' + fieldLabel + '"]').css("background-color", "#ffbaba");
	jQuery('[for="element' + fieldLabel + '"]').append("<span class='appendedFor_" + fieldLabelNoSpaces + "' style='color: rgb(255, 0, 0); font-size: 85%;'> " + validationMessage + "</span>");
	document.getElementById('saveBtnSingle').disabled = true;
}

function removeValidationMessageFromAttribute(fieldLabel) {
	var fieldLabelNoSpaces = fieldLabel.replace(/\s/g, "_");
	jQuery('[data-id="' + fieldLabel + '"]').css("background-color", "");
	jQuery('.appendedFor_' + fieldLabelNoSpaces + '').remove();
}

function enableSave() {
	document.getElementById('saveBtnSingle').disabled = false;	
}

if (originalSchema.name && originalSchema.name === 'Cable Socket') {
	registerHandler('onLoad', setTimeout(validateCableSocketFields, 100));
	registerHandler('onInputChange', validateCableSocketFields);
}*/