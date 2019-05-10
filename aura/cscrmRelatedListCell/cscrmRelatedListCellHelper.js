/**
 * Created by Petar on 11/19/2018.
 */
({
	fireCellSelectedEvent: function(cmp, event, helper ){
		let relatedListEvent = cmp.getEvent("relatedListEvent");
		relatedListEvent.setParams({
			eventType: this.CELL_COPY_CLIPBOARD_EVENT_TYPE,
			rowIndex: cmp.get('v.rowIndex'),
			columnName: cmp.get('v.fieldDefinition').name
		});
		relatedListEvent.fire();
	}
})