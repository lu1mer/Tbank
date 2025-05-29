// Models/FinancialDataManager.swift
import Foundation

final class FinancialDataManager {
    static let shared = FinancialDataManager()
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    // MARK: - Keys
    private struct Keys {
        static let currentBalance = "currentBalance"
        static let selectedCategories = "selectedCategories"
        static let categoryDistribution = "categoryDistribution"
        static let transactions = "userTransactions"
        static let monthlySpending = "monthlySpending"
        static let savingsGoals = "savingsGoals"
    }
    
    // MARK: - Date Formatter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    // MARK: - Initialization
    private init() {
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
    }
    
    // MARK: - User Data
    var currentBalance: Double {
        get { userDefaults.double(forKey: Keys.currentBalance) }
        set { userDefaults.set(newValue, forKey: Keys.currentBalance) }
    }
    
    var selectedCategories: [String] {
        get { userDefaults.stringArray(forKey: Keys.selectedCategories) ?? [] }
        set {
            userDefaults.set(newValue, forKey: Keys.selectedCategories)
            if categoryDistribution.isEmpty {
                _categoryDistribution = calculateInitialDistribution()
            }
        }
    }
    
    // MARK: - Transactions
    private var _transactions: [Transaction]?
    
    var transactions: [Transaction] {
        get {
            if let cached = _transactions { return cached }
            guard let data = userDefaults.data(forKey: Keys.transactions),
                  let transactions = try? decoder.decode([Transaction].self, from: data) else {
                return sampleTransactions()
            }
            _transactions = transactions
            return transactions
        }
        set {
            _transactions = newValue
            if let data = try? encoder.encode(newValue) {
                userDefaults.set(data, forKey: Keys.transactions)
            }
            recalculateMonthlySpending()
        }
    }
    
    func addTransaction(_ transaction: Transaction) {
        var current = transactions
        current.append(transaction)
        transactions = current
    }
    
    func deleteTransaction(withId id: UUID) {
        transactions = transactions.filter { $0.id != id }
    }
    
    // MARK: - Category Distribution
    private var _categoryDistribution: [String: Int]?
    
    var categoryDistribution: [String: Int] {
        get {
            if let cached = _categoryDistribution { return cached }
            if let data = userDefaults.data(forKey: Keys.categoryDistribution),
               let dict = try? decoder.decode([String: Int].self, from: data) {
                _categoryDistribution = dict
                return dict
            }
            return calculateInitialDistribution()
        }
        set {
            _categoryDistribution = newValue
            if let data = try? encoder.encode(newValue) {
                userDefaults.set(data, forKey: Keys.categoryDistribution)
            }
        }
    }
    
    // MARK: - Monthly Spending
    private var _monthlySpending: [String: Double]?
    
    var monthlySpending: [String: Double] {
        get {
            if let cached = _monthlySpending { return cached }
            if let data = userDefaults.data(forKey: Keys.monthlySpending),
               let dict = try? decoder.decode([String: Double].self, from: data) {
                _monthlySpending = dict
                return dict
            }
            return calculateMonthlySpending()
        }
        set {
            _monthlySpending = newValue
            if let data = try? encoder.encode(newValue) {
                userDefaults.set(data, forKey: Keys.monthlySpending)
            }
        }
    }
    
    // MARK: - Savings Goals
    private var _savingsGoals: [SavingsGoal]?
    
    var savingsGoals: [SavingsGoal] {
        get {
            if let cached = _savingsGoals { return cached }
            guard let data = userDefaults.data(forKey: Keys.savingsGoals),
                  let goals = try? decoder.decode([SavingsGoal].self, from: data) else {
                return []
            }
            _savingsGoals = goals
            return goals
        }
        set {
            _savingsGoals = newValue
            if let data = try? encoder.encode(newValue) {
                userDefaults.set(data, forKey: Keys.savingsGoals)
            }
        }
    }
    
    // MARK: - Public Methods
    func recalculateMonthlySpending() {
        monthlySpending = calculateMonthlySpending()
    }
    
    func getTransactions(for category: String? = nil, month: Int? = nil, year: Int? = nil) -> [Transaction] {
        let calendar = Calendar.current
        var filtered = transactions
        
        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }
        
        if let month = month {
            filtered = filtered.filter {
                calendar.component(.month, from: $0.date) == month
            }
        }
        
        if let year = year {
            filtered = filtered.filter {
                calendar.component(.year, from: $0.date) == year
            }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    func getMonthlySummary(month: Int, year: Int) -> (totalSpent: Double, byCategory: [String: Double]) {
        let transactions = getTransactions(month: month, year: year)
        var summary: [String: Double] = [:]
        var total: Double = 0
        
        transactions.forEach { transaction in
            let amount = abs(transaction.amount)
            total += amount
            summary[transaction.category] = (summary[transaction.category] ?? 0) + amount
        }
        
        return (total, summary)
    }
    
    // MARK: - Private Helpers
    private func calculateMonthlySpending() -> [String: Double] {
        var result: [String: Double] = [:]
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        for category in selectedCategories {
            result[category] = 0
        }
        
        transactions.forEach { transaction in
            let components = calendar.dateComponents([.month, .year], from: transaction.date)
            if components.month == currentMonth && components.year == currentYear {
                result[transaction.category] = (result[transaction.category] ?? 0) + abs(transaction.amount)
            }
        }
        
        return result
    }
    
    private func calculateInitialDistribution() -> [String: Int] {
        var distribution: [String: Int] = [:]
        let equalValue = 100 / max(1, selectedCategories.count)
        
        for category in selectedCategories {
            distribution[category] = equalValue
        }
        
        let remainder = 100 - (equalValue * selectedCategories.count)
        if remainder > 0, let firstCategory = selectedCategories.first {
            distribution[firstCategory] = (distribution[firstCategory] ?? 0) + remainder
        }
        
        return distribution
    }
    
    private func sampleTransactions() -> [Transaction] {
        return [
            Transaction(id: UUID(), amount: -130, category: "Транспорт",
                      date: dateFormatter.date(from: "06/05/2023")!, description: "Яндекс Такси"),
            Transaction(id: UUID(), amount: -1500, category: "Продукты",
                      date: dateFormatter.date(from: "05/05/2023")!, description: "Пятерочка"),
            Transaction(id: UUID(), amount: -750, category: "Кафе",
                      date: dateFormatter.date(from: "04/05/2023")!, description: "Starbucks")
        ]
    }
}
