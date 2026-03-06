// YouTube IFrame API loader for JuliaCon playlist
(function () {
  var tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  var player;
  window.onYouTubeIframeAPIReady = function () {
    player = new YT.Player('player', {
      playerVars: {
        list: 'PLP8iPy9hna6SZOq4EH_nE_BFulBAKXkf1',
        listType: 'playlist',
      },
      events: {
        'onReady': function (event) {
          player.cuePlaylist({
            index: Math.floor(Math.random() * player.getPlaylist().length)
          });
        },
      }
    });
  };
})();
