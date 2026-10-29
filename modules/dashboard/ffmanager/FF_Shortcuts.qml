import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services


Item{
    Layout.fillWidth:true
    Layout.preferredHeight:80
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 12
        spacing: Tokens.spacing.small

        ScrollView {
            id: scroll

            Layout.preferredWidth: 260
            Layout.fillHeight: true
            Layout.minimumWidth: 260

            contentWidth: urls_Row.implicitWidth
            contentHeight: availableHeight
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

            Row {
                id: urls_Row
                spacing: Tokens.spacing.small
                height: parent.height

                                IconButton { 
                    icon: "search"
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
                IconButton { 
                    icon: "network_intelligence" 
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
                IconButton { 
                    icon: "smart_display" 
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
                IconButton { 
                    icon: "search"
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
                IconButton { 
                    icon: "network_intelligence" 
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
                IconButton { 
                    icon: "smart_display" 
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
                                IconButton { 
                    icon: "search"
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
                IconButton { 
                    icon: "network_intelligence" 
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
                IconButton { 
                    icon: "smart_display" 
                    type: ButtonBase.Tonal
                    onClicked: {}
                }
            }

            WheelHandler {
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

                onWheel: event => {
                    scroll.contentItem.contentX -= event.angleDelta.y
                    event.accepted = true
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
        }

        IconButton {
            icon: "settings"
            type: ButtonBase.Tonal
            onClicked: {}
        }
    }
}