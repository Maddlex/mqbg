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
  property int bgh: 90
  property int bgv: 90
  property int fgh: 90
  property int fgv: 90
  Image {
    anchors.centerIn: parent
    anchors.horizontalCenterOffset: -varX / bgh + 12
    anchors.verticalCenterOffset: -varY / bgv + 6
    source: "./BGForSprite.png"
    sourceSize.width: 2016
    sourceSize.height: 1134
    fillMode: Image.PreserveAspectFit
  }
  Image {
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.horizontalCenterOffset: varX / fgh + 22
    anchors.verticalCenterOffset: varY / fgv
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
  Process {
    id: offsets
    command: ["sh", "-c", "cat ~/mqbg/config.txt"]
    running: true
    stdout: SplitParser {
      onRead: data => {
        let matches = data.match(/\d+/g);
        if (matches) {
          bgh = parseInt(matches[0], 10);
          bgv = parseInt(matches[1], 10);
          fgh = parseInt(matches[2], 10);
          fgv = parseInt(matches[3], 10);
        }
      }
    }
  }
}
