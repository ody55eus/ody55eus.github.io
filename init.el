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
    (setq org-roam-directory (concat
                              (locate-dominating-file buffer-file-name "INFO")
                              "source/")))

(provide 'init)
;;; init.el ends here
