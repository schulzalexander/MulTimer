//
//  TutorialPageViewController.swift
//  MulTimer
//
//  Created by Alexander Schulz on 05.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

	var controllers: [UIViewController]!
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		for view in self.view.subviews {
			
			if view is UIScrollView {
				view.frame = UIScreen.main.bounds
			} else if view is UIPageControl {
				view.backgroundColor = UIColor.clear
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = self
		
		let contents = [
			TutorialPage(title: NSLocalizedString("TutorialMainAddButtonTitle", comment: ""), explanation: NSLocalizedString("TutorialMainAddButtonExplanation", comment: ""), image: UIImage(named: "TutorialMainAddButton") ?? UIImage()),
			TutorialPage(title: NSLocalizedString("TutorialAddContainerTitle", comment: ""), explanation: NSLocalizedString("TutorialAddContainerExplanation", comment: ""), image: UIImage(named: "TutorialAddContainer") ?? UIImage()),
			TutorialPage(title: NSLocalizedString("TutorialNamedUnnamedTitle", comment: ""), explanation: NSLocalizedString("TutorialNamedUnnamedExplanation", comment: ""), image: UIImage(named: "TutorialNamedUnnamed") ?? UIImage()),
			TutorialPage(title: NSLocalizedString("TutorialPauseTimerTitle", comment: ""), explanation: NSLocalizedString("TutorialPauseTimerExplanation", comment: ""), image: UIImage(named: "TutorialPauseTimer") ?? UIImage()),
			TutorialPage(title: NSLocalizedString("TutorialTimerFinishedTitle", comment: ""), explanation: NSLocalizedString("TutorialTimerFinishedExplanation", comment: ""), image: UIImage(named: "TutorialTimerFinished") ?? UIImage())
		]
		controllers = [UIViewController]()
		for content in contents {
			let newController = TutorialViewController(content: content)
			controllers.append(newController)
		}
		setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
		
		setupDotAppearance()
		setupCancelButton()
	}
	
	
	private func setupDotAppearance() {
		//dots setup
		let appearance = UIPageControl.appearance()
		appearance.pageIndicatorTintColor = UIColor.lightGray
		appearance.currentPageIndicatorTintColor = UIColor.black
		appearance.backgroundColor = UIColor.clear
		
		appearance.layer.position.x = self.view.center.x
		appearance.layer.position.y = self.view.center.y
	}
	
	private func setupCancelButton() {
		let dim: CGFloat = 50 // Cancel Button dimension
		let buttonFrame = CGRect(x: view.frame.maxX - dim, y: 20, width: dim, height: dim)
		let button = UIButton(frame: buttonFrame)
		button.setTitle("×", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.titleLabel?.font = button.titleLabel?.font.withSize(40)
		button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
		self.view.insertSubview(button, aboveSubview: self.view)
	}
	
	@objc private func cancel() {
		dismiss(animated: true) {
			Settings.shared.firstAppStart = false
			SettingsArchive.save()
		}
	}
	
}


//MARK: PageViewControllerDataSource
extension TutorialPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let index = controllers.index(of: viewController) else {
			return nil
		}
		
		let prevIndex = index-1
		guard prevIndex < controllers.count else {
			return nil
		}
		
		guard prevIndex >= 0 else {
			return controllers.last
		}
		
		return controllers[prevIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let index = controllers.index(of: viewController) else {
			return nil
		}
		
		let nextIndex = index+1
		guard nextIndex >= 0 else {
			return nil
		}
		
		guard nextIndex < controllers.count else {
			return controllers.first
		}
		
		return controllers[nextIndex]
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return controllers.count
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		guard let firstViewController = viewControllers?.first,
			let index = controllers.index(of: firstViewController) else {
				return 0
		}
		return index
	}
	
	
}
