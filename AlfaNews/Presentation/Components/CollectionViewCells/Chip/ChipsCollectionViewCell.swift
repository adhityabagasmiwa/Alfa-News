//
//  ChipsCollectionViewCell.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import UIKit

class ChipsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let cellId = "ChipsCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            setupSelectedUI(isSelected)
        }
    }
}

private extension ChipsCollectionViewCell {
    
    private func setupUI() {
        mainView.layer.cornerRadius = 16
        mainView.clipsToBounds = true
    }
    
    private func setupSelectedUI(_ isSelected: Bool) {
        mainView.backgroundColor = isSelected ? .red.withAlphaComponent(0.7) : .tertiarySystemGroupedBackground
        titleLabel.textColor = isSelected ? .white : .darkGray
    }
}

extension ChipsCollectionViewCell {
    
    func configure(_ data: NewsCategory) {
        setupUI()
        
        titleLabel.text = data.title.rawValue.capitalized
    }
}
