//
//  TabLayoutScrollView.swift
//  IOSTablayoutWithViewPager
//
//  Created by Sanjeev .Gautam on 03/07/17.
//  Copyright © 2017 SWS. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

//MARK:- Delegate
@objc protocol TabLayoutScrollViewDelegate {
    @objc optional func tabLayoutScrollView(tabLayoutView: TabLayoutScrollView, didSelectedTabInView item: Int) -> Void
}

//MARK:- Datasource
protocol TabLayoutScrollViewDataSource {
    func numberOfTabsInLayout() -> Int
    func tabLayoutScrollView(titleForTabAtIndex index: Int) -> String
    func styleOfSelectedTab() -> (font: UIFont, color: UIColor)
    func styleOfNonSelectedTab() -> (font: UIFont, color: UIColor)
    func styleOfTabLine() -> (height: CGFloat, color: UIColor)
    func marginBetweenTabs() -> CGFloat
}

//MARK:- TabLayoutScrollView
class TabLayoutScrollView: UIView {
    
    // delgate & datasource object
    var delegate: TabLayoutScrollViewDelegate?
    var dataSource: TabLayoutScrollViewDataSource?
    
    // varibale and object
    var scrollView: UIScrollView?
    var nextSelectedHeaderButton: UIButton?

    fileprivate var bottomLine: UIView?
    fileprivate var selectedHeaderButton: UIButton?
    
    
    //MARK:- Properties
    fileprivate var marginOfTextCustom: CGFloat?
    fileprivate var nonSelectedTabTextFont: UIFont {
        get {
            if let font = self.dataSource?.styleOfNonSelectedTab().font {
                return font
            }
            return UIFont.systemFont(ofSize: 14.0)
        }
    }
    
    fileprivate var nonSelectedTabTextColor: UIColor {
        get {
            if let color = self.dataSource?.styleOfNonSelectedTab().color {
                return color
            }
            return UIColor.black
        }
    }
    
    fileprivate var selectedTabTextFont: UIFont {
        get {
            if let font = self.dataSource?.styleOfSelectedTab().font {
                return font
            }
            return UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    fileprivate var selectedTabTextColor: UIColor {
        get {
            if let color = self.dataSource?.styleOfSelectedTab().color {
                return color
            }
            return UIColor.blue
        }
    }

    fileprivate var marginOfText: CGFloat {
        get {
            if self.marginOfTextCustom == nil {
                if let margin = self.dataSource?.marginBetweenTabs() {
                    return margin
                }
                return 30
            } else {
                return self.marginOfTextCustom!
            }
        }
        set {
            self.marginOfTextCustom = newValue
        }
    }
    
    fileprivate var bottomLineColor: UIColor {
        get {
            if let clr = self.dataSource?.styleOfTabLine().color {
                return clr
            }
            return UIColor.blue
        }
    }
    
    fileprivate var bottomLineHeight: CGFloat {
        get {
            if let height = self.dataSource?.styleOfTabLine().height {
                return height
            }
            return 2.0
        }
    }
    
    fileprivate var numberOfTabs: Int {
        get {
            return self.dataSource?.numberOfTabsInLayout() ?? 0
        }
    }
    
    //MARK:- view init
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    //MARK:- view draw
    func drawHeaderView() -> Void {
        
        if numberOfTabs == 0 {
            return
        }
        
        // scrollview draw
        scrollView = UIScrollView(frame: self.bounds)
        if scrollView != nil {
            scrollView!.tag = 111
            scrollView!.showsHorizontalScrollIndicator = false
            scrollView!.backgroundColor = UIColor.clear
            self.addSubview(scrollView!)
        }
        
        // draw buttons of header
        var i = 0
        var xOrigion: CGFloat = 0
        let yOrigin: CGFloat = 0
        let totalDisplayMarginPlaces = numberOfTabs + 1
        
        //-- * below code is used to set the header width as per vdevice width if dynamic width is lower than device width
        var totalCalculatedWidth: CGFloat = 0
        while i<numberOfTabs {
            let btnTitle = self.dataSource?.tabLayoutScrollView(titleForTabAtIndex: i) ?? ""
            let btnWidth = self.getWidthAsPerText(selectedTabTextFont, text: btnTitle)
            totalCalculatedWidth = totalCalculatedWidth + btnWidth
            i+=1
        }
        totalCalculatedWidth = totalCalculatedWidth + (marginOfText * CGFloat(totalDisplayMarginPlaces))
        if totalCalculatedWidth < self.frame.width {
            let diffrence = self.frame.width - totalCalculatedWidth
            marginOfText = marginOfText + (diffrence / CGFloat(totalDisplayMarginPlaces))
        }
        //-- * ------------------------------------------------------------ *
        
        i = 0
        xOrigion = marginOfText
        while i<numberOfTabs {
            
            let btnTitle = self.dataSource?.tabLayoutScrollView(titleForTabAtIndex: i) ?? ""
            let btnHeight = self.frame.height
            let btnWidth = self.getWidthAsPerText(selectedTabTextFont, text: btnTitle)
            
            let button = UIButton(type: UIButtonType.custom)
            button.tag = i
            button.frame = CGRect(x: xOrigion, y: yOrigin, width: btnWidth, height: btnHeight)
            
            button.setTitleColor(nonSelectedTabTextColor, for: UIControlState())
            button.setTitle(btnTitle, for: UIControlState())
            button.addTarget(self, action: #selector(TabLayoutScrollView.buttonAction(_:)), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = nonSelectedTabTextFont
            
            xOrigion = xOrigion + button.frame.size.width + marginOfText
            i+=1
            
            scrollView?.addSubview(button)
            
            // get reference of first button
            if selectedHeaderButton == nil {
                selectedHeaderButton = button
            }
        }
        
        // set content size of scrollview
        scrollView?.contentSize = CGSize(width: xOrigion, height: self.frame.height)
        
        let btnTitle = self.dataSource?.tabLayoutScrollView(titleForTabAtIndex: 0) ?? ""
        let width = self.getWidthAsPerText(selectedTabTextFont, text: btnTitle)
        
        // draw line bottom at bottom of first button
        bottomLine = UIView(frame: CGRect(x: marginOfText,y: self.frame.height-bottomLineHeight,width: width,height: bottomLineHeight))
        if bottomLine != nil {
            bottomLine!.backgroundColor = bottomLineColor
            bottomLine!.tag = 113
            bottomLine!.isUserInteractionEnabled = false
            scrollView!.addSubview(bottomLine!)
        }
        
        // set first button text color
        self.setSelectedHeaderButtonTextColor(0)
    }
    
    //MARK:- Button action
    func buttonAction(_ sender:UIButton!)
    {
        selectedHeaderButton = sender
        
        // call delegate to send notifcaiton of selected button
        if self.delegate != nil {
            self.delegate!.tabLayoutScrollView!(tabLayoutView: self, didSelectedTabInView: sender.tag)
        }
        
        // scroll line & scrollview to selected button
        self.autoScrollToScrollView(sender)
    }
    
    //MARK:- View Animation
    func autoScrollToScrollView(_ sender:UIButton!) {
        
        // get frame of selected button for line
        let xOrigin = sender.frame.origin.x
        let btnTitle = self.dataSource?.tabLayoutScrollView(titleForTabAtIndex: sender.tag) ?? ""
        let widthOfTitle = self.getWidthAsPerText(selectedTabTextFont, text: btnTitle)
        
        let centeredRect = CGRect(x: sender.frame.origin.x + sender.frame.size.width/2.0 - self.frame.size.width/2.0,
                                  y: sender.frame.origin.y + sender.frame.size.height/2.0 - self.frame.size.height/2.0,
                                  width: self.frame.size.width,
                                  height: self.frame.size.height) as CGRect
        
        // move line
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            if self.bottomLine != nil {
                self.bottomLine!.frame = CGRect(x: xOrigin, y: self.bottomLine!.frame.origin.y, width: widthOfTitle, height: self.bottomLine!.frame.size.height)
            }
            
            // scroll selected button to the centre of the screen
            self.scrollView?.scrollRectToVisible(centeredRect, animated: true)
            
        }, completion: { (isValue) -> Void in
            
            // set selected button text color
            self.setSelectedHeaderButtonTextColor(sender.tag)
            
            self.selectedHeaderButton = sender
        })
        
    }
    
    // move line when user scroll page
    func moveLineWithPageDragging(_ scrollviewOfPageVC: UIScrollView) {
        
        var diffrence = scrollviewOfPageVC.contentOffset.x - ScreenWidth
        if diffrence == 0 {
            return
        }
        
        if diffrence > 0 {
            
            if selectedHeaderButton != nil, let btnAtRightPosition = scrollView?.viewWithTag(selectedHeaderButton!.tag+1) as? UIButton {
                
                nextSelectedHeaderButton = btnAtRightPosition
                
                let percentageOfScroll = (diffrence * 100) / ScreenWidth
                
                let lineX = (((btnAtRightPosition.frame.origin.x - selectedHeaderButton!.frame.origin.x) * percentageOfScroll) /  100) + selectedHeaderButton!.frame.origin.x
                
                let percentageWidthOfnextButton = (btnAtRightPosition.frame.size.width * percentageOfScroll) / 100
                var lineWidth: CGFloat = 0
                if selectedHeaderButton!.frame.size.width < btnAtRightPosition.frame.size.width {
                    lineWidth = selectedHeaderButton!.frame.size.width + percentageWidthOfnextButton
                    if lineWidth > btnAtRightPosition.frame.size.width {
                        lineWidth = btnAtRightPosition.frame.size.width
                    }
                }
                else {
                    lineWidth = selectedHeaderButton!.frame.size.width - percentageWidthOfnextButton
                    if lineWidth < btnAtRightPosition.frame.size.width {
                        lineWidth = btnAtRightPosition.frame.size.width
                    }
                }
                
                if self.bottomLine != nil {
                    self.bottomLine!.frame = CGRect(x: lineX, y: self.bottomLine!.frame.origin.y, width: lineWidth, height: self.bottomLine!.frame.size.height)
                }
            }
            
        } else {
            diffrence = diffrence * -1
            if selectedHeaderButton != nil, let btnAtLeftPosition = scrollView?.viewWithTag(selectedHeaderButton!.tag-1) as? UIButton {
                
                nextSelectedHeaderButton = btnAtLeftPosition
                
                let percentageOfScroll = (diffrence * 100) / ScreenWidth
                
                let lineX = (((btnAtLeftPosition.frame.origin.x - selectedHeaderButton!.frame.origin.x) * percentageOfScroll) /  100) + selectedHeaderButton!.frame.origin.x
                
                let percentageWidthOfnextButton = (btnAtLeftPosition.frame.size.width * percentageOfScroll) / 100
                var lineWidth: CGFloat = 0
                if selectedHeaderButton!.frame.size.width < btnAtLeftPosition.frame.size.width {
                    lineWidth = selectedHeaderButton!.frame.size.width + percentageWidthOfnextButton
                    if lineWidth > btnAtLeftPosition.frame.size.width {
                        lineWidth = btnAtLeftPosition.frame.size.width
                    }
                }
                else {
                    lineWidth = selectedHeaderButton!.frame.size.width - percentageWidthOfnextButton
                    if lineWidth < btnAtLeftPosition.frame.size.width {
                        lineWidth = btnAtLeftPosition.frame.size.width
                    }
                }
                
                if self.bottomLine != nil {
                    self.bottomLine!.frame = CGRect(x: lineX, y: self.bottomLine!.frame.origin.y, width: lineWidth, height: self.bottomLine!.frame.size.height)
                }
            }
        }
    }
    
    // move line without animation
    func moveLineWithOutAnimation(_ btn: UIButton) {
        selectedHeaderButton = btn
        
        if self.bottomLine != nil {
            self.bottomLine!.frame = CGRect(x: btn.frame.origin.x, y: self.bottomLine!.frame.origin.y, width: btn.frame.size.width, height: self.bottomLine!.frame.size.height)
        }
        
        let centeredRect = CGRect(x: btn.frame.origin.x + btn.frame.size.width/2.0 - self.frame.size.width/2.0,
                                  y: btn.frame.origin.y + btn.frame.size.height/2.0 - self.frame.size.height/2.0,
                                  width: self.frame.size.width,
                                  height: self.frame.size.height) as CGRect
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView?.scrollRectToVisible(centeredRect, animated: false)
        })
    }
    
    //MARK:- UI
    fileprivate func setSelectedHeaderButtonTextColor(_ tag: Int) {
        
        if scrollView != nil {
            for view in scrollView!.subviews {
                if view.isKind(of: UIButton.self) {
                    
                    let btn = view as! UIButton
                    if btn.tag == tag {
                        btn.setTitleColor(selectedTabTextColor, for: UIControlState())
                        btn.titleLabel?.font = selectedTabTextFont
                    }
                    else {
                        btn.setTitleColor(nonSelectedTabTextColor, for: UIControlState())
                        btn.titleLabel?.font = nonSelectedTabTextFont
                    }
                }
            }
        }
    }
    
    //MARK:- Utility
    fileprivate func getWidthAsPerText(_ font: UIFont, text: String) -> CGFloat {
        
        let attributes = [NSFontAttributeName : font]
        let rect = text.boundingRect(with: CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.width
    }
}
