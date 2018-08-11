$(function(){
  // console.log(platform.os);
  hljs.initHighlightingOnLoad();
});

// Cycle through words in the jumbotron
$(function() {
  things = [
    ["Mathematicians", "differential equations"],
    ["Physicists", "quantum simulations"],
    ["Statisticans", "Bayesian inference"],
    ["Space scientists", "systems engineering"],
    ["Insurers", "risk models"],
    ["Energy companies", "load forecasting"],
    ["Geophysicists", "data analysis"],
    ["Researchers", "parallel computing"],
    ["Economists", "supercomputers"],
    ["Students", "code"],
    ["Engineers", "LIDAR data"],
    ["Whale spotters", "neural networks"]
  ]
  // shuffle the array
  things.sort(function(a,b){return 0.5 - Math.random()});
  console.log(things);
  // loop through and replace elements every 5 seconds
  count = 0;
  setInterval(function() {
    count++;
    i = count % things.length
    $("#words1").fadeOut(400, function() {
      $(this).text(things[i][0]).fadeIn(400);
    });
    $("#words2").fadeOut(400, function() {
      $(this).text(things[i][1]+".").fadeIn(400);
    })
  }, 5000);
});
