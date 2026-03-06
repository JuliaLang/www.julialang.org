// YouTube IFrame API loader for JuliaCon playlist
(function () {
  var tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  var player;
  var prevHandler = window.onYouTubeIframeAPIReady;
  window.onYouTubeIframeAPIReady = function () {
    if (prevHandler) prevHandler();
    player = new YT.Player('player', {
      playerVars: {
        list: 'PLP8iPy9hna6SZOq4EH_nE_BFulBAKXkf1',
        listType: 'playlist',
      },
      events: {
        'onReady': function (event) {
          var playlist = player.getPlaylist();
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
