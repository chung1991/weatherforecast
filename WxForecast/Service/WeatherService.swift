//
//  WeatherService.swift
//  WxForecast
//
//  Created by Chung EXI-Nguyen on 6/18/22.
//

import Foundation

extension Int {
    func isNightTime() -> Bool {
        return self < 5 || self > 21
    }
}

class WeatherService {
    let dateService = DateService()
    let cacheService = CacheService.shared
    
    func getHourlyForecasts(_ date: Date) -> [HourlyForecast] {
        let todayString = dateService.getDateDiff(date, 0)
        let tomorrowString = dateService.getDateDiff(date, 1)
        
        guard let todayForecast = cacheService.get(todayString),
              let tomorrowForecast = cacheService.get(tomorrowString) else {
                  assertionFailure()
                  return []
              }
        
        let fromHour = dateService.getDateComponent(.hour, date)
        if fromHour == 0 {
            return todayForecast.hourly
        } else {
            var forecasts = todayForecast.hourly + tomorrowForecast.hourly
            
            // past fromHour
            let elapsedHourCount = fromHour + 1
            let remainHourObjectCount = forecasts.count - elapsedHourCount
            forecasts = forecasts.suffix(remainHourObjectCount)
            // get only 24 object after that
            forecasts = Array(forecasts.prefix(24))
            return forecasts
        }
    }
    
    func getAnalyzedForecasts(_ date: Date) -> [ForecastAnalytic] {
        var result: [ForecastAnalytic] = []
        for diff in -1...5 {
            let curDateString = dateService.getDateDiff(date, diff)
            guard let forecast = cacheService.get(curDateString) else {
                assertionFailure()
                continue
            }
            result.append(analyseForecast(forecast))
        }
        
        return result
    }
    
    func getWeatherForecast(_ date: Date) -> DailyForecast? {
        let dateString = dateService.getDateString(date)
        guard cacheService.contains(dateString) else {
            return nil
        }
        return cacheService.get(dateString)
    }
    
    // get 7 days belong yesterday, today and 5 day more
    func fetchWeatherForecast(_ date: Date) {
        for diff in -1...5 {
            let curDateString = dateService.getDateDiff(date, diff)
            guard !cacheService.contains(curDateString) else {
                continue
            }
            cacheService.insert(curDateString, randomForecast(curDateString))
        }
    }
    
    private func analyseForecast(_ dailyForecast: DailyForecast) -> ForecastAnalytic {
        ForecastAnalytic(date: dailyForecast.date,
                         humid: analyseHumid(dailyForecast),
                         dayTemp: analyseTemp(dailyForecast, day: true),
                         nightTemp: analyseTemp(dailyForecast, day: false),
                         dayCondition: analyseCondition(dailyForecast, day: true),
                         nightCondition: analyseCondition(dailyForecast, day: false))
    }
    
    private func analyseTemp(_ dailyForecast: DailyForecast, day: Bool) -> Int {
        let hourlyForecasts = dailyForecast.hourly
        var temps: [Int] = []
        if day {
            temps = hourlyForecasts.filter { !$0.hour.isNightTime() }.map { $0.temp }
            return temps.max() ?? -1
        } else {
            temps = hourlyForecasts.filter { $0.hour.isNightTime() }.map { $0.temp }
            return temps.min() ?? -1
        }
    }
    
    private func analyseCondition(_ dailyForecast: DailyForecast, day: Bool) -> ForecastCondition {
        let hourlyForecasts = dailyForecast.hourly
        var conditions: [ForecastCondition] = []
        if day {
            conditions = hourlyForecasts.filter { $0.hour >= 5 && $0.hour <= 21 }.map { $0.condition }
        } else {
            conditions = hourlyForecasts.filter { $0.hour < 5 || $0.hour > 21 }.map { $0.condition }
        }
        conditions.sort { $0.rawValue < $1.rawValue }
        return conditions[conditions.count / 2]
    }
    
    private func analyseHumid(_ dailyForecast: DailyForecast) -> Int {
        let hourlyForecasts = dailyForecast.hourly
        let humids = hourlyForecasts.map { $0.humid }
        let sum = humids.reduce(0, +)
        return sum / humids.count
    }
    
    private func randomForecast(_ dateString: String) -> DailyForecast {
        var hourlyForecasts: [HourlyForecast] = []
        for hour in 0...23 {
            hourlyForecasts.append(randomHourlyForecast(hour))
        }
        
        let location = ["Kent", "Auburn", "Seattle", "Tacoma"].randomElement()!
        let forecast = DailyForecast(date: dateString,
                                     hourly: hourlyForecasts,
                                     location: location)
        return forecast
    }

    private func randomHourlyForecast(_ hour: Int) -> HourlyForecast {
        let temp = Int.random(in: 0...40)
        let humid = Int.random(in: 0...80)
        
        var allCondition = Set<String>(ForecastCondition.allCases.map { $0.rawValue })
        if hour.isNightTime() {
            allCondition.remove(ForecastCondition.sun.rawValue)
        } else {
            allCondition.remove(ForecastCondition.moon.rawValue)
        }
        guard let randomCondition = allCondition.randomElement(),
              let condition = ForecastCondition(rawValue: randomCondition) else {
                  assertionFailure()
                  return HourlyForecast(hour: -1, temp: -1, humid: -1, condition: .cloud)
              }
        
        let forecast = HourlyForecast(hour: hour,
                                      temp: temp,
                                      humid: humid,
                                      condition: condition)
        return forecast
    }
}
