//
//  ViewController.swift
//  SlideshowApp
//
//  Created by KAZUKI-OGATA on 2021/06/08.
//

import UIKit

class ViewController: UIViewController {
    var imageIndex: Int = 0
    var images: [UIImage]!
    var imageCount: Int!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    
    var timer: Timer?
    
    @IBOutlet weak var imageSlide: UIImageView!
    
    func loadImages() {
        self.images = [
            UIImage(named: "bird.png")!,
            UIImage(named: "cat.jpeg")!,
            UIImage(named: "dog.jpeg")!,
        ]
        self.imageCount = self.images.count
    }
    
    func setCurrentImage() {
        self.imageSlide.image = self.images[imageIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadImages()
        setCurrentImage()
    }

    func moveDiffPagesImage(_ diff: Int) {
        imageIndex = (imageIndex + self.imageCount + (diff % self.imageCount)) % self.imageCount
        setCurrentImage()
    }

    @IBAction func nextImage(_ sender: Any) {
       moveDiffPagesImage(1)
    }
    
    @IBAction func previousImage(_ sender: Any) {
        moveDiffPagesImage(-1)
    }
    
    @IBAction func toggleStartStop(_ sender: Any) {
        if(timer == nil){
            // to start
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
            
            nextButton.isEnabled = false
            previousButton.isEnabled = false
            timerButton.setTitle("停止", for: .normal)
        } else{
            timer?.invalidate()
            timer = nil
            
            nextButton.isEnabled = true
            previousButton.isEnabled = true
            timerButton.setTitle("再生", for: .normal)
        }
    }
    
    @objc func updateTimer(_ timer : Timer){
        moveDiffPagesImage(1)
    }
    
    @IBAction func tapImage(_ sender: Any) {
        // スライドショーが動いていると元の画像に戻ってこれないので止めておく
        timer?.invalidate()
        timer = nil
        
        nextButton.isEnabled = true
        previousButton.isEnabled = true
        timerButton.setTitle("再生", for: .normal)
        
        performSegue(withIdentifier: "showImageScene", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImageScene"){
            let controller: ShowViewController = segue.destination as! ShowViewController
            // set actions
            controller.image = self.images[imageIndex]
            return
        }
    }

    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // none
    }
}

