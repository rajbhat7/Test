require(['cs_js/cs-full'], function (CS) {

CS.EventHandler.subscribe(
  CS.EventHandler.Event.RULES_FINISHED,
  function(payload){
   jQuery("h2:contains('The Product definition, that the Product configuration was created from, needs to be recompiled for v2.')").hide();
   jQuery("h2:contains('Product configuration has an older version of Product definition and needs to have its rules re-executed and be revalidated.')").hide();
   jQuery("h2:contains('Configuration upgrader needs to be run on the Product configuration.')").hide();
   let notifyContainer = document.getElementById("csSldsNotifyContainer");
   let notifyContainerChildren = notifyContainer.children
   var warningElement;

   for(var i = 0; i < notifyContainerChildren.length; i++){
    var notifyChild = notifyContainerChildren[i];
    if(notifyChild != undefined && notifyChild != null){
     if(notifyChild.classList.contains("cs-validation-message-box-warning")){
      warningElement = notifyChild;
     }
    }
    
   }
   if(warningElement != null) {
    let warningChildren = warningElement.children;
    var warChildElement;
    for(var i = 0; i < warningChildren.length; i++){
     var warChild = warningChildren[i];
     if(warChild != undefined && warChild != null){
      if(warChild.classList.contains("slds-notify__content") && warChild.classList.contains("cs-validation-message-box-text")){
       warChildElement = warChild;
      }
     }
    }
    if(warChildElement != null){
     let divChilds = warChildElement.children;
     var shouldHideWarning = true;
     for(var i = 0; i < divChilds.length; i++){
      var divChild = divChilds[i];
      if(divChild != undefined && divChild != null){
       if(divChild.getAttribute("style") != "display: none;"){
        shouldHideWarning = false;
       }
      } 
     }
     if(shouldHideWarning){
      warningElement.setAttribute("Style", "display:none;"); 
     } else {
      warningElement.removeAttribute("Style");
     }
      
    }
   }
   return;
  }
 );
 
});