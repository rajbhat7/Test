({
	initHelper : function(component) {
		var action = component.get("c.initClass");
		console.log(action);

		action.setParams({
			"oppid": component.get("v.recordId")
		});

		action.setCallback(this, function (a) {
			var state = a.getState();
			console.log(state);
			if (state === "SUCCESS") {
				var items = [];
				items.push({
					"label": "--None--",
					"value": "",
				});
				var mylist = a.getReturnValue().ListReturnSites;
				console.log(mylist);
				for (var i = 0; i < mylist.length; i++) {
					var item = {
						"label": mylist[i].UPC_Basic_Address__c,
						"value": mylist[i].Id,
					};
					items.push(item);
				}
				console.log(items);
				component.set("v.options", items);
				component.set("v.accid", a.getReturnValue().accid)

			} else if (state === "INCOMPLETE") {

			} else if (state === "ERROR") {
				var errors = a.getError();

				console.log(errors);
			}
		});
		$A.enqueueAction(action);
	}
})