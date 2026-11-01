import sys
from pathlib import Path
import subprocess
import json
import time
import re

def first_unoccupied(start,occupied,limit):
    for i in range(start,limit+1):
        if i not in occupied:
            return i
    return start

def is_valid_name(name):
    return re.fullmatch(r"[\w-]+", name)

def read_hypr(*args):
    result = subprocess.run(["hyprctl",*args, "-j",], capture_output=True, text=True)

    if result.returncode!=0:
        raise ValueError(f"hyprctl error: {result.stderr}")
    
    all_ws=json.loads(result.stdout)
    return all_ws


def occupied_ws(special):

    all_ws = read_hypr("workspaces")

    occupied=set()
    for workspace in all_ws:
        if not special:
            if workspace["windows"]>0 and workspace["id"]>0:
                occupied.add(workspace["id"])
        else:
            if workspace["windows"]>0 and workspace["name"].startswith("special:") and workspace["name"][8:len(workspace["name"])].isdigit() :#max : special:99
                occupied.add(int(workspace["name"][8:len(workspace["name"])])) #on recupere le nombre depuis le nom "ON ASSUME QUE LES NOMS SONT TOUS SOUT FORMAT : special:i"
    return occupied

def window_addresses():
    all_windows = read_hypr("clients")
    adresses=set()
    for window in all_windows:
       adresses.add(window["address"])
    return adresses

def launch_firefox(urls):
    if len(urls)<1:
        raise ValueError("pas d'url")
    elif len(urls)==1:
        subprocess.Popen(["firefox","--new-window"]+urls,start_new_session=True)
    else:
        subprocess.Popen(["firefox"]+urls,start_new_session=True)

def get_new_window_address(addresses,timeout):
    start=time.monotonic()
    while time.monotonic()-start<timeout:
        windows=read_hypr("clients")
        new_window_address=[w["address"] for w in windows if w["address"] not in addresses and w["class"]=="firefox"]
        if len(new_window_address)>0:
            return new_window_address
        time.sleep(0.1)
    raise TimeoutError(f"new firefox window took more than {timeout}s to open")

def move_window(address,workspace):
    lua_cmd = f'hl.dsp.window.move({{ workspace = "{workspace}", window = "address:{address}" }})'
    r = subprocess.run(["hyprctl","dispatch",lua_cmd], capture_output=True, text=True)
    if not r.returncode==0:
        raise ValueError("hyprctl error")
    check=read_hypr("clients")
    for client in check:
        if client["address"]==address:
            if client["workspace"]["name"]==workspace:
                return 0
            else:
                raise RuntimeError("window didnt move")
    raise RuntimeError("window disapeared")
def get_url_from_theme(name):
    themes_folder=Path.home()/".local"/"share"/"ff-windows"
    theme_path=themes_folder/(name+".json")

    with theme_path.open() as f:
        theme=json.load(f)
        theme_tabs=theme["tabs"]
        urls= [theme_tabs[i]["url"] for i in range(0,len(theme_tabs)) if theme_tabs[i]["url"].startswith(("http://", "https://"))]
    return urls

def open(name="",supplementary_urls=None,workspace_destination=None):
    if supplementary_urls==None:
        supplementary_urls=[]
    if workspace_destination==None:
        target_ws="special:"+str(first_unoccupied(1,occupied_ws(True),99))
    else :
        target_ws=workspace_destination
    currents_windows=window_addresses()
    if name!="":
        urls=get_url_from_theme(name)+supplementary_urls
    else:
        urls=supplementary_urls
    launch_firefox(urls)
    address_firefox=get_new_window_address(currents_windows,5)
    move_window(address_firefox[0],target_ws)

def list_themes(themes_folder):
    if not themes_folder.is_dir():
        return []
    themes_names=themes_folder.glob("*.json")
    themes_names=[name.stem for name in themes_names if is_valid_name(name.stem)]
    return sorted(themes_names)
def help():
    return "utulisations:\n python ff_window.py --theme-name NOM_THEME --urls URL1 URL2 URL3... --wokspace WORKSPACE_DESTINATION \n python ff_window.py --list \n python ff_window.py --list-theme-urls THEME_NAME"
def main():
    themes_path=Path.home()/".local"/"share"/"ff-windows"
    args=sys.argv[1:]
    current_option=None
    theme_name=""
    suppelementary_urls=[]
    workspace_destination=None
    if args and args[0]=="--list":
        if len(args) != 1:
            print(help(), file=sys.stderr)
            return 2

        print(json.dumps(list_themes(themes_path)))
        return 0
    if args and args[0] == "--list-theme-urls":
        if len(args) != 2:
            print(help(), file=sys.stderr)
            return 2

        print(json.dumps(get_url_from_theme(args[1])))
        return 0
    for arg in args:
        if arg.startswith("--"):
            if arg not in ("--theme-name", "--urls", "--workspace"):
                print(help(), file=sys.stderr)
                return 2
            current_option = arg
            continue
        if current_option=="--theme-name":
            theme_name=arg #supress the other theme name to keep only the last one
        elif current_option=="--urls":
            suppelementary_urls.append(arg)
        elif current_option=="--workspace":
            workspace_destination=arg#also suppress the other workspace_destination to keep only the last one
        else:
            print(help(), file=sys.stderr)
            return 2
    open(name=theme_name,supplementary_urls=suppelementary_urls,workspace_destination=workspace_destination)
    return 0
if __name__ == "__main__":
    sys.exit(main())