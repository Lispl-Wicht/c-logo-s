*Under development*

# Contributing Guideline

Welcome, and thank you for considering contributing to the cLogos project.

This project is a work in progress and is currently at a very early stage 
of development. It is also a learning-by-doing process.

Contribution itself is therefore part of this learning process. The content 
of this document will evolve continuously as the project will and the community 
may grow.

## Table of Contents

- [Introduction](#introduction)
- [Setting up the environment](#setting-up-the-environment)
- [Testing](#testing)
- [Pull Requests (PR)](#pull-requests-pr)
  - [What is a Pull Request?](#what-is-a-pull-request)
  - [Offering a contribution for consideration](#offering-a-contribution-for-consideration)

## Introduction

cLogos aims to become a mature educational programming environment based on the 
programming language [Logo](https://el.media.mit.edu/logo-foundation/what_is_logo/logo_programming.html) 
and implemented in [Common Lisp](https://common-lisp.net/).

Contributing to the project therefore involves learning and exploring several things at once: programming 
in Common Lisp as the host language, using its dedicated development environment, and learning Logo through 
the process of implementing it.

The goal is to develop a deeper understanding of both Lisp and Logo, and through this understanding to 
improve our ability to design learning environments in which these languages can become epistemic tools — 
tools for thinking, exploring, and discovering — across school subjects such as mathematics, English, 
German, French, and general studies or science education.

The exchange of ideas about both languages, the cLogos implementation of Logo, and the collaborative development 
of the surrounding environment are therefore considered an essential part of the learning process itself.

Educators from all levels (kindergarten, primary school, secondary school, and higher education), from all 
disciplines, and with any level of programming experience are especially invited to participate.

Over time, documentation and learning materials will be provided to support individual experimentation with the 
environment. Once participation becomes a personal interest or need, contributions are warmly welcomed — always 
within the framework of the [Code of Conduct](CODE_OF_CONDUCT.md), which is dedicated to kind, respectful, and 
fault-tolerant cooperation.

**The Code of Conduct is inspired by the following principles:**
- Act only according to those principles that you can at the same time wish to become universally binding laws.
- Treat every person as a person and respect them accordingly.
- Always assume that others are trying to make a meaningful or truthful contribution.

**More concretely:**
- Be self-reflective.
- Accept that you, like everyone else, will make mistakes.
- See both your own and others’ mistakes as opportunities for learning.
- Be patient and kind.
- If something upsets you, step away from the keyboard for a while and consider a benevolent interpretation before responding.
- Remember that written communication lacks many non-verbal aspects; therefore, kindness and respect should always take priority
  over a form of honesty that is experienced as hurtful. Politeness serves as an intermediate layer that preserves kindness when 
  kindness itself cannot immediately be felt or expressed.
- Every person deserves equal respect. No accidental attribute, such as gender, heritage, or any other characteristic, diminishes
  a person’s worth or grants communicative privilege.
- Knowledge is a gift to share, not a pedestal to stand on.
- To err is human; forgiving is as well. 

The following sections describe the current understanding of how contribution to cLogos is envisioned.

## Setting up the environment

These sections of the project's [README file](README.md) briefly inform about the details of setting up the environment:
- [Prerequisites](https://github.com/Lispl-Wicht/c-logo-s#prerequisites)
- [Configuring the IDE](https://github.com/Lispl-Wicht/c-logo-s#getting-started-quickly)
- [Installing and loading cLogos](https://github.com/Lispl-Wicht/c-logo-s#installing-and-loading-clogos)

A comprehensive but friendly documentation in pdf form is also under development, that introduces the use of 
[Emacs](https://www.gnu.org/software/emacs/) as obvious Common Lisp [IDE](https://github.com/resources/articles/what-is-an-ide), 
the use of Common Lisp as the host language, and the implementation of Logo as target language. 

That documentation is at first written **in German**, aiming at German teachers without a programming background 
in order to lower the barrier to participate in the project, and to introduce a pedagogically compatible 
**German** terminology. 

The documentation will be translated to English when it is finished. However, the documentation project is suspended 
until the first version of cLogos is completed. The status *complete* is reached when cLogos is sufficient to use the 
[specification of cLogos](https://github.com/Lispl-Wicht/c-logo-s#design-commitments):
> Brian Harvey (1985/1997), [Computer Science Logo Style Vol. 1-3](https://people.eecs.berkeley.edu/~bh/v1-toc2.html)

The parts of the finished documentation that friendly introduce the set-up of the development environment will later 
be referenced here, and a short version will replace this text.

## Setting up the Environment

The following sections of the project's [README file](README.md) provide a brief overview of how to set up the 
development environment:

- [Prerequisites](https://github.com/Lispl-Wicht/c-logo-s#prerequisites)
- [Configuring the IDE](https://github.com/Lispl-Wicht/c-logo-s#getting-started-quickly)
- [Installing and loading cLogos](https://github.com/Lispl-Wicht/c-logo-s#installing-and-loading-clogos)

A comprehensive but approachable documentation in PDF form is also under development. It introduces the use 
of [Emacs](https://www.gnu.org/software/emacs/) as the development environment for Common Lisp, the use of 
Common Lisp as the host language, and the implementation of Logo as the target language.

The documentation is initially being written **in German**. Its primary audience is German teachers without 
a programming background, with the aim of lowering the barrier to participation and establishing pedagogically 
appropriate **German** terminology.

Once completed, the documentation will be translated into English. However, work on this documentation is currently 
suspended until the first usable version of cLogos has been reached.

For this purpose, the first version is considered usable when cLogos is sufficiently mature to implement the primary
[specification of cLogos](https://github.com/Lispl-Wicht/c-logo-s#design-commitments):

> Brian Harvey (1985/1997), [Computer Science Logo Style Vol. 1–3](https://people.eecs.berkeley.edu/~bh/v1-toc2.html)

Once the documentation is completed, the sections providing a friendly introduction to setting up the development 
environment will be referenced here. A shorter version of this section will then replace the current text.

## Testing

The cLogos project follows the directory structure generated by [Fukamachi](https://github.com/fukamachi)'s [cl-project](https://github.com/fukamachi/cl-project) template:

```text
c-logo-s
|
|-- src
|-- tests
```

Project tests will eventually reside in the dedicated `tests` directory.

At the current stage of development, this directory is still empty. Once a testing framework has been selected 
and integrated, this section will describe how to run the project's test suite and how to write new tests.

Until then, the primary form of validation is exploration. More generally, understanding the current behaviour 
of the available components through exploration is itself an important contribution. At present, the current 
development target is the reader. Instructions for exploring its behaviour are available in the 
section [Current Focus: The Reader and Parser Pipeline](https://github.com/Lispl-Wicht/c-logo-s#current-focus-the-reader-and-parser-pipeline). 

## Pull Requests (PR)

### What is a Pull Request?

Before discussing which PR etiquette this project follows, it is helpful to understand what a Pull Request actually is.

(If you already know this, you may skip this subsection.)

A Pull Request starts with [*forking*](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository) a [repository (repo)](https://github.blog/developer-skills/github/beginners-guide-to-github-repositories-how-to-create-your-first-repo/#what-is-a-repository).

**Forking means creating your own GitHub copy of a repository.**

If you like cLogos and simply want to try it out, you can make your own local copy of the cLogos repository on your computer 
by [**cloning**](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).

You can experiment with this local copy and make any changes you like **on your own computer**. However, you cannot push
these changes directly to the cLogos repository because you do not own that repository and therefore do not have write privileges.

If you want to contribute changes to cLogos, you first create **your own copy of the repository on GitHub** by **forking** it. Since this
fork belongs to you, you may modify it, create branches, and push your changes there.

**A Pull Request is then literally a request:**

> "Please compare my GitHub branch with your branch and consider merging my changes into your project."

GitHub provides the interface for comparing the branches, discussing the proposed changes, reviewing the code, and completing the merge process.

#### Making changes in your repository

Three central [Git](https://git-scm.com/) operations are crucial when working with a local repository and its remote repositories:
- [**commit**](https://github.com/git-guides/git-commit) = create a historical checkpoint in your local repository
- [**push**](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository) = send your commits to a remote repository
  (for example, a repository hosted on GitHub)
- [**pull**](https://github.com/git-guides/git-pull) = bring commits from a remote repository into your local repository

Therefore, you can always *commit* your changes to your local repository. This is the core feature of the version control system Git: 
it allows you to recover previous versions and trace the course of development.

You can only *push* these commits to a remote repository where you have write access.

You can *pull* changes from a remote repository into your own. Conversely, you can **request** another repository owner to incorporate 
changes from your repository through a Pull Request.

### Offering a contribution for consideration

A Pull Request is not only a technical mechanism for transferring changes between repositories. It is also a way of communicating with 
the maintainers and contributors of a project:

> "I have developed something that I believe may be valuable for this project. Would you like to consider incorporating it?"

The purpose of a Pull Request is therefore not to demand that changes are accepted, but to make a contribution visible, 
understandable, and discussable.

In this spirit, the following PR etiquette is currently envisioned:
