MPFlipViewController
====================

A custom container view controller following the iOS 5 containment API that navigates between child view controllers via touch gestures and page-flip animations
  
This is the app to accompany my talk ["Implementing Custom Container View Controllers"](http://cocoaconf.com/conference/sessionDetails/82?confId=4) I presented at [CocoaConf DC 2012](http://cocoaconf.com/dc-2012/home).  
   
![iPhone screenshot](http://markpospesel.files.wordpress.com/2012/07/fliphorizontal2x.png)
  
Requirements
------------
* Xcode 4.4 or higher
* LLVM compiler
* iOS 5 or higher
* ARC

API
----------
The API is simple and modeled after UIKit's UIPageViewController.  There is a Data Source protocol (to provide previous and next controllers) and a Delegate protocol.  
  
More details can be found in this [blog post](http://markpospesel.com/2012/07/28/mpflipviewcontroller/).  See MPFlipViewController.h for full details.
  
How To Use
---------
Build and run the included demo app, and see how it works.  The controller files are in the "Controller" directory and the demo app is in the "Demo" directory.

The background images in the demo app are not freely distributable.  They're by Glyphish and you should [get your own copy](http://glyphish.com/backgrounds/).  While you're at it, they make [a great set of icons](http://glyphish.com/) too.

Licensing
---------
Read Source Code License.rtf, but the gist is:  
  
* Anyone can use it for any type of project  
* All I ask for is attribution somewhere  

Support, bugs and feature requests
----------------------------------
There is absolutely no support offered with this component. You're on your own! If you want to submit a feature request, please do so via [the issue tracker on github](https://github.com/mpospese/MPFlipViewController/issues).  
  
If you want to submit a bug report, please also do so via the issue tracker, including a diagnosis of the problem and a suggested fix (in code). If you're using MPFlipViewController, you're a developer - so I expect you to do your homework and provide a fix along with each bug report. You can also submit pull requests or patches.  
  
Please don't submit bug reports without fixes!  

(The preceding blurb provided courtesy of the legendary [Matt Gemmell](https://github.com/mattgemmell/))
  
Best,  
Mark Pospesel  
  
Website: http://markpospesel.com/  
Contact: http://markpospesel.com/about  
Twitter: http://twitter.com/mpospese  
