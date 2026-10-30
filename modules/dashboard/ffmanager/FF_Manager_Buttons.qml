import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services


Item{
    id:root

    property int n_selected:0
    Layout.fillWidth: true
    Layout.minimumHeight:80

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: Tokens.spacing.small

        StyledText {
            text: "Firefox"
            font: Tokens.font.title.medium
            color: Colours.palette.m3onSurface
        }
        StyledRect {
            radius: Tokens.rounding.full
            color: Colours.palette.m3surfaceContainerHigh
            implicitHeight: 20
            implicitWidth: selectedText.implicitWidth + 12

            StyledText {
                id: selectedText
                anchors.centerIn: parent
                text: root.n_selected +" selected"
                font: Tokens.font.title
                color: Colours.palette.m3onSurface
                elide: Text.ElideRight
            }
        }
        Item { Layout.fillWidth: true 
                Layout.minimumWidth: 0
        }   // pousse ce qui suit vers la droite

        IconButton { 
            icon: "refresh"
            type: ButtonBase.Tonal  
            onClicked: {}
        }
        IconButton { 
            icon: "place_item" 
            type: ButtonBase.Filled
            onClicked: {}
        }
        IconButton { 
            icon: "play_arrow" 
            type: ButtonBase.Filled 
            onClicked: {}
        }
    }
}