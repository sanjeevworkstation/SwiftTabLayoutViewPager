## IOS_TabLayoutViewPager

### Overview
____________________________________________________________________________________________
Design Tab Layout View pager for IOS same as android native component.

<a href="http://imgur.com/pM4MzNv"><img src="http://i.imgur.com/pM4MzNv.png?1" title="source: imgur.com" /></a><a href="http://imgur.com/RS5D0xX"><img src="http://i.imgur.com/RS5D0xX.png" title="source: imgur.com" /></a>

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
