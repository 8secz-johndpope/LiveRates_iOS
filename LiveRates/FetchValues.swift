
//
//  LoadInitialValues.swift
//  Forex Wallet
//
//  Created by Aruna Sairam Manjunatha on 10/6/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import GoogleMobileAds
import UserNotifications


struct Currency: Decodable{
    var source: String = ""
    var quotes: [String:Float] = ["":0.0]
}

var storedValuesCurrent = Currency()
var storedValuesPrevious = Currency()
var storedValuesPreviousCustom = Currency()
var startFetchingAlreadyRunning = false
var start: DispatchTime?
var end: DispatchTime?
var calledFromBackground = false
var calledFromSubscription = false

//#if DEBUG
//let verifyReceiptURL = "https1://sandbox.itunes.apple.com/verifyReceipt1"
//#else
let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
//#endif

var lastUpdated = String()
var yesterday = ""
var today = ""
var prevDate = " "
var premiumSubscriptionPurchased = Bool()
var startLaunch = Bool()
var restoreStatus = false
var currencies: [(currency: String, symbol: String, name: String,image: UIImage?)] = [("Select","$","Select",UIImage(named: "add.png")),
                                                         ("AUD","$","Australian Dollar",UIImage(named: "aus.png")),
                                                         
                                                         ("USD","$","United States Dollar",UIImage(named:"usa.png")),
                                                         ("AED","د.إ","United Arab Emirates Dirham",UIImage(named: "united-arab-emirates.png")),
                                                         ("AFN","؋","Afghan Afghani",UIImage(named: "afghanistan.png")),
                                                         ("ALL","Lek","Albanian Lek",UIImage(named: "albania.png")),
                                                         ("AMD","դր","Armenian Dram",UIImage(named: "armenia.png")),
                                                         ("ANG","ƒ","Netherlands Antillean Guilder",UIImage(named: "netherlands.png")),
                                                         ("AOA","Kz","Angolan Kwanza",UIImage(named: "angola.png")),
                                                         ("ARS","$","Argentine Peso",UIImage(named: "argentina.png")),
                                                         ("AWG","ƒ","Aruban florin",UIImage(named: "aruba.png")),
                                                         ("AZN","₼","Azerbaijani Manat",UIImage(named: "azerbaijan.png")),
                                                         ("BAM","KM","Bosnia and Herzegovina convertible mark",UIImage(named: "bosnia-and-herzegovina.png")),
                                                         ("BBD","$","Barbados Dollar",UIImage(named: "barbados.png")),
                                                         ("BDT","৳","Bangladeshi Taka",UIImage(named: "bangladesh.png")),
                                                         ("BGN","лв","Bulgarian Lev",UIImage(named: "bulgaria.png")),
                                                         ("BHD",".د.ب","Bahraini Dinar",UIImage(named: "bahrain.png")),
                                                         ("BIF","FBu","Burundian Franc",UIImage(named: "burundi.png")),
                                                         ("BMD","$","Bermudian dollar",UIImage(named: "bermuda.png")),
                                                         ("BND","$","Brunei Dollar",UIImage(named: "brunei.png")),
                                                         ("BOB","$b","Bolivian Boliviano",UIImage(named: "bolivia.png")),
                                                         ("BRL","R$","Brazilian Real",UIImage(named: "brazil.png")),
                                                         ("BSD","$","Bahamian Dollar",UIImage(named: "bahamas.png")),
                                                         ("BTC","₿","Bitcoin",UIImage(named: "bitcoin.png")),
                                                         ("BTN","Nu","Bhutanese Ngultrum",UIImage(named: "bhutan.png")),
                                                         ("BWP","P","Botswana Pula",UIImage(named: "botswana.png")),
                                                         ("BYN","Br","New Belarusian Ruble",UIImage(named: "belarus.png")),
                                                         ("BYR","Br","Belarusian Ruble",UIImage(named: "belarus.png")),
                                                         ("BZD","BZ$","Belize Dollar",UIImage(named: "belize.png")),
                                                         ("CAD","$","Canadian Dollar",UIImage(named: "canada.png")),
                                                         ("CDF","FC","Congolese franc",UIImage(named: "democratic-republic-of-congo.png")),
                                                         ("CHF","CHF","Swiss Franc",UIImage(named: "switzerland.png")),
                                                         ("CLF","UF","Unidad de Fomento",UIImage(named: "chile.png")),
                                                         ("CLP","$","Chilean Peso",UIImage(named: "chile.png")),
                                                         ("CNY","¥","Chinese Yuan Renminbi",UIImage(named: "china.png")),
                                                         ("COP","$","Colombian Peso",UIImage(named: "colombia.png")),
                                                         ("CRC","₡","Costa Rican Colon",UIImage(named: "costa-rica.png")),
                                                         ("CUC","$","Cuban Convertible Peso",UIImage(named: "cuba.png")),
                                                         ("CUP","₱","Cuban Peso",UIImage(named: "cuba.png")),
                                                         ("CVE","$","Cape Verde Escudo",UIImage(named: "cape-verde.png")),
                                                         ("CZK","Kč","Czech Koruna",UIImage(named: "czech-republic.png")),
                                                         ("DJF","Fdj","Djiboutian Franc",UIImage(named: "djibouti.png")),
                                                         ("DKK","kr.","Danish Krone",UIImage(named: "denmark.png")),
                                                         ("DOP","RD$","Dominican Peso",UIImage(named: "dominican-republic.png")),
                                                         ("DZD","دج","Algerian Dinar",UIImage(named: "algeria.png")),
                                                         ("EGP","£","Egyptian Pound",UIImage(named: "egypt.png")),
                                                         ("ERN","ናቕፋ","Eritrean Nakfa",UIImage(named: "eritrea.png")),
                                                         ("ETB","ብር","Ethiopian Birr",UIImage(named: "ethiopia.png")),
                                                         ("EUR","€","European Euro",UIImage(named: "european-union.png")),
                                                         ("FJD","$","Fiji Dollar",UIImage(named: "fiji.png")),
                                                         ("FKP","£","Falkland Islands pound",UIImage(named: "falkland-islands.png")),
                                                         ("GBP","£","United Kingdom Pound Sterling",UIImage(named: "united-kingdom.png")),
                                                         ("GEL","ლ","Georgian Lari",UIImage(named: "georgia.png")),
                                                         ("GGP","£","Guernsey pound",UIImage(named: "guernsey.png")),
                                                         ("GHS","GH¢","Ghanaian cedi",UIImage(named: "ghana.png")),
                                                         ("GIP","£","Gibraltar pound",UIImage(named: "gibraltar.png")),
                                                         ("GMD","D","Gambian Dalasi",UIImage(named: "gambia.png")),
                                                         ("GNF","FG","Guinean Franc",UIImage(named: "guinea.png")),
                                                         ("GTQ","Q","Guatemalan Quetzal",UIImage(named: "guatemala.png")),
                                                         ("GYD","$","Guyanese Dollar",UIImage(named: "guyana.png")),
                                                         ("HKD","HK$","Hong Kong dollar",UIImage(named: "hong-kong.png")),
                                                         ("HNL","L","Honduran Lempira",UIImage(named: "honduras.png")),
                                                         ("HRK","kn","Croatian Kuna",UIImage(named: "croatia.png")),
                                                         ("HTG","G","Haitian Gourde",UIImage(named: "haiti.png")),
                                                         ("HUF","Ft","Hungarian Forint",UIImage(named: "hungary.png")),
                                                         ("IDR","Rp","Indonesian Rupiah",UIImage(named: "indonesia.png")),
                                                         ("ILS","₪","Israeli New Sheqel",UIImage(named: "israel.png")),
                                                         ("IMP","£","Manx pound",UIImage(named: "isle-of-man.png")),
                                                         ("INR","₹","Indian Rupee",UIImage(named: "india.png")),
                                                         ("IQD","ع.د","Iraqi Dinar",UIImage(named: "iraq.png")),
                                                         ("IRR","﷼","Iranian Rial",UIImage(named: "iran.png")),
                                                         ("ISK","kr","Icelandic Krona",UIImage(named: "iceland.png")),
                                                         ("JEP","£","Jersey Pound",UIImage(named: "jersey.png")),
                                                         ("JMD","J$","Jamaican Dollar",UIImage(named: "jamaica.png")),
                                                         ("JOD","د.ا","Jordanian Dinar",UIImage(named: "jordan.png")),
                                                         ("JPY","¥","Japanese Yen",UIImage(named: "japan.png")),
                                                         ("KES","KSh,","Kenyan Shilling",UIImage(named: "kenya.png")),
                                                         ("KGS","лв","Kyrgyzstani Som",UIImage(named: "kyrgyzstan.png")),
                                                         ("KHR","៛","Cambodian Riel",UIImage(named: "cambodia.png")),
                                                         ("KMF","CF","Comorian Franc",UIImage(named: "comoros.png")),
                                                         ("KPW","₩","North Korean Won",UIImage(named: "north-korea.png")),
                                                         ("KRW","₩","Korean Won",UIImage(named: "south-korea.png")),
                                                         ("KWD","د.ك","Kuwaiti Dinar",UIImage(named: "kuwait.png")),
                                                         ("KYD","$","Cayman Islands dollar",UIImage(named: "cayman-islands.png")),
                                                         ("KZT","лв","Kazakhstani Tenge",UIImage(named: "kazakhstan.png")),
                                                         ("LAK","₭","Lao Kip",UIImage(named: "laos.png")),
                                                         ("LBP","£","Lebanese Pound",UIImage(named: "lebanon.png")),
                                                         ("LKR","ரூ","Sri Lankan Rupee",UIImage(named: "sri-lanka.png")),
                                                         ("LRD","$","Liberian Dollar",UIImage(named: "liberia.png")),
                                                         ("LSL","L","Lesotho Loti",UIImage(named: "lesotho.png")),
                                                         ("LTL","Lt","Lithuanian Litas",UIImage(named: "lithuania.png")),
                                                         ("LVL","Ls","Latvian Lats",UIImage(named: "latvia.png")),
                                                         ("LYD","ل.د","Libyan Dinar",UIImage(named: "libya.png")),
                                                         ("MAD","DH","Moroccan Dirham",UIImage(named: "morocco.png")),
                                                         ("MDL","L","Moldovan Leu",UIImage(named: "moldova.png")),
                                                         ("MGA","Ar","Malagasy Ariary",UIImage(named: "madagascar.png")),
                                                         ("MKD","ден","Macedonian Denar",UIImage(named: "republic-of-macedonia.png")),
                                                         ("MMK","K","Myanmar Kyat",UIImage(named: "myanmar.png")),
                                                         ("MNT","₮","Mongolian Tugrik",UIImage(named: "mongolia.png")),
                                                         ("MOP","MOP$","Macanese pataca",UIImage(named: "macao.png")),
                                                         ("MRO","UM","Mauritanian Ouguiya",UIImage(named: "mauritania.png")),
                                                         ("MUR","₨","Mauritian Rupee",UIImage(named: "mauritius.png")),
                                                         ("MVR","Rf","Maldives Rufiyaa",UIImage(named: "maldives.png")),
                                                         ("MWK","MK","Malawian Kwacha",UIImage(named: "malawi.png")),
                                                         ("MXN","$","Mexican Peso",UIImage(named: "mexico.png")),
                                                         ("MYR","RM","Malaysian Ringgit",UIImage(named: "malaysia.png")),
                                                         ("MZN","MT","Mozambican Metical",UIImage(named: "mozambique.png")),
                                                         ("NAD","$","Namibian Dollar",UIImage(named: "namibia.png")),
                                                         ("NGN","₦","Nigerian Naira",UIImage(named: "nigeria.png")),
                                                         ("NIO","C$","Nicaraguan Córdoba",UIImage(named: "nicaragua.png")),
                                                         ("NOK","kr","Norwegian Krone",UIImage(named: "norway.png")),
                                                         ("NPR","₨","Nepalese Rupee",UIImage(named: "nepal.png")),
                                                         ("NZD","$","New Zealand Dollar",UIImage(named: "new-zealand.png")),
                                                         ("OMR","﷼","Omani Rial",UIImage(named: "oman.png")),
                                                         ("PAB","B/.","Panamanian Balboa",UIImage(named: "panama.png")),
                                                         ("PEN","S/.","Peruvian Nuevo Sol",UIImage(named: "peru.png")),
                                                         ("PGK","K","Papua New Guinea Kina",UIImage(named: "papua-new-guinea.png")),
                                                         ("PHP","₱","Philippine Peso",UIImage(named: "philippines.png")),
                                                         ("PKR","₨","Pakistan Rupee",UIImage(named: "pakistan.png")),
                                                         ("PLN","zł","Polish Zloty",UIImage(named: "republic-of-poland.png")),
                                                         ("PYG","Gs","Paraguay Guarani",UIImage(named: "paraguay.png")),
                                                         ("QAR","﷼","Qatari Riyal",UIImage(named: "qatar.png")),
                                                         ("RON","lei","Romanian Leu",UIImage(named: "romania.png")),
                                                         ("RSD","Дин.","Serbian Dinar",UIImage(named: "serbia.png")),
                                                         ("RUB","₽","Russian Ruble",UIImage(named: "russia.png")),
                                                         ("RWF","FRw","Rwandan Franc",UIImage(named: "rwanda.png")),
                                                         ("SAR","﷼","Saudi Arabian Riyal",UIImage(named: "saudi-arabia.png")),
                                                         ("SBD","$","Solomon Islands Dollar",UIImage(named: "solomon-islands.png")),
                                                         ("SCR","₨","Seychelles Rupee",UIImage(named: "seychelles.png")),
                                                         ("SDG","SD","Sudanese pound",UIImage(named: "sudan.png")),
                                                         ("SEK","kr","Swedish Krona",UIImage(named: "sweden.png")),
                                                         ("SGD","$","Singapore Dollar",UIImage(named: "singapore.png")),
                                                         ("SLL","Le","Sierra Leonean Leone",UIImage(named: "sierra-leone.png")),
                                                         ("SOS","S","Somali Shilling",UIImage(named: "somalia.png")),
                                                         ("SRD","$","Suriname Dollar",UIImage(named: "suriname.png")),
                                                         ("STD","Db","Sao Tome Dobra",UIImage(named: "sao-tome-and-principe.png")),
                                                         ("SVC","₡","Salvadoran colón",UIImage(named: "salvador.png")),
                                                         ("SYP","£","Syrian Pound",UIImage(named: "syria.png")),
                                                         ("SZL","E","Swazi Lilangeni",UIImage(named: "swaziland.png")),
                                                         ("THB","฿","Thai Baht",UIImage(named: "thailand.png")),
                                                         ("TJS","ЅM","Tajikistan Somoni",UIImage(named: "tajikistan.png")),
                                                         ("TMT","T","Turkmenistan manat",UIImage(named: "turkmenistan.png")),
                                                         ("TND","د.ت","Tunisian Dinar",UIImage(named: "tunisia.png")),
                                                         ("TOP","T$","Tongan Pa'Anga",UIImage(named: "tonga.png")),
                                                         ("TRY","₺","Turkish New Lira",UIImage(named: "turkey.png")),
                                                         ("TTD","TT$","Trinidad and Tobago Dollar",UIImage(named: "trinidad-and-tobago.png")),
                                                         ("TWD","NT$","New Taiwan Dollar",UIImage(named: "taiwan.png")),
                                                         ("TZS","TSh","Tanzanian Shilling",UIImage(named: "tanzania.png")),
                                                         ("UAH","₴","Ukrainian Hryvnia",UIImage(named: "ukraine.png")),
                                                         ("UGX","USh","Ugandan Shilling",UIImage(named: "uganda.png")),
                                                         ("UYU","$U","Uruguayan peso",UIImage(named: "uruguay.png")),
                                                         ("UZS","лв","Uzbekistani Som",UIImage(named: "uzbekistn.png")),
                                                         ("VEF","Bs","Venezuelan Bolivar",UIImage(named: "venezuela.png")),
                                                         ("VND","₫","Viet Nam Dong",UIImage(named: "vietnam.png")),
                                                         ("VUV","VT","Vanuatu vatu",UIImage(named: "vanuatu.png")),
                                                         ("WST","WS$","Samoan Tala",UIImage(named: "samoa.png")),
                                                         
                                                         ("XAF","FCFA","CFA Franc BEAC",UIImage(named: "central-african-republic.png")),
                                                         ("XAG","℥","Silver (troy ounce)",UIImage(named: "silver.png")),
                                                         ("XAU","℥","Gold (troy ounce)",UIImage(named: "gold.png")),
                                                         
                                                         ("XCD","$","East Caribbean Dollar",UIImage(named: "caribbean.png")),
                                                         ("XDR","SDR","Special Drawing Rights",UIImage(named: "sdr.png")),
                                                         ("XOF","CFA","West African CFA franc",UIImage(named: "central-african-republic.png")),
                                                         ("XPF","₣","CFP Franc",UIImage(named: "france.png")),
                                                         ("YER","﷼","Yemeni Rial",UIImage(named: "yemen.png")),
                                                         ("ZAR","R","South African Rand",UIImage(named: "south-africa.png")),
                                                         ("ZMK","K","Zambian Kwacha (pre-2013)",UIImage(named: "zambia.png")),
                                                         ("ZMW","ZK","Zambian Kwacha",UIImage(named: "zambia.png")),
                                                         ("ZWL","$","Zimbabwean Dollar",UIImage(named: "zimbabwe.png"))]






var sectionIndexTitlesArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y", "Z"]

var currenciesName: [[(currencyShort: String,country: String)]] = [[("AED", "United Arab Emirates Dirham"),
                                                                 ("AFN", "Afghan Afghani"),
                                                                 ("ALL", "Albanian Lek"),
                                                                 ("AMD", "Armenian Dram"),
                                                                 ("ANG", "Netherlands Antillean Guilder"),
                                                                 ("AOA", "Angolan Kwanza"),
                                                                 ("ARS", "Argentine Peso"),
                                                                 ("AUD", "Australian Dollar"),
                                                                 ("AWG", "Aruban Florin"),
                                                                 ("AZN", "Azerbaijani Manat")],
                                                                 [("BAM", "Bosnia-Herzegovina Convertible Mark"),
                                                                 ("BBD", "Barbadian Dollar"),
                                                                 ("BDT", "Bangladeshi Taka"),
                                                                 ("BGN", "Bulgarian Lev"),
                                                                 ("BHD", "Bahraini Dinar"),
                                                                 ("BIF", "Burundian Franc"),
                                                                 ("BMD", "Bermudan Dollar"),
                                                                 ("BND", "Brunei Dollar"),
                                                                 ("BOB", "Bolivian Boliviano"),
                                                                 ("BRL", "Brazilian Real"),
                                                                 ("BSD", "Bahamian Dollar"),
                                                                 ("BTC", "Bitcoin"),
                                                                 ("BTN", "Bhutanese Ngultrum"),
    ("BWP", "Botswanan Pula"),
    ("BYN", "New Belarusian Ruble"),
    ("BYR", "Belarusian Ruble"),
    ("BZD", "Belize Dollar")],
    [("CAD", "Canadian Dollar"),
    ("CDF", "Congolese Franc"),
    ("CHF", "Swiss Franc"),
    ("CLF", "Unidad de Fomento"),//Chilean Unit of Account (UF)"),
    ("CLP", "Chilean Peso"),
    ("CNY", "Chinese Yuan"),
    ("COP", "Colombian Peso"),
    ("CRC", "Costa Rican Colon"),
    ("CUC", "Cuban Convertible Peso"),
    ("CUP", "Cuban Peso"),
    ("CVE", "Cape Verdean Escudo"),
    ("CZK", "Czech Republic Koruna")],
    [("DJF", "Djiboutian Franc"),
    ("DKK", "Danish Krone"),
    ("DOP", "Dominican Peso"),
    ("DZD", "Algerian Dinar")],
    [("EGP", "Egyptian Pound"),
    ("ERN", "Eritrean Nakfa"),
    ("ETB", "Ethiopian Birr"),
    ("EUR", "Euro")],
    [("FJD", "Fijian Dollar"),
    ("FKP", "Falkland Islands Pound")],
    [("GBP", "British Pound Sterling"),
    ("GEL", "Georgian Lari"),
    ("GGP", "Guernsey Pound"),
    ("GHS", "Ghanaian Cedi"),
    ("GIP", "Gibraltar Pound"),
    ("GMD", "Gambian Dalasi"),
    ("GNF", "Guinean Franc"),
    ("GTQ", "Guatemalan Quetzal"),
    ("GYD", "Guyanaese Dollar")],
    [("HKD", "Hong Kong Dollar"),
    ("HNL", "Honduran Lempira"),
    ("HRK", "Croatian Kuna"),
    ("HTG", "Haitian Gourde"),
    ("HUF", "Hungarian Forint")],
    [("IDR", "Indonesian Rupiah"),
    ("ILS", "Israeli New Sheqel"),
    ("IMP", "Manx pound"),
    ("INR", "Indian Rupee"),
    ("IQD", "Iraqi Dinar"),
    ("IRR", "Iranian Rial"),
    ("ISK", "Icelandic Krona")],
    [("JEP", "Jersey Pound"),
    ("JMD", "Jamaican Dollar"),
    ("JOD", "Jordanian Dinar"),
    ("JPY", "Japanese Yen")],
    [("KES", "Kenyan Shilling"),
    ("KGS", "Kyrgystani Som"),
    ("KHR", "Cambodian Riel"),
    ("KMF", "Comorian Franc"),
    ("KPW", "North Korean Won"),
    ("KRW", "South Korean Won"),
    ("KWD", "Kuwaiti Dinar"),
    ("KYD", "Cayman Islands Dollar"),
    ("KZT", "Kazakhstani Tenge")],
    [("LAK", "Laotian Kip"),
    ("LBP", "Lebanese Pound"),
    ("LKR", "Sri Lankan Rupee"),
    ("LRD", "Liberian Dollar"),
    ("LSL", "Lesotho Loti"),
    ("LTL", "Lithuanian Litas"),
    ("LVL", "Latvian Lats"),
    ("LYD", "Libyan Dinar")],
    [("MAD", "Moroccan Dirham"),
    ("MDL", "Moldovan Leu"),
    ("MGA", "Malagasy Ariary"),
    ("MKD", "Macedonian Denar"),
    ("MMK", "Myanma Kyat"),
    ("MNT", "Mongolian Tugrik"),
    ("MOP", "Macanese Pataca"),
    ("MRO", "Mauritanian Ouguiya"),
    ("MUR", "Mauritian Rupee"),
    ("MVR", "Maldivian Rufiyaa"),
    ("MWK", "Malawian Kwacha"),
    ("MXN", "Mexican Peso"),
    ("MYR", "Malaysian Ringgit"),
    ("MZN", "Mozambican Metical")],
    [("NAD", "Namibian Dollar"),
    ("NGN", "Nigerian Naira"),
    ("NIO", "Nicaraguan Córdoba"),
    ("NOK", "Norwegian Krone"),
    ("NPR", "Nepalese Rupee"),
    ("NZD", "New Zealand Dollar")],
    [("OMR", "Omani Rial")],
    [("PAB", "Panamanian Balboa"),
    ("PEN", "Peruvian Nuevo Sol"),
    ("PGK", "Papua New Guinean Kina"),
    ("PHP", "Philippine Peso"),
    ("PKR", "Pakistani Rupee"),
    ("PLN", "Polish Zloty"),
    ("PYG", "Paraguayan Guarani")],
    [("QAR", "Qatari Rial")],
    [("RON", "Romanian Leu"),
    ("RSD", "Serbian Dinar"),
    ("RUB", "Russian Ruble"),
    ("RWF", "Rwandan Franc")],
    [("SAR", "Saudi Riyal"),
    ("SBD", "Solomon Islands Dollar"),
    ("SCR", "Seychellois Rupee"),
    ("SDG", "Sudanese Pound"),
    ("SEK", "Swedish Krona"),
    ("SGD", "Singapore Dollar"),
    ("SHP", "Saint Helena Pound"),
    ("SLL", "Sierra Leonean Leone"),
    ("SOS", "Somali Shilling"),
    ("SRD", "Surinamese Dollar"),
    ("STD", "Sao Tome Dobra"),
    ("SVC", "Salvadoran colón"),
    ("SYP", "Syrian Pound"),
    ("SZL", "Swazi Lilangeni")],
    [("THB", "Thai Baht"),
    ("TJS", "Tajikistani Somoni"),
    ("TMT", "Turkmenistani Manat"),
    ("TND", "Tunisian Dinar"),
    ("TOP", "Tongan Pa'Anga"),
    ("TRY", "Turkish Lira"),
    ("TTD", "Trinidad and Tobago Dollar"),
    ("TWD", "New Taiwan Dollar"),
    ("TZS", "Tanzanian Shilling")],
    [("UAH", "Ukrainian Hryvnia"),
    ("UGX", "Ugandan Shilling"),
    ("USD", "United States Dollar"),
    ("UYU", "Uruguayan Peso"),
    ("UZS", "Uzbekistan Som")],
    [("VEF", "Venezuelan Bolivar"),
    ("VND", "Vietnamese Dong"),
    ("VUV", "Vanuatu Vatu")],
    [("WST", "Samoan Tala")],
    [("XAF", "CFA Franc BEAC"),
    ("XAG", "Silver (troy ounce)"),
    ("XAU", "Gold (troy ounce)"),
    ("XCD", "East Caribbean Dollar"),
    ("XDR", "Special Drawing Rights"),
    ("XOF", "West African CFA franc"),
    ("XPF", "CFP Franc")],
    [("YER", "Yemeni Rial")],
    [("ZAR", "South African Rand"),
    ("ZMK", "Zambian Kwacha (pre-2013)"),
    ("ZMW", "Zambian Kwacha"),
    ("ZWL", "Zimbabwean Dollar")]]

var historyArray = ["Select","Select"]
var numberOfTimesLaunched = 0

var homeViewInterstitial: GADInterstitial!
var searchViewInterstitial: GADInterstitial!
var conversionViewInterstitial: GADInterstitial!

func createAndLoadInterstitial(_ adID: String) -> GADInterstitial {
    let interstitial = GADInterstitial(adUnitID: adID)
    interstitial.load(GADRequest())
    return interstitial
}

var expiryDate: Date?

var startAppAdHomeInterstitial: STAStartAppAd?
var startAppAdConversionViewInterstitial: STAStartAppAd?
var startAppHomeInterstitialPresented = false
var startAppConversionViewPresented = false
var startAppHomeAlreadyLoaded=false
var startAppConversionAlreadyLoaded=false
var admobHomeInterstitialAlreadyLoaded=false
var admobConversionInterstitalAlreadyLoaded=false

class FetchValues: UIViewController, GADInterstitialDelegate, SKProductsRequestDelegate, STADelegateProtocol{
    
    let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
   
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    
    @IBOutlet weak var loadingScreenActivityIndicator: UIActivityIndicatorView!
    
    var productsRequest = SKProductsRequest()
    
    func fetchAvailableProducts()
    {
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: autoRenewableProduct)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error)
    {
        print(request)
        print(error)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        if calledFromBackground{
            calledFromBackground=false
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.startFetching()
            }
        }
        else if calledFromSubscription{
            calledFromSubscription=false
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.startFetching()
            }
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         start = DispatchTime.now()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        prevDate = dateFormatter.string(from: previousDay!)
        
        dateFormatter2.dateFormat = "dd MMM yyyy"
        yesterday = dateFormatter2.string(from: previousDay!)
        
        today = dateFormatter2.string(from: Date())
        self.fetchAvailableProducts()
        
        startFetching()
        
        startAppAdHomeInterstitial = STAStartAppAd()
        startAppAdConversionViewInterstitial = STAStartAppAd()
    }
    

    
    func startFetching(){
        
        premiumSubscriptionPurchased = UserDefaults.standard.bool(forKey: "premiumSubscriptionPurchased")
        
        loadingScreenActivityIndicator.startAnimating()
        let networkStatus = CheckNetwork()
        if (networkStatus.connectedToNetwork()){
    
            numberOfTimesLaunched = UserDefaults.standard.integer(forKey: "numberOfTimesLaunched")
            print("Number of time launched: \(numberOfTimesLaunched)")
            UserDefaults.standard.setValue(numberOfTimesLaunched+1, forKey: "numberOfTimesLaunched")
            
            localNotification()
            
            receiptValidation { (receiptValidated) in
                if !premiumSubscriptionPurchased{
                    if numberOfTimesLaunched>1{
                        if !admobHomeInterstitialAlreadyLoaded{
                            admobHomeInterstitialAlreadyLoaded=true
                            print("Ad loading from startFetching Block - Admob Home")
                            homeViewInterstitial = createAndLoadInterstitial("ca-app-pub-4235447962727236/4167850341")
                        }
                        
                        print("Ad loading from startFetching Block - StartApp Home")
                        DispatchQueue.main.async {
                            startAppAdHomeInterstitial!.load(withDelegate: self)
                        }
                    }
                }
                UserDefaults.standard.set(premiumSubscriptionPurchased, forKey: "premiumSubscriptionPurchased")
            }
            self.fetchJasonOfYesterday(prevDate)
            self.fetchJasonOfToday(){ (success2) in
                if (success2==true){
                    self.performSegue(withIdentifier: "Enter", sender: nil)
                    self.loadingScreenActivityIndicator.stopAnimating()
                }
            }
        }
        else{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Network Error", message: "Please check your internet conncetion and try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        self.startFetching()
                        
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
    
    
    func fetchJasonOfYesterday(_ pDate: String){//, completion:@escaping (Bool)->Void){

        let jsonURL = "https://apilayer.net/api/historical?access_key=7e4329ef9daa6adce5d7775a6719bcb4&date=\(pDate)&source=USD"
   
        guard let url = URL(string: jsonURL) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                return
            }
            do{
                let values = try
                    JSONDecoder().decode(Currency.self, from: data)
                storedValuesPrevious = values
    
            } catch _{
                print("Unable to fetch yesterday's data")
            }
        }
        task.resume()
    }
    
    
    func fetchJasonOfToday(completion:@escaping (Bool)->Void){
        var success2=false
        let jsonURL = "https://apilayer.net/api/live?access_key=7e4329ef9daa6adce5d7775a6719bcb4&source=USD"
   
        guard let url = URL(string: jsonURL) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                return
            }
            do{
                let values = try
                    JSONDecoder().decode(Currency.self, from: data)
                storedValuesCurrent = values
                lastUpdated = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
                DispatchQueue.main.async {
                    success2=true
                    completion(success2)
                }
            } catch _{
                print("Unable to fetch today's data")
            }
        }
        task.resume()
    }
    
    
    
    func fetchJasonOfYesterdayCustom(_ pDate: String, completion:@escaping (Bool)->Void){
        var success1=true
        let jsonURL = "https://apilayer.net/api/historical?access_key=7e4329ef9daa6adce5d7775a6719bcb4&date=\(pDate)&source=USD"
        guard let url = URL(string: jsonURL) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                return
            }
            do{
                let values = try
                    JSONDecoder().decode(Currency.self, from: data)
                storedValuesPreviousCustom = values
                DispatchQueue.main.async {
                    success1=true
                    completion(success1)
                }
                
            } catch _{
                print("Unable to fetch yesterday's data")
            }
        }
        task.resume()
    }
    
    func localNotification(){
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        // Step 2: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Hey, the latest rates are here!"
        content.body = "Change is the only constant in life, did you check the latest Forex rates?"
        
        // Step 3: Create the notification trigger
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        // Step 4: Create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Step 5: Register the request
        center.add(request) { (error) in
            // Check the error parameter and handle any errors
        }
    }
    
    //StartApp Delegate
    func didClose(_ ad: STAAbstractAd!) {
        if !premiumSubscriptionPurchased{
            if startAppHomeInterstitialPresented{
                startAppHomeInterstitialPresented=false
                startAppHomeAlreadyLoaded=true
                startAppAdHomeInterstitial!.load(withDelegate: self)
                print("StartApp Home Interstitial Dismissed and reloaded")
            }
        }
    }
    
    func failedLoad(_ ad: STAAbstractAd!, withError error: Error!) {
        print("Failed to load StartAppInterstitial")
        startAppHomeAlreadyLoaded=false
    }
    
    
}


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Double{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        return mapToDevice(identifier: identifier)
    }()
}

extension UIButton {
    
    func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
    
}


func receiptValidation(completion: @escaping (Bool)->Void) {
    var receiptVerified = false
    let receiptFileURL = Bundle.main.appStoreReceiptURL
    let receiptData = try? Data(contentsOf: receiptFileURL!)
    guard let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))else {
        receiptVerified = true
        completion(receiptVerified)
        return
    }
    let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString as AnyObject, "password" : "9f4e2f62956a49499f00114af3793ffb" as AnyObject]
    
    do {
        let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let storeURL = URL(string: verifyReceiptURL)!
        var storeRequest = URLRequest(url: storeURL)
        storeRequest.httpMethod = "POST"
        storeRequest.httpBody = requestData
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: storeRequest, completionHandler: { /*[weak self]*/ (data, response, error) in
            
            do {
                
                guard let receivedData = data else{
                    print("Receipt not received")
                    receiptVerified = true
                    completion(receiptVerified)
                    return
                }
                
                let jsonResponse = try JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.mutableContainers)
                //  print("=======>",jsonResponse)
                if let expiryDate = getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                    let formatterForReceipt = DateFormatter()
                    formatterForReceipt.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                    let temp = formatterForReceipt.string(from: Date())
                    let latestDay = formatterForReceipt.date(from: temp)
                    //                        print("Today's Date: \(latestDay!)")
                    //                        print("ExpiryDate: \(expiryDate)")
                    
                    if expiryDate.compare(latestDay!) == .orderedDescending{
                        print("Valid")
                        premiumSubscriptionPurchased = true
                        UserDefaults.standard.set(premiumSubscriptionPurchased, forKey: "premiumSubscriptionPurchased")
                        restoreStatus = true
                    }
                    else if expiryDate.compare(latestDay!) == .orderedSame{
                        print("Valid")
                        premiumSubscriptionPurchased = true
                        UserDefaults.standard.set(premiumSubscriptionPurchased, forKey: "premiumSubscriptionPurchased")
                        restoreStatus = true
                    }else{
                        print("InValid")
                        premiumSubscriptionPurchased = false
                        UserDefaults.standard.set(premiumSubscriptionPurchased, forKey: "premiumSubscriptionPurchased")
                        restoreStatus = false
                    }
                    receiptVerified = true
                    completion(receiptVerified)
                }else{
                    premiumSubscriptionPurchased = false
                    UserDefaults.standard.set(premiumSubscriptionPurchased, forKey: "premiumSubscriptionPurchased")
                    print("No Expiry Date found")
                    receiptVerified = true
                    completion(receiptVerified)
                }
            } catch let parseError {
                receiptVerified = true
                completion(receiptVerified)
                print(parseError)
            }
        })
        task.resume()
    } catch let parseError {
        receiptVerified = true
        completion(receiptVerified)
        print(parseError)
    }
    
    
   

}

func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
    
    if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
        let lastReceipt = receiptInfo.lastObject as! NSDictionary
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        if let expiresDate = lastReceipt["expires_date"] as? String {
            return formatter.date(from: expiresDate)
        }
        return nil
    }
    else {
        return nil
    }
}

    

