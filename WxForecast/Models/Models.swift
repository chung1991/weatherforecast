//
//  Models.swift
//  WxForecast
//
//  Created by Chung EXI-Nguyen on 6/18/22.
//

import Foundation

struct ForecastAnalytic {
    let date: String
    let humid: Int
    let dayTemp: Int
    let nightTemp: Int
    let dayCondition: ForecastCondition
    let nightCondition: ForecastCondition
}

struct DailyForecast {
    let date: String            // "24/12/2022"
    let hourly: [HourlyForecast]
    let location: String
}

enum ForecastCondition: String, CaseIterable {
    case cloud  // both
    case cloudy // both
    case rain   // both
    case moon   // night
    case sun    // day
}

struct HourlyForecast {
    let hour: Int       // 0-23
    let temp: Int       // celius
    let humid: Int      // 20-100
    let condition: ForecastCondition
}

extension Int {
    func humidType() -> String {
        if self < 20 { return "empty" }
        if self < 50 { return "half" }
        return "full"
    }
}
