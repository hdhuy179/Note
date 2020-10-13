//
//  WeatherDayTableViewCell.swift
//  Cloudy
//
//  Created by Bart Jacobs on 02/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit

class WeatherDayTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        // Configure Cell
        selectionStyle = .none
    }

    // MARK: - Public API
    
    func configure(with presentable: WeatherDayPresentable) {
        // Configure Icon Image View
        iconImageView.image = presentable.image
        
        // Configure Labels
        dayLabel.text = presentable.day
        dateLabel.text = presentable.date
        windSpeedLabel.text = presentable.windSpeed
        temperatureLabel.text = presentable.temperature
    }
    
}
