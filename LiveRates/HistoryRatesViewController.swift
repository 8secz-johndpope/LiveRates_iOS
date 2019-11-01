//
//  HistoryRatesViewController.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 17/6/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HistoryRatesViewController: UIViewController, UITextFieldDelegate, GADBannerViewDelegate,GADInterstitialDelegate,STADelegateProtocol{
    
    var sharingEnabledInHistoryView = false
    
    @IBOutlet weak var conversionViewBanner: GADBannerView!
    var startAppConversionViewBanner: STABannerView?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBaseCurrency: UITextField!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBAction func baseCurrencyButtonClicked(_ sender: Any) {
        selectBaseCurrency()
    }
    @IBAction func swapButtonClicked(_ sender: Any) {
        swap()
    }
    
    @IBAction func swapClicked(_ sender: Any) {
        swap()
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var baseAmountToConvert_Current: UITextField!
    @IBOutlet weak var baseAmountToConvert_Previous: UITextField!
    @IBOutlet weak var targetAmountConverted_Current: UITextField!
    @IBOutlet weak var targetAmountConverted_Previous: UITextField!
    @IBAction func targetCurrencyButtonClicked(_ sender: Any) {
       selectTargetCurrency()
    }
    @IBOutlet weak var targetCurrency: UITextField!
    @IBOutlet weak var targetCurrencyButton: UIButton!
    
    
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var recommend: UIButton!
    
    @IBAction func recommendButtonClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        if  sharingEnabledInHistoryView{
            sharingEnabledInHistoryView = false
            if !premiumSubscriptionPurchased{
                removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
                removeAd.setTitle("Remove Ads", for: .normal)
            }else{
                removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
                removeAd.setTitle("Support", for: .normal)
            }
            recommendButton.setImage(UIImage(named: "Recommend"), for: .normal)
            recommend.setTitle("Recommend", for: .normal)
            shareCurrencyButton.isEnabled=true
            shareCurrency.isEnabled=true
            shareCurrency.setTitle("Share Currency Info", for: .normal)
            shareCurrencyButton.isHidden=false
        }
        else{
            recommendApp()
        }
    }
    
    @IBAction func recommendClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        if  sharingEnabledInHistoryView{
            sharingEnabledInHistoryView = false
            if !premiumSubscriptionPurchased{
                removeAdButton.setImage(UIImage(named: "Cart"), for: .normal)
                removeAd.setTitle("Remove Ads", for: .normal)
            }else{
                removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
                removeAd.setTitle("Support", for: .normal)
            }
            recommendButton.setImage(UIImage(named: "Recommend"), for: .normal)
            recommend.setTitle("Recommend", for: .normal)
            shareCurrencyButton.isEnabled=true
            shareCurrency.isEnabled=true
            shareCurrency.setTitle("Share Currency Info", for: .normal)
            shareCurrencyButton.isHidden=false
        }
        else{
            recommendApp()
        }
    }
    
    @IBOutlet weak var textView1: UIView!
    @IBOutlet weak var textView2: UIView!
    
    
    @IBOutlet weak var shareCurrency: UIButton!
    
    @IBOutlet weak var shareCurrencyButton: UIButton!
    @IBAction func shareCurrencyButtonClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        let currentValueText = String(format: "%0.4f", Float(currentValueNumeric))
        let text1 = "Current Data:\n\n     Rate:\n     1 \(historyArray[0]) = \(currentValueText) \(historyArray[1])\n     Conversion:\n     \(baseAmountToConvert_Current.text!) \(historyArray[0]) = \(targetAmountConverted_Current.text!) \(historyArray[1])\n\n"
        
        let previousValueText = String(format: "%0.4f", Float(previousValueNumeric))
        let text2 = "Historical Data:\n(Date: \(previousTimeStamp.text!))\n\n     Rate:\n     1 \(historyArray[0]) = \(previousValueText) \(historyArray[1])\n     Conversion:\n     \(baseAmountToConvert_Previous.text!) \(historyArray[0]) = \(targetAmountConverted_Previous.text!) \(historyArray[1])\n"
        
        let shareText = "Forex Rates"+"\n\n"+text1+text2+"\nBy: LiveRates"
        let shareViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = self.view
        self.present(shareViewController, animated: true, completion: nil)
   
    }
    
    @IBAction func shareCurrencyClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        let currentValueText = String(format: "%0.4f", Float(currentValueNumeric))
        let text1 = "Current Data:\n\n     Rate:\n     1 \(historyArray[0]) = \(currentValueText) \(historyArray[1])\n     Conversion:\n     \(baseAmountToConvert_Current.text!) \(historyArray[0]) = \(targetAmountConverted_Current.text!) \(historyArray[1])\n\n"
        
        let previousValueText = String(format: "%0.4f", Float(previousValueNumeric))
        let text2 = "Historical Data:\n(Date: \(previousTimeStamp.text!))\n\n     Rate:\n     1 \(historyArray[0]) = \(previousValueText) \(historyArray[1])\n     Conversion:\n     \(baseAmountToConvert_Previous.text!) \(historyArray[0]) = \(targetAmountConverted_Previous.text!) \(historyArray[1])\n"
        
        let shareText = "Forex Rates"+"\n\n"+text1+text2+"\nBy: LiveRates"
        let shareViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = self.view
        self.present(shareViewController, animated: true, completion: nil)

    }
    
    @IBOutlet weak var removeAdButton: UIButton!
    
    @IBOutlet weak var removeAd: UIButton!
    @IBAction func removeAdButtonClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
            if !premiumSubscriptionPurchased{
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                self.navigationItem.backBarButtonItem = backItem
                performSegue(withIdentifier: "segueToSubscriptionVCFromConversionView", sender: nil)
            }else{
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                self.navigationItem.backBarButtonItem = backItem
                performSegue(withIdentifier: "segueToSupportVCFromConversionView", sender: nil)
            }
        
        
    }
    
    
    @IBAction func removeAdClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()

            if !premiumSubscriptionPurchased{
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                self.navigationItem.backBarButtonItem = backItem
                performSegue(withIdentifier: "segueToSubscriptionVCFromConversionView", sender: nil)
            }else{
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                self.navigationItem.backBarButtonItem = backItem
                 performSegue(withIdentifier: "segueToSupportVCFromConversionView", sender: nil)
            }
        
    }
    
    
    
    
    @IBOutlet weak var changeDateButton: UITextField!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var previousValue: UILabel!
    @IBOutlet weak var currentTimeStamp: UILabel!
    @IBOutlet weak var previousTimeStamp: UILabel!
    @IBOutlet weak var ai1: UIActivityIndicatorView!
    @IBOutlet weak var ai3: UIActivityIndicatorView!
    
    var myDatePicker = UIDatePicker()
    
    var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
    var doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked1))
    var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelClicked))
     var cancelButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelClicked))
    var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
    
    var toolBar = UIToolbar()
    let dateFormatter = DateFormatter()
    var currentValueNumeric: Float = 0.0
    var previousValueNumeric: Float = 0.0
    var lastPositionOfScrollView: CGFloat = 0
    var lastHeightOfScrollView: CGFloat = 0
    var toolBar1 = UIToolbar()
    var decimalAdded: Bool = false
    var decimalCount = 0
    var blankView = UIView()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startFetchingAlreadyRunning=false
        searchBaseCurrency.text = historyArray[0]
        targetCurrency.text = historyArray[1]
        baseCurrencyButton.setImage(currencies[currencies.firstIndex(where: {$0.currency == searchBaseCurrency.text!})!].image, for: .normal)
        targetCurrencyButton.setImage(currencies[currencies.firstIndex(where: {$0.currency == targetCurrency.text!})!].image, for: .normal)
        self.navigationController?.navigationBar.barStyle = .black
        let loadValues = LoadCurrencyValues()
        var cValue = Float()
        var pValue = Float()
        if calledFrom == "searchBaseCurrency" || calledFrom == "searchTargetCurrency" {
             (cValue,pValue) = loadValues.loadCurrencyValue(self.searchBaseCurrency.text!, self.targetCurrency.text!, storedValuesCurrent, storedValuesPreviousCustom)
            calledFrom = "tableCell"
        }
        else{
             (cValue,pValue) = loadValues.loadCurrencyValue(self.searchBaseCurrency.text!, self.targetCurrency.text!, storedValuesCurrent, storedValuesPrevious)
        }
        
        self.currentValueNumeric = cValue
        self.previousValueNumeric = pValue
        if searchBaseCurrency.text != targetCurrency.text{
            self.previousValue.text = "1 \(self.searchBaseCurrency.text!) = \(String(format: "%0.4f", Float(previousValueNumeric))) \(self.targetCurrency.text!)"
            self.currentValue.text = "1 \(self.searchBaseCurrency.text!) = \(String(format: "%0.4f", Float(currentValueNumeric))) \(self.targetCurrency.text!)"
        }else{
            self.previousValue.text = "1 \(self.searchBaseCurrency.text!) = 1 \(self.targetCurrency.text!)"
            self.currentValue.text = "1 \(self.searchBaseCurrency.text!) = 1 \(self.targetCurrency.text!)"
        }
        self.currencyConversion()
        
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) {
            return false
        }
        else{
            return true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    var baseAmount_Current: Double = 0
    var baseAmount_Previous: Double = 0
//    var targetAmount_Current: Double = 0
//    var targetAmount_Previous: Double = 0
    
    @IBOutlet weak var toolBarView: UIView!
    override func viewDidLoad() {
         super.viewDidLoad()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               } 
        textView1.layer.masksToBounds=true
        textView1.layer.cornerRadius = textView1.frame.height/2
        
        textView2.layer.masksToBounds=true
        textView2.layer.cornerRadius = textView2.frame.height/2
        storedValuesPreviousCustom = storedValuesPrevious
        if !premiumSubscriptionPurchased {
            
            if !admobConversionInterstitalAlreadyLoaded{
                admobConversionInterstitalAlreadyLoaded=true
                print("Ad loading from startFetching Block - Admob ConversionView")
                conversionViewInterstitial = createAndLoadInterstitial("ca-app-pub-4235447962727236/3059874117")
            }
            
            if !startAppConversionAlreadyLoaded{
                startAppConversionAlreadyLoaded=true
                print("Ad loading from startFetching Block - StartApp ConversionView")
                DispatchQueue.main.async {
                    startAppAdConversionViewInterstitial!.load(withDelegate: self)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                if conversionViewInterstitial.isReady {
                    conversionViewInterstitial.delegate = self
                    conversionViewInterstitial.present(fromRootViewController: self)
                } else {
                    startAppConversionViewPresented=true
                    startAppAdConversionViewInterstitial!.show()
                    print("Ad wasn't ready, Hence StartApp Ad will be presented")
                }
            })
        }
        changeDateButton.layer.masksToBounds=true
        changeDateButton.layer.cornerRadius=changeDateButton.frame.size.height/2
        
        if !premiumSubscriptionPurchased{
            conversionViewBanner.adUnitID = "ca-app-pub-4235447962727236/8169155595"
            conversionViewBanner.rootViewController = self
            conversionViewBanner.load(GADRequest())
            conversionViewBanner.adSize = kGADAdSizeSmartBannerLandscape
            conversionViewBanner.delegate=self
        }else{
            removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
            removeAd.setTitle("Support", for: .normal)
        }
        
        self.splitViewController?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
       
        if baseCurrencyAmountGlobal != ""{
            baseAmount_Current = Double(baseCurrencyAmountGlobal)!
            baseAmount_Previous = Double(baseCurrencyAmountGlobal)!
            baseAmountToConvert_Current.text = baseAmount_Current.formattedWithSeparator
            baseAmountToConvert_Previous.text =  baseAmount_Previous.formattedWithSeparator
        }else{
            self.baseAmountToConvert_Current.text = "1"
            self.baseAmountToConvert_Previous.text = "1"
            baseAmount_Current = 1
            baseAmount_Previous = 1
        }
        
        self.myDatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
       
        var dateComponents = DateComponents()
        dateComponents.year = -19
        self.myDatePicker.minimumDate = Calendar.current.date(byAdding: dateComponents,to: Date())
        self.baseAmountToConvert_Current.delegate = self
        self.baseAmountToConvert_Previous.delegate = self
        
        baseAmountToConvert_Current.addTarget(self, action: #selector(textChanged1), for: .editingChanged)
        baseAmountToConvert_Previous.addTarget(self, action: #selector(textChanged2), for: .editingChanged)
        searchBaseCurrency.addTarget(self, action: #selector(selectBaseCurrency), for: .touchDown)
        targetCurrency.addTarget(self, action: #selector(selectTargetCurrency), for: .touchDown)
        searchBaseCurrency.delegate=self
        targetCurrency.delegate=self
        changeDateButton.delegate = self
        searchBaseCurrency.inputView = blankView
        targetCurrency.inputView = blankView
//        baseAmountToConvert_Previous.addTarget(self, action: #selector(text2EditBegan), for: .editingDidBegin)
        changeDateButton.addTarget(self, action: #selector(text2EditBegan), for: .editingDidBegin)
    
        
        
        myDatePicker.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        myDatePicker.setValue(UIColor.white, forKey: "textColor")
        myDatePicker.datePickerMode = .date
        
        
        toolBar.setItems([cancelButton,flexibleSpace,doneButton], animated: true)
        toolBar.sizeToFit()
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        changeDateButton.inputAccessoryView = toolBar
        changeDateButton.inputView = myDatePicker
        
        toolBar1.setItems([cancelButton1,flexibleSpace,doneButton1], animated: true)
        toolBar1.sizeToFit()
        toolBar1.barStyle = .blackTranslucent
        toolBar1.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        baseAmountToConvert_Current.inputAccessoryView = toolBar1
        baseAmountToConvert_Previous.inputAccessoryView = toolBar1
       
        searchBaseCurrency.text = historyArray[0]
        targetCurrency.text = historyArray[1]
        
        baseCurrencyButton.setImage(currencies[currencies.firstIndex(where: {$0.currency == searchBaseCurrency.text!})!].image, for: .normal)
        targetCurrencyButton.setImage(currencies[currencies.firstIndex(where: {$0.currency == targetCurrency.text!})!].image, for: .normal)

        let loadValues = LoadCurrencyValues()
        let (cValue,pValue) = loadValues.loadCurrencyValue(searchBaseCurrency.text!, targetCurrency.text!, storedValuesCurrent, storedValuesPrevious)
        currentValueNumeric = cValue
        previousValueNumeric = pValue
        currencyConversion()
        
        currentValue.text = "1 \(searchBaseCurrency.text!) = \(String(format: "%0.4f", Float(currentValueNumeric))) \(targetCurrency.text!)"
        previousValue.text = "1 \(searchBaseCurrency.text!) = \(String(format: "%0.4f", Float(previousValueNumeric))) \(targetCurrency.text!)"
        currentTimeStamp.text = "\(today)"
        previousTimeStamp.text = "\(yesterday)"
        dateFormatter.dateFormat = "dd MMM yyyy"
    }
    
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyBoardDimensions = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            contentView.frame.origin.y = -keyBoardDimensions.height + toolBarView.frame.size.height + 50
            
        }else{
            contentView.frame.origin.y = 0
        }
        
    }
    func swap(){
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        historyArray[0] = targetCurrency.text!
        historyArray[1] = searchBaseCurrency.text!
        searchBaseCurrency.text = historyArray[0]
        targetCurrency.text = historyArray[1]
        baseCurrencyButton.setImage(currencies[currencies.firstIndex(where: {$0.currency == searchBaseCurrency.text!})!].image, for: .normal)
        targetCurrencyButton.setImage(currencies[currencies.firstIndex(where: {$0.currency == targetCurrency.text!})!].image, for: .normal)
        let loadValues = LoadCurrencyValues()
        let (cValue,pValue) = loadValues.loadCurrencyValue(self.searchBaseCurrency.text!, self.targetCurrency.text!, storedValuesCurrent, storedValuesPrevious)
        self.currentValueNumeric = cValue
        self.previousValueNumeric = pValue
        self.previousTimeStamp.text = yesterday
        
        if searchBaseCurrency.text != targetCurrency.text{
            self.previousValue.text = "1 \(self.searchBaseCurrency.text!) = \(String(format: "%0.4f", Float(previousValueNumeric))) \(self.targetCurrency.text!)"
            self.currentValue.text = "1 \(self.searchBaseCurrency.text!) = \(String(format: "%0.4f", Float(currentValueNumeric))) \(self.targetCurrency.text!)"
        }else{
             self.previousValue.text = "1 \(self.searchBaseCurrency.text!) = 1 \(self.targetCurrency.text!)"
             self.currentValue.text = "1 \(self.searchBaseCurrency.text!) = 1 \(self.targetCurrency.text!)"
        }
        currencyConversion()
        if numberOfTimesLaunched > 2{
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
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
    
    @objc func selectBaseCurrency(){
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        calledFrom = "searchBaseCurrency"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.navigationItem.backBarButtonItem = backItem
        performSegue(withIdentifier: "showCurrencySearch2", sender: nil)
    }
    
    @objc func selectTargetCurrency(){
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        calledFrom = "searchTargetCurrency"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.navigationItem.backBarButtonItem = backItem
        performSegue(withIdentifier: "showCurrencySearch2", sender: nil)
    }
    
    @objc func doneClicked1(){
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
     baseAmountToConvert_Current.resignFirstResponder()
     baseAmountToConvert_Previous.resignFirstResponder()
         NotificationCenter.default.removeObserver(self)
    }
    
    @objc func doneClicked(){
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        changeDateButton.resignFirstResponder()
        if searchBaseCurrency.text != targetCurrency.text{
        previousValue.isHidden=true
       // previousTimeStamp.isHidden=true
        let networkStatus = CheckNetwork()
        if (networkStatus.connectedToNetwork()){

        let fetchCustomPreviousValues = FetchValues()
        let loadValues = LoadCurrencyValues()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let pDate = dateFormatter.string(from: myDatePicker.date)
            targetAmountConverted_Previous.isHidden = true
        ai1.startAnimating()
        ai3.startAnimating()
        fetchCustomPreviousValues.fetchJasonOfYesterdayCustom(pDate){
            (sucess) in
            if (sucess){
                let (cValue,pValue) = loadValues.loadCurrencyValue(self.searchBaseCurrency.text!, self.targetCurrency.text!, storedValuesCurrent, storedValuesPreviousCustom)
                self.currentValueNumeric = cValue
                self.previousValueNumeric = pValue
               
                self.previousValue.text = "1 \(self.searchBaseCurrency.text!) = \(String(format: "%0.4f", Float(self.previousValueNumeric))) \(self.targetCurrency.text!)"
                self.dateFormatter.dateFormat = "dd MMM yyyy"
                self.previousTimeStamp.text = self.dateFormatter.string(from: self.myDatePicker.date)
                self.ai1.stopAnimating()
                self.ai3.stopAnimating()
                self.previousValue.isHidden=false
               // self.previousTimeStamp.isHidden=false
                self.currencyConversion()
                self.targetAmountConverted_Previous.isHidden = false
                if numberOfTimesLaunched > 2{
                    AppStoreReviewManager.requestReviewIfAppropriate()
                }
            }
        }
         NotificationCenter.default.removeObserver(self)
     }
       else{
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Network Error", message: "Please check your internet conncetion and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
        
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
    else{
    self.previousValue.text = "1 \(self.searchBaseCurrency.text!) = 1 \(self.targetCurrency.text!)"
    self.previousTimeStamp.text = self.dateFormatter.string(from: self.myDatePicker.date)
    if numberOfTimesLaunched > 2{
    AppStoreReviewManager.requestReviewIfAppropriate()
    }
    }
    }
    
    @objc func cancelClicked(){
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        changeDateButton.resignFirstResponder()
        baseAmountToConvert_Current.resignFirstResponder()
        baseAmountToConvert_Previous.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textChanged1(){
        if baseAmountToConvert_Current.text! != ""{
            let array = Array(baseAmountToConvert_Current.text!)
            var count = 0
            for character in array {
                if character == "." {
                    count += 1
                }
            }
            if count > 0{
                decimalAdded = true
            }else{
                decimalAdded = false
            }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.allowsFloats = true
            baseAmount_Current = Double(baseAmountToConvert_Current.text!.replacingOccurrences(of: ",", with: ""))!
            if !decimalAdded{
                self.baseAmountToConvert_Current.text = formatter.string(from: NSNumber(value: self.baseAmount_Current))!
            }
            baseAmount_Previous = baseAmount_Current
            baseAmountToConvert_Previous.text = baseAmountToConvert_Current.text
            currencyConversion()
        }
        else{
            baseAmountToConvert_Current.text = "0"
            targetAmountConverted_Current.text = "0"
            baseAmountToConvert_Previous.text = baseAmountToConvert_Current.text
            targetAmountConverted_Previous.text = targetAmountConverted_Current.text
        }
    }
    
    @objc func text2EditBegan(){
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
    }
    
    @objc func textChanged2(){
       
        if baseAmountToConvert_Previous.text! != ""{
            let array = Array(baseAmountToConvert_Previous.text!)
            var count = 0
            for character in array {
                if character == "." {
                    count += 1
                }
            }
            if count > 0{
                decimalAdded = true
            }else{
                decimalAdded = false
            }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.allowsFloats = true
            baseAmount_Previous = Double(baseAmountToConvert_Previous.text!.replacingOccurrences(of: ",", with: ""))!
            if !decimalAdded{
                self.baseAmountToConvert_Previous.text = formatter.string(from: NSNumber(value: self.baseAmount_Previous))!
            }
            baseAmount_Current = baseAmount_Previous
            baseAmountToConvert_Current.text = baseAmountToConvert_Previous.text
            currencyConversion()
        }else{
            baseAmountToConvert_Previous.text = "0"
            targetAmountConverted_Previous.text = "0"
            baseAmountToConvert_Current.text = baseAmountToConvert_Previous.text
            targetAmountConverted_Current.text = targetAmountConverted_Previous.text
        }
    }
    
    @objc func currencyConversion(){
        
        if baseAmountToConvert_Current.text! != "" && baseAmountToConvert_Previous.text! != ""{
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.numberStyle = .decimal
            
        let value1 = numberFormatter.string(from: NSNumber(value: Double(currentValueNumeric) * baseAmount_Current))
            
        let value2 = numberFormatter.string(from: NSNumber(value: Double(previousValueNumeric) * baseAmount_Previous))
            
            self.targetAmountConverted_Current.text = value1!
            self.targetAmountConverted_Previous.text = value2!
        }
        else{
            self.targetAmountConverted_Current.text = String(currentValueNumeric)
            self.targetAmountConverted_Previous.text = String(previousValueNumeric)
        }
    }
    
    func recommendApp(){
         let recommendMessage = "Hello,\nI am using LiveRates app and have found it useful. You might find it useful too. Here is the AppStore link.\n\nhttps://itunes.apple.com/app/liveratescurrencyconverter/id1471361382\n\nCheers!"
        let recommendViewController = UIActivityViewController(activityItems: [recommendMessage], applicationActivities: nil)
        recommendViewController.popoverPresentationController?.sourceView = self.view
        self.present(recommendViewController, animated: true, completion: nil)
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
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        if !premiumSubscriptionPurchased{
            if startAppConversionViewBanner == nil{
                startAppConversionViewBanner = STABannerView(size: STA_AutoAdSize,
                                                             autoOrigin: STAAdOrigin_Bottom,
                                                             withDelegate: nil);
                self.conversionViewBanner.addSubview(startAppConversionViewBanner!)
            }
        }
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        if startAppConversionViewBanner != nil{
            self.startAppConversionViewBanner!.removeFromSuperview()
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
        admobConversionInterstitalAlreadyLoaded=false
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        if !premiumSubscriptionPurchased{
            admobConversionInterstitalAlreadyLoaded=true
            conversionViewInterstitial = createAndLoadInterstitial("ca-app-pub-4235447962727236/3059874117")
        }
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
    //StartApp Delegate
    func didClose(_ ad: STAAbstractAd!) {
        if !premiumSubscriptionPurchased{
            if startAppConversionViewPresented{
                startAppConversionViewPresented=false
                startAppConversionAlreadyLoaded=true
                startAppAdConversionViewInterstitial!.load(withDelegate: self)
                print("StartApp ConversionView Interstitial Dismissed and reloaded")
            }
        }
    }
    
    func failedLoad(_ ad: STAAbstractAd!, withError error: Error!) {
        print("Failed to load StartAppInterstitial")
        startAppConversionAlreadyLoaded=false
    }
        
}





