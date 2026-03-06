// YouTube IFrame API loader for JuliaCon playlist
(function () {
  const tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  const firstScriptTag = document.getElementsByTagName('script')[0];
  if (!firstScriptTag || !firstScriptTag.parentNode) return;
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  let player;
  const prevHandler = window.onYouTubeIframeAPIReady;
  window.onYouTubeIframeAPIReady = function () {
    if (prevHandler) prevHandler();
    player = new YT.Player('player', {
      playerVars: {
        list: 'PLP8iPy9hna6SZOq4EH_nE_BFulBAKXkf1',
        listType: 'playlist',
      },
      events: {
        'onReady': function (event) {
          const playlist = player.getPlaylist();
          if (playlist && playlist.length > 0) {
            player.cuePlaylist({
              index: Math.floor(Math.random() * playlist.length)
            });
          }
        },
      }
    });
  };
})();
