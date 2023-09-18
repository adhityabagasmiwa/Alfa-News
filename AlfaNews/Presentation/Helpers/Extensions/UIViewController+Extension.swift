//
//  UIViewController+Extension.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 17/09/23.
//

import Foundation
import UIKit
import FittedSheets
import SkeletonView

protocol TableViewConfigurable: UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView! { get set }
}

extension TableViewConfigurable where Self: UIViewController {

    func configureTableView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: nibName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}

protocol CollectionViewConfigurable: UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView! { get set }
}

extension CollectionViewConfigurable where Self: UIViewController {
    
    func configurableCollectionView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: nibName)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension UIViewController {
    
    func navigatePushToPage(_ toPage: UIViewController) {
        self.navigationController?.pushViewController(toPage, animated: true)
    }
    
    func navigatePop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigateReplacement(withLastIndex index: Int) {
        let vc = UIViewController()
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        navigationArray.removeLast(index)
        navigationArray.append(vc)
        self.navigationController?.setViewControllers(navigationArray, animated: true)
    }
    
    func navigateToWebview(_ urlString: String) {
        if let url = URL(string: urlString) {
            let vc = WebviewViewController(url: url)
            navigatePushToPage(vc)
        }
    }
    
    func showHideCircluarLoading(_ isLoading: Bool) {
        if isLoading {
            view.startLoadingAnimating()
        } else {
            view.stopLoadingAnimating()
        }
    }
    
    func showHideSkeletonTableView(tableView: UITableView, isLoading: Bool) {
        if isLoading {
            let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
            tableView.startSkeletonAnimation()
            tableView.showAnimatedGradientSkeleton(animation: animation, transition: .crossDissolve(0.25))
        } else {
            tableView.stopSkeletonAnimation()
            tableView.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    func showHideSkeletonCollectionView(collectionView: UICollectionView, isLoading: Bool) {
        if isLoading {
            let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
            collectionView.startSkeletonAnimation()
            collectionView.showAnimatedGradientSkeleton(animation: animation, transition: .crossDissolve(0.25))
        } else {
            collectionView.stopSkeletonAnimation()
            collectionView.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
    
    func showBottomSheet(controller: UIViewController, sizes: [SheetSize], dismissOnPull: Bool = true, dismissOnOverlayTap: Bool = true) {
        let options = SheetOptions(
            shrinkPresentingViewController: false
        )
        let sheetController = SheetViewController(controller: controller, sizes: sizes, options: options)
        sheetController.dismissOnPull = dismissOnPull
        sheetController.dismissOnOverlayTap = dismissOnOverlayTap
        sheetController.autoAdjustToKeyboard = true
        
        self.present(sheetController, animated: true, completion: nil)
    }
    
    func showAlertDialog(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            self.navigatePop()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupHideKeyboardTapOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
