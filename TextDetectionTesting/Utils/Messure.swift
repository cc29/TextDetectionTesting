//
//  Messure.swift
//  ObjectDetectionTesting
//
//  Created by Theseus on 17/07/20.
//  Copyright © 2020 Theseus. All rights reserved.
//

import UIKit

protocol MeasureDelegate {
    func updateMeasure(inferenceTime: Double, executiontime: Double, fps: Int)
    }

class Measure {
    var delegate : MeasureDelegate?
    
    var index = -1
    var measurememnts : [Dictionary<String,Double>]
    
    init() {
        let measurement = [
            "start" : CACurrentMediaTime(),
            "end" : CACurrentMediaTime()]
        
        measurememnts = Array<Dictionary<String, Double>>(repeating: measurement, count: 30)
        print(12)
        
    }
    
    func startMeasuring() {
        index += 1
        index = index % 30
        measurememnts[index] = [:]
        labeling(for: index, with: "start")
        print(13)
    }
    
    func stopMeasuring() {
        print(14)
        labeling(for: index, with: "end")
        let beforeMeasuement = getBeforeMeasurement(for: index)
        let currentMeasument = measurememnts[index]
        if let startTime = currentMeasument["start"],
        let endInferenceTime = currentMeasument["endInference"],
        let endTime = currentMeasument["end"],
        let beforeStartTime = beforeMeasuement["start"] {
            delegate?.updateMeasure(inferenceTime: endInferenceTime - startTime, executiontime: endTime - startTime, fps: Int(1 / (startTime - beforeStartTime)))
        }
        }
    
    func labeling(with msg: String? = "") {
        labeling(for: index, with: msg)
        print(16)
    }
    private func labeling(for index: Int, with msg: String? = "") {
        if let message = msg {
            print(17)
            measurememnts[index][message] = CACurrentMediaTime()
        }
    }
    
    private func getBeforeMeasurement(for index: Int) -> Dictionary<String, Double> {
        return measurememnts[(index + 30 - 1) % 30]
    }
}
