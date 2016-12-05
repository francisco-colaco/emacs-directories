;;; user-directories.el --- Emacs startup and package directories  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Francisco Miguel Colaço

;; This file is not part of GNU Emacs.

;; Author: Francisco Miguel Colaço <francisco.colaco@gmail.com>
;; Version: 0.1
;; Maintainer: Francisco Miguel Colaço <francisco.colaco@gmail.com>
;; Keywords: internal, wp, files

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; user-directories contains functions to locate user Emacs files,
;; inspired by the XDG Base Directory Specification.
;;
;; There are different domains for the emacs-related files, as they
;; are broken into configuration, data, cache and runtime.  We advise
;; the users of this package to look at the aforementioned
;; specification to learn the different purposes of the domains and
;; the files that should be kept in each one.
;;
;; The locate-* functions are to be used mainly by package writers.
;; Using them, user Emacs configuration, data and cache files can be
;; segregated into their own directories, making it simple to migrate
;; configurations among several machines --- since the files that are
;; unnecessary, being cache or runtime files, could easily not be
;; incorporated into the roll of backup or transmission.
;;
;; The most important function for end users is `locate-user-file',
;; which locates a file in a domain.  For instance, on my Linux
;; system, in portuguese:
;;
;; > (locate-user-file :config "init.el")
;;   "/home/fhc/.config/emacs/a-file.txt"
;; > (locate-user-file :cache "a-file.txt")
;;   "/home/fhc/.cache/emacs/a-file.txt"
;; > (locate-user-file :documents "org/agenda.org")
;;   "/home/fhc/Documentos/org/agenda.org"
;; > (locate-user-file :downloads "a-file.txt")
;;   "/home/fhc/Transferências/a-file.txt"
;;
;; The domains that are available depend on the operating system.
;;
;; In Linux, we have the following defined: :config, :data, :cache,
;; :runtime, :documents :pictures, :music, :videos, :downloads,
;; :public and :templates
;;
;; In MS Windows, as far as this version, only the following domains
;; are defined: :config, :data, :cache, :runtime, :documents,
;; :pictures, :music and :videos
;;
;; In darwin (MacOS and OSX), no domains are defined at this point.
;;
;; In other OS, the domains defined are :config, :data, :cache,
;; :runtime, :documents and :downloads
;;
;; This package is released under the GNU General Public License,
;; version 3.0 or above.  One may read or obtain a copy of the the GNU
;; General Public License at the GNU Web site, at http://www.gnu.org.
;;
;; Still to do:
;;
;;   + OSX directory finding code.
;;   + MS Windows directory finding code (a seemingly skeleton is there).
;;   + Code for other systems, not necessarily Linux.
;;   + Should the directories plist be private and closed over asthey are?
;;
;; All help is humbly accepted.

;;; Code:

(eval-when-compile
  (require 'cl)
  (require 'subr-x))


(defgroup user-directories
    ()
  "Emacs User Startup Directories

Defines the directories that Emacs uses during execution to store
configuration, data, cache and runtimes files.  Additionally,
locates user files in specific file domains."
  :group 'internal)


(defcustom user-emacs-config-directory
  nil
  "Directory to store configuration files.

In this directory, configuration files for Emacs and it's various
packages are stored.  This directory should not contain
machine-generated session files."
  :group 'emacs-directories
  :type 'directory)


(defcustom user-emacs-data-directory
  nil
  "Directory to store data files.

In this directory, data files for Emacs and it's packages are
located.  This directory should contain Emacs state and session
files."
  :group 'emacs-directories
  :type 'directory)


(defcustom user-emacs-cache-directory
  nil
  "Directory to store cache files.

In this directory, cache files for Emacs and it's packages are
stored.  This directory should contain only files whose deletion
will mean no loss of information."
  :group 'emacs-directories
  :type 'directory)


(defcustom user-emacs-runtime-directory
  nil
  "Directory to store runtime files.

In this directory, runtime files for Emacs and it's packages are
located, like socket files or credentials.  These files can be
erased when Emacs exits or when the user logs out."
  :group 'emacs-directories
  :type 'directory)


(defcustom user-documents-directory
  nil
  "Directory where the user stores documents."
  :group 'emacs-directories
  :type 'directory)


(defmacro udirs-locate-file (directory name)
  "Return an absolute file in DIRECTORY named NAME.

If the directory of the file does not exist, it is created.  The
name of the file is returned regardless of it's existence."
  `(let* ((file (expand-file-name ,name ,directory))
          (dir (file-name-directory file)))
     (unless (file-exists-p dir)
       (make-directory dir t))
    file))


;;;###autoload
(defun locate-user-emacs-config-file (name)
  "Return an absolute per user Emacs-specific configuration file name.

Return NAME in ‘user-emacs-config-directory’, regardless of
the existence of a file with that name.  Creates all the parent
directories of the file."
  (udirs-locate-file user-emacs-config-directory name))


;;;###autoload
(defun locate-user-emacs-data-file (name)
  "Return an absolute per user Emacs-specific data file name.

Return NAME in ‘user-emacs-data-directory’, regardless of
the existence of a file with that name.  Creates all the parent
directories of the file."
  (udirs-locate-file user-emacs-data-directory name))


;;;###autoload
(defun locate-user-emacs-cache-file (name)
  "Return an absolute per user Emacs-specific cache file name.

Return NAME in ‘user-emacs-cache-directory’, regardless of
the existence of a file with that name.  Creates all the parent
directories of the file."
  (udirs-locate-file user-emacs-cache-directory name))


;;;###autoload
(defun locate-user-emacs-runtime-file (name)
  "Return an absolute per user Emacs-specific runtime file name.

Return NAME in ‘user-emacs-runtime-directory’, regardless of
the existence of a file with that name.  Creates all the parent
directories of the file."
  (udirs-locate-file user-emacs-runtime-directory name))


;;;###autoload
(defun locate-user-document-file (name)
  "Return an absolute per user document file name.

Return NAME in the ‘user-documents-directory’, regardless of
the existence of a file with that name.  Creates all the parent
directories of the file."
  (udirs-locate-file user-documents-directory name))


(when (eq system-type 'gnu/linux)
  (defun xdg-find-user-dir (domain fallback)
    (if (locate-file "xdg-user-dir" exec-path)
        (substring (shell-command-to-string (concat "xdg-user-dir " domain)) 0 -1)
        (expand-file-name fallback))))


(when (eq system-type 'windows-nt)
  (defun windows-read-registry-value (key value)
    "From a registry KEY, reads VALUE, when on MS Windows."
    (let ((command (concat "REG QUERY \"" key "\" /V \"" value "\""))
	  result tokens last-token)
      (setq result (shell-command-to-string command)
	    tokens (split-string result nil t)
	    last-token (nth (1- (length tokens)) tokens))
      (and (not (string= last-token "value.")) last-token)))

  (defun windows-shell-folder (folder)
    "Returns a user shell folder.

 FOLDER is a string describing the folder purpose, like \"My Documents\"."
    (let ((result (windows-read-registry-value "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders" folder)))
      (substring (shell-command-to-string (concat "echo " result)) 0 -1))))


(when (eq system-type 'darwin)
  ;; Define nothing for now.  I am clueless on MacOS.
  )


;; This should be a private function, runned once when the package is
;; loaded to initialise the directories with proper values, according
;; to the operating system (and locale).  In Linux it user
;; xdg-user-dir where available, in Windows environment variables and
;; still lacks OSX.  On other operating systems, it gets default
;; values.
;;
;; The case to make this a function, instead of a simple code block,
;; is that the user may wish to run the function again to regenerate
;; the directory names.
;;
(defun udirs-find-user-emacs-directories ()
  "Set the user Emacs directories."
  (let ((dirs
          (case system-type
            (gnu/linux
             (let ((config-dir (or (getenv "XDG_CONFIG_HOME") (expand-file-name "~/.config")))
                   (data-dir (or (getenv "XDG_DATA_HOME") (expand-file-name "~/.local/share")))
                   (cache-dir (or (getenv "XDG_CACHE_HOME") (expand-file-name "~/.cache")))
                   (runtime-dir (or (getenv "XDG_RUNTIME_DIR") (expand-file-name "~/.runtime"))))
               (list :config    (expand-file-name "emacs" config-dir)
                     :data      (expand-file-name "emacs" data-dir)
                     :cache     (expand-file-name "emacs" cache-dir)
                     :runtime   (expand-file-name "emacs" runtime-dir)
                     :documents (xdg-find-user-dir "DOCUMENTS" "~/Documents")
                     :pictures  (xdg-find-user-dir "PICTURES" "~/Images")
                     :music     (xdg-find-user-dir "MUSIC" "~/Music")
                     :videos    (xdg-find-user-dir "VIDEOS" "~/Videos")
                     :downloads (xdg-find-user-dir "DOWNLOAD" "~/Downloads")
                     :public    (xdg-find-user-dir "PUBLICSHARE" "~/Public")
                     :templates (xdg-find-user-dir "PUBLICSHARE" "~/Templates"))))
            (windows-nt
             ;; CAVEAT EMPTOR: this code was not fully tested and
             ;; probably is based on erroneous assumptions.
             (let ((appdata (getenv "APPDATA"))
                   (local-appdata (getenv "LOCALAPPDATA"))
                   (temp (getenv "TEMP")))
               (list :config    (expand-file-name "emacs/config" appdata)
                     :data      (expand-file-name "emacs/data" local-appdata)
                     :cache     (expand-file-name "emacs/cache" local-appdata)
                     :runtime   (expand-file-name "emacs/runtime" temp)
                     :documents (windows-shell-folder "Personal")
                     :pictures  (windows-shell-folder "My Pictures")
                     :music     (windows-shell-folder "My Music")
                     :videos    (windows-shell-folder "My Video"))))
            (darwin
             ;; TODO: How can I get OSX directories?
             (error "**** darwin pending implementation ****"))
            (t
             ;; TODO: Revise the list of variables.
             (list :config    (expand-file-name "config" "~/.emacs.d")
                   :data      (expand-file-name "data" "~/.emacs.d")
                   :cache     (expand-file-name "cache" "~/.emacs.d")
                   :runtime   (expand-file-name "runtime" "~/.emacs.d")
                   :documents (expand-file-name "~/Documents")
                   :downloads (expand-file-name "~/Downloads"))))))
    (setq user-emacs-config-directory (plist-get dirs :config)
          user-emacs-data-directory (plist-get dirs :data)
          user-emacs-cache-directory (plist-get dirs :cache)
          user-emacs-runtime-directory (plist-get dirs :runtime)
          user-documents-directory (plist-get dirs :documents))

    ;; Thanks for lexical-binding into elisp, there is no need for a
    ;; public map of directories.
    (defun locate-user-file (domain name)
      "Locates a file named NAME in DOMAIN.

The domain is a key like :documents or :downloads.
Returns NIL if DOMAIN is not found."
      (if-let ((dir (plist-get dirs domain)))
              (expand-file-name name dir)))))


;; Find now all the directory names this system use and define the
;; function `locate-user-file', tailored to the OS.  Do not run it if
;; 'locate-user-file' is defined (for it would be runned twice
;; unecessarily).
;;
(unless (fboundp 'locate-user-file)
  (udirs-find-user-emacs-directories))


(provide 'emacs-directories)
;;; emacs-directories.el ends here
