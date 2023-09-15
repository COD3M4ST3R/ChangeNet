# ChangeNet
Changes the network over command prompt between known wifi and wlan.

## How to Install
This bash script's path has to be defined in the ~/.bashrc. To do this:
- extract the 'change_net.sh' at wherever you want to and copy the full path of it.
- open command prompt and command:
``` echo "[[ -s '/${HOME}/${USER}/<relative path of change_net.sh>' ]] && source '/${HOME}/${USER}/<relative path of change_net.sh>'" >> ~/.bashrc ```

## Example
To make things easier, you can get full path of file.
- extract file as PROJECTS/BashScripts/change_net.sh
- open command prompt and enter command:
```pwd```
- copy the full path:
```/home/COD3M4ST3R/PROJECTS/BashScripts/change_net.sh```
- open command prompt and enter command:
```echo "[[ -s '/<full path of change_net.sh>' ]] && source '/<full path of change_net.sh>'" >> ~/.bashrc```

## Usage
```s```: changes the networks in between

```s w||wifi```: changes to wifi network

```s e||ethernet```: changes to ethernet network
