;;; init-page.el --- Ody55eus.gitlab.io Webpage -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Jonathan Pieper
;;
;; Author: Jonathan Pieper <https://gitlab.com/ody55eus>
;; Maintainer: Jonathan Pieper <ody55eus@mailbox.org>
;; Created: September 22, 2021
;; Modified: September 22, 2021
;; Version: 0.0.1
;; Keywords: org roam publish html css
;; Homepage: https://github.com/ody55eus/ody55eus.gitlab.io/
;; Package-Requires: ((emacs "27.2"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  These are my emacs tweaks to edit this
;;  webpage using org roam.
;;
;;; Code:

(require 'find-lisp)

(defun jp/init-webpage ()
  (defvar jp/url "https://ody5.de")
  (defvar jp/gl-url "https://gitlab.ody5.de")
  (defvar jp/repository "https://gitlab.com/ody55eus/ody55eus.gitlab.io")
  (defvar jp/root (expand-file-name "."))
  (setq org-roam-directory (concat
                            jp/root
                            "/source/")
        org-roam-v2-ack t
        org-link-abbrev-alist '(("gitlab" . "https://gitlab.com/")
                                ("github" . "https://github.com/")
                                ("ody5" . (concat jp/gl-url "/"))
                                )
        org-directory (concat
                       jp/root
                       "/source/")
        org-roam-db-location (concat jp/root "/org-roam.db")
        org-id-extra-files (find-lisp-find-files org-roam-directory "\.org$")
        org-roam-capture-templates '(("d" "default" plain
                                      "%?\n\nSee also %a.\n"
                                      :if-new (file+head
                                               "${slug}.org"
                                               "#+title: ${title}\n")
                                      :unnarrowed t)
                                     ("b" "Blog Entry" plain
                                      "%?"
                                      :if-new (file+head
                                               "Blog/${slug}.org"
                                               "#+title: ${title}\n#+date: %U")
                                      :unnarrowed t
                                      )
                                     ("l" "Literature")
                                     ("ll" "Literature Note" plain
                                      "%?\n\nSee also %a.\n* Links\n- %x\n* Notes\n"
                                      :if-new (file+head
                                               "Literature/${slug}.org"
                                               "#+title: ${title}\n")
                                      :unnarrowed t
                                      )
                                     ("lr" "Bibliography reference" plain
                                      "#+ROAM_KEY: %^{citekey}\n#+PROPERTY: type %^{entry-type}\n#+FILETAGS: %^{keywords}\n#+AUTHOR: %^{author}\n%?"
                                      :if-new (file+head
                                               "References/${citekey}.org"
                                               "#+title: ${title}\n")
                                      :unnarrowed t
                                      )
                                     ("p" "Projects" plain
                                      "%?"
                                      :if-new (file+head
                                               "Projects/${slug}.org"
                                               "#+title: ${title}\n")
                                      :unnarrowed t
                                      )
                                     )))

(provide 'init-page)
;;; init-page.el ends here
