//Registering on event only if Number Porting non commercial schema context is selected
if (originalSchema.name && originalSchema.name === 'Number Porting') {
    document.getElementById('saveBtnMultiple').disabled = true;
    registerHandler('onLoad', validatePortingFields);
    registerHandler('onLoad', checkRowTotal);
    registerHandler('onDelete', validatePortingFields);
    registerHandler('onDelete', checkRowTotal);
    registerHandler('onNewRow', validatePortingFields);
    registerHandler('onNewRow', checkRowTotal);
    registerHandler('onInputChange', validatePortingFields);
    registerHandler('onRemoveAll', validatePortingFields);
    registerHandler('onRemoveAll', checkRowTotal);
    registerHandler('onImport', validatePortingFields);
}

function checkRowTotal() {
    var jsonAttribute = originalSchema.attributes[0];
    var items = jQuery('[data-id="' + jsonAttribute.name + '"]').length;

    return items;
}

function validatePortingFields() {
    var tableIsValid = 1;

    // let's see how many rows we have
    var jsonAttribute = originalSchema.attributes[0];
    var items = jQuery('[data-id="' + jsonAttribute.name + '"]').length;    

    // iterate over the rows, validating
    for (var i = 0; i < items; i++) {
        removeAllBorders(i);
        if(isPorting(i)) {
            enablePortingFields(i);
            tableIsValid = tableIsValid & checkPrivateOwnerFullNameIsPresent(i);
            tableIsValid = tableIsValid & checkCompanyOwnerNameIsPresent(i);
            tableIsValid = tableIsValid & checkMobileNumberFormat(i);
            tableIsValid = tableIsValid & checkWishDate(i);
            checkIsPrepaid(i);
            // if we already know it's invalid, no need to check the required fields because the UI will handle their rendering
            if (tableIsValid) {
                tableIsValid = tableIsValid & checkRequiredFields(i);
            }
        } else {
            disablePortingFields(i);
        }
    }

    if (tableIsValid){
        document.getElementById('saveBtnMultiple').disabled = false;
    } else {
        document.getElementById('saveBtnMultiple').disabled = true;
    }
}

function disablePortingFields(rowNum) {
    setAttrReadOnly('Mobile number to be ported',rowNum, true);
    setAttrReadOnly('Private Customer?',rowNum, true);
    setAttrReadOnly('Company Name',rowNum, true);
    setAttrReadOnly('Street & No',rowNum, true);
    setAttrReadOnly('Zip',rowNum, true);
    setAttrReadOnly('City',rowNum, true);
    setAttrReadOnly('Donor Provider',rowNum, true);
    setAttrReadOnly('Prepaid?',rowNum, true);
    setAttrReadOnly('Porting Options',rowNum, true);
}

function enablePortingFields(rowNum) {
    setAttrReadOnly('Mobile number to be ported',rowNum, false);
    setAttrReadOnly('Private Customer?',rowNum, false);
    setAttrReadOnly('Company Name',rowNum, false);
    setAttrReadOnly('Street & No',rowNum, false);
    setAttrReadOnly('Zip',rowNum, false);
    setAttrReadOnly('City',rowNum, false);
    setAttrReadOnly('Donor Provider',rowNum, false);
    setAttrReadOnly('Prepaid?',rowNum, false);
    setAttrReadOnly('Porting Options',rowNum, false);
}

function removeAllBorders(rowNum) {
    var firstName = getAttribute('First Name', rowNum);
    var lastName = getAttribute('Last Name', rowNum);
    var companyName = getAttribute('Company Name', rowNum);
    var mobileNumber = getAttribute('Mobile number to be ported', rowNum);
    var street = getAttribute('Street & No', rowNum);
    var zip = getAttribute('Zip', rowNum);
    var city = getAttribute('City', rowNum);
    var currentProvider = getAttribute('Donor Provider', rowNum);
    var wishDate = getAttribute('Wished Date', rowNum);

    removeBorder(lastName);
    removeBorder(firstName);
    removeBorder(companyName);
    removeBorder(mobileNumber);
    removeBorder(street);
    removeBorder(zip);
    removeBorder(city);
    removeBorder(currentProvider);
    removeBorder(wishDate);
    setAttrReadOnly('Wished Date',rowNum, true);
}

function checkPrivateOwnerFullNameIsPresent(rowNum) {
    var privateOwner = getAttribute('Private Customer?', rowNum).checked;
    var result = 1;

    var firstName = getAttribute('First Name', rowNum);
    var lastName = getAttribute('Last Name', rowNum);

    if (privateOwner) {
        if (!firstName || firstName.value == '') {            
            result = 0;
            applyBorder(firstName);
        } else {
            result = result & 1;
            removeBorder(firstName);
        }
        if (!lastName || lastName.value == '') {
            result = 0;
            applyBorder(lastName);
        } else {
            result = result & 1;
            removeBorder(lastName);
        }
    } else {
        result = result & 1;
        removeBorder(firstName);
        removeBorder(lastName);
    }
    return result;
}

function checkCompanyOwnerNameIsPresent(rowNum) {
    var companyOwner = !(getAttribute('Private Customer?', rowNum).checked);
    var result = 1;

    var companyName = getAttribute('Company Name', rowNum);

    if (companyOwner) {
        if (!companyName || companyName.value == '') {
            result = 0;
            applyBorder(companyName);
        } else {
            result = 1;
            removeBorder(companyName);
        }
    } else {
        console.log('should be removing border');
        result = 1;
        removeBorder(companyName);
    }

    return result;
}

function checkIsPrepaid(rowNum) {
    var prepaid = getAttribute('Prepaid?', rowNum);
    var prepaidSelected = jQuery(prepaid).val();
    var portingOptions = getAttribute('Porting Options', rowNum);

    if (prepaidSelected == 'Yes') {
        jQuery(portingOptions.options[0]).prop('selected', true);
        jQuery(portingOptions).prop('disabled', true);
    } else {
        jQuery(portingOptions).prop('disabled', false);
    }
}

function checkRequiredFields(rowNum) {
    var mobileNumber = getAttribute('Mobile number to be ported', rowNum);
    var street = getAttribute('Street & No', rowNum);
    var zip = getAttribute('Zip', rowNum);
    var city = getAttribute('City', rowNum);
    var currentProvider = getAttribute('Donor Provider', rowNum);
    var valid = 1;

    if (!mobileNumber || mobileNumber.value == '') {
        applyBorder(mobileNumber);
        valid = 0;
    }
    if (!street || street.value == '') {
        applyBorder(street);
        valid = 0;
    }
    if (!zip || zip.value == '') {
        applyBorder(zip);
        valid = 0;
    }
    if (!city || city.value == '') {
        applyBorder(city);
        valid = 0;
    }
    if (!currentProvider || currentProvider.value == '') {
        applyBorder(currentProvider);
        valid = 0;
    }
    return valid;
}

function checkMobileNumberFormat(rowNumber) {
    var mobileNumber = getAttribute('Mobile number to be ported', rowNumber);
    var regex = createRegexForMobileNumber();
    var result = regex.exec(mobileNumber.value);
    if(result === null) { //invalid format
        applyBorder(mobileNumber);
        return 0;
    }

    removeBorder(mobileNumber);
    return 1;
}

function createRegexForMobileNumber() {
      var re1='(0)';    // Any Single Character 1
      var re2='(7)';    // Any Single Character 2
      var re3='(\\d)';  // Any Single Digit 1
      var re4='( )';    // White Space 1
      var re5='(\\d)';  // Any Single Digit 2
      var re6='(\\d)';  // Any Single Digit 3
      var re7='(\\d)';  // Any Single Digit 4
      var re8='( )';    // White Space 2
      var re9='(\\d)';  // Any Single Digit 5
      var re10='(\\d)'; // Any Single Digit 6
      var re11='( )';   // White Space 3
      var re12='(\\d)'; // Any Single Digit 7
      var re13='(\\d)'; // Any Single Digit 8

      return new RegExp(re1+re2+re3+re4+re5+re6+re7+re8+re9+re10+re11+re12+re13,["i"]);
}

function checkWishDate(rowNumber) {
    var portingOptions = getAttribute('Porting Options', rowNumber);
    var wishDate = getAttribute('Wished Date', rowNumber);
    if(portingOptions.value === 'Wish Date') {
        setAttrReadOnly('Wished Date',rowNumber, false);
        var todayPlusTen = new Date();
        todayPlusTen.setDate(todayPlusTen.getDate() + 14);
        todayPlusTen.setHours(0,0,0);
        var wishDateConverted = new Date(wishDate.value);
        if(wishDateConverted >= todayPlusTen) {
            removeBorder(wishDate);
            return 1;
        }

        applyBorder(wishDate);
        return 0;
    } else {
        setAttrReadOnly('Wished Date',rowNumber, true);
    }

    return 1;
}

function isPorting(rowNumber) {
    return getAttribute('Porting Y/N', rowNumber).checked === true;
}

function getAttribute(attName, rowNumber) {
    return jQuery('[data-id="' + attName + '"]')[rowNumber];
}

function applyBorder(element) {
    jQuery(element).attr("style", "border: 1px solid #c23934 !important");
}

function removeBorder(element) {
    jQuery(element).attr("style", "border:none");
}

function setAttrReadOnly(attName, rowNumber, flag) {
    jQuery('[data-id="' + attName + '"]').eq(rowNumber).prop('readonly', flag);
    jQuery('[data-id="' + attName + '"]').eq(rowNumber).prop('disabled', flag);
}