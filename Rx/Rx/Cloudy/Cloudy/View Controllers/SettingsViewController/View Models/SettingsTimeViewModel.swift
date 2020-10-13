//
//  SettingsTimeViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit
//sourcery: AutoMockable
protocol SettingsTimeViewModelAbstract {
    var text: String { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
    func justTestFunction(str: String) -> String
}
struct SettingsTimeViewModel: SettingsTimeViewModelAbstract {

    // MARK: - Properties

    let timeNotation: TimeNotation

    // MARK: - Public API
    
    var text: String {
        switch timeNotation {
        case .twelveHour: return "12 Hour"
        case .twentyFourHour: return "24 Hour"
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        if UserDefaults.timeNotation == timeNotation {
            return .checkmark
        } else {
            return .none
        }
    }
    
    func justTestFunction(str: String) -> String {
        return "123"
    }

}

extension SettingsTimeViewModel: SettingsPresentable {

}
