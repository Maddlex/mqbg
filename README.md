<h2 align="center">mqbg</h2>
<p align="center">mqbg is a custom animated wallpaper tool written with quickshell</p>
<hr>
mqbg(Moving Quickshell BackGround) uses quickshell to animate 2 PNG images(background and foreground with transparent background) and libinput to track cursor location on any DE or WM, no matter Xorg or Wayland
<hr>
<h1 align="center">Usage</h1>
mqbg command (without flags) activates the service itself(warning! using without defining wallpaper will result in white screen)
mqbg --set [path/to/background] [path/to/foreground] sets background and foreground files(does NOT activate the service itself!)
<h1 align="center">Warning!</h1>
<p align="center">Please ensure that you are cloning repository in ~, else it's not gonna work. Also DO NOT remove the ~/mqbg directory even after installation, as it's where the program files are kept</p>
