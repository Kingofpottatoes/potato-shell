import "ffmanager"
import QtQuick
import QtQuick.Layouts






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
        }
        Current_Theme_Urls_Shower{
            
        }
    }
}