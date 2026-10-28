from pathlib import Path
import subprocess
import json
import time

def first_unoccupied(start,occupied,limit):
    for i in range(start,limit+1):
        if i not in occupied:
            return i
    return start


def read_hypr(*args):
    result = subprocess.run(["hyprctl","clients", "-j",], capture_output=True, text=True)

    all_ws=json.loads(result.stdout)
    return all_ws
def occupied_ws(special):

    result = subprocess.run(["hyprctl","workspaces", "-j",], capture_output=True, text=True)

    all_ws=json.loads(result.stdout)
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
    result = subprocess.run(["hyprctl","clients", "-j",], capture_output=True, text=True)
    all_windows=json.loads(result.stdout)
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
        windows=read_hypr()
        new_window_address=[w["address"] for w in windows if w["address"] not in addresses and w["class"]=="firefox"]
        if len(new_window_address)>0:
            return new_window_address
        time.sleep(0.1)
    raise TimeoutError("new firefox window took more than 5s to open")
def move_window(address,workspace):
    lua_cmd=lua = f'hl.dsp.window.move({{ workspace = "{workspace}", window = "address:{address}" }})'
    r = subprocess.run(["hyprctl","dispatch",lua_cmd], capture_output=True, text=True)
    print(r.returncode, repr(r.stdout), repr(r.stderr))

if __name__ == "__main__":
    theme_file="ytb.json"
    themes_folder=Path.home()/".local"/"share"/"ff-windows"
    theme_path=themes_folder/theme_file
    target_ws="special:"+str(first_unoccupied(1,occupied_ws(True),99))
    with theme_path.open() as f:
        theme=json.load(f)
        theme_tabs=theme["tabs"]
        urls= [theme_tabs[i]["url"] for i in range(0,len(theme_tabs))]
        current_windows=window_addresses()
        launch_firefox(urls)
        address_firefox=get_new_window_address(current_windows,5)
        print(address_firefox)
        move_window(address_firefox[0],target_ws)
