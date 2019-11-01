//
//  SearchCurrencies.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 19/6/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import GoogleMobileAds

var searchedCurrency = ""
var currencyAlreadyIsPresent = true
class SearchCurrencies: UIViewController,GADBannerViewDelegate,GADInterstitialDelegate{
   
    
    @IBOutlet weak var searchViewBanner: GADBannerView!
    var startAppSearchViewBanner: STABannerView?
    @IBOutlet weak var searchTable: UITableView!
    var cellDelegate: TableCellProtocol?
    var searchViewController = UISearchController(searchResultsController: nil)
    var searchResult = [(currencyShort:String,country:String)]()
    var searching: Bool = false
    var matchedText: String = ""
    let cellBackgroundView = UIView()
    
    @IBAction func recommendButton(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.navigationItem.backBarButtonItem = backItem
        performSegue(withIdentifier: "searchToMore", sender: nil)
    }
    
    @IBAction func recommend(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.navigationItem.backBarButtonItem = backItem
        performSegue(withIdentifier: "searchToMore", sender: nil)
    }
    
    
    @IBOutlet weak var removeAd: UIButton!
    
    @IBOutlet weak var removeAdButton: UIButton!
    
    @IBAction func removeAdButtonClicked(_ sender: Any) {
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.impactOccurred()
        if !premiumSubscriptionPurchased{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            self.navigationItem.backBarButtonItem = backItem
            performSegue(withIdentifier: "segueToSubscriptionVCFromSearchView", sender: nil)
        }else{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            self.navigationItem.backBarButtonItem = backItem
            performSegue(withIdentifier: "segueToSupportVCFromSearchView", sender: nil)
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
            performSegue(withIdentifier: "segueToSubscriptionVCFromSearchView", sender: nil)
        }else{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            backItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            self.navigationItem.backBarButtonItem = backItem
            performSegue(withIdentifier: "segueToSupportVCFromSearchView", sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startFetchingAlreadyRunning=false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               } 
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if !premiumSubscriptionPurchased{
            searchViewBanner.adUnitID = "ca-app-pub-4235447962727236/9208627297"
            searchViewBanner.rootViewController = self
            searchViewBanner.load(GADRequest())
            searchViewBanner.adSize = kGADAdSizeSmartBannerLandscape
            searchViewBanner.delegate=self
        }else{
            removeAdButton.setImage(UIImage(named: "Support"), for: .normal)
            removeAd.setTitle("Support", for: .normal)
        }

        if calledFrom == "baseCurrency"{
            self.title = "Base Currency"
        }
       
        self.navigationItem.searchController = searchViewController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchViewController.searchBar.delegate=self
        searchViewController.dimsBackgroundDuringPresentation = false
        searchViewController.searchBar.barStyle = .blackTranslucent
        searchViewController.searchBar.keyboardType = .asciiCapable
        searchViewController.searchBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        searchViewController.searchBar.keyboardAppearance = .dark
        cellBackgroundView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        searchTable.sectionIndexColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.navigationController?.editButtonItem.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        cellDelegate = CurrencyTable()
    }
}

extension SearchCurrencies: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchResult.count
        }else{
            return currenciesName[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.searchTable.topAnchor.constraint(equalTo: (self.navigationItem.searchController?.searchBar.bottomAnchor)!, constant: 0).isActive = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
       // print(indexPath.section)
        if searching{
            cell.selectedBackgroundView = cellBackgroundView
            cell.textLabel?.text = searchResult[indexPath.row].currencyShort + " - " + searchResult[indexPath.row].country
            cell.textLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // initally set the whole color for your text
            //Create mutable string from original one
            let attString = NSMutableAttributedString(string:  cell.textLabel!.text!)
            //Fing range of the string you want to change colour
            //If you need to change colour in more that one place just repeat it
            let range: NSRange = (cell.textLabel!.text! as NSString).range(of:  matchedText, options: .caseInsensitive) //he in here use searchBar.text
            attString.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], range: range)
            // here set selection color what ever you typed
            //Add it to the label - notice its not text property but it's attributeText
            cell.textLabel?.attributedText = attString
        }else{
            cell.selectedBackgroundView = cellBackgroundView
            cell.textLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.textLabel?.text = currenciesName[indexPath.section][indexPath.row].currencyShort + " - " + currenciesName[indexPath.section][indexPath.row].country
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searching{
            return 1
        }
        else{
            return sectionIndexTitlesArray.count
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searching{
            return [""]
        }
        else{
         return sectionIndexTitlesArray
        }
        
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitle = UILabel()
        if searching{
            sectionTitle.text = "TOP MATCHES"
        }
        else{
            sectionTitle.text = "    "+sectionIndexTitlesArray[section]
            sectionTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        }
        //sectionTitle.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 2)
        
        sectionTitle.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        sectionTitle.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.searchViewController.searchBar.endEditing(true)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        inserted=true
 
        if calledFrom == "addButton"{
            searchedCurrency = searching ? searchResult[indexPath.row].currencyShort : currenciesName[indexPath.section][indexPath.row].currencyShort
            
            for i in selectedCurrencies{
                if i.currName == searchedCurrency{
                    currencyAlreadyIsPresent = true
                    alreadyPresentLocation=selectedCurrencies.firstIndex(where: {$0.currName == searchedCurrency})!
                    break
                }else{
                    currencyAlreadyIsPresent = false
                }
            }
            if !currencyAlreadyIsPresent{
                let hapticFeedback = UISelectionFeedbackGenerator()
                hapticFeedback.selectionChanged()
                selectedCurrencies.insert(favoriteCurrencies(currName: "\(searchedCurrency)", fullForm: currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].name, symbol: currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].symbol, image: (currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].image?.pngData()!)!), at: selectedArrayIndex)
                storeFavCurrencies()
            }else{
                let hapticFeedback = UINotificationFeedbackGenerator()
                hapticFeedback.notificationOccurred(.warning)
                let alert = UIAlertController(title: "Duplicate Selection", message: "\(searchedCurrency) is already present in wallet", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    switch action.style{
                    case .default:
                        print("Default")
                        self.navigationController?.popViewController(animated: true)
                    case .cancel:
                        print("Cancel")
                    case .destructive:
                        print("Destructive")
                    @unknown default:
                        print("Unknow error")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            searchedCurrency = ""
        }
        else if calledFrom == "plusButton"{
            searchedCurrency = searching ? searchResult[indexPath.row].currencyShort : currenciesName[indexPath.section][indexPath.row].currencyShort
            for i in selectedCurrencies{
                if i.currName == searchedCurrency{
                    alreadyPresentLocation=selectedCurrencies.firstIndex(where: {$0.currName == searchedCurrency})!
                    currencyAlreadyIsPresent = true
                    break
                }else{
                    currencyAlreadyIsPresent = false
                }
            }
            if !currencyAlreadyIsPresent{
                let hapticFeedback = UISelectionFeedbackGenerator()
                hapticFeedback.selectionChanged()
                
               
                selectedCurrencies.insert(favoriteCurrencies(currName: "\(searchedCurrency)", fullForm: currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].name, symbol: currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].symbol, image: (currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].image?.pngData()!)!), at: 0)
                
                storeFavCurrencies()
            }else{
                let hapticFeedback = UINotificationFeedbackGenerator()
                hapticFeedback.notificationOccurred(.warning)
                let alert = UIAlertController(title: "Duplicate Selection", message: "\(searchedCurrency) is already present in wallet", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    switch action.style{
                    case .default:
                        print("Default")
                        self.navigationController?.popViewController(animated: true)
                    case .cancel:
                        print("Cancel")
                    case .destructive:
                        print("Destructive")
                    @unknown default:
                        print("Unknow error")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            searchedCurrency = ""
        }
        else if calledFrom == "currencyButton"{
            searchedCurrency = searching ? searchResult[indexPath.row].currencyShort : currenciesName[indexPath.section][indexPath.row].currencyShort
            for i in selectedCurrencies{
                print("Searched Currency: \(searchedCurrency)")
                //print(i)
                if i.currName == searchedCurrency{
                    alreadyPresentLocation=selectedCurrencies.firstIndex(where: {$0.currName == searchedCurrency})!
                    currencyAlreadyIsPresent = true
                    break
                }else{
                    currencyAlreadyIsPresent = false
                }
            }
            if !currencyAlreadyIsPresent{
                let hapticFeedback = UISelectionFeedbackGenerator()
                hapticFeedback.selectionChanged()
                selectedCurrencies[selectedArrayIndex].currName = searchedCurrency
                selectedCurrencies[selectedArrayIndex].image = (currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].image?.pngData()!)!
                selectedCurrencies[selectedArrayIndex].fullForm = (currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].name)
                selectedCurrencies[selectedArrayIndex].symbol = (currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].symbol)
                storeFavCurrencies()
            }else{
                let hapticFeedback = UINotificationFeedbackGenerator()
                hapticFeedback.notificationOccurred(.warning)
                let alert = UIAlertController(title: "Duplicate Selection", message: "\(searchedCurrency) is already present in wallet", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    switch action.style{
                    case .default:
                        print("Default")
                        self.navigationController?.popViewController(animated: true)
                    case .cancel:
                        print("Cancel")
                    case .destructive:
                        print("Destructive")
                    @unknown default:
                        print("Unknow error")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            searchedCurrency = ""
        }
        else if calledFrom == "baseCurrency"{
            searchedCurrency = searching ? searchResult[indexPath.row].currencyShort : currenciesName[indexPath.section][indexPath.row].currencyShort
            if searchedCurrency == baseCurrencyName.currName{
                currencyAlreadyIsPresent = true
            }else{
                currencyAlreadyIsPresent = false
            }
            if !currencyAlreadyIsPresent{
                let hapticFeedback = UISelectionFeedbackGenerator()
                hapticFeedback.selectionChanged()
                baseCurrencyName.currName = searchedCurrency
                baseCurrencyName.image = (currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].image?.pngData()!)!
                baseCurrencyName.fullForm = (currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].name)
                baseCurrencyName.symbol = (currencies[currencies.firstIndex(where: {$0.currency == searchedCurrency})!].symbol)
                storeBaseCurrency()
            }else{
                let hapticFeedback = UINotificationFeedbackGenerator()
                hapticFeedback.notificationOccurred(.warning)
                let alert = UIAlertController(title: "Duplicate Selection", message: "\(searchedCurrency) is already the base currency in wallet", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    switch action.style{
                    case .default:
                        print("Default")
                        self.navigationController?.popViewController(animated: true)
                    case .cancel:
                        print("Cancel")
                    case .destructive:
                        print("Destructive")
                    @unknown default:
                        print("Unknow error")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            searchedCurrency = ""
        }
        else if calledFrom == "searchBaseCurrency"{
            let hapticFeedback = UISelectionFeedbackGenerator()
            hapticFeedback.selectionChanged()
            historyArray[0] = searching ? searchResult[indexPath.row].currencyShort : currenciesName[indexPath.section][indexPath.row].currencyShort
        }
        else if calledFrom == "searchTargetCurrency"{
            let hapticFeedback = UISelectionFeedbackGenerator()
            hapticFeedback.selectionChanged()
            historyArray[1] = searching ? searchResult[indexPath.row].currencyShort : currenciesName[indexPath.section][indexPath.row].currencyShort
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            self.navigationController?.popViewController(animated: true)
            })
    }
}

extension SearchCurrencies: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTable.isHidden=true
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            searchResult = currenciesName.flatMap({$0}).filter({$0.currencyShort.prefix(searchText.count).lowercased() == searchText.lowercased() || /*$0.country.prefix(searchText.count).lowercased() == searchText.lowercased() ||*/ $0.country.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil})
            matchedText = searchText
            searching = true
            searchTable.isHidden=false
            searchTable.reloadData()
        }
        else{
            searchTable.isHidden=true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchTable.isHidden=false
        searchTable.reloadData()
    }
    
    func recommend(){
        let recommendMessage = "Hello,\nI am using LiveRates app and have found it useful. You might find it useful too. Here is the AppStore link.\n\nhttps://itunes.apple.com/app/liveratescurrencyconverter/id1471361382\n\nCheers!"
        let recommendViewController = UIActivityViewController(activityItems: [recommendMessage], applicationActivities: nil)
        recommendViewController.popoverPresentationController?.sourceView = self.view
        self.present(recommendViewController, animated: true, completion: nil)
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
            if startAppSearchViewBanner == nil{
                startAppSearchViewBanner = STABannerView(size: STA_AutoAdSize,
                                                         autoOrigin: STAAdOrigin_Bottom,
                                                         withDelegate: nil);
                self.searchViewBanner.addSubview(startAppSearchViewBanner!)
            }
        }
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        if startAppSearchViewBanner != nil{
            self.startAppSearchViewBanner!.removeFromSuperview()
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
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
    
}
