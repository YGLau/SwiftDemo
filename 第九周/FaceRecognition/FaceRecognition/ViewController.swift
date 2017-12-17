//
//  ViewController.swift
//  FaceRecognition
//
//  Created by 刘勇刚 on 17/12/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var genderL: UILabel!
    @IBOutlet weak var ageL: UILabel!
    @IBOutlet weak var emotionsL: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "oldman") else {
            fatalError("no starting image")
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        detectScene(image: ciImage)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        present(pickerController, animated: true)
    }
    
    fileprivate func detectScene(image: CIImage) {
        genderL.text = "detecting scene..."
        ageL.text = "......"
        emotionsL.text = "......"
        
        // 从生成的类中加载 ML模型
        guard let genderModel = try? VNCoreMLModel(for: GenderNet().model),let ageModel = try? VNCoreMLModel(for: AgeNet().model),let emotionModel = try? VNCoreMLModel(for: CNNEmotions().model) else {
            fatalError("can't load ML model")
        }
        
        // 创建一个带有 completion handler 的 Vision 请求
        let request = VNCoreMLRequest(model: genderModel) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            DispatchQueue.main.async { [weak self] in
                self?.genderL.text = "Gender: \(topResult.identifier) \(Int(topResult.confidence * 100))% "
            }
        }
        
        let ageRequest = VNCoreMLRequest(model: ageModel) { [weak self] ageRequest, error in
            guard let ageResults = ageRequest.results as? [VNClassificationObservation],
                let topAgeResult = ageResults.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            DispatchQueue.main.async { [weak self] in
                self?.ageL.text = "Age: \(topAgeResult.identifier) \(Int(topAgeResult.confidence * 100))% "
            }
        }
        let emotionRequest = VNCoreMLRequest(model: emotionModel) { [weak self] emotionRequest, error in
            guard let emotionResults = emotionRequest.results as? [VNClassificationObservation],
                let topEmotionResult = emotionResults.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            DispatchQueue.main.async { [weak self] in
                self?.emotionsL.text = "Emotions: \(topEmotionResult.identifier) \(Int(topEmotionResult.confidence * 100))% "
            }
        }
        
        // 在主线程上运行 Core ML GoogLeNetPlaces 分类器
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            try? handler.perform([request])
        }
        let ageHandler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            try? ageHandler.perform([ageRequest])
        }
        let emotionHandler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            try? emotionHandler.perform([emotionRequest])
        }
    }
}

// MARK: - UIImagePickerControllerDelegate && UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        imageView.image = image
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        detectScene(image: ciImage)
    }
}
