---
layout: basic
title: Series
---

{% for s in site.data.series %}
<b>{{ s.title }}</b><br>
<i>{{ s.summary }}</i>
<ul>
{% for p in s.pages %}
    <li><a href="{{ p.url | prepend: site.baseurl }}" title="{{ p.summary }}">{{ p.title }}</a></li>
{% endfor %}
</ul>
{% endfor %}
