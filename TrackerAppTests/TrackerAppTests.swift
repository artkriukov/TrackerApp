//
//  TrackerAppTests.swift
//  TrackerAppTests
//
//  Created by Artem Kriukov on 03.07.2025.
//

import XCTest
import SnapshotTesting
@testable import TrackerApp

final class MainScreenSnapshotTests: XCTestCase {
    func testMainScreen_Light() {
        let vc = TrackersViewController()
        vc.overrideUserInterfaceStyle = .light
        vc.view.frame = UIScreen.main.bounds
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light))
        )
    }
    
    func testMainScreen_Dark() {
        let vc = TrackersViewController()
        vc.overrideUserInterfaceStyle = .dark
        vc.view.frame = UIScreen.main.bounds
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark))
        )
    }
}
