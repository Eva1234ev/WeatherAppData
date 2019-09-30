//
//  CountryCell.swift
//  WeatherAppData
//
//  Created by Eva on 9/27/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder
extension UIView {
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
}

class CountryCell: UICollectionViewCell  {

    var country: Countrie? {
        didSet {
            nameLbl.text = country!.capital + ", " + country!.name
            
            countryImage.layer.cornerRadius = countryImage.frame.height/2
            countryImage.layer.masksToBounds = true
            let SVGCoder = SDImageSVGCoder.shared
            SDImageCodersManager.shared.addCoder(SVGCoder)
            countryImage.sd_setImage(with:   URL(string: country!.image))
            let SVGImageSize = CGSize(width: 100, height: 100)
            countryImage.sd_setImage(with:  URL(string: country!.image), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
          
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardCellShadow()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nameLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Country Name", size: 22)
        lbl.textColor = UIColor.init(white: 0, alpha: 1)
        return lbl
    }()
    
    
    lazy var countryImage: UIImageView = {
        
        let profileImg = UIImage(systemName: "person.crop.circle")
        let renderedImg = profileImg!.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let imv = UIImageView(image: renderedImg )
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()
    
    private func setupCell() {
        
        self.backgroundView?.addSubview(countryImage)
        self.backgroundView?.addSubview(nameLbl)

        NSLayoutConstraint.activate([
            countryImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            countryImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            countryImage.widthAnchor.constraint(equalToConstant: 50),
            countryImage.heightAnchor.constraint(equalToConstant: 50),
            
            nameLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLbl.leadingAnchor.constraint(equalTo: countryImage.trailingAnchor, constant: 16),
            nameLbl.widthAnchor.constraint(equalToConstant: 250),
            nameLbl.heightAnchor.constraint(equalToConstant: 50),

        ])
        
    }
    
    override var isHighlighted: Bool {
        
        didSet{
            
            var transform = CGAffineTransform.identity
            if isHighlighted {
               transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            
            UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
                self.transform = transform
            })
        }
    }
    
    func setupCardCellShadow() {
         backgroundView = UIView()
         addSubview(backgroundView!)
         backgroundView?.fillSuperview()
         backgroundView?.backgroundColor  = UIColor(red:0.87, green:0.91, blue:0.95, alpha:1.0)
         backgroundView?.layer.cornerRadius  = 26
         backgroundView?.layer.shadowOpacity = 0.1
         backgroundView?.layer.shadowOffset  = .init(width: 4, height: 10)
         backgroundView?.layer.shadowRadius  = 10

         layer.borderColor  = UIColor.blue.cgColor
         layer.borderWidth  = 1
         layer.cornerRadius = 26
         self.layoutIfNeeded()
     }
    
}


