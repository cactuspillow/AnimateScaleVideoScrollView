//  ViewController.swift
//
//  Created by patrick piemonte on 11/26/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-present patrick piemonte (http://patrickpiemonte.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public protocol VideoFeedsDelegate {
  func currentVideoPlaying(player: Player)
}


class VideoFeeds: UIViewController, PlayerDelegate {
  var ViewControllerVideoPath = String()
  var player: Player!
  var delegate: VideoFeedsDelegate!
  
  var playerHeight = screenWidth-30
  
  // MARK: view lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.frame = CGRect(x: 0, y: 0, width: screenWidth-30, height: (screenWidth-30)*0.75)
    self.view.backgroundColor = UIColor.blackColor()
    self.player = Player()
    self.player.delegate = self
    self.player.view.frame = CGRect(x: 0, y: 0, width: screenWidth-30, height: playerHeight)
    
    self.addChildViewController(self.player)
    self.view.addSubview(self.player.view)
    self.player.didMoveToParentViewController(self)
    
    self.player.path = ViewControllerVideoPath
    
    self.player.playbackLoops = true
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizer:")
    tapGestureRecognizer.numberOfTapsRequired = 1
    self.player.view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    self.player.pause()
  }
  
  // MARK: UIGestureRecognizer
  
  func handleTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
    switch (self.player.playbackState.rawValue) {
    case PlaybackState.Stopped.rawValue:
      self.player.playFromBeginning()
    case PlaybackState.Paused.rawValue:
      self.delegate.currentVideoPlaying(self.player)
//      NSNotificationCenter.defaultCenter().postNotificationName("avplayer", object: self.player)
      self.player.playFromCurrentTime()
    case PlaybackState.Playing.rawValue:
      self.player.pause()
    case PlaybackState.Failed.rawValue:
      self.player.pause()
    default:
      self.player.pause()
    }
  }
  
  // MARK: PlayerDelegate
  
  func playerReady(player: Player) {
  }
  
  func playerPlaybackStateDidChange(player: Player) {
  }
  
  func playerBufferingStateDidChange(player: Player) {
  }
  
  func playerPlaybackWillStartFromBeginning(player: Player) {
  }
  
  func playerPlaybackDidEnd(player: Player) {
  }
  
}

