$(function(){
  // console.log(platform.os);
  hljs.initHighlightingOnLoad();
});

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
  things = [
    ["Machine learning researchers", "brain–computer interfaces", "#"],
    ["Mathematicians", "differential equations", "http://sched.co/FQ3h"],
    // ["Physicists", "quantum simulations", "http://sched.co/FQ4H"],
    // ["Statisticans", "Bayesian inference", "http://sched.co/FQ4J"],
    // ["Space scientists", "systems engineering"],
    // ["Insurers", "risk models"],
    // ["Energy companies", "load forecasting"],
    // ["Geophysicists", "data analysis"],
    // ["Researchers", "parallel computing"],
    // ["Economists", "supercomputers"],
    // ["Students", "code"],
    // ["Engineers", "LIDAR data"],
    // ["Whale spotters", "neural networks"],
    // ["Kids", "Minecraft"],
    ["Engineers", "robots"]
  ]
  shuffle(things)
  // loop through and replace elements every 5 seconds
  count = 0;
  interval = 5000;
  setInterval(function() {
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
  }, interval);
});
