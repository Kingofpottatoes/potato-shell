import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item{
    id:themes_list
    Layout.fillHeight:true
    Layout.maximumWidth: 350
    property var themes: FFManager_Data.themes_list //liste des themes
    Component.onCompleted: {
        FFManager_Data.get_themes_names()
    }
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
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOff
                }

                ColumnLayout {
                    width: scroll.availableWidth
                    spacing: 3
                    Repeater {
                        model: themes_list.themes
                        delegate:Selector{
                            theme_name:modelData
                        }
                    }
                }
            }
        }
    }
}
