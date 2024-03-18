//
//  HostViewController.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/6.
//

import Foundation
import UIKit
import SnapKit
import WebKit

class HomeViewController: UIViewController {
    
    lazy var titleImage: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "OBJECTS")
        return imv
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let sgm = UISegmentedControl(items: ["Movie", "Sports", "Nature", "Science", "Technology"])
        sgm.selectedSegmentIndex = 0
        sgm.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        sgm.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        sgm.setBackgroundImage(UIImage(), for: .selected, barMetrics: .compact)
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        sgm.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        sgm.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
        
        sgm.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        return sgm
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.delegate = self
        tbv.dataSource = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.showsHorizontalScrollIndicator = false
        tbv.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.cellIdentifier())
        
        return tbv
    }()
    
    var tableModel = [ArticleCellController]() {
        didSet { tableView.reloadData() }
    }
    
    var viewModel: HomeViewModel? {
        didSet {
            bind()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        refresh()
        setupUI()
    }
    
    private func refresh() {
        viewModel?.loadNews(newsCase: .movie)
    }
    
    func bind() {
        viewModel?.onOpenURL = { url in
            
            let urlRequest = URLRequest(url: url)
            
            let webViewController = UIViewController()
            let webView = WKWebView(frame: self.view.frame)
            webView.load(urlRequest)
            webViewController.view.addSubview(webView)
            
            webView.snp.makeConstraints { make in
                make.top.equalTo(webViewController.view.snp.topMargin)
                make.bottom.equalTo(webViewController.view.snp.bottomMargin)
                make.leading.equalTo(webViewController.view.snp.leading)
                make.trailing.equalTo(webViewController.view.snp.trailing)
            }
            
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(webViewController, animated: false)
            
            
        }
    }
    
    func setupUI() {
        self.view.addSubview(titleImage)
        self.view.addSubview(segmentedControl)
        self.view.addSubview(tableView)
        
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalTo(view.snp.leadingMargin).offset(20)
            make.height.equalTo(39.08)
            make.width.equalTo(72.08)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(14.92)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottomMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // Movie
            viewModel?.loadNews(newsCase: .movie)
        case 1: // Sports
            viewModel?.loadNews(newsCase: .sport)
        case 2: // Nature
            viewModel?.loadNews(newsCase: .nature)
        case 3: // Science
            viewModel?.loadNews(newsCase: .science)
        case 4: // Technology
            viewModel?.loadNews(newsCase: .technology)
        default:
            break
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = cellController(forRowAt: indexPath).browseURL()
        viewModel?.openURL(url: url)
        
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellController(forRowAt: indexPath).view(in: tableView, at: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> ArticleCellController {
        return tableModel[indexPath.row]
    }
    
    
}
