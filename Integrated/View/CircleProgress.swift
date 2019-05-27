//
//  RMDownloadIndicator.swift
//  RMDownloadIndicator-Swift
//
//  Created by Mahesh Shanbhag on 10/08/15.
//  Copyright (c) 2015 Mahesh Shanbhag. All rights reserved.
//

import UIKit

enum CircleProgressType: Int {
    case Closed = 0
    case Filled
    case Mixed
}

class CircleProgress: UIView {
    
    // this value should be 0 to 0.5 (default: (kRMFilledIndicator = 0.5), (kRMMixedIndictor = 0.4))
    var radiusPercent: CGFloat = 0.5 {
        didSet {
            if type == CircleProgressType.Closed {
                self.radiusPercent = 0.5
            }
            if radiusPercent > 0.5 || radiusPercent < 0 {
                radiusPercent = oldValue
            }
        }
    }
    
    // used to fill the downloaded percent slice (default: (kRMFilledIndicator = white), (kRMMixedIndictor = white))
	var fillColor: UIColor = UIColor.clear {
        didSet {
            if type == CircleProgressType.Closed {
				fillColor = UIColor.clear
            }
        }
    }
    
    // used to stroke the covering slice (default: (kRMClosedIndicator = white), (kRMMixedIndictor = white))
    var strokeColor: UIColor = UIColor.white
    
    // used to stroke the background path the covering slice (default: (kRMClosedIndicator = gray))
    var closedIndicatorBackgroundStrokeColor: UIColor = UIColor.white
    
    
    // Private properties
    private var paths: [CGPath] = []
    private var indicateShapeLayer: CAShapeLayer!
    private var coverLayer: CAShapeLayer!
    private var animatingLayer: CAShapeLayer!
    private var type: CircleProgressType!
    private var coverWidth: CGFloat = 0.0
    private var lastUpdatedPath: UIBezierPath!
    private var lastSourceAngle: CGFloat = 0.0
    private var animationDuration: CGFloat = 0.0
    
    
    
    // init with frame and type
    // if() - (id)initWithFrame:(CGRect)frame is used the default type = kRMFilledIndicator
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        self.type = .Filled
        self.initAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rectframe: CGRect, type: CircleProgressType) {
        super.init(frame: rectframe)
        
        self.type = type
        self.initAttributes()
    }
    
    func initAttributes() {
        if type == CircleProgressType.Closed {
            self.radiusPercent = 0.5
            coverLayer = CAShapeLayer()
            animatingLayer = coverLayer
            fillColor = UIColor.clear
            strokeColor = UIColor.white
            closedIndicatorBackgroundStrokeColor = UIColor.gray
            coverWidth = 2.0
        }
        else {
            if type == CircleProgressType.Filled {
                indicateShapeLayer = CAShapeLayer()
                animatingLayer = indicateShapeLayer
                radiusPercent = 0.5
                coverWidth = 2.0
                closedIndicatorBackgroundStrokeColor = UIColor.clear
            }
            else {
                indicateShapeLayer = CAShapeLayer()
                coverLayer = CAShapeLayer()
                animatingLayer = indicateShapeLayer
                coverWidth = 2.0
                radiusPercent = 0.4
                closedIndicatorBackgroundStrokeColor = UIColor.white
            }
            fillColor = UIColor.white
            strokeColor = UIColor.white
        }
        
        animatingLayer.frame = self.bounds
        self.layer.addSublayer(animatingLayer)
        animationDuration = 0.5
    }
    
    // prepare the download indicator
    func loadIndicator() {
		let center: CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        let initialPath: UIBezierPath = UIBezierPath.init()
        if type == CircleProgressType.Closed {
			initialPath.addArc(withCenter: center, radius: (fmin(self.bounds.size.width, self.bounds.size.height)), startAngle: degreeToRadian(degree: -90), endAngle: degreeToRadian(degree: -90), clockwise: true)
        }
        else {
            if type == CircleProgressType.Mixed {
                self.setNeedsDisplay()
            }
            let radius: CGFloat = (fmin(self.bounds.size.width, self.bounds.size.height) / 2) * self.radiusPercent
			initialPath.addArc(withCenter: center, radius: radius, startAngle: degreeToRadian(degree: -90), endAngle: degreeToRadian(degree: -90), clockwise: true)
        }
		animatingLayer.path = initialPath.cgPath
		animatingLayer.strokeColor = strokeColor.cgColor
		animatingLayer.fillColor = fillColor.cgColor
        animatingLayer.lineWidth = coverWidth
		self.lastSourceAngle = degreeToRadian(degree: -90)
    }
    
    func keyframePathsWithDuration(duration: CGFloat, lastUpdatedAngle: CGFloat, newAngle: CGFloat, radius: CGFloat, type: CircleProgressType) -> [CGPath] {
        let frameCount: Int = Int(ceil(duration * 60))
        var array: [CGPath] = []
        for frame in 0 ... frameCount {
			let startAngle = degreeToRadian(degree: -90)
            
            let angleChange = ((newAngle - lastUpdatedAngle) * CGFloat(frame))
            let endAngle = lastUpdatedAngle + (angleChange / CGFloat(frameCount))
			array.append((self.pathWithStartAngle(startAngle: startAngle, endAngle: endAngle, radius: radius, type: type).cgPath))
        }
        return array
    }
    
    func pathWithStartAngle(startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat, type: CircleProgressType) -> UIBezierPath {
        let clockwise: Bool = startAngle < endAngle
        let path: UIBezierPath = UIBezierPath()
		let center: CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        if type == CircleProgressType.Closed {
			path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        }
        else {
			path.move(to: center)
			path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
			path.close()
        }
        return path
    }
    
	override func draw(_ rect: CGRect) {
        if type == CircleProgressType.Mixed {
            let radius: CGFloat = fmin(self.bounds.size.width, self.bounds.size.height) / 2 - self.coverWidth
			let center: CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            let coverPath: UIBezierPath = UIBezierPath()
            coverPath.lineWidth = coverWidth
			coverPath.addArc(withCenter: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(2 * Double.pi), clockwise: true)
            closedIndicatorBackgroundStrokeColor.set()
            coverPath.stroke()
        }
        else {
            if type == CircleProgressType.Closed {
                let radius: CGFloat = (fmin(self.bounds.size.width, self.bounds.size.height) / 2) - self.coverWidth
                let center: CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
                let coverPath: UIBezierPath = UIBezierPath()
                coverPath.lineWidth = coverWidth
				coverPath.addArc(withCenter: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(2 * Double.pi), clockwise: true)
                closedIndicatorBackgroundStrokeColor.set()
                coverPath.lineWidth = self.coverWidth
                coverPath.stroke()
            }
        }
    }
    
    // update the downloadIndicator
    func updateWithTotalBytes(bytes: CGFloat, downloadedBytes: CGFloat) {
		lastUpdatedPath = UIBezierPath.init(cgPath: animatingLayer.path!)
		paths.removeAll(keepingCapacity: false)
		let destinationAngle: CGFloat = self.destinationAngleForRatio(ratio: (downloadedBytes / bytes))
		let radius: CGFloat = (fmin(self.bounds.size.width, self.bounds.size.height) * radiusPercent) - self.coverWidth
		paths = self.keyframePathsWithDuration(duration: self.animationDuration, lastUpdatedAngle: self.lastSourceAngle, newAngle: destinationAngle, radius: radius, type: type)
        animatingLayer.path = paths[(paths.count - 1)]
        self.lastSourceAngle = destinationAngle
        let pathAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
        pathAnimation.values = paths
        pathAnimation.duration = CFTimeInterval(animationDuration)
		pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		pathAnimation.isRemovedOnCompletion = true
		animatingLayer.add(pathAnimation, forKey: "path")
        if downloadedBytes >= bytes{
            self.removeFromSuperview()
        }
    }
    
    func destinationAngleForRatio(ratio: CGFloat) -> CGFloat {
		return (degreeToRadian(degree: (360 * ratio) - 90))
    }
    
    
    func degreeToRadian(degree: CGFloat) -> CGFloat
    {
        return (CGFloat(degree) * CGFloat(Double.pi)) / CGFloat(180.0);
    }
//    
//    func setLayerFillColor(fillColor: UIColor) {
//        if type == RMIndicatorType.kRMClosedIndicator {
//            self.fillColor = UIColor.clearColor()
//        }
//        else {
//            self.fillColor = fillColor
//        }
//    }
    
//    func setLayerRadiusPercent(radiusPercent: CGFloat) {
//        if type == RMIndicatorType.kRMClosedIndicator {
//            self.radiusPercent = 0.5
//            return
//        }
//        if radiusPercent > 0.5 || radiusPercent < 0 {
//            return
//        }
//        else {
//            self.radiusPercent = radiusPercent
//        }
//    }
    
    // update the downloadIndicator
    func setIndicatorAnimationDuration(duration: CGFloat) {
        self.animationDuration = duration
    }
}
