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
    
    let title = UILabel()
    let subtitle = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyModel()
    }
    
    override func constructView() {
        title.font = UIFont.preferredFont(forTextStyle: .body)
        subtitle.font = UIFont.preferredFont(forTextStyle: .caption2)
    }
    
    override func constructSubviewHierarchy() {
        addAutoLayoutSubview(title)
        addAutoLayoutSubview(subtitle)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            title.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            title.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),

            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            subtitle.leftAnchor.constraint(equalTo: title.leftAnchor),
            subtitle.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func applyModel() {
        self.title.text = model.title
        self.subtitle.text = model.subtitle
    }
}
