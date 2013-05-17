VIClipboardListener
===================
Listening clipboard ten minutes, when the application is running in the background

## HOW TO USE
* Drag the VIClipboardListener/ folder to your project (make sure you copy all files/folders)
* <code>#import "VIClipboardListener.h"</code>
* In AppDelegate, Implement <code>VIClipboardListenerDelegate</code>, and the method <code>- (void)pasteboardChanged:(UIPasteboard *)generatePasteboard</code>

## EXAMPLE 
1. Start Listener.
<pre><code>- (void)applicationDidEnterBackground:(UIApplication *)application
{
&nbsp;&nbsp;&nbsp;&nbsp;[[VIClipboardListener share] setDelegate:self];
&nbsp;&nbsp;&nbsp;&nbsp;[[VIClipboardListener share] startListener];
}
</code></pre>
3. Get pasteboard data when you copy something.
<pre><code>- (void)pasteboardChanged:(UIPasteboard *)generatePasteboard {
&nbsp;&nbsp;&nbsp;&nbsp;//Get pasteboard's String/URL/Image/Color
&nbsp;&nbsp;&nbsp;&nbsp;//And save the data or do anything else...
&nbsp;&nbsp;&nbsp;&nbsp;NSLog(@"The pasteboard string :%@",[UIPasteboard generalPasteboard].string);
&nbsp;&nbsp;&nbsp;&nbsp;NSLog(@"The pasteboard URL :%@",[UIPasteboard generalPasteboard].URL);
&nbsp;&nbsp;&nbsp;&nbsp;NSLog(@"The pasteboard image :%@",[UIPasteboard generalPasteboard].image);
&nbsp;&nbsp;&nbsp;&nbsp;NSLog(@"The pasteboard color :%@",[UIPasteboard generalPasteboard].color);
}
</code></pre>
