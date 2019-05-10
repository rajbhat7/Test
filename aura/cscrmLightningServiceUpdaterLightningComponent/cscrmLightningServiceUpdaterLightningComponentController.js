({
    init: function (cmp, event, helper) {
        var totalWidth = screen.width;
        cmp.set('v.columns', [
            {label: 'Mobile Portfolio Tier', fieldName: 'servName', type: 'text', editable: false, initialWidth: totalWidth * 0.09},
            {label: 'AddOns', fieldName: 'addons', type: 'text', editable: false, initialWidth: totalWidth * 0.24},
            {label: 'Last Name', fieldName: 'lastName', type: 'text', editable: false, initialWidth: totalWidth * 0.075},
            {label: 'First Name', fieldName: 'firstName', type: 'text', editable: false, initialWidth: totalWidth * 0.075},
            {label: 'MRC', fieldName: 'MRC', type: 'text', editable: false, initialWidth: totalWidth * 0.05},
            {label: 'MRC Discount', fieldName: 'MRCDiscount', type: 'text', editable: false, initialWidth: totalWidth * 0.05},
            {label: 'OTC', fieldName: 'OTC', type: 'text', editable: false, initialWidth: totalWidth * 0.05},
            {label: 'OTC Discount', fieldName: 'OTCDiscount', type: 'text', editable: false, initialWidth: totalWidth * 0.05},
            {label: 'Porting', fieldName: 'porting', type: 'text', editable: false, initialWidth: totalWidth * 0.04},
            {label: 'ACC subscr. ID', fieldName: 'accId', type: 'text', editable: true, initialWidth: totalWidth * 0.09},
            {label: 'ICCID', fieldName: 'iccId', type: 'text', editable: true, initialWidth: totalWidth * 0.09}
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
        var action = cmp.get("c.updateServices");

        action.setParams({"wrapListJSON" : JSON.stringify(draftValues)});
        action.setCallback(this, function(response) {
            var state = response.getState();
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action);
        
    }
})