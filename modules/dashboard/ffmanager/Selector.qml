import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services



StyledRect{
    property string theme_name
    property bool selected: FFManager_Data.selectedThemes.includes(theme_name)
    Layout.fillWidth:true
    height:50

    border.width: (hover.hovered || selected) ? 2 : 0
    border.color:Colours.tPalette.m3primary
    radius: Tokens.rounding.large

    color:selected? Colours.tPalette.m3surfaceContainerLowest:Colours.tPalette.m3surfaceContainerHighest
    HoverHandler {
        id: hover
        onHoveredChanged: {
        if (hover.hovered) {
            FFManager_Data.get_theme_urls(theme_name)
            }
        else {
            FFManager_Data.clear_urls()
        }   
        }
    }
    TapHandler{
        onTapped:{
            FFManager_Data.theme_clicked(theme_name)
        }
    }
    StyledText{
        text:theme_name
        anchors.centerIn: parent
    }
}