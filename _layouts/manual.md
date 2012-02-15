---
layout: common
---
<div class="title">The Julia Manual</div>
{% include links.html %}

<h1>{{ page.title }}</h1>

{{ content }}

<br/><br/>

{% assign this_index = 'none' %}
{% for i in (0..site.chapters.size) %}
  {% for this_chapter in site.chapters[i] %}
    {% if page.title == this_chapter[0] %}
      {% assign this_index = i %}
    {% endif %}
  {% endfor %}
{% endfor %}

{% capture prev_index %}{{ this_index | minus:1 }}{% endcapture %}
{% capture next_index %}{{ this_index | plus:1 }}{% endcapture %}

{% if this_index != 'none' %}
  {% if this_index > 0 %}
    {% for i in (0..site.chapters.size) %}
      {% capture istr %}{{i}}{% endcapture %}
      {% if istr == prev_index %}
        {% for chapter in site.chapters[i] %}
          <div class="chaplink prevlink">
            &laquo; <a href="../{{chapter[1]}}">{{chapter[0]}}</a>
          </div>
        {% endfor %}
      {% endif %}
    {% endfor %}
  {% endif %}
  {% if this_index < site.chapters.size %}
    {% for i in (0..site.chapters.size) %}
      {% capture istr %}{{i}}{% endcapture %}
      {% if istr == next_index %}
        {% for chapter in site.chapters[i] %}
          <div class="chaplink nextlink">
            <a href="../{{chapter[1]}}">{{chapter[0]}}</a> &raquo;
          </div>
        {% endfor %}
      {% endif %}
    {% endfor %}
  {% endif %}
{% endif %}
