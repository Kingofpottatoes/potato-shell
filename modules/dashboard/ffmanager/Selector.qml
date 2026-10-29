import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services



StyledRect{
    Layout.fillWidth:true
    height:50

    border.width:hover.hovered? 2 : 0
    border.color:Colours.tPalette.m3primary
    radius: Tokens.rounding.large

    color:Colours.tPalette.m3surfaceContainerHighest
    HoverHandler {
        id: hover
    }
    StyledText{
        text:modelData
        anchors.centerIn: parent
    }
}