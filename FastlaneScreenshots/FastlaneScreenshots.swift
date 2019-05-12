//
//  FastlaneScreenshots.swift
//  FastlaneScreenshots
//
//  Created by Alexander Schulz on 12.05.19.
//  Copyright © 2019 Alexander Schulz. All rights reserved.
//

import XCTest

class FastlaneScreenshots: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

		let app = XCUIApplication()
		setupSnapshot(app)
		app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimerOverview() {
		MulTimerManager.shared.addNewTimer(timer: MulTimer(name: "Noodles", durationTotal: 420, color: ColorPicker.nextColor()), state: .visible)
		MulTimerManager.shared.addNewTimer(timer: MulTimer(name: "Laundry", durationTotal: 1826, color: ColorPicker.nextColor()), state: .visible)
		MulTimerManager.shared.addNewTimer(timer: MulTimer(name: "Call back John", durationTotal: 3280, color: ColorPicker.nextColor()), state: .visible)
		
		let app = XCUIApplication()
		app.navigationBars["Timers"].buttons["Item"].tap()
		app.navigationBars["Settings"].buttons["Timers"].tap()
		
		snapshot("TimerOverview")
    }

}
