## IOS_TabLayoutViewPager

### Overview
____________________________________________________________________________________________
Design Tab Layout View pager for IOS same as android native component.

![](https://photos.google.com/share/AF1QipP8UzHPvro-cibYxKqU5ZKhxyiF9gEnOAcafttm1jzqQecX_tpKYo2_lxzulvWCrw?key=d0NWZ0JseGN1cE5rSFZEeGlwellSa2NTVko0dUp3)
![]({{site.baseurl}}//Simulator%20Screen%20Shot%2004-Jul-2017%2C%2011.20.04%20AM.png)

### Basic
____________________________________________________________________________________________

TabLayoutScrollView has some delegates and datasources to render the view-

**DataSources:**
- func numberOfTabsInLayout() -> Int
- func tabLayoutScrollView(titleForTabAtIndex index: Int) -> String
- func styleOfSelectedTab() -> (font: UIFont, color: UIColor)
- func styleOfNonSelectedTab() -> (font: UIFont, color: UIColor)
- func styleOfTabLine() -> (height: CGFloat, color: UIColor)
- func marginBetweenTabs() -> CGFloat

    
**Delegates:**
- func tabLayoutScrollView(tabLayoutView: TabLayoutScrollView, didSelectedTabInView item: Int) -> Void

    
    
### License
____________________________________________________________________________________________
TabLayoutScrollView is available under the SWS license.
Copyright © 2017 SWS
