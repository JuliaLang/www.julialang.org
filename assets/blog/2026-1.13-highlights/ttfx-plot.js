// Interactive TTFX plot for the Julia 1.13 highlights post.
// Data comes from ttfx-data.js (window.TTFX_DATA): per machine, per metric, the
// geometric mean over the Julia-TTFX-Snippets workflows plus every workflow's own
// times. Default view is the precompile geomean only; the metric tabs, the
// per-workflow lines and the hover readout are progressive detail.
(function () {
  var D = window.TTFX_DATA;
  var root = document.getElementById("ttfx-plot");
  if (!D || !root) return;

  var NS = "http://www.w3.org/2000/svg";
  var VERS = D.versions;
  var METRICS = [
    { id: "precompile", tab: "Precompilation",
      title: "Julia 1.13 precompiles packages ~30% faster than 1.12",
      sub: "Geometric mean precompilation time of the full dependency tree from a clean depot" },
    { id: "load", tab: "Package load",
      title: "Package load time",
      sub: "Geometric mean load time after precompilation, excluding Julia startup" },
    { id: "run", tab: "Script execution",
      title: "Script execution time",
      sub: "Geometric mean first-execution time of each workflow after loading" },
  ];
  // Plot geometry in viewBox units. On a narrow container (phones) the viewBox is
  // narrower too, so the same nominal font sizes come out larger on screen, and the
  // tick/label fonts are bumped further via the ttfx-narrow class.
  var W, H, PL, PR, PT, PB, PLOT_H, xs, narrow;
  function layout() {
    narrow = root.clientWidth > 0 && root.clientWidth < 560;
    W = narrow ? 440 : 760;
    PL = narrow ? 60 : 70;
    PR = narrow ? 340 : 620;
    PT = 24;
    PLOT_H = narrow ? 200 : 240;   // doubled when the workflows are shown
    xs = VERS.map(function (_, i) { return PL + i * (PR - PL) / (VERS.length - 1); });
    root.classList.toggle("ttfx-narrow", narrow);
  }
  var state = { metric: "precompile", tasks: false };
  var sc_y_cache = null;   // y-scale of the current render, for tooltips
  var hoverDot = null;     // marker on the workflow point under the mouse

  // ---------- controls ----------
  var controls = el("div", "ttfx-controls");
  var tabs = el("div", "ttfx-tabs");
  tabs.setAttribute("role", "tablist");
  METRICS.forEach(function (m) {
    var b = document.createElement("button");
    b.type = "button"; b.textContent = m.tab; b.dataset.metric = m.id;
    b.setAttribute("role", "tab");
    b.addEventListener("click", function () { state.metric = m.id; render(); });
    tabs.appendChild(b);
  });
  var toggle = document.createElement("label");
  toggle.className = "ttfx-toggle";
  var cb = document.createElement("input");
  cb.type = "checkbox";
  cb.addEventListener("change", function () { state.tasks = cb.checked; render(); });
  toggle.appendChild(cb);
  toggle.appendChild(document.createTextNode(" Show all " + D.ntasks + " workflows"));
  controls.appendChild(tabs);
  controls.appendChild(toggle);
  root.appendChild(controls);

  // Title, subtitle and legend are HTML so they wrap and scale with the page text.
  var head = el("div", "ttfx-head");
  var titleEl = el("div", "ttfx-title");
  var subEl = el("div", "ttfx-sub");
  var legendEl = el("div", "ttfx-legend");
  D.machines.forEach(function (mc) {
    var item = el("span", "ttfx-legend-item");
    item.appendChild(el("i", "ttfx-swatch ttfx-swatch-" + mc.id));
    item.appendChild(document.createTextNode(mc.label));
    legendEl.appendChild(item);
  });
  head.appendChild(titleEl); head.appendChild(subEl); head.appendChild(legendEl);
  root.appendChild(head);

  // The svg keeps its natural aspect from the viewBox; the wrapper's height is set
  // explicitly and transitions, so the chart grows and shrinks smoothly when the
  // workflows are toggled instead of jumping.
  var wrap = el("div", "ttfx-wrap");
  var svg = document.createElementNS(NS, "svg");
  svg.setAttribute("role", "img");
  wrap.appendChild(svg);
  root.appendChild(wrap);
  function fitWrap() { if (wrap.clientWidth) wrap.style.height = (wrap.clientWidth * H / W) + "px"; }
  // Re-lay out when the container crosses the narrow threshold; otherwise just refit.
  window.addEventListener("resize", function () {
    var was = narrow;
    layout();
    if (narrow !== was) render(); else fitWrap();
  });
  var tip = el("div", "ttfx-tip");
  tip.hidden = true;
  root.appendChild(tip);

  // ---------- helpers ----------
  function el(tag, cls) { var e = document.createElement(tag); if (cls) e.className = cls; return e; }
  function s(tag, attrs, cls) {
    var e = document.createElementNS(NS, tag);
    for (var k in attrs) e.setAttribute(k, attrs[k]);
    if (cls) e.setAttribute("class", cls);
    return e;
  }
  function text(x, y, str, cls, attrs) {
    var t = s("text", Object.assign({ x: x, y: y }, attrs || {}), cls);
    t.textContent = str;
    return t;
  }
  function fmt(v) {
    if (v >= 100) return v.toFixed(0) + " s";
    if (v >= 1) return v.toFixed(1) + " s";
    return (v * 1000).toFixed(0) + " ms";
  }
  // Axis ticks: whole numbers stay whole ("5 s", not "5.00 s").
  function fmtTick(v) {
    if (v === 0) return "0";
    if (v >= 1) return (Number.isInteger(v) ? v : v.toFixed(1)) + " s";
    return (v * 1000).toFixed(0) + " ms";
  }
  function pct(a, b) { return Math.round(100 * (a / b - 1)); }
  function pctStr(p) { return (p > 0 ? "+" : p < 0 ? "−" : "") + Math.abs(p) + "%"; }
  function pctCls(p) { return p < 0 ? "ttfx-good" : p > 0 ? "ttfx-bad" : "ttfx-ink2"; }
  // Changes worth quoting for point i of series ys: vs the previous release for the
  // newest point, and vs the first version (1.10, the LTS) for every later point.
  function deltas(ys, i) {
    var out = [];
    if (i === ys.length - 1 && ys[i - 1]) out.push({ p: pct(ys[i], ys[i - 1]), vs: VERS[i - 1] });
    if (i > 0 && ys[0]) out.push({ p: pct(ys[i], ys[0]), vs: VERS[0] });
    return out;
  }
  function deltaHtml(ys, i) {
    return deltas(ys, i).map(function (d) {
      return "<span class='" + pctCls(d.p) + "'>" + pctStr(d.p) + " vs " + d.vs + "</span>";
    }).join(" · ");
  }

  // Linear axis from zero for the summary; log when the workflows are shown, since
  // they span two decades.
  function makeScale(vals) {
    var max = Math.max.apply(null, vals);
    if (!state.tasks) {
      var step = niceStep(max / 4);
      var top = Math.ceil(max / step) * step;
      var ticks = [];
      for (var v = 0; v <= top + 1e-9; v += step) ticks.push(v);
      return { y: function (v) { return PB - (v / top) * (PB - PT); }, ticks: ticks };
    }
    // Hug the data (a few percent of padding in log space) rather than rounding out to
    // whole decades, which flattened the lines. Ticks at the decades inside the range,
    // with 2x and 5x steps added when fewer than three decades are visible.
    var min = Math.min.apply(null, vals);
    var lo = Math.log10(min) - 0.05, hi = Math.log10(max) + 0.05;
    var tks = [];
    for (var e = Math.ceil(lo); e <= Math.floor(hi); e++) tks.push(Math.pow(10, e));
    if (tks.length < 3) {
      for (var e2 = Math.floor(lo); e2 <= Math.floor(hi); e2++) [2, 5].forEach(function (f) {
        var v = f * Math.pow(10, e2);
        if (Math.log10(v) >= lo && Math.log10(v) <= hi) tks.push(v);
      });
      tks.sort(function (a, b) { return a - b; });
    }
    return { y: function (v) { return PB - ((Math.log10(v) - lo) / (hi - lo)) * (PB - PT); }, ticks: tks };
  }
  function niceStep(raw) {
    var p = Math.pow(10, Math.floor(Math.log10(raw)));
    var f = raw / p;
    return (f <= 1 ? 1 : f <= 2 ? 2 : f <= 5 ? 5 : 10) * p;
  }

  // ---------- render ----------
  function render() {
    var m = METRICS.filter(function (x) { return x.id === state.metric; })[0];
    Array.prototype.forEach.call(tabs.children, function (b) {
      var on = b.dataset.metric === m.id;
      b.setAttribute("aria-selected", on);
      b.classList.toggle("ttfx-on", on);
    });
    while (svg.firstChild) svg.removeChild(svg.firstChild);
    tip.hidden = true;
    layout();
    titleEl.textContent = m.title;
    subEl.textContent = m.sub + ", " + D.ntasks + " workflows.";
    // Twice the vertical room for 39 lines per machine, so they spread out.
    PB = PT + (state.tasks ? 2 : 1) * PLOT_H;
    H = PB + (narrow ? 62 : 70);
    svg.setAttribute("viewBox", "0 0 " + W + " " + H);
    fitWrap();

    var vals = [];
    D.machines.forEach(function (mc) {
      vals = vals.concat(mc.geomean[m.id]);
      if (state.tasks) for (var k in mc.tasks[m.id]) mc.tasks[m.id][k].forEach(function (v) { if (v) vals.push(v); });
    });
    var sc = makeScale(vals);
    sc_y_cache = sc.y;

    // grid + y ticks
    sc.ticks.forEach(function (v) {
      var y = sc.y(v);
      svg.appendChild(s("line", { x1: PL, y1: y, x2: PR, y2: y }, v === 0 ? "ttfx-axis" : "ttfx-grid"));
      svg.appendChild(text(PL - 10, y + 4, fmtTick(v), "ttfx-muted ttfx-tick", { "text-anchor": "end" }));
    });
    if (state.tasks) svg.appendChild(s("line", { x1: PL, y1: PB, x2: PR, y2: PB }, "ttfx-axis"));
    // x ticks
    // Hovering a version label shows the exact build each machine ran.
    VERS.forEach(function (v, i) {
      var label = text(xs[i], PB + 22, v + (i === 0 ? " (LTS)" : ""), "ttfx-ink2 ttfx-tick ttfx-xlabel", { "text-anchor": "middle" });
      label.addEventListener("mouseenter", function () {
        var builds = D.machines.map(function (mc) { return mc.builds[v]; });
        var same = builds.every(function (b) { return b === builds[0]; });
        tip.innerHTML = "<b>Julia " + v + "</b><br>" + (same ? builds[0] :
          D.machines.map(function (mc) { return mc.label.split(",")[0] + ": " + mc.builds[v]; }).join("<br>"));
        placeTip(xs[i], PB + 10);
      });
      label.addEventListener("mouseleave", function () { tip.hidden = true; });
      svg.appendChild(label);
    });
    svg.appendChild(text((PL + PR) / 2, PB + 46, "Julia version", "ttfx-muted ttfx-tick", { "text-anchor": "middle" }));

    // per-workflow lines, faint, drawn first; their hover targets go on top of everything
    var taskHits = [];
    if (state.tasks) {
      D.machines.forEach(function (mc) {
        for (var k in mc.tasks[m.id]) {
          var ys = mc.tasks[m.id][k];
          var pts = [];
          ys.forEach(function (v, i) { if (v) pts.push(xs[i] + "," + sc.y(v)); });
          if (pts.length < 2) continue;
          var pl = s("polyline", { points: pts.join(" "), fill: "none", "stroke-width": 1 }, "ttfx-line-" + mc.id + " ttfx-task");
          svg.appendChild(pl);
          taskHits.push({ line: pl, points: pts.join(" "), machine: mc, name: k, ys: ys });
        }
      });
    }

    // geomean lines + markers + endpoint labels
    var labelYs = [];
    D.machines.forEach(function (mc) {
      var g = mc.geomean[m.id];
      var pts = g.map(function (v, i) { return xs[i] + "," + sc.y(v); }).join(" ");
      svg.appendChild(s("polyline", { points: pts, fill: "none", "stroke-width": 2.5,
        "stroke-linejoin": "round", "stroke-linecap": "round" }, "ttfx-line-" + mc.id));
      g.forEach(function (v, i) {
        var c = s("circle", { cx: xs[i], cy: sc.y(v), r: i === VERS.length - 1 ? 5.5 : 4.5 }, "ttfx-fill-" + mc.id + " ttfx-ring");
        // generous hit target
        var hit = s("circle", { cx: xs[i], cy: sc.y(v), r: 14, fill: "transparent" });
        hit.style.cursor = "default";
        hit.addEventListener("mouseenter", function () { showTip(mc, m, g, i, xs[i], sc.y(v)); });
        hit.addEventListener("mouseleave", function () { tip.hidden = true; });
        svg.appendChild(c);
        svg.appendChild(hit);
      });
      // endpoint label: value and change vs 1.12
      var last = g.length - 1, y = sc.y(g[last]);
      // nudge apart if the two labels would collide
      // Only the relative changes: the geomean's absolute seconds aren't meaningful.
      labelYs.forEach(function (o) { if (Math.abs(o - y) < 34) y = o < y ? o + 34 : o - 34; });
      labelYs.push(y);
      deltas(g, last).forEach(function (d, j) {
        svg.appendChild(text(PR + 14, y - 2 + 14 * j, pctStr(d.p) + " vs " + d.vs, pctCls(d.p) + " ttfx-delta"));
      });
    });

    // Wide transparent strokes over each workflow line so a thin line is easy to hit.
    // Hovering names the workflow, lifts its line, and reads out the nearest version.
    taskHits.forEach(function (h) {
      var hit = s("polyline", { points: h.points, fill: "none" }, "ttfx-task-hit");
      hit.addEventListener("mouseenter", function () { h.line.classList.add("ttfx-hl"); });
      hit.addEventListener("mousemove", function (e) { showTaskTip(h, e); });
      hit.addEventListener("mouseleave", function () {
        h.line.classList.remove("ttfx-hl"); tip.hidden = true; hoverDot.setAttribute("visibility", "hidden");
      });
      svg.appendChild(hit);
    });
    // Marker for the point a workflow tooltip is describing; moves with the mouse.
    hoverDot = s("circle", { r: 4.5, visibility: "hidden", "pointer-events": "none" }, "ttfx-ring");
    svg.appendChild(hoverDot);
  }

  function svgX(e) {
    var sb = svg.getBoundingClientRect();
    return (e.clientX - sb.left) * W / sb.width;
  }
  function showTaskTip(h, e) {
    var sx = svgX(e), best = -1;
    h.ys.forEach(function (v, i) {
      if (v && (best < 0 || Math.abs(xs[i] - sx) < Math.abs(xs[best] - sx))) best = i;
    });
    if (best < 0) return;
    var v = h.ys[best];
    var html = "<b>" + h.name + "</b><br>" + h.machine.label + "<br><b>Julia " + VERS[best] + "</b> " + fmt(v);
    var d = deltaHtml(h.ys, best);
    if (d) html += "<br>" + d;
    tip.innerHTML = html;
    var y = sc_y_cache(v);
    hoverDot.setAttribute("cx", xs[best]);
    hoverDot.setAttribute("cy", y);
    hoverDot.setAttribute("class", "ttfx-ring ttfx-fill-" + h.machine.id);
    hoverDot.setAttribute("visibility", "visible");
    placeTip(xs[best], y);
  }

  function showTip(mc, m, g, i, x, y) {
    var v = g[i];
    var html = "<b>Julia " + VERS[i] + "</b> · " + mc.label + "<br>" + fmt(v);
    var d = deltaHtml(g, i);
    if (d) html += "<br>" + d;
    tip.innerHTML = html;
    placeTip(x, y);
  }

  function placeTip(x, y) {
    tip.hidden = false;
    var box = root.getBoundingClientRect(), sb = svg.getBoundingClientRect();
    var k = sb.width / W;
    var px = sb.left - box.left + x * k, py = sb.top - box.top + y * k;
    var left = Math.max(0, Math.min(box.width - tip.offsetWidth, px - tip.offsetWidth / 2));
    tip.style.left = left + "px";
    tip.style.top = (py - tip.offsetHeight - 14) + "px";
  }

  render();
  requestAnimationFrame(function () { wrap.classList.add("ttfx-animate"); });
})();
