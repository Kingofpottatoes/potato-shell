import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
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
            Layout.preferredHeight: 48
            Layout.minimumWidth: 260
            Layout.alignment: Qt.AlignVCenter

            contentWidth: urls_Row.implicitWidth
            contentHeight: availableHeight
            clip: true

            ScrollBar.horizontal: null
                            NumberAnimation {
                    id: scrollAnimation
                    target: scroll.contentItem
                    property: "contentX"
                    duration: 200
                    easing.type: Easing.OutCubic
                }
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
                    onClicked: {FFManager_Data.addUrl("https://chatgpt.com/")}
                }
                IconButton { 
                    icon: "smart_display" 
                    type: ButtonBase.Tonal
                    onClicked: {FFManager_Data.addUrl("https://www.youtube.com/")}
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
                    const flickable = scroll.contentItem
                    const max = Math.max(0, scroll.contentWidth - scroll.availableWidth)

                    // On repart de la destination précédente si l'animation tourne déjà
                    const current = scrollAnimation.running
                        ? scrollAnimation.to
                        : flickable.contentX

                    const target = Math.max(
                        0,
                        Math.min(max, current - event.angleDelta.y * scrollSensitivity)
                    )

                    scrollAnimation.stop()
                    scrollAnimation.to = target
                    scrollAnimation.start()

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