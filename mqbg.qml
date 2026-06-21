import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  exclusiveZone: -1
  WlrLayershell.layer: WlrLayer.Background
  anchors: {
    top: true
    right: true
  }
  width: 1920
  height: 1080
  property int varX: 960
  property int varY: 540
  Image {
    anchors.centerIn: parent
    anchors.horizontalCenterOffset: -varX / 90
    anchors.verticalCenterOffset: -varY / 90
    source: "./BGForSprite.png"
    sourceSize.width: 2016
    sourceSize.height: 1134
    fillMode: Image.PreserveAspectFit
  }
  Image {
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.horizontalCenterOffset: varX / 90 //90 stands for how fast is it moving - the lower the value the faster FG is moving
    anchors.verticalCenterOffset: varY / 90
    source: "./Sprite.png"
    sourceSize.width: 1920
    sourceSize.height: 1080
    fillMode: Image.PreserveAspectFit
  }
  Process {
    id: mouseLocation
    command: ["sh", "-c", "~/mqbg/getMouseLocation.sh"]
    running: true
    stdout: SplitParser {
      onRead: data => {
        let regex = /X=\s*(\d+).*Y=\s*(\d+)/;
        let match = data.match(regex);
        if (match) {
          varX = parseInt(match[1], 10);
          varY = parseInt(match[2], 10);
        }
      }
    }
  }
}
