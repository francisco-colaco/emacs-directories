# User directories for Emacs

user-directories contains functions to locate user Emacs files,
inspired by the XDG Base Directory Specification.

## Purpose

There are different domains for the emacs-related files, as they are
broken into configuration, data, cache and runtime.  We advise the
users of this package to look at the aforementioned specification to
learn the different purposes of the domains and the files that should
be kept in each one.

## `locate-`

The `locate-*` functions are to be used mainly by package writers.
Using them, user Emacs configuration, data and cache files can be
segregated into their own directories, making it simple to migrate
configurations among several machines --- since the files that are
unnecessary, being cache or runtime files, could easily not be
incorporated into the roll of backup or transmission.

The most important function for end users is `locate-user-file`,
which locates a file in a domain.  For instance, on my Linux
system, in portuguese:

## Examples

```emacs-lisp
(locate-user-file :config "init.el") => "/home/fhc/.config/emacs/a-file.txt"

(locate-user-file :cache "a-file.txt") => "/home/fhc/.cache/emacs/a-file.txt"

(locate-user-file :documents "org/agenda.org") => "/home/fhc/Documentos/org/agenda.org"

(locate-user-file :downloads "a-file.txt") => "/home/fhc/Transferências/a-file.txt"
```

## Available file domains

The domains that are available depend on the operating system.

In Linux, we have the following defined: :config, :data, :cache,
:runtime, :documents :pictures, :music, :videos, :downloads,
:public and :templates

In MS Windows, as far as this version, only the following domains
are defined: :config, :data, :cache, :runtime, :documents,
:pictures, :music and :videos

In darwin (MacOS and OSX), no domains are defined at this point.

In other OS, the domains defined are :config, :data, :cache,
:runtime, :documents and :downloads

# Licence

This package is released under the GNU General Public License,
version 3.0 or above.  One may read or obtain a copy of the the GNU
General Public License at the GNU Web site, at http://www.gnu.org.

# Todo

Still to do:

  + OSX directory finding code.

  + MS Windows directory finding code (a seemingly skeleton is there).

  + Code for other systems, not necessarily Linux.

  + Should the directories plist be private and closed over asthey are?

All help is humbly accepted.
