//
//  HomeNewsViewController.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import UIKit
import SkeletonView

class HomeNewsViewController: UIViewController, CollectionViewConfigurable, TableViewConfigurable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var breakingNewsImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel = HomeNewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupCell()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData(viewModel.selectedNewsCategory.title)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.layoutSkeletonIfNeeded()
        tableView.layoutSkeletonIfNeeded()
    }
    
    @IBAction func onPressBreakingNewsButton(_ sender: Any) {
        if let url = viewModel.breakingNews?.url {
            navigateToWebview(url)
        }
    }
}

private extension HomeNewsViewController {
    
    private func setupDelegate() {
        viewModel.delegate = self
    }
    
    private func setupCell() {
        configurableCollectionView(nibName: ChipsCollectionViewCell.cellId)
        configureTableView(nibName: NewsCardTableViewCell.cellId)
    }
    
    private func setupUI() {
        overlayView.layer.cornerRadius = 16
        overlayView.clipsToBounds = true
        
        breakingNewsImageView.layer.cornerRadius = 16
        breakingNewsImageView.clipsToBounds = true
    }
    
    private func configureBreakingNews(_ data: Article) {
        let url = URL(string: data.urlToImage ?? "")
        breakingNewsImageView.contentMode = .scaleAspectFill
        breakingNewsImageView.kf.setImage(with: url, placeholder: iconPlaceholderNews)
        
        sourceLabel.text = "\(data.source.name) • \(data.publishedAt.toString())"
        titleLabel.text = data.title
    }
    
    private func showHideSkeletonBreakingNews(_ isLoding: Bool) {
        overlayView.isHidden = isLoding
        
        if isLoding {
            breakingNewsImageView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        } else {
            breakingNewsImageView.stopSkeletonAnimation()
            breakingNewsImageView.hideSkeleton()
        }
    }
    
    private func fetchData(_ category: NewsCategoryEnum) {
        let request = NewsRequestPayload(page: 1, pageSize: 10, category: category)
        viewModel.fetchNewsHeadlines(request: request)
    }
}

extension HomeNewsViewController: HomeNewsProtocolDelegate {
    
    func notifyLoadingStateChanged() {
        showHideSkeletonCollectionView(collectionView: collectionView, isLoading: viewModel.isLoading)
        showHideSkeletonTableView(tableView: tableView, isLoading: viewModel.isLoading)
        showHideSkeletonBreakingNews(viewModel.isLoading)
    }
    
    func onSuccessGetNews() {
        if let news = viewModel.breakingNews {
            configureBreakingNews(news)
        }
        
        if let newsHeadlines = viewModel.newsHeadlines?.articles {
            tableViewHeight.constant = CGFloat(newsHeadlines.count * 136)
            tableView.reloadData()
        }
        
        collectionView.reloadData()
    }
    
    func onErrorGetNews(error: CustomError) {
        showAlertDialog(message: error.message)
    }
}

extension HomeNewsViewController: UICollectionViewDataSource, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newsCategoryChips.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ChipsCollectionViewCell.cellId
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newsCategoryChips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipsCollectionViewCell.cellId, for: indexPath) as! ChipsCollectionViewCell
        
        let newsCategory = viewModel.newsCategoryChips[indexPath.row]
        cell.configure(newsCategory)
        
        let indexPath = IndexPath(item: (viewModel.selectedNewsCategory.id - 1), section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        
        return cell
    }
}

extension HomeNewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipsCollectionViewCell.cellId, for: indexPath) as! ChipsCollectionViewCell
        
        let newsCategory = viewModel.newsCategoryChips[indexPath.row]
        viewModel.selectedNewsCategory = newsCategory
        fetchData(newsCategory.title)
        
        cell.isSelected = true
    }
}

extension HomeNewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let newsCategory = viewModel.newsCategoryChips[indexPath.row]
        
        let text = newsCategory.title.rawValue.capitalized
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 10)]).width + 48
        
        return CGSize(width: width, height: 36)
    }
}

extension HomeNewsViewController: UITableViewDataSource, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NewsCardTableViewCell.cellId
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsHeadlines?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCardTableViewCell.cellId, for: indexPath) as! NewsCardTableViewCell
        
        guard let newsHeadlines = viewModel.newsHeadlines?.articles else { return cell }
        
        let newsHeadline = newsHeadlines[indexPath.row]
        cell.configure(data: newsHeadline, newsCategory: viewModel.selectedNewsCategory)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        cell.selectionStyle = .none
        
        return cell
    }
}

extension HomeNewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newsHeadlines = viewModel.newsHeadlines?.articles {
            let newsHeadline = newsHeadlines[indexPath.row]
            navigateToWebview(newsHeadline.url)
        }
    }
}
