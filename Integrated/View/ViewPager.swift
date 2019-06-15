//
//  ViewPager.swift
//  ViewPager
//
//  Created by Septiyan Andika on 6/26/16.
//  Copyright © 2016 sailabs. All rights reserved.
//

import UIKit

@objc public protocol  ViewPagerDataSource {
    func numberOfItems(viewPager:ViewPager) -> Int
    func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView
    @objc optional func didSelectedItem(index:Int)
    
}

protocol ViewPagerDelegate {
	func viewPager(_ viewPager: ViewPager, didSelectedItem itemIndex: Int)
}

public class ViewPager: UIView {
    
    var pageControl: UIPageControl = UIPageControl()
    var scrollView: UIScrollView = UIScrollView()
    var currentPosition: Int = 0
    
    var dataSource: ViewPagerDataSource? = nil {
        didSet {
            reloadData()
        }
    }
	var delegate: ViewPagerDelegate? = nil
    
    var numberOfItems: Int = 0
    var itemViews: Dictionary<Int, UIView> = [:]
    
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		reloadViews()
	}
    
    func setupView() {
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        setupScrollView();
        setupPageControl();
        reloadData()
    }
    
    func setupScrollView() {
        scrollView.isPagingEnabled = true;
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self;
        let topContraints = NSLayoutConstraint(item: scrollView, attribute:
            .top, relatedBy: .equal, toItem: self,
				  attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0,
                  constant: 0)
        
        let bottomContraints = NSLayoutConstraint(item: scrollView, attribute:
            .bottom, relatedBy: .equal, toItem: self,
					 attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0,
                     constant: 0)
        
        let leftContraints = NSLayoutConstraint(item: scrollView, attribute:
            .leadingMargin, relatedBy: .equal, toItem: self,
                            attribute: .leadingMargin, multiplier: 1.0,
                            constant: 0)
        
        let rightContraints = NSLayoutConstraint(item: scrollView, attribute:
            .trailingMargin, relatedBy: .equal, toItem: self,
                             attribute: .trailingMargin, multiplier: 1.0,
                             constant: 0)
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topContraints,rightContraints,leftContraints,bottomContraints])
    }
    
    func setupPageControl() {
        
        self.pageControl.numberOfPages = numberOfItems
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        
        
        let heightContraints = NSLayoutConstraint(item: pageControl, attribute:
            .height, relatedBy: .equal, toItem: nil,
					 attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0,
                     constant: 25)
        
        let bottomContraints = NSLayoutConstraint(item: pageControl, attribute:
            .bottom, relatedBy: .equal, toItem: self,
					 attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0,
                     constant: 0)
        
        let leftContraints = NSLayoutConstraint(item: pageControl, attribute:
            .leadingMargin, relatedBy: .equal, toItem: self,
                            attribute: .leadingMargin, multiplier: 1.0,
                            constant: 0)
        
        let rightContraints = NSLayoutConstraint(item: pageControl, attribute:
            .trailingMargin, relatedBy: .equal, toItem: self,
                             attribute: .trailingMargin, multiplier: 1.0,
                             constant: 0)
        
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([heightContraints,rightContraints,leftContraints,bottomContraints])
    }
    
    
    func reloadData() {
        if dataSource != nil {
            numberOfItems = (dataSource?.numberOfItems(viewPager: self))!
        }
        self.pageControl.numberOfPages = numberOfItems
        
        itemViews.removeAll()
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
		
        DispatchQueue.main.async {
			self.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.scrollView.contentSize = CGSize(width: self.frame.width *  CGFloat(self.numberOfItems) , height: self.frame.height)
            self.reloadViews()
        }
    }
    
    func loadViewAtIndex(_ index: Int) {
        let view: UIView?
        if(dataSource != nil){
            view =  (dataSource?.viewAtIndex(viewPager: self, index: index, view: itemViews[index]))!
        }else{
            view = UIView()
        }
        
        setFrameForView(view: view!, index: index);
        
        
        if(itemViews[index] == nil){
            itemViews[index] = view
            let tap = UITapGestureRecognizer(target: self, action:  #selector(self.handleTapSubView))
            tap.numberOfTapsRequired = 1
            itemViews[index]!.addGestureRecognizer(tap)
            
            scrollView.addSubview(itemViews[index]!)
        } else {
            itemViews[index] = view
        }
    }
    
	@objc func handleTapSubView() {
        if(dataSource?.didSelectedItem != nil){
            dataSource?.didSelectedItem!(index: currentPosition)
        }
    }
    
    
    func reloadViews() {
        for i in 0 ..< numberOfItems {
            loadViewAtIndex(i)
        }
    }
    
    func setFrameForView(view: UIView, index: Int) {
        view.frame = CGRect(x: self.frame.width * CGFloat(index), y: 0,
							width: self.frame.width,
							height: self.frame.height)
		view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleLeftMargin.rawValue
			| UIViewAutoresizing.flexibleTopMargin.rawValue
			| UIViewAutoresizing.flexibleWidth.rawValue
			| UIViewAutoresizing.flexibleHeight.rawValue)
		print(view.frame)
    }
}

extension ViewPager: UIScrollViewDelegate {
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self)
        var pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageNumber = pageNumber + 1
        pageControl.currentPage = Int(pageNumber)
//        currentPosition = pageControl.currentPage
//        scrollToPage(index: Int(pageNumber))
		
		let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
		self.delegate?.viewPager(self, didSelectedItem: index)
    }
    
    //http://stackoverflow.com/a/1857162
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        NSObject.cancelPreviousPerformRequests(withTarget: scrollView)
//        self.perform(#selector(self.scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.1)
		
		let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
		self.delegate?.viewPager(self, didSelectedItem: index)
    }
	
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
		self.delegate?.viewPager(self, didSelectedItem: index)
	}
}

extension ViewPager {
    func animationNext(){
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewPager.moveToNextPage), userInfo: nil, repeats: true)
    }
	
	@objc func moveToNextPage () {
		currentPosition = min(currentPosition+1, numberOfItems-1)
		self.scrollToPage(index: currentPosition)
    }
    
    func scrollToPage(index: Int) {
        if(index < numberOfItems && index >= 0) {
            let iframe = CGRect(x: self.scrollView.frame.width*CGFloat(index), y: 0,
								width: self.scrollView.frame.width,
								height: self.scrollView.frame.height);
            scrollView.setContentOffset(iframe.origin, animated: true)
            pageControl.currentPage = index
            reloadViews()
            currentPosition = index
        }
    }    
}
