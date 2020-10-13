//
//  ShoppingCartViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 25.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ShoppingCartViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        rxSetup()
    }
    
//    private func removeCartItem(at row: Int) {
//        guard row < cartItems.count else { return }
//        
//        ShoppingCart.shared.removeCoffee(cartItems[row].coffee)
//        
//        loadData()
//    }
    
    private func configureTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.rowHeight = 104
    }
    
    private func rxSetup() {
//        let cartItemObservable = ShoppingCart.shared.getCartItems()
//
//        cartItemObservable.bind(to: tableView.rx.items(cellIdentifier: "cartCoffeeCell", cellType: CartCoffeeCell.self)) { row, cartItem, cell in
//            cell.configure(with: cartItem)
//        }.disposed(by: bag)
        
//        tableView.rx.modelDeleted(CartItem.self).subscribe(onNext: { cartItem in
//            ShoppingCart.shared.removeCoffee(cartItem.coffee)
//        }).disposed(by: bag)
//
//        tableView.rx.modelDeleted(CartItem.self).subscribe(onNext: { cartItem in
//            ShoppingCart.shared.removeCoffee(cartItem.coffee)
//        }).disposed(by: bag)
        
        let cartSectionItemObservable = ShoppingCart.shared.getCartItems().map { listCart in
            return [AnimatableSectionModel(model: "1", items: listCart)]
        }
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CartItem>>(configureCell: { datasource, tableView, indexPath, cartItem in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCoffeeCell", for: indexPath) as? CartCoffeeCell else { fatalError()}
            cell.configure(with: cartItem)
            return cell
        })
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        tableView.rx.modelDeleted(CartItem.self).subscribe(onNext: { cartItem in
            ShoppingCart.shared.removeCoffee(cartItem.coffee)
        }).disposed(by: bag)
        
        
        tableView.rx.willDisplayCell.subscribe(onNext: { (cell, indexPath) in
            cell.alpha = 0
            let transform = CATransform3DTranslate(CATransform3DIdentity, -500, 200, 0)
            cell.layer.transform = transform
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                })
            }).disposed(by: bag)
        
        cartSectionItemObservable.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        
        ShoppingCart
            .shared
            .getTotalCost()
            .bind(onNext: { [weak self] in
                self?.totalPriceLabel.text = CurrencyFormatter.turkishLirasFormatter.string(from: $0)})
            .disposed(by: bag)
        
        
        
    }
}

//extension ShoppingCartViewController: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 104
//  }
//
//  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//    return true
//  }
//
//  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//    return .delete
//  }
//
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .delete {
//      removeCartItem(at: indexPath.row)
//      tableView.deleteRows(at: [indexPath], with: .fade)
//    }
//  }
//}
//
//extension ShoppingCartViewController: UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return cartItems.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    if let cell = tableView.dequeueReusableCell(withIdentifier: "cartCoffeeCell", for: indexPath) as? CartCoffeeCell {
//      cell.configure(with: cartItems[indexPath.row])
//
//      return cell
//    }
//
//    return UITableViewCell()
//  }
//}

