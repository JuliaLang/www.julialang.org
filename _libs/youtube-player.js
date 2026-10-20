// YouTube IFrame API loader for JuliaCon playlist.
// The playlist ID comes from the #player element's data-playlist attribute.
// Videos are uploaded in batches, so the playlist is read live on each page
// load and a random video is picked from whatever it contains at the time.
// Videos longer than MAX_DURATION (e.g. full-day livestreams) are skipped.
(function () {
  const el = document.getElementById('player');
  if (!el) return;
  const playlistId = el.dataset.playlist;
  const MAX_DURATION = 2 * 60 * 60; // seconds

  const tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  const firstScriptTag = document.getElementsByTagName('script')[0];
  if (!firstScriptTag || !firstScriptTag.parentNode) return;
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  let player;
  let videoIds = null;   // playlist video IDs, read once it has loaded
  let candidates = null; // shuffled playlist indices not yet tried
  let current = null;    // index of the video being checked
  let done = false;

  // Cue the next untried random video. Its duration is only known once it
  // has been cued, so it is checked in checkDuration().
  function cueNext() {
    if (candidates.length === 0) {
      done = true; // everything is too long; keep the last one cued
      return;
    }
    current = candidates.pop();
    player.cuePlaylist({ listType: 'playlist', list: playlistId, index: current });
    checkDuration(current, 0);
  }

  // Right after cueing, the player can still report the previous video's
  // duration (or 0), so poll until it reports the cued video.
  function checkDuration(index, attempt) {
    if (done || index !== current) return;
    // getPlaylist() is briefly empty after cueing, so use the IDs read earlier.
    const videoId = videoIds[index];
    const duration = player.getDuration();
    const loaded = player.getPlaylistIndex() === index &&
      (player.getVideoUrl() || '').indexOf(videoId) !== -1 && duration > 0;
    if (!loaded) {
      // Give up after ~5s and keep this video rather than leave the player empty.
      if (attempt < 50) {
        setTimeout(function () { checkDuration(index, attempt + 1); }, 100);
      } else {
        done = true;
      }
    } else if (duration > MAX_DURATION) {
      cueNext();
    } else {
      done = true;
    }
  }

  function onPlayerEvent() {
    if (candidates !== null) return;
    // The playlist may not be available yet in onReady, so this is also
    // retried on state changes.
    const playlist = player.getPlaylist();
    if (!playlist || playlist.length === 0) return;
    videoIds = playlist;
    candidates = playlist.map(function (_, i) { return i; });
    for (let i = candidates.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [candidates[i], candidates[j]] = [candidates[j], candidates[i]];
    }
    cueNext();
  }

  const prevHandler = window.onYouTubeIframeAPIReady;
  window.onYouTubeIframeAPIReady = function () {
    if (prevHandler) prevHandler();
    player = new YT.Player('player', {
      playerVars: {
        list: playlistId,
        listType: 'playlist',
      },
      events: {
        'onReady': onPlayerEvent,
        'onStateChange': onPlayerEvent,
      }
    });
  };
})();
