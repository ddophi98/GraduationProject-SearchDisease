//
//  DateExtension.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/26.
//

import Foundation

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)!
    }
}

extension Date {
    static let secondsInDay = 86400.0
    
    func beforeDays(_ days: Int) -> Date {
        return Calendar.current.startOfDay(for: self.addingTimeInterval(-Date.secondsInDay * Double(days)))
    }
    
    func getDday() -> Int {
        let target = Calendar.current.dateComponents(in: .current, from: self)
        let today = Calendar.current.dateComponents(in: .current, from: Date())
        
        if today.month == target.month {
            return today.day! - target.day!
        } else {
            let daysOfMonth = getDaysOfMonth(target)
            return today.day! + daysOfMonth - target.day!
        }
    }
    
    private func getDaysOfMonth(_ dateComponent: DateComponents) -> Int {
        guard let date = Calendar.current.date(from: dateComponent) else {
            return -1
        }
        let interval = Calendar.current.dateInterval(of: .month, for: date)!
        return Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day!
    }
}
