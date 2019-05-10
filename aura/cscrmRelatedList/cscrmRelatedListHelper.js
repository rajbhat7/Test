/**
 * Created by Petar on 11/18/2018.
 */
({
    createRequest: function (cmp, event, helper) {
        let request = {
            currentRecordId: cmp.get('v.recordId'),
            currentRecordSObject: cmp.get('v.sObjectName'),
            settingsKey: cmp.get('v.settingsKey')
        };
        return request;
    },
    readResponse: function (cmp, event, helper, responseJson) {
        try {
            var result = JSON.parse(responseJson);
            if (!result.errorMessage) {
                cmp.set('v.records', result.recordData);
                cmp.set('v.fieldDefinitions', helper.populateFieldLabels(result.fieldDefinitions));
                cmp.set('v.numberOfColumns', result.fieldDefinitions.length);
                cmp.set('v.isError', false);
            }
            else {
                cmp.set('v.isError', true);
                cmp.set('v.errorMessage', result.errorMessage)
            }
        }
        catch (e) {

        }
        helper.hideElement(cmp, 'spinner');
    },
    loadRelatedData: function (cmp, event, helper) {
        helper.showElement(cmp, 'spinner');
        this.callServer(cmp,
            'c.loadDataApex',
            {requestJson: JSON.stringify(helper.createRequest(cmp, event, helper))},
            this.readResponse.bind(this, cmp, event, helper)
        );
    },
    populateFieldLabels: function (fieldDefinitions) {
        fieldDefinitions.forEach(function (definition) {
            if (definition.label.indexOf('Label.') === 0) {
                definition.label = definition.label.replace('Label.', 'Label.c.');
                let newLabel = $A.get(definition.label);
                definition.label = !!newLabel ? newLabel : 'Error getting label: ' + definition.label;
            }
        })
        return fieldDefinitions;
    }

})