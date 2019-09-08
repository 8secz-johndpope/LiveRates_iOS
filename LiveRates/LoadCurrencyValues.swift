//
//  LoadValues.swift
//  Money Matter
//
//  Created by Aruna Sairam Manjunatha on 26/5/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import Foundation
import UIKit

class LoadCurrencyValues{
    
    var currentCurrencyValue1: Float = 0.0
    var currentCurrencyValue2: Float = 0.0
    var currentCurrencyResult: Float = 0.0
    
    var previousCurrencyValue1: Float = 0.0
    var previousCurrencyValue2: Float = 0.0
    var previousCurrencyResult: Float = 0.0
    
    func loadCurrencyValue(_ base: String, _ symbole: String, _ storedStructureCurrent: Currency, _ storedStructurePrevious: Currency )->(Float,Float){
        let baseCurrency = "USD"+base
        let targetCurrency = "USD"+symbole
        for (keys,values) in storedStructureCurrent.quotes{
            if keys == baseCurrency{
                currentCurrencyValue1 = values
                break
            }
        }
        for (keys,values) in storedStructureCurrent.quotes{
            if keys == targetCurrency{
                currentCurrencyValue2 = values
                break
            }
        }
        currentCurrencyResult = (1/currentCurrencyValue1) * currentCurrencyValue2
        for (keys,values) in storedStructurePrevious.quotes{
            if keys == baseCurrency{
                previousCurrencyValue1 = values
                break
            }
        }
        for (keys,values) in storedStructurePrevious.quotes{
            if keys == targetCurrency{
                previousCurrencyValue2 = values
                break
            }
        }
        previousCurrencyResult = (1/previousCurrencyValue1) * previousCurrencyValue2
       // let percent = calculatePercent(currentCurrencyResult, previousCurrencyResult)
        return (currentCurrencyResult,previousCurrencyResult)//,percent)
    }
//    func calculatePercent(_ currentCurrencyResult: Float, _ previousCurrencyResult: Float)->(Float){
//        var percent: Float = 0.00
//            percent = ((currentCurrencyResult - previousCurrencyResult ) / previousCurrencyResult) * 100
//            return percent
//    }
    
}
