//
//  SavingsGoal.swift
//  Tbank
//
//  Created by Ильнур Салахов on 29.05.2025.
//


// Models/SavingsGoal.swift
import Foundation

struct SavingsGoal: Codable, Identifiable {
    let id: UUID
    let name: String
    let targetAmount: Double
    var currentAmount: Double
    let targetDate: Date?
    let createdDate: Date
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, targetAmount, currentAmount, targetDate, createdDate, isCompleted
    }
    
    init(id: UUID = UUID(),
         name: String,
         targetAmount: Double,
         currentAmount: Double = 0,
         targetDate: Date? = nil,
         createdDate: Date = Date(),
         isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.targetDate = targetDate
        self.createdDate = createdDate
        self.isCompleted = isCompleted
    }
}

// Расширение для удобства
extension SavingsGoal {
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
    
    var formattedTargetAmount: String {
        NumberFormatter.currencyFormatter.string(from: NSNumber(value: targetAmount)) ?? "\(targetAmount) ₽"
    }
    
    var formattedCurrentAmount: String {
        NumberFormatter.currencyFormatter.string(from: NSNumber(value: currentAmount)) ?? "\(currentAmount) ₽"
    }
    
    var remainingAmount: Double {
        max(targetAmount - currentAmount, 0)
    }
    
    var formattedRemainingAmount: String {
        NumberFormatter.currencyFormatter.string(from: NSNumber(value: remainingAmount)) ?? "\(remainingAmount) ₽"
    }
    
    var daysRemaining: Int? {
        guard let targetDate = targetDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: targetDate).day
    }
}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₽"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
}