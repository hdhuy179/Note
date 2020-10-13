//
//  MenuViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 23.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class MenuViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var srbCoffee: UISearchBar!
    
    private let bag = DisposeBag()
    
    private lazy var shoppingCartButton: BadgeBarButtonItem = {
        let button = BadgeBarButtonItem(image: "cart_menu_icon", badgeText: nil, target: self, action: #selector(shoppingCartButtonPressed))
        
        button!.badgeButton!.tintColor = Colors.brown
        
        return button!
    }()
    
//    private lazy var coffees: Observable<[SectionModel<string>]> = {
//        let espresso = Coffee(name: "Espresso", icon: "espresso", price: 4.5)
//        let cappuccino = Coffee(name: "Cappuccino", icon: "cappuccino", price: 11)
//        let macciato = Coffee(name: "Macciato", icon: "macciato", price: 13)
//        let mocha = Coffee(name: "Mocha", icon: "mocha", price: 8.5)
//        let latte = Coffee(name: "Latte", icon: "latte", price: 7.5)
//        return .just(SectionModel(model: "section 1", items: [espresso, cappuccino, macciato, mocha, latte]))
////        return .just([[espresso, cappuccino, macciato, mocha, latte],[espresso, cappuccino, macciato, mocha, latte]])
//    }()
    
    private lazy var coffees: Observable<[SectionModel<String, Coffee>]> = {
        
            let espresso = Coffee(name: "Espresso", icon: "espresso", price: 4.5)
            let cappuccino = Coffee(name: "Cappuccino", icon: "cappuccino", price: 11)
            let macciato = Coffee(name: "Macciato", icon: "macciato", price: 13)
            let mocha = Coffee(name: "Mocha", icon: "mocha", price: 8.5)
            let latte = Coffee(name: "Latte", icon: "latte", price: 7.5)
            return .just([SectionModel(model: "section 1", items: [espresso, cappuccino, macciato, mocha, latte]), SectionModel(model: "section 2", items: [espresso, cappuccino, macciato, mocha, latte])])
        
    //        return .just([[espresso, cappuccino, macciato, mocha, latte],[espresso, cappuccino, macciato, mocha, latte]])
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = shoppingCartButton
        configureTableView()
        rxSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let totalOrderCount = ShoppingCart.shared.getTotalCount()
        
        totalOrderCount.bind{ [weak self] in
            self?.shoppingCartButton.badgeText = $0 != 0 ? "\($0)" : nil
        }.disposed(by: bag)
    }
    
    private func configureTableView() {
        
//        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.rowHeight = 104
    }
    
    private func rxSetup() {
        
        
        let dataSources = RxTableViewSectionedReloadDataSource<SectionModel<String, Coffee>> (configureCell: { (dataSource, tableView, indexPath, coffee) -> CoffeeCell in
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: "coffeeCell", for: indexPath) as? CoffeeCell else { fatalError()}
            cell.configure(with: coffee)
            return cell
        })
        
        dataSources.titleForHeaderInSection = { datasource, indexPath in
            return dataSources.sectionModels[indexPath].model
        }
        coffees.bind(to: tableView.rx.items(dataSource: dataSources)).disposed(by: bag)
        tableView.sectionHeaderHeight = 50
        
//        coffees.asObservable().bind(to: tableView.rx.items(cellIdentifier: "coffeeCell", cellType: CoffeeCell.self)) {row, coffee, cell in
//            cell.configure(with: coffee)
//        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Coffee.self).subscribe(onNext: { [weak self] coffee in
            self?.performSegue(withIdentifier: "OrderCofeeSegue", sender: coffee)
            
            if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }).disposed(by: bag)
    }
    
    @objc private func shoppingCartButtonPressed() {
        performSegue(withIdentifier: "ShowCartSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let coffee = sender as? Coffee else { return }
        
        if segue.identifier == "OrderCofeeSegue" {
            if let viewController = segue.destination as? OrderCoffeeViewController {
                viewController.coffee = coffee
                viewController.title = coffee.name
            }
        }
    }
}

//extension MenuViewController: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 104
//  }
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//
//    guard indexPath.row < coffees.count else { return }
//
//    performSegue(withIdentifier: "OrderCofeeSegue", sender: coffees[indexPath.row])
//  }
//}
//
//extension MenuViewController: UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return coffees.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    if let cell = tableView.dequeueReusableCell(withIdentifier: "coffeeCell", for: indexPath) as? CoffeeCell {
//      cell.configure(with: coffees[indexPath.row])
//
//      return cell
//    }
//
//    return UITableViewCell()
//  }
//}
