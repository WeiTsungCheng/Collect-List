//
//  ArticleTableViewCell.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/6.
//

import UIKit
import SnapKit

class ArticleTableViewCell: UITableViewCell {
    
    lazy var cardStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.alignment = .center
        stv.distribution = .fill
        return stv
    }()
    
    lazy var articlelImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(systemName: "photo")
        return imv
    }()
    
    lazy var nameView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hexString: "#C1BA74")
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "name nameLabel"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "title"
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    
    lazy var articleDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "description"
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    
    lazy var bottomView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "bookmark"), for: .normal)
        return btn
    }()
    
    lazy var timeImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "watch")
        imv.contentMode = .scaleAspectFill
        return imv
    }()
    
    lazy var timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "01/01 00:00:00"
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 11)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setupUI()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(cardStackView)
        cardStackView.addArrangedSubview(articlelImageView)
        articlelImageView.addSubview(nameView)
        nameView.addSubview(nameLabel)
        cardStackView.addArrangedSubview(titleLabel)
        cardStackView.addArrangedSubview(articleDescriptionLabel)
        cardStackView.addArrangedSubview(bottomView)
        
        cardStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        articlelImageView.snp.makeConstraints { make in
            make.height.equalTo(175)
            make.width.equalTo(353)
        }
        
        nameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(6)
            make.height.equalTo(26)
            make.width.equalTo(nameLabel).offset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(articlelImageView.snp.bottom)
            make.leading.equalToSuperview().offset(9)
            make.trailing.equalToSuperview().offset(-9)
        }
        
        articleDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(9)
            make.trailing.equalToSuperview().offset(-9)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(9)
            make.trailing.equalToSuperview().offset(-9)
            make.height.equalTo(24)
        }
        
        bottomView.addSubview(likeButton)
        bottomView.addSubview(timeLabel)
        bottomView.addSubview(timeImageView)
        
        likeButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        timeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(timeLabel.snp.leading).offset(-4)
            make.width.height.equalTo(15)
        }
    }
    
    var onSelect: (() -> Void)?
    
    func setAction() {
        likeButton.addTarget(self, action: #selector(storeArticle), for: .touchUpInside)
    }
    
    @objc func storeArticle() {
        onSelect?()
    }
    
    
}
