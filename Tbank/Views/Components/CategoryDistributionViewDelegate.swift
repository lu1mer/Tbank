//
//  CategoryDistributionViewDelegate.swift
//  Tbank
//
//  Created by Ильнур Салахов on 16.05.2025.
//


// Views/Components/CategoryDistributionView.swift
import UIKit

protocol CategoryDistributionViewDelegate: AnyObject {
    func percentageDidChange()
    func adjustOtherCategories(adjustedCategory: String, newValue: Int, oldValue: Int)
}

class CategoryDistributionView: UIView {
    
    weak var delegate: CategoryDistributionViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.minimumTrackTintColor = .systemBlue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var oldValue: Int = 0
    var currentPercentage: Int = 0 {
        didSet {
            percentageLabel.text = "\(currentPercentage)%"
            slider.value = Float(currentPercentage)
        }
    }
    
    var categoryName: String {
        return nameLabel.text ?? ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(percentageLabel)
        addSubview(slider)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            percentageLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            percentageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            percentageLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            
            slider.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupActions() {
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    func configure(with category: String, percentage: Int) {
        nameLabel.text = category
        currentPercentage = percentage
        oldValue = percentage
    }
    
    func setPercentage(_ percentage: Int) {
        currentPercentage = percentage
        oldValue = percentage
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let newValue = Int(sender.value.rounded())
        
        // Сохраняем старое значение перед изменением
        let previousValue = currentPercentage
        currentPercentage = newValue
        
        // Уведомляем делегата об изменении
        delegate?.adjustOtherCategories(
            adjustedCategory: categoryName,
            newValue: newValue,
            oldValue: previousValue
        )
        
        delegate?.percentageDidChange()
    }
}