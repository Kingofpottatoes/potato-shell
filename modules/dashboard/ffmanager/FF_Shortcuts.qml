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

    StyledRect{
        anchors.fill:parent
        height:80

        radius: Tokens.rounding.large

        color:Colours.tPalette.m3surfaceContainer
    }
}