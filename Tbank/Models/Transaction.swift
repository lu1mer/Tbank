//
//  Transaction.swift
//  Tbank
//
//  Created by Ильнур Салахов on 29.05.2025.
//


// Models/Transaction.swift
import Foundation

struct Transaction: Codable, Identifiable {
    let id: UUID
    let amount: Double
    let category: String
    let date: Date
    let description: String
    var isCompleted: Bool
    
    // Для кастомного кодирования/декодирования даты
    enum CodingKeys: String, CodingKey {
        case id, amount, category, date, description, isCompleted
    }
    
    init(id: UUID = UUID(), 
         amount: Double, 
         category: String, 
         date: Date, 
         description: String,
         isCompleted: Bool = true) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.description = description
        self.isCompleted = isCompleted
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        amount = try container.decode(Double.self, forKey: .amount)
        category = try container.decode(String.self, forKey: .category)
        date = try container.decode(Date.self, forKey: .date)
        description = try container.decode(String.self, forKey: .description)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
        try container.encode(date, forKey: .date)
        try container.encode(description, forKey: .description)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}

// Расширение для удобства
extension Transaction {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₽"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount) ₽"
    }
    
    var isExpense: Bool {
        return amount < 0
    }
    
    var absoluteAmount: Double {
        return abs(amount)
    }
}
