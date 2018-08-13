$(function(){
  hljs.initHighlightingOnLoad();
});

// Shuffle an array
function shuffle(a) {
  var j, x, i;
  for (i = a.length - 1; i > 0; i--) {
      j = Math.floor(Math.random() * (i + 1));
      x = a[i];
      a[i] = a[j];
      a[j] = x;
  }
  return a;
}

// Cycle through words in the jumbotron
$(function() {
  // default content
  things = [["People", "code"]];
  $.getJSON("v2/data/amazing-things.json", function(data) {
    things = [];
    $.each(data, function(key, val) {
      things.push(val)
    })
    shuffle(things)
  });

  // loop through and replace elements every 5 seconds
  count = 0;
  initial_interval = 2500;
  interval = 5000;
  randomise = function() {
    count++;
    i = count % things.length;
    object = things[i][0];
    subject = things[i][1];
    link = things[i][2];
    $("#words1").fadeOut(300, function() {
      $(this).text(object).fadeIn(300);
    });
    $("#words2").fadeOut(300, function() {
      text = subject + "."
      if (link !== undefined && link !== null){
        text += "<a class='link' href='"+link+"'>*</a>"
      }
      $(this).html(text).fadeIn(300);
    });
  };
  setTimeout(function() {
    randomise();
    setInterval(randomise, interval)
  }, initial_interval);
});
