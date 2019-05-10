var alreadyValidated = false;
function inputFunc(data) {
    /**
     *Show/Hide dinamicaly the fields on OE by picklist values selected
     **/
    var configurationGuids = Object.keys(configurationMap);
    var fieldMAster = 'Is the OTO Box available?'; //Label owner of the picklist 
    var fieldsToHideOTO = new Array(
        "Where should the oto-socket be installed?",
        "Floor",
        "Office side",
        "Office designation",
        "Salutation",
        "Company Name",
        "First Name",
        "Last Name",
        "Phone Number",
        "Email"
    );
    var fieldsToHideNoOTO = new Array(
        "Is the OTO plug currently in use?",
        "Enter OTO Number",
        "On which port?",
        "Which provider?"
    );

    var chosenPicklistValue = jQuery('[data-id="' + fieldMAster + '"]').val();
    for (var i = 0; i < configurationGuids.length; i++) {
        if (chosenPicklistValue === "Yes") {
            for (var i = 0; i < fieldsToHideOTO.length; i++) {
                //Check if it is a Picklist field, to add another parent layer
                if (jQuery('[data-id="' + fieldsToHideOTO[i] + '"]').children('option').length < 1) { //NO
                    jQuery('[data-id="' + fieldsToHideOTO[i] + '"]').parent().parent().hide();
                } else { //Yes
                    jQuery('[data-id="' + fieldsToHideOTO[i] + '"]').parent().parent().parent().parent().hide();
                }
                // make sure the field exists before trying to set the value
                if (jQuery('[data-id="' + fieldsToHideOTO[i] + '"]').length > 0) {
                    jQuery('[data-id="' + fieldsToHideOTO[i] + '"]')[0].value = '';
                }
            }
            for (var i = 0; i < fieldsToHideNoOTO.length; i++) {
                if (jQuery('[data-id="' + fieldsToHideNoOTO[i] + '"]').children('option').length < 1) {
                    jQuery('[data-id="' + fieldsToHideNoOTO[i] + '"]').parent().parent().show();
                } else { //Yes
                    jQuery('[data-id="' + fieldsToHideNoOTO[i] + '"]').parent().parent().parent().parent().show();
                }
            }
        } else if (chosenPicklistValue === "No") {
            for (var i = 0; i < fieldsToHideOTO.length; i++) {
                //Check if it is a Picklist field, to add another parent layer
                if (jQuery('[data-id="' + fieldsToHideOTO[i] + '"]').children('option').length < 1) { //NO
                    jQuery('[data-id="' + fieldsToHideOTO[i] + '"]').parent().parent().show();
                } else { //Yes
                    jQuery('[data-id="' + fieldsToHideOTO[i] + '"]').parent().parent().parent().parent().show();
                }
            }
            for (var i = 0; i < fieldsToHideNoOTO.length; i++) {
                if (jQuery('[data-id="' + fieldsToHideNoOTO[i] + '"]').children('option').length < 1) {
                    jQuery('[data-id="' + fieldsToHideNoOTO[i] + '"]').parent().parent().hide();
                } else { //Yes
                    jQuery('[data-id="' + fieldsToHideNoOTO[i] + '"]').parent().parent().parent().parent().hide();
                }
                jQuery('[data-id="' + fieldsToHideNoOTO[i] + '"]')[0].value = '';
            }
        }
    }

    /**
     *Fields validations error throwers and Save disablers
     **/

    //Phone
    var phoneFieldLabel = "Phone Number";
    var phoneFieldLabelNoSpaces = phoneFieldLabel.replace(/\s/g, "_");
    var phoneValidationError = "<br>Please insert a 9 digit valid number, it can start with + or 0 and must contain only numbers and single spaces.";
    var phoneNumber = jQuery('[data-id="' + phoneFieldLabel + '"]').val();
    var isValidPhone = formatValidation(phoneNumber);
    var isValidSwissPhone;

    if (!isValidPhone && phoneNumber != "" && jQuery('.appendedFor_' + phoneFieldLabelNoSpaces + '').text() == "") {
        jQuery('[data-id="' + phoneFieldLabel + '"]').css("background-color", "#ffbaba");
        jQuery('[for="element' + phoneFieldLabel + '"]').append("<span class='appendedFor_" + phoneFieldLabelNoSpaces + "' style='color: rgb(255, 0, 0); font-size: 85%;'> " + phoneValidationError + "</span>");
    } else if (isValidPhone || phoneNumber == "") {
        jQuery('[data-id="' + phoneFieldLabel + '"]').css("background-color", "");
        jQuery('.appendedFor_' + phoneFieldLabelNoSpaces + '').remove();
    }

    if (isValidPhone) {
        var isValidSwissPhone = lengthValidation(phoneFieldLabel, phoneNumber);
        if (isValidSwissPhone && phoneNumber != "" && jQuery('.appendedFor_' + phoneFieldLabelNoSpaces + '').text() == "") {
            jQuery('[data-id="' + phoneFieldLabel + '"]').css("background-color", "#ffbaba");
            jQuery('[for="element' + phoneFieldLabel + '"]').append("<span class='appendedFor_" + phoneFieldLabelNoSpaces + "' style='color: rgb(255, 0, 0); font-size: 85%;'> " + isValidSwissPhone + "</span>");
        } else if (!isValidSwissPhone || phoneNumber == "") {
            jQuery('[data-id="' + phoneFieldLabel + '"]').css("background-color", "");
            jQuery('.appendedFor_' + phoneFieldLabelNoSpaces + '').remove();
        }
    }

    //Email
    var emailFieldLabel = "Email";
    var emailValidationError = "<br>Please provide a valid email, e.g. example@example.com";
    var email = jQuery('[data-id="' + emailFieldLabel + '"]').val();
    var checkEmail = new RegExp('^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\.([a-zA-Z]{2,5})$');
    var isValidEmail = checkEmail.test(email);

    if (!isValidEmail && email != "" && jQuery('.appendedFor_' + emailFieldLabel + '').text() == "") {
        jQuery('[data-id="' + emailFieldLabel + '"]').css("background-color", "#ffbaba");
        jQuery('[for="element' + emailFieldLabel + '"]').append("<span class='appendedFor_" + emailFieldLabel + "' style='color: rgb(255, 0, 0); font-size: 85%;'> " + emailValidationError + "</span>");
    } else if (isValidEmail || email == "") {
        jQuery('[data-id="' + emailFieldLabel + '"]').css("background-color", "");
        jQuery('.appendedFor_' + emailFieldLabel + '').remove();
    }

    var disable = false;
    if (chosenPicklistValue === "Yes") {
        var otoNumberLabel = 'Enter OTO Number';
        var otoNumberLabel_noSpaces = 'EnterOTONumber';
        var otoNum = jQuery('[data-id="' + otoNumberLabel + '"]').val();
        if(otoNum === undefined || otoNum === '') {
            jQuery('[data-id="' + otoNumberLabel + '"]').attr("style", "border: 1px solid #c23934 !important");
            if(!alreadyValidated) {
                jQuery('[for="element' + otoNumberLabel + '"]').append("<span class='appendedFor_" + otoNumberLabel_noSpaces + "' style='color: rgb(255, 0, 0); font-size: 85%;'> " + "Please enter the value!" + "</span>");
            }
            disable = true;
            alreadyValidated = true;
        } else {
            jQuery('[data-id="' + otoNumberLabel + '"]').attr("style", "border: 1px solid #d8dde6 !important");
            jQuery('.appendedFor_' + otoNumberLabel_noSpaces + '').remove();
            disable = false;
            alreadyValidated = false;
        }
    }

    for (var i = 0; i < originalSchema.attributes.length; i++){
        var jsonAttribute = originalSchema.attributes[i];
        var inputValue = jQuery('[data-id="' + jsonAttribute.name + '"]').val();
        var noSpecialCharAttrName = jsonAttribute.name.replace(/\s+/g, '_').slice(0,-1);

        if(jsonAttribute.regularExpression !== undefined && jsonAttribute.regularExpression !== null && jsonAttribute.validationErrorMessage !== undefined && jsonAttribute.validationErrorMessage !== null) {
            jQuery('[data-id="' + jsonAttribute.name + '"]').css("background-color", "");
            jQuery('.validationError_' + noSpecialCharAttrName + '').remove();
            if(inputValue === undefined || inputValue === '' || !inputValue.match(jsonAttribute.regularExpression)) {
                disable = disable || false;
            } else {
                jQuery('[data-id="' + jsonAttribute.name + '"]').css("background-color", "#ffbaba");
                jQuery('[for="element' + jsonAttribute.name + '"]').append("<span class='validationError_" + noSpecialCharAttrName + "' style='color: rgb(255, 0, 0); font-size: 85%;'> " + '<br/>' +jsonAttribute.validationErrorMessage + "</span>");
                disable = disable || true;
            }
        }
    }

    //Enable/Disable Buttons
    if (jQuery('.appendedFor_' + emailFieldLabel + '').text() == "" && jQuery('.appendedFor_' + phoneFieldLabelNoSpaces + '').text() == "" && !disable) {
        document.getElementById('saveBtnSingle').disabled = false;
    } else {
        document.getElementById('saveBtnSingle').disabled = true;
    }
}

//Validation for phone numbers format
function formatValidation(phoneNumber) {
    var isValidPhone;
    var checkValidCharsInPhone = new RegExp('[<|>]?[0-9,+, ]+$');
    var isValidFormatPhone = checkValidCharsInPhone.test(phoneNumber);

    if (phoneNumber != '' && (phoneNumber.startsWith('+') || phoneNumber.startsWith('0')) && isValidFormatPhone) {
        isValidPhone = true;
    } else {
        isValidPhone = false;
    }
    return isValidPhone;
}

//Validation for Swiss phone numbers
function lengthValidation(phoneFieldLabel, rawPhoneNumber) {
    var phoneNumber;
    var valError = '<br>Invalid length or wrong number type.<br>Normal phone number length is 9 digits with area code but without the leading 0.<br>Exceptions are: 01 (3 to 6 digit), 0860 (12 digit), 0869 (6 to 13 digits).<br>Mobile numbers are not allowed in phone field.'

    //phoneNumber normalization: used to normalize the introduced phone number removing the indicative and add a 0
    if (rawPhoneNumber.startsWith('+41')) {
        phoneNumber = '0' + rawPhoneNumber.replace(/ /g, '').substr(3);
    } else {
        phoneNumber = rawPhoneNumber;
    }

    if ((phoneNumber.startsWith('0') && !phoneNumber.startsWith('00') && !phoneNumber.startsWith('07')) || (phoneNumber.startsWith('071'))) { //07* except 071 are indicatives reserved for mobile numbers
        if (phoneNumber.startsWith('01') && (3 < phoneNumber.length && phoneNumber.length < 8)) {
            var trimedPhoneNumber = phoneNumber.substr(2);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 1 ' + trimedPhoneNumber);
        } else if (phoneNumber.startsWith('0860') && (phoneNumber.length == 13)) {
            var trimedPhoneNumber = phoneNumber.substr(4);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 860 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 9));
        } else if (phoneNumber.startsWith('0869') && (6 < phoneNumber.length && phoneNumber.length < 15)) {
            var trimedPhoneNumber = phoneNumber.substr(4);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 869 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 10));
        } else if (phoneNumber.startsWith('098') && (3 < phoneNumber.length)) {
            var trimedPhoneNumber = phoneNumber.substr(3);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 98 ' + trimedPhoneNumber);
        } else if (phoneNumber.startsWith('099') && (3 < phoneNumber.length)) {
            var trimedPhoneNumber = phoneNumber.substr(3);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 99 ' + trimedPhoneNumber);
        } else if (phoneNumber.startsWith('02') && (phoneNumber.length == 10)) {
            var trimedPhoneNumber = phoneNumber.substr(1);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 9));
        } else if (phoneNumber.startsWith('03') && (phoneNumber.length == 10)) {
            var trimedPhoneNumber = phoneNumber.substr(1);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 9));
        } else if (phoneNumber.startsWith('04') && (phoneNumber.length == 10)) {
            var trimedPhoneNumber = phoneNumber.substr(1);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 9));
        } else if (phoneNumber.startsWith('05') && (phoneNumber.length == 10)) {
            var trimedPhoneNumber = phoneNumber.substr(1);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 9));
        } else if (phoneNumber.startsWith('06') && (phoneNumber.length == 10)) {
            var trimedPhoneNumber = phoneNumber.substr(1);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 9));
        } else if (phoneNumber.startsWith('07') && (phoneNumber.length == 10)) {
            var trimedPhoneNumber = phoneNumber.substr(1);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 9));
        } else if ((phoneNumber.startsWith('08') && !phoneNumber.startsWith('0860') && !phoneNumber.startsWith('0869')) && (phoneNumber.length == 10)) {
            var trimedPhoneNumber = phoneNumber.substr(1);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 ' + trimedPhoneNumber.slice(0, 3) + ' ' + trimedPhoneNumber.slice(3, 6) + ' ' + trimedPhoneNumber.slice(6, 9));
        } else if ((phoneNumber.startsWith('09') && !phoneNumber.startsWith('098') && !phoneNumber.startsWith('099')) && (phoneNumber.length == 10)) {
            var trimedPhoneNumber = phoneNumber.substr(1);
            jQuery('[data-id="' + phoneFieldLabel + '"]').val('+41 ' + trimedPhoneNumber.slice(0, 2) + ' ' + trimedPhoneNumber.slice(2, 5) + ' ' + trimedPhoneNumber.slice(5, 7) + ' ' + trimedPhoneNumber.slice(7, 9));
        } else {
            return valError;
        }
    }
}
if (originalSchema.name && originalSchema.name === 'OTO Box') {
    registerHandler('onLoad', setTimeout(inputFunc, 100));
    registerHandler('onInputChange', inputFunc);
}