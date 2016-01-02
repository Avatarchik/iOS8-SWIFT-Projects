//
//  ViewController.swift
//  FunnyJunk_v0.5
//
//  Created by Matt on 1/15/15.
//  Copyright (c) 2015 Raporte. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var time = 0
    var pictureCount = 0
    var imagePageUrlArray = [String]()
    var imageUrlArray = [String]()
    var imageTitleArray = [String]()
    
    
    @IBOutlet var scrollView: UIScrollView!
    var imageView: UIImageView!
    

    
    @IBAction func displayPrev(sender: AnyObject) {
        if pictureCount > 0{
            pictureCount--
            var newImgUrl = NSURL(string: imageUrlArray[pictureCount])
            var imgData = NSData(contentsOfURL: newImgUrl!)
            var image = UIImage(data: imgData!)
            imageView.image = image
        }
    }
    
    @IBAction func displayNext(sender: AnyObject) {
        for line in imageUrlArray{
            println(line)
        }
        
        if pictureCount < self.imageUrlArray.count {
            pictureCount++
            var newImgUrl = NSURL(string: imageUrlArray[pictureCount])
            
            
            
            var imgData = NSData(contentsOfURL: newImgUrl!)
            
            
            
            var image = UIImage(data: imgData!)
            imageView.image = image
            println(imageTitleArray[pictureCount])
        }
        else if pictureCount == self.imageUrlArray.count{
            pictureCount++
            var image = UIImage(named: "EndPage.png")
            imageView.image = image
        }

    }
    
 
    
    func timer(){
        time++
    }
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //timer for testing
        println("Beta version testing")
        var timer = NSTimer.scheduledTimerWithTimeInterval((1/100), target: self, selector: Selector("timer"), userInfo: nil, repeats: true)
        
        //scraping
        var url = NSURL(string: "https://funnyjunk.com/rss/most_popular.rss")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){(data, response,error) in
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            var rssFeedScrape = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println("SCRAPE 1:\n\n\n") //prints initial scrape.. for testing
            println(rssFeedScrape)
            println("END SCRAPE 1 \n\n\n")
            
            if rssFeedScrape!.containsString("link"){
                println("[TIME: \(self.time/100).\(self.time%100) SECONDS] Scrape Succeseful \n\n\n")
                
                //creating array of image page urls
                var processingScrape = rssFeedScrape!.componentsSeparatedByString("<link>")
                for line in processingScrape{
                    var processingScrape2 = (line as NSString).componentsSeparatedByString("</link>")
                    var tempUrl : String = processingScrape2[0] as String
                    self.imagePageUrlArray.append(tempUrl)
                }
                //creating array of image urls
                if(self.imagePageUrlArray.count > 2){
                    self.imagePageUrlArray.removeAtIndex(0)
                    self.imagePageUrlArray.removeAtIndex(0)
                    println("[TIME: \(self.time/100).\(self.time%100) SECONDS] Image Page URL Array Assembled Complete.")
                    for line in self.imagePageUrlArray{
                        
                        var imgPageUrl = NSURL(string: line as String)
                        
                        //print("image url generated: \t")//TESTING
                        //println(imgPageUrl)
                        
                        let task2 = NSURLSession.sharedSession().dataTaskWithURL(imgPageUrl!){(data, response,error) in
                            
                            
                            var imagePageScrape = NSString(data: data, encoding: NSUTF8StringEncoding)
                            
                            //println("page scrape:")
                            //println(imagePageScrape)
                            //println("\n\n\n")
                            
                            
                            var imagePageScrapeProcessing = imagePageScrape!.componentsSeparatedByString("src=\"")
                            
                            println("scrape processing:")
                            println(imagePageScrapeProcessing[1])
                            println("\n\n")
                            
                            if imagePageScrapeProcessing.count > 2{
                                
                               
                                
                                
                                var finalImageUrl = imagePageScrapeProcessing[1].componentsSeparatedByString("\"")
                                /*println("final image Url:")
                                for line in finalImageUrl{
                                    println(line)
                                }
                                println("\n\n")
                                */
                                
                                
                                if !finalImageUrl[0].containsString(".gif"){ //gif handling.. eventually needs actual implementation
                                    self.imageUrlArray.append(finalImageUrl[0] as String)
                                    
                                    //print("imageUrlArray: appended: \t")//TESTING
                                    //println(finalImageUrl[0] as String)
                                    
                                    var imagePageScrapeProcessing2 = imagePageScrape!.componentsSeparatedByString("name=\"title\" content=\"")
                                    var imagePageScrapeProcessing3 = imagePageScrapeProcessing2[1].componentsSeparatedByString("\"")
                                    var temp : String = imagePageScrapeProcessing3[0] as String
                                    var temp2 = temp.stringByReplacingOccurrencesOfString("&#039;", withString: "'")
                                    
                                    self.imageTitleArray.append(temp2)
                                }
                                
                            }
                            
                            
                            
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            task2.resume()
                        }
                    }
                    println("[TIME: \(self.time/100).\(self.time%100) SECONDS] Image URL Array Assembly Complete.")
                    
                    
                    
                    
                    
                }
                
                
            }
            else{
                println("[TIME: \(self.time/100).\(self.time%100) SECONDS] Scrape Unsucceseful: Error 0")
            }
            
            
        }
        task.resume()
        
        // 1
        let image = UIImage(named: "TitlePage.png")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
        scrollView.addSubview(imageView)
        
        // 2
        scrollView.contentSize = image.size
        
        // 3
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        // 4
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        // 5
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
        // 6
        centerScrollViewContents()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView!) {
        centerScrollViewContents()
    }


}

