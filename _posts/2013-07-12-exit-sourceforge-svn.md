---
comments: true
date: 2013-07-12 15:00:00
layout: post
slug: git-out-of-sourceforge-svn

title: Exit Sourceforge SVN to Git 
summary: "Git out of Sourceforge SVN, it's EASY!"
image: 'how-to-jekyll/wp_github_jekyll.png'
tags:
- git
- svn
---

# Why Would I Leave the Loving Arms of SourceForge?

Please, I am not looking to wreck any kind of relationship
that has been established over the years or months.  I just
find that there are many projects hosted in SourceForge as SVN
that would be well served if there was a `git` repo as well.
Many times, I'll take the SVN repo, convert it and push it to
Github, nothing against SourceForge, I just like Github better.
SourceForge supports multiple version control systems including
[git](http://sourceforge.net/apps/trac/sourceforge/wiki/Git).
I've not done any cross SVN-GIT development, so I'm not sure
how much of a burden it would be to support both.  It would seem
that `git` is the way of future, and with that in mind, let's *git*
going.

That is so lame, I'm sorry.

# Make a Backup Repo Copy

This is the secret in the sauce.  We `rsync` the bare SVN repo
onto our local machine and life is good.  Instructions are lifted
from [here](http://sourceforge.net/apps/trac/sourceforge/wiki/Subversion#Backups).

    rsync -av PROJECTNAME.svn.sourceforge.net::svn/PROJECTNAME/* .

[Adrian Smith](http://www.17od.com/2010/11/11/migrating-a-sourceforge-subversion-repository-to-github/) also writes about this feature of SourceForge
which makes backups **and** conversions a snap!

# Install svn2git

`svn2git` does what its name implies, but in a very robust amazing
way.  For those of you who have yet to install `rvm` I would recommend
checking out one of my [previous posts]().  Then, installation is a
total breeze.  If you install it to your `HOME` directory, installation
should be as easy as:

    gem install svn2git

If you've been crusty, or on a server, and you've installed `rvm` and
friends to `/usr/local` you'll of course need a `sudo` in front of the
`gem` command.

I found the following gist pretty helpful in the invocation of the
`svn2git` command:

  <script src="https://gist.github.com/ebadedude/3823092.js"></script>


