<h1>TLAlertView</h1>
A simple replacement for UIAlertView with block based completion methods and a 3D dismiss animation.<br><br>
![Two Buttons](http://ploverproductions.com/wp-content/uploads/2013/06/TLAlertView2Buttons.png?raw=true)&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![One Buttons](http://ploverproductions.com/wp-content/uploads/2013/06/TLAlertView1Button.png?raw=true)
<h2>Installation</h2>
<hr>
The preferred method is cocoapods, www.cocoapods.org, which you would then `#import <TLAlertView/TLAlertView.h>`, or you can just drop in TLAlertView.h wherever you need it and include the QuartzCore framework
<h2>Usage</h2>
<hr>
`+showInView:withTitle:message:confirmButtonTitle:cancelButtonTitle:`<br>
`-handleCancel:handleConfirm:`<br>
`-show`<br>
and thats it!<br>
You can also specify the type of animation using the `TLAnimationType` property, or just ignore it and use the default animation.<br>
All of the colors are able to be customized as well, and also respond to `UI_APPEARANCE_SELECTOR`<br>
Use as a replacement for UIAlertView wherever you need it.<br><br>




<h1>License</h1>
If you use TLAlertView and you like it, feel free to let me know, <terry@ploverproductions.com>. If you have any issue or want to make improvements, submit a pull request.<br><br>

The MIT License (MIT)
Copyright (c) 2013 Terry Lewis II

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
<br><br>
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
<br><br>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
