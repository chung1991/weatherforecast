//
//  HourlyDataCell.swift
//  WxForecast
//
//  Created by Chung EXI-Nguyen on 6/20/22.
//

import Foundation
import UIKit

class HourlyDataCell: UICollectionViewCell {
    lazy var hourLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var conditionImageView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var tempLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var humidStackView: UIStackView = {
        return UIStackView()
    }()
    
    lazy var humidIcon: UIImageView = {
        return UIImageView()
    }()
    
    lazy var humidLabel: UILabel = {
        return UILabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAutolayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hourLabel.text = nil
        conditionImageView.image = nil
        tempLabel.text = nil
        humidLabel.text = nil
        humidIcon.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(hourLabel)
        hourLabel.textColor = .systemBackground
        hourLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(conditionImageView)
        conditionImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(tempLabel)
        tempLabel.textColor = .systemBackground
        tempLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        contentView.addSubview(humidStackView)
        humidStackView.distribution = .equalSpacing
        humidStackView.spacing = 3.0
        
        humidStackView.addArrangedSubview(humidIcon)
        humidIcon.contentMode = .scaleAspectFit
        
        humidStackView.addArrangedSubview(humidLabel)
        humidLabel.textColor = .systemBackground
        humidLabel.font = .systemFont(ofSize: 12)
    }
    
    func setupAutolayouts() {
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0),
            hourLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conditionImageView.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 5.0),
            conditionImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionImageView.widthAnchor.constraint(equalToConstant: 30),
            conditionImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor, constant: 5.0),
            tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        humidStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            humidStackView.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 5.0),
            humidStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configure(_ hourly: HourlyForecast) {
        hourLabel.text = String(format: "%.2d:00", hourly.hour)
        conditionImageView.image = UIImage(named: hourly.condition.rawValue)
        tempLabel.text = "\(hourly.temp)°"
        humidLabel.text = "\(hourly.humid)%"
        humidIcon.image = UIImage(named: hourly.humid.humidType())
    }
}
