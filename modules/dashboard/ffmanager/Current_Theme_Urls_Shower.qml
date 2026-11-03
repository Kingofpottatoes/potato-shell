import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services


Item{
    Layout.fillHeight: true
    Layout.fillWidth:true
    
    StyledRect{
        anchors.fill:parent

        radius: Tokens.rounding.large
        color:Colours.tPalette.m3surfaceContainer
        
        ColumnLayout{
            anchors.fill:parent
            anchors.margins:12
            spacing:16

            FF_Workspace_Selector{
                Layout.fillWidth:true
                Layout.preferredHeight:80
            }
            Url_list{
                Layout.fillHeight:true
                Layout.fillWidth:true
            }
        }
    }
}