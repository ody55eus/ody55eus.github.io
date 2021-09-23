;;; init.el --- Org Roam Website Blog -*- lexical-binding: t; -*-
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
;;  These are my personal emacs tweaks to edit my
;;  webpage with org roam.
;;
;;
;;; Code:

(defun jp/init-webpage ()
    (setq-local org-roam-directory (concat
                              (locate-dominating-file buffer-file-name "INFO")
                              "source/")
          org-roam-capture-templates '(("d" "default" plain
         "%?\n\nSee also %a.\n"
         :if-new (file+head
                  "%<%Y%m%d%H%M%S>-${slug}.org"
                  "#+title: ${title}\n")
         :unnarrowed t)
        ("j" "Projects" plain
         "%?"
         :if-new (file+head
                  "Projects/%<%Y%m%d%H%M%S>-${slug}.org"
                  "#+title: ${title}\n")
         :clock-in :clock-resume
         :unnarrowed t
         )
        ("l" "Literature")
        ("ll" "Literature Note" plain
         "%?\n\nSee also %a.\n* Links\n- %x\n* Notes\n"
         :if-new (file+head
                  "Literature/%<%Y%m%d%H%M%S>-${slug}.org"
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
        ("c" "Code" plain
         "%?\n\nSee also %a.\n"
         :if-new (file+head
                  "Code/%<%Y%m%d%H%M%S>-${slug}.org"
                  "#+title: ${title}\n#+date: %U")
         :unnarrowed t
         )
        )))

(provide 'init)
;;; init.el ends here
