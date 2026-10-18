#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <thunderstore_download_url>"
    echo "Example: $0 https://thunderstore.io/package/download/Smoothbrain/DualWield/1.0.10/"
    exit 1
fi

URL="$1"

path="${URL#https://thunderstore.io/package/download/}"
path="${path%/}"
IFS='/' read -ra parts <<< "$path"

author="${parts[0]}"
name="${parts[1]}"
version="${parts[2]}"

if [ -z "$author" ] || [ -z "$name" ] || [ -z "$version" ]; then
    echo "[ERROR] Could not parse author/name/version from URL."
    exit 1
fi
echo "[INFO] Mod details:"
echo "Author:  $author"
echo "Name:    $name"
echo "Version: $version"

target_dir="./BepInEx/plugins/${author}-${name}"
mkdir -p "$target_dir"

temp_file="/tmp/${author}-${name}-${version}.zip"
echo "[PROC] Downloading and unzipping $URL ..."
curl -fSL -o "$temp_file" "$URL" || { echo "Download failed."; exit 1; }

temp_dir="/tmp/${author}-${name}-${version}-unzipped"
mkdir -p "$temp_dir"
unzip -oq "$temp_file" -d "$temp_dir" || { echo "Unzip failed."; rm -f "$temp_file"; exit 1; }

found_dll=0
while IFS= read -r -d '' dll; do
    found_dll=1
    dll_name="$(basename "$dll")"
    dest="$target_dir/$dll_name"
    if [ -f "$dest" ]; then
        read -rp "[INFO] $dll_name already exists. Overwrite? [y/N] " answer < /dev/tty
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            mv -f "$dll" "$dest"
            echo "[WARN] Overwrote $dll_name"
        else
            echo "[WARN] Skipped $dll_name"
        fi
    else
        mv "$dll" "$dest"
        echo "[INFO] Installed $dll_name"
    fi
done < <(find "$temp_dir" -name '*.dll' -type f -print0)

[ "$found_dll" -eq 0 ] && echo "[WARN] No .dll files found in the archive."

rm -f "$temp_file"
rm -rf "$temp_dir"

echo "[INFO] Done"
