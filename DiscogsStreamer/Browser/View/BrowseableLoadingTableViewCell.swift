//
//  BrowseableLoadingTableViewCell.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import UIKit

class BrowseableLoadingTableViewCell: BaseTableViewCell {
    class var reuseIdentifier: String {
        return "BrowseableLoadingTableViewCell"
    }
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func constructView() {
        self.activityIndicator.startAnimating()
    }
    
    override func constructSubviewHierarchy() {
        addAutoLayoutSubview(activityIndicator)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            activityIndicator.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor)
        ])
    }
    
    override func prepareForReuse() {
        self.activityIndicator.startAnimating()
    }
}
