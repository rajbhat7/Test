/**
   (c) 2018 CloudSense LTD
   Developed by CloudSense LTD, London (UK)

   @date 12.2018
   @author Tomislav Blazek

   @description Throws a message on UI if the Order was not applicable to be Withdrawn.

   @modifications
   1.12.2018 [TB] SFCH-737 TPV Order Management Withdrawal
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
    if (!result.orderWithdrawn) {
      helper.showToast('info', 'Unavailable', 'It is not possible to withdraw an Order. Order is not a TPV one, or the Termination Order Wish Date has been reached.', 'sticky');
    } else {
      helper.showToast('success', 'Success', 'Order has been successfully withdrawn.', 'sticky');
    }

    helper.hideElement(cmp, 'spinner');
    var dismissActionPanel = $A.get("e.force:closeQuickAction");
    dismissActionPanel.fire();
  }
})