//
//  Currency Table.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 13/6/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import StoreKit
import GoogleMobileAds
import MessageUI



struct favoriteCurrencies: Codable{
    var currName = ""
    var fullForm = ""
    var symbol = ""
    var image: Data = UIImage(named: "add.png")!.pngData()!
}


var selectedCurrencies = [favoriteCurrencies(currName: "Select", fullForm: "Select", symbol: "$", image: UIImage(named: "add.png")!.pngData()!)]

var baseCurrencyName = favoriteCurrencies(currName: "Select", fullForm: "Select", symbol: "$", image: UIImage(named: "add.png")!.pngData()!)

var targetCurrencyName = ""
var calledFrom = ""
var baseCurrencyAmountGlobal = ""
var selectedArrayIndex = 0
var containsDecimal = false
var reviewAsked = false
var firstLaunch = Bool()
var alreadyPresentLocation = Int()
var inserted = false
var tableAnimationDone = Bool()
var selectedCurrenciesForSharing = ["Forex Rates"]
var localCurrencyCode = "USD"
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor?{
        get{
            return self.placeHolderColor
        }
        set{
            var font1 = UIFont()
            if (UIDevice.modelName == "iPhone 5" || UIDevice.modelName == "iPhone 5c" || UIDevice.modelName == "iPhone 5s" || UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "iPhone 4" || UIDevice.modelName == "iPhone 4s" || UIDevice.modelName == "iPod Touch 5" || UIDevice.modelName == "iPod Touch 6" || UIDevice.modelName == "Simulator iPhone 5" || UIDevice.modelName == "Simulator iPhone 5c" || UIDevice.modelName == "Simulator iPhone 5s" || UIDevice.modelName == "Simulator iPhone SE" || UIDevice.modelName == "Simulator iPhone 4" || UIDevice.modelName == "Simulator iPhone 4s" || UIDevice.modelName == "Simulator iPod Touch 5" || UIDevice.modelName == "Simulator iPod Touch 6")
            {
                font1 = UIFont(name: "HelveticaNeue", size: 11.0)!
            }
            else{
                font1 = UIFont(name: "HelveticaNeue", size: 15.0)!
            }
            
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder!: "", attributes: [NSAttributedString.Key.foregroundColor: newValue!, NSAttributedString.Key.font : font1])
        }
    }
}

 var sharingEnabled = false

class CurrencyTable: UIViewController, UITextFieldDelegate, UITabBarDelegate, GADBannerViewDelegate, GADInterstitialDelegate, STADelegateProtocol, STABannerDelegateProtocol{
   
    var onboardingCell: TableViewCellOnboarding?
    
    @IBOutlet weak var plusAddButton: UIBarButtonItem!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var shareCurrencyButton: UIButton!
    
    @IBOutlet weak var shareCurrencyText: UIButton!
    
    @IBAction func baseCurrencyButton(_ sender: Any) {
        self.selectBaseCurrency()
    }
    
    @IBAction func shareCurrencyTextClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
       // if sharingEnabled == false{
            tableView.isEditing=false
            tableView.allowsMultipleSelection = true
            tableView.allowsMultipleSelectionDuringEditing = true
            sharingEnabled = true
            EditButton.isEnabled = false
            tableView.setEditing(true, animated: true)
            removeAdButton.setImage(UIImage(named: "Send"), for: .normal)
            removeAd.setTitle("Send", for: .normal)
            moreButton.setImage(UIImage(named: "Cancel"), for: .normal)
            more.setTitle("Cancel", for: .normal)
            shareCurrencyButton.isEnabled=false
            shareCurrencyText.isEnabled=false
            shareCurrencyText.setTitle("", for: .normal)
            shareCurrencyButton.isHidden=true
            removeAdButton.isEnabled = false
            removeAd.isEnabled = false
            removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 0.531044662, green: 0.3263615966, blue: 0.03531886265, alpha: 1)), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                self.tableView.reloadData()
            })
    }
    
    @IBAction func shareCurrencyButtonClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
            tableView.isEditing=false
            tableView.allowsMultipleSelection = true
            tableView.allowsMultipleSelectionDuringEditing = true
            sharingEnabled = true
            EditButton.isEnabled = false
            tableView.setEditing(true, animated: true)
            removeAdButton.setImage(UIImage(named: "Send"), for: .normal)
            removeAd.setTitle("Send", for: .normal)
            moreButton.setImage(UIImage(named: "Cancel"), for: .normal)
            more.setTitle("Cancel", for: .normal)
            shareCurrencyButton.isEnabled=false
            shareCurrencyText.isEnabled=false
            shareCurrencyText.setTitle("", for: .normal)
            shareCurrencyButton.isHidden=true
            removeAdButton.isEnabled = false
            removeAd.isEnabled = false
            removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 0.531044662, green: 0.3263615966, blue: 0.03531886265, alpha: 1)), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                self.tableView.reloadData()
            })
    }
    
  
    
    // function for get the receiptValidation from the server for get  receiptValiation we need to recieptString and shared secret which will provided by Apple and we have pass those in following way to get All the subscription Data
    
    
    
    @IBOutlet weak var diamond: UIButton!
    
    @IBAction func diamondClicked(_ sender: Any) {
        if !premiumSubscriptionPurchased{
            performSegue(withIdentifier: "segueToSubscriptionVCFromHome", sender: nil)
        }else{
            
        }
    }
    
    
    
    @IBOutlet weak var more: UIButton!
    @IBAction func moreClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        if sharingEnabled{
            tableView.allowsMultipleSelection = false
            tableView.allowsMultipleSelectionDuringEditing = false
            sharingEnabled = false
            EditButton.isEnabled=true
            tableView.setEditing(false, animated: true)
            print(selectedCurrenciesForSharing)
            
            if !premiumSubscriptionPurchased{
                removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
                removeAd.setTitle("Remove Ads", for: .normal)
            }else{
                removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
                removeAd.setTitle("Support", for: .normal)
            }
            moreButton.setImage(UIImage(named: "More"), for: .normal)
            more.setTitle("More", for: .normal)
            
            shareCurrencyButton.isEnabled=true
            shareCurrencyText.isEnabled=true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                self.tableView.reloadData()
            })
            
            shareCurrencyText.setTitle("Share Currency Info", for: .normal)
            shareCurrencyButton.isHidden=false
            removeAdButton.isEnabled = true
            removeAd.isEnabled = true
            removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)), for: .normal)
            selectedCurrenciesForSharing = ["Forex Rates"]
        }
        else{
            performSegue(withIdentifier: "homeToMore", sender: nil)
        }
        
    }
    
    
    
    @IBOutlet weak var moreButton: UIButton!
    @IBAction func moreButtonClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        if sharingEnabled{
            tableView.allowsMultipleSelection = false
            tableView.allowsMultipleSelectionDuringEditing = false
            sharingEnabled = false
            EditButton.isEnabled=true
            tableView.setEditing(false, animated: true)
            print(selectedCurrenciesForSharing)
            
            if !premiumSubscriptionPurchased{
                removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
                removeAd.setTitle("Remove Ads", for: .normal)
            }else{
                removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
                removeAd.setTitle("Support", for: .normal)
            }
            moreButton.setImage(UIImage(named: "More"), for: .normal)
            more.setTitle("More", for: .normal)
            
            shareCurrencyButton.isEnabled=true
            shareCurrencyText.isEnabled=true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                self.tableView.reloadData()
            })
            
            shareCurrencyText.setTitle("Share Currency Info", for: .normal)
            shareCurrencyButton.isHidden=false
            removeAdButton.isEnabled = true
            removeAd.isEnabled = true
            removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)), for: .normal)
            selectedCurrenciesForSharing = ["Forex Rates"]
        }
        else{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            self.navigationItem.backBarButtonItem = backItem
            performSegue(withIdentifier: "homeToMore", sender: nil)
        }
        
    }
    
  
    @IBOutlet weak var removeAdButton: UIButton!
  
    
    @IBOutlet weak var removeAd: UIButton!
   
    
    @IBAction func removeAdButtonClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        
            if sharingEnabled{
                var shareText = ""
                var text = ""
                for i in 1..<selectedCurrenciesForSharing.count{
                    let loadCurrencyValue = LoadCurrencyValues()
                    let (cValue,_) = loadCurrencyValue.loadCurrencyValue(self.baseCurrency.text!, selectedCurrenciesForSharing[i],storedValuesCurrent,storedValuesPrevious)
                    let cValueText = String(format: "%0.2f", cValue)
                    if baseCurrencyAmount.text != "" && baseCurrencyAmount.text != "."{
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        numberFormatter.maximumFractionDigits = 2
                        let value = numberFormatter.string(from: NSNumber(value: Double(cValue)*Double(baseCurrencyAmountGlobal)!))
                        text = "\(i)) Rate:\n     1 \(self.baseCurrency.text!) = \(cValueText) \(selectedCurrenciesForSharing[i])\n     Conversion:\n     \(baseCurrencyAmount.text!) \(self.baseCurrency.text!) = \(value!) \(selectedCurrenciesForSharing[i])\n\n"
                    shareText = shareText + text
                        
                    }else{
                        text = "\(i)) Rate:\n     1 \(self.baseCurrency.text!) = \(cValueText) \(selectedCurrenciesForSharing[i])\n\n"
                         shareText = shareText + text
                    }
                }
                shareText = selectedCurrenciesForSharing[0]+"\n\n"+shareText+"Last updated on \(lastUpdated)\n\n"+"By: LiveRates"
                
                let shareViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                shareViewController.popoverPresentationController?.sourceView = self.view
                self.present(shareViewController, animated: true, completion: nil)
                
                tableView.allowsMultipleSelection = false
                tableView.allowsMultipleSelectionDuringEditing = false
                sharingEnabled = false
                EditButton.isEnabled=true
                tableView.setEditing(false, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                    self.tableView.reloadData()
                })
                
                if !premiumSubscriptionPurchased{
                    removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
                    removeAd.setTitle("Remove Ads", for: .normal)
                }else{
                    removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
                    removeAd.setTitle("Support", for: .normal)
                }
                moreButton.setImage(UIImage(named: "More"), for: .normal)
                more.setTitle("More", for: .normal)
                
                shareCurrencyButton.isEnabled=true
                shareCurrencyText.isEnabled=true
              
                
                shareCurrencyText.setTitle("Share Currency Info", for: .normal)
                  shareCurrencyButton.isHidden=false
                removeAdButton.isEnabled = true
                removeAd.isEnabled = true
                removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)), for: .normal)
                selectedCurrenciesForSharing = ["Forex Rates"]
            }
            else{
                if !premiumSubscriptionPurchased{
                    let backItem = UIBarButtonItem()
                    backItem.title = "Live Rates"
                    backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    self.navigationItem.backBarButtonItem = backItem
                    performSegue(withIdentifier: "segueToSubscriptionVCFromHome", sender: nil)
                }else{
                    let backItem = UIBarButtonItem()
                    backItem.title = "Live Rates"
                    backItem.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                    self.navigationItem.backBarButtonItem = backItem
                    performSegue(withIdentifier: "segueToSupportVCFromHome", sender: nil)
                }
                
            }
        
    }
    
    
    @IBAction func removeAdClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        if sharingEnabled{
            var shareText = ""
            var text = ""
            for i in 1..<selectedCurrenciesForSharing.count{
                let loadCurrencyValue = LoadCurrencyValues()
                let (cValue,_) = loadCurrencyValue.loadCurrencyValue(self.baseCurrency.text!, selectedCurrenciesForSharing[i],storedValuesCurrent,storedValuesPrevious)
                let cValueText = String(format: "%0.2f", cValue)
                if baseCurrencyAmount.text != "" && baseCurrencyAmount.text != "."{
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.maximumFractionDigits = 2
                    let value = numberFormatter.string(from: NSNumber(value: Double(cValue)*Double(baseCurrencyAmountGlobal)!))
                    text = "\(i)) Rate:\n     1 \(self.baseCurrency.text!) = \(cValueText) \(selectedCurrenciesForSharing[i])\n     Conversion:\n     \(baseCurrencyAmount.text!) \(self.baseCurrency.text!)\n       =\n       \(value!) \(selectedCurrenciesForSharing[i])\n\n"
                    shareText = shareText + text
                    
                }else{
                    text = "\(i)) Rate:\n     1 \(self.baseCurrency.text!) = \(cValueText) \(selectedCurrenciesForSharing[i])\n\n"
                    shareText = shareText + text
                }
            }
            shareText = selectedCurrenciesForSharing[0]+"\n\n"+shareText+"Last updated on \(lastUpdated)\n\n"+"By: LiveRates"
            
            let shareViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            shareViewController.popoverPresentationController?.sourceView = self.view
            self.present(shareViewController, animated: true, completion: nil)
            
            tableView.allowsMultipleSelection = false
            tableView.allowsMultipleSelectionDuringEditing = false
            sharingEnabled = false
            EditButton.isEnabled=true
            tableView.setEditing(false, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                self.tableView.reloadData()
            })
            
            if !premiumSubscriptionPurchased{
                removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
                removeAd.setTitle("Remove Ads", for: .normal)
            }else{
                removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
                removeAd.setTitle("Support", for: .normal)
            }
            moreButton.setImage(UIImage(named: "More"), for: .normal)
            more.setTitle("More", for: .normal)
            
            
            shareCurrencyButton.isEnabled=true
            shareCurrencyText.isEnabled=true
            
            
            shareCurrencyText.setTitle("Share Currency Info", for: .normal)
            shareCurrencyButton.isHidden=false
            removeAdButton.isEnabled = true
            removeAd.isEnabled = true
            removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)), for: .normal)
            selectedCurrenciesForSharing = ["Forex Rates"]
        }
        else{
            if !premiumSubscriptionPurchased{
                let backItem = UIBarButtonItem()
                backItem.title = "Live Rates"
                backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                self.navigationItem.backBarButtonItem = backItem
                performSegue(withIdentifier: "segueToSubscriptionVCFromHome", sender: nil)
            }else{
                let backItem = UIBarButtonItem()
                backItem.title = "Live Rates"
                backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                self.navigationItem.backBarButtonItem = backItem
                performSegue(withIdentifier: "segueToSupportVCFromHome", sender: nil)
            }
            
        }
    }
    
    
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var baseCurrencyImageButton: UIButton!
    
    @IBAction func baseCurrencyImageButtonClicked(_ sender: Any) {
        self.selectBaseCurrency()
    }
    
    @IBAction func plusButton(_ sender: Any) {
        calledFrom = "plusButton"
        performPushSegue()
    }
    
    @IBOutlet weak var homeViewBanner: GADBannerView!
    var startAppHomeBanner: STABannerView?
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    
    @IBAction func EditButton(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        if tableView.isEditing{
            self.tableView.setEditing(false, animated: true)
            EditButton.style = UIBarButtonItem.Style.plain
            EditButton.title = "Reorder"
            EditButton.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                self.tableView.reloadData()
                })
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.45) {
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.tableView.separatorColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
//                })
//            }
           
            
        }else{
            if selectedCurrencies.count>2{
                self.tableView.setEditing(true, animated: true)
                
                EditButton.style = UIBarButtonItem.Style.done
                EditButton.title = "Done"
                
                EditButton.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                    self.tableView.reloadData()
                })
//                DispatchQueue.main.asyncAfter(deadline: .now()+0.45, execute: {
//                    UIView.animate(withDuration: 1.2, delay: 0, options: [.repeat,.autoreverse], animations: {
//                        self.tableView.separatorColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
//                    }, completion: nil)
//                })
            }
        }
    }
    
    @IBOutlet weak var baseCurrency: UITextField!
  
   
    
    @IBOutlet weak var baseCurrencyAmount: UITextField!
    
    
    
    
    
    
    let cellBackgroundView = UIView()
  
    var pullToRefresh = UIRefreshControl()
    
    var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
    var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelClicked))
    var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
    var refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(reloadTableData))
    var toolBar = UIToolbar()
    var emptyView = UIView()
    var decimalCount = 0
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        end = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            startFetchingAlreadyRunning=false
        }
        navigationController?.navigationBar.barStyle = .black
        if numberOfTimesLaunched > 5 && numberOfTimesLaunched%5 == 0 && !firstLaunch{
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
        print("Time Elapsed = \((end!.uptimeNanoseconds - start!.uptimeNanoseconds)/1_000_000_000)")
    
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
        if baseCurrencyAmount.isFirstResponder{
            tableView.isUserInteractionEnabled=false
        }else{
            tableView.isUserInteractionEnabled=true
        }
        
        
        if !premiumSubscriptionPurchased{
            removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
            removeAd.setTitle("Remove Ads", for: .normal)
        }else{
            removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
            removeAd.setTitle("Support", for: .normal)
            if homeViewBanner != nil{
                homeViewBanner.removeFromSuperview()
            }
        }
        
        firstLaunch = false
        
        
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return .lightContent
//    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1{
            let moreMessage = "Try LiveRates"
            let moreView = UIActivityViewController(activityItems: [moreMessage], applicationActivities: nil)
            moreView.popoverPresentationController?.sourceView = self.view
            self.present(moreView, animated: true, completion: nil)
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        premiumSubscriptionPurchased = UserDefaults.standard.bool(forKey: "premiumSubscriptionPurchased")
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = false
        sharingEnabled = false
        if inserted{
            if calledFrom == "addButton"{
                calledFrom=""
                tableView.reloadData()
                tableView.scrollToRow(at: IndexPath(row: selectedCurrencies.count-1, section: 0), at: .middle, animated: true)
                if !currencyAlreadyIsPresent{
                    UIView.animate(withDuration: 0.9, animations: {
                        self.tableView.cellForRow(at: IndexPath(row: selectedCurrencies.count-2, section: 0))?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            self.tableView.cellForRow(at: IndexPath(row: selectedCurrencies.count-2, section: 0))?.contentView.backgroundColor = UIColor.black
                        })
                        if selectedCurrencies.count == 2{
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                self.tableCellAnimation()
                            }
                        }
                    })
                    
                }else{
                    tableView.scrollToRow(at: IndexPath(row: alreadyPresentLocation, section: 0), at: .top, animated: true)
                    UIView.animate(withDuration: 0.9, animations: {
                        self.tableView.cellForRow(at: IndexPath(row: alreadyPresentLocation, section: 0))?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            self.tableView.cellForRow(at: IndexPath(row: alreadyPresentLocation, section: 0))?.contentView.backgroundColor = UIColor.black
                        })
                    })
                    currencyAlreadyIsPresent = false
                }
            }
            else if calledFrom == "plusButton"{
                calledFrom=""
                tableView.reloadData()
                tableView.scrollToRow(at: IndexPath(row: selectedCurrencies.startIndex, section: 0), at: .top, animated: true)
                if !currencyAlreadyIsPresent{
                    UIView.animate(withDuration: 0.9, animations: {
                        self.tableView.cellForRow(at: IndexPath(row: selectedCurrencies.startIndex, section: 0))?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            self.tableView.cellForRow(at: IndexPath(row: selectedCurrencies.startIndex, section: 0))?.contentView.backgroundColor = UIColor.black
                        })
                        if selectedCurrencies.count == 2{
                            DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                                self.tableCellAnimation()
                            }
                        }
                    })
                }else{
                    tableView.scrollToRow(at: IndexPath(row: alreadyPresentLocation, section: 0), at: .top, animated: true)
                    UIView.animate(withDuration: 0.9, animations: {
                        self.tableView.cellForRow(at: IndexPath(row: alreadyPresentLocation, section: 0))?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            self.tableView.cellForRow(at: IndexPath(row: alreadyPresentLocation, section: 0))?.contentView.backgroundColor = UIColor.black
                        })
                    })
                    currencyAlreadyIsPresent = false
                }
            }
            else if calledFrom == "currencyButton"{
                calledFrom=""
                tableView.reloadData()
                 tableView.scrollToRow(at: IndexPath(row: selectedArrayIndex, section: 0), at: .middle, animated: true)
                if !currencyAlreadyIsPresent{
                    UIView.animate(withDuration: 0.9, animations: {
                        self.tableView.cellForRow(at: IndexPath(row: selectedArrayIndex, section: 0))?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            self.tableView.cellForRow(at: IndexPath(row: selectedArrayIndex, section: 0))?.contentView.backgroundColor = UIColor.black
                        })
                    })
                }else{
                    tableView.scrollToRow(at: IndexPath(row: alreadyPresentLocation, section: 0), at: .top, animated: true)
                    UIView.animate(withDuration: 0.9, animations: {
                        self.tableView.cellForRow(at: IndexPath(row: alreadyPresentLocation, section: 0))?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            self.tableView.cellForRow(at: IndexPath(row: alreadyPresentLocation, section: 0))?.contentView.backgroundColor = UIColor.black
                        })
                    })
                    currencyAlreadyIsPresent = false
                }
            }
            else if calledFrom == "baseCurrency"{
                calledFrom=""
                if !currencyAlreadyIsPresent{
                    
                    baseCurrency.text = baseCurrencyName.currName
                    baseCurrencyImageButton.setImage(UIImage(data:baseCurrencyName.image), for: .normal)
                    
                    self.navigationController?.hidesBarsWhenKeyboardAppears = false
                    tableView.reloadData()
                    UIView.animate(withDuration: 0.9, animations: {
                        self.baseCurrency.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            self.baseCurrency.backgroundColor = UIColor.black
                        })
                    })
                }else{
                    
                    tableView.reloadData()
                    UIView.animate(withDuration: 0.9, animations: {
                        self.baseCurrency.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            self.baseCurrency.backgroundColor = UIColor.black
                        })
                    })
                    currencyAlreadyIsPresent = false
                }
            }
            inserted=false
        }

       
        EditButton.isEnabled=true
        if !premiumSubscriptionPurchased{
            removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
            removeAd.setTitle("Remove Ads", for: .normal)
        }else{
            removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
            removeAd.setTitle("Support", for: .normal)
            if homeViewBanner != nil{
                homeViewBanner.removeFromSuperview()
            }
        }
        moreButton.setImage(UIImage(named: "More"), for: .normal)
        more.setTitle("More", for: .normal)
        shareCurrencyButton.isEnabled=true
        shareCurrencyText.isEnabled=true
        if selectedCurrencies.count-1 == 0{
            shareCurrencyText.isHidden=true
            shareCurrencyButton.isHidden=true
        }else{
            shareCurrencyText.setTitle("Share Currency Info", for: .normal)
            shareCurrencyText.isHidden=false
            shareCurrencyButton.isHidden=false
        }
        removeAdButton.isEnabled = true
        removeAd.isEnabled = true
        removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)), for: .normal)
        selectedCurrenciesForSharing = ["Forex Rates"]
        if selectedCurrencies.count>2{
            self.EditButton.isEnabled=true
            self.EditButton.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        }else{
            self.EditButton.isEnabled=false
            self.EditButton.tintColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
        }
        super.viewWillAppear(true)
    }
    
    
    
    @IBAction func clearButtonClicked(_ sender: Any) {
        baseCurrencyAmount.text = ""
        reloadTableData()
    }
    
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .black
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = #colorLiteral(red: 0.0700000003, green: 0.0700000003, blue: 0.0700000003, alpha: 1)
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        firstLaunch=true
        tableAnimationDone = false
        clearButton.isHidden=true
        
        self.pullToRefresh.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
       // self.pullToRefresh.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        baseCurrencyAmount.addTarget(self, action: #selector(reloadTableData), for: [.touchDown,.editingChanged])
        baseCurrency.addTarget(self, action: #selector(selectBaseCurrency), for: .touchDown)
       
        
        self.splitViewController?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.baseCurrencyAmount.delegate = self

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        baseCurrency.delegate = self
        baseCurrency.inputView = emptyView
        doneButton.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        toolBar.setItems([cancelButton,flexibleSpace,doneButton], animated: true)
        toolBar.sizeToFit()
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = #colorLiteral(red: 0.9039215803, green: 0.9039215803, blue: 0.9039215803, alpha: 1)
        
        let locale = Locale.current
        localCurrencyCode = "USD"
        localCurrencyCode = locale.currencyCode!
        print(localCurrencyCode)
        
        fetchBaseCurrency()
        baseCurrency.text = baseCurrencyName.currName
        baseCurrencyImageButton.setImage(UIImage(data:baseCurrencyName.image), for: .normal)
        fetchFavCurrencies()

        baseCurrency.layer.cornerRadius = baseCurrency.frame.size.height/2
        baseCurrency.layer.masksToBounds = true
        baseCurrencyAmount.layer.cornerRadius = baseCurrencyAmount.frame.size.height/2
        baseCurrencyAmount.layer.masksToBounds = true
        baseCurrencyAmount.inputAccessoryView = toolBar
        pullToRefresh.attributedTitle = NSAttributedString(string: "Last updated: " + lastUpdated,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        pullToRefresh.addTarget(self, action: #selector(refreshRates), for: .valueChanged)
        self.tableView.backgroundView = pullToRefresh
        cellBackgroundView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        if selectedCurrencies.count-1 == 0{
            shareCurrencyText.isHidden=true
            shareCurrencyButton.isHidden=true
        }else{
            shareCurrencyText.isHidden=false
            shareCurrencyButton.isHidden=false
        }
        if premiumSubscriptionPurchased{
            removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
            removeAd.setTitle("Support", for: .normal)
        }
        
        if (!premiumSubscriptionPurchased) && (numberOfTimesLaunched == 0)  && (!introAlreadyCalled){
            calledFrom = "intro"
            let backItem = UIBarButtonItem()
            backItem.title = "Live Rates"
            backItem.tintColor = #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1)
            backItem.isEnabled=false
            self.navigationItem.backBarButtonItem = backItem
            performSegue(withIdentifier: "segueToSubscriptionVCFromHome", sender: nil)
        }
        else if (!premiumSubscriptionPurchased) && (numberOfTimesLaunched%10 == 0)  && (!introAlreadyCalled){
            calledFrom = "intro"
            let backItem = UIBarButtonItem()
            backItem.title = "Live Rates"
            backItem.tintColor = #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1)
            backItem.isEnabled=false
            self.navigationItem.backBarButtonItem = backItem
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.performSegue(withIdentifier: "segueToSubscriptionVCFromHome", sender: nil)
            }
        }
        else{
          adManagement()
        }
        
        if !premiumSubscriptionPurchased{
            homeViewBanner.adUnitID = "ca-app-pub-4235447962727236/2214450902"
            homeViewBanner.rootViewController = self
            homeViewBanner.load(GADRequest())
            homeViewBanner.adSize = kGADAdSizeSmartBannerLandscape
            homeViewBanner.delegate=self
        }
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    
    func adManagement(){
       
        DispatchQueue.main.asyncAfter(deadline: .now()+20, execute: {
        if !premiumSubscriptionPurchased && numberOfTimesLaunched > 1 {
            
            
                if homeViewInterstitial.isReady {
                    firstLaunch = true
                    homeViewInterstitial.delegate = self
                    homeViewInterstitial.present(fromRootViewController: self)
                } else {
                    firstLaunch = true
                    startAppHomeInterstitialPresented=true
                    print("Ad wasn't ready, Hence StartApp Ad will be presented")
                    if startAppAdHomeInterstitial!.isReady(){
                        self.tableCellAnimation()
                        DispatchQueue.main.asyncAfter(wallDeadline: .now()+3, execute: {
                            startAppAdHomeInterstitial!.show()
                        })
                    }else{
                        print("StartApp Ad not yet ready, Hence creating delay")
                        self.tableCellAnimation()
                        DispatchQueue.main.asyncAfter(wallDeadline: .now()+9, execute: {
                            startAppAdHomeInterstitial!.show()
                        })
                    }
                }
            
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self.tableCellAnimation()
            }
        }
        
        })
        
    }
    
    
    @objc func didEnterBackground(){
        baseCurrencyAmountGlobal = ""
        calledFromBackground = true
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            let array = Array(textField.text!)
            decimalCount = 0
            for character in array {
                if character == "." {
                    decimalCount+=1
                }
            }
            if decimalCount == 1 {
                vibrateTextBox(textField)
                return false
            } else {
                return true
            }
        default:
            let array = Array(string)
            if array.count == 0 {
                return true
            }
            return false
        }
        
        
    }
    
    @objc func refreshRates(){
        let networkStatus = CheckNetwork()
        if (networkStatus.connectedToNetwork()){
        pullToRefresh.attributedTitle = NSAttributedString(string: "")
        print("Refreshing")
                let loadValues = FetchValues()
                loadValues.fetchJasonOfToday(completion: { (success) in
                    if (success){
                        self.tableView.reloadData()
                        
                        self.pullToRefresh.endRefreshing()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            self.pullToRefresh.attributedTitle = NSAttributedString(string: "Last updated: " + lastUpdated,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                            if numberOfTimesLaunched > 2{
                                AppStoreReviewManager.requestReviewIfAppropriate()
                            }
                        }
                    }
                })
        }
        else{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Network Error", message: "Please check your internet conncetion and try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        self.pullToRefresh.endRefreshing()
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                    @unknown default:
                        print("Unknow error")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
  
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) {
            return false
        }
        else{
            return true
        }
    }
    
    @objc func selectBaseCurrency(){
        calledFrom="baseCurrency"
        baseCurrency.resignFirstResponder()
        self.performPushSegue()
    }
    @objc func doneClicked(){
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        clearButton.isHidden=true
        baseCurrencyAmount.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
             self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
       
        self.tableView.isUserInteractionEnabled=true
        if numberOfTimesLaunched > 2{
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
    }
    @objc func cancelClicked(){
//        let hapticFeedback = UIImpactFeedbackGenerator()
//        hapticFeedback.impactOccurred()
        clearButton.isHidden=true
        baseCurrencyAmount.text = ""
        reloadTableData()
        
        print("Cancel Clicked")
        baseCurrencyAmount.resignFirstResponder()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.isUserInteractionEnabled=true
    }
    @objc func reloadTableData(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if baseCurrencyAmount.text != ""{
            clearButton.isHidden=false
            //padding behind cancel button
            let rightView = UIView(frame: CGRect(x: 0.0, y: baseCurrencyAmount.frame.maxY, width: 18.0, height: 2.0))
            baseCurrencyAmount.rightView = rightView
            baseCurrencyAmount.rightViewMode = .always
        }else{
            clearButton.isHidden=true
            //remove padding behind cancel button
            let rightView = UIView(frame: CGRect(x: 0.0, y: baseCurrencyAmount.frame.maxY, width: 0.0, height: 2.0))
            baseCurrencyAmount.rightView = rightView
            baseCurrencyAmount.rightViewMode = .always
        }
        if self.tableView.isEditing{
            
           
            DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
               // UIView.animate(withDuration: 0.5, animations: {
                    self.tableView.setEditing(false, animated: true)
                    self.tableView.separatorColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                //})
            }
            
            selectedCurrenciesForSharing = ["Forex Rates"]
            
            EditButton.title = "Reorder"
            EditButton.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            
            tableView.allowsMultipleSelection = false
            tableView.allowsMultipleSelectionDuringEditing = false
            sharingEnabled = false
            EditButton.isEnabled=true
            if !premiumSubscriptionPurchased{
                removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
                removeAd.setTitle("Remove Ads", for: .normal)
            }else{
                removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
                removeAd.setTitle("Support", for: .normal)
            }
            moreButton.setImage(UIImage(named: "More"), for: .normal)
            more.setTitle("More", for: .normal)
            
            shareCurrencyButton.isEnabled=true
            shareCurrencyText.isEnabled=true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.55, execute: {
                self.tableView.reloadData()
            })
            
            if selectedCurrencies.count-1 == 0{
                shareCurrencyText.isHidden=true
                shareCurrencyButton.isHidden=true
            }else{
                shareCurrencyText.setTitle("Share Currency Info", for: .normal)
                shareCurrencyText.isHidden=false
                shareCurrencyButton.isHidden=false
            }
            removeAdButton.isEnabled = true
            removeAd.isEnabled = true
            removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)), for: .normal)
            
        
        }
        
        self.tableView.isUserInteractionEnabled=false
        let array = Array(baseCurrencyAmount.text!)
        var count = 0
        for character in array {
            if character == "." {
                count += 1
            }
        }
        if count > 0{
            containsDecimal = true
        }else{
            containsDecimal = false
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = true
        
        if baseCurrencyAmount.text! != ""{
            baseCurrencyAmountGlobal = baseCurrencyAmount.text!.replacingOccurrences(of: ",", with: "")
            if !containsDecimal{
                self.baseCurrencyAmount.text! = formatter.string(from: NSNumber(value:  Double(baseCurrencyAmountGlobal)!))!
            }
            tableView.reloadData()
        }else{
          baseCurrencyAmountGlobal = ""
          tableView.reloadData()
        }
    }
}

extension CurrencyTable: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return selectedCurrencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CurrencyCell
        cell?.selectedBackgroundView = cellBackgroundView
        cell?.cellDelegate = self
        cell?.index = indexPath
        cell?.doneButton.isHidden=true
        cell?.currencyButton.setImage(UIImage(named: "add.png"), for: .normal)
        cell?.currencyAttributesStackView.isHidden=true
        cell?.percentValue.setTitle("--", for: .normal)
        cell?.convertedValue.text = selectedCurrencies[indexPath.row].symbol
        cell?.currencyLabel.text = selectedCurrencies[indexPath.row].currName
        cell?.currencyButton.setImage(UIImage(data: selectedCurrencies[indexPath.row].image), for: .normal)
        cell?.currencyLabel.isHidden = false
        cell?.currencyAttributesStackView.isHidden=false
        cell?.currencyButton.isHidden=false
        cell?.addButton.isHidden=true
        cell?.calculateValue(baseCurrencyName.currName, selectedCurrencies[indexPath.row].currName)
        cell?.currencyFullForm.text  = selectedCurrencies[indexPath.row].fullForm
        if cell?.currencyLabel.text == "Select"{
            cell?.currencyLabel.isHidden = true
            cell?.currencyAttributesStackView.isHidden=true
            cell?.currencyButton.isHidden=true
            cell?.addButton.isHidden=false
        }
        if baseCurrencyAmount.text != "" && baseCurrencyAmount.text != "."{
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            let loadCurrencyValue = LoadCurrencyValues()
             let (cValue,_) = loadCurrencyValue.loadCurrencyValue(self.baseCurrency.text!, selectedCurrencies[indexPath.row].currName,storedValuesCurrent,storedValuesPrevious)
            let value = numberFormatter.string(from: NSNumber(value: Double(cValue)*Double(baseCurrencyAmountGlobal)!))
            cell?.convertedValue.text = selectedCurrencies[indexPath.row].symbol + " " + value!
        }
        if selectedCurrencies.count == 1{
            cell?.hint.isHidden=false
            cell?.addButton.setImage(UIImage(named: "add.png"), for: .normal)
        }
        else{
            cell?.addButton.setImage(UIImage(named: ""), for: .normal)
            cell?.hint.isHidden=true
        }
        //print(UIDevice.modelName)
        if tableView.isEditing && (UIDevice.modelName == "iPhone 5" || UIDevice.modelName == "iPhone 5c" || UIDevice.modelName == "iPhone 5s" || UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "iPhone 4" || UIDevice.modelName == "iPhone 4s" || UIDevice.modelName == "iPod Touch 5" || UIDevice.modelName == "iPod Touch 6" || UIDevice.modelName == "Simulator iPhone 5" || UIDevice.modelName == "Simulator iPhone 5c" || UIDevice.modelName == "Simulator iPhone 5s" || UIDevice.modelName == "Simulator iPhone SE" || UIDevice.modelName == "Simulator iPhone 4" || UIDevice.modelName == "Simulator iPhone 4s" || UIDevice.modelName == "Simulator iPod Touch 5" || UIDevice.modelName == "Simulator iPod Touch 6")
        {
            cell?.currentValueHeading.isHidden = true
            cell?.changeHeading.isHidden=true
            cell?.currencyAttributesStackWidth.constant = 65
            cell?.conversionStack.isHidden=true
            cell?.currencyFullForm.isHidden=true
            
        }else{
            cell?.currentValueHeading.isHidden = false
            cell?.changeHeading.isHidden=false
            cell?.currencyAttributesStackWidth.constant = 170
            cell?.conversionStack.isHidden=false
            cell?.currencyFullForm.isHidden=false
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            print("Action tapped")
        }
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        let swap = UITableViewRowAction(style: .normal, title: "Swap") { (_, _) in
            print("Action tapped")
        }
        swap.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        let share = UITableViewRowAction(style: .normal, title: "Share") { (_, _) in
            print("Action tapped")
        }
        share.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        return [delete, swap, share]
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Remove", handler: {(action,view,nil) in
            UIView.animate(withDuration: 0.5, animations: {
                tableView.separatorColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            })
            selectedCurrencies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            storeFavCurrencies()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { // to reload the table after the completion of animation
                tableView.reloadData()
                if selectedCurrencies.count-1 == 0{
                    self.shareCurrencyText.isHidden=true
                    self.shareCurrencyButton.isHidden=true
                }else{
                    self.shareCurrencyText.isHidden=false
                    self.shareCurrencyButton.isHidden=false
                }
                if selectedCurrencies.count>2{
                    self.EditButton.isEnabled=true
                    self.EditButton.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                }else{
                    self.EditButton.isEnabled=false
                    self.EditButton.tintColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
                }

            }
            let hapticFeedback = UIImpactFeedbackGenerator()
            hapticFeedback.impactOccurred()
            
        })
        delete.backgroundColor=#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        delete.image = #imageLiteral(resourceName: "DeleteIcon")
        
        
//        delete.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 30)).image { _ in
//            UIImage(named: "DeleteIcon")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 30))
//        }
        
        let swap = UIContextualAction(style: .normal, title: "Swap"){(action,view,nil) in
            tableView.setEditing(false, animated: true)
            print("Swap Button Clicked")
            let alert = UIAlertController(title: "Swap with base currency", message: "Do you want to swap the Quote Currency: \(selectedCurrencies[indexPath.row].currName) with Base Currency: \(self.baseCurrency.text!)?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                print("default")
                
                let temp = self.baseCurrency.text
                
                
                self.baseCurrency.text = selectedCurrencies[indexPath.row].currName
                baseCurrencyName.currName = selectedCurrencies[indexPath.row].currName
                baseCurrencyName.symbol = currencies[currencies.firstIndex(where: {$0.currency == selectedCurrencies[indexPath.row].currName})!].symbol
                baseCurrencyName.fullForm = currencies[currencies.firstIndex(where: {$0.currency == selectedCurrencies[indexPath.row].currName})!].name
                baseCurrencyName.image = currencies[currencies.firstIndex(where: {$0.currency == selectedCurrencies[indexPath.row].currName})!].image!.pngData()!
                self.baseCurrencyImageButton.setImage(UIImage(data:baseCurrencyName.image), for: .normal)
                
                
                selectedCurrencies[indexPath.row].currName = temp!
                selectedCurrencies[indexPath.row].fullForm = currencies[currencies.firstIndex(where: {$0.currency == temp!})!].name
                selectedCurrencies[indexPath.row].symbol = currencies[currencies.firstIndex(where: {$0.currency == temp!})!].symbol
                selectedCurrencies[indexPath.row].image = (currencies[currencies.firstIndex(where: {$0.currency == temp!})!].image?.pngData()!)!
                
                storeBaseCurrency()
                storeFavCurrencies()
                
                tableView.reloadData()
                let hapticFeedback = UINotificationFeedbackGenerator()
                hapticFeedback.notificationOccurred(.success)
                UIView.animate(withDuration: 0.5, animations: {
                    self.baseCurrency.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                })
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.baseCurrency.backgroundColor = UIColor.black
                    })
                })
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                })
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.black
                    })
                })
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    var duplicate = false
                    var atRow = 0
                    for i in 0..<indexPath.row{
                        if selectedCurrencies[indexPath.row].currName == selectedCurrencies[i].currName{
                            duplicate = true
                            atRow = i
                            
                            break
                        }
                    }
                    for i in indexPath.row+1...selectedCurrencies.count-1{
                        if selectedCurrencies[indexPath.row].currName == selectedCurrencies[i].currName{
                            duplicate = true
                            atRow = i
                            break
                        }
                    }
                    if duplicate{
                        print("Found at \(atRow)")
                        selectedCurrencies.remove(at: atRow)
                        print("Row Deleted")
                        print(selectedCurrencies)
                        tableView.deleteRows(at: [IndexPath(row: atRow, section: 0)], with: .automatic)
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                            tableView.reloadData()
                            storeFavCurrencies()
                            if selectedCurrencies.count-1 == 0{
                                self.shareCurrencyText.isHidden=true
                                self.shareCurrencyButton.isHidden=true
                            }else{
                                self.shareCurrencyText.isHidden=false
                                self.shareCurrencyButton.isHidden=false
                            }
                            if selectedCurrencies.count>2{
                                self.EditButton.isEnabled=true
                                self.EditButton.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                            }else{
                                self.EditButton.isEnabled=false
                                self.EditButton.tintColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
                            }

                        })
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                tableView.setEditing(false, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        swap.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
       // swap.image = #imageLiteral(resourceName: "SwapIcon")
        swap.image = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 35)).image{ _ in
            UIImage(named: "SwapIcon")?.draw(in: CGRect(x: 0, y: 0, width: 32, height: 35))
        }

        
        
        
        
        let share = UIContextualAction(style: .normal, title: "Share", handler: {(action,view,nil) in
            tableView.setEditing(false, animated: true)
            let hapticFeedback = UIImpactFeedbackGenerator()
            hapticFeedback.impactOccurred()
            var currencyInfo = ""
            var currencyInfoText = ""
            let loadCurrencyValue = LoadCurrencyValues()
            let (cValue,_) = loadCurrencyValue.loadCurrencyValue(self.baseCurrency.text!, selectedCurrencies[indexPath.row].currName,storedValuesCurrent,storedValuesPrevious)
            
           
            let cValueText = String(format: "%0.2f", cValue)
            if self.baseCurrencyAmount.text != "" && self.baseCurrencyAmount.text != "."{
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.maximumFractionDigits = 2
                let value = numberFormatter.string(from: NSNumber(value: Double(cValue)*Double(baseCurrencyAmountGlobal)!))
                currencyInfo = "\(1)) Rate:\n     1 \(self.baseCurrency.text!) = \(cValueText) \(selectedCurrencies[indexPath.row].currName)\n     Conversion:\n     \(self.baseCurrencyAmount.text!) \(self.baseCurrency.text!) = \(value!) \(selectedCurrencies[indexPath.row].currName)\n\n"
                currencyInfoText = "Forex Rates"+"\n\n"+currencyInfo+"Last updated on \(lastUpdated)\n\n"+"By: LiveRates"
            }
            else{
                currencyInfo = "\(1)) Rate:\n     1 \(self.baseCurrency.text!) = \(cValueText) \(selectedCurrencies[indexPath.row].currName)\n\n"
                currencyInfoText = "Forex Rates"+"\n\n"+currencyInfo+"Last updated on \(lastUpdated)\n\n"+"By: LiveRates"
            }
            
            let activityVC = UIActivityViewController(activityItems: [currencyInfoText], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        })
        share.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        share.image = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { _ in
            UIImage(named: "Share")?.draw(in: CGRect(x: 0, y: 0, width: 32, height: 32))
        }
        
        let swipeActionsSet1 = UISwipeActionsConfiguration(actions: [delete,swap,share])
        swipeActionsSet1.performsFirstActionWithFullSwipe = false
        return swipeActionsSet1
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if selectedCurrencies.count-1 == indexPath.row{
            return false
        }
        else if selectedCurrencies[0].currName == "Select"{
            return false
        }
        else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if sharingEnabled{
            return UITableViewCell.EditingStyle(rawValue: 3)!
        }else{
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let item = selectedCurrencies[sourceIndexPath.row]
            selectedCurrencies.remove(at: sourceIndexPath.row)
            selectedCurrencies.insert(item, at: destinationIndexPath.row)
            storeFavCurrencies()
            print(selectedCurrencies)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if selectedCurrencies[proposedDestinationIndexPath.row].currName == "Select"{
            return sourceIndexPath
        }else{
            return proposedDestinationIndexPath
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if selectedCurrencies.count-1 == indexPath.row{
            return false
        }
        else{
            return true
        }
    }

    // Prevent last row from being selected
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if selectedCurrencies.count-1 == indexPath.row{
            return false
        }
        else if selectedCurrencies[0].currName == "Select"{
            return false
        }
        else{
            return true
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sharingEnabled{
            selectedCurrenciesForSharing.append(selectedCurrencies[indexPath.row].currName)
          
            print("\n\(selectedCurrenciesForSharing)")
            if selectedCurrenciesForSharing.count <= 1{
                removeAdButton.isEnabled = false
                removeAd.isEnabled = false
                removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 0.531044662, green: 0.3263615966, blue: 0.03531886265, alpha: 1)), for: .normal)
            }else{
                removeAdButton.isEnabled = true
                removeAd.isEnabled = true
                removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)), for: .normal)
            }
            
        }else{
            calledFrom = "tableCell"
            performShowDetailSegue(index: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if sharingEnabled{
        
                    selectedCurrenciesForSharing.remove(at: selectedCurrenciesForSharing.firstIndex(where: {$0 == selectedCurrencies[indexPath.row].currName})!)
            print(selectedCurrenciesForSharing)
            if selectedCurrenciesForSharing.count <= 1{
                removeAdButton.isEnabled = false
                removeAd.isEnabled = false
                removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 0.531044662, green: 0.3263615966, blue: 0.03531886265, alpha: 1)), for: .normal)
            }else{
                removeAdButton.isEnabled = true
                removeAd.isEnabled = true
                removeAd.setTitleColor(UIColor(cgColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)), for: .normal)
            }
    
        }
    }
    
    

     
}

extension CurrencyTable: TableCellProtocol, MFMailComposeViewControllerDelegate{
    func insertNewRow(index: Int) {
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
    }

    func performPushSegue(){
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        self.tableView.setEditing(false, animated: false)
        selectedCurrenciesForSharing = ["Forex Rates"]
        sharingEnabled=false
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            backItem.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
            self.navigationItem.backBarButtonItem = backItem
            performSegue(withIdentifier: "ShowSearchViewController", sender: nil)
        
    }
    
    func performShowDetailSegue(index: Int){
        if !sharingEnabled{
            let hapticFeedback = UIImpactFeedbackGenerator()
            hapticFeedback.impactOccurred()
            let backItem = UIBarButtonItem()
            backItem.title = "Live Rates"
            backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            self.navigationItem.backBarButtonItem = backItem
            historyArray[0] = baseCurrency.text!
            historyArray[1] = selectedCurrencies[index].currName
            performSegue(withIdentifier: "ShowDetailHistoryViewController", sender: nil)
        }
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    
    func vibrateTextBox(_ viewToShake: UITextField){
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.error)
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        viewToShake.layer.add(animation, forKey: "position")
    }
    
    func tableCellAnimation(){
        if !tableAnimationDone{
            if selectedCurrencies.count>1{
                let config = TableViewCellOnboarding.Config(initialDelay: 1, duration: 1.5, halfwayDelay: 0.2)
                onboardingCell = TableViewCellOnboarding(with: tableView, config: config)
                onboardingCell?.editActions = tableView(tableView, editActionsForRowAt: IndexPath(row: 0, section: 0))
                tableAnimationDone=true
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
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        if !premiumSubscriptionPurchased{
            if startAppHomeBanner == nil{
                startAppHomeBanner = STABannerView(size: STA_AutoAdSize,
                                                   autoOrigin: STAAdOrigin_Bottom,
                                                   withDelegate: nil);
                self.homeViewBanner.addSubview(startAppHomeBanner!)
            }
        }
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        if tableView.isEditing{
            self.tableView.setEditing(false, animated: true)
        }
        if startAppHomeBanner != nil{
         self.startAppHomeBanner!.removeFromSuperview()
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
    
    
    // delegate methods for interstitial ads
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
        admobHomeInterstitialAlreadyLoaded=false
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        tableView.setEditing(false, animated: true)
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
                tableCellAnimation()
                if !premiumSubscriptionPurchased{
                    admobHomeInterstitialAlreadyLoaded=true
                    homeViewInterstitial = createAndLoadInterstitial("ca-app-pub-4235447962727236/4167850341")
                }
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
}


func storeFavCurrencies(){
    let dataToBeStored = try? PropertyListEncoder().encode(selectedCurrencies)
    UserDefaults.standard.set(dataToBeStored, forKey: "favoriteCurrencies")
}

func fetchFavCurrencies(){
    if let dataFetched = UserDefaults.standard.data(forKey: "favoriteCurrencies"){
        selectedCurrencies = try! PropertyListDecoder().decode([favoriteCurrencies].self, from: dataFetched)
    }else{
       selectedCurrencies = [favoriteCurrencies(currName: "Select", fullForm: "Select", symbol: "$", image: UIImage(named: "add.png")!.pngData()!)]
    }
    
}

func storeBaseCurrency(){
    let dataToBeStored = try? PropertyListEncoder().encode(baseCurrencyName)
    UserDefaults.standard.set(dataToBeStored, forKey: "favoriteBaseCurrency")
}

func fetchBaseCurrency(){
    if let dataFetched = UserDefaults.standard.data(forKey: "favoriteBaseCurrency"){
        baseCurrencyName = try! PropertyListDecoder().decode(favoriteCurrencies.self, from: dataFetched)
    }else{
        baseCurrencyName.currName = localCurrencyCode
        baseCurrencyName.symbol = currencies[currencies.firstIndex(where: {$0.currency == localCurrencyCode})!].symbol
        baseCurrencyName.fullForm = currencies[currencies.firstIndex(where: {$0.currency == localCurrencyCode})!].name
        baseCurrencyName.image = currencies[currencies.firstIndex(where: {$0.currency == localCurrencyCode})!].image!.pngData()!
        storeBaseCurrency()
    }
}




