//
//  IncomeDistributionViewController.swift
//  Tbank
//
//  Created by Ильнур Салахов on 16.05.2025.
//


// Controllers/IncomeDistributionViewController.swift
import UIKit

class IncomeDistributionViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Распределите свой доход по категориям"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумма должна составлять 100%"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Итого"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPercentageLabel: UILabel = {
        let label = UILabel()
        label.text = "100%"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var categoryViews: [CategoryDistributionView] = []
    private var totalPercentage: Int = 100 {
        didSet {
            totalPercentageLabel.text = "\(totalPercentage)%"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupActions()
        setupCategoryViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(categoriesStackView)
        view.addSubview(separatorView)
        view.addSubview(totalLabel)
        view.addSubview(totalPercentageLabel)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoriesStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            categoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoriesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            separatorView.topAnchor.constraint(equalTo: categoriesStackView.bottomAnchor, constant: 20),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            totalLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            totalPercentageLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            totalPercentageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupCategoryViews() {
        // Очищаем предыдущие представления
        categoryViews.forEach { $0.removeFromSuperview() }
        categoryViews.removeAll()
        categoriesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Загружаем распределение из UserDefaults или устанавливаем равное распределение
        var distribution = UserData.shared.categoryDistribution
        let categories = UserData.shared.selectedCategories
        
        // Если распределение не задано, устанавливаем равное распределение
        if distribution.isEmpty {
            let equalValue = 100 / max(1, categories.count)
            for category in categories {
                distribution[category] = equalValue
            }
            // Корректируем остаток
            let remainder = 100 - (equalValue * categories.count)
            if remainder > 0, let firstCategory = categories.first {
                distribution[firstCategory] = (distribution[firstCategory] ?? 0) + remainder
            }
        }
        
        // Создаем представления для каждой категории
        for category in categories {
            let value = distribution[category] ?? 0
            let categoryView = CategoryDistributionView()
            categoryView.configure(with: category, percentage: value)
            categoryView.delegate = self
            categoriesStackView.addArrangedSubview(categoryView)
            categoryViews.append(categoryView)
        }
        
        updateTotalPercentage()
    }
    
    private func updateTotalPercentage() {
        totalPercentage = categoryViews.reduce(0) { $0 + $1.currentPercentage }
    }
    
    @objc private func nextButtonTapped() {
        guard totalPercentage == 100 else {
            showAlert(title: "Ошибка", message: "Сумма должна составлять ровно 100%")
            return
        }
        
        // Сохраняем распределение
        var distribution: [String: Int] = [:]
        for view in categoryViews {
            distribution[view.categoryName] = view.currentPercentage
        }
        UserData.shared.categoryDistribution = distribution
        
        // Переход к следующему экрану
        print("Распределение сохранено: \(distribution)")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension IncomeDistributionViewController: CategoryDistributionViewDelegate {
    func percentageDidChange() {
        updateTotalPercentage()
    }
    
    func adjustOtherCategories(adjustedCategory: String, newValue: Int, oldValue: Int) {
        let delta = newValue - oldValue
        guard delta != 0 else { return }
        
        let otherCategories = categoryViews.filter { $0.categoryName != adjustedCategory }
        let totalOtherPercentage = otherCategories.reduce(0) { $0 + $1.currentPercentage }
        
        // Если другие категории уже на минимуме (0), не можем уменьшать дальше
        if delta > 0 && totalOtherPercentage == 0 {
            return
        }
        
        // Распределяем изменение пропорционально
        for categoryView in otherCategories {
            let currentPercentage = categoryView.currentPercentage
            if totalOtherPercentage > 0 {
                let adjustment = delta * currentPercentage / totalOtherPercentage
                categoryView.setPercentage(currentPercentage - adjustment)
            }
        }
        
        // Корректируем возможные ошибки округления
        let currentTotal = categoryViews.reduce(0) { $0 + $1.currentPercentage }
        if currentTotal != 100 {
            if let firstOtherCategory = otherCategories.first {
                firstOtherCategory.setPercentage(firstOtherCategory.currentPercentage + (100 - currentTotal))
            }
        }
    }
}