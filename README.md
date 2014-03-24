CADVoteCountView
================

CADVoteCountView is a circular or linear shaped view where you animate the angle changes, used at Topic app to set the vote count of a post.


<p align="center"><img src="https://raw.github.com/TopicSo/CADVoteCountView/master/Screenshots/countviewpreview.gif"/></p>

##Usage

###Install
Add the source files to your project. Don't forget to include the QuartzCore framework as well.

Finally, import the header file wherever you want to use it:

```objc
#import "CADVoteCountView.h"
```

And you are done!

### Initialization
You should always instantiate the view programmatically (loading from nib not supported yet). In order to do so, usage of voteCountViewWithType: creation method is mandatory.
