# c-Logo-s

```
                  /
          \     _________________
    ___    \   /       ___       \    ___
   /   \   /\ |     | /   \ |     |  /   \
  |       /  \ \___/ |     | \___/  |
   \_____/    \_______\___/          \___
                       \__               \
                       /  \            __/
                      |    |
                       \__/
```

The Common Logo Setup c-Logo-s
==============================
 
Version 0.0.1 - (This text will be replaced as soon as there is a
significant progress in the background work to publish Version
0.1.0. At the moment, this serves as an explanation, why simply the
skeleton is already published.) 
 
This is the plan:
 
The Common Logo Setup shall become the core of the Common Logo Setup
*Suite* which provides the behaviour of the Logo programming language
on top of Common Lisp. The main reference is Brian Harveys Berkeley
Logo (UCBLogo) 6.2 manual (2022) including the experimental
prototype-based object system inspired by Paradigm Software's Object Logo (1991). 

A further point of reference is the Atari Logo manual from Logo Computer Systems, Inc. (1983).
 
The goal is to make it possible to reproduce all examples of the following textbook at most without compromises:

* Brian Harvey (1984/1997): Computer Science Logo Style vol. 1-3

In combination with the turtle extension also the examples in the following (text-)books shall be fully reproducable:

* Seymour Papert (1980): Mindstorms.
* Harold Abelson, Andrea diSessa (1980): Turtle Geometry.
* Cynthia Solomon, Margaret Minsky, Brian Harvey (ed.) (1986): LogoWorks. Challenging Programs in Logo
* Jim Muller (1997): The Great Logo Adventure.

The project name indicates the ancient greek heritage of the name
"Logo" for a Lisp-derived language which was at first hand specialized
on computer linguistic operations: Λόγος (Lógos), mainly in the sense
of "word". But all the philosophical and linguistic implications of
the term are also useful in this context. Therefore the setup provides
everything which is possible without the turtle (textual, symbolic
programming without graphical output but with sound generation). 
 
The *setup* is an extension of the Common Lisp language which
"pretends" to be Logo. And it is aimed at allowing for reproducing the
most important, beautiful and timeless books about Logo programming
(in my humbly opinion) starting from the quasi standard Berkeley
Logo. Thus, it is not only "Common Lisp Logo" but also "Common Logo"
which basically is also a Lisp. That is why I decided to merge the two
"Ls" and ended up with clogos resp. c-logo-s instead of cl-logos. 

I am far from being a professional programmer. Instead I am about to
become a primary school teacher. Before that I worked as a case
officer in a Social Welfare Office after my legal studies and
sometimes part-time as a lecturer for social and aliens law and legal
theory. I also worked for the legal protection company of the German
Trade Union Federation during my studies.  Before that I worked as a
trained bookseller, a works council member and a unionist. Quite
mixed up. Yet through all these years, since my father bought a CPC
464 for his own work in 1984, I never could detach myself from
somehow playing around with programming and programming languages -
as a kid not knowing what to program with clumsy Turbo Pascal
(unfortunately I didn't know anything about Digital Research's
Dr. Logo), as an enthusiast delving into Linux, as a merchant, as a
legal scholar and as a teacher.
 
I hope, regarding my source code my attempt at designing a complex
Logo learning environment is not a total style crime like my work
life. But of course: I won't find the most efficient solutions nor 
the least verbose. Thus, the implementation will stay
optimisable for a very long time. My major goal is to bring something
to life, being mostly usable. (Because I want to use it
multidisciplinary at my work with my primary school children.)
And I try to document the code responsibly, so the processes of
optimisation might not become to painful. 

## Usage

## Installation
