//
//  HomeCellController.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/6.
//

import Foundation
import UIKit

final class ArticleCellController {
    private let viewModel: ArticleCellViewModel
    private var cell: ArticleTableViewCell?
    
    init(viewModel: ArticleCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = binded(tableView.dequeueReusableCell())
        viewModel.loadImage()
        
        cell.onSelect = { [unowned self] in
            
            viewModel.storeArticle()
            
            let bool = self.viewModel.isLike
            self.viewModel.isLike = !bool
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        return cell
    }
    
    func browseURL() -> URL {
        return viewModel.url
    }
    
    private func binded(_ cell: ArticleTableViewCell) -> ArticleTableViewCell {
        self.cell = cell
        
        cell.nameLabel.text =  viewModel.name
        cell.titleLabel.text = viewModel.titile
        cell.articleDescriptionLabel.text = viewModel.description
        cell.timeLabel.text = viewModel.time
        
        let image = viewModel.isLike ?
        UIImage(named: "bookmark-fill"):
        UIImage(named: "bookmark")
        cell.likeButton.setImage(image, for: .normal)
        
        viewModel.onImageLoad = { [weak self] image in
            DispatchQueue.main.async {
                self?.cell?.articlelImageView.image = image
            }
        }
        
        return cell
    }
    
    
}
