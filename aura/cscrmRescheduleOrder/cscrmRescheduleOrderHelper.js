/**
   (c) 2019 CloudSense LTD
   Developed by CloudSense LTD, London (UK)

   @date 1.2019
   @author Tomislav Blazek

   @description Throws a message on UI if the Order was not applicable to be Rescheduled.

   @modifications
   22.01.2019 [TB] SFCH-1171 Date Change/Cancellation of Termination
 */
({
  createRequest: function (cmp, event, helper) {
    let request = {
      recordId: cmp.get('v.recordId')
    };
    return request;
  },
  readResponse: function (cmp, event, helper, responseJson) {
    var result = JSON.parse(responseJson);
    if (!result.orderRescheduled) {
      helper.showToast('info', 'Unavailable', 'It is only possible to reschedule the Termination order and before Termination Wish Date was reached.', 'sticky');
    } else {
      helper.showToast('success', 'Success', 'Case for rescheduling an Order has been successfully created.', 'sticky');
    }

    helper.hideElement(cmp, 'spinner');
    var dismissActionPanel = $A.get("e.force:closeQuickAction");
    dismissActionPanel.fire();
  }
})