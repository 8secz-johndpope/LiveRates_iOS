//
//  AppStoreReviewManager.swift
//  Forex Wallet
//
//  Created by Aruna Sairam Manjunatha on 23/6/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import Foundation
import StoreKit

enum AppStoreReviewManager {
    static func requestReviewIfAppropriate() {
        SKStoreReviewController.requestReview()
    }
}
class AutoRenewableSubscription: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate{
    var product: SKProduct?
    var productID = "com.13148059.LiveRates"
}
