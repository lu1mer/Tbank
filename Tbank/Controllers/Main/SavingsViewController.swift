//
//  SavingsViewController.swift
//  Tbank
//
//  Created by Ильнур Салахов on 16.05.2025.
//


// SavingsViewController.swift
import UIKit

class SavingsViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Накопления"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ставьте простые финансовые цели и отслеживайте прогресс накопления"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать накопление", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupSavingsGoals()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Накопления"
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(createButton)
    }
    
    private func setupConstraints() {
        [titleLabel, subtitleLabel, scrollView, contentView, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupSavingsGoals() {
        let seaTripView = createSavingsGoalView(
            title: "Поездка на море",
            targetAmount: "200 000 ₽",
            savedAmount: "116 700 ₽",
            remainingAmount: "83 300 ₽"
        )
        
        let carView = createSavingsGoalView(
            title: "Машина",
            targetAmount: "5 000 000 ₽",
            savedAmount: "350 000 ₽",
            remainingAmount: "4 650 000 ₽"
        )
        
        contentView.addSubview(seaTripView)
        contentView.addSubview(carView)
        
        seaTripView.translatesAutoresizingMaskIntoConstraints = false
        carView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seaTripView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            seaTripView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            seaTripView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            carView.topAnchor.constraint(equalTo: seaTripView.bottomAnchor, constant: 20),
            carView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            carView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            carView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func createSavingsGoalView(title: String, targetAmount: String, savedAmount: String, remainingAmount: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let targetLabel = UILabel()
        targetLabel.text = targetAmount
        targetLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        
        let savedTitleLabel = UILabel()
        savedTitleLabel.text = "Накоплено"
        savedTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        savedTitleLabel.textColor = .gray
        
        let savedAmountLabel = UILabel()
        savedAmountLabel.text = savedAmount
        savedAmountLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let remainingTitleLabel = UILabel()
        remainingTitleLabel.text = "Осталось"
        remainingTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        remainingTitleLabel.textColor = .gray
        
        let remainingAmountLabel = UILabel()
        remainingAmountLabel.text = remainingAmount
        remainingAmountLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let calculateButton = UIButton(type: .system)
        calculateButton.setTitle("Рассчитать рекомендуемую сумму откладывания", for: .normal)
        calculateButton.setTitleColor(.systemBlue, for: .normal)
        
        [titleLabel, targetLabel, deleteButton, savedTitleLabel, savedAmountLabel, 
         remainingTitleLabel, remainingAmountLabel, calculateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            targetLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            deleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            savedTitleLabel.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 16),
            savedTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            savedAmountLabel.topAnchor.constraint(equalTo: savedTitleLabel.bottomAnchor, constant: 4),
            savedAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            remainingTitleLabel.topAnchor.constraint(equalTo: savedAmountLabel.bottomAnchor, constant: 8),
            remainingTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            remainingAmountLabel.topAnchor.constraint(equalTo: remainingTitleLabel.bottomAnchor, constant: 4),
            remainingAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            calculateButton.topAnchor.constraint(equalTo: remainingAmountLabel.bottomAnchor, constant: 16),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calculateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        return view
    }
}