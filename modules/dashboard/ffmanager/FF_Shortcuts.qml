import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components.controls


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
            Layout.preferredHeight: 48
            Layout.minimumWidth: 260
            Layout.alignment: Qt.AlignVCenter

            contentWidth: urls_Row.implicitWidth
            contentHeight: availableHeight
            clip: true

            ScrollBar.horizontal: null

            Row {
                id: urls_Row
                spacing: Tokens.spacing.small
                height: scroll.height

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
                property real scrollSensitivity: 0.3
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

                onWheel: event => {
                    const max = Math.max(
                        0,
                        scroll.contentWidth - scroll.availableWidth
                    )

                    const flickable = scroll.contentItem

                    flickable.contentX = Math.max(
                        0,
                        Math.min(max, flickable.contentX - event.angleDelta.y*scrollSensitivity)
                    )

                    event.accepted = true
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
        }

        IconButton {
            Layout.alignment: Qt.AlignVCenter
            icon: "settings"
            type: ButtonBase.Filled
            onClicked: {}
        }
    }
}