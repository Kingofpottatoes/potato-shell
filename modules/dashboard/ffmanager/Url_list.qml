import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components

Item{
    id:root
    property var urls: [
    "https://www.youtube.com",
    "https://fr.wikipedia.org",
    "https://chatgpt.com",
    "https://www.youtube.com",
    "https://fr.wikipedia.org",
    "https://chatgpt.com",
    "https://www.youtube.com",
    "https://fr.wikipedia.org",
    "https://chatgpt.com"
]
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
                anchors.fill:parent
                height: scroll.availableHeight
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
