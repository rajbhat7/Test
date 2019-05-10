({
    init: function (cmp, event, helper) {
        var totalWidth = screen.width;
        cmp.set('v.columns', [
            {label: 'Product Name', fieldName: 'productName', type: 'text', editable: false},
            {label: 'Is New Number?', fieldName: 'isNewNumber', type: 'text', editable: false},
            {label: 'Ported Number', fieldName: 'portedNumber', type: 'text', editable: false},
            {label: 'MAC Address', fieldName: 'macAddress', type: 'text', editable: true},
            {label: 'New Number', fieldName: 'newNumber', type: 'text', editable: true}
        ]);
        
        var recordId = cmp.get("v.recordId");
        var action = cmp.get("c.getRelevantServices");
        action.setParams({"caseId" : recordId});
        action.setCallback(this, function(response) {
            var servIdByRowNumberMap = [];
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                cmp.set('v.data',data);
                for(var i = 0; i < data.length; i++) {
                    servIdByRowNumberMap.push('row-' + i + ',' + data[i].servId);
                }
                cmp.set("v.servIdByRowNumberMap",servIdByRowNumberMap);
                console.log(JSON.stringify(servIdByRowNumberMap));
                console.log(cmp.get("v.servIdByRowNumberMap"));
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues'); 
        var tableData = cmp.get('v.data');
        var servIdByRowNumberMap = cmp.get("v.servIdByRowNumberMap");
        draftValues.forEach(function(x) {
            servIdByRowNumberMap.forEach(function (y){
                if(y.split(',')[0] == x['Id']) {
                    x['Id'] = y.split(',')[1];
                }
            });
        });
        var params = event.getParams();
        console.log(draftValues);
        console.log(JSON.stringify(tableData));
        var action = cmp.get("c.updateServices");

        action.setParams({"draftValuesJSON" : JSON.stringify(draftValues), "tableDataJSON" : JSON.stringify(tableData)});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnValue = response.getReturnValue();
            if(returnValue === false) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some of your data is incorrect. Please check that all your entries have MAC Address filled and either Ported Number or New Number."
                });
                toastEvent.fire();
            }
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
        
    }
})