/**
 * Created by Petar on 11/18/2018.
 */
({
    getValue: function (cmp, event, helper) {
        let record = cmp.get('v.record');
        let fieldDefinition = cmp.get('v.fieldDefinition');
        if (!!record && !!fieldDefinition) {
            try {
                cmp.set('v.value', helper.getObjectProperty(record, fieldDefinition.name));
            } catch (e) {
                debugger;
            }
        }
    },
    copyValue: function (cmp, event, helper) {
        helper.copyToClipboard(cmp.get('v.value'));
        helper.fireCellSelectedEvent(cmp, event, helper);
    }
})