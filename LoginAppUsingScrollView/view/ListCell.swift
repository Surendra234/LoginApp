//
//  ListCell.swift
//  LoginAppUsingScrollView
//
//  Created by Admin on 31/07/22.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Properties
    
    let titleLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        lable.lineBreakMode = .byWordWrapping
        lable.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        lable.textColor = .blue
        lable.textAlignment = .center
        return lable
    }()
    
    let descriptionLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        lable.lineBreakMode = .byWordWrapping
        lable.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        return lable
    }()
    
    
    func setUpView() {
        backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLable)

        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true

        descriptionLable.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30).isActive = true
        descriptionLable.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        descriptionLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        descriptionLable.heightAnchor.constraint(equalToConstant: 120).isActive = true
        descriptionLable.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
}

