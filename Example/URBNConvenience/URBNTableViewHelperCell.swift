//
//  URBNTableViewHelperCell.swift
//  URBNConvenience
//
//  Created by Bueno McCartney on 5/25/16.
//  Copyright © 2016 jgrandelli. All rights reserved.
//

import UIKit

class URBNTableViewHelperCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        
        let views = ["titleLabel": titleLabel, "detailLabel": detailLabel]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[titleLabel]-[detailLabel]-|", options: [.AlignAllLeft], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellContent(sampleData: [String: String]) {
        titleLabel.text = sampleData["title"]
        detailLabel.text = sampleData["detail"]
    }
}
