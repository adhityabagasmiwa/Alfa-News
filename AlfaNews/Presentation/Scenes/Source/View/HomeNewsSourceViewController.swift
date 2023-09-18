//
//  HomeNewsSourceViewController.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import UIKit
import SkeletonView

class HomeNewsSourceViewController: UIViewController, CollectionViewConfigurable, TableViewConfigurable {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var viewModel = HomeNewsSourceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupCell()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData(category: .business)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

private extension HomeNewsSourceViewController {
    
    private func setupDelegate() {
        viewModel.delegate = self
        searchBar.delegate = self
    }
    
    private func setupCell() {
        configurableCollectionView(nibName: ChipsCollectionViewCell.cellId)
        configureTableView(nibName: NewsSourceCardTableViewCell.cellId)
    }
    
    private func setupUI() {
        searchBar.searchTextField.layer.cornerRadius = 16
        searchBar.searchTextField.layer.masksToBounds = true
    }
    
    private func fetchData(category: NewsCategoryEnum, query: String? = nil) {
        let request = NewsRequestPayload(query: query, category: category)
        viewModel.fetchNewsSources(request: request)
    }
    
    private func navigateToArticles(_ sources: Source) {
        let vc = ArticlesViewController(sources: sources)
        navigatePushToPage(vc)
    }
}

extension HomeNewsSourceViewController: HomeNewsSourceProtocolDelegate {
    
    func notifyLoadingStateChanged() {
        showHideSkeletonCollectionView(collectionView: collectionView, isLoading: viewModel.isLoading)
        showHideSkeletonTableView(tableView: tableView, isLoading: viewModel.isLoading)
    }
    
    func onSuccessGetNewsSources() {
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func onErrorGetNewsSources(error: CustomError) {
        
    }
}

extension HomeNewsSourceViewController: UICollectionViewDataSource, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newsCategoryChips.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
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

extension HomeNewsSourceViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipsCollectionViewCell.cellId, for: indexPath) as! ChipsCollectionViewCell
        
        let newsCategory = viewModel.newsCategoryChips[indexPath.row]
        viewModel.selectedNewsCategory = newsCategory
        fetchData(category: newsCategory.title)
        
        cell.isSelected = true
    }
}

extension HomeNewsSourceViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let newsCategory = viewModel.newsCategoryChips[indexPath.row]
        
        let text = newsCategory.title.rawValue.capitalized
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 10)]).width + 48
        
        return CGSize(width: width, height: 36)
    }
}

extension HomeNewsSourceViewController: UITableViewDataSource, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NewsSourceCardTableViewCell.cellId
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsSources?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsSourceCardTableViewCell.cellId, for: indexPath) as! NewsSourceCardTableViewCell
        
        guard let newsSources = viewModel.newsSources else { return cell }
        
        let newsSource = newsSources[indexPath.row]
        cell.configure(newsSource)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        cell.selectionStyle = .none
        
        return cell
    }
}

extension HomeNewsSourceViewController: UITabBarDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newsSources = viewModel.newsSources {
            let newsSource = newsSources[indexPath.row]
            navigateToArticles(newsSource)
        }
    }
}

extension HomeNewsSourceViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            fetchData(category: viewModel.selectedNewsCategory.title, query: searchBar.text ?? "")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            fetchData(category: viewModel.selectedNewsCategory.title)
        }
    }
}
