//
//  SettingsTemperatureViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit
//sourcery: AutoMockable
protocol SettingsTemperatureViewModelAbstract {
    var text: String { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
}
struct SettingsTemperatureViewModel: SettingsTemperatureViewModelAbstract {

    // MARK: - Properties

    let temperatureNotation: TemperatureNotation

    // MARK: - Public Interface

    var text: String {
        switch temperatureNotation {
        case .fahrenheit: return "Fahrenheit"
        case .celsius: return "Celsius"
        }
    }

    var accessoryType: UITableViewCell.AccessoryType {
        if UserDefaults.temperatureNotation == temperatureNotation {
            return .checkmark
        } else {
            return .none
        }
    }
    
}

extension SettingsTemperatureViewModel: SettingsPresentable {

}
