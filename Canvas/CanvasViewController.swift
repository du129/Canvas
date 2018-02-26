//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Jonathan Du on 2/26/18.
//  Copyright © 2018 Jonathan Du. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!



    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 160
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down

        // Do any additional setup after loading the view.
    }


    

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)

        let translation = sender.translation(in: view)
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            //moving down
            if(velocity.y > 0) {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            }
            //moving up
            else {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            }
            
        }

    }
    
    @IBAction func didMoveFace(_ sender: UIPanGestureRecognizer) {
        //  access the translation parameter of the UIPanGestureRecocognizer and store it in a constant.
        let translation = sender.translation(in: view)
        
        // create a new image view that contains the same image as the view that was panned on
        if sender.state == .began {
            // imageView now refers to the face that you panned on
            let imageView = sender.view as! UIImageView
            
            // Create a new image view that has the same image as the one you're currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the main view
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the main view, you have to offset the coordinates.
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            // for panning
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            // scale the face out after the start of the dragging
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
            
            print("Gesture began")
        } else if sender.state == .changed {
            // pan the position of the newlyCreatedFace.
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
            
            print("Gesture is changing")
        } else if sender.state == .ended {
            print("Gesture ended")
            // after the face is droped the face will scale back to it initial size
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
            // programmatically create and add a UIPanGestureRecognizer to the newly created face in order for the Gesture Recognizer to work
            newlyCreatedFace.isUserInteractionEnabled = true
            let addGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didMoveFace2(sender:)))
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(addGestureRecognizer)
        }
        
    }
    
    @objc func didMoveFace2(sender: UIPanGestureRecognizer){
        NSLog("Paned from the main View")
        let translation = sender.translation(in: view)
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            // scale the face out after the start of the dragging
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        }
            
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
            
        else if sender.state == .ended {
            // after the face is droped the face will scale back to it initial size
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
