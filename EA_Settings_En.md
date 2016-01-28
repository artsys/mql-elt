

# Basic settings #
> TWICE\_LOT - The value of max. volume, after which the adviser will split the amount of orders put up in equal parts.
> MN - Magick which will work advisor. others magick will not be processed
> ## Grid Settings Limit ##
    * Main Grid Properties (mgp) - setting up a basic grid main grid - a grid of level 1. Netting is constructed from a parent orders billed manually, or open an adviser to one of the built-in strategies. Nets constructed from the stop orders are subsidiaries and have a level 2 or more
> ### Setting target with ###
    * mgp\_Target - Fixed value target with (or is canceled using useAVG\_H1 useAVG\_D)
    * mgp\_TargetPlus - target with an increase depending on the level on points mgp\_TargetPlus
> #### Settings TakeProfit ####
    * mgp\_TP\_on\_first - count. items to be placed on the parent order m, when the child is not triggered orders
    * mgp\_TP - count. items to be placed on the work warrants m grid. calculated on the last warrants triggered
    * mgp\_TPPlus - m increase in the level of a specified number of points.
> #### Settings stoploss ####
    * mgp\_needSLToAll - true / false - display words by the whole grid on the last warrants or separately for each order
    * mgp\_SL - depends on the dimension of mgp\_needSLToAll: items
    * mgp\_SLPlus - Increase cl depending on the current grid
> #### Setting Limmit Grid ####
    * mgp\_useLimOrders = true / false - enables an adviser to limit use of the grid
    * mgp\_LimLevels - Limit the number of levels of the grid, including the parent of a warrant
> #### Setting the averaging ####
    * mgp\_plusVol - an increase of the Lot. level by an amount mgp\_plusVol
    * mgp\_multiplyVol - an increase of the trace. level mgp\_multiplyVol times
> ### Setting up an additional limit order ###
> after operation, an additional limit order is an order to be a parent of a grid of the second order agreement: a grid for an additional warrant is calculated from the grid configuration settings Limit
    * add\_useAddLimit = true / false - enables an adviser to put an additional limit order as a parent
    * add\_LimitLevel - the level of the grid on which the price will be calculated incremental order
    * add\_Limit\_Pip - how many points will be put on the level of an additional order
    * add\_Limit\_useLevelVol = true / false - enables an adviser to use a different configuration will be used add\_Limit\_multiplyVol add\_Limit\_fixVol
    * add\_Limit\_multiplyVol - coefficients. multiplying the volume level of the main grid add\_LimitLevel limit orders
    * add\_Limit\_fixVol - a fixed amount of additional orders

> ### Setting up additional stop order ###
after the stop trigger, an additional stop order is an order to be a parent of a grid of order
Agreement: a grid for an additional warrant is calculated from the grid configuration Limit
    * add\_useAddStop = true / false - enables an adviser to put an additional stop order as the parent
    * add\_StopLevel - the level of the grid on which the price will be calculated an additional warrant. Parental Order is on the 1st level
    * add\_Stop\_Pip - how many points will be put on the level of an additional order
    * add\_Stop\_useLevelVol = true / false - enables an adviser to use a different configuration will be used add\_Stop\_multiplyVol add\_Stop\_fixVol
    * add\_Stop\_multiplyVol - coefficients. multiplying the volume level of the main grid add\_StopLevel limit orders
    * add\_Stop\_fixVol - a fixed amount of additional orders

> ## Stop orders and child grid ##

> ### Setting of stop orders ###
    * SO\_useStopLevels = true / false - enables an adviser to use the nomination of stop orders
    * SO\_Levels - 1 - number of levels coincides with the levels of limit orders, or sets of stop levels kolichetvo
    * SO\_StartLevel - the level at which stop orders are set for the parent. The parent has an index of a warrant
    * SO\_useLimLevelVol = true / false - enables use of the volume of the current level of Limit grid to calculate the volume of stop orders
    * SO\_LimLevelVol\_Divide - dividing the volume of lymph. order to calculate the amount of feet. to the level of LevelVolParent. For -1 exhibited the parent volume
    * SO\_EndLevel - Settings SO\_useLimLevelVol SO\_LimLevelVol\_Divide and will be used to this level including
    * SO\_ContinueLevel - Includes up to this level and will continue to exhibit SO\_Levels stop orders.
    * SO\_ContLevelVol\_Divide - To calculate the amount of value is the amount of current Limit level.
> ### Setting child grids ###
    * SO\_useKoefProp true / false - enables an adviser to use a target with the settings, m and lyrics for the child grid as a coefficient. multiplication with respect to the settings of the parent grid.
    * SO\_Target - depending on SO\_useKoefProp will be set to target with before. net 