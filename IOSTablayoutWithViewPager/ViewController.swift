//
//  ViewController.swift
//  IOSTablayoutWithViewPager
//
//  Created by Sanjeev .Gautam on 03/07/17.
//  Copyright © 2017 SWS. All rights reserved.
//

import UIKit

private let PageControlScrollViewTag = 111

class ViewController: UIViewController {

    @IBOutlet weak var tabParentView: UIView!
    
    var tabLayoutScrollView:TabLayoutScrollView!
    var pageVC: UIPageViewController!
    var currentChildIndex = -1
    var isDragging = false
    
    let tabsList = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "TabLayout ViewPager"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addTabLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Perform Seque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "embedToPageVC" {
            pageVC = segue.destination as! UIPageViewController
            
            pageVC.dataSource = self
            pageVC.delegate = self
            
            if let firstViewController = orderedViewControllers.first {
                currentChildIndex = 0
                
                pageVC.setViewControllers(
                    [firstViewController],
                    direction: .forward,
                    animated: true,
                    completion: nil
                )
            }
            
            for view in pageVC.view.subviews {
                if let scrollView = view as? UIScrollView {
                    scrollView.delegate = self
                    scrollView.tag = PageControlScrollViewTag
                }
            }
        }
    }
    
    // MARK:- Button Actions
    func dismissScreenFunc() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper
    fileprivate func addTabLayout() {
        if tabLayoutScrollView == nil {
            
            tabLayoutScrollView = TabLayoutScrollView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.tabParentView.frame.size.height))
            tabLayoutScrollView.delegate = self
            tabLayoutScrollView.dataSource = self
            tabLayoutScrollView.backgroundColor = UIColor.groupTableViewBackground
            tabLayoutScrollView.drawHeaderView()
            self.tabParentView.addSubview(tabLayoutScrollView)
        }
    }
    
    //MARK:- Page controller
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        
        var instantiatedArray: [UIViewController] = []
        
        for name in self.tabsList {
            let vcObject = self.storyboard?.instantiateViewController(withIdentifier: "\(DisplayContentViewController.self)") as! DisplayContentViewController
            vcObject.pageNumber = name
            instantiatedArray.append(vcObject)
        }
        
        return instantiatedArray
    }()
}

// MARK:- UIPageViewController DataSource & Delegate
extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func setChildViewControllers(_ tag: Int) {
        
        switch tag {
        case 0:
            pageVC.setViewControllers([orderedViewControllers.first!], direction: .reverse, animated: true, completion: nil)
        case tabsList.count-1:
            pageVC.setViewControllers([orderedViewControllers.last!], direction: .forward, animated: true, completion: nil)
            
        default:
            if currentChildIndex < tag {
                pageVC.setViewControllers([orderedViewControllers[tag]], direction: .forward, animated: true, completion: nil)
            }
            else {
                pageVC.setViewControllers([orderedViewControllers[tag]], direction: .reverse, animated: true, completion: nil)
            }
        }
        currentChildIndex = tag
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed && finished)
        {
            let viewControllerIndex11 = orderedViewControllers.index(of: pageViewController.viewControllers!.first!)
            
            currentChildIndex = (viewControllerIndex11?.hashValue)!
        }
        else{
            return
        }
        
        let btn = tabLayoutScrollView.scrollView?.viewWithTag(currentChildIndex)
        if btn != nil {
            tabLayoutScrollView.moveLineWithOutAnimation(btn as! UIButton)
        }
    }
}

//MARK:- UIScrollview of UIPageControl
extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.tag == PageControlScrollViewTag {
            if tabLayoutScrollView != nil && isDragging {
                tabLayoutScrollView.moveLineWithPageDragging(scrollView)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if scrollView.tag == PageControlScrollViewTag {
            isDragging = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.tag == PageControlScrollViewTag {
            isDragging = false
            if tabLayoutScrollView.nextSelectedHeaderButton != nil {
                let btn = tabLayoutScrollView.scrollView?.viewWithTag(currentChildIndex)
                if btn != nil {
                    tabLayoutScrollView.autoScrollToScrollView(btn as! UIButton)
                }
            }
        }
    }
}

//MARK:- JukeboxScrollableItemsView Delegate & DataSource
extension ViewController: TabLayoutScrollViewDataSource {
    
    func numberOfTabsInLayout() -> Int {
        return tabsList.count
    }
    
    func tabLayoutScrollView(titleForTabAtIndex index: Int) -> String {
        return tabsList[index]
    }
    
    func styleOfTabLine() -> (height: CGFloat, color: UIColor) {
        return (2.0, UIColor.red)
    }
    
    func styleOfSelectedTab() -> (font: UIFont, color: UIColor) {
        return (UIFont.boldSystemFont(ofSize: 15), UIColor.red)
    }
    
    func styleOfNonSelectedTab() -> (font: UIFont, color: UIColor) {
        return (UIFont.systemFont(ofSize: 14.0), UIColor.black)
    }
    
    func marginBetweenTabs() -> CGFloat {
        return 25.0
    }
}

extension ViewController: TabLayoutScrollViewDelegate {
    
    func tabLayoutScrollView(tabLayoutView: TabLayoutScrollView, didSelectedTabInView item: Int) {
        print("Selected Tab: \(item)")
        self.setChildViewControllers(item)
    }
}
