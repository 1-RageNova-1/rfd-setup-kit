"""
Pull owned assets via Roblox Open Cloud.

You need an API key from https://create.roblox.com/dashboard/credentials
with permission to read assets.

Edit ASSET_IDS below, then:
    python AssetsDownload.py

Output goes to temp_assets/ as small JSON files.
Run pull_real_assets.ps1 right after to grab the actual bytes
(signed links expire pretty fast).
"""

import getpass
import sys
import time
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

# --- put the asset ids you care about here ---
ASSET_IDS = [
    "123456789",   # example, replace me
    # "987654321",
]

OUT_DIR = Path("temp_assets")


def grab(api_key: str, asset_id: str) -> bool:
    url = f"https://apis.roblox.com/asset-delivery-api/v1/assetId/{asset_id}"
    req = Request(url, headers={"x-api-key": api_key})
    try:
        with urlopen(req, timeout=45) as resp:
            data = resp.read()
        if not data:
            print(f"  empty response for {asset_id}")
            return False
        OUT_DIR.mkdir(parents=True, exist_ok=True)
        path = OUT_DIR / asset_id
        path.write_bytes(data)
        print(f"  wrote {path} ({len(data)} bytes)")
        return True
    except HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")[:400]
        print(f"  http {e.code} on {asset_id}: {e.reason}")
        if body:
            print(f"  {body}")
        return False
    except (URLError, TimeoutError, OSError) as e:
        print(f"  failed {asset_id}: {e}")
        return False


def main() -> int:
    if not ASSET_IDS or ASSET_IDS[0] == "123456789":
        print("edit ASSET_IDS in this file first")
        return 1

    key = getpass.getpass("Open Cloud API key: ").strip()
    if not key:
        print("no key, abort")
        return 1

    ok = 0
    for i, aid in enumerate(ASSET_IDS, 1):
        print(f"[{i}/{len(ASSET_IDS)}] {aid}")
        if grab(key, aid):
            ok += 1
        time.sleep(0.35)

    print(f"\ndone {ok}/{len(ASSET_IDS)} -> {OUT_DIR.resolve()}")
    print("run pull_real_assets.ps1 next before the links expire")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
