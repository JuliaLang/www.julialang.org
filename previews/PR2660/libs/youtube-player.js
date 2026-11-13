// YouTube IFrame API loader for JuliaCon playlist.
// The playlist ID comes from the #player element's data-playlist attribute.
// Videos are uploaded in batches, so the playlist is read live on each page
// load and a random video is picked from whatever it contains at the time.
(function () {
  const el = document.getElementById('player');
  if (!el) return;
  const playlistId = el.dataset.playlist;

  const tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  const firstScriptTag = document.getElementsByTagName('script')[0];
  if (!firstScriptTag || !firstScriptTag.parentNode) return;
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  let player;
  let picked = false;

  // Cue a random video once the playlist contents are known. They may not
  // be available yet in onReady, so this is also retried on state changes.
  function pickRandom() {
    if (picked) return;
    const playlist = player.getPlaylist();
    if (!playlist || playlist.length === 0) return;
    picked = true;
    if (playlist.length > 1) {
      player.cuePlaylist({
        listType: 'playlist',
        list: playlistId,
        index: Math.floor(Math.random() * playlist.length),
      });
    }
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
        'onReady': pickRandom,
        'onStateChange': pickRandom,
      }
    });
  };
})();
