// Views/Components/CategoryButton.swift
import UIKit

class CategoryButton: UIButton {
    var isSelectedCategory: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 10
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        updateAppearance()
    }
    
    private func updateAppearance() {
        backgroundColor = isSelectedCategory ? .systemBlue : .systemGray6
        setTitleColor(isSelectedCategory ? .white : .black, for: .normal)
    }
}
