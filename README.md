# **TextDetectionTesting**

This project is Text Detection on iOS using [Vision](https://developer.apple.com/documentation/vision) built-in model.  
If you are interested in iOS + Machine Learning, visit [here](https://github.com/motlabs/iOS-Proejcts-with-ML-Models) you can see various DEMOs.



![](/Users/theseusX12/Desktop/FirstWallpaper.png)

---

## Requirements

- Xcode 9.2+

- iOS 12.0+

- Swift 4.2
  
  
  
  
  
  

---

## Performance

### Inference Time

| device        | inference time |
| ------------- | -------------- |
| iPhone XS Max | 10 ms          |



---

## Build & Run

1. ### Prerequisites
   
   Add permission in info.plist for device's camera access.

2. ### Dependencies
   
   No external library yet

3. ### Code
   
   ##### 3.1 Import Vision framework
   
   ```swift
   import Vision
   ```
   
   ##### 3.2 Define properties for vision
   
   ```
   var request: VNDetectTextRectanglesRequest?
   ```
   
   ##### 3.3 Configure and prepare
   
   ```
        
       override func viewDidLoad() {
           super.viewDidLoad()
           measure.delegate = self
        let request = VNDetectTextRectanglesRequest(completionHandler: self.visionDidComplete)
        }
    
        
       
       
       func visionDidComplete(request: VNRequest, error: Error?) {
           self.measure.labeling(with: "endInference")
   
           
           }
   ```
   
   ##### 3.4 Infernece
   
   ```
   
   ```
   
   
   
   
   
   ### 
   
   
   
   


