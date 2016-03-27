---
layout: basic
title: Series
---

{% for s in site.data.series %}
<b>{{ s.title }}</b><br>
<i>{{ s.summary }}</i>
<ul>
{% for a in s.articles %}
    {% for p in site.pages %}
        {% assign _pdir = p.url | split: '/' | last %}
        {% if _pdir == a %}
            <li><a href="{{ s.url }}/{{ a }}" title="{{ p.summary }}">{{ p.title }}</a></li>
            {% break %}
        {% endif %}
    {% endfor %}
{% endfor %}
</ul>
{% endfor %}
