---
layout: default
title:  Julia Publications
---

For citing Julia, we recommend:

{% assign beks17 = site.publications | where:"path","_publications/BEKS17.md" | first %}
<div>{% include citation.html pub=beks17 %}</div>

The following is a list of publications about the Julia language, its
standard library, Julia packages, and technical computing applications
using code written in Julia. The list below is by no means complete,
and is based on submissions by authors. A broader list of papers is
available on [Google
Scholar](https://scholar.google.com/scholar?cites=12373977815425691465&as_sdt=40000005&sciodt=0,22&hl=en).

We welcome additions to this list in the form of [pull requests](https://github.com/JuliaLang/julialang.github.com/tree/master/_publications#readme).

{% assign pubs_grouped = site.publications | group_by: 'year' | sort: 'name' | reverse %}
<ul class="publist">
{% for eachyear in pubs_grouped  %}
  <h2> {{ eachyear.name }} </h2>
  {% for pub in eachyear.items %}
  <li id="{{ pub.path | remove: "_publications/" | remove: ".md"  }}">{% include citation.html pub=pub %}</li>
  {% endfor %}
{% endfor %}
</ul>
