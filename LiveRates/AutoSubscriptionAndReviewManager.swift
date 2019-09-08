//
//  AutoSubscriptionAndReviewManager.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 4/7/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import Foundation
import StoreKit

enum AppStoreReviewManager {
    static func requestReviewIfAppropriate() {
        SKStoreReviewController.requestReview()
    }
}
class AutoSubscriptionAndReviewManager: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        <#code#>
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        <#code#>
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var product: SKProduct?
    var productID = "com.13148059.LiveRates"
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
