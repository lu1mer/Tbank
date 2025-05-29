// Models/UserData.swift
import Foundation

class UserData {
    static let shared = UserData()
    private let userDefaults = UserDefaults.standard
    
    private let balanceKey = "currentBalance"
    private let selectedCategoriesKey = "selectedCategories"
    private let categoryDistributionKey = "categoryDistribution"
    
    var currentBalance: Double {
        get { userDefaults.double(forKey: balanceKey) }
        set { userDefaults.set(newValue, forKey: balanceKey) }
    }
    
    var selectedCategories: [String] {
        get { userDefaults.stringArray(forKey: selectedCategoriesKey) ?? [] }
        set { userDefaults.set(newValue, forKey: selectedCategoriesKey) }
    }
    
    var categoryDistribution: [String: Int] {
        get {
            if let data = userDefaults.data(forKey: categoryDistributionKey),
               let dict = try? JSONDecoder().decode([String: Int].self, from: data) {
                return dict
            }
            return [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: categoryDistributionKey)
            }
        }
    }
    
    private init() {}
}
