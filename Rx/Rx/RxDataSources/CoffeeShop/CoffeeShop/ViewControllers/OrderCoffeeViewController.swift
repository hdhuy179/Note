//
//  OrderCoffeeViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 24.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderCoffeeViewController: BaseViewController {
    @IBOutlet private weak var coffeeIconImageView: UIImageView!
    @IBOutlet private weak var coffeeNameLabel: UILabel!
    @IBOutlet private weak var coffeePriceLabel: UILabel!
    @IBOutlet private weak var orderCountLabel: UILabel!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var totalPrice: UILabel!
    @IBOutlet private weak var addToCartButton: UIButton!
    
    private let bag = DisposeBag()
    
    var coffee: Coffee!
    var totalOrderObs = BehaviorRelay<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateUI()
        rxSetup()
    }
    
    private func populateUI() {
        guard let coffee = coffee else { return }
        
        coffeeNameLabel.text = coffee.name
        coffeeIconImageView.image = UIImage(named: coffee.icon)
        coffeePriceLabel.text = CurrencyFormatter.turkishLirasFormatter.string(from: coffee.price)
    }
    
    private func rxSetup() {
        totalOrderObs.bind(onNext: { [weak self] in
            self?.orderCountLabel.text = "\($0)"
            self?.totalPrice.text = CurrencyFormatter.turkishLirasFormatter.string(from: Float($0) * (self?.coffee.price ?? 0))
        }).disposed(by: bag)
        
        Observable
            .of(addButton.rx.tap.map { true }, removeButton.rx.tap.map { false })
            .merge()
            .bind { [weak self] isAdd in
                if isAdd {
                    self?.totalOrderObs.accept((self?.totalOrderObs.value ?? 0) + 1)
                } else {
                    guard self?.totalOrderObs.value ?? 0 > 0 else { return }
                    
                    self?.totalOrderObs.accept((self?.totalOrderObs.value ?? 0) - 1)
                }
        }.disposed(by: bag)
        
        addToCartButton.rx.tap.bind(onNext: { [weak self] in
            guard let coffee = self?.coffee, let value = self?.totalOrderObs.value else { return }
            
            ShoppingCart.shared.addCoffee(coffee, withCount: value)
            
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
}
