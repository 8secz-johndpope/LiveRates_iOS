//
//  FaceIDAndTouchIDViewController.swift
//  LiveRates
//
//  Created by Aruna Sairam Manjunatha on 2/6/19.
//  Copyright © 2019 Aruna Sairam Manjunatha. All rights reserved.
//

import UIKit
import LocalAuthentication

class FaceIDAndTouchIDViewController: UIViewController {
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        faceID_touchID()
    }
    
    let context:LAContext = LAContext()
    override func viewDidLoad() {
        super.viewDidLoad()
        faceID_touchID()
         self.loginButton.isHidden=true
        
    }
    func faceID_touchID(){
        loginButton.isHidden=true
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use your finger print to login", reply: {(wasCorrect,error) in
                if (wasCorrect)
                {
                    print("Correct")
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "homeScreenSegue", sender: nil)
                    }
                }
                else
                {
                    print("Incorrect")
                    self.loginButton.isHidden=false
                }
            })
        }
        else
        {
            print("Not Supported")
            self.loginButton.isHidden=false
        }
        
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
