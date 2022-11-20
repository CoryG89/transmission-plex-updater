# transmission-plex-updater

Configure the Transmission torrent client to intelligently keep your Plex Media Server instance up to date.

## Motivation

Plex Media Server ships with a nice feature for watching the disk and scanning your configured libraries for new media whenever a change on disk occurs within one or more of the directories configured as part of one of your libraries. Another nice option is the ability to configure it so that when it does detect a change on disk within one or more of its configured libraries, it will only run the scanner in the particular sub-tree on disk in which the detected change occurred, so that it does not have to run the scanner against the whole entire (potentially quite large) library on the disk when a change is perhaps detected in only a very small sub-tree of the library on disk.

Unfortunately, I learned recently that this feature is not supported for Plex libraries backed by a remote network share (eg. a mounted windows/smb/samba/cifs/nfs share). I have all of my media hosted on a network share not local to my Plex Media Server instance, so I was disappointed to learn that this meant I was stuck runnning the expensive scanning task on some fixed interval and/or running it manually.

## How It Works

This script allows you to configure the Transmission torrent client to totally restore that functionality by obtaining the torrent's save path on disk from Transmission whenver a torrent completes and calling the Plex API to check it against each of the configured paths for each Plex library. If the torrent save path is contained within any of the paths configured for any of the Plex Libraries then it uses the API to tell Plex to run the scanner against that library. The script instead uses the Plex API to restrict the scanning to only the subtree where the torrent was saved instead of scanning the  entire library path instead of the subtree entire library  al that subtree instead of scanning the arbitrarily large library on disk. the save path on disk from Transmission torrent completion running a script on torrent completion that getting the torrent save path on disk from Trasmissionand using against the configured paths for each library on the Plex Media Server instance.


## Dependencies

The script depends on the following:

 - curl (for calling the Plex API)
 - xq (for parsing the XML returned by the Plex API)
 - xargs (for pipelining the script's execution)

On Ubuntu/Debian, these can be obtained by running:

```sh
sudo apt install -y curl python3-pip
python3 -m pip install yq
```

After that you should have the `curl`, `xq`, and `xargs` on your `$PATH` and you should be able to run them.

## Setup

You can configure this with just a few steps:

  1. Clone the repo or just download the `transmision-script-on-torrent-done.sh` script.
  
  2. Uncomment the first few lines of `transmission-script-on-torrent-done.sh` or alternatively set `$PLEX_BASE_URL`, `$PLEX_API_TOKEN`, and optionally `$LOG_PATH` somewhere else such that they will be defined in the environment in which Transmission is running.

  3. Update your Transmission client settings by setting the following two settings in your Transmission client's `settings.json` file:

```js
{
    // ...
    "script-torrent-done-enabled": true,
    "script-torrent-done-filename": "/path/to/transmission-script-on-torrent-done.sh"
}
```
