//
//  ArticlesViewController.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 18/09/23.
//

import UIKit
import SkeletonView

class ArticlesViewController: UIViewController, TableViewConfigurable {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = ArticleViewModel()
    private var sources: Source
    
    init(sources: Source) {
        self.sources = sources
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegate()
        setupCell()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
}

private extension ArticlesViewController {
    
    private func setupDelegate() {
        viewModel.delegate = self
        searchBar.delegate = self
    }
    
    private func setupCell() {
        configureTableView(nibName: NewsCardTableViewCell.cellId)
    }
    
    private func setupUI() {
        searchBar.searchTextField.layer.cornerRadius = 16
        searchBar.searchTextField.layer.masksToBounds = true
    }
    
    private func fetchData(query: String? = nil, sortBy: NewsCategoryEnum? = nil, from: String? = nil, to: String? = nil) {
        let request = NewsRequestPayload(
            page: 1,
            pageSize: 10,
            query: query,
            sources: sources.id,
            sortBy: sortBy,
            from: from,
            to: to
        )
        viewModel.fetchArticles(request: request)
    }
}

extension ArticlesViewController: ArticleProtocolDelegate {
    
    func notifyLoadingStateChanged() {
        showHideSkeletonTableView(tableView: tableView, isLoading: viewModel.isLoading)
    }
    
    func onSuccessGetArticles() {
        tableView.reloadData()
    }
    
    func onErrorGetArticles(error: CustomError) {
        
    }
}

extension ArticlesViewController: UITableViewDataSource, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NewsCardTableViewCell.cellId
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsEverything?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCardTableViewCell.cellId, for: indexPath) as! NewsCardTableViewCell
        
        guard let newsArticles = viewModel.newsEverything?.articles else { return cell }
        
        let newsArticle = newsArticles[indexPath.row]
        cell.configure(data: newsArticle, sources: self.sources)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ArticlesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let newsArticles = viewModel.newsEverything?.articles {
            let newsArticle = newsArticles[indexPath.row]
            navigateToWebview(newsArticle.url)
        }
    }
}

extension ArticlesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            fetchData(query: searchBar.text ?? "")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            fetchData()
        }
    }
}
