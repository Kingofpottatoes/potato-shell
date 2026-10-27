import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

RowLayout {
    id: root

    required property var lock

    spacing: Tokens.spacing.largeIncreased * 2

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Tokens.spacing.medium

        Quotes {
            id: quotes

            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
            Layout.minimumHeight: implicitHeight
        }
        Fetch {
            Layout.fillWidth: true
            Layout.fillHeight: true

            rootHeight: root.height
        }
        Loader {
            active: !quotes.isLongQuote
            visible: active

            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.preferredHeight: item ? item.implicitHeight : 0

            sourceComponent: Media {
                lock: root.lock
            }
        }

    }

    Center {
        lock: root.lock
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Tokens.spacing.medium

        Resources {
            Layout.fillWidth: true
        }

        Loader {
            active: quotes.isLongQuote
            visible: active

            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.preferredHeight: item ? item.implicitHeight : 0


            sourceComponent: Media {
                lock: root.lock
            }
        }
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true

            bottomRightRadius: Tokens.rounding.extraLarge
            radius: Tokens.rounding.medium
            color: Colours.tPalette.m3surfaceContainer

            NotifDock {
                lock: root.lock
            }
        }
    }
}
