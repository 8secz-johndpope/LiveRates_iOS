//
//  SubscriptionViewController.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 4/7/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import StoreKit
import GoogleMobileAds

enum AppStoreReviewManager {
    static func requestReviewIfAppropriate() {
        if !reviewAsked{
             SKStoreReviewController.requestReview()
             reviewAsked = true
        }
       
    }
}

extension SKProduct {
    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
    var localizedPrice: String {
        if self.price == 0.00 {
            return "Get"
        } else {
            let formatter = SKProduct.formatter
            formatter.locale = self.priceLocale
            
            guard let formattedPrice = formatter.string(from: self.price)else {
                return "Unknown Price"
            }
            
            return formattedPrice
        }
    }
}








let kInAppProductPurchasedNotification = "InAppProductPurchasedNotification"
let kInAppPurchaseFailedNotification   = "InAppPurchaseFailedNotification"
let kInAppProductRestoredNotification  = "InAppProductRestoredNotification"
let kInAppPurchasingErrorNotification  = "InAppPurchasingErrorNotification"

// Global Variables
let arr:NSMutableArray = NSMutableArray()
var productID:String!
var introAlreadyCalled = false

var iapProducts = [SKProduct]()
var selectedSubScription:Int!

class SubscriptionViewController: UIViewController, SKPaymentTransactionObserver, GADBannerViewDelegate{
    
    @IBOutlet weak var purchaseLabel: UILabel!
    
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var freeButton: UIButton!
    @IBAction func buyButtonClicked(_ sender: Any) {
        
        blurView.isHidden = false
        activityIndicator.startAnimating()
        
        self.buyProduct(iapProducts[0])
        print(iapProducts[0].localizedPrice)
        
    }
   
    
    @IBAction func freeButtonClicked(_ sender: Any) {

            self.navigationController?.popViewController(animated: true)
    }
    
    var startAppSubscriptionViewBanner: STABannerView?
    @IBOutlet weak var subscriptionViewBanner: GADBannerView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var information: UILabel!
    
    @IBAction func restoreButtonClicked(_ sender: Any) {
        self.restorePurchases()
    }
    
   
    @IBAction func privacyPolicyButtonClicked(_ sender: Any) {
        
        let url = URL(string: "http://www.aictm.in/liverates/privacy_policy.html")!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func termsOfServiceButtonClicked(_ sender: Any) {
            let url = URL(string: "http://www.aictm.in/liverates/terms_of_service.html")!
        
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               } 
        startFetchingAlreadyRunning=false
        buyButton.layer.masksToBounds = true
        freeButton.layer.masksToBounds = true
        buyButton.layer.cornerRadius = buyButton.frame.size.height/2
        freeButton.layer.cornerRadius = freeButton.frame.size.height/2
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 25
        blurView.isHidden=true
        
        if (!premiumSubscriptionPurchased) && (numberOfTimesLaunched != 0){
            subscriptionViewBanner.adUnitID = "ca-app-pub-4235447962727236/3958533569"
            subscriptionViewBanner.rootViewController = self
            subscriptionViewBanner.load(GADRequest())
            subscriptionViewBanner.adSize = kGADAdSizeSmartBannerLandscape
            subscriptionViewBanner.delegate=self
        }
        
        if (!premiumSubscriptionPurchased) && (numberOfTimesLaunched == 0) && (calledFrom=="intro") {
            introAlreadyCalled=true
            self.title = "Live Rates"
            self.freeButton.setTitle("Skip and Continue Freemium", for: .normal)
            calledFrom = ""
        }
        
        let substring1 = "Subscribe"
        let substring2 = "\(iapProducts[0].localizedPrice)/month"
        let font1:UIFont? = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        let font2: UIFont? = UIFont(name: "HelveticaNeue", size: 15.0)
     
        
        let attributedString = NSMutableAttributedString(string: substring1, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: font1!])
        
        let attributedString2 = NSMutableAttributedString(string: substring2, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSMutableAttributedString.Key.font: font2!])
        
        let attributedString3 = NSAttributedString(string: " \(iapProducts[0].localizedPrice)/month.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)])

        
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(attributedString2)
       
        buyButton.setAttributedTitle(attributedString, for: .normal)
        buyButton.titleLabel?.textAlignment = .center
        
        let informationAttributedText = NSMutableAttributedString(string: """
        We currently offer the following auto-renewing subscription option:
        """)
       
        informationAttributedText.append(attributedString3)
        
        informationAttributedText.append(NSMutableAttributedString(string: """
         By subscribing to LiveRates Premium, you will be able to
        """))
        
        informationAttributedText.append(NSMutableAttributedString(string: """
          enjoy Ad free experience, and make use of premium customer support from us
         """, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        informationAttributedText.append(NSMutableAttributedString(string: """
          The payment will be charged to your iTunes Account within 24 hours prior to the end of the free trial period - if applicable - or at the confirmation of your purchase.
            
            Your subscription automatically renews unless auto-renewal is turned off at least 24-hours before the end of the current period. You can cancel auto-renewal at any time, but this won’t affect the currently active subscription period.
            Your iTunes Account will be charged for renewal within 24-hours prior to the end of the current period.
            You can manage your subscriptions and turn off auto-renewal by going to your Account Settings after the purchase and following these steps:
            - Go to Settings - iTunes and AppStore.
            - Tap on your Apple ID at the top of the screen and select View Apple ID.
            - Tap on Subscriptions and select the one you want to manage.
            - Use the provided options to manage your subscriptions.
            Any unused portion of a free trial period, will be forfeited if you purchase a subscription to that publication.
            
            We take the satisfaction and security of our customers very seriously.
         """))
        
            
        
            
        information.attributedText = informationAttributedText
    }
    
    
    // Request For buy the Available Product
    
    func buyProduct(_ product: SKProduct)
    {
        // Add the StoreKit Payment Queue for ServerSide
        SKPaymentQueue.default().add(self)
        if SKPaymentQueue.canMakePayments()
        {
            print("Sending the Payment Request to Apple")
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
            receiptValidation(){ (receiptVarfied) in
                _ = 0
            }
        }
        else
        {
            print("cant purchase")
        }
    }
    
    public func restorePurchases() {
        blurView.isHidden = false
        activityIndicator.startAnimating()
        SKPaymentQueue.default().restoreCompletedTransactions()
        SKPaymentQueue.default().add(self)
       
        
    }

    // function for details of all the transtion done for spacific Account
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    premiumSubscriptionPurchased=true
                  //  receiptValidation(){(receiptVerified) in
                    //    print("Receipt Verified")
                      //  if premiumSubscriptionPurchased{
                            let alert = UIAlertController(title: "Switch to Premium Version", message: "Enjoy using LiveRates as a premium user", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Switch", style: .default, handler: { (action) in
                                switch action.style{
                                case .default:
                                    print("default")
                                    if premiumSubscriptionPurchased{
                                        UserDefaults.standard.set(premiumSubscriptionPurchased, forKey: "premiumSubscriptionPurchased")
                                        calledFromSubscription=true
                                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                    }
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                @unknown default:
                                    print("Unknow error")
                                }
                            }))
                            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                self.present(alert, animated: true, completion: nil)
                            })
                      //  }
                  //  }
                    self.blurView.isHidden=true
                    self.activityIndicator.stopAnimating()
                    break
                    
                case .restored:
                    print("restored")
                    premiumSubscriptionPurchased=true
                    restoreStatus=true
                    self.blurView.isHidden=true
                    self.activityIndicator.stopAnimating()
                  //  receiptValidation(){(receiptVerified) in
                        if restoreStatus{
                            print("Restore Status Alerted")
                            SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                            let alert = UIAlertController(title: "Purchase Restored", message: "You already have the LiveRates premium subscription", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                switch action.style{
                                case .default:
                                    print("default")
                                    if premiumSubscriptionPurchased{
                                        UserDefaults.standard.set(premiumSubscriptionPurchased, forKey: "premiumSubscriptionPurchased")
                                        calledFromSubscription=true
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                    }
                                case .cancel:
                                    print("cancel")

                                case .destructive:
                                    print("destructive")

                                @unknown default:
                                    print("Unknow error")
                                }
                            }))
                            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                self.present(alert, animated: true, completion: nil)
                            })
                            
                        }else{
                            SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                            self.blurView.isHidden=true
                            self.activityIndicator.stopAnimating()
                            print("Alerted")
                            let alert = UIAlertController(title: "Restore unsuccessful", message: "No previous purchases found to restore", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                switch action.style{
                                case .default:
                                    print("default")
                                    self.blurView.isHidden=true
                                    self.activityIndicator.stopAnimating()
                                    
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                @unknown default:
                                    print("Unknow error")
                                }
                            }))
                            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                self.present(alert, animated: true, completion: nil)
                            })
                            SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        }
                        
                   // }
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    self.blurView.isHidden=true
                    self.activityIndicator.stopAnimating()
                    if restoreStatus{
                        let alert = UIAlertController(title: "Purchase Restored", message: "You already have the LiveRates premium subscription", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            switch action.style{
                            case .default:
                                print("default")
                                UserDefaults.standard.set(premiumSubscriptionPurchased, forKey: "premiumSubscriptionPurchased")
                                calledFromSubscription=true
                                self.dismiss(animated: true, completion: nil)
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                            @unknown default:
                                print("Unknow error")
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert = UIAlertController(title: "Purchase Unsuccessful", message: "Purchase did not go through, Try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil ))
                        self.present(alert, animated: true, completion: nil)
                    }
                    break
                    
                default:
                    self.blurView.isHidden=true
                    self.activityIndicator.stopAnimating()
                    break
                }
                break
            }
            
        }
    }
    
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        if !premiumSubscriptionPurchased{
            if startAppSubscriptionViewBanner == nil{
                startAppSubscriptionViewBanner = STABannerView(size: STA_AutoAdSize,
                                                   autoOrigin: STAAdOrigin_Bottom,
                                                   withDelegate: nil);
                self.subscriptionViewBanner.addSubview(startAppSubscriptionViewBanner!)
            }
        }
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        if startAppSubscriptionViewBanner != nil{
            self.startAppSubscriptionViewBanner!.removeFromSuperview()
        }
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }


}
