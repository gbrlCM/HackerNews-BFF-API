//
//  TimeElapsed.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 09/02/21.
//

import Foundation

struct TimeElapsed {
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    var second: Int?
    
    init(since timeStamp: TimeInterval) {
        guard let remainderFromYear = calculate(with: timeStamp, for: .year) else { return }
        guard let remainderFromMonth = calculate(with: remainderFromYear, for: .month) else { return }
        guard let remainderFromDay = calculate(with: remainderFromMonth, for: .day) else { return }
        guard let remainderFromHour = calculate(with: remainderFromDay, for: .hour) else { return }
        guard let remainderFromMinute = calculate(with: remainderFromHour, for: .minute) else { return }
        let _ = calculate(with: remainderFromMinute, for: .second)
    }
    
    private mutating func calculate(with timeStamp: TimeInterval, for variable: ConversionTable) -> TimeInterval? {
        guard timeStamp >= 1 else { return nil }
        
        let secondsConversion = variable.rawValue
        let valueCalculated = timeStamp/secondsConversion
        
        if valueCalculated >= 1 {
            assign(from: Int(valueCalculated), to: variable)
            let remainder = ((valueCalculated - valueCalculated.rounded()) * secondsConversion)
            return remainder
        } else {
            let remainder = timeStamp
            return remainder
        }
    }
    
    private enum ConversionTable: Double {
        case year = 31536000
        case month = 2592000
        case day = 86400
        case hour = 3600
        case minute = 60
        case second = 1
    }
    
    private mutating func assign(from value: Int, to variableFromSeconds: ConversionTable) {
        switch variableFromSeconds {
            case .year:
                self.year = value
            case .month:
                self.month = value
            case .day:
                self.day = value
            case .hour:
                self.hour = value
            case .minute:
                self.minute = value
            case .second:
                self.second = value
        }
        
    }
    
    public func stringfy() -> String {
        var string = ""
        
        if let year = self.year {
            string.append("\(year)y ")
        }
        
        if let month = self.month {
            string.append("\(month)m ")
        }
        
        if let day = self.day {
            string.append("\(day)d ")
        }
        
        if let hour = self.hour {
            string.append("\(hour)h ")
        }
        
        if let minute = self.minute {
            string.append("\(minute)min ")
        }
        
        return string
    }
}
