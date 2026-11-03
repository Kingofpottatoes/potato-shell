import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services

Item{
    id:root
    property string workspaceMode: "auto"
    property string workspaceTarget: ""
    property string workspaceType: "special"
    ColumnLayout{
        anchors.fill: parent
        spacing: 8
        RowLayout {
            Layout.fillWidth:true
            StyledText {
                text: "Workspace selection"
            }

            Item { Layout.fillWidth: true 
                    Layout.minimumWidth: 0
            }   // pousse ce qui suit vers la droite

            StyledSwitch {
                checked: root.workspaceMode === "auto"

                onToggled: {
                    root.workspaceMode = checked ? "auto" : "manual"
                }
            }

            StyledText {
                Layout.preferredWidth: 70
                text: "Auto"
            }
        }
        RowLayout{
            StackLayout{
                currentIndex: root.workspaceMode === "auto" ? 0 : 1
                Item{
                    id:auto
                    StyledText{
                        text:"Prochain workspace disponible"
                    }
                }
                Item{
                    id:manuel
                    ColumnLayout {
                        id:workspaceInput
                        anchors.fill: parent
                        spacing: 0
                        StyledTextField{
                            Layout.fillWidth: true
                            placeholderText: "Enter Workspace desination name"
                            onTextChanged:{
                                FFManager_Data.workspace_destination = text
                            }
                        }
                    }
                }
            }
            StyledSwitch {
                checked: FFManager_Data.special===true

                onToggled: {
                    if (FFManager_Data.special){
                        FFManager_Data.special=false
                    }
                    else {
                        FFManager_Data.special=true
                    }

                }
            }

            StyledText {
                Layout.preferredWidth: 70
                text: "Special"
            }
        }
    }
}