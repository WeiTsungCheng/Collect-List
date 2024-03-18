//
//  FavoriteViewController.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/7.
//

import UIKit

class FavoriteViewController: UIViewController {
    
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
    
    var viewModel: FavoriteViewModel? {
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
        viewModel?.loadStoredArticle()
    }
    
    func bind() { }
    
    func setupUI() {
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottomMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
    
}
