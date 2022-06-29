//
//  CacheService.swift
//  WxForecast
//
//  Created by Chung EXI-Nguyen on 6/18/22.
//

import Foundation

class CacheService {
    static let shared: CacheService = CacheService()
    var cache: [String: DailyForecast] = [:]
    private init() {}
    
    func contains(_ dateString: String) -> Bool {
        return cache[dateString] != nil
    }
    
    func insert(_ dateString: String, _ dailyForecast: DailyForecast) {
        cache[dateString] = dailyForecast
    }
    
    func get(_ dateString: String) -> DailyForecast? {
        return cache[dateString]
    }
}
