//
//  CropDragPointView.swift
//  CropKit
//
//  Created by Dalton Claybrook on 3/31/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

struct MovementDirection: OptionSet {
    let rawValue: Int
    
    static let none = MovementDirection(rawValue: 0)
    static let upDown = MovementDirection(rawValue: 1 << 0)
    static let leftRight = MovementDirection(rawValue: 1 << 1)
    static let both: MovementDirection = [.upDown, .leftRight]
}

protocol CropDragPointViewDelegate {
    func cropDragPointView(_ view: CropDragPointView, updatedCenter center: CGPoint)
}

class CropDragPointView: UIView {
    enum State {
        case idle
        case dragging(startingCenter: CGPoint)
    }
    
    override var frame: CGRect { didSet { updateView() } }
    override var bounds: CGRect { didSet { updateView() } }
    
    var delegate: CropDragPointViewDelegate?
    var centeredBetween = [CropDragPointView]()
    var linkedXCorner: CropDragPointView?
    var linkedYCorner: CropDragPointView?
    
    var direction = MovementDirection.none
    
    private let circleView = UIView()
    private var state = State.idle
    private let circleSizeMultiplier: CGFloat = 0.3
    private let preferredSize: CGFloat = 44
    override var intrinsicContentSize: CGSize {
        return CGSize(width: preferredSize, height: preferredSize)
    }
    
    init(center: CGPoint) {
        let frame = CGRect(x: center.x - preferredSize/2.0, y: center.y - preferredSize/2.0, width: preferredSize, height: preferredSize)
        super.init(frame: frame)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    //MARK: Superclass
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        circleView.backgroundColor = tintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    //MARK: Actions
    
    @objc private func panGestureRecognized(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        switch gesture.state {
        case .began:
            state = .dragging(startingCenter: center)
        case .changed:
            if case .dragging(let startingCenter) = state {
                let translation = gesture.translation(in: superview)
                updatePosition(withStartingCenter: startingCenter, translation: translation)
            }
        case .ended, .cancelled:
            state = .idle
        default:
            break
        }
    }
    
    //MARK: Private
    
    private func configureView() {
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.layer.masksToBounds = true
        addSubview(circleView)
        
        circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circleView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: circleSizeMultiplier).isActive = true
        circleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: circleSizeMultiplier).isActive = true
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(CropDragPointView.panGestureRecognized(_:)))
        gesture.maximumNumberOfTouches = 1
        addGestureRecognizer(gesture)
        updateView()
    }
    
    private func updateView() {
        backgroundColor = .clear
        circleView.backgroundColor = tintColor
        circleView.layer.cornerRadius = min(circleView.bounds.width/2.0, circleView.bounds.height/2.0)
    }
    
    private func updatePosition(withStartingCenter starting: CGPoint, translation: CGPoint) {
        guard let superview = superview else { return }
        let translatedCenter = CGPoint(x: starting.x + translation.x, y: starting.y + translation.y)
        var newCenter = center
        if direction.contains(.leftRight) {
            newCenter.x = max(min(translatedCenter.x, superview.bounds.maxX), 0)
        }
        if direction.contains(.upDown) {
            newCenter.y = max(min(translatedCenter.y, superview.bounds.maxY), 0)
        }
        
        for view in centeredBetween {
            if direction == .upDown {
                view.center.y = newCenter.y
            } else if direction == .leftRight {
                view.center.x = newCenter.x
            }
        }
        
        center = newCenter
        linkedXCorner?.center.x = newCenter.x
        linkedYCorner?.center.y = newCenter.y
        delegate?.cropDragPointView(self, updatedCenter: center)
    }
}
