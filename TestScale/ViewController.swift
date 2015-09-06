//
//  ViewController.swift
//  TestScale
//
//  Created by shikaiwen on 1/9/2015.
//  Copyright (c) 2015 shikaiwen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate,VideoFeedsDelegate{
  var currentPlayer:Player!
  var square = UIView()
  var squareScrollView = UIScrollView()
  var squareWidth = screenWidth - 30
  var videoItems = ["http://apollov.blinnnk.com/ab478739c38262dbdbe7efc49bc5f59f","http://apollov.blinnnk.com/992f5658535839ba79ff324dd6b87e71","http://apollov.blinnnk.com/cdb720d0d4c9cb689cdbc113060f4894","http://apollov.blinnnk.com/edab3b4b01d227bc6774d9e09f5acb94","http://apollov.blinnnk.com/27130bc78a0dcda6ce4bc9e6ec56800b","http://apollov.blinnnk.com/c7e38a55091dc643fc20aabe81a8f3da","http://apollov.blinnnk.com/ab478739c38262dbdbe7efc49bc5f59f","http://apollov.blinnnk.com/992f5658535839ba79ff324dd6b87e71","http://apollov.blinnnk.com/cdb720d0d4c9cb689cdbc113060f4894","http://apollov.blinnnk.com/edab3b4b01d227bc6774d9e09f5acb94","http://apollov.blinnnk.com/27130bc78a0dcda6ce4bc9e6ec56800b","http://apollov.blinnnk.com/c7e38a55091dc643fc20aabe81a8f3da","http://apollov.blinnnk.com/ab478739c38262dbdbe7efc49bc5f59f"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    

    
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentVideoPlaying:", name: "avplayer", object: nil)
    //创建一个全局的ScrollView
    squareScrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    squareScrollView.backgroundColor = darkNight
    squareScrollView.contentSize = CGSize(width: 0, height: screenHeight*10)
    squareScrollView.pagingEnabled = false
    squareScrollView.delegate = self
    squareScrollView.showsVerticalScrollIndicator = false
    view.addSubview(squareScrollView)
    
    //生成一个循环队列的Square
    var squareOrginY = CGFloat(30)
      for index in 0..<8{
        square = UIView(frame: CGRect(x: 15, y: squareOrginY, width: screenWidth-30, height: screenWidth-30))
        square.backgroundColor = UIColor.whiteColor()
        square.layer.shadowColor = UIColor.blackColor().CGColor
        square.layer.shadowOpacity = 0.5
        square.layer.shadowRadius = 6
        square.layer.shadowOffset = CGSizeMake(4, 6)
        squareScrollView.addSubview(square)
        square.tag = index+1
        squareOrginY+=screenWidth-30 + 15
        
        var videoFeeds = VideoFeeds()
        videoFeeds.ViewControllerVideoPath = videoItems[index]
        videoFeeds.view.frame.size.height = screenWidth-30
        videoFeeds.delegate = self
        square.addSubview(videoFeeds.view)
        
        videoFeeds.player.playFromBeginning()
        
      }
    }

  // ──────────────────缩小动画跟踪判断的实现─────────── //
  func scrollViewDidScroll(scrollView: UIScrollView) {
    //计算出当前出现在屏幕上的Square的Tag
    var scrollViewContentOffsetY = squareScrollView.contentOffset.y + 30 - 150
    var squareTag = Int(floor(scrollViewContentOffsetY/squareWidth)+1)
    //找到需要附着动画的Square
    var squareCurrent = squareScrollView.viewWithTag(squareTag)
    //动态为每一个拥有不同Offset值得Square附着上同样得Scale取值范围
    var scaleSmall = CGFloat()
    //初始化动画以及进入动画出现的属性判断
    if(squareScrollView.contentOffset.y <= 300 && squareScrollView.contentOffset.y>120){
      scaleSmall = scrollViewContentOffsetY/1000
      if(scaleSmall<0.15){
      squareCurrent?.transform = CGAffineTransformMakeScale(1.0 - scaleSmall, 1.0 - scaleSmall)
      }else{
        scaleSmall = 0.15
      squareCurrent?.transform = CGAffineTransformMakeScale(1.0 - scaleSmall, 1.0 - scaleSmall)
      }
    }else if(scrollViewContentOffsetY>300){
      scaleSmall = (scrollViewContentOffsetY-floor(scrollViewContentOffsetY/squareWidth)*squareWidth)/1000
      if(scaleSmall<0.15){
        squareCurrent?.transform = CGAffineTransformMakeScale(1.0 - scaleSmall, 1.0 - scaleSmall)
      }else{
        scaleSmall = 0.15
        squareCurrent?.transform = CGAffineTransformMakeScale(1.0 - scaleSmall, 1.0 - scaleSmall)
      }
    }
    // ──────────────────放大动画跟踪判断的实现─────────── //
    //缩放的进度因为上面的已经被赋值不能复用
    var scaleSmall2 = (scrollViewContentOffsetY-floor(scrollViewContentOffsetY/squareWidth)*squareWidth)/1000
    //计算出屏幕上实际能放下的Square个数(是物理屏幕不是Offset)
    var squareCountInScreen = Int(floor(screenHeight/squareWidth)+1)
    //判断屏幕上出现的多余部分尺寸是否出现了大半个视图
    var squareApperaStatus =  scrollViewContentOffsetY/squareWidth - floor(scrollViewContentOffsetY/squareWidth)
    //获得即将显示进屏幕的Square的Tag并判断其赋值的状态
    var willAppearSquareTag = squareTag + squareCountInScreen+1
    if(squareApperaStatus >= 0.4 || squareScrollView.contentOffset.y < 0){
      willAppearSquareTag = squareTag + squareCountInScreen+1
    }else{
      willAppearSquareTag = squareTag + squareCountInScreen
    }
    //为这个Square命名为WillApperaSquare
    var willAppearSquareMarginLeft = (screenWidth - squareWidth*0.85)/2
    var willAppearSquare = squareScrollView.viewWithTag(willAppearSquareTag)
    var scaleBack = CGFloat(0.85+scaleSmall)
    //控制回放大的范围回复到原装
    if(scaleBack>1){
      scaleBack = 1
    }
    willAppearSquare?.transform = CGAffineTransformMakeScale(scaleBack , scaleBack)
    }
  
  func currentVideoPlaying(player: Player) {
    if (nil == self.currentPlayer) {
      self.currentPlayer = player;
      return;
    }
    
    if (self.currentPlayer == player) {
        return;
    }
    
      self.currentPlayer.pause()
      self.currentPlayer = player
  }
  
//  func currentVideoPlaying(notification:NSNotification) {
//    var player = notification.object as! Player
//    if (nil == self.jjj) {
//      self.jjj = player;
//      return;
//    }
//    
//    if (self.jjj == player) {
//      return;
//    }
//    
//    self.jjj.pause()
//    self.jjj = player
//  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

