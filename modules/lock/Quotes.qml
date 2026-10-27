import QtQuick
import Caelestia
import Caelestia.Config
import qs.components
import qs.services
StyledRect {
    id: root

    property string quoteText: "TAS"
    property string quoteAuthor: "hackingnoises"

    implicitHeight: Math.min(quote.implicitHeight, 250)
    + author.implicitHeight + 60
    radius: Tokens.rounding.medium
    color: Colours.tPalette.m3surfaceContainer
    property bool isLongQuote : height>=180

    function loadQuote() {
        const xhr = new XMLHttpRequest()
        xhr.open("GET", "file:///usr/share/sddm/themes/caelestia/config/quotes.json")

        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return

                if (xhr.status === 0 || xhr.status === 200) {
                    try {
                        const quotes = JSON.parse(xhr.responseText)

                        if (!Array.isArray(quotes) || quotes.length === 0) {
                            console.error("Le fichier quotes.json est vide ou invalide")
                            return
                        }

                        const quote = quotes[Math.floor(Math.random() * quotes.length)]
                        root.quoteText = quote.text
                        root.quoteAuthor = "~"+quote.author
                    } catch (error) {
                        console.error("Impossible de lire quotes.json :", error)
                    }
                } else {
                    console.error("Erreur de lecture de quotes.json :", xhr.status)
                }
        }

        xhr.send()
    }

    Component.onCompleted: loadQuote()

    Column {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.8
        spacing: 15

        Text {
            id: quote

            width: parent.width
            height: parent.height - author.height - 15

            text: root.quoteText
            color: "white"

            font.family: "Rubik"
            font.italic: true
            font.pointSize: 16

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            fontSizeMode: Text.Fit
            minimumPointSize: 4
        }

        Text {
            id: author

            width: parent.width

            text: root.quoteAuthor
            color: Colours.tPalette.m3secondary

            font.pointSize: 12
            font.family: "CaskaydiaCove NF"
            font.bold: true

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
