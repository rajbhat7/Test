/**
   (c) 2018 CloudSense LTD
   Developed by CloudSense LTD, London (UK)

   @date 12.2018
   @author Tomislav Blazek

   @description Calls the method for setting the Order status to Withdrawal (if applicable).
   Returns if order was set to Withdrawal.

   @modifications
   1.12.2018 [TB] SFCH-737 TPV Order Management Withdrawal
 */
({
  onInit: function(cmp, event, helper) {
    helper.showElement(cmp, 'spinner');
    helper.callServer(cmp,
      'c.withdrawOrder', {
        requestJson: JSON.stringify(helper.createRequest(cmp, event, helper))
      },
      helper.readResponse.bind(this, cmp, event, helper)
    );
  }

})