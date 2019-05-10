//Registering on event only if Number Forwarding non commercial schema context is selected
if (originalSchema.name && originalSchema.name === 'Hunt group planner (call forwarding)') {
    registerHandler('executeAction', prepopulateRows);
    registerHandler('executeAction', updateDirectDial);
    registerHandler('onSave', triggerUpdateDirectDial);
}

var defaultValues = [];
defaultValues[0] = 'Step 1 (0)';
defaultValues[1] = 'Step 2 (+15)';
defaultValues[2] = 'Step 3 (+15)';
defaultValues[3] = 'Step 4 (+15)';
defaultValues[4] = 'Step 5 (+15)';

var stepFieldName = '15 sec/step';
var externalDialFieldName = 'External direct dial';

function prepopulateRows() {
    if(jQuery('[data-id="' + stepFieldName + '"]').length === 0) {
        for(var i = 0; i < 5; i++) {
            newRow();
            var attr = getAttribute(stepFieldName,i);
            attr.value = defaultValues[i];
        }
    }
}

function getAttribute(attName, rowNumber) {
    return jQuery('[data-id="' + attName + '"]')[rowNumber];
}

function triggerUpdateDirectDial() {
    SPM.executeOnParent({data:null, method:'updateDirectDialParent'});
}

function updateDirectDial(param) {
    var params = {};
    params.value = {};
    params.value.attributeName = externalDialFieldName;
    params.value.attributeValue = param.directDial;
    setAttributeValue(params);
}