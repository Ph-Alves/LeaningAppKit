//
//  AcessibilityHelper.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 22/06/26.
//

import Foundation
import AppKit
import ApplicationServices

//enum AcessibilityHelper {
//    static func hasPermission() -> Bool {
//        return AXIsProcessTrusted()
//    }
//    
//    @discardableResult
//    static func requestPermission() -> Bool {
//        let key = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
//        let options = [key: true] as CFDictionary
//        return AXIsProcessTrustedWithOptions(options)
//    }
//    
//    static func openAccessibilitySettings() {
//        let urlStr = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
//        if let url = URL(string: urlStr) {
//            NSWorkspace.shared.open(url)
//        }
//    }
//}
