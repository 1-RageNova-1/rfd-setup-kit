# RFD Setup Kit

Small helper pack for running [Roblox Freedom Distribution](https://github.com/Windows81/Roblox-Freedom-Distribution) offline servers with friends.

This is **not** affiliated with Roblox or the RFD project. Just notes + scripts we use.

## Download RFD.exe (official only)

**Get the exe here:**  
https://github.com/Windows81/Roblox-Freedom-Distribution/releases

On the latest release, download the Windows build from **Assets** (name is usually like `RFD-windows-latest.exe` or similar — rename to `RFD.exe` if you want).

Put it in a folder such as `C:\rfd`.

This repo does **not** ship `RFD.exe` or any Roblox client/server binaries. Redistributing those is a copyright mess and the builds go out of date anyway. Always pull from the official RFD releases page.

Optional: clone the full RFD source if you need mesh serialise with Draco:
```
git clone --depth 1 https://github.com/Windows81/Roblox-Freedom-Distribution rfd-source
```

## Whats in this kit

| File | What it does |
|------|--------------|
| `GUIDE.md` | How to start server, join, studio, convert places, meshes |
| `AssetsDownload.py` | Pull assets you own via Open Cloud into `temp_assets/` |
| `pull_real_assets.ps1` | Turn the JSON pointers into real files in `AssetCache/` |
| `serialise_meshes.ps1` | Convert meshes for the 2021 client (needs RFD source) |
| `GameConfig.example.toml` | Minimal config to copy |

## Quick start

1. Download `RFD.exe` from the official releases link above
2. Copy `GameConfig.example.toml` → `GameConfig.toml` next to `RFD.exe`
3. Put a place file as `MyPlace.rbxl` (or change the path in the config)
4. Start server (pick free ports):

```powershell
cd C:\rfd
$env:ROBLOSECURITY = "your_cookie_if_you_need_owned_assets"
.\RFD.exe server --config_path GameConfig.toml --web_port 2005 --rcc_port 2005
```

5. Join:

```powershell
.\RFD.exe player -h 127.0.0.1 -p 2005 -rp 2005 -u SomeName
```

Remote players: use the host public IP and open **TCP + UDP** for those ports.

Full steps are in **GUIDE.md**.

## License

Scripts here are free to use / modify.  
RFD itself is GPL-3.0 — see their repo.  
Roblox binaries stay under Roblox copyright; this kit does not redistribute them.
