---
layout: basic
---

{% for series in site.data.allseries %}
<b>{{ series.title }}</b><br>
<i>{{ series.summary }}</i>
<ul>
{% for article in series.articles %}
    <li><a href="{{ series.dir }}/{{ article.dir }}" title="{{ article.intro }}">{{ article.title }}</a></li>
{% endfor %}
</ul>
{% endfor %}
