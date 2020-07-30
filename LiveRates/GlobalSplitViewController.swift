//
//  GlobalSplitViewController.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 22/6/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit

class GlobalSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
   
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return .lightContent
//        
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               } 
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        // Do any additional setup after loading the view.
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
