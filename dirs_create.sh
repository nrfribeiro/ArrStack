export FOLDER_FOR_MEDIA=/your-media-folder       # Change to where you want your media to be stored
export FOLDER_FOR_DATA=/your-app-configs         # Change to where you want your container configurations to be stored

export PUID=1000
export PGID=1000

mkdir -p $FOLDER_FOR_DATA/{authelia/assets,bazarr,ddns-updater,gluetun,heimdall,homarr/{configs,data,icons},homepage,jellyfin,jellyseerr,lidarr,mylar,plex,portainer,prowlarr,qbittorrent,radarr,readarr,sabnzbd,sonarr,swag,tdarr/{server,configs,logs},tdarr_transcode_cache,unpackerr,whisparr}
mkdir -p $FOLDER_FOR_MEDIA/media/{anime,audio,books,comics,movies,music,photos,tv,xxx}
mkdir -p $FOLDER_FOR_MEDIA/usenet/{anime,audio,books,comics,complete,console,incomplete,movies,music,prowlarr,software,tv,xxx}
mkdir -p $FOLDER_FOR_MEDIA/torrents/{anime,audio,books,comics,complete,console,incomplete,movies,music,prowlarr,software,tv,xxx}
mkdir -p $FOLDER_FOR_MEDIA/watch
mkdir -p $FOLDER_FOR_MEDIA/filebot/{input,output}
chmod -R 775 $FOLDER_FOR_MEDIA $FOLDER_FOR_DATA
chown -R $PUID:$PGID $FOLDER_FOR_MEDIA $FOLDER_FOR_DATA