---
layout: post
title:  Tetris coming to Julia language for v1.0
author: <a href="https://github.com/djsegal" target="_blank">Dan Segal</a>
---

Good news, everyone! Starting v1.0, Tetris will be included in the standard library. This will allow you to play a round of Tetris while your code is busy running.

Until Julia v1.0 drops next Wednesday, though, you can play online at:

+ [JuliaTetris.com](http://www.juliatetris.com)

Example footage below.

<style>

  .cs-tetris-div {
    text-align: center;
    padding-top: 4px;
    padding-bottom: 6px;
  }

  .cs-tetris-div a {
    transition: all 0.5s ease;
  }

  .cs-tetris-div a:hover {
    -webkit-filter: brightness(125%);
    opacity: 0.95;
  }

  .cs-tetris-div img {
    border-radius: 6px;
    max-height: 42vh;
  }

  .cs-tetris-div a:hover img {
    border: solid 2.5px;
  }

  .cs-tetris-div a:not(:hover) img {
    border: solid 2.5px transparent;
  }

</style>

<div class="cs-tetris-div">
  <a href="http://www.juliatetris.com">
    <img src="/images/blog/2018-04-01-tetris-and-you/green_tetris.gif" alt="tetris game">
  </a>
</div>
