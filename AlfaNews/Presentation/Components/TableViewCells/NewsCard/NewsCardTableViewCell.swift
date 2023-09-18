//
//  NewsCardTableViewCell.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import UIKit
import Kingfisher

class NewsCardTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let cellId = "NewsCardTableViewCell"
}

private extension NewsCardTableViewCell {
    
    private func setupUI() {
        posterImageView.layer.cornerRadius = 16
        posterImageView.clipsToBounds = true
        
        mainView.layer.cornerRadius = 16
        mainView.clipsToBounds = true
    }
}

extension NewsCardTableViewCell {
    
    func configure(data: Article, newsCategory: NewsCategory) {
        setupUI()
        
        titleLabel.text = data.title
        categoryLabel.text = newsCategory.title.rawValue.capitalized
        
        let url = URL(string: data.urlToImage ?? "")
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.kf.setImage(with: url, placeholder: iconPlaceholderNews)
        
        dateLabel.text = data.publishedAt.toString()
    }
    
    func configure(data: Article, sources: Source) {
        setupUI()
        
        titleLabel.text = data.title
        categoryLabel.text = sources.name.capitalized
        
        let url = URL(string: data.urlToImage ?? "")
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.kf.setImage(with: url, placeholder: iconPlaceholderNews)
        
        dateLabel.text = data.publishedAt.toString()
    }
}
