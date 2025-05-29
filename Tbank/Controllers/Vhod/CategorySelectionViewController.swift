// Controllers/CategorySelectionViewController.swift
import UIKit

class CategorySelectionViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите категории расходов"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    private let categories = [
        "Здоровье", "Досуг", "Образование",
        "Продукты", "Кафе", "Подарки",
        "Семья", "Спорт", "Другое"
    ]
    
    private var categoryButtons: [CategoryButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupActions()
        setupCategoryButtons()
        loadSelectedCategories()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(categoriesStackView)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoriesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            categoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoriesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoriesStackView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -30),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupCategoryButtons() {
        // Очищаем предыдущие кнопки
        categoryButtons.removeAll()
        categoriesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Создаем строки по 3 кнопки
        for i in stride(from: 0, to: categories.count, by: 3) {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 16
            rowStackView.distribution = .fillEqually
            
            // Добавляем до 3 кнопок в строку
            for j in i..<min(i+3, categories.count) {
                let button = CategoryButton()
                button.setTitle(categories[j], for: .normal)
                button.tag = j
                button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                categoryButtons.append(button)
            }
            
            categoriesStackView.addArrangedSubview(rowStackView)
        }
    }
    
    private func loadSelectedCategories() {
        let selectedCategories = UserData.shared.selectedCategories
        for (index, category) in categories.enumerated() {
            if selectedCategories.contains(category) {
                categoryButtons[index].isSelectedCategory = true
            }
        }
    }
    
    @objc private func categoryButtonTapped(_ sender: CategoryButton) {
        sender.isSelectedCategory.toggle()
        
        let selectedCategories = categoryButtons
            .filter { $0.isSelectedCategory }
            .compactMap { $0.title(for: .normal) }
        
        UserData.shared.selectedCategories = selectedCategories
    }
    
    @objc private func nextButtonTapped() {
        let distributionVC = IncomeDistributionViewController()
        navigationController?.pushViewController(distributionVC, animated: true)
    }
}
