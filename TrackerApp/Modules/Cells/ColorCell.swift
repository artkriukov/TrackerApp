//
//  ColorCell.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 09.06.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 3 : 0
            layer.borderColor = isSelected ? colorView.backgroundColor?.cgColor : nil
            layer.cornerRadius = isSelected ? 8 : 0
        }
    }
    
    private func setupViews() {
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
