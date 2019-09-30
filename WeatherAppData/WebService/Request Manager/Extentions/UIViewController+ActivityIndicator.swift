//
//  UIViewController.swift
//  Mealo
//
//  Created by ArtS on 1/21/19.
//  Copyright © 2019 Mealo. All rights reserved.
//

import UIKit

fileprivate let overlayViewTag = 999
fileprivate let activityIndicatorTag = 1000

extension UIViewController {
    
    public func displayActivityIndicator(shouldDisplay: Bool) -> Void {
        if shouldDisplay {
            setActivityIndicator()
        } else {
            removeActivityIndicator()
        }
    }
    
    public func isDisplayingActivityIndicator() -> Bool {
        return isDisplayingActivityIndicatorOverlay()
    }
    
    private func setActivityIndicator() -> Void {
        guard !isDisplayingActivityIndicatorOverlay() else { return }
        guard let parentViewForOverlay = (tabBarController?.view ?? navigationController?.view) ?? view else { return }
        
        //configure overlay
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.5
        overlay.tag = overlayViewTag
        
        //configure activity indicator

        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.sizeToFit()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tag = activityIndicatorTag

        //add subviews
        overlay.addSubview(activityIndicator)
        parentViewForOverlay.addSubview(overlay)
        
        //add overlay constraints
        overlay.heightAnchor.constraint(equalTo: parentViewForOverlay.heightAnchor).isActive = true
        overlay.widthAnchor.constraint(equalTo: parentViewForOverlay.widthAnchor).isActive = true
        
        //add indicator constraints
        activityIndicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
        
        //animate indicator
        activityIndicator.startAnimating()
    }
    
    private func removeActivityIndicator() -> Void {
        let activityIndicator = getActivityIndicator()
        
        if let overlayView = getOverlayView() {
            UIView.animate(withDuration: 0.2, animations: {
                overlayView.alpha = 0.0
                activityIndicator?.stopAnimating()
            }) { (finished) in
                activityIndicator?.removeFromSuperview()
                overlayView.removeFromSuperview()
            }
        }
    }
    
    private func isDisplayingActivityIndicatorOverlay() -> Bool {
        if let _ = getActivityIndicator(), let _ = getOverlayView() {
            return true
        }
        return false
    }
    
    private func getActivityIndicator() -> UIActivityIndicatorView? {
        //        return (navigationController?.view.viewWithTag(activityIndicatorTag) ?? view.viewWithTag(activityIndicatorTag)) as? UIActivityIndicatorView
        if let activityIndicatorView = tabBarController?.view.viewWithTag(activityIndicatorTag) as? UIActivityIndicatorView {
            return activityIndicatorView
        } else if let activityIndicatorView = navigationController?.view.viewWithTag(activityIndicatorTag) as? UIActivityIndicatorView {
            return activityIndicatorView
        } else {
            return view.viewWithTag(activityIndicatorTag) as? UIActivityIndicatorView
        }
    }
    
    private func getOverlayView() -> UIView? {
        if let view = tabBarController?.view.viewWithTag(overlayViewTag) {
            return view
        } else if let view = navigationController?.view.viewWithTag(overlayViewTag) {
            return view
        } else {
            return view.viewWithTag(overlayViewTag)
        }
    }
}
