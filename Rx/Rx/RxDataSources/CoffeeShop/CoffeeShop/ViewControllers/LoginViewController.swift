//
//  LoginViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 23.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var logInButton: UIButton!
    
    private let bag = DisposeBag()
    private let throttleInterval = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rxSetup()
    }
    
    private func rxSetup() {
        
        let emailValid = emailTextfield
            .rx
            .text
            .orEmpty
            .throttle(throttleInterval, scheduler: MainScheduler.instance)
            .map {[weak self] in self?.validateEmail(with: $0) ?? false}
            .debug("emailValid", trimOutput: true)
            .share(replay: 0)
        
        let passwordValid = passwordTextfield
            .rx
            .text
            .orEmpty
            .throttle(throttleInterval, scheduler: MainScheduler.instance)
            .map { $0.count >= 6}
            .debug("passwordValid", trimOutput: true)
            .share(replay: 0)
        
        let everythingValid = Observable
            .combineLatest(emailValid, passwordValid) { $0 && $1}
            .debug("everythingValid", trimOutput: true)
            .share()
        
//        everythingValid.bind(to: logInButton.rx.isEnabled).disposed(by: bag)
        
        logInButton.rx.tap.bind {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = mainStoryboard.instantiateInitialViewController()!
            
            UIApplication.changeRoot(with: initialViewController)
        }.disposed(by: bag)
    }
    
    private func validateEmail(with email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", email)
        
        return predicate.evaluate(with: emailPattern)
    }
}
