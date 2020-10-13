//
//  LocationTableViewCell.swift
//  Cloudy
//
//  Created by Bart Jacobs on 10/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var mainLabel: UILabel!

    // MARK: - Configuration

    func configure(withViewModel viewModel: LocationRepresentable) {
        // Configure Main Label
        mainLabel.text = viewModel.text
    }

}
