//
//  CurrencyCell.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 13/6/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit

protocol TableCellProtocol {
    func insertNewRow(index: Int)
    func reloadData()
    func performPushSegue()
    func performShowDetailSegue(index: Int)
   
}

enum errors: Error{
    case baseCurrencyAmountFieldEmpty
}


class CurrencyCell: UITableViewCell{
    
    @IBOutlet weak var convertedValue: UILabel!
    @IBOutlet weak var currencyAttributesStackWidth: NSLayoutConstraint!
    @IBOutlet weak var currentValueHeading: UILabel!
    @IBOutlet weak var changeHeading: UILabel!
    @IBOutlet weak var conversionStack: UIStackView!
    @IBOutlet weak var currencyFullForm: UILabel!
    @IBAction func percentButtonClicked(_ sender: Any) {
        if !sharingEnabled{
             cellDelegate?.performShowDetailSegue(index: index!.row)
        }
       
    }
    @IBOutlet weak var currencyLabel: UILabel!
 
    @IBOutlet weak var currencyAttributesStackView: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var currencyButtonPosition: NSLayoutConstraint!
    @IBOutlet weak var percentValue: UIButton!
    @IBOutlet weak var hint: UILabel!
    @IBAction func addButtonClicked(_ sender: Any) {
        calledFrom = "addButton"
        selectedArrayIndex = index!.row
        print(selectedArrayIndex)
        cellDelegate?.performPushSegue()
    }
    @IBAction func currencyButtonClicked(_ sender: Any) {
        calledFrom="currencyButton"
        selectedArrayIndex = index!.row
        print(selectedArrayIndex)
        if !sharingEnabled{
             cellDelegate?.performPushSegue()
        }
       
    }
    
    var currencyName: String = ""
    var currencySelected: Bool = true
    var cellDelegate: TableCellProtocol?
    var index: IndexPath?
    var tableView: CurrencyTable?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
               } 
        currencyAttributesStackView.isHidden = true
        currencyLabel.isHidden=true
        doneButton.isHidden = true
        convertedValue.layer.cornerRadius = convertedValue.frame.size.height/2
        convertedValue.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func calculateValue(_ baseCurr: String, _ targetCurr: String){
        let loadCurrencyValue = LoadCurrencyValues()
        let (cValue,pValue) = loadCurrencyValue.loadCurrencyValue(baseCurr, targetCurr,storedValuesCurrent,storedValuesPrevious)
        self.currencyButton.setImage(UIImage(data:selectedCurrencies[index!.row].image), for: .normal)
        self.currencyLabel.text!=selectedCurrencies[index!.row].currName
        self.currentValue.text = String(format: "%.4f",cValue)
        self.currencyConversion()
        let cPercent = ((cValue - pValue ) / pValue) * 100
        self.formatButton(percentValue, cPercent)
    }
    
    func formatButton(_ button: UIButton?, _ percentage: Float){
        button?.layer.cornerRadius = 5
        print(percentage)
        if baseCurrencyName.currName != selectedCurrencies[index!.row].currName{
            if percentage < 0.00{
                button?.setTitle(" -"+String(format: "%.2f", abs(percentage))+"% "+" ", for: .normal)
                button?.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                button?.layer.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                button?.isHidden=false
            }
            else if percentage > 0.00{
                button?.setTitle(" +"+String(format: "%.2f", percentage)+"% "+" ", for: .normal)
                button?.layer.borderColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
                button?.layer.backgroundColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
                button?.isHidden=false
            }
            else{
                button?.setTitle(" "+String(format: "%.2f", percentage)+"% "+" ", for: .normal)
                button?.layer.borderColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
                button?.layer.backgroundColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
                button?.isHidden=false
            }
        }
        else{
                button?.setTitle(" "+String(format: "%.2f", percentage)+"% "+" ", for: .normal)
                button?.layer.borderColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
                button?.layer.backgroundColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
                button?.isHidden=false
        }
    }
    
    func setTime(_ timeStamp: UILabel){
        timeStamp.isHidden = false
        timeStamp.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
    
    @objc func currencyConversion(){
        if baseCurrencyAmountGlobal != "" && baseCurrencyAmountGlobal != "."{
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.numberStyle = .decimal
            let value = numberFormatter.string(from: NSNumber(value: Double(self.currentValue.text!)!*Double(baseCurrencyAmountGlobal)!))
            self.convertedValue.text = selectedCurrencies[index!.row].symbol + " " + value!
        }
        else{
            self.convertedValue.text = selectedCurrencies[index!.row].symbol
        }
    }
}
