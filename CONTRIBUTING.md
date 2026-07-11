*Under development*

# Contribution Guidelines

Welcome, and thank you for considering contributing to the cLogos project.

This project is a work in progress and is currently at a very early stage 
of development. It is also a learning-by-doing process.

Contribution itself is therefore part of this learning process. The content 
of this document will evolve continuously as the project will and the community 
may grow.

## Table of Contents

- [Introduction](#introduction)
- [Different forms of contribution](#different-forms-of-contribution)
- [Relationship between the Charter and Contribution Guidelines](#relationship-between-the-charter-and-contribution-guidelines)
- [Setting up the environment](#setting-up-the-environment)
- [Testing](#testing)
- [Pull Requests (PR)](#pull-requests-pr)
  - [What is a Pull Request?](#what-is-a-pull-request)
  - [Offering a contribution for consideration](#offering-a-contribution-for-consideration)
- [The project's learning workflow](#the-projects-learning-workflow)
  - [Starting a discussion](#starting-a-discussion)
  - [Filing an Issue](#filing-an-issue)
  - [Assuming responsibility](#assuming-responsibility)

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

---

These guidelines intentionally explain not only what contributors are asked to do, but also why. Since 
cLogos is itself an educational project, its contribution process is intended to be part of the learning experience.

---

## Different forms of contribution

Contribution to cLogos can take different forms, depending on one's interests, background, and relationship with the project.

During the development and maintenance of cLogos, contributions are primarily concerned with building, improving, enriching and 
preserving the software itself. These contributions are coordinated through GitHub and may include programming, 
documentation, design discussions, issue reports, and [Pull Requests](#what-is-a-pull-request). Contributing to cLogos does not 
mean owning or directing the project. It means participating in **the stewardship** of an educational language environment.

Once a first usable version of cLogos is available as a self-contained executable program, another important form of contribution 
will begin: using and exploring cLogos as an educational environment. This includes experimenting with Logo 
based on [Brian Harvey's](https://people.eecs.berkeley.edu/~bh/) textbooks, reporting experiences, identifying problems, and suggesting 
improvements from an educational perspective. **Explorers** discover what they *can think with* cLogos and what may disturb their
thinking.

These forms of contribution are closely connected but intentionally separated. Software development contributions are managed through 
GitHub, while contributions related to the educational use of cLogos will be supported through a dedicated cLogos website.

## Relationship between the Charter and Contribution Guidelines

The [cLogos Charter](https://github.com/Lispl-Wicht/c-logo-s/blob/development/conceptual-work/clogos-charter.markdown) defines 
the identity, principles, and boundaries of the project. It answers the questions:
> What are we stewarding? What must remain recognisable? What may grow?

These Contribution Guidelines define how the community can participate in developing and maintaining that identity.  
It answers the question:
> How do we steward it together? How do we responsibly care for the educational language environment entrusted to us,
> so that the project continues to serve the educational idea.

Both documents serve the same purpose: enabling cLogos to evolve while preserving the principles that make it cLogos. 
> Stewardship of cLogos begins by listening closely to the language: before changing the system, observe it. Ask it questions.
> Explore what it reveals. Then act.

The Charter protects the integrity of the language and its pedagogical foundations. The Contribution Guidelines protect 
the integrity of the collaborative process through which the project evolves.

Both outline the garden of cLogos, metaphorically, which is nurtured, cultivated, and guarded by the stewards as the 
gardeners. Contributors may assume different roles in this garden so they can be stewards or explorers or, quite often, both.
Stewardship itself may be exercised from different perspectives: programming, research, and pedagogy. The dialogue between 
these roles is grounded by the Charter and coordinated by the Guidelines to center the diverse interests.

Together they form the constitutional framework of cLogos: one protecting the identity of the language, the other protecting 
the integrity of its collaborative evolution.

## Setting up the Environment

The following sections of the project's [README file](README.md) provide a brief overview of how to set up the development environment:

* [Prerequisites](https://github.com/Lispl-Wicht/c-logo-s#prerequisites)
* [Configuring the IDE](https://github.com/Lispl-Wicht/c-logo-s#getting-started-quickly)
* [Installing and loading cLogos](https://github.com/Lispl-Wicht/c-logo-s#installing-and-loading-clogos)

A comprehensive but approachable documentation in PDF form is also under development. It introduces the use of [Emacs](https://www.gnu.org/software/emacs/) 
as the development environment for Common Lisp, the use of Common Lisp as the host language, and the implementation of Logo as the target language.

The documentation is initially being written **in German**. Its primary audience is German teachers without a programming background, with the aim of lowering 
the barrier to participation and establishing pedagogically appropriate **German** terminology.

Once completed, the documentation will be translated into English. However, work on this documentation is currently suspended until the first usable version 
of cLogos has been reached.

For this purpose, the first version is considered usable when cLogos is sufficiently mature to implement 
the [specification of cLogos](https://github.com/Lispl-Wicht/c-logo-s#design-commitments):

> Brian Harvey (1985/1997), [Computer Science Logo Style Vol. 1–3](https://people.eecs.berkeley.edu/~bh/v1-toc2.html)

Once the documentation is completed, the sections providing a friendly introduction to setting up the development environment will be referenced here. 
A shorter version of this section will then replace the current text.

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

**Forking means creating your own GitHub copy of a repository.** Throughout these guidelines we occasionally compare 
such a fork to a cutting in a garden: it allows new ideas to grow without disturbing the original tree.

If you like cLogos and simply want to try it out, you can make your own local copy, your cutting of the cLogos repository on 
your computer by [**cloning**](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).

You can experiment with this cutting and make any changes you like **on your own computer**. However, you cannot push
these changes directly to the cLogos repository because you do not own that repository and therefore do not have write privileges. 
You are not the steward of the original tree.

If you want to contribute changes to cLogos, you first create **your own copy of the repository on GitHub** by **forking** it. Since this
fork belongs to you, you may modify it, create branches, and push your changes there. Forks are also the natural place to experiment
with [possible extensions of cLogos](https://github.com/Lispl-Wicht/c-logo-s/blob/development/conceptual-work/clogos-charter.markdown#7-extension-disciplin) 
that may potentially change its behaviour.

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

In this spirit, the following PR etiquette is currently envisioned.

As a learning-oriented project, every contribution becomes part of the ongoing discourse about the development and maintenance 
of the language and its environment providing new answers to the core question: How can cLogos become more cLogos? 
Every contribution has the potential to deepen our shared understanding of the language, the environment, and the educational 
ideas they embody.

A Pull Request proposes a change to the project's implementation. Such proposals should therefore be introduced transparently, 
making both their intention and their possible consequences understandable. So the primary purpose of a Pull Request in cLogos
is not merely to propose a modification of the source, but to make the reasoning behind that modification available for 
discussion.

#### Explain the intention behind your contribution.

A Pull Request should explain what problem it addresses or what improvement it proposes. Understanding the intention 
behind a contribution is often more important than understanding the implementation itself.

#### Make your reasoning visible.

Describe the considerations that led to your solution. This allows others to understand not only *what* was changed, 
but also *why* it was changed, making meaningful discussion and future maintenance much easier.

#### Keep your changes focused enough to discuss.

A Pull Request should preferably address one coherent topic. Smaller, well-focused contributions are easier to review, 
discuss, understand, and, if appropriate, integrate into the project.

#### Be open to feedback.

A Pull Request is an invitation to *discussion*, not merely a proposal for integration. Questions, suggestions, and 
alternative ideas are part of the collaborative learning process and should be welcomed as opportunities to improve 
both the project and our shared understanding.

#### Treat review as collaboration, not judgment.

The purpose of reviewing a Pull Request is to improve the project together. Feedback is directed at the proposed 
contribution, never at the person who made it. Likewise, comments should be understood as contributions to the 
discussion rather than as personal criticism.

---

Every Pull Request will be reviewed with the following possible outcomes. A closed Pull Request does not necessarily represent 
a failed contribution. Depending on the discussion, it may be:

- accepted as-is,
- accepted after revision,
- discussed and redesigned,
- postponed,
- not integrated into cLogos, while still contributing valuable ideas or insights.

A well-explained contribution remains part of the project's collective learning, even when it is not ultimately integrated 
into the implementation.

---

## The project's learning workflow

```
Question   (Wonder)
        │
        ▼
Discussion (Discuss)      
        │
        ▼
Shared understanding (Decide)
        │
        ▼
Issue        
        │
(assume responsibility)
        ▼
Fork / Branch
        │
implementation  (Create)
        ▼
Pull Request
        │
review       (Reflect)
        ▼
Merge        (Integrate)
```

Wonder
    ↓
Discuss
    ↓
Decide
    ↓
Take responsibility
    ↓
Create
    ↓
Reflect
    ↓
Integrate

### Starting a Discussion

### Filing an Issue

### Assuming Responsibility
