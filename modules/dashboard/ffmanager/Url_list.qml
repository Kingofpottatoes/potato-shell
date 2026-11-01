import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item{
    id:root
    property var urls: FFManager_Data.showed_urls
    ColumnLayout{
        anchors.fill:parent
        StyledText{
            text:"Theme urls"
            font: Tokens.font.title.medium
        }
        ScrollView {
            id: scroll

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ScrollBar.vertical: ScrollBar {
               policy: ScrollBar.AlwaysOff
            }
            ColumnLayout {
                width: scroll.availableWidth
                Repeater {
                    model: root.urls
                    delegate: Url {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                    }
                }
            }
        }
    }
}
