pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Caelestia

Singleton{
    id:root
    //selection property
    property var themes_list:[]//theme list showed
    property var theme_url_list:[] //url of the theme selected if only one, else [] 
    property var selectedUrls: [] //url added by the sortcuts
    property var selectedThemes:[] //list of selected themes
    property var showed_urls:[] //url showed
    property string workspace_destination: "" //workspace selection
    property bool special:true //do we send the window in a special workspace ?
    //process property
    property var processQueue: [] //list of python request
    property bool processBusy: false //is the Process busy
    property int hoverRequestId:0 //to avoid getting outdated response
    //settings
    property bool settingsOpen:false //is settings window open ?
    property var settings: ({ //default settings, you have the syntax now :)
            "shortcuts": [{
                "title": "GitHub",
                "url": "https://github.com",
                "icon": "code"
            }],
            "defaults": {
                "auto": true,
                "special": true
            }
        })
    //theme creator property
    property string theme_creator_name:""
    property string theme_creator_current_url:""
    property var theme_creator_urls : []
    //shortcut creator property
    property string shortcut_name:""
    property string shortcut_icon:""
    property string shortcut_url:""
    //script path
    readonly property string script_path:CUtils.toLocalFile(Qt.resolvedUrl("../utils/scripts/ff_open_window.py"))
    
    function saveSettings(){
        settingsFile.setText(JSON.stringify(root.settings,null,4))
    }
    function runPython(args, callback) {
        root.processQueue=[...root.processQueue,{args:[...args],callback}]
        root.processNext()
    }
    function processNext(){
        if (root.processBusy || root.processQueue.length === 0){
            return
        }
        const task=root.processQueue[0]
        
        root.processQueue = root.processQueue.slice(1)
        root.processBusy = true

        pythonProcess.currentCallback = task.callback

         pythonProcess.command = [
            "python",
            root.script_path,
            ...task.args
        ]

        pythonProcess.running = true

    }
    function get_themes_names(){
        runPython(["--list"],function(result){
            root.themes_list=[...result]
        })
    }

    function addUrl(url){
        root.selectedUrls=[...selectedUrls,url]
        root.showed_urls=[...showed_urls,url]
    }
    function get_theme_urls(theme_name) {
        const requestId = ++root.hoverRequestId
        runPython(["--list-theme-urls",theme_name],function(result){
            if (requestId !== root.hoverRequestId)
                return
            root.theme_url_list = [...result]
            if ((selectedThemes.length==1 && selectedThemes.includes(theme_name)||(selectedThemes.length==0))){
                root.showed_urls=[...result,...selectedUrls]
            }
            else{
            root.showed_urls = [...result]
            }
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
    function clear_selected_theme_and_urls(){
        ++root.hoverRequestId
        root.selectedThemes = []
        root.selectedUrls = []
        root.theme_url_list = []
        root.showed_urls = []
    }
    function clear_urls() {
        ++root.hoverRequestId
        if (root.selectedThemes.length === 1) {
            get_theme_urls(root.selectedThemes[0])
        } else {
            root.theme_url_list = []
            root.showed_urls = [...root.selectedUrls]
        }
    }
    function delete_selected_themes(){
        for (const theme_name of selectedThemes){
        runPython(["--theme-name",theme_name,"--delete"])
        }    
        clear_selected_theme_and_urls()
        get_themes_names()
    }
    function open_windows(selectedThemes,workspace_destination,selectedUrls){
        const workspace_args= workspace_destination!=="" ? ["--workspace",workspace_destination,...(special ? ["--special"]:[])]:[]
        if (selectedThemes.length > 1){
            //one window for each theme
            for (const theme_name of selectedThemes){
                runPython(["--theme-name",theme_name,...workspace_args],function(result){})
            }
            //supplementary window for selected urls
            if (selectedUrls.length>0){
                runPython(["--urls",...selectedUrls,...workspace_args],function(result){})
            }
        }
        else if (selectedThemes.length==1){
            //one theme + suppelementary urls
            runPython(["--theme-name",selectedThemes[0],"--urls",...selectedUrls,...workspace_args],function(result){})
        }
        else if (selectedThemes.length==0){
            //one window with suppelementary urls
            runPython(["--urls",...selectedUrls,...workspace_args],function(result){})
        }
        clear_selected_theme_and_urls()
    }
    function addShortcut(name,url,icon){
        if (name ==="" || url ===""){
            return
        }
        const newShortcut = {
            name:name,
            url:url,
            icon:icon
        }
        settings.shortcuts=[...settings.shortcuts,newShortcut]
        saveSettings()
    }
    function addTheme(name,urls){
        if (name ==="" || urls.length === 0){
            return
        }
        runPython(["--theme-name",name,"--urls",...urls,"--create-theme"],
            function(result) {
                FFManager_Data.get_themes_names()
            })
        saveSettings()
    }
    Process {
        id: pythonProcess
        property var currentCallback: null
        command: []

        stdout: StdioCollector {
            id:output
        }
        stderr: StdioCollector {
            id: errorOutput
        }
        onExited:(exitCode,exitStatus)=>{
            const outputText=output.text.trim()
            if (exitCode==0 && outputText !== ""){
                try {
                    const result = JSON.parse(outputText)
                    if (pythonProcess.currentCallback)
                        pythonProcess.currentCallback(result)
                } catch(error) {
                    console.error("Erreur JSON Python :", error)
                    console.error("Sortie reçue :", outputText)
                    console.error(errorOutput)
                }
            } 
            else if (exitCode !== 0) {
                console.error("Python a terminé avec le code :", exitCode)
                console.error("Sortie :", outputText)
            }
            pythonProcess.currentCallback = null
            root.processBusy = false

            root.processNext()
        }
    }
    FileView {
        id: settingsFile

        path: Quickshell.env("HOME") + "/.config/ffmanager/ffmanager.json"

        watchChanges: true

        onLoaded: {
            root.settings=JSON.parse(text())
        }
        onLoadFailed: error =>{
            console.log("Failed to load FFmanager settings:", error)
        }
        onSaveFailed: error => {
            console.error("Failed to save FFmanager settings:", error)
        }
    }
    Component.onCompleted:{
        //for tests
    }
}