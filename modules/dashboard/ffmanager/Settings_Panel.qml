import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services
import qs.components.controls

Item{
    id:settings_panel
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
                        text:"Default Value :"
                        font:Tokens.font.title.medium
                    }
                    Item{Layout.fillWidth:true}
                    ColumnLayout{
                        RowLayout{
                            StyledSwitch {
                                checked: FFManager_Data.settings.defaults.auto

                                onToggled: {
                                    FFManager_Data.settings.defaults.auto = checked
                                    FFManager_Data.auto=checked
                                    FFManager_Data.saveSettings()
                                }
                            }

                            StyledText {
                                Layout.preferredWidth: 70
                                text: "Auto"
                            }
                        }
                        RowLayout{
                            StyledSwitch {
                                checked: FFManager_Data.settings.defaults.special === true

                                onToggled: {
                                    FFManager_Data.settings.defaults.special = checked
                                    FFManager_Data.special=checked
                                    FFManager_Data.saveSettings()
                                }
                            }

                            StyledText {
                                text: "Special"
                            }
                        }
                    }
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
                            FFManager_Data.shortcut_name=""
                            FFManager_Data.shortcut_url=""
                            FFManager_Data.shortcut_icon=""
                        }
                    }
                }
                StyledTextField {
                    id: shortcutName
                    Layout.fillWidth:true
                    placeholderText: "Shortcut name"
                    text:FFManager_Data.shortcut_name
                    onTextChanged:{
                        FFManager_Data.shortcut_name=text
                    }
                }

                StyledTextField {
                    id: shortcutUrl
                    Layout.fillWidth:true
                    placeholderText: "URL"
                    text:FFManager_Data.shortcut_url
                    onTextChanged:{
                        FFManager_Data.shortcut_url=text
                    }
                }

                StyledTextField {
                    id: shortcutIcon
                    Layout.fillWidth:true
                    placeholderText: "Icon (optional)"
                    text:FFManager_Data.shortcut_icon
                    onTextChanged:{
                        FFManager_Data.shortcut_icon=text
                    }
                    

                }
                RowLayout{
                    StyledText{
                        text:"Add Theme"
                        font:Tokens.font.title.medium
                    }
                    Item{Layout.fillWidth:true}//move all following item to the right
                    IconButton{
                        icon:"add"
                        type: ButtonBase.Filled
                        onClicked: {FFManager_Data.addTheme(FFManager_Data.theme_creator_name,FFManager_Data.theme_creator_urls)
                            themeName.text = ""
                            url_adder.text=""
                            FFManager_Data.theme_creator_urls = []
                        }
                    }
                }
                StyledTextField {
                    id: themeName
                    Layout.fillWidth:true
                    placeholderText: "Theme name"
                    text: FFManager_Data.theme_creator_name
                    onTextChanged:{
                        FFManager_Data.theme_creator_name=text
                    }
                }
                RowLayout{
                    StyledTextField {
                        id: url_adder
                        Layout.fillWidth:true
                        placeholderText: "Add url"
                        text:FFManager_Data.theme_creator_current_url
                        onTextChanged:{
                            FFManager_Data.theme_creator_current_url=text
                        }
                    }
                    IconButton{
                        icon:"add"
                        type: ButtonBase.Filled
                        onClicked: {
                            FFManager_Data.theme_creator_urls = [
                                ...FFManager_Data.theme_creator_urls,
                                url_adder.text
                            ]
                            FFManager_Data.theme_creator_current_url = ""
                        }
                    }
                }
                Repeater{

                    model:FFManager_Data.theme_creator_urls

                    delegate:RowLayout{
                        StyledRect{
                            Layout.fillWidth:true
                            StyledText{
                                text:modelData
                                anchors.fill:parent
                            }
                        }
                        IconButton{
                            icon:"delete"
                            type:ButtonBase.Tonal
                            onClicked: {
                                let updated = [...FFManager_Data.theme_creator_urls]
                                FFManager_Data.theme_creator_urls.splice(index, 1)
                                FFManager_Data.theme_creator_urls = updated
                            }
                        }
                    }
                }
            }
        }
    }
}
