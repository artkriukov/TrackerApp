//
//  GradientBorderView.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 03.07.2025.
//

import UIKit

class GradientBorderView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CAShapeLayer()
    var borderWidth: CGFloat = 1 {
        didSet { setNeedsLayout() }
    }
    var cornerRadius: CGFloat = 16 {
        didSet { setNeedsLayout() }
    }
    var gradientColors: [UIColor] = [] {
        didSet { updateGradientColors() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2), cornerRadius: cornerRadius)
        maskLayer.path = path.cgPath
        maskLayer.lineWidth = borderWidth
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
    }

    private func updateGradientColors() {
        gradientLayer.colors = gradientColors.map { $0.cgColor }
    }
}
