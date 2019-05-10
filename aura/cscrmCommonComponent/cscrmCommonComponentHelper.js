/**
 * Created by Petar on 11/18/2018.
 */
({
    CELL_COPY_CLIPBOARD_EVENT_TYPE: 'CopyClipboard',
    callServer: function (cmp, actionName, parameters, onSuccess, onError, isStorable, isAbortable, isBackground) {
        var action = cmp.get(actionName);
        if (parameters) {
            action.setParams(parameters);
        }
        if (isAbortable) {
            action.setAbortable();
        }
        if (isStorable) {
            action.setStorable();
        }
        if (isBackground) {
            action.setBackground();
        }
        action.setCallback(this, function (response) {
            if (response) {
                var state = response.getState();
                if (cmp.isValid()) {
                    if (state === "SUCCESS") {
                        var result = response.getReturnValue();

                        onSuccess(result);
                    } else if (state == "ERROR") {
                        var errors = response.getError();
                        if (!onError) {
                            this.handleError(errors);
                        } else {
                            onError(errors);
                        }
                    }
                }
            } else {
                onSuccess();
            }
        });
        $A.enqueueAction(action);
    },
    hideElement: function (cmp, elementId) {
        var elm = cmp.find(elementId);
        $A.util.addClass(elm, 'slds-hide');
    },
    showElement: function (cmp, elementId) {
        var elm = cmp.find(elementId);
        $A.util.removeClass(elm, 'slds-hide');
    },
    handleError: function (errors) {
        if (errors) {
            if (console) {
                console.log('errors', errors);
            }
            this.showToast('error', 'Error:', errors[0].message);
        }
    },
    showToast: function (type, title, message) {
        this.showToast(type, title, message, null);
    },
    showToast: function (type, title, message, mode) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type
            });
            if (!!mode) {
                toastEvent.setParams({
                    "mode": mode
                })
            }
            toastEvent.fire();
        }
    },
    getObjectProperty: function (obj, path) {
        let propArray = path.split('.');
        let returnValue = obj;
        propArray.forEach(function (item) {
            if (!!returnValue) {
                returnValue = returnValue[item];
            }
        });
        return returnValue;
    },
    copyToClipboard: function (valueToCopy) {
        let element = document.createElement('textarea');
        element.value = valueToCopy;
        document.body.appendChild(element);
        element.select();
        document.execCommand('copy');
        document.body.removeChild(element);
    },
    gotoURL: function (url) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },
    gotoObject: function (recordId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
        });
        navEvt.fire();
    }
})