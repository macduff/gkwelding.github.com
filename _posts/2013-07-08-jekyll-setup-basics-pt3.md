---
comments: true
date: 2013-07-08 15:00:00
layout: post
slug: jekyll-setup-vps

title: Jekyll Setup VPS
summary: "Jekyll Setup Part III: Virtual Private Server"
image: 'how-to-jekyll/wp_github_jekyll.png'
tags:
- jekyll 
- blog
- server
---

## Motivation:

If we're already using Jekyll, then why should we even go to the trouble
of hosting it ourselves? I mean, we could just get it hosted for **free** on
Github.  That's pretty crazy simple, follow the [simple instructions](http://github.com/thoseinstructions) and boom, you're blog is up!  You can even pay a
paltry sum and get it to resolve you custom domain and then get private
github repos to boot!

This is a pretty sweet deal, however, since github is being so incredibly
generous with their server space, they do require something in exchange.  You
can't really use any of the Jekyll Ruby plugins due to security concerns.  The
only way to add functionality is through the Liquid templating language, which
can be pretty tricky.  Since I'm more interested in functionality, like tags,
categories, sitemap generation, etc. I'm quite motivated to setup the blog to
run on my own virtual private server.

## Server Prerequisites

To host a Jekyll blog is a little tricky, but all things considered, it's
pretty easy.  I'm going to assume that the interested reader is running
something like Ubuntu 12.04 LTS or later with Apache up and rolling.

### Git

Git installation is pretty much a piece of cake.

    sudo apt-get install git git-base git-core git-svn gitk git-gui

That should pretty much get `git` on your system, no problems.  What we'd really
like is to have an automated method of deploying our content online.
Fortunately for us, this can easily be accomplished using a simple recieve hook
that is part of the git repo that we will soon create.  There are other methods
to accomplish this task, but I'll outline the one that I found conceptually
the simplest to implement.


#### Setup A Deployment Account

We'll setup an account that will be used only for the sole purpose of updating
our git repo on our server.  This technique can be used to host many different
repos on the same server, and in theory, could allow many users to push and
pull changes to the repo.  Since it's using the same user account, some might
be hesitant, but have no fear, it's likely that you'll be the only one that
needs to update your *personal* blog, right?  :-)

We'll give our user the name of `deployer` to be consistent with some of the
other documentation for Jekyll, but feel free to change the name to whatever
you choose.

    sudo groupadd git-data
    sudo useradd -g git-data deployer

This should create a new user account with the initial login group of
`git-data`.  It will also ask for a password, be sure to choose a strong
password and one you'll remember.  I tend to think the intersection of the
set of strong passwords and ones you'll remember are equivalent to the empty
set, so I would recommend looking into password software like
[password safe](http://passwordsafe.com) or [KeePass](http://keepass.com).

Now, let's create a location where our git repos will be stored.  I've run
across recommendations to place it in `/opt/git/`, after looking into this
option I've decided I like it!

    # create the directory
    sudo mkdir -p /opt/git
    # make it so that the directory and all subdirectories
    # will be part of the git-data group
    sudo chgrp git-data /opt/git/
    sudo chmod g+s /opt/git/

### Ruby

As we discussed on a [earlier post](http://post), Ruby should not be installed
using `apt-get` as the debian package is painfully old and just causes a lot
of problems.  Before, we installed Ruby on our development machine in our `home`
directory.  This is not such a good plan when hosted on a server where
different accounts need access to the same Ruby and gem set.  So, we'll have to
go after a different plan of attack.


### Let's test

mark it down

Git post-update hook
====================

If you store your jekyll site in Git (you are using version control, right?), it’s pretty easy to automate the deployment process by setting up a post-update hook in your Git repository, like this.
Git post-receive hook

To have a remote server handle the deploy for you every time you push changes using Git, you can create a user account which has all the public keys that are authorized to deploy in its authorized_keys file. With that in place, setting up the post-receive hook is done as follows:

    laptop$ ssh deployer@myserver.com
    server$ mkdir myrepo.git
    server$ cd myrepo.git
    server$ git --bare init
    server$ cp hooks/post-receive.sample hooks/post-receive
    server$ mkdir /var/www/myrepo

Next, add the following lines to hooks/post-receive and be sure Jekyll is installed on the server:

    GIT_REPO=$HOME/myrepo.git
    TMP_GIT_CLONE=$HOME/tmp/myrepo
    PUBLIC_WWW=/var/www/myrepo

    git clone $GIT_REPO $TMP_GIT_CLONE
    jekyll build -s $TMP_GIT_CLONE -d $PUBLIC_WWW
    rm -Rf $TMP_GIT_CLONE
    exit

Finally, run the following command on any users laptop that needs to be able to deploy using this hook:

    laptops$ git remote add deploy deployer@myserver.com:~/myrepo.git

Git Server Setup
================

4.4 Git on the Server - Setting Up the Server
---------------------------------------------

### Setting Up the Server

Let’s walk through setting up SSH access on the server side. In this example, you’ll use the authorized_keys method for authenticating your users. We also assume you’re running a standard Linux distribution like Ubuntu. First, you create a 'git' user and a .ssh directory for that user.

$ sudo adduser git
$ su git
$ cd
$ mkdir .ssh

Next, you need to add some developer SSH public keys to the authorized_keys file for that user. Let’s assume you’ve received a few keys by e-mail and saved them to temporary files. Again, the public keys look something like this:

$ cat /tmp/id_rsa.john.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
dAv8JggJICUvax2T9va5 gsg-keypair

You just append them to your authorized_keys file:

$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Now, you can set up an empty repository for them by running git init with the --bare option, which initializes the repository without a working directory:

$ cd /opt/git
$ mkdir project.git
$ cd project.git
$ git --bare init

Then, John, Josie, or Jessica can push the first version of their project into that repository by adding it as a remote and pushing up a branch. Note that someone must shell onto the machine and create a bare repository every time you want to add a project. Let’s use gitserver as the hostname of the server on which you’ve set up your 'git' user and repository. If you’re running it internally, and you set up DNS for gitserver to point to that server, then you can use the commands pretty much as is:

# on Johns computer
$ cd myproject
$ git init
$ git add .
$ git commit -m 'initial commit'
$ git remote add origin git@gitserver:/opt/git/project.git
$ git push origin master

At this point, the others can clone it down and push changes back up just as easily:

$ git clone git@gitserver:/opt/git/project.git
$ cd project
$ vim README
$ git commit -am 'fix for the README file'
$ git push origin master

With this method, you can quickly get a read/write Git server up and running for a handful of developers.

As an extra precaution, you can easily restrict the 'git' user to only doing Git activities with a limited shell tool called git-shell that comes with Git. If you set this as your 'git' user’s login shell, then the 'git' user can’t have normal shell access to your server. To use this, specify git-shell instead of bash or csh for your user’s login shell. To do so, you’ll likely have to edit your /etc/passwd file:

$ sudo vim /etc/passwd

At the bottom, you should find a line that looks something like this:

git:x:1000:1000::/home/git:/bin/sh

Change /bin/sh to /usr/bin/git-shell (or run which git-shell to see where it’s installed). The line should look something like this:

git:x:1000:1000::/home/git:/usr/bin/git-shell

Now, the 'git' user can only use the SSH connection to push and pull Git repositories and can’t shell onto the machine. If you try, you’ll see a login rejection like this:

$ ssh git@gitserver
fatal: What do you think I am? A shell?
Connection to gitserver closed.
