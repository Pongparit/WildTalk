//
//  ViewController.swift
//  WildTalk
//
//  Created by Pongparit Paocharoen on 3/7/17.
//  Copyright © 2017 Pongparit Paocharoen. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    private var authListener: FIRAuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
       
        let facebookLogin = FBSDKLoginManager()
        print("Logging In")
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil { print("Facebook login failed. Error \(facebookError)")
            } else if (facebookResult?.isCancelled)! { print("Facebook login was cancelled.")
            } else {
                self.loginBtnOutlet.isHidden = true
                print("You’re in ;)")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    // ...
                    if let error = error {
                        print(error)
                        self.loginBtnOutlet.isHidden = false
                        return
                    }
                    self.authListen()
                }
            }
        })
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance().uiDelegate = self
        self.loginBtnOutlet.isHidden = false
        
        authListen()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loginBtnOutlet.isHidden = false
        authListen()

        
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAuth.auth()?.removeStateDidChangeListener(authListener!)
    }
    
    func authListen() {
        
        authListener = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.loginBtnOutlet.isHidden = true
                //                print(user)
                
                // Go to chat view controller.
                let nav = self.storyboard?.instantiateViewController(withIdentifier: "NavChatViewController") as! UINavigationController
                let chatVC = nav.viewControllers[0] as! ChatViewController
                chatVC.senderId = user.uid
                chatVC.senderDisplayName = user.displayName
                chatVC.avatarString = user.photoURL?.absoluteString ?? ""
                chatVC.title = "WildTalk"
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = nav
            }
        })

    }
    

}


//// MARK: - GIDSignInUIDelegate
//extension LoginViewController: GIDSignInUIDelegate {
//    
//}
