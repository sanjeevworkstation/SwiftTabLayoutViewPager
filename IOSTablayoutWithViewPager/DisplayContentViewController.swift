//
//  DisplayContentViewController.swift
//  IOSTablayoutWithViewPager
//
//  Created by Sanjeev .Gautam on 03/07/17.
//  Copyright © 2017 SWS. All rights reserved.
//

import UIKit

class DisplayContentViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var pageNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.label.text = pageNumber ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
