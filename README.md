# RFD Setup Kit

Small helper pack for running [Roblox Freedom Distribution](https://github.com/Windows81/Roblox-Freedom-Distribution) offline servers with friends.

This is **not** affiliated with Roblox or the RFD project. Just notes + scripts we use.

## Whats in here

| File | What it does |
|------|--------------|
| `GUIDE.md` | How to start server, join, studio, convert places, meshes |
| `AssetsDownload.py` | Pull assets you own via Open Cloud into `temp_assets/` |
| `pull_real_assets.ps1` | Turn the JSON pointers into real files in `AssetCache/` |
| `serialise_meshes.ps1` | Convert meshes for the 2021 client (needs RFD source) |
| `GameConfig.example.toml` | Minimal config to copy |

## Get RFD itself

Download the latest Windows exe from the official releases:

https://github.com/Windows81/Roblox-Freedom-Distribution/releases

Put `RFD.exe` in a folder (example: `C:\rfd`).  
Optional: clone the full repo if you need mesh serialise with Draco.

## Quick start

1. Copy `GameConfig.example.toml` → `GameConfig.toml` next to `RFD.exe`
2. Put a place file as `MyPlace.rbxl` (or change the path in the config)
3. Start server (pick free ports):

```powershell
cd C:\rfd
$env:ROBLOSECURITY = "your_cookie_if_you_need_owned_assets"
.\RFD.exe server --config_path GameConfig.toml --web_port 2005 --rcc_port 2005
```

4. Join:

```powershell
.\RFD.exe player -h 127.0.0.1 -p 2005 -rp 2005 -u SomeName
```

Remote players: use the host public IP and open **TCP + UDP** for those ports.

Full steps are in **GUIDE.md**.

## License

Scripts here are free to use / modify.  
RFD itself is GPL-3.0 — see their repo.  
Roblox binaries stay under Roblox copyright; this kit does not redistribute them.
