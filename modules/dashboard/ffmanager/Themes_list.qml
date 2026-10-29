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
    property var model: ["Gaming", "Research", "Development", "Music"] //liste des themes
    StyledRect{
        anchors.fill:parent
        radius: Tokens.rounding.large

        color:Colours.tPalette.m3surfaceContainer
        
        ColumnLayout{
            anchors.fill: parent

            FF_Shortcuts{
                
            }
            FF_Manager_Buttons{

            }
            ListView{
                Layout.fillHeight:true
                Layout.fillWidth: true
                spacing:8

                model:themes_list.model

                delegate:StyledRect{
                    width: ListView.view.width
                    height:80

                    radius: Tokens.rounding.large

                    color:Colours.tPalette.m3surfaceContainer
                    
                    StyledText{
                        anchors.centerIn: parent
                        text: modelData
                    }
                }

            }
        }
    }
}
