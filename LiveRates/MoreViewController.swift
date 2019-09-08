//
//  MoreViewController.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 29/7/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds

class MoreViewController: UIViewController, MFMailComposeViewControllerDelegate, GADBannerViewDelegate{

    
    @IBOutlet weak var feedback: UIButton!
    @IBOutlet weak var recommend: UIButton!
    @IBOutlet weak var removeAds: UIButton!
    
    
    @IBAction func sendFeedbackClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        sendFeedback()
    }
    
    @IBAction func recommendClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        recommendApp()
    }
    
    
    @IBAction func removeAdsClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        if !premiumSubscriptionPurchased{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            self.navigationItem.backBarButtonItem = backItem
            performSegue(withIdentifier: "moreToSubscription", sender: nil)
        }else{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            self.navigationItem.backBarButtonItem = backItem
            performSegue(withIdentifier: "moreToSupport", sender: nil)
        }
    }
    
   
    var startAppMoreViewBanner: STABannerView?
    var startAppMoreViewBanner2: STABannerView?
    @IBOutlet weak var moreViewBanner1: GADBannerView!
    @IBOutlet weak var startAppBannerView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now()+2) {
            if status != "mailNotAttemped"{
                var alert = UIAlertController()
                if status == "Cancelled"{
                    alert = UIAlertController(title: "Cancelled", message: "Message Cancelled", preferredStyle: .alert)
                    status = "mailNotAttemped"
                }else if status == "Failed"{
                    alert = UIAlertController(title: "Failed", message: "Failed to send the message", preferredStyle: .alert)
                    status = "mailNotAttemped"
                }else if  status == "Saved"{
                    alert = UIAlertController(title: "Saved", message: "Message saved", preferredStyle: .alert)
                    status = "mailNotAttemped"
                }else if status == "Sent"{
                    alert = UIAlertController(title: "Sent", message: "Message successfully sent. We will review your message and get back to you", preferredStyle: .alert)
                    status = "mailNotAttemped"
                }
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        if !premiumSubscriptionPurchased{
            removeAds.setTitle("Remove Ads", for: .normal)
        }else{
            removeAds.setTitle("Support", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedback.layer.masksToBounds=true
        removeAds.layer.masksToBounds=true
        recommend.layer.masksToBounds=true
        
        feedback.layer.cornerRadius = feedback.frame.size.height/2
        removeAds.layer.cornerRadius = feedback.frame.size.height/2
        recommend.layer.cornerRadius = recommend.frame.size.height/2
        
        if premiumSubscriptionPurchased{
            startAppBannerView.isHidden=true
        }else{
            startAppBannerView.isHidden=false
        }
        
        if !premiumSubscriptionPurchased{
            moreViewBanner1.adUnitID = "ca-app-pub-4235447962727236/5595537538"
            moreViewBanner1.rootViewController = self
            moreViewBanner1.load(GADRequest())
            moreViewBanner1.adSize = kGADAdSizeSmartBannerLandscape
            moreViewBanner1.delegate=self
            
            
        }else{
            removeAds.setTitle("Support", for: .normal)
        }
        if !premiumSubscriptionPurchased{
            if startAppMoreViewBanner2 == nil{
                startAppMoreViewBanner2 = STABannerView(size: STA_AutoAdSize,
                                                   autoOrigin: STAAdOrigin_Bottom,
                                                   withDelegate: nil);
                self.startAppBannerView.addSubview(startAppMoreViewBanner2!)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    func recommendApp(){
                let feedbackMessage = "Hello,\nI am using LiveRates app and have found it useful. You might find it useful too. Here is the AppStore link.\n\nhttps://itunes.apple.com/app/liveratescurrencyconverter/id1471361382\n\nCheers!"
                let recommedViewController = UIActivityViewController(activityItems: [feedbackMessage], applicationActivities: nil)
                recommedViewController.popoverPresentationController?.sourceView = self.view
                self.present(recommedViewController, animated: true, completion: nil)
    }
    
    func sendFeedback(){
        
        let mailVC: MFMailComposeViewController = MFMailComposeViewController()
        
        mailVC.mailComposeDelegate = self
        
        mailVC.setToRecipients(["arunasairammanjunatha@gmail.com"])
        mailVC.setSubject("Customer Feedback")
        
        mailVC.setMessageBody("Hello,<br>I would like to give the following feedback about LiveRates Currency Converter<br><br>Feedback: <br><br><br><br><br>", isHTML: true)
        if MFMailComposeViewController.canSendMail(){
            self.present(mailVC, animated: true, completion: nil)
        }else{
            print("Could not send message")
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result{
        case .cancelled :
            print("Cancelled")
            status = "Cancelled"
            break
            
        case .failed :
            print("Failed")
            status = "Failed"
            break
            
        case .saved :
            print("Saved")
            status = "Saved"
            break
            
        case .sent :
            print("Sent")
            status = "Sent"
            break
            
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        if !premiumSubscriptionPurchased{
            if startAppMoreViewBanner == nil{
                startAppMoreViewBanner = STABannerView(size: STA_AutoAdSize,
                                                       autoOrigin: STAAdOrigin_Bottom,
                                                       withDelegate: nil);
                self.moreViewBanner1.addSubview(startAppMoreViewBanner!)
            }
        }
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        if startAppMoreViewBanner != nil{
         self.startAppMoreViewBanner!.removeFromSuperview()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
