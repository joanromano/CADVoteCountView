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

## MIT License
Copyright (c) 2014 [Joan Romano](http://twitter.com/joanromano)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
