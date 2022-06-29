//
//  AnalyticDataCell.swift
//  WxForecast
//
//  Created by Chung EXI-Nguyen on 6/20/22.
//

import Foundation
import UIKit

class AnalyticDataCellViewModel {
    let dateService = DateService()
    func getDateOfWeekDisplay(_ dateString: String) -> String {
        dateService.getDateOfWeekDisplay(date: dateString)
    }
}

class AnalyticDataCell: UITableViewCell {
    var viewModel = AnalyticDataCellViewModel()
    
    lazy var dateLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var humidIcon: UIImageView = {
        return UIImageView()
    }()
    
    lazy var humidLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var dayConditionImageView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var nightConditionImageView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var dayTempLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var nightTempLabel: UILabel = {
        return UILabel()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupAutolayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        humidIcon.image = nil
        humidLabel.text = nil
        dayConditionImageView.image = nil
        nightConditionImageView.image = nil
        dayTempLabel.text = nil
        nightTempLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ analyticForecast: ForecastAnalytic) {
        dateLabel.text = viewModel.getDateOfWeekDisplay(analyticForecast.date)
        humidIcon.image = UIImage(named: analyticForecast.humid.humidType())
        humidLabel.text = "\(analyticForecast.humid)%"
        dayConditionImageView.image = UIImage(named: analyticForecast.dayCondition.rawValue)
        nightConditionImageView.image = UIImage(named: analyticForecast.nightCondition.rawValue)
        dayTempLabel.text = "\(analyticForecast.dayTemp)°"
        nightTempLabel.text = "\(analyticForecast.nightTemp)°"
    }
    
    func setupViews() {
        backgroundColor = .clear

        contentView.addSubview(dateLabel)
        dateLabel.font = .systemFont(ofSize: 12, weight: .bold)
        dateLabel.textColor = .systemBackground
        
        contentView.addSubview(humidIcon)
        humidIcon.contentMode = .scaleAspectFit

        contentView.addSubview(humidLabel)
        humidLabel.textColor = .systemBackground
        humidLabel.font = .systemFont(ofSize: 10)

        contentView.addSubview(dayConditionImageView)
        dayConditionImageView.contentMode = .scaleAspectFit

        contentView.addSubview(nightConditionImageView)
        dayConditionImageView.contentMode = .scaleAspectFit

        contentView.addSubview(dayTempLabel)
        dayTempLabel.textColor = .systemBackground
        dayTempLabel.font = .systemFont(ofSize: 12, weight: .bold)

        contentView.addSubview(nightTempLabel)
        nightTempLabel.textColor = .systemBackground
        nightTempLabel.font = .systemFont(ofSize: 12, weight: .bold)
    }
    
    func setupAutolayouts() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
        
        humidIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            humidIcon.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 0.0),
            humidIcon.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            humidIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            humidIcon.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4)
        ])
        
        humidLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            humidLabel.leadingAnchor.constraint(equalTo: humidIcon.trailingAnchor, constant: 3.0),
            humidLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            humidLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1)
        ])
        
        dayConditionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayConditionImageView.leadingAnchor.constraint(equalTo: humidLabel.trailingAnchor, constant: 5.0),
            dayConditionImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            dayConditionImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            dayConditionImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
        
        nightConditionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nightConditionImageView.leadingAnchor.constraint(equalTo: dayConditionImageView.trailingAnchor, constant: 5.0),
            nightConditionImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            nightConditionImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            nightConditionImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
        
        dayTempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayTempLabel.leadingAnchor.constraint(equalTo: nightConditionImageView.trailingAnchor, constant: 5.0),
            dayTempLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            dayTempLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1)
        ])
        
        nightTempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nightTempLabel.leadingAnchor.constraint(equalTo: dayTempLabel.trailingAnchor, constant: 5.0),
            nightTempLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            nightTempLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1)
        ])
    }
}
