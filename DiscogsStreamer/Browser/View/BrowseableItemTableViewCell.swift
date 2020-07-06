//
//  BrowseableItemTableViewCell.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import UIKit

class BrowseableItemTableViewCell: BaseTableViewCell {
    class var reuseIdentifier: String {
        return "BrowseableItemTableViewCell"
    }
    
    struct Model {
        var title: String?
        var subtitle: String?
    }

    var model = Model() {
        didSet {
            applyModel()
        }
    }
    
    private let title: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyModel()
    }
    
    override func constructSubviewHierarchy() {
        addAutoLayoutSubview(title)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            title.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            title.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            title.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor)
        ])
    }
    
    private func applyModel() {
        self.title.text = model.title
    }
}
