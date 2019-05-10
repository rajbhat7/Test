/**
 * Created by Petar on 11/30/2018.
 */
({
    createRequest: function (cmp, event, helper) {
        let request = {
            recordId: cmp.get('v.recordId'),
            objectType: cmp.get('v.sObjectName'),
        };
        return request;
    },
    readResponse: function (cmp, event, helper, responseJson) {
        var result = JSON.parse(responseJson);
        var subscriptionId = result.subscriptionId;
        if (result.accountManagedInSuperOffice) {
            helper.showToast('info', 'Unavailable', 'It is not possible to initiate a Change Request when the Account is managed by SuperOffice', 'sticky');
        }
        else {
            if (cmp.get('v.sObjectName') === 'csord__Subscription__c'){
                helper.gotoURL("/apex/csordtelcoa__CreateChangeOrder?id=" + cmp.get('v.recordId'));
            }else if(cmp.get('v.sObjectName') === 'csord__Service__c'){
                helper.gotoURL("/apex/csordtelcoa__CreateChangeOrder?id=" + subscriptionId);
            }else if (cmp.get('v.sObjectName') === 'Account') {
                helper.gotoURL("/apex/cscrmAccountMultipleSubscriptions?id=" + cmp.get('v.recordId'));
            }
        }

        helper.hideElement(cmp, 'spinner');
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})