//
//  ViewController.swift
//  test
//
//  Created by 宋小伟 on 2022/9/30.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var image4: UIImageView!
    
    let imageUrls = [
        "https://tenfei04.cfp.cn/creative/vcg/800/new/VCG41N1060392686.jpg",
        "https://tenfei04.cfp.cn/creative/vcg/veer/1600water/veer-143433288.jpg",
        "https://alifei02.cfp.cn/creative/vcg/veer/1600water/veer-130236201.jpg",
        "https://alifei01.cfp.cn/creative/vcg/veer/1600water/veer-347236730.jpg"

    ]
    
    var images = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        images.append(image1)
        images.append(image2)
        images.append(image3)
        images.append(image4)
    }

    @IBAction func downloadImage(_ sender: UIButton) {
       // queueSerival()
       // queueGlobal()
        queueOperation()
    }
    
    @IBAction func clearDownload(_ sender: UIButton) {
        for i in 0...3 {
            images[i].image = nil
        }
    }
    
    let queue = OperationQueue();
    
    @IBAction func cancleOpration(_ sender: UIButton) {
        queue.cancelAllOperations()
    }
    
    func getImageData(urlName: String) -> Data? {
        let url = URL(string: urlName)
        return try! Data(contentsOf: url!)
    }
    
    func queueSerival() {
        let serial = dispatch_queue_serial_t(label: "com.boxueio.images1")
        serial.async {
            for i in 0...3 {
                if let data = self.getImageData(urlName: self.imageUrls[i]) {
                    DispatchQueue.main.async {
                        self.images[i].image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func queueGlobal() {
        let curQueue = dispatch_queue_concurrent_t(label:"com.boxueio.images2")

        for i in 0...3 {
            curQueue.async {
                if let data = self.getImageData(urlName: self.imageUrls[i]) {
                    DispatchQueue.main.async {
                        self.images[i].image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func queueOperation() {
        for i in 0...3 {
            let index = i
            let op = BlockOperation(block: {
                if let data = self.getImageData(urlName: self.imageUrls[i]) {
                    OperationQueue.main.addOperation({
                        self.images[i].image = UIImage(data: data)
                    })
                }
            })
            op.completionBlock = { print("\(index) is complete")}
            queue.addOperation(op)
        }
    }
}

