/**
 * Created by Petar on 11/30/2018.
 */
({
    onInit: function (cmp, event, helper) {
        helper.showElement(cmp, 'spinner');
        helper.callServer(cmp,
            'c.checkIsAccountLocked',
            {requestJson: JSON.stringify(helper.createRequest(cmp, event, helper))},
            helper.readResponse.bind(this, cmp, event, helper)
        );
    }

})