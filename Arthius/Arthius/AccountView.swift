//
//  AccountView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/25/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AccountViewDelegate: class {
    func account_pressBack()
    func account_isLoggedIn() -> Bool
    func account_signUp(email: String, password: String)
    func account_signIn(email: String, password: String)
}

class AccountView : UIView {
    
    weak var accountDelegate : AccountViewDelegate?
    
    var titleLabel : Label!;
    var backButton : Button!;
    
    var signedInView : SignedInView!;
    var signUpView : SignUpView!;
    var signInView : SignInView!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        
        titleLabel = Label(frame: propToRect(prop: CGRect(x: 0.5, y: 0.05, width: 0.4, height: 0.15)), text: "Account", _outPos: propToPoint(prop: CGPoint(x: 1, y: 0.05)), textColor: UIColor.black, valign: .Bottom, _insets: false)
        titleLabel.font = UIFont(name: "SFProText-Heavy", size: Screen.fontSize(propFontSize: 70))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .right
        self.addSubview(titleLabel)

        
        backButton = Button(frame: propToRect(prop:  CGRect(x: 0, y: 0, width: 0.1, height: 0.1)), text: "back")
        backButton.pressed = {
            self.accountDelegate?.account_pressBack()
        }
        self.addSubview(backButton)
        
        let subViewFrame = propToRect(prop: CGRect(x: 0, y: 0.25, width: 1, height: 0.75))
        signedInView = SignedInView(frame: subViewFrame)
        signedInView.signOutButtonPressed = {
            
            do{
                try Auth.auth().signOut()
                self.updateView()
            }catch{
                
            }
            
        }
        
        signUpView = SignUpView(frame: subViewFrame)
        signUpView.signInButtonPressed = {
            self.showSignInView()
        }
        signUpView.signedUp = {
            self.updateView()
        }
        
        signInView = SignInView(frame: subViewFrame)
        signInView.signInButtonPressed = {
            self.updateView()
        }
    }
    
    func removeAll(){
        func removeView(view: UIView, after: CGFloat){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(after), execute: {
                view.removeFromSuperview()
            })
        }
        
        
//        signedInView.animateOut()
//        signUpView.animateOut()
//        signInView.animateOut()
        
        signedInView.removeFromSuperview()
        signUpView.removeFromSuperview()
        signInView.removeFromSuperview()
        
//        removeView(view: signedInView, after: 0)
//        removeView(view: signUpView, after: 0)
//        removeView(view: signInView, after: 0)
    }
    
    func showSignedInView(){
        removeAll()
        self.addSubview(signedInView)
        signedInView.animateIn()
    }
    
    func showSignUpView(){
        removeAll()
        self.addSubview(signUpView)
        signUpView.animateIn()
    }
    
    func showSignInView(){
        removeAll()
        self.addSubview(signInView)
        signInView.animateIn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn(){
        backButton.animateIn()
        titleLabel.animateIn()
        
        updateView()
    }
    func updateView(){
        
        if(accountDelegate?.account_isLoggedIn())!{
            //            self.addSubview(signedInView)
            signedInView.update()
            showSignedInView()
        }else{
            //            self.addSubview(signUpView)
            showSignUpView()
        }
    }
    func animateOut(){
        backButton.animateOut()
        titleLabel.animateOut()
    }
}

class SignedInView : UIView{
    
    var usernameLabel: Label!
    var publishedLevels: Label!;
    var totalDownloads: Label!
    var signOutButton: Button!;
    var docRef : DocumentReference!;

    var signOutButtonPressed = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //username
        usernameLabel = Label(frame: Screen.propToRect(prop: CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.1), within: self.frame), text: "", _outPos: Screen.propToRect(prop: CGRect(x: -0.1, y: 0.1, width: 0, height: 0), within: self.frame).origin, textColor: UIColor.black, valign: VAlign.Default, _insets: false)
        usernameLabel.backgroundColor = UIColor.gray
        self.addSubview(usernameLabel)
        
        //published levels
        publishedLevels = Label(frame: Screen.propToRect(prop: CGRect(x: 0.1, y: 0.25, width: 0.8, height: 0.1), within: self.frame), text: "", _outPos: Screen.propToRect(prop: CGRect(x: -0.1, y: 0.1, width: 0, height: 0), within: self.frame).origin, textColor: UIColor.black, valign: VAlign.Default, _insets: false)
        publishedLevels.backgroundColor = UIColor.gray
        self.addSubview(publishedLevels)
        
        //total downloads
        totalDownloads = Label(frame: Screen.propToRect(prop: CGRect(x: 0.1, y: 0.4, width: 0.8, height: 0.1), within: self.frame), text: "", _outPos: Screen.propToRect(prop: CGRect(x: -0.1, y: 0.1, width: 0, height: 0), within: self.frame).origin, textColor: UIColor.black, valign: VAlign.Default, _insets: false)
        totalDownloads.backgroundColor = UIColor.gray
        self.addSubview(totalDownloads)
        
        //sign out button
        signOutButton = Button(frame: Screen.propToRect(prop: CGRect(x: 0.1, y: 0.7, width: 0.8, height: 0.1), within: self.frame), text: "sign out", outPos: Screen.propToRect(prop: CGRect(x: -1, y: 0.7, width: 0, height: 0), within: self.frame).origin)
        signOutButton.pressed = {
            self.signOutButtonPressed()
        }
        self.addSubview(signOutButton)
    }
    
    func update(){
        docRef = db.collection("users").document((Auth.auth().currentUser?.uid)!);
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let data = document.data()!
            print("Current data: \(String(describing: data)) \(String(describing: Auth.auth().currentUser?.uid)) \(data["stats"] as! [String: Any])")
            self.usernameLabel.text = data["username"] as? String;
            
            var stats = data["stats"] as! [String: Any]
            self.publishedLevels.text = "\(String(describing: stats["publishedCount"]!))";
            self.totalDownloads.text = "\(String(describing: stats["totalDownloadsCount"]!))";

        }
    }
    
    func animateIn(){
        usernameLabel.animateIn()
        publishedLevels.animateIn()
        totalDownloads.animateIn()
        
        signOutButton.animateIn()
    }
    
    func animateOut(){
        usernameLabel.animateOut()
        publishedLevels.animateOut()
        totalDownloads.animateOut()
        
        signOutButton.animateOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SignUpView : UIView, UITextFieldDelegate{
    
    var emailField : TextField!;
    var usernameField : TextField!;
    var passwordField : TextField!;
    var signUpButton : Button!;
    var signInButton : Button!;
    
    var signedUp = {}
    var signInButtonPressed = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //email
        emailField = TextField(frame: propToRect(prop: CGRect(x: 0.1, y: 0.05, width: 0.8, height: 0.1), within: self.frame))
        emailField.delegate = self
        emailField.backgroundColor = UIColor.gray
        self.addSubview(emailField)
        
        //username
        usernameField = TextField(frame: propToRect(prop: CGRect(x: 0.1, y: 0.2, width: 0.8, height: 0.1), within: self.frame))
        usernameField.delegate = self
        usernameField.backgroundColor = UIColor.gray
        self.addSubview(usernameField)
        
        //password
        passwordField = TextField(frame: propToRect(prop: CGRect(x: 0.1, y: 0.35, width: 0.8, height: 0.1), within: self.frame))
        passwordField.delegate = self
        passwordField.backgroundColor = UIColor.gray
        self.addSubview(passwordField)
        
        
        //sign up button
        signUpButton = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0.5, width: 0.8, height: 0.1), within: self.frame), text: "sign up", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToPoint(prop: CGPoint(x: -1, y: 0.5)))
        signUpButton.pressed = {
            Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user, error) in
                print("created user \(String(describing: user?.email)) \(String(describing: user?.displayName)) \(String(describing: user?.uid)) \(String(describing: user?.photoURL?.absoluteString))")
                db.collection("users").document((user?.uid)!).setData(["username":self.usernameField.text!, "stats":["publishedCount":0, "totalDownloadsCount":0]])
                self.signedUp()
            })
        }
        self.addSubview(signUpButton)
        
        //sign in button
        
        signInButton = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0.75, width: 0.8, height: 0.1), within: self.frame), text: "sign in", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToPoint(prop: CGPoint(x: -1, y: 0.5)))
        signInButton.pressed = {
            self.signInButtonPressed()
        }
        self.addSubview(signInButton)
    }
    
    func animateIn(){
        signUpButton.animateIn()
        signInButton.animateIn()
    }
    
    func animateOut(){
        signUpButton.animateOut()
        signInButton.animateIn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SignInView : UIView, UITextFieldDelegate{
    
    var emailField : TextField!;
    var passwordField : TextField!;
    var signInButton : Button!;
    var signInButtonPressed = {}

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //email
        //email
        emailField = TextField(frame: propToRect(prop: CGRect(x: 0.1, y: 0.05, width: 0.8, height: 0.1), within: self.frame))
        emailField.delegate = self
        emailField.backgroundColor = UIColor.gray
        self.addSubview(emailField)
  
        //password
        passwordField = TextField(frame: propToRect(prop: CGRect(x: 0.1, y: 0.35, width: 0.8, height: 0.1), within: self.frame))
        passwordField.delegate = self
        passwordField.backgroundColor = UIColor.gray
        self.addSubview(passwordField)
        
        //sign in button
        signInButton = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0.75, width: 0.8, height: 0.1), within: self.frame), text: "sign in", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToPoint(prop: CGPoint(x: -1, y: 0.5)))
        signInButton.pressed = {
            self.signInButtonPressed()
            
            Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user, error) in
                self.signInButtonPressed()
            });
        }
        self.addSubview(signInButton)
    }
    
    func animateIn(){
        signInButton.animateIn()
    }
    
    func animateOut(){
        signInButton.animateOut()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
