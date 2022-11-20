#!/usr/bin/env bash

# Uncomment and assign or set these variables elsewhere to configure
# the Plex API base URL and API token, optionally a path for logging
#
# PLEX_BASE_URL='https://plex.example.com'
# PLEX_API_TOKEN='fDsovASlevmzDevbUak'
# LOG_PATH="$HOME/.local/var/log/transmission-plex-updater.log"

set -eo pipefail

fetchPlexSections() {
    curl -s "$PLEX_BASE_URL/library/sections?X-Plex-Token=$PLEX_API_TOKEN"
}

parseContainingSectionId() {
    # shellcheck disable=SC2016
    xq -r --arg PATH "$TR_TORRENT_DIR" '.MediaContainer.Directory | map(.Location) | map(objects) + map(arrays | .[]) | map(select(. as $SECTION_PATH | $PATH | startswith($SECTION_PATH["@path"]))) | map(.["@id"])[]'
}

refreshSection() {
    xargs -I{} curl -s "$PLEX_BASE_URL/library/sections/{}/refresh?path=$TR_TORRENT_DIR&X-Plex-Token=$PLEX_API_TOKEN"
}

if [[ -n "$LOG_PATH" ]]; then
    exec &> >(tee -a "$LOG_PATH")
    printf '[%s] Torrent Complete: Saved to disk at %s, checking if plex needs update\n' "$(date)" "$TR_TORRENT_DIR"
fi

fetchPlexSections | parseContainingSectionId | refreshSection
