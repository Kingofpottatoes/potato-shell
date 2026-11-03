import "ffmanager"
import QtQuick
import QtQuick.Layouts
import qs.services





Item{
    id: root
    implicitWidth: 840
    implicitHeight: 380

    RowLayout{
        anchors.fill: parent
        spacing:12
        
        Themes_list{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 0
        }
        Loader {
            id: contentLoader

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 0

            sourceComponent: FFManager_Data.settingsOpen
                ? settingsComponent
                : currentUrlsComponent
        }
        Component{
            id:currentUrlsComponent
            Current_Theme_Urls_Shower {}
        }
        Component{
            id:settingsComponent
            Settings_Panel{}
        }
    }
}