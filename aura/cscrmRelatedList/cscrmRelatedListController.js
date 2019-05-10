/**
 * Created by Petar on 11/18/2018.
 */
({
    onInit: function (cmp, event, helper) {
        helper.loadRelatedData(cmp, event, helper);
    },
    handleRelatedListEvent: function (cmp, event, helper) {
        let eventType = event.getParam('eventType');
        if (eventType == helper.CELL_COPY_CLIPBOARD_EVENT_TYPE) {
            let rowIndex = event.getParam('rowIndex');
            let columnName = event.getParam('columnName');
            cmp.set('v.selectedRow', rowIndex);
            cmp.set('v.selectedColumn', columnName);
        }
    }
})