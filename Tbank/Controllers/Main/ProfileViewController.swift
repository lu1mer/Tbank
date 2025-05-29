//
//  ProfileViewController.swift
//  Tbank
//
//  Created by Ильнур Салахов on 16.05.2025.
//


// ProfileViewController.swift
import UIKit

class ProfileViewController: UIViewController {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Тарышкина Ксения"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ваши данные >", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let categoriesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Категории", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let editCategoriesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "Бюджет"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let budgetAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "100 000 ₽"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let recalculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пересчитать баланс", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Профиль"
        
        view.addSubview(nameLabel)
        view.addSubview(editButton)
        view.addSubview(categoriesButton)
        view.addSubview(editCategoriesButton)
        view.addSubview(budgetLabel)
        view.addSubview(budgetAmountLabel)
        view.addSubview(recalculateButton)
        view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        [nameLabel, editButton, categoriesButton, editCategoriesButton,
         budgetLabel, budgetAmountLabel, recalculateButton, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            editButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoriesButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            categoriesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesButton.trailingAnchor.constraint(equalTo: editCategoriesButton.leadingAnchor, constant: -8),
            
            editCategoriesButton.centerYAnchor.constraint(equalTo: categoriesButton.centerYAnchor),
            editCategoriesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            budgetLabel.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor, constant: 20),
            budgetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            budgetAmountLabel.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: 8),
            budgetAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            recalculateButton.topAnchor.constraint(equalTo: budgetAmountLabel.bottomAnchor, constant: 16),
            recalculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.topAnchor.constraint(equalTo: recalculateButton.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}