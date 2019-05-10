'use strict';

// ES6 Promise polyfill for IE
!function (e) { function n() { } function t(e, n) { return function () { e.apply(n, arguments) } } function o(e) { if ("object" != typeof this) throw new TypeError("Promises must be constructed via new"); if ("function" != typeof e) throw new TypeError("not a function"); this._state = 0, this._handled = !1, this._value = void 0, this._deferreds = [], s(e, this) } function i(e, n) { for (; 3 === e._state;)e = e._value; return 0 === e._state ? void e._deferreds.push(n) : (e._handled = !0, void o._immediateFn(function () { var t = 1 === e._state ? n.onFulfilled : n.onRejected; if (null === t) return void (1 === e._state ? r : u)(n.promise, e._value); var o; try { o = t(e._value) } catch (i) { return void u(n.promise, i) } r(n.promise, o) })) } function r(e, n) { try { if (n === e) throw new TypeError("A promise cannot be resolved with itself."); if (n && ("object" == typeof n || "function" == typeof n)) { var i = n.then; if (n instanceof o) return e._state = 3, e._value = n, void f(e); if ("function" == typeof i) return void s(t(i, n), e) } e._state = 1, e._value = n, f(e) } catch (r) { u(e, r) } } function u(e, n) { e._state = 2, e._value = n, f(e) } function f(e) { 2 === e._state && 0 === e._deferreds.length && o._immediateFn(function () { e._handled || o._unhandledRejectionFn(e._value) }); for (var n = 0, t = e._deferreds.length; n < t; n++)i(e, e._deferreds[n]); e._deferreds = null } function c(e, n, t) { this.onFulfilled = "function" == typeof e ? e : null, this.onRejected = "function" == typeof n ? n : null, this.promise = t } function s(e, n) { var t = !1; try { e(function (e) { t || (t = !0, r(n, e)) }, function (e) { t || (t = !0, u(n, e)) }) } catch (o) { if (t) return; t = !0, u(n, o) } } var a = setTimeout; o.prototype["catch"] = function (e) { return this.then(null, e) }, o.prototype.then = function (e, t) { var o = new this.constructor(n); return i(this, new c(e, t, o)), o }, o.all = function (e) { var n = Array.prototype.slice.call(e); return new o(function (e, t) { function o(r, u) { try { if (u && ("object" == typeof u || "function" == typeof u)) { var f = u.then; if ("function" == typeof f) return void f.call(u, function (e) { o(r, e) }, t) } n[r] = u, 0 === --i && e(n) } catch (c) { t(c) } } if (0 === n.length) return e([]); for (var i = n.length, r = 0; r < n.length; r++)o(r, n[r]) }) }, o.resolve = function (e) { return e && "object" == typeof e && e.constructor === o ? e : new o(function (n) { n(e) }) }, o.reject = function (e) { return new o(function (n, t) { t(e) }) }, o.race = function (e) { return new o(function (n, t) { for (var o = 0, i = e.length; o < i; o++)e[o].then(n, t) }) }, o._immediateFn = "function" == typeof setImmediate && function (e) { setImmediate(e) } || function (e) { a(e, 0) }, o._unhandledRejectionFn = function (e) { "undefined" != typeof console && console && console.warn("Possible Unhandled Promise Rejection:", e) }, o._setImmediateFn = function (e) { o._immediateFn = e }, o._setUnhandledRejectionFn = function (e) { o._unhandledRejectionFn = e }, "undefined" != typeof module && module.exports ? module.exports = o : e.Promise || (e.Promise = o) }(this);

// 'cs_js/cs-full' - this is needed for 1.461 config and higher
// './src/cs-full' - this is needed for 1.460 config and below
require(['cs_js/cs-full', 'cs_js/cs-event-handler'], function (CS, EventHandler) {
    var domRootElement = '.pmWidget';
    var preparingWidgetMessage = '<div>Preparing AddOn Manager...</div>';
    var isInitialOpen = true;
    var priceItemId; // holds currently selected Price Item Id value
    var emptyPromise = Promise.resolve();
    var configAttrCache = {};
    var priceItemAttrCache = {}; // holds instance of __PriceItemReference__ attribute
    var addOnsForPriceItemCache = {}; // holds all possible addons for Related Product and currently selected Price Item Id - manipulable
    var mapAssocIdAssocRecord = {};

    var groupMinMaxValidation = {}; // RELATED_PRODUCT: { GROUP: {MIN_COUNT: COUNT, MAX_COUNT: COUNT} }

    var addOnIdsToAdd = [];
    var grpIds = [];
    var onlyDefaultAddOnPriceItems = []; // holds only DEFAULT QUANTITY > 0
    var allSelectedAddOnPriceItems = []; // holds all AddOnPriceItems which should be check for persisting during Price Item change process
    var selectedAddOn;
    var firstRunFlagRef;
    var priceItemObject;
    var currentConfigRef; // holds reference of config which opened PW
    var customPluginJsonObject = {}; // this variable will be populated dynamically from the action that invokes AddOn Manager

    var allRelatedProductAttributes;
    var cachedDependencyData = undefined;

    var priceItemAttr;

    var refreshInvoked = false;
    var configuratorReady = false;
    var allDependencyRecordsCached = [];

    var aopiList = {};
    var aopiPIList = {};
    var campaignForPriceItem = [];
    var campaignAssociationPrevious = '';

    function buildCompatibilityFunctions() {

        function initializeWidget(ref, jsonObject) {
            currentConfigRef = ref;

            if (priceItemAttr === undefined)
                priceItemAttr = findPriceItemAttributeForConfigRef('');

            firstRunFlagRef = CS.Util.generateReference('First_Run', { ref: currentConfigRef });
            customPluginJsonObject = jsonObject;

            if (!configuratorReady)
                return null;

            // if price item changed
            if (priceItemId != priceItemAttr.attr.cscfga__Value__c && priceItemAttr.attr.cscfga__Value__c !== '') {
                priceItemId = priceItemAttr.attr.cscfga__Value__c;

                if (attributeIsPresent(firstRunFlagRef)) {
                    CS.setAttributeValue(firstRunFlagRef, 'false', true);
                }

                addOnsForPriceItemCache = {};
                mapAssocIdAssocRecord = {};
                selectedAddOn = '';
                onlyDefaultAddOnPriceItems = [];
                campaignForPriceItem = [];
                grpIds = [];
            } else {
                noPriceItemChange(currentConfigRef, priceItemAttr);
            }

            if (priceItemAttr.attr.cscfga__Value__c == '') {
                priceItemId = '';
            }

            if (priceItemId == '' || priceItemId == undefined) {
                console.info('No Price Item selected - Widget is not refreshed!');
                return null;
            }

            var firstRunValue = CS.getAttributeValue(firstRunFlagRef);

            if (firstRunValue === 'false') {
                priceItemChanged(currentConfigRef, false);
            }
        }

        EventHandler.subscribe(EventHandler.Event.RULES_STARTED, function (payload) {
            console.log('CONFIGURATOR UI RULES_STARTED catched!');
        });

        EventHandler.subscribe(EventHandler.Event.RULES_FINISHED, function (payload) {
            console.log('CONFIGURATOR UI RULES_FINISHED catched!');
        });

        EventHandler.subscribe(EventHandler.Event.RULES_ITERATION_START, function (payload) {
            console.log('CONFIGURATOR UI RULES_ITERATION_START catched!');
        });

        EventHandler.subscribe(EventHandler.Event.RULES_ITERATION_END, function (payload) {
            console.log('CONFIGURATOR UI RULES_ITERATION_END catched!');
        });

        CS.EventHandler.subscribe(CS.EventHandler.Event.AFTER_REMOVE_RELATED_PRODUCT_ACTION, function (payload) {
            console.log('CONFIGURATOR UI AFTER_REMOVE_RELATED_PRODUCT_ACTION catched!');
        });

        CS.EventHandler.subscribe(CS.EventHandler.Event.AFTER_CONTINUE_ACTION, function (payload) {
            console.log('CONFIGURATOR UI AFTER_CONTINUE_ACTION catched!');

            init();
        });

        CS.EventHandler.subscribe(CS.EventHandler.Event.AFTER_CANCEL_ACTION, function (payload) {
            console.log('CONFIGURATOR UI AFTER_CANCEL_ACTION catched!');

            init();
        });

        CS.EventHandler.subscribe(CS.EventHandler.Event.CONFIGURATOR_READY, function (payload) {
            console.log('CONFIGURATOR UI CONFIGURATOR_READY catched!');

            init();
        });

        function turnLoadingOverlayOn() {
            var overlayElement = document.getElementById("widgetLoadingImage");

            if (overlayElement != undefined)
                overlayElement.style.display = "block";

            CS.indicator.start();
            CS.disableLoadingOverlay();
        }

        function turnLoadingOverlayOff() {
            var overlayElement = document.getElementById("widgetLoadingImage");

            if (overlayElement != undefined)
                overlayElement.style.display = "none";

            CS.enableLoadingOverlay();
            CS.indicator.stop();
        }

        function noPriceItemChange(configRef, piAttr) {
            turnLoadingOverlayOn();
            if (piAttr === undefined || piAttr.attr.cscfga__Value__c === '') {
                console.info('No Price Item selected - Widget is not refreshed!');
                turnLoadingOverlayOff();
                return emptyPromise;
            } else if (refreshInvoked) {
                console.info('Widget refresh already invoked!');
                return emptyPromise;
            } else {
                setRefreshInvokedFlag(true);
                displayPricingWidget(domRootElement).then(function () { });
            }
        }

        function priceItemChanged(configRef, isInitialOpen) {
            turnLoadingOverlayOn();

            if (attributeIsPresent(firstRunFlagRef)) {
                CS.setAttributeValue(firstRunFlagRef, 'true', true);
            }

            setRefreshInvokedFlag(true);
            priceItemObject = getPriceItemForConfig(configRef);

            priceItemObject
                .then(function (priceItem) {
                    // here maybe delete every related product and clear widget???
                    if (!priceItem || priceItem === '') {
                        console.info('no Price Item selected');
                        turnLoadingOverlayOff();
                        return emptyPromise;
                    } else {
                        var relatedProductAttributes = [];

                        if (allRelatedProductAttributes !== undefined && allRelatedProductAttributes.length > 0) {
                            relatedProductAttributes = Promise.resolve(allRelatedProductAttributes);
                        } else {
                            relatedProductAttributes = findAddOnRelatedProductAttributes(configRef, priceItemObject);
                        }

                        return relatedProductAttributes
                            .then(function (relAttrs) {
                                allRelatedProductAttributes = relAttrs;
                                var listPromises = [];
                                _.each(relAttrs, function (it) {
                                    listPromises.push(getAddOnAssociationsListForAttrCached(it));
                                });

                                return Promise.all(listPromises);
                            })
                            .then(function (values) {
                                return prepareAndCacheDependencyData().then(function (dependencyRecords) {
                                    if (priceItemId !== CSAddOnManager.getCurrentCommercialProductId()) {
                                        var isMACD = undefined;

                                        // flattening a map and creating array out of map values
                                        var addOnAssociations = [];
                                        for (var i = 0; i < values.length; i++) {
                                            for (var j = 0; j < values[i].length; j++) {
                                                if (!addOnAssociations.includes(values[i][j])) {
                                                    addOnAssociations.push(values[i][j]);
                                                }
                                            }
                                        }

                                        CSAddOnManager.init(priceItemId, addOnAssociations, allDependencyRecordsCached, isMACD, customPluginJsonObject.useDependencyEngine);
                                    }

                                    if (isInitialOpen) {
                                        return displayPricingWidget(domRootElement).then(function () { });
                                    } else {
                                        return addDefaultAddOns(allRelatedProductAttributes)
                                            .catch(function (e) {
                                                console.error('EAPI Compatibility: error adding default Add Ons', e);
                                                turnLoadingOverlayOff();
                                            })
                                            .then(function () {
                                                CS.Rules.enableRules();
                                                console.log('Evaluate all rules from AddOn Manager invoked!');
                                                CS.Rules.evaluateAllRules()
                                                    .then(function afterRules() {
                                                        return displayPricingWidget(domRootElement).then(function () { });
                                                    });
                                            });
                                    }
                                });
                            });
                    }
                });
        }

        function widgetUIPrepare() {
            // expand canvas
            jQuery('#configurationContainer').css('max-width', 'none');
        }

        function checkAddOnDependency() {
            var promiseList = [];
            var language = UserContext.language;

            var currentlySelectedAddOnAssocIds = [];
            _.each(allRelatedProductAttributes, function (attr) {
                // every AddOn Association selected - only Ids
                currentlySelectedAddOnAssocIds.push(getSelectedAddOnAssociationIds(attr));
            });

            currentlySelectedAddOnAssocIds = _.flatten(currentlySelectedAddOnAssocIds);

            var dependentAssociationsIdToAdd = [];

            var dependentAssociationsIdToDelete = [];

            var addOnsForInclusion = {};
            var groupsToRemove = [];
            var addOnsFromGroupToInclude = {};

            var dependencyEngineResults = CSAddOnManager.runDependencyEngine(currentlySelectedAddOnAssocIds);
            //addOnsForInclusion = dependencyEngineResults.addOnsToBeIncluded;
            addOnsForInclusion = dependencyEngineResults.addOnsForInclusion;
            groupsToRemove = dependencyEngineResults.groupsToRemove;
            addOnsFromGroupToInclude = dependencyEngineResults.addOnsFromGroupToInclude;
            dependentAssociationsIdToAdd = dependencyEngineResults.dependentAssociationsIdToAdd;
            dependentAssociationsIdToDelete = dependencyEngineResults.dependentAssociationsIdToDelete;
            groupMinMaxValidation = dependencyEngineResults.groupMinMaxValidation;

            // invalidate configuration if addons from target group are missing
            _.each(addOnsFromGroupToInclude, function (targetGroup) {
                if (language == 'en_US') {
                    CS.markConfigurationInvalid('Add On from the ' + targetGroup + ' group is required to be added.');
                } else {
                    CS.markConfigurationInvalid('Add On from the ' + targetGroup + ' group is required to be added.');
                }
            });

            if (groupsToRemove.length > 0) {
                for (var i = 0; i < groupsToRemove.length; i++) {
                    if (language == 'en_US') {
                        CS.markConfigurationInvalid('Add Ons from the ' + groupsToRemove[i].targetGroup + ' group needs to be removed.');
                    } else {
                        CS.markConfigurationInvalid('Add Ons from the ' + groupsToRemove[i].targetGroup + ' group needs to be removed.');
                    }
                }
            }

            // now do the additional filtering logic because of custom requirements
            //////////
            _.each(addOnsForInclusion, function (listItem, key) {
                _.each(mapAssocIdAssocRecord, function (assocValue, assocKey) {
                    if (assocValue.cspmb__add_on_price_item__c === key) {
                        _.each(listItem, function (item) {
                            //childValue.current_count += 1;
                            if (language == 'en_US') {
                                CS.markConfigurationInvalid(item.quantity + ' ' + item.targetAddOnName + ' Add On is required to be added.');
                            } else {
                                CS.markConfigurationInvalid(item.quantity + ' ' + item.targetAddOnName + ' Add On is required to be added.');
                            }
                        });
                    }
                });
            });
            ///////////

            // do the custom filtering because of the requirements
            if (dependentAssociationsIdToAdd.length > 0) {
                var assocsToAddFinal = [];
                _.each(dependentAssociationsIdToAdd, function (assocId) {
                    var assocRecord = mapAssocIdAssocRecord[assocId];
                    if (assocRecord !== undefined) {
                        var assocGroupState = groupMinMaxValidation[assocRecord.cspmb__group__c];
                        if (assocGroupState !== undefined) {
                            var maxValue = assocGroupState.max_count;
                            var currentValue = assocGroupState.current_count;

                            if (currentValue < maxValue) {
                                assocsToAddFinal.push(assocId);
                                assocGroupState.current_count += 1;
                            }
                        }
                    }
                });
                promiseList.push(addSelectedRelatedProducts(assocsToAddFinal));
            }

            if (dependentAssociationsIdToDelete.length > 0) {
                // delete all - dependentAssociationsIdToDelete
                promiseList.push(deleteSelectedRelatedProducts(dependentAssociationsIdToDelete, getRelatedProductReferenceAndAssociationRelation()));
            }

            return Promise.all(promiseList).then(function () {  });
        }

        /*
         * addDefaultAddOns
         *
         * When a Price Item-based product is first added to the basket, assess for default
         * Add Ons and if found, add the default Add Ons automatically.
         *
         * Since there is no 'add to basket' in the regular Configurator, a newly added
         * product is identified through a 'first run' Attribute used to flag whether this
         * logic has been performed for this configuration.
         */
        function addDefaultAddOns(relAttrList) {

            function chainAddDefaultAddons(promise, attr) {
                return promise.then(function () {
                    return addDefaultAddOnsForAttribute(attr);
                });
            }

            return _.reduce(relAttrList, chainAddDefaultAddons, emptyPromise);
        }

        function displayPricingWidget(containerSelector) {
            jQuery(containerSelector).html(preparingWidgetMessage);

            if (!priceItemObject) {
                jQuery(containerSelector).html('');
                return emptyPromise;
            }

            var relatedProductAttributesFiltered = allRelatedProductAttributes;

            return buildPricingWidget(relatedProductAttributesFiltered, containerSelector)
                .then(function () {
                    return checkAddOnDependency().then(function () {
                        checkMinMaxForGroupsInConfiguration();
                        setRefreshInvokedFlag(false);
                        turnLoadingOverlayOff();
                    });
                });
        }

        function checkMinMaxForGroupsInConfiguration() {
            var language = UserContext.language;
            var invalidGroups = '';
            // each group
            _.each(groupMinMaxValidation, function (childValue, childKey) {
                var minValue = childValue.min_count;
                var maxValue = childValue.max_count;
                var currentValue = childValue.current_count;

                if (currentValue < minValue) {
                    invalidGroups += 'Minimum ' + minValue + ' mandatory from the group ' + childKey + '. ';
                }

                if (currentValue > maxValue) {
                    invalidGroups += 'Maximum (' + maxValue + ') has been exceeded for the group ' + childKey + '. Please correct before proceeding. ';
                }
            });

            if (invalidGroups !== '') {
                CS.markConfigurationInvalid(invalidGroups);
            }
        }

        function buildPricingWidget(attrs, selector) {
            var language = UserContext.language;
            var table =
                '    <style type="text/css">  ' +
                '   / Dropdown Button /  ' +
                '   .dropbtn {  ' +
                '       border: none;  ' +
                '       cursor: pointer;  ' +
                '   }  ' +
                '     ' +
                ' .header {' +
                '  color:#54698d !important; font-size: 0.75rem;font-weight: 400;padding-right: 6px; padding-top: 8px }' +
                ' .wordWrapClass {' +
                '  word-wrap:break-word; word-break:break-word; white-space:normal !important; }' +
                ' .headerTitle {' +
                '  background-color: #fafafa;color:#54698d !important;font-size: 0.75rem;font-weight: 400;padding: 6px }' +
                ' .inputNumber {' +
                '  border: 1px solid #d8dde6 }' +
                '   / Dropdown button on hover & focus /  ' +
                '     ' +
                '     ' +
                '   / Dropdown Content (Hidden by Default) /  ' +
                '   .dropdown-content {  ' +
                '       display: none;  ' +
                '       position: absolute;  ' +
                '       background-color: #f9f9f9;  ' +
                '       min-width: 500px;  ' +
                '       box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);  ' +
                '       z-index: 1;  ' +
                '   }  ' +
                '     ' +
                '     ' +
                '   / Change color of dropdown links on hover /  ' +
                '   .dropdown-content a:hover {background-color: #f1f1f1}  ' +
                '     ' +
                '   / Show the dropdown menu (use JS to add this class to the .dropdown-content container when the user clicks on the dropdown button) /  ' +
                '  .show {display:block;}  ' +
                '   </style>  ';

            /*table = table + '<select id="addOnSelect" style="float: left; margin: 0px 0px 5px 0px;">'
                + '<option ';

            if (!selectedAddOn || '' == selectedAddOn) {
                selectedAddOn = 'empty';
                table = table + 'selected ';
            }

            table = table + ' value="">Select Add On Group</option>'
                + '</select>'*/

            table = table + '<table class="list" id="addOnTable1" style="background: #fff; border-collapse: collapse; width: 100%; table-layout: fixed;" >'
                + '<tr class="headerRow" id="addOnHeader">'
                + '<th class="header wordWrapClass" style="width:15%;">'
                + (language == 'en_US' ? 'Group' : 'Group') + '</th>'
                + '<th class="header wordWrapClass" style="width:5%;">'
                + (language == 'en_US' ? 'Quantity' : 'Quantity') + '</th>'
                + '<th class="header wordWrapClass" style="width:25%;">'
                + (language == 'en_US' ? 'Add On' : 'Add On') + '</th>'
                + '<th class="header wordWrapClass" style="width:10%;">'
                + (language == 'en_US' ? 'One-Off Charge' : 'One-Off Charge') + '</th>'
                + '<th class="header wordWrapClass" style="width:10%;">'
                + (language == 'en_US' ? 'Recurring Charge' : 'Recurring Charge') + '</th>'
                + '<th class="header wordWrapClass" style="width:20%;">'
                //+ (language == 'en_US' ? 'Description' : 'Description') + '</th>'
                //+ '<th class="header wordWrapClass" style="width:15%;">'
                + (language == 'en_US' ? 'Action' : 'Action') + '</th>'
                + '</tr>'
                + '</table>';

            table = jQuery(table);

            return _.reduce(attrs, buildPricingWidgetSectionForAttr, Promise.resolve(table))
                .then(function (table) {
                    jQuery(selector).html(table);
                    /*var groupNames = _.uniq(grpIds);

                    _.each(groupNames, function (a) {
                        jQuery('#addOnSelect').append(jQuery('<option>', { value: a, text: a }));
                    });

                    jQuery('#addOnSelect').append(jQuery('<option>', { value: 'All', text: 'All' }));
                    jQuery('#addOnSelect').change(
                        function (item) {
                            selectedAddOn = item.currentTarget.value;
                            hideAddOns(selectedAddOn);
                        }
                    );

                    hideAddOns(selectedAddOn);*/
            }).catch(function (err) {
                console.error('EAPI compatibility: cannot display pricing widget.', err);
                turnLoadingOverlayOff();
                return Promise.reject(err);
            });
        }

        /*
         * finds last quantity input element. workaround
         *
         */
        function findLastInputElementValue(addOnAssocId) {
            return jQuery('#Quantity' + addOnAssocId).val();
            //return jQuery(jQuery('input[id^="' + addOnAssocId + '"]')[jQuery('input[id^="' + addOnAssocId + '"]').length - 1]).val();
        }

        /*
         * buildPricingWidgetSectionForAttr
         *
         * Used by buildPricingWidget to contruct the table section for the supplied
         * related product attribute, chained to the supplied promise.
         */
        function buildPricingWidgetSectionForAttr(promise, attr) {
            return promise.then(function (table) {
                var headerRow = jQuery('<tr><th class="headerTitle" colspan="7">Related Product: ' + (attr.attr.cscfga__Label__c || attr.attr.Name) + '</th></tr>');

                var tableElement = undefined;
                for (var i = 0; i < table.length; i++) {
                    var elm = table[i];

                    if (elm !== undefined && elm.id === 'addOnTable1') {
                        tableElement = elm;
                        break;
                    }
                }

                jQuery(tableElement).append(headerRow);

                var currentlySelectedAddOnAssocIdsAllRelatedProducts = [];
                _.each(allRelatedProductAttributes, function (attr) {
                    // every AddOn Association selected - only Ids
                    currentlySelectedAddOnAssocIdsAllRelatedProducts.push(getSelectedAddOnAssociationIds(attr));
                });

                currentlySelectedAddOnAssocIdsAllRelatedProducts = _.flatten(currentlySelectedAddOnAssocIdsAllRelatedProducts);

                return getAddOnAssociationsListForAttrCached(attr)
                    .then(function (assocs) {
                        var currentlySelectedAddOnAssociationIdsForRelatedProduct = [];
                        currentlySelectedAddOnAssociationIdsForRelatedProduct = getSelectedAddOnAssociationIds(attr);
                        _.each(currentlySelectedAddOnAssociationIdsForRelatedProduct, function (assocId) {
                            if (mapAssocIdAssocRecord[assocId] === undefined) {
                                CS.markConfigurationInvalid('Error while checking currently selected add ons. Please contact your administrator to resolve the issue.');
                                turnLoadingOverlayOff();
                            }
                        });

                        return buildAddOnListWithGroupAndCardinalityConstraints(assocs, currentlySelectedAddOnAssociationIdsForRelatedProduct, currentlySelectedAddOnAssocIdsAllRelatedProducts);
                    })
                    .then(function (addOns) {
                        var tmpCurrentlySelectedAddOnAssociationIds = [];
                        tmpCurrentlySelectedAddOnAssociationIds = getSelectedAddOnAssociationIds(attr);
                        _.each(addOns, function (it) {
                            var attrWrapper = attr;
                            var input;
                            var quantityjQuery = '';
                            var attrValue = 0;
                            var isNew = true;
                            var productReference;
                            var addOnPriceItemName = it.assoc.cspmb__add_on_price_item__r.name;
                            var addOnPriceItemId = it.assoc.cspmb__add_on_price_item__c;

                            //Sarma 7-Apr-17: Added code to check if one-off / recurring charge should be referred from the add on or add on association - START
                            var overrideAddOnCharges = it.assoc.cspmb__overrides_add_on_charges__c;
                            var recurringCharge = 0;
                            var oneOffCharge = 0;

                            if (overrideAddOnCharges) {
                                recurringCharge = it.assoc.cspmb__recurring_charge__c;
                                oneOffCharge = it.assoc.cspmb__one_off_charge__c;
                            } else {
                                recurringCharge = it.assoc.cspmb__add_on_price_item__r.cspmb__recurring_charge__c;
                                oneOffCharge = it.assoc.cspmb__add_on_price_item__r.cspmb__one_off_charge__c;
                            }
                            //Sarma 7-Apr-17: Added code to check if one-off / recurring charge should be referred from the add on or add on association - END


                            if (jQuery('div[data-cs-binding="' + attrWrapper.reference + '"] span:contains("' + it.assoc.cspmb__add_on_price_item__r.name + '")')[0] && it.assoc.add_on_type__c == 'Quantity') {
                                isNew = false;
                                productReference = jQuery(jQuery('div[data-cs-binding="' + attrWrapper.reference + '"] span:contains("' + it.assoc.cspmb__add_on_price_item__r.name + '")')).attr("data-cs-ref");
                                attrValue = CS.getAttributeValue(productReference + ':Quantity_0');
                            }

                            grpIds.push(it.assoc.cspmb__group__c);

                            
                            if (it.assoc.add_on_type__c == 'Quantity') {
                                if (it.isAvailable) {
                                    input = '<input type="number" class="attrdisable" value="' + 1 + '" min="1" id="Quantity' + it.assoc.id + '"style="width:100%;"></input>';
                                } else {
                                    input = '<input type="number" value="' + 1 + '" min="1" id="Quantity' + it.assoc.id + '" style="background-color:LightGray; width:100%;"></input>';
                                }

                                quantityjQuery = '\',CS.EAPI.findLastInputElementValue(\'' + it.assoc.id + '\')';
                                //input = '';
                            } else {
                                input = '<input type="number" value ="1" id="Checkbox' + it.assoc.id + '" style="background-color:LightGray; width:100%;" readonly></input>';
                                quantityjQuery = '\',1';
                                //input = '';
                            }


                            


                            var row = '';
                            var isAdded = false;

                          

                            row = '<tr assoc-id="' + it.assoc.id + '" data-rc-addon="' + it.assoc.cspmb__add_on_price_item__c + '">'
                                + '<td style="padding: 6px; width:15%;" class="grp wordWrapClass" id="' + it.assoc.cspmb__group__c + '">' + (it.assoc.cspmb__group__c ? it.assoc.cspmb__group__c : '') + '</td>'
                                //+ '<td style="padding: 6px; width:20%;" class="wordWrapClass">' + it.assoc.cspmb__add_on_price_item__r.name + '</td>'
                                //+ '<td style="text-align: left; padding: 6px; width:10%;" class="wordWrapClass">' + asDecimal(oneOffCharge, 2) + '</td>'
                                //+ '<td style="text-align: left; padding: 6px; width:10%;" class="wordWrapClass">' + asDecimal(recurringCharge, 2) + '</td>'
                                //+ '<td style="padding: 6px; width:20%;" class="wordWrapClass">' + (it.assoc.cspmb__add_on_price_item__r.cspmb__add_on_price_item_description__c ? it.assoc.cspmb__add_on_price_item__r.cspmb__add_on_price_item_description__c : '') + '</td>'
                                + '<td style="width:15%;" class="wordWrapClass">' + input + '</td>';

                            //commented it.max ===1 for now to support DigiPhone specific requirements
                            if (!it.isAvailable && /*it.max === 1 &&*/ tmpCurrentlySelectedAddOnAssociationIds.includes(it.assoc.id)) {
                                //row = row + '<td style="padding: 6px; width:10%;" class="wordWrapClass"><a href="#!" onclick="CS.EAPI.deleteAddOn(\'' + attrWrapper.reference + '\',\'' + addOnPriceItemId + '\')">' + 'Remove' + '</a></td>';
                                isAdded = true;
                            } else {
                                //row = row + '<td style="padding: 6px; width:10%;" class="wordWrapClass"><a href="#!" onclick="CS.EAPI.insertAddOn(\'' + attrWrapper.reference + '\',\'' + it.assoc.id + quantityjQuery + ',' + isNew + ',\'' + productReference + '\',\'' + addOnPriceItemId + '\'' + ')">' + (it.isAvailable && !it.isExcluded ? 'Add' : '') + '</a></td>';
                                isAdded = false;
                            } 


                            if(isAdded){
                                row += '<td style="padding: 6px; width:20%;" class="wordWrapClass"><b>' + it.assoc.cspmb__add_on_price_item__r.name + '</b></td>';
                            }else{
                                row += '<td style="padding: 6px; width:20%;" class="wordWrapClass">' + it.assoc.cspmb__add_on_price_item__r.name + '</td>';
                            }

                            row += '<td style="text-align: left; padding: 6px; width:10%;" class="wordWrapClass">' + asDecimal(oneOffCharge, 2) + '</td>'
                                  + '<td style="text-align: left; padding: 6px; width:10%;" class="wordWrapClass">' + asDecimal(recurringCharge, 2) + '</td>';

                            if(isAdded){
                                row = row + '<td style="padding: 6px; width:10%;" class="wordWrapClass"><a href="#!" onclick="CS.EAPI.deleteAddOn(\'' + attrWrapper.reference + '\',\'' + addOnPriceItemId + '\')">' + 'Remove' + '</a></td>';
                            }else{
                                row = row + '<td style="padding: 6px; width:10%;" class="wordWrapClass"><a href="#!" onclick="CS.EAPI.insertAddOn(\'' + attrWrapper.reference + '\',\'' + it.assoc.id + quantityjQuery + ',' + isNew + ',\'' + productReference + '\',\'' + addOnPriceItemId + '\'' + ')">' + (it.isAvailable && !it.isExcluded ? 'Add' : '') + '</a></td>';
                            }    


                            

                            row = row + '</tr>';
                        
                            jQuery(tableElement).append(row);
                            
                        });
                        return table;
                    });
            });
        }

        /*
         * hideAddOns
         *
         * Hides add ons of specific group
         */
        function hideAddOns(groupName) {
            jQuery('.grp').each(function () {
                jQuery(this).parent().show();
            });

            if (groupName !== 'All') {
                jQuery('.grp').each(function () {
                    if (jQuery(this)[0].id != groupName) {
                        jQuery(this).parent().hide();
                    }
                });
            }
        }

        /*
         * Save all function
         *
         */
        function bulkSave() {
            addOnIdsToAdd = [];

            _.each(jQuery('.addOnSelect'), function (it) {
                if (jQuery(it).is(":checked")) {
                    addOnIdsToAdd.push(jQuery(it).attr('assoc-id'));
                }
            });

            if (addOnIdsToAdd.length > 0)
                addSelectedRelatedProducts(addOnIdsToAdd);
        }

        function deleteSelectedRelatedProducts(assocsToDelete, relatedProductReferenceAddOnAssociationRelation) {
            if (assocsToDelete === undefined || assocsToDelete.length < 1) {
                return emptyPromise;
            }

            jQuery(domRootElement).html(preparingWidgetMessage);

            var listPromises = [];

            for (var i = 0; i < assocsToDelete.length; i++) {
                var assocId = assocsToDelete[i];

                if (relatedProductReferenceAddOnAssociationRelation === undefined) {
                    _.each(addOnsForPriceItemCache, function (value, key) {
                        _.each(value, function (assoc) {
                            if (assoc.id === assocId) {
                                //refreshAllSelectedAddOnPriceItemList(assoc.cspmb__add_on_price_item__c);
                                //refreshDefaultAddOnPriceItemList(assoc.cspmb__add_on_price_item__c);

                                listPromises.push(CS.Service.removeRelatedProduct(key, true));
                            }
                        });
                    });
                } else {
                    _.each(relatedProductReferenceAddOnAssociationRelation, function (valueId, key) {
                        if (valueId === assocId) {
                            //var addOnIdTmp = mapAssocIdAssocRecord[assocId].cspmb__add_on_price_item__c;
                            //refreshAllSelectedAddOnPriceItemList(addOnIdTmp);
                            //refreshDefaultAddOnPriceItemList(addOnIdTmp);

                            listPromises.push(CS.Service.removeRelatedProduct(key, true));
                        }
                    });
                }
            }

            return Promise.all(listPromises)
                .then(function (values) {
                    CS.Rules.enableRules();
                    console.log('Evaluate all rules from AddOn Manager invoked!');
                    CS.Rules.evaluateAllRules()
                        .then(function afterRules() { displayPricingWidget(domRootElement); });
                });
        }

        function addSelectedRelatedProducts(assocsToAdd) {
            if (assocsToAdd === undefined || assocsToAdd.length < 1) {
                return emptyPromise;
            }

            jQuery(domRootElement).html(preparingWidgetMessage);

            var listPromises = [];

            for (var i = 0; i < assocsToAdd.length; i++) {
                var assocId = assocsToAdd[i];
                var addOnAssocs = [];

                _.each(addOnsForPriceItemCache, function (value, key) {
                    _.each(value, function (assoc) {
                        if (assoc.id === assocId) {
                            //addToAllSelectedAddOnPriceItemList(assoc.cspmb__add_on_price_item__c);

                            addOnAssocs.push(assoc);
                            listPromises.push(createRelatedProducts({ reference: key }, addOnAssocs, 1, true));
                        }
                    });
                });
            }

            return Promise.all(listPromises)
                .then(function (values) {
                    CS.Rules.enableRules();
                    console.log('Evaluate all rules from AddOn Manager invoked!');
                    CS.Rules.evaluateAllRules().then(function afterRules() { displayPricingWidget(domRootElement); });
                });
        }

        /*
         * insertAddOn
         *
         * Inserts an instance of the Add On identified by addOnId into the
         * Related Product attribute identified by attrRef.
         */
        function insertAddOn(attrRef, addOnId, quantity, isNew, productReference, addOnPriceItemId, suppressRules) {
            jQuery(domRootElement).html(preparingWidgetMessage);
            setRefreshInvokedFlag(true);
            turnLoadingOverlayOn();

            return emptyPromise
                .then(function () {
                    //addToAllSelectedAddOnPriceItemList(addOnPriceItemId);

                    if (isNew) {
                        return createRelatedProducts({ reference: attrRef }, [{ id: addOnId, cspmb__add_on_price_item__c: addOnPriceItemId }], quantity, true)
                            .then(function () {
                                CS.Rules.enableRules();
                                console.log('Evaluate all rules from AddOn Manager invoked!');
                                CS.Rules.evaluateAllRules().then(function afterRules() { displayPricingWidget(domRootElement); });
                            });
                    } else {
                        return CS.setAttributeValue(productReference + ':Quantity_0', quantity, true)
                            .then(function () {
                                CS.Rules.enableRules();
                                console.log('Evaluate all rules from AddOn Manager invoked!');
                                CS.Rules.evaluateAllRules().then(function afterRules() { displayPricingWidget(domRootElement); });
                            });
                    }
                });
        }

        /*
         * deleteAddOn
         *
         * Deletes add on if max = 1
         * Related Product attribute identified by attrRef.
         */
        function deleteAddOn(attrRef, addOnPriceItemId) {
            jQuery(domRootElement).html(preparingWidgetMessage);
            setRefreshInvokedFlag(true);
            turnLoadingOverlayOn();

            var listPromises = [];
            listPromises.push(CS.Service.removeRelatedProduct(attrRef, true));

            return Promise.all(listPromises)
                .then(function (values) {
                    CS.Rules.enableRules();
                    console.log('Evaluate all rules from AddOn Manager invoked!');
                    CS.Rules.evaluateAllRules().then(function afterRules() { displayPricingWidget(domRootElement); });
                });
        }

        function setRefreshInvokedFlag(state) {
            refreshInvoked = state;
        }

        function removeAndCheckDefaultAddOns(attr, addOns) {
            //var indexesToRemove = [];
            var listPromises = [];
            _.each(attr.relatedProducts, function (rp) {
                var addOnId = CS.getAttributeValue(rp.reference + '\:' + customPluginJsonObject.addOnPriceItemAttributeName + '_0');
                var remove = true;

                for (var i = 0; i < addOns.length; i++) {
                    var tmpAddOn = addOns[i];
                    var index = -1;

                    if (tmpAddOn.cspmb__add_on_price_item__c === addOnId) {
                        remove = false;
                        //indexesToRemove.push(i);
                        index = i;

                        if (index > -1) {
                            listPromises.push(CS.setAttributeValue(rp.reference + '\:' + customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName + '_0', tmpAddOn.id, true));
                        }
                    }
                }

                if (remove) {
                    listPromises.push(CS.Service.removeRelatedProduct(rp.reference, true));
                }
            });

            return Promise.all(listPromises)
                .then(function (values) {
                    //_.pullAt(addOns, indexesToRemove);
                    return Promise.resolve(addOns);
                });
        }

        function addDefaultAddOnsForAttribute(attr) {
            return getAddOnAssociationsListForAttrCached(attr)
                .then(function (addOns) {
                    return removeAndCheckDefaultAddOns(attr, addOns)
                        .then(function (addOnsValues) {
                            var currentlySelectedAddOnAssociationIds = getSelectedAddOnAssociationIds(attr);
                            return _.filter(addOnsValues, function (assoc) {
                                return (assoc.cspmb__default_quantity__c > 0 && !currentlySelectedAddOnAssociationIds.includes(assoc.id));
                            });
                        });
                })
                .then(function (addOns) {
                    if (addOns != undefined && addOns.length > 0) {
                        return createRelatedProducts(attr, addOns, 1, true);
                    }
                });
        }

        function getAddOnAssociationsListForAttrCached(attrWrapper) {
            if (addOnsForPriceItemCache[attrWrapper.reference] != undefined && addOnsForPriceItemCache[attrWrapper.reference].length > 0) {
                return Promise.resolve(addOnsForPriceItemCache[attrWrapper.reference]);
            } else {
                return getAddOnAssociationsListForAttr(attrWrapper);
            }
        }

        /////////// REFACTOR THIS
        function getAddOnAssociationsListForAttr3(attWrapper) {
            if (campaignForPriceItem.length == 0) {
                campaignForPriceItem = getAddOnAssociationsListForAttr(attWrapper);
            }
            return Promise.resolve(campaignForPriceItem);
        }
        ///////////

        function getAddOnAssociationsListForAttr(attWrapper) {
            var configRef = CS.Util.getParentReference(attWrapper.reference);
            var prefix = configRef ? configRef + ':' : '';
            var regExp = new RegExp('^' + prefix + '[^:]+$');
            var index = CS.Service.getProductIndex('');
            var attrDef = index.all[attWrapper.definitionId];
            var productDefinitionId = CS.getConfigurationWrapper(configRef).config.cscfga__Product_Definition__c;
            var filterAttrNames;
            var filterAttrs = {};

            if (!attrDef) {
                console.warn('Could not find attribute definition id for attr ', attWrapper);
                return Promise.reject('Could not find attribute definition id for attr ' + attWrapper.reference);
            }
            var lc = index.all[attrDef.cscfga__Lookup_Config__c];
            if (!lc) {
                return Promise.reject('LookupConfig could not be found for attr ' + attWrapper.reference);
            }

            var lq = index.all[lc.cscfga__Filter__c];
            if (!lq) {
                return Promise.reject('LookupQuery filter could not be found for attr ' + attWrapper.reference);
            }

            if (lq.cscfga__Referenced_Attributes__c) {
                try {
                    filterAttrNames = JSON.parse(lq.cscfga__Referenced_Attributes__c);
                } catch (e) {
                    console.error('Could not parse referenced Attributes: ' + lq.Id + ' / ' + lq.cscfga__Referenced_Attributes__c);
                }
            } else {
                filterAttrNames = [];
            }

            _.each(CS.Service.config, function (node) {
                if (node.attr && regExp.exec(node.reference)) {
                    var name = node.attr.Name;
                    if (_.indexOf(filterAttrNames, name) > -1) {
                        var val = node.attr.cscfga__Value__c;
                        filterAttrs[name] = val;
                    }
                }
            });

            return doLookupQuery(lq.Name, filterAttrs, productDefinitionId)
                .then(function (fetchedRecords) {
                    /*
                     * NOTE: This part is UPC customisation to avoid issues with MIN values on MACD cases.
                     * The problem was that MIN works fine on new provides but for on MACD delivery 
                     * type orders are cleared by the O&S package. MIN still remains though and
                     * invalidates the configuration.
                     * Changes done by Marin Mamic.
                     */
                    
                    //Figure out what change type is.
                    var opportunityChangeType;
                    //TODO: It's crappy code as we're referrig to a UPC specific attribute. Better would be to referr from Opportuntiy change type 
                    // since that comes preinstalled by package but i did not know how to do that at the time.
                    if(CS.Service.config["Change_Type_0"] !== undefined) {
                        opportunityChangeType = CS.getAttributeValue("Change_Type_0");
                    }
                    
                    //Go through all records and set MIN values to 0 for those addon dependencies that are not required for this change type
                    for (var i = 0; i < fetchedRecords.length; i++) {
                        var record = fetchedRecords[i];
                        var addonNotRequiredForChangeTypes = record.not_required_for_change_types__c;
                        if (addonNotRequiredForChangeTypes !== undefined && addonNotRequiredForChangeTypes.includes(opportunityChangeType)) {
                          record.cspmb__min__c = 0;
                        }
                    }
                    
                    //Legacy code from here
                    addOnsForPriceItemCache[attWrapper.reference] = fetchedRecords;

                    mapAssocIdAssocRecord = {};
                    _.each(addOnsForPriceItemCache, function (value, key) {
                        _.each(value, function (assoc) {
                            mapAssocIdAssocRecord[assoc.id] = assoc;
                        });
                    });

                    return fetchedRecords;
                });
        }

        /**** Remote callouts ****/
        function doLookupQuery(name, dynamicFilterMap, productDefinitionId) {
            return new Promise(function (resolve, reject) {
                Visualforce.remoting.Manager.invokeAction(
                    'cscfga.UISupport.doMultiRowLookupQuery',
                    name,
                    dynamicFilterMap,
                    productDefinitionId,
                    function (result, event) {
                        if (event.status) {
                            resolve(keysToLowerCase(result));
                        } else {
                            console.error(event);
                            reject(event);
                        }
                    },
                    { escape: false }
                );
            });
        }

        /*
         * findAddOnRelatedProductAttributes
         *
         * Returns a Promise providing a list of add-on related product attributes in the specified config.
         * Add-on related product attributes have the following characteristics:
         *
         *  1. A single 'avaialble product definition'
         *  2. That product definition contains a lookup attribute with an attribute field named '__AddOnGenerator__'
         *
         */
        function findAddOnRelatedProductAttributes(configRef) {
            function addOnGeneratorLookupsFilter(index, configAttrs) {
                return function (avail) {
                    var rpAttrs = index.attributeDefsByProduct[avail.cscfga__Product_Definition__c];
                    if (!rpAttrs) {
                        console.error('Could not find attribute definitions for product definition: ', avail.cscfga__Product_Definition__c);
                    }

                    var addOnGenerators = _.filter(
                        _.filter(rpAttrs, { cscfga__Type__c: 'Lookup' }),
                        function (it) {
                            return _.filter(index.attributeFieldDefsByAttributeDef[it.Id], { Name: '__AddonGenerator__' }).length;
                        }
                    );

                    if (addOnGenerators.length) {
                        return _.filter(configAttrs, function (it) {
                            return it.definitionId === avail.cscfga__Attribute_Definition__c;
                        });
                    }
                }
            }

            function findAddOnGeneratorLookups(configRef, products, index) {
                var configAttrs = getAttributesForConfigRef(configRef);
                return _.flatten(_.filter(_.map(products, addOnGeneratorLookupsFilter(index, configAttrs)), removeUndefinedFilter));
            }

            function loadProductReducer(promise, avail) {
                var defId = avail.cscfga__Product_Definition__c;
                return (!!defId && !CS.Service.getProductIndex(defId))
                    ? promise.then(function () {
                        return loadProduct(defId);
                    })
                    : promise;
            }

            function removeUndefinedFilter(it) {
                return !!it;
            }

            function findRelatedProductAttributes() {
                var index = CS.Service.getProductIndex('');
                var currentProdDefId = CS.getConfigurationWrapper(configRef).config.cscfga__Product_Definition__c;

                var singleAvailableProducts = _.flatten(_.filter(
                    _.filter(index.availableProductsByAttributeDef, { length: 1 }),
                    attributesForProductFilter(currentProdDefId, index)
                ));

                var loadProductsPromise = emptyPromise;
                return loadProductsPromise.then(function () {
                    return findAddOnGeneratorLookups(configRef, singleAvailableProducts, index);
                });
            }

            var relatedProductAttributeNames = [];
            _.each(CS.Service.config, function (attr) {
                if (attr.displayInfo === 'Related Product') {
                    relatedProductAttributeNames.push(attr.reference);
                }
            });

            var productDefinitionIds = [];
            _.each(relatedProductAttributeNames, function (relatedProductAttributeName) {
                _.each(CS.Service.getAvailableProducts(relatedProductAttributeName, ''), function (availableProduct) {
                    productDefinitionIds.push(availableProduct['cscfga__Product_Definition__c']);
                });
            });

            var loadedProductDefinitions = CS.Service.getProductIndex('').attributeDefsByProduct;
            var promiseList = [];
            _.each(productDefinitionIds, function (productDefinitionId) {
                if (loadedProductDefinitions[productDefinitionId] === undefined) {
                    console.log('Additionally loading PD: ' + productDefinitionId);
                    promiseList.push(CS.Service.loadProduct(productDefinitionId));
                }
            });

            return Promise.all(promiseList).then(function () {
                return findRelatedProductAttributes()
            }, emptyPromise);
        }

        /*
         * findPriceItemAttributeForConfigRef
         *
         * Returns the Attribute containing the Price Item for this Config.
         * This is identified by the presence of a __PriceItemReference__ marker AttributeField
         */
        function findPriceItemAttributeForConfigRef(ref) {
            var pi = priceItemAttrCache[ref];
            if (pi) {
                return pi;
            }

            var pis = _.filter(CS.Service.config, function (wrapper, reference) {
                return (wrapper.attributeFields
                    && wrapper.attributeFields.__PriceItemReference__
                    && CS.Util.getParentReference(reference) === ref);
            });

            if (pis.length > 1) {
                console.warn('Multiple __PriceItemReference__ markers found, model is invalid: ', pis);
            }

            priceItemAttrCache[ref] = pis[0];

            return pis[0];
        }

        function getPriceItemForConfig(ref) {
            var piAttr = findPriceItemAttributeForConfigRef(ref);
            var priceItem;

            if (!piAttr) {
                console.log('EAPI compatibility: No price item attribute found in config ref \'' + ref + '\'');
                priceItem = undefined;
            } else {
                priceItem = CS.getAttributeValue(piAttr.reference);
            }

            if (!priceItem && piAttr) {
                console.log('EAPI compatibility: No price item found in attribute ref ' + piAttr.reference);
            }

            return Promise.resolve(priceItem);
        }

        function buildAddOnListWithGroupAndCardinalityConstraints(assocs, selectedAddOnAssocIdsForRelatedProduct, currentlySelectedAddOnAssocIdsAllRelatedProducts) {
            var preDrawAssociationMap = CSAddOnManager.preDrawAssociationListFiltering(assocs, selectedAddOnAssocIdsForRelatedProduct, currentlySelectedAddOnAssocIdsAllRelatedProducts);

            return preDrawAssociationMap;
        }

        /*
        * getAddOnDependencyRecords
        *
        * Fetches all the dependency records from the Salesforce 
        * and cache them in the allDependencyRecordsCached variable
        *
        * Returns all the dependency records.
        */
        function getAddOnDependencyRecords() {
            return CS.Service.invokePlugin('GetAddOnDependencyRecords', '').then(
                function onSuccess(result) {
                    allDependencyRecordsCached = result.addOnDependencyList;
                    console.log('Plugin GetAddOnDependencyRecords successfully invoked and result is returned! Records count is: ' + result.addOnDependencyList.length);
                },
                function onFailure(error) {
                    console.log('Error executing getAddOnDependencyRecords() action: ' + error);
                }
            );
        }

        /*
        * prepareAndCacheDependencyData
        *
        * Check if the dependency data has already been fetched and cached.
        * If not fetch and return them, if yes just return the cached version.
        *
        * Returns all the dependency records.
        */
        function prepareAndCacheDependencyData() {
            if (allDependencyRecordsCached.length < 1) {
                return Promise.resolve(getAddOnDependencyRecords());
            } else {
                return Promise.resolve(allDependencyRecordsCached);
            }
        }

        function filterAddOnAssociationsByDefaultQuantity(assocs) {
            return _.filter(assocs, function (assoc) {
                return assoc.cspmb__default_quantity__c > 0;
            });
        }

        /**** Utility functions ****/
        function attributesForProductFilter(productId, index) {
            return function (it) {
                var attrDef = index.all[it[0].cscfga__Attribute_Definition__c];
                return attrDef
                    && attrDef.cscfga__Product_Definition__c == productId
                    && !!it[0].cscfga__Product_Definition__c;
            };
        }

        function getAttributesForConfigRef(ref) {
            var prefix = ref ? ref + ':' : '';
            var regExp = new RegExp('^' + prefix + '[^:]+$');
            var cached = configAttrCache[ref];

            if (cached) {
                return cached;
            }

            return configAttrCache[ref] = _.filter(CS.Service.config, function (node) {
                return node.attr && regExp.exec(node.reference);
            });
        }

        function getSelectedAddOnAssociationIds(addOnAttr) {
            return _.filter(_.map(
                addOnAttr.relatedProducts,
                function (it) {
                    return CS.getAttributeValue(makeRef(it.reference, customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName + '_0'));
                }),
                function (it) {
                    return it != null;
                }
            );
        }

        function getRelatedProductReferenceAndAssociationRelation(attrWrapper) {
            var relationMap = {};

            if (attrWrapper === undefined) {
                _.each(CS.Service.config, function (attr) {
                    _.each(attr.relatedProducts, function (rp) {
                        if (attributeIsPresent(makeRef(rp.reference, customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName + '_0'))) {
                            relationMap[rp.reference] = CS.getAttributeValue(makeRef(rp.reference, customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName + '_0'));
                        }
                    });
                });
            } else {
                _.each(attrWrapper.relatedProducts, function (rp) {
                    if (attributeIsPresent(makeRef(rp.reference, customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName + '_0'))) {
                        relationMap[rp.reference] = CS.getAttributeValue(makeRef(rp.reference, customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName + '_0'));
                    }
                });
            }

            return relationMap;
        }

        function attributeIsPresent(ref) {
            return (CS.Service.config[ref] && CS.Service.config[ref].attr);
        }

        function getAttributeDefinition(node) {
            var index = CS.Service.getProductIndex();
            return index.all[node.definitionId];
        }

        function asDecimal(val, scale) {
            var f = parseFloat(val);
            if (isNaN(f)) {
                return '';
            } else {
                return f.toFixed(scale);
            }
        }

        function error(err) {
            console.error(err);
            return Promise.reject(err);
        }

        function keysToLowerCase(obj) {
            var data = _.isArray(obj) ? [] : {};
            _.each(obj, function (val, key) {
                if (key.toLowerCase) {
                    key = key.toLowerCase();
                }
                if (val && typeof val === 'object') {
                    data[key] = keysToLowerCase(val);
                } else {
                    data[key] = val;
                }
            });
            return data;
        }

        function makeRef(ref, tail) {
            return (ref ? ref + ':' : '') + tail;
        }

        function createRelatedProducts(attr, addOns, quantity, suppressRules) {
            var availableProducts = CS.Service.getAvailableProducts(attr.reference);

            if (availableProducts == undefined || availableProducts.length < 1) {
                console.error('EAPI Compatibility: no related product definitions avaialable; there should be exactly one for attribute ' + attr.reference);
                return Promise.reject('No related product available.');
            }

            var defId = availableProducts[0].cscfga__Product_Definition__c;
            var promise = _.reduce(addOns, function (promise, addOn) {
                return promise.then(function () {
                    var listPromises = [];
                    for(var i = 0; i < quantity; i++) {
                        listPromises.push(createAddOnRelatedProductInline(attr, defId, addOn, 1, suppressRules));
                    }

                    return Promise.all(listPromises);
                });
            }, emptyPromise);

            return promise;
        }

        function createAddOnRelatedProductInline(attr, defId, addOn, quantity, suppressRules) {
            var parent = CS.getConfigurationWrapper(CS.Util.getParentReference(attr.reference));
            return loadProduct(defId)
                .then(function () {
                    return CS.Service.addRelatedProduct(attr.reference, defId, suppressRules);
                })
                .then(function (config) {
                    console.info('Created Configuration: ', config);

                    var context = { ref: config.reference };

                    var quantityAttributeReference = CS.Util.generateReference('Quantity', context);
                    if (attributeIsPresent(quantityAttributeReference)) {
                        CS.setAttributeValue(quantityAttributeReference, quantity, true);
                    } else {
                        console.error('Quantity attribute is missing!');
                        return Promise.reject('Quantity attribute is missing!');
                    }

                    var csAddOnPriceItemAttributeReference = CS.Util.generateReference(customPluginJsonObject.addOnPriceItemAttributeName, context);
                    if (attributeIsPresent(csAddOnPriceItemAttributeReference)) {
                        CS.setAttributeValue(csAddOnPriceItemAttributeReference, addOn.cspmb__add_on_price_item__c, true);
                    } else {
                        console.error(customPluginJsonObject.addOnPriceItemAttributeName + ' attribute is missing!');
                        return Promise.reject(customPluginJsonObject.addOnPriceItemAttributeName + ' attribute is missing!');
                    }

                    var csAddOnAttributeReference = CS.Util.generateReference(customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName, context);
                    if (attributeIsPresent(csAddOnAttributeReference)) {
                        return CS.setAttributeValue(csAddOnAttributeReference, addOn.id, true);
                    } else {
                        console.error(customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName + ' attribute is missing!');
                        return Promise.reject(customPluginJsonObject.addOnPriceItemAssociationLookupAttributeName + ' attribute is missing!');
                    }
                });
        }

        function loadProduct(id) {
            var index = CS.Service.getProductIndex(id);
            if (!index) {
                return CS.Service.loadProduct(id, function (index) {
                    jQuery.extend(CS.screens, CS.DataBinder.prepareScreenTemplates(index));
                    return index;
                });
            } else {
                return emptyPromise;
            }
        }

        function getPricingModelLookupAttributes() {
            var lookupConfigIds = getPricingModelLookupConfigIds();
            var pricingModelLookupAttrs = _.filter(CS.Service.config, function (it) {
                var def = getAttributeDefinition(it);
                return it.attr && _.includes(lookupConfigIds, def.cscfga__Lookup_Config__c);
            });
            return pricingModelLookupAttrs;
        }

        function getPricingModelLookupConfigIds() {
            return _.map(_.filter(CS.Service.getProductIndex().all, function (it) {
                return it.attributes &&
                    it.attributes.type === 'cscfga__Lookup_Config__c'
                    && (it.cscfga__Object__c === 'cspmb__price_item__c'
                        || it.cscfga__Object__c === 'cspmb__add_on_price_item__c'
                        || it.cscfga__Object__c === 'cspmb__price_item_add_on_price_item_association__c');
            }), function (it) {
                return it.Id;
            }
            );
        }

        /*
         * Resolve an expression of the form {lookupAttribute.field} to the lookup field value
         */
        function resolveLookupValue(exp, ctx) {
            var lk = exp ? exp.match(/\{([^\.]+)\.([^\}]+)\}/) : [];
            if (lk != null && lk.length == 3) {
                var lkName = lk[1];
                var lkField = lk[2];
                var ref = attNameToRef(lkName, CS.Util.getParentReference(ctx));
                if (!ref) {
                    console.error('Pricing lookup reference ' + exp + ' could not be resolved.');
                    return;
                }
                return CS.getLookupValue(ref, lkField);
            }
        }

        /*
         * Resolve an attribute name to its reference. Scoped to the context
         * of the current product (it may be anywhere in the hierarchy, must not
         * select an Attribute with the same name under a different product position)
         */
        function attNameToRef(name, context) {
            var atts = _.filter(CS.Service.config, function (it) { return it.attr && it.attr.Name == name && CS.Util.getParentReference(it.reference) == context; });
            if (atts.length == 1) return atts[0].reference;
        }

        /**************************/

        return {
            initializeWidget: initializeWidget,
            addDefaultAddOns: addDefaultAddOns,
            insertAddOn: insertAddOn,
            deleteAddOn: deleteAddOn,
            createRelatedProducts: createRelatedProducts,
            displayPricingWidget: displayPricingWidget,
            findAddOnRelatedProductAttributes: findAddOnRelatedProductAttributes,
            findLastInputElementValue: findLastInputElementValue,
            bulkSave: bulkSave,
            init: init
        };

        function init() {
            configuratorReady = true;
            widgetUIPrepare();
            priceItemId = priceItemAttr.attr.cscfga__Value__c;
            priceItemChanged(currentConfigRef, true);
        }
    }

    CS.EAPI = CS.EAPI || {};
    _.extend(CS.EAPI, buildCompatibilityFunctions());

    var template = '<% var prefix = CS.Util.configuratorPrefix;\r\n  var max = definition[prefix + \'Max__c\'];\r\n  var disabled = ((max && relatedProducts.length >= max) ? \'disabled=\"disabled\"\' : \'\');\r\n  var prod;\r\n  var attRef;\r\n  var rowClass;\r\n  var errorClass;\r\n  var errorMessage;\r\n  var attr = anchor.attr;\r\n  var isReadOnly = Boolean(attr[prefix + \'Is_Read_Only__c\']);\r\n  var isActive = Boolean(attr[prefix + \'is_active__c\']);\r\n  var isRequired = Boolean(attr[prefix + \'Is_Required__c\']);\r\n  var isQuantityEnabled = !Boolean(definition[prefix + \'disable_quantity__c\']);\r\n  if (max && relatedProducts.length > max) {\r\n   errorClass = \'attributeError\';\r\n   errorMessage = \'<p class=\"attributeErrorMessage\">The maximum number of \' + max + \' related items has been exceeded.<\/p>\';\r\n  }\r\n %>\r\n <article class=\"slds-card\">\r\n  <div class=\"slds-card__header slds-grid\">\r\n   <header class=\"slds-media slds-media--center slds-has-flexi-truncate\">\r\n    <div class=\"slds-media__body slds-truncate\">\r\n     <h2>\r\n      <span class=\"slds-icon_container slds-icon-custom-custom57 slds-m-right--x-small icon-list\"><\/span>\r\n      <% if (isRequired) { %><span style=\"color: #c23934; font-size:0.9rem\">*<\/span><% } %>\r\n      <span class=\"definition-name\"><%= definition.Name %><\/span>\r\n      <% if (isReadOnly) { %><span class=\"slds-text-color--error\">(Read Only)<\/span><% } %>\r\n      <% if (anchor.validationError) { %><span class=\"attributeErrorMessageRelated\"><%= anchor.validationMessage %><\/span><% } %>\r\n     <\/h2>\r\n    <\/div>\r\n   <\/header>\r\n  <\/div>\r\n\r\n  <% if (relatedProducts.length > 0) { %>\r\n\r\n  <table class=\"slds-table slds-table--bordered slds-table--cell-buffer\" data-cs-binding=\"<%= anchor.reference %>\" data-cs-control=\"<%= anchor.reference %>\" data-cs-type=\"list\">\r\n   <thead>\r\n    <tr class=\"slds-text-title--caps\">\r\n     <th scope=\"col\" width=\"140px\">\r\n      <div class=\"slds-truncate\" title=\"\">Action<\/div>\r\n     <\/th>\r\n     <th scope=\"col\" width=\"300px\">\r\n      <div class=\"slds-truncate\" title=\"\">Name<\/div>\r\n     <\/th>\r\n   <% for (var i = 0; i < cols.length; i++) {\r\n     var spec = colSpecs[cols[i]]; %>\r\n     <th scope=\"col\">\r\n      <div class=\"slds-truncate\" title=\"\"><%= spec.header %><\/div>\r\n     <\/th>\r\n   <% } %>\r\n    <\/tr>\r\n   <\/thead>\r\n   <tbody>\r\n   <% for (var i = 0; i < relatedProducts.length; i++) {\r\n     prod = relatedProducts[i];\r\n   %>\r\n    <tr data-cs-ref=\"<%= prod.reference %>\">\r\n     <td data-label=\"\">\r\n     <% if (isActive && ! isReadOnly) { %>\r\n      <a href=\"javascript:void(0);\"><span data-cs-action=\"editRelatedProduct\" data-cs-ref=\"<%= prod.reference %>\">Edit<\/span><\/a> |\r\n      <a href=\"javascript:void(0);\"><span data-cs-action=\"removeRelatedProduct\" data-cs-ref=\"<%= prod.reference %>\">Del<\/span><\/a>\r\n      <% if (!max || (((prod.config[prefix + \'Quantity__c\'] ? prod.config[prefix + \'Quantity__c\'] : 1) + totalQuantity) <= max)) { %>\r\n       | <a href=\"javascript:void(0);\"><span data-cs-action=\"copyRelatedProduct\" data-cs-ref=\"<%= prod.reference %>\">Copy<\/span><\/a>\r\n      <% } %>\r\n     <% } %>\r\n     <\/td>\r\n     <td data-label=\"\">\r\n      <div class=\"slds-truncate\" data-cs-action=\"editRelatedProduct\" data-cs-ref=\"<%= prod.reference %>\" title=\"<%= prod.config.Name %>\"><%= prod.config.Name %><\/div>\r\n     <\/td>\r\n   <%  for (var j = 0; j < cols.length; j++) {\r\n      if (colSpecs[cols[j]].ref != undefined) {\r\n       attRef = prod.reference + \':\' + colSpecs[cols[j]].ref;\r\n      }\r\n   %>\r\n     <td data-label=\"\">\r\n   <%   if (attRef != undefined) { %>\r\n      <div class=\"slds-truncate\" title=\"\"><%= CS.getAttributeDisplayValue(attRef) %><\/div>\r\n   <%   } %>\r\n     <\/td>\r\n   <%  } %>\r\n    <\/tr>\r\n   <% } %>\r\n   <\/tbody>\r\n  <\/table>\r\n\r\n  <% } else { %>\r\n\r\n  <table class=\"slds-table slds-table--bordered slds-table--cell-buffer\">\r\n   <tbody>\r\n    <tr class=\"cs-no-items-to-display\">\r\n     <td scope=\"row\">\r\n      <div class=\"slds-text-align--center\">No items to display<\/div>\r\n     <\/td>\r\n    <\/tr>\r\n   <\/tbody>\r\n  <\/table>\r\n\r\n  <% } %>\r\n <\/article>\r\n';
    var el = jQuery('#CS\\.MultipleRelatedProductLE__tpl')[0];

    if(el !== undefined) {
        el.text = template;
        CS.App.Components.Repository.addComponent('configurator', 'MultipleRelatedProduct', jQuery('#CS\\.MultipleRelatedProductLE__tpl')[0]);
    }
});
