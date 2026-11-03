import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services
import qs.components.controls

Item{
    Layout.fillHeight: true
    Layout.fillWidth:true
    
    StyledRect{
        anchors.fill:parent

        radius: Tokens.rounding.large
        color:Colours.tPalette.m3surfaceContainer
        ScrollView {
                id: scroll
                anchors.fill:parent
                anchors.margins: Tokens.padding.large
                clip: true
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOff
                }
                contentWidth: availableWidth
            ColumnLayout{
                width: scroll.availableWidth
                spacing: Tokens.padding.medium
                StyledText{
                    text:"Settings"
                    font:Tokens.font.headline.medium
                }
                RowLayout{
                    StyledText{
                        text:"Add Shortcut"
                        font:Tokens.font.title.medium
                    }
                    Item{Layout.fillWidth:true}//moove all following item to the right
                    IconButton{
                        icon:"add"
                        type: ButtonBase.Filled
                        onClicked: {FFManager_Data.addShortcut(shortcutName.text,shortcutUrl.text,shortcutIcon.text)
                            shortcutName.text = ""
                            shortcutUrl.text = ""
                            shortcutIcon.text = ""
                        }
                    }
                }
                StyledTextField {
                    id: shortcutName
                    Layout.fillWidth:true
                    placeholderText: "Shortcut name"
                }

                StyledTextField {
                    id: shortcutUrl
                    Layout.fillWidth:true
                    placeholderText: "URL"
                }

                StyledTextField {
                    id: shortcutIcon
                    Layout.fillWidth:true
                    placeholderText: "Icon (optional)"
                }
                StyledText{
                    text:"Add Theme"
                    font:Tokens.font.title.medium
                }
            }
        }
    }
}
