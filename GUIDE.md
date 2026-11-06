# RFD offline setup guide

For friends running their own Windows (or Wine) host.

---

## 1. Install

1. Grab latest `RFD-windows` from  
   https://github.com/Windows81/Roblox-Freedom-Distribution/releases
2. Make a folder, e.g. `C:\rfd`, drop `RFD.exe` in it
3. Copy `GameConfig.example.toml` from this kit → rename to `GameConfig.toml`
4. You need a place file: `MyPlace.rbxl` (or whatever name you put in the config)

For mesh conversion later, also clone the source:

```powershell
git clone --depth 1 https://github.com/Windows81/Roblox-Freedom-Distribution rfd-source
cd rfd-source\Source
pip install -r requirements.txt
pip install DracoPy numpy
```

Python 3.12+ recommended.

---

## 2. Start the server

Pick **any free ports**. Example uses 2005 for both web (TCP) and RCC (UDP).

```powershell
cd C:\rfd
$env:ROBLOSECURITY = "paste_cookie_only_if_you_need_private_assets"
.\RFD.exe server --config_path GameConfig.toml --web_port 2005 --rcc_port 2005
```

Cookie is optional. Only needed if the server has to download assets your account owns from Roblox.com.

Firewall: open **TCP + UDP** on the ports you chose if other people join from outside.

---

## 3. Join (player)

Same PC:

```powershell
.\RFD.exe player -h 127.0.0.1 -p 2005 -rp 2005 -u Guest123
```

Other machine:

```powershell
.\RFD.exe player -h HOST_IP -p WEB_PORT -rp RCC_PORT -u TheirName
```

`-p` = web port, `-rp` = RCC port. They can be different numbers if you set them that way on the server.

Linux: same commands with `wine RFD.exe ...`

---

## 4. Studio

```powershell
.\RFD.exe studio --place_path MyPlace.rbxl --web_port 2005
```

First launch downloads the 2021 Studio build.  
If `enable_saveplace = true` in the config, saving in Studio updates the rbxl on disk.

---

## 5. Convert a modern place

Got a newer `.rbxl` / `.rbxlx`? Serialise it for 2021:

```powershell
# source
cd path\to\rfd-source\Source
python _main.py serialise --load "C:\path\Place.rbxlx" --save "C:\rfd\MyPlace.rbxl" --method rbxlx

# or exe
.\RFD.exe serialise --load "C:\path\Place.rbxlx" --save "C:\rfd\MyPlace.rbxl" --method rbxlx
```

Use `--method rbxl` for binary places.

---

## 6. Download assets you own

### Step A — signed URLs

Edit `AssetsDownload.py`, put your asset ids in the list, run:

```powershell
python AssetsDownload.py
```

It asks for an Open Cloud API key (create one on the Creator Dashboard with asset read permission).  
Writes small JSON files into `temp_assets\`.

### Step B — real files (do this right away, links expire)

```powershell
.\pull_real_assets.ps1
```

Saves binaries into `AssetCache\`. Sizes should be way bigger than ~300 bytes.

---

## 7. Convert meshes for 2021

```powershell
.\serialise_meshes.ps1
```

Or manually:

```powershell
cd path\to\rfd-source\Source
python _main.py serialise --load C:\rfd\AssetCache\123456 --save C:\rfd\AssetCache\123456 --method mesh
```

Other methods: `rbxl`, `rbxlx`, `csg`, `video`.  
**Dont** run mesh serialise on textures/images — leave those raw in AssetCache.

---

## 8. Using meshes in Studio

- `MeshPart.MeshId` **cannot** be set from scripts (Roblox blocks it). Set it in the Properties panel.
- `SpecialMesh` on a normal Part **can** be set from scripts.
- Client resolves `rbxassetid://ID` from `AssetCache\ID` through the server web port.

---

## 9. Ports cheat sheet

| Role | Protocol | Example |
|------|----------|--------|
| Web (join, assets) | TCP | 2005 |
| RCC (game) | UDP | 2005 |

Use whatever free ports you want. Same number for both is fine if nothing else is using them.

---

## Links

- RFD: https://github.com/Windows81/Roblox-Freedom-Distribution
- Releases: https://github.com/Windows81/Roblox-Freedom-Distribution/releases
