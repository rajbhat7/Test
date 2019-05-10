// Adam Mehtic, Marijan Barisin 09/07/2018
// However, the previous behaviour where rules were executed after the screen change might be needed with the product models that use custom “Execute Javascript” rule actions to modify the UI - for instance, to show or hide a particular part of the UI. To re-enable the behaviour, one should register the CS.Rules.evaluateAllRules() call with the events that are of interest.
require(['cs_js/cs-full'], function(CS) {
	CS.EventHandler.subscribe(
		CS.EventHandler.Event.CONFIGURATOR_READY,
		function(payload){
			return CS.Rules.evaluateAllRules('after show screen action');
		}
	);
	
	CS.EventHandler.subscribe(
        CS.EventHandler.Event.RULES_FINISHED, 
		function (payload) {
			var numberOfPortings = CS.getAttributeValue('Number_Of_Portings_0');
			if(numberOfPortings > 0) {
				SPM.setQuantity('Number Porting', numberOfPortings, numberOfPortings);
			}				
		}
	);
});