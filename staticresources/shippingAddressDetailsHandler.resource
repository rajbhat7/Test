//Registering on event only if Shipping address non commercial schema context is selected
if (originalSchema.name && originalSchema.name === 'Shipping Address') {
    document.getElementById('saveBtnSingle').disabled = true;
    registerHandler('onInputChange', validateShippingAddressFields);
}

function validateShippingAddressFields() {
  var shippingAddressValid = true;
  for (var i = 0; i < originalSchema.attributes.length; i++){
    var jsonAttribute = originalSchema.attributes[i];
    jQuery('[data-id="' + jsonAttribute.name + '"]').css("background-color", "");
    jQuery('.validationError_' + jsonAttribute.name.replace(' ', '.') + '').remove();
    if(jsonAttribute.required == true) {
      var inputValue = jQuery('[data-id="' + jsonAttribute.name + '"]').val();
      if(jsonAttribute.regularExpression === undefined || jsonAttribute.regularExpression === null || jsonAttribute.validationErrorMessage === undefined || jsonAttribute.validationErrorMessage === null) {
          if(inputValue) {
              shippingAddressValid = shippingAddressValid && true;
          } else {
              jQuery('[data-id="' + jsonAttribute.name + '"]').css("background-color", "#ffbaba");
            jQuery('[for="element' + jsonAttribute.name + '"]').append("<span class='validationError_" + jsonAttribute.name + "' style='color: rgb(255, 0, 0); font-size: 85%;'> " + '<br/>' + 'This field is required and needs to be filled.' + "</span>");
            shippingAddressValid = shippingAddressValid && false;
          }
      } else {
        if(inputValue.match(jsonAttribute.regularExpression)) {
            shippingAddressValid = shippingAddressValid && true;
        } else {
            jQuery('[data-id="' + jsonAttribute.name + '"]').css("background-color", "#ffbaba");
            jQuery('[for="element' + jsonAttribute.name + '"]').append("<span class='validationError_" + jsonAttribute.name + "' style='color: rgb(255, 0, 0); font-size: 85%;'> " + '<br/>' +jsonAttribute.validationErrorMessage + "</span>");
            shippingAddressValid = shippingAddressValid && false;
        }
      }   
      
    }
  }

  if (shippingAddressValid){
      document.getElementById('saveBtnSingle').disabled = false;
  } else {
      document.getElementById('saveBtnSingle').disabled = true;
    }
}