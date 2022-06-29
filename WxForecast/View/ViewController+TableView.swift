//
//  ViewController+TableView.swift
//  WxForecast
//
//  Created by Chung EXI-Nguyen on 6/20/22.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SizeManager.TABLE_ROW_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.analyzedForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AnalyticDataCell else {
            return UITableViewCell()
        }
        let forecasts = viewModel.analyzedForecasts[indexPath.row]
        cell.configure(forecasts)
        return cell
    }
}
