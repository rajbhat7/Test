function buildAddOnManagerFunctions() {
	var groupMinMaxValidation = {};
	var allDependencyRecordsCached = [];
	var commercialProductAddOnAssociationListCached = [];
	var mapAssocIdAssocRecord = {};
	var currentCommercialProductId = '';
	var cachedDependencyData = {};
	var useDependencyEngine = false;

	/*
	* init
	*
	* Initializes the following data used by the Add On Manager:
	* current commercial product id, commercial product add on associations list and map and 
	* add on dependency records.
	*
	* Input parameters are: commercial product id, commercial product add on associations and 
	* add on dependency records.
	*/
	function init(commercialProductId, associationRecords, allDependencyRecords, isMACD, useDependencyEngineFlag) {
		useDependencyEngine = useDependencyEngineFlag;
		currentCommercialProductId = commercialProductId;
		mapAssocIdAssocRecord = {};
		commercialProductAddOnAssociationListCached = [];
		_.each(associationRecords, function (assoc) {
			assoc = Object.keys(assoc).reduce((c, k) => (c[k.toLowerCase()] = assoc[k], c), {});
			commercialProductAddOnAssociationListCached.push(assoc);
			mapAssocIdAssocRecord[assoc.id] = assoc;
			//console.log('mapAssocIdAssocRecord[assoc.id] ' + mapAssocIdAssocRecord[assoc.id]);
		});
		allDependencyRecordsCached = allDependencyRecords;

		if (isMACD !== undefined && useDependencyEngine) {
			allDependencyRecordsCached = _.filter(allDependencyRecordsCached, function (dependencyItem) {
				if ((isMACD && dependencyItem.Order_Type__c === 'MACD') || (!isMACD && dependencyItem.Order_Type__c === 'New Order') || (dependencyItem.Order_Type__c === '' || dependencyItem.Order_Type__c === undefined)) {
					return true;
				}

				return false;
			});
		}
	}

	/*
	* getCurrentCommercialProductId
	*
	* Returns the id of the commercial product currently set in the Add On Manager.
	*/
	function getCurrentCommercialProductId() {
		return currentCommercialProductId;
	}

	/*
	* prepareDependencyMapsForCommercialProduct
	*
	* Dependency records from table AddOn_Dependency__c are being processed and
	* maps which will be used in AddOn Dependency engine are being populated and prepared
	*
	* Input parameters are:
	* currentlySelectedAddOnAssocIds // List of all currently selected Association AddOn Ids - { 'id1', 'id2' .. }
	*
	* Return parameters are:
	* resultMap = { allOptionalAddOnDependencies: {}, mapAssocIdRelatedDependencies: {}, allSatisfiedMandatoryAddOnDependencies: {}, allExcludedAddOnDependencies: {} };
	*/
	function prepareDependencyMapsForCommercialProduct(currentlySelectedAddOnAssocIds) {
		var resultMap = { allMandatoryRules: {}, allOptionalAddOnDependencies: {}, mapAssocIdRelatedDependencies: {}, allSatisfiedMandatoryAddOnDependencies: {}, allExcludedAddOnDependencies: {}, allInclusionAddOnDependencies: {}, satisfiedInclusionAddOnDependencies: {} };
		var allSatisfiedMandatoryAddOnDependencies = {};
		var mapAssocIdRelatedDependencies = {};
		var allOptionalAddOnDependencies = {};
		var allExcludedAddOnDependencies = {};
		var allInclusionAddOnDependencies = {};
		var satisfiedInclusionAddOnDependencies = [];
		var allMandatoryRules = {};

		groupMinMaxValidation = buildAssociationGroups(commercialProductAddOnAssociationListCached);

		var groupCounts = getAssociationGroupCounts(commercialProductAddOnAssociationListCached, currentlySelectedAddOnAssocIds);

		_.each(commercialProductAddOnAssociationListCached, function (assoc) {
			var count = groupCounts[assoc.cspmb__group__c];
			groupMinMaxValidation[assoc.cspmb__group__c].current_count = isNaN(Number(count)) ? 0 : Number(count);
		});

		if (useDependencyEngine) {
			// Preparing all inclusion records.
			allInclusionAddOnDependencies = _.filter(allDependencyRecordsCached, function (dependencyItem) {
				if (dependencyItem.Type__c === 'Inclusion' &&
					((dependencyItem.Price_Item__c !== undefined && dependencyItem.Price_Item__c === getCurrentCommercialProductId()) ||
					dependencyItem.Price_Item__c === undefined)) {
					return true;
				}

				return false;
			});

			allMandatoryRules = _.filter(allDependencyRecordsCached, function (dependencyItem) {
				if (dependencyItem.Type__c === 'Mandatory' &&
					((dependencyItem.Add_On_Source__c != undefined && dependencyItem.Add_On_Source__c !== '') ||
					(dependencyItem.Group_Source__c != undefined && dependencyItem.Group_Source__c !== '')) &&
					((dependencyItem.Price_Item__c !== undefined && dependencyItem.Price_Item__c === getCurrentCommercialProductId()) ||
					dependencyItem.Price_Item__c === undefined)) {
					return true;
				}

				return false;
			});

			if(currentlySelectedAddOnAssocIds.length > 0) {
				_.each(currentlySelectedAddOnAssocIds, function (assocId) {
					var assocRecord = mapAssocIdAssocRecord[assocId];

					if (assocRecord !== undefined) {
						_.each(allDependencyRecordsCached, function (dependencyItem) {
							if ((dependencyItem.Price_Item__c !== undefined && dependencyItem.Price_Item__c === assocRecord.cspmb__price_item__c) ||
								dependencyItem.Price_Item__c === undefined) {
								// optional group dependencies does not need to be processed within regular dependency check
								if (dependencyItem.Type__c === 'Optional' &&
									((dependencyItem.Group_Source__c != undefined && dependencyItem.Group_Source__c !== '') ||
										(dependencyItem.Add_On_Source__c !== '' && dependencyItem.Add_On_Source__c !== undefined)) &&
									((dependencyItem.Group_Target__c != undefined && dependencyItem.Group_Target__c !== '') ||
										(dependencyItem.Add_On_Target__c !== '' && dependencyItem.Add_On_Target__c !== undefined))) {
									if (allOptionalAddOnDependencies[assocRecord.id] === undefined) {
										allOptionalAddOnDependencies[assocRecord.id] = [];
									}
									allOptionalAddOnDependencies[assocRecord.id].push(dependencyItem);

									// check with Marijan why this OPTIONALS are being added
									if (dependencyItem.Add_On_Target__c !== undefined) {
										if (allOptionalAddOnDependencies[dependencyItem.Add_On_Target__c] === undefined) {
											allOptionalAddOnDependencies[dependencyItem.Add_On_Target__c] = [];
										}
										allOptionalAddOnDependencies[dependencyItem.Add_On_Target__c].push(dependencyItem);
									}
								} else {
									if (dependencyItem.Group_Source__c !== '' && dependencyItem.Group_Source__c !== undefined) {
										if (assocRecord.cspmb__group__c === dependencyItem.Group_Source__c) {
											if (mapAssocIdRelatedDependencies[assocRecord.id] === undefined) {
												mapAssocIdRelatedDependencies[assocRecord.id] = [];
											}

											mapAssocIdRelatedDependencies[assocRecord.id].push(dependencyItem);
										}
									} else if (dependencyItem.Add_On_Source__c !== '' && dependencyItem.Add_On_Source__c !== undefined) {
										if (assocRecord.cspmb__add_on_price_item__c === dependencyItem.Add_On_Source__c) {
											if (mapAssocIdRelatedDependencies[assocRecord.id] === undefined) {
												mapAssocIdRelatedDependencies[assocRecord.id] = [];
											}

											mapAssocIdRelatedDependencies[assocRecord.id].push(dependencyItem);
										}
									} else if (dependencyItem.Price_Item__c !== '' && dependencyItem.Price_Item__c !== undefined) {
										if (mapAssocIdRelatedDependencies[assocRecord.id] === undefined) {
											mapAssocIdRelatedDependencies[assocRecord.id] = [];
										}

										mapAssocIdRelatedDependencies[assocRecord.id].push(dependencyItem);
									} else if ((dependencyItem.Add_On_Source__c === undefined || dependencyItem.Add_On_Source__c === '') &&
										(dependencyItem.Group_Source__c === undefined || dependencyItem.Group_Source__c === '')) {
										if (mapAssocIdRelatedDependencies[assocRecord.id] === undefined) {
											mapAssocIdRelatedDependencies[assocRecord.id] = [];
										}

										mapAssocIdRelatedDependencies[assocRecord.id].push(dependencyItem);
									}

									// mandatory addon dependencies
									if (dependencyItem.Type__c === 'Mandatory' && dependencyItem.Add_On_Source__c != undefined && dependencyItem.Add_On_Source__c !== '' &&
										dependencyItem.Add_On_Target__c != undefined && dependencyItem.Add_On_Target__c !== '' &&
										(dependencyItem.Add_On_Target__c === assocRecord.cspmb__add_on_price_item__c || dependencyItem.Add_On_Source__c === assocRecord.cspmb__add_on_price_item__c)) {
										if (allSatisfiedMandatoryAddOnDependencies[assocRecord.id] === undefined) {
											allSatisfiedMandatoryAddOnDependencies[assocRecord.id] = [];
										}
										allSatisfiedMandatoryAddOnDependencies[assocRecord.id].push(dependencyItem);
									} else if (dependencyItem.Type__c === 'Exclusion') {
										if (dependencyItem.Add_On_Source__c != undefined && dependencyItem.Add_On_Source__c !== '' &&
											(dependencyItem.Add_On_Source__c === assocRecord.cspmb__add_on_price_item__c)) { // exclusion addon dependencies
											if (allExcludedAddOnDependencies[assocRecord.id] === undefined) {
												allExcludedAddOnDependencies[assocRecord.id] = [];
											}
											allExcludedAddOnDependencies[assocRecord.id].push(dependencyItem);
										} else if (dependencyItem.Group_Source__c != undefined && dependencyItem.Group_Source__c !== '' &&
											(dependencyItem.Group_Source__c === assocRecord.cspmb__group__c)) { // exclusion group dependencies
											if (allExcludedAddOnDependencies[assocRecord.id] === undefined) {
												allExcludedAddOnDependencies[assocRecord.id] = [];
											}
											allExcludedAddOnDependencies[assocRecord.id].push(dependencyItem);
										}
										else if ((dependencyItem.Add_On_Source__c === undefined || dependencyItem.Add_On_Source__c === '') &&
											(dependencyItem.Group_Source__c === undefined || dependencyItem.Group_Source__c === '')) {
											if (allExcludedAddOnDependencies[assocRecord.id] === undefined) {
												allExcludedAddOnDependencies[assocRecord.id] = [];
											}

											allExcludedAddOnDependencies[assocRecord.id].push(dependencyItem);
										}
									}
								}
							}
						});

						// Filtering records for each selected add on.
						allInclusionAddOnDependencies = _.filter(allInclusionAddOnDependencies, function (inclusionDependencyItem) {
							var isDependency = false;
							if (inclusionDependencyItem.Add_On_Source__c !== undefined && inclusionDependencyItem.Add_On_Source__c !== '' && inclusionDependencyItem.Add_On_Source__c === assocRecord.cspmb__add_on_price_item__c) {
								isDependency = true;
							}

							if (inclusionDependencyItem.Group_Source__c !== undefined && inclusionDependencyItem.Group_Source__c !== '' && inclusionDependencyItem.Group_Source__c === assocRecord.cspmb__group__c) {
								isDependency = true;
							}

							if (inclusionDependencyItem.Group_Source__c === undefined && inclusionDependencyItem.Add_On_Source__c === undefined) {
								isDependency = true;
							}

							if (isDependency) {
								satisfiedInclusionAddOnDependencies.push(inclusionDependencyItem);
							}

							return !isDependency;
						});
					}
				});
			} else {
				_.each(allDependencyRecordsCached, function (dependencyItem) {
					if ((dependencyItem.Price_Item__c !== undefined && dependencyItem.Price_Item__c === getCurrentCommercialProductId()) ||
						dependencyItem.Price_Item__c === undefined) {

						if (dependencyItem.Type__c === 'Inclusion' && 
							(dependencyItem.Add_On_Source__c === undefined || dependencyItem.Add_On_Source__c === '') &&
							(dependencyItem.Group_Source__c === undefined || dependencyItem.Group_Source__c === '')) {
							if (mapAssocIdRelatedDependencies['priceItemLevel'] === undefined) {
								mapAssocIdRelatedDependencies['priceItemLevel'] = [];
							}

							mapAssocIdRelatedDependencies['priceItemLevel'].push(dependencyItem);
						} else if (dependencyItem.Type__c === 'Exclusion') {
							if ((dependencyItem.Add_On_Source__c === undefined || dependencyItem.Add_On_Source__c === '') &&
								(dependencyItem.Group_Source__c === undefined || dependencyItem.Group_Source__c === '')) {
								if (allExcludedAddOnDependencies['priceItemLevel'] === undefined) {
									allExcludedAddOnDependencies['priceItemLevel'] = [];
								}

								allExcludedAddOnDependencies['priceItemLevel'].push(dependencyItem);
							}
						}
					}
				});

				// Filtering records for each selected add on.
				allInclusionAddOnDependencies = _.filter(allInclusionAddOnDependencies, function (inclusionDependencyItem) {
					var isDependency = false;

					if (inclusionDependencyItem.Group_Source__c === undefined && inclusionDependencyItem.Add_On_Source__c === undefined) {
						isDependency = true;
					}

					if (isDependency) {
						satisfiedInclusionAddOnDependencies.push(inclusionDependencyItem);
					}

					return !isDependency;
				});
			}

			mapAssocIdRelatedDependencies = sortMapBySequence(mapAssocIdRelatedDependencies);
			allOptionalAddOnDependencies = sortMapBySequence(allOptionalAddOnDependencies);
			allSatisfiedMandatoryAddOnDependencies = sortMapBySequence(allSatisfiedMandatoryAddOnDependencies);
			allExcludedAddOnDependencies = sortMapBySequence(allExcludedAddOnDependencies);
			allInclusionAddOnDependencies = sortListBySequence(allInclusionAddOnDependencies);
		}

		resultMap.allOptionalAddOnDependencies = allOptionalAddOnDependencies;
		resultMap.allSatisfiedMandatoryAddOnDependencies = allSatisfiedMandatoryAddOnDependencies;
		resultMap.allExcludedAddOnDependencies = allExcludedAddOnDependencies;
		resultMap.allInclusionAddOnDependencies = allInclusionAddOnDependencies;
		resultMap.mapAssocIdRelatedDependencies = mapAssocIdRelatedDependencies;
		resultMap.satisfiedInclusionAddOnDependencies = satisfiedInclusionAddOnDependencies;
		resultMap.allMandatoryRules = allMandatoryRules;

		cachedDependencyData = resultMap;

		return resultMap;
	}

	/*
	* sortMapBySequence
	*
	* Sort each list in the map based on the sequence field on the SF record.
	*
	* Input parameter: map to sort, map is association id -> list of related dependency items.
	*
	* Returns the same map with all lists sorted.
	*/
	function sortMapBySequence(mapToSort) {
		// sort populated Sequence first and then undefined values
		_.each(mapToSort, function (listItems, key) {
			listItems = sortListBySequence(listItems);
		});

		return mapToSort;
	}

	/*
	* sortListBySequence
	*
	* Sort the list on the sequence field on the SF record.
	*
	* Input parameter: list to sort.
	*
	* Returns the sorted list.
	*/
	function sortListBySequence(listToSort) {
		listToSort.sort(function (a, b) {
			if (a.Sequence__c === undefined) {
				return 1;
			} else if (b.Sequence__c === undefined) {
				return -1;
			} else {
				return a.Sequence__c - b.Sequence__c;
			}
		});

		return listToSort;
	}

	/*
	* buildAssociationGroups
	*
	* Build groups and min and max for it.
	*
	* Input parameter: associations to analyse.
	*
	* Returns the map name -> group data (min, max, count).
	*/
	function buildAssociationGroups(assocs) {
		var groups = {};
		_.each(assocs, function (assoc) {
			var name = assoc.cspmb__group__c;
			groups[name] = {
				max_count: isNaN(Number(assoc.cspmb__max__c)) ? 1000 : Number(assoc.cspmb__max__c),
				min_count: isNaN(Number(assoc.cspmb__min__c)) ? 0 : Number(assoc.cspmb__min__c),
				current_count: 0
			};
		});
		return groups;
	}

	/*
	* getAssociationGroupCounts
	*
	* Get count of added AddOns for each related product and group.
	*
	* Input parameter: associations to analyse and currently selected asociations.
	*
	* Returns the group counts.
	*/
	function getAssociationGroupCounts(assocs, selectedAddOnAssocIds) {
		var groupCounts = {};
		var assocsById = _.fromPairs(_.map(assocs, function (assoc) {
			return [assoc.id, assoc];
		}));

		_.each(selectedAddOnAssocIds, function (id) {
			var assoc = assocsById[id];
			if (assoc) {
				var count = groupCounts[assoc.cspmb__group__c] || (groupCounts[assoc.cspmb__group__c] = 0);
				groupCounts[assoc.cspmb__group__c] = count + 1;
			}
		});

		return groupCounts;
	}

	/*
	* preDrawAssociationListFiltering
	*
	* Performs the pre draw filtering of the available add ons baded on min-max
	* exclusion and inclusion dependencies.
	*
	* Input parameter: all selected add on association ids
	*
	* Returns the filtered list with the following information:
	* { assoc, isAvailable, unavailableReason, max, isExcluded };
	*/
	function preDrawAssociationListFiltering(assocsForRelatedProduct, selectedAddOnAssocIdsForRelatedProduct, currentlySelectedAddOnAssocIdsAllRelatedProducts) {
		prepareDependencyMapsForCommercialProduct(currentlySelectedAddOnAssocIdsAllRelatedProducts);

		var groupCounts = getAssociationGroupCounts(commercialProductAddOnAssociationListCached, selectedAddOnAssocIdsForRelatedProduct);
		var excludedAddOns = getExcludedAddOns();
		var excludedGroups = getExcludedGroups();
		var mapMandatoryTargetAddOnIds = getAllMandatoryTargetAddOns();

		if(Array.isArray(assocsForRelatedProduct) && assocsForRelatedProduct.length > 0) {
			assocsForRelatedProduct.sort((a, b) => (a.cspmb__sequence__c > b.cspmb__sequence__c) ? 1 : -1);
		}

		return _.map(assocsForRelatedProduct, function (assoc) {
			var isAvailable = true;
			var reason = '';
			var isExcluded = false;

			var grp = groupMinMaxValidation[assoc.cspmb__group__c];
			var max = grp.max_count;

			if (!checkForGroupMax(assoc, groupCounts)) {
				isAvailable = false;
				reason += 'The max for group ' + assoc.cspmb__group__c + ' has been exceeded. ';
			}

			if (useDependencyEngine) {
				if (!checkForExclusionRules(assoc, excludedAddOns, excludedGroups)) {
					isExcluded = true;
				}

				if ((!checkForInclusionRules(assoc) || mapMandatoryTargetAddOnIds[assoc.cspmb__add_on_price_item__c] !== undefined)) {
					isAvailable = false;
					reason += 'Add On does not satisfy the inclusion rules. ';
				}
			}

			return { assoc: assoc, isAvailable: isAvailable, unavailableReason: reason, max: max, isExcluded: isExcluded };
		});
	}

	/*
	* getExcludedAddOns
	*
	* Gets the comma separated list of excluded add on names.
	*
	* Returns the comma separated list of excluded add on names.
	*/
	function getExcludedAddOns() {
		var excludedAddOns = '';
		_.each(cachedDependencyData.allExcludedAddOnDependencies, function (it) {
			_.each(it, function (i) {
				if (i.Add_On_Target__c != undefined) {
					excludedAddOns += i.Add_On_Target__r.Name;
					excludedAddOns += ',';
				}
			});
		});
		return excludedAddOns;
	}

	/*
	* getExcludedAddOns
	*
	* Gets the comma separated list of excluded add on names.
	*
	* Returns the comma separated list of excluded add on names.
	*/
	function getExcludedGroups() {
		var excludedGroups = '';
		_.each(cachedDependencyData.allExcludedAddOnDependencies, function (it) {
			_.each(it, function (i) {
				if (i.Group_Target__c != undefined) {
					excludedGroups += i.Group_Target__c;
					excludedGroups += ',';
				}
			});
		});
		return excludedGroups;
	}

	function getMandatoryTargetAddOns() {
		var listOfMandatoryAddOnIds = {};

		_.each(cachedDependencyData.allSatisfiedMandatoryAddOnDependencies, function (it) {
			_.each(it, function (i) {
				if (i.Add_On_Target__c !== undefined) {
					listOfMandatoryAddOnIds[i.Add_On_Target__c] = i.Add_On_Target__c;
				}
			});
		});

		return listOfMandatoryAddOnIds;
	}

	function getAllMandatoryTargetAddOns() {
		var listOfMandatoryAddOnIds = {};

		_.each(cachedDependencyData.allMandatoryRules, function (it) {
			if (it.Add_On_Target__c !== undefined) {
				listOfMandatoryAddOnIds[it.Add_On_Target__c] = it.Add_On_Target__c;
			}
		});

		return listOfMandatoryAddOnIds;
	}

	/*
	* checkForMinMax
	*
	* Checks if the group maximum is exceeded and updates the counter data.
	*
	* Input parameter: association to check and all group counts.
	*
	* Returns false if max is exceeded, true if it is not.
	*/
	function checkForGroupMax(assoc, groupCounts) {
		var grp = groupMinMaxValidation[assoc.cspmb__group__c];
		var max = grp.max_count;
		var count = groupCounts[assoc.cspmb__group__c];

		groupMinMaxValidation[assoc.cspmb__group__c].current_count = isNaN(Number(count)) ? 0 : Number(count);

		if (count + 1 > max) {
			return false;
		}

		return true;
	}

	/*
	* checkForExclusionRules
	*
	* Checks if the add on has been included based on add on dependency inclusion rules.
	*
	* Input parameter: association to check and all excluded add ons
	* prepared in the getExcludedAddOns.
	*
	* Returns false if the add on is excluded, false if it is not.
	*/
	function checkForExclusionRules(assoc, excludedAddOns, excludedGroups) {
		var excludedAddOnsList = excludedAddOns.split(',');
		var excludedGroupsList = excludedGroups.split(',');
		if (excludedAddOnsList.indexOf(assoc.cspmb__add_on_price_item__r.name) != -1 || excludedGroupsList.indexOf(assoc.cspmb__group__c) != -1) {
			return false;
		}

		return true;
	}

	/*
	* checkForInclusionRules
	*
	* Checks if the add on has been included based on add on dependency inclusion rules.
	*
	* Input parameter: association to check.
	*
	* Returns false if the add on is not included, false if it is.
	*/
	function checkForInclusionRules(assoc) {
		var flag = true;
		var satisfied = false;
		_.each(cachedDependencyData.satisfiedInclusionAddOnDependencies, function (satisfiedInclusionDependencyItem) {
			if (satisfiedInclusionDependencyItem.Add_On_Target__c != undefined && satisfiedInclusionDependencyItem.Add_On_Target__c !== '' && satisfiedInclusionDependencyItem.Add_On_Target__c === assoc.cspmb__add_on_price_item__c) {
				satisfied = true;
			}

			if (satisfiedInclusionDependencyItem.Group_Target__c != undefined && satisfiedInclusionDependencyItem.Group_Target__c !== '' && satisfiedInclusionDependencyItem.Group_Target__c === assoc.cspmb__group__c) {
				satisfied = true;
			}
		});

		_.each(cachedDependencyData.allInclusionAddOnDependencies, function (inclusionDependencyItem) {
			if (inclusionDependencyItem.Add_On_Target__c != undefined && inclusionDependencyItem.Add_On_Target__c !== '' && inclusionDependencyItem.Add_On_Target__c === assoc.cspmb__add_on_price_item__c) {
				flag = false;
			}

			if (inclusionDependencyItem.Group_Target__c != undefined && inclusionDependencyItem.Group_Target__c !== '' && inclusionDependencyItem.Group_Target__c === assoc.cspmb__group__c) {
				flag = false;
			}
		});

		return satisfied || flag;
	}

	/*
	* runDependencyEngine
	*
	* Checks the add on dependencies and decides which error messages to display and add ons to add or remove
	*
	* Input parameter: list of currently selected add on association ids.
	*
	* Returns the object with following data: addOnsFromGroupToInclude, groupsToRemove, addOnsForInclusion,
	* dependentAddOnsIdToAdd, dependentAssociationsIdToAdd, dependentAddOnsIdToDelete 
	* dependentAssociationsIdToDelete, groupMinMaxValidation
	*/
	function runDependencyEngine(currentlySelectedAddOnAssocIds) {
		var resultMap = {
			dependentAssociationsIdToAdd: [],
			addOnsFromGroupToInclude: [],
			groupsToRemove: [],
			addOnsToBeIncluded: {},
			dependentAddOnsIdToAdd: [],
			dependentAddOnsIdToDelete: [],
			dependentAssociationsIdToDelete: [],
			addOnsForInclusion: {},
			groupMinMaxValidation: {}
		};

		if(useDependencyEngine) {
			var addOnsFromGroupInclusion = {};
			var groupsToRemove = [];
			var addOnsForInclusion = {};
			var dependentAddOnsIdToAdd = [];
			var dependentAssociationsIdToAdd = [];
			var dependentAddOnsIdToDelete = [];
			var dependentAssociationsIdToDelete = [];

			var addOnsFromGroupToInclude = [];
			var addOnsToBeIncluded = {};

			var mapAssocIdRelatedDependencies = cachedDependencyData.mapAssocIdRelatedDependencies;
			var allOptionalAddOnDependencies = cachedDependencyData.allOptionalAddOnDependencies;
			var allSatisfiedMandatoryAddOnDependencies = cachedDependencyData.allSatisfiedMandatoryAddOnDependencies;
			var allInclusionAddOnDependencies = cachedDependencyData.allInclusionAddOnDependencies;
			var satisfiedInclusionAddOnDependencies = cachedDependencyData.satisfiedInclusionAddOnDependencies;

			_.each(mapAssocIdRelatedDependencies, function (value, key) {
				_.each(value, function (childValue) {
					var targetGroup = childValue.Group_Target__c;
					var useGroupInclusionCheck = false;
					var quantity = isNaN(Number(childValue.Quantity__c)) ? 1 : Number(childValue.Quantity__c);
					var type = childValue.Type__c;
					var addOnTarget = childValue.Add_On_Target__c;
					var targetAddOnMissing = true;
					var targetAddOnName = '';
					var sequence = childValue.Sequence__c;

					// this is check for Target AddOn only
					if (type === 'Inclusion' && childValue.Add_On_Target__r != undefined && childValue.Add_On_Target__r.Name !== '') {
						// check for target add on and store the name for the message
						targetAddOnName = childValue.Add_On_Target__r.Name;
					} else {
						// no target add ons needed for add
						targetAddOnMissing = false;
						targetAddOnName = '';
					}

					// this is check for groups
					if (type === 'Inclusion' && targetGroup !== undefined && targetGroup !== '') {
						// check if inclusion quantity check needed for this dependency record
						useGroupInclusionCheck = true;
					}

					// if it is Mandatory then search for the missing ones
					// this is for adding all the missing add ons in bulk
					if (type === 'Mandatory') {
						// store the Add On Id to check is already present or not
						dependentAddOnsIdToAdd.push(addOnTarget);
					}

					_.each(currentlySelectedAddOnAssocIds, function (assocId) {
						var assocRecord = mapAssocIdAssocRecord[assocId];

						if (assocRecord !== undefined) {
							// skip assoc record for which you are checking dependencies
							// if(assocRecord.id !== key) {
							if (type === 'Inclusion') {
								// check how many is missing from some specific group
								// if quantity at the end is more than 0 show message
								if (targetGroup !== undefined && targetGroup !== '' && assocRecord.cspmb__group__c === targetGroup) {
									quantity--;
								} else if (assocRecord.cspmb__add_on_price_item__c == addOnTarget) {
									// this is used when user wants to add more than 1 AddOn record of the same type
									quantity--;

									if (quantity < 1) {
										// enough Target Add Ons already added
										targetAddOnMissing = false;
									}
								}
							} else if (type === 'Exclusion') {
								if (targetGroup !== undefined && targetGroup !== '' && assocRecord.cspmb__group__c === targetGroup) {
									//if (!_.includes(groupsToRemove, targetGroup)) {
									groupsToRemove.push({ targetGroup: targetGroup, sequence: sequence });
									//}
								} else if (assocRecord.cspmb__add_on_price_item__c == addOnTarget && childValue.Add_On_Target__r != undefined && childValue.Add_On_Target__r.Name !== '') {
									// this is for exclusion of add ons in bulk
									// store the Add On Id to check is already present or not
									if (!_.includes(dependentAddOnsIdToDelete, addOnTarget))
										dependentAddOnsIdToDelete.push(addOnTarget);
								}
							} else if (type === 'Mandatory') {
								if (assocRecord.cspmb__add_on_price_item__c == addOnTarget) {
									_.remove(dependentAddOnsIdToAdd, function (currentItem) {
										return currentItem === addOnTarget;
									});
								}
							}
							//}
						}
					});

					if (quantity > 0 && useGroupInclusionCheck) {
						if (addOnsFromGroupInclusion[key] === undefined) {
							addOnsFromGroupInclusion[key] = [];
						}
						addOnsFromGroupInclusion[key].push(targetGroup);
					}

					// target add on missing is used in Inclusion type rules
					if (targetAddOnMissing) {
						if (addOnsForInclusion[addOnTarget] === undefined) {
							addOnsForInclusion[addOnTarget] = [];
						}

						var listItem = { targetAddOnName: targetAddOnName, quantity: quantity };
						addOnsForInclusion[addOnTarget].push(listItem);
					}

				});
			});

			// invalidate configuration if addons from target group are missing
			_.each(addOnsFromGroupInclusion, function (targetGroups, assocId) {
				_.each(targetGroups, function (targetGroup) {
					var invalidateConfig = true;
					// check if this addon group has any optional records
					// if has optional records and source group is added - do not require target group
					var optionalListForAssocId = allOptionalAddOnDependencies[assocId];
					if (optionalListForAssocId !== undefined && optionalListForAssocId.length > 0) {
						_.each(optionalListForAssocId, function (listItem) {
							var sourceGroupOptional = listItem.Group_Source__c;
							var sourceAddOnOptional = listItem.Add_On_Source__c;
							var targetGroupOptional = listItem.Group_Target__c;

							if (sourceGroupOptional !== undefined && sourceGroupOptional !== '') {
								var assocGroupState = groupMinMaxValidation[sourceGroupOptional];
								if (assocGroupState !== undefined && targetGroup === targetGroupOptional) {
									var currentValue = assocGroupState.current_count;

									if (currentValue > 0) {
										invalidateConfig = false;
									}
								}
							}

							if (sourceAddOnOptional !== undefined && sourceAddOnOptional !== '') {
								_.each(currentlySelectedAddOnAssocIds, function (assocId) {
									var assocRecord = mapAssocIdAssocRecord[assocId];
									if (sourceAddOnOptional === assocRecord.cspmb__add_on_price_item__c) {
										invalidateConfig = false;
									}
								});
							}
						});
					}

					if (invalidateConfig) {
						addOnsFromGroupToInclude.push(targetGroup);
					}
				});
			});

			var addOnsForInclusionFinal = {};
			/// check MIN and MAX and prepare final list to return
			_.each(addOnsForInclusion, function (listItem, key) {
				_.each(mapAssocIdAssocRecord, function (assocValue, assocKey) {
					if (assocValue.cspmb__add_on_price_item__c === key) {
						var optionalListForAssocId = allOptionalAddOnDependencies[assocKey];
						if (optionalListForAssocId === undefined) {
							optionalListForAssocId = allOptionalAddOnDependencies[key];
						}
						var optional = false;
						if (optionalListForAssocId !== undefined && optionalListForAssocId.length > 0) {
							_.each(optionalListForAssocId, function (listItem) {
								if (listItem.Add_On_Target__c === assocValue.cspmb__add_on_price_item__c) {
									optional = true;
								}
							});
						}

						// check on Association level - MIN and MAX within the Group
						var assocGroupState = groupMinMaxValidation[assocValue.cspmb__group__c];
						if (assocGroupState !== undefined) {
							var maxValue = assocGroupState.max_count;
							var currentValue = assocGroupState.current_count;

							if (currentValue < maxValue && !optional) {
								addOnsForInclusionFinal[key] = listItem;
							}
						}
					}
				});
			});

			// sort groups to remove messages in sequence defined order
			groupsToRemove.sort(function (a, b) {
				if (a.sequence === undefined) {
					return 1;
				} else if (b.sequence === undefined) {
					return -1;
				} else {
					return a.sequence - b.sequence;
				}
			});

			// update dependentAddOnsIdToAdd if some are not allowed to be added based on MIN and MAX
			// respect min and max for associations
			if (dependentAddOnsIdToAdd.length > 0) {
				_.each(mapAssocIdAssocRecord, function (assocValue, key) {
					_.each(dependentAddOnsIdToAdd, function (addOnId) {
						if (assocValue.cspmb__add_on_price_item__c === addOnId) {
							var assocGroupState = groupMinMaxValidation[assocValue.cspmb__group__c];
							if (assocGroupState !== undefined) {
								var maxValue = assocGroupState.max_count;
								var currentValue = assocGroupState.current_count;

								if (currentValue < maxValue) {
									dependentAssociationsIdToAdd.push(key);
								}
							}
						}
					});
				});
			}

			//update dependentAddOnsIdToDelete if some are not allowed to be deleted
			if (dependentAddOnsIdToDelete.length > 0) {
				_.each(mapAssocIdAssocRecord, function (value, key) {
					_.each(dependentAddOnsIdToDelete, function (addOnId) {
						if (value.cspmb__add_on_price_item__c === addOnId && (value.cspmb__default_quantity__c === undefined ||
							value.cspmb__default_quantity__c < 1)) {
							var assocGroupState = groupMinMaxValidation[value.cspmb__group__c];
							if (assocGroupState !== undefined) {
								var minValue = assocGroupState.min_count;
								var currentValue = assocGroupState.current_count;

								if (currentValue > minValue) {
									dependentAssociationsIdToDelete.push(key);
								}
							}
						}
					});
				});
			}

			// when "parent" AddOn in Mandatory dependency between AddOn Source and AddOn Target is deleted
			// find "children" and delete them too
			_.each(currentlySelectedAddOnAssocIds, function (selectedAssoc) {
				// get mandatory dependency records
				var depenRecordsForAssoc = allSatisfiedMandatoryAddOnDependencies[selectedAssoc];

				if (depenRecordsForAssoc !== undefined && depenRecordsForAssoc.length > 0) {
					// if its more than just "parent" and "child"
					// this is TRUE if PARENT -> CHILD -> GRANDCHILD relationship found
					var dependenciesExist = false;
					var superDependenciesExist = true;
					var parentFound = false;

					_.each(depenRecordsForAssoc, function (childValue) {
						var addOnTarget = childValue.Add_On_Target__c;
						var addOnSource = childValue.Add_On_Source__c;

						// if this assoc is parent to some addon
						if (addOnSource === mapAssocIdAssocRecord[selectedAssoc].cspmb__add_on_price_item__c) {
							// this assoc is parent to some addon assoc and do not allow deletion of selectedAssoc
							dependenciesExist = true;
						}

						// need to check if parent assoc is currently added
						var enteredInParentCheck = false;

						// it will enter only if selectedAssoc is "child" AddOn Assoc to other AddOn Assoc
						if (addOnTarget === mapAssocIdAssocRecord[selectedAssoc].cspmb__add_on_price_item__c) {
							enteredInParentCheck = true;
							// trying to find parent assoc record
							_.each(currentlySelectedAddOnAssocIds, function (parentAssocId) {
								var parentAssoc = mapAssocIdAssocRecord[parentAssocId];

								if (parentAssoc.cspmb__add_on_price_item__c === addOnSource) {
									parentFound = true;
									dependenciesExist = true;
								}
							});
						}

						// if this assoc is "child" of some MANDATORY relation and "parent" assoc wasnt found
						// delete this "child"
						if (enteredInParentCheck && !parentFound) {
							superDependenciesExist = false;
						}

						// check if "parent" is just being added in this iteration
						// skip deletion because of that
						// use case - when someone tries to delete middle AddOn in Mandatory dependency
						_.each(dependentAssociationsIdToAdd, function (assocIdToAdd) {
							var parentAssoc = mapAssocIdAssocRecord[assocIdToAdd];

							if (parentAssoc.cspmb__add_on_price_item__c === addOnSource) {
								dependenciesExist = true;
								superDependenciesExist = true;
							}
						});

						// if "child" is being currently added
						_.each(dependentAssociationsIdToAdd, function (assocIdToAdd) {
							var childAssoc = mapAssocIdAssocRecord[assocIdToAdd];

							if (childAssoc.cspmb__add_on_price_item__c === addOnTarget) {
								dependenciesExist = true;
							}
						});
					});

					if (!dependenciesExist || (!superDependenciesExist && !parentFound)) {
						if (!_.includes(dependentAssociationsIdToDelete, selectedAssoc)) {
							dependentAssociationsIdToDelete.push(selectedAssoc);
						}
					}
				}

				// Delete target add ons when source is deleted (inclusion)
				// Check for inclusion add ons no longer valid.
				_.each(allInclusionAddOnDependencies, function (inclusionDependencyItem) {
					var satisfied = false;
					var assocRecord = mapAssocIdAssocRecord[selectedAssoc];
					_.each(satisfiedInclusionAddOnDependencies, function (satisfiedDependencyItem) {
						if (satisfiedDependencyItem.Add_On_Target__c === assocRecord.cspmb__add_on_price_item__c || satisfiedDependencyItem.Group_Target__c === assocRecord.cspmb__group__c) {
							satisfied = true;
						}
					});

					if (!satisfied) {
						if (inclusionDependencyItem.Add_On_Target__c === assocRecord.cspmb__add_on_price_item__c || inclusionDependencyItem.Group_Target__c === assocRecord.cspmb__group__c) {
							if (!_.includes(dependentAssociationsIdToDelete, selectedAssoc)) {
								dependentAssociationsIdToDelete.push(selectedAssoc);
							}
						}
					}
				});
			});

			resultMap.addOnsFromGroupToInclude = addOnsFromGroupToInclude;
			resultMap.groupsToRemove = groupsToRemove;
			//resultMap.addOnsToBeIncluded = addOnsToBeIncluded;
			resultMap.addOnsForInclusion = addOnsForInclusionFinal;
			resultMap.dependentAddOnsIdToAdd = dependentAddOnsIdToAdd;
			resultMap.dependentAssociationsIdToAdd = dependentAssociationsIdToAdd;
			resultMap.dependentAddOnsIdToDelete = dependentAddOnsIdToDelete;
			resultMap.dependentAssociationsIdToDelete = dependentAssociationsIdToDelete;
		}

		resultMap.groupMinMaxValidation = groupMinMaxValidation;

		return resultMap;
	}

	return {
		init: init,
		getCurrentCommercialProductId: getCurrentCommercialProductId,
		preDrawAssociationListFiltering: preDrawAssociationListFiltering,
		runDependencyEngine: runDependencyEngine,
		getMandatoryTargetAddOns: getMandatoryTargetAddOns
	};
}

var CSAddOnManager = {};
_.extend(CSAddOnManager, buildAddOnManagerFunctions());