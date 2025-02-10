//
//  BusStopTime.swift
//  NYU_Bus_Helper
//
//  Created by Daniel Brito on 7/18/24.
//
import Foundation

struct BusStopTime: Identifiable {
    var id = UUID()
    var stop: String
    var time: String
}
