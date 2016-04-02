---
layout: post
title: Gradle projects
show_git_clone?: true
summary: This article covers what a Gradle project is and how it is organized. After reading this article and the previous one, you should be able to understand many Gradle scripts for real projects.
---

## Overview

### What is a Gradle project?

<span name="projectname">A Gradle project is a named collection of tasks</span>. You can think of it as a folder, a `build.gradle` file, and all other contents in that folder.

{% filetree %}
<i>root</i>/
    build.gradle
    src/
    resources/
    ...
{% endfiletree %}

<aside name="projectname">By default, a project's name comes from the folder which contains the Gradle build script. Modifying it is not a common action and therefore not covered in this series, but it's easy to find the answer if you search for it.</aside>

Commonly, you'll define projects that represent a library or an application. In fact, this may be all you ever use Gradle for, and that's fine.

But you can define a Gradle project to do pretty much anything. A project isn't limited to just building code. For example, a project can spin up a web server and serve interal documentation to your team. Or a project can process art assets. Or, _whatever_ really. Gradle build scripts are programs, so Gradle projects, by extension, are very flexible.

Overall, it's easiest to think of a Gradle project as a `build.gradle` script plus data. In fact, for every `build.gradle` script, Gradle creates a single <span name="projectapi">`Project`</span> object that it associates with it. The relationship is one-to-one.

You can access this object directly by referencing `project` anywhere in your script:

<figcaption class="title">build.gradle</figcaption>
{% highlight groovy %}
task printName << {
  println "My project name: '${project.name}'"
}

task listTasks << {
  println "Project tasks are:"
  project.tasks.each { task ->
    println "\t${task.name}"
  }
}
{% endhighlight %}

<aside name="projectapi"><a href="https://docs.gradle.org/current/javadoc/org/gradle/api/Project.html">Check out the API</a> to learn more about what information is provided by the <code>Project</code> class.</aside>

{% terminal %}
$ cd empty_project

$ ./gradlew -q printName
My project name: 'empty_project'

$ ./gradlew -q listTasks
Project tasks are:
    printName
    listTasks
{% endterminal %}

<div class="note">Note the use of <code>gradlew -q</code>, where <code>q</code> is short for <code>quiet</code>. This cuts out a lot of chatty help text.</div>

## Project Organization

### Root project and settings.gradle

Gradle is designed so that multiple projects can work together to accomplish some larger goal. After all, if one project represents a library and another project represents an application, there needs to be a way to get the two of them to talk.

Gradle supports this by having you to declare a root project and configuring it with a list of target projects for it to manage. Often, these other projects are nested, which makes for a nice, hierarchical organization.

For the root project only, in addition to defining a `build.gradle` script, you also provide a `settings.gradle` file. This settings file defines all subprojects. If a target project isn't listed in there, the root project won't know about it.

<figcaption class="title">The layout of a root project and three nested projects, named "a", "b", and "c" for simplicity.<br>Note the inclusion of a <code>gradlew</code> binary in the root folder, which is a standard convention.</figcaption>
{% filetree %}
root_project/
    gradlew*
    <b>build.gradle</b>
    <b>settings.gradle</b>
    a/
        build.gradle
    b/
        build.gradle
    c/
        build.gradle
{% endfiletree %}

<figcaption class="title">build.gradle, a/build.gradle, b/guild.gradle, c/build.gradle</figcaption>
{% highlight groovy %}
task printName << {
  println "My project name: '${project.name}'"
}
{% endhighlight %}

<figcaption class="title">settings.gradle</figcaption>
{% highlight groovy %}
include 'a', 'b', 'c'
{% endhighlight %}

Simply including the subproject names in your `settings.gradle` is all you need to do in most cases. Gradle automatically searches the current path for matching subdirectories and creates a `Project` for each.

Now, we have multiple projects all with the same task (`printName`). By default, when you make a request to run a Gradle task, it will fire all tasks that match.

If you want to target a task in a particular project, you will need to qualify its name. You do this by explicitly including the project name before the task,

e.g. `task` → `projectname:task`

{% terminal %}
$ cd root_project

$ ./gradlew -q printName
My project name: 'root_project'
My project name: 'a'
My project name: 'b'
My project name: 'c'

$ ./gradlew -q c:printName
My project name: 'c'
{% endterminal %}

The `:` character is essentially a path separator, playing a similar role to the `/` character in a directory path.

If you start a project name with a `:`, that means start from the root project. If you don't, Gradle treats the task name like a relative path, using the current directory to figure out the active project scope.

By using `:` and starting from the root, you can reference any project's task from the directory of any other.

{% terminal %}
$ cd root_project

$ ./gradlew -q printName
My project name: 'root_project'
My project name: 'a'
My project name: 'b'
My project name: 'c'

$ ./gradlew -q :printName
My project name: 'root_project'

$ cd b

$ ../gradlew -q printName
My project name: 'b'

$ ../gradlew -q :printName
My project name: 'root_project'

$ ../gradlew -q :c:printName
My project name: 'c'
{% endterminal %}

<div class="note">Gradle only supports one root project at any time. Even if you wrap a subproject that has its own <code>settings.gradle</code> in it, it will be ignored. Only the root <code>settings.gradle</code> file will be considered in a Gradle run.
</div>

### Deeply nested projects

Projects can be nested more than one level deep. Just be sure to qualify the project names correctly, such as `:root:projectParent:projectChild`.

{% filetree %}
nested_projects/
    gradlew*
    build.gradle
    settings.gradle
    <b>a</b>/
        build.gradle
        <b>b</b>/
            build.gradle
            <b>c</b>/
                build.gradle
{% endfiletree %}

<figcaption class="title">settings.gradle</figcaption>
{% highlight groovy %}
include 'a', 'a:b', 'a:b:c'
{% endhighlight %}

{% terminal %}
$ cd nested_projects

$ ./gradlew -q printName
My project name: 'nested_projects'
My project name: 'a'
My project name: 'b'
My project name: 'c'

$ ./gradlew -q a:printName
My project name: 'a'

$ ./gradlew -q b:printName
* What went wrong:
Project 'b' not found in root project 'nested_projects'

$ ./gradlew -q a:b:printName
My project name: 'b'
{% endterminal %}

### Project blocks

You may have noticed in the previous sections that I duplicated a lot of script code. In particular, each subproject had the exact same copy of the root project's `build.gradle` script. Of course, we can do better than this and share code across projects.

Gradle provides special blocks that are available to the root project: `allprojects` and `subprojects`. Any logic within the `allprojects` blocks will be available both to the root project itself as well as its subprojects. The `subprojects` block does the same, except excluding the root project.

In fact, by specifying these blocks in your root script, you don't even need to have `build.gradle` files in the subproject folders at all. Of course, if there are `build.gradle` files in these subprojects, the additional logic will simply be combined into them.

For completion, you should also know you can also target a project directly using the `project(':project-name')` method.

{% filetree %}
project_blocks/
    gradlew*
    build.gradle
    settings.gradle
    a/
        example_file_a1.txt
        example_file_a1.txt
    b/
        example_file_b1.txt
    c/
        example_file_c1.txt
        example_file_c2.txt
        example_file_c3.txt
{% endfiletree %}

<figcaption class="title">build.gradle</figcaption>
{% highlight groovy %}
allprojects {
    task printName << {
        println "My project name: '${project.name}'"
    }
}

subprojects {
    task listFiles << {
        println "Project '${project.name}', files:"
        fileTree('.').visit { file ->
            println "\t${file.relativePath}"
        }
    }
}

project(':c') {
    task listTasks << {
        println "Project '${project.name}', tasks:"
        project.tasks.each { task ->
            println "\t${task.name}"
        }
    }
}
{% endhighlight %}

The above gradle script defines `printName` in every project, `listFiles` in subprojects only, and `listTasks` only in project `c`.

{% terminal %}
$ cd project_blocks

$ ./gradlew -q printName
My project name: 'project_blocks'
My project name: 'a'
My project name: 'b'
My project name: 'c'

$ ./gradlew -q listFiles
Project 'a', files:
  example_file_a1.txt
  example_file_a2.txt
Project 'b', files:
  example_file_b1.txt
Project 'c', files:
  example_file_c1.txt
  example_file_c2.txt
  example_file_c3.txt

$ ./gradlew -q listTasks
Project 'c', tasks:
  listFiles
  listTasks
  printName
{% endterminal %}

`allprojects` and `subprojects` blocks are a great place to set variables or define tasks that are shared across projects. The `project` selector may be useful occasionally, but it is probably better to just put that logic in the subproject `build.gradle` script directly.

In short, if you find yourself repeating logic across subprojects, think about moving it to the root project instead.

### External paths

In practice, it's pretty common to have a root project that wants to reach outside of its own path to some external directory. For example, a project may commonly be laid out as follows, where the library directories are not children of the application directory:

{% filetree %}
external_paths/
    <b>app_root</b>/
        build.gradle
        settings.gradle
        app/
            src/
                SampleApp.java
                ...
    libs/
        <b>lib1</b>/
            src/
                Lib1.java
                ...
        <b>lib2</b>/
            src/
                Lib2.java
                ...
{% endfiletree %}

To provide a custom path for a project, you can override any default settings in the `settings.gradle` file.

<figcaption class="title">app_root/settings.gradle</figcaption>
{% highlight groovy %}
include 'app', 'lib1', 'lib2'

project(':lib1').projectDir = file('../libs/lib1')
project(':lib2').projectDir = file('../libs/lib2')
{% endhighlight %}

<figcaption class="title">app_root/build.gradle</figcaption>
{% highlight groovy %}
subprojects {
    task listJava << {
        println "Project '${project.name}', source files:"
        fileTree('.').include('**/*.java').visit { file ->
            if (!file.isDirectory()) {
                println "\t${file.relativePath}"
            }
        }
    }
}
{% endhighlight %}

By modifying `settings.gradle` in this way, you not only can support complex project layouts, but this abstracts hardcoded path details out of your build script logic. For example, you can now safely change the location of `lib1` and/or `lib2` anytime. Simply update `settings.gradle` and everything will still compile.

As far as the root project is concerned, it thinks the organization is flat:

{% filetree %}
<i>root</i>/
    app/
    lib1/
    lib2/
{% endfiletree %}

{% terminal %}
$ cd external_paths/app_root

$ ./gradlew -q listJava
Project 'app', source files:
  src/SampleApp.java
Project 'lib1', source files:
  src/Lib1.java
Project 'lib2', source files:
  src/Lib2.java
{% endterminal %}

## Key Takeaways

* A Gradle project is a folder containing a `gradle.build` script plus its contents
* Multiproject layout is accomplished with a root project that manages target projects
* A root project is defined by a `gradle.build` scripts plus a `settings.gradle` file
* To explicitly target the Gradle tasks of a particular subproject, qualify its name using `:` separators, e.g. `:path:to:project:<task>`
* Projects can be nested as deeply as you want
* Gradle allows `allprojects` and `subprojects` blocks in the root project to share code across scripts
* You can specify a project's path in `settings.gradle`, allowing Gradle to manage projects in external directories