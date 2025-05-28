//
//  TableViewCell.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 28.05.2025.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
}

private extension CategoryTableViewCell {
    func setupViews() {

    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([

        ])
    }
}
