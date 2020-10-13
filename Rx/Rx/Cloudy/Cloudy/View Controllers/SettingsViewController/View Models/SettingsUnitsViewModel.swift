//
//  SettingsUnitsViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit
//sourcery: AutoMockable
protocol SettingsUnitsViewModelAbstract {
    var text: String { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
}
struct SettingsUnitsViewModel: SettingsUnitsViewModelAbstract {

    // MARK: - Properties

    let unitsNotation: UnitsNotation

    // MARK: - Public API

    var text: String {
        switch unitsNotation {
        case .imperial: return "Imperial"
        case .metric: return "Metric"
        }
    }

    var accessoryType: UITableViewCell.AccessoryType {
        if UserDefaults.unitsNotation == unitsNotation {
            return .checkmark
        } else {
            return .none
        }
    }
    
}

extension SettingsUnitsViewModel: SettingsPresentable {

}
