import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item{
    StyledRect{
        anchors.fill:parent
        border.width:0
        border.color:Colours.tPalette.m3primary
        radius: Tokens.rounding.large
                        
        color:Colours.tPalette.m3surfaceContainerHighest
        RowLayout{
            anchors.fill:parent
            anchors.margins:12
            spacing: 10
            Image {
                source: "https://www.google.com/s2/favicons?domain=" + modelData + "&sz=64"
                sourceSize: Qt.size(32, 32)
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                fillMode: Image.PreserveAspectFit
            }
            StyledText{
                Layout.fillWidth:true
                Layout.fillHeight:true
                text:modelData
            }
        }
    }
}