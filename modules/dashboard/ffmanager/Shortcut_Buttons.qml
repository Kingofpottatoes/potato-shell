import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services
import qs.components.controls


ButtonBase {
    id:root
    property string title:""
    property string icon:""
    property string url:""
    property int type: ButtonBase.Filled

    implicitWidth: 48
    implicitHeight: 48
    padding: Tokens.padding.small

    
    activeColour: type === IconButton.Filled ? Colours.palette.m3primary : Colours.palette.m3secondary
    inactiveColour: {
        if (!isToggle && type === IconButton.Filled)
            return Colours.palette.m3primary;
        return type === IconButton.Filled ? Colours.tPalette.m3surfaceContainer : Colours.palette.m3secondaryContainer;
    }
    activeOnColour: type === IconButton.Filled ? Colours.palette.m3onPrimary : type === IconButton.Tonal ? Colours.palette.m3onSecondary : Colours.palette.m3primary
    inactiveOnColour: {
        if (!isToggle && type === IconButton.Filled)
            return Colours.palette.m3onPrimary;
        return type === IconButton.Tonal ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurfaceVariant;
    }
    Image {
        anchors.centerIn: parent
        visible: root.icon === ""
        source: "https://www.google.com/s2/favicons?sz=128&domain=" + root.url
        width:24
        height:24
        fillMode: Image.PreserveAspectFit
        asynchronous: true

    }

    MaterialIcon {
        anchors.centerIn: parent
        visible: root.icon !== ""
        text: root.icon
        fontStyle:Tokens.font.icon.medium
        color: root.onColour
    }
}