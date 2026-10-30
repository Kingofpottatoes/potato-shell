pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Caelestia.Config
import Caelestia

Singleton{
    id:root
    property var themes_list:[]
    property var theme_url_list:[]
    property var selectedUrls: []
    property var selectedThemes:[]
    property var single_window_urls:[]
    property string workspace_destination: ""
    readonly property string script_path:
    CUtils.toLocalFile(Qt.resolvedUrl("../utils/scripts/ff_open_window.py"))

    function runPython(args, callback) {
        pythonProcess.command = [
            "python",
            root.script_path,
            ...args
        ]

        pythonProcess.onResult = callback
        pythonProcess.running = true
    }

    function get_themes_names(){
        runPython(["--list"],function(result){
            root.themes_list=[...result]
        })
    }

    function addUrl(url){
    }
    function get_theme_urls(theme_name) {
        runPython(["--list-theme-urls",theme_name],function(result){
            root.theme_url_list=[...result]
        })
    }
    function theme_clicked(theme_name){
        if (!root.selectedThemes.includes(theme_name)){
            root.selectedThemes=[...root.selectedThemes,theme_name]
        }
        else {
            root.selectedThemes = root.selectedThemes.filter(theme => theme !== theme_name)
        }
    }
    Process {
        id: pythonProcess
        property var onResult: null
        command: []

        stdout: StdioCollector {
            onStreamFinished: {
                const result = JSON.parse(text)

                if (pythonProcess.onResult) {
                    pythonProcess.onResult(result)
                    pythonProcess.onResult = null
                }
            }
        }
    }
}