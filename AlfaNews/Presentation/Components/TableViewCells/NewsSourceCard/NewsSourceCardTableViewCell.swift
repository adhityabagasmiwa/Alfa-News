//
//  NewsSourceCardTableViewCell.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import UIKit

class NewsSourceCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    static let cellId = "NewsSourceCardTableViewCell"
}

private extension NewsSourceCardTableViewCell {
    
    private func setupUI() {
        mainView.layer.cornerRadius = 16
        mainView.clipsToBounds = true
        
        posterImageView.layer.cornerRadius = 16
        posterImageView.clipsToBounds = true
    }
}

extension NewsSourceCardTableViewCell {
    
    func configure(_ data: Source) {
        setupUI()
        
        let imageName = data.name.generateTextToUIImage()
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.image = imageName
        
        categoryLabel.text = (data.category ?? "").capitalized
        titleLabel.text = data.description
        sourceLabel.text = data.name
    }
}
