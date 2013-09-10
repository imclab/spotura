Spotify playlist generator.
It parses several music review sites and generate Spotify playlists, for personal use.

You need a Spotify application key, which can be downloaded from: https://developer.spotify.com/en/libspotify/application-key/

```
bundle install

# Fetch the latest reviewed albums and create a playlist
SPOTIFY_USERNAME=YOUR_USERNAME SPOTIFY_PASSWORD=YOUR_PASSWORD bundle exec ruby textura_latest.rb

# Fetch the archive belongs to letter 'a' and create a playlist
SPOTIFY_USERNAME=YOUR_USERNAME SPOTIFY_PASSWORD=YOUR_PASSWORD CATALOG_LETTER=a bundle exec ruby textura_archive.rb
```
