//
//  ViewController.swift
//  WxForecast
//
//  Created by Chung EXI-Nguyen on 6/18/22.
//

import UIKit

// features
// 1. display current wx for current time
// 2. display wx for 24 hours
// 3. display wx for 7 days

// MARK: View Model

protocol ViewModelDelegate: AnyObject {
    func weatherDidUpdate()
}

class ViewModel {
    var todayForecast: DailyForecast?
    var hourlyForecasts: [HourlyForecast] = []
    var analyzedForecasts: [ForecastAnalytic] = []
    
    var weatherService = WeatherService()
    var dateService = DateService()
    weak var delegate: ViewModelDelegate?
    
    func load() {
        let now = Date()
        weatherService.fetchWeatherForecast(now)
        
        todayForecast = weatherService.getWeatherForecast(now)
        hourlyForecasts = weatherService.getHourlyForecasts(now)
        analyzedForecasts = weatherService.getAnalyzedForecasts(now)
        delegate?.weatherDidUpdate()
    }

    /// Not sure logic of feel like, simulate one
    func getFeelTemp(_ sample1: Int, _ sample2: Int) -> Int {
        let minTemp = min(sample1, sample2)
        let diff = abs(sample1 - sample2)
        let randomDiff = Int.random(in: 0...diff)
        return minTemp + randomDiff
    }
    
    func getCurrentDateString() -> String {
        let now = Date()
        return dateService.getDateString(now, "E, HH:mm")
    }
}

class ViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
       return UIScrollView()
    }()
    
    lazy var scrollViewContent: UIView = {
        return UIView()
    }()

    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()
    
    lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var conditionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var tempStatLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let viewModel = ViewModel()
    let mainQueue = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAutolayouts()
        setupDelegates()
        viewModel.load()
    }
    
    func reloadData() {
        let hourly = viewModel.hourlyForecasts
        let analytics = viewModel.analyzedForecasts
        guard hourly.count > 0,
              analytics.count > 0,
              let todayForecast = viewModel.todayForecast else { return }
        
        currentTempLabel.text = "\(hourly[0].temp)°"
        
        locationLabel.text = "\(todayForecast.location)"
        
        pinImageView.image = UIImage(named: "pin")
        
        conditionImageView.image = UIImage(named: hourly[0].condition.rawValue)
        
        let dayTemp = analytics[0].dayTemp
        let nightTemp = analytics[0].nightTemp
        let feelTemp = viewModel.getFeelTemp(dayTemp, nightTemp)
        tempStatLabel.text = "\(dayTemp)° / \(nightTemp)° Feels like \(feelTemp)°"
        
        dateLabel.text = viewModel.getCurrentDateString()
        
        collectionView.reloadData()
        
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.colors = [UIColor(red: 136.0 / 255.0,
                                        green: 139.0 / 255.0,
                                        blue: 215.0 / 255.0,
                                        alpha: 1.0).cgColor,
                                UIColor(red: 98.0 / 255.0,
                                        green: 122.0 / 255.0,
                                        blue: 177.0 / 255.0,
                                        alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.frame
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContent)

        view.layer.insertSublayer(gradientLayer, at: 0)
        
        scrollViewContent.addSubview(currentTempLabel)
        currentTempLabel.font = .systemFont(ofSize: 50)
        currentTempLabel.textColor = .systemBackground
        
        scrollViewContent.addSubview(locationLabel)
        locationLabel.font = .systemFont(ofSize: 30)
        locationLabel.textColor = .systemBackground
        
        scrollViewContent.addSubview(pinImageView)
        pinImageView.contentMode = .scaleAspectFit
        
        scrollViewContent.addSubview(conditionImageView)
        conditionImageView.contentMode = .scaleAspectFit
        
        scrollViewContent.addSubview(tempStatLabel)
        tempStatLabel.font = .systemFont(ofSize: 16, weight: .bold)
        tempStatLabel.textColor = .systemBackground

        scrollViewContent.addSubview(dateLabel)
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.textColor = .systemBackground

        scrollViewContent.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(displayP3Red: 255.0/255.0,
                                                 green: 255.0/255.0,
                                                 blue: 255.0/255.0,
                                                 alpha: 0.2)
        collectionView.layer.borderColor = UIColor.systemBackground.cgColor
        collectionView.layer.borderWidth = 0.2
        collectionView.layer.shadowColor = UIColor.label.cgColor
        collectionView.layer.shadowOffset = .zero
        collectionView.layer.shadowOpacity = 0.2
        collectionView.layer.shadowRadius = 10.0
        collectionView.layer.masksToBounds = false
        collectionView.layer.cornerRadius = 20.0
        collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(HourlyDataCell.self, forCellWithReuseIdentifier: "cell")
        
        scrollViewContent.addSubview(tableView)
        tableView.backgroundColor = UIColor(displayP3Red: 255.0/255.0,
                                             green: 255.0/255.0,
                                             blue: 255.0/255.0,
                                             alpha: 0.2)
        tableView.layer.borderColor = UIColor.systemBackground.cgColor
        tableView.layer.borderWidth = 0.2
        tableView.layer.shadowColor = UIColor.label.cgColor
        tableView.layer.shadowOffset = .zero
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowRadius = 10.0
        tableView.layer.masksToBounds = false
        tableView.layer.cornerRadius = 20.0
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = SizeManager.TABLE_CELL_INSET
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.register(AnalyticDataCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupAutolayouts() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
        
        let equalHeight = scrollViewContent.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        equalHeight.priority = UILayoutPriority(rawValue: 250.0) // 750: scroll works but broken
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollViewContent.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollViewContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollViewContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            equalHeight
        ])
        
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentTempLabel.topAnchor.constraint(equalTo: scrollViewContent.topAnchor, constant: 50),
            currentTempLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 30)
        ])
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: currentTempLabel.leadingAnchor)
        ])
        
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pinImageView.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            pinImageView.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 3.0),
            pinImageView.heightAnchor.constraint(equalTo: locationLabel.heightAnchor)
        ])
        
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conditionImageView.topAnchor.constraint(equalTo: scrollViewContent.topAnchor, constant: 60),
            conditionImageView.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -30),
            conditionImageView.widthAnchor.constraint(equalToConstant: 50.0),
            conditionImageView.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        tempStatLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tempStatLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 40),
            tempStatLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: tempStatLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: tempStatLabel.leadingAnchor)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 125)
        ])
        
        let fullHeight = SizeManager.TABLE_ROW_HEIGHT * 7 + SizeManager.TABLE_CELL_INSET.top * 2
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: scrollViewContent.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: fullHeight)
        ])
    }
    
    func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ViewController: ViewModelDelegate {
    func weatherDidUpdate() {
        mainQueue.async { [weak self] in
            self?.reloadData()
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            print (scrollView.contentSize)
        }
    }
}
