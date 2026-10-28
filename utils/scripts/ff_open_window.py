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

def open_theme(name):
    themes_folder=Path.home()/".local"/"share"/"ff-windows"
    theme_path=themes_folder/(name+".json")
    target_ws="special:"+str(first_unoccupied(1,occupied_ws(True),99))
    with theme_path.open() as f:
        theme=json.load(f)
        theme_tabs=theme["tabs"]
        urls= [theme_tabs[i]["url"] for i in range(0,len(theme_tabs)) if theme_tabs[i]["url"].startswith(("http://", "https://"))]
        current_windows=window_addresses()
        launch_firefox(urls)
        address_firefox=get_new_window_address(current_windows,5)
        move_window(address_firefox[0],target_ws)
def list_themes(themes_folder):
    if not themes_folder.is_dir():
        return []
    themes_names=themes_folder.glob("*.json")
    themes_names=[name.stem for name in themes_names if is_valid_name(name.stem)]
    return sorted(themes_names)

def main():
    themes_path=Path.home()/".local"/"share"/"ff-windows"
    args=sys.argv[1:]
    if not args:
        print("ff_open_window --list | ff_open_window NOM_THEME",file=sys.stderr)
        return 2
    if args[0] == "--list":
        themes=list_themes(themes_path)
        for theme in themes:
            print(theme)
        return 0
    try:
        if not is_valid_name(args[0]):
            raise ValueError("invalid name")
        open_theme(args[0])
    except (FileNotFoundError, ValueError,TimeoutError,KeyError,RuntimeError) as e:
        print(e, file=sys.stderr)
        return 1
    return 0
if __name__ == "__main__":
    sys.exit(main())