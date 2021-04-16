//
//  String+Addition.swift
//  HeartRecording
//
//  Created by MagicAna on 2021/4/16.
//

import Foundation


public extension String {
    static func stringFromTime(_ time: CGFloat) -> String {
        var string = ""
        let minutes = floor(time / 60)
        let seconds = floor((time - minutes * 60))
        string.append(String(format: "%02d", Int(minutes)))
        string.append(":")
        string.append(String(format: "%02d", Int(seconds)))
        return string
    }
}
