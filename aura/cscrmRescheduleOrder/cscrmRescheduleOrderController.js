/**
   (c) 2019 CloudSense LTD
   Developed by CloudSense LTD, London (UK)

   @date 1.2019
   @author Tomislav Blazek

   @description Calls the method for setting the Reschedule Order flag to true (if applicable).

   @modifications
   22.01.2019 [TB] SFCH-1171 Date Change/Cancellation of Termination
 */
({
  onInit: function(cmp, event, helper) {
    helper.showElement(cmp, 'spinner');
    helper.callServer(cmp,
      'c.rescheduleOrder', {
        requestJson: JSON.stringify(helper.createRequest(cmp, event, helper))
      },
      helper.readResponse.bind(this, cmp, event, helper)
    );
  }

})