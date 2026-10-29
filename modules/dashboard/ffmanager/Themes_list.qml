import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services

Item{
    id:themes_list
    Layout.fillHeight:true
    Layout.maximumWidth: 350
    property var themes: ["Gaming", "Research", "Development", "Music"] //liste des themes
    StyledRect{
        anchors.fill:parent
        radius: Tokens.rounding.large

        color:Colours.tPalette.m3surfaceContainer
        
        ColumnLayout{
            anchors.fill: parent

            FF_Shortcuts{
                
            }
            FF_Manager_Buttons{
                Layout.fillWidth: true
                Layout.maximumWidth: themes_list.width
            }
            ScrollView {
                id: scroll
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: scroll.availableWidth
                    Repeater {
                        model: themes_list.themes
                        delegate:Selector{
                        }
                    }
                }
            }
        }
    }
}
