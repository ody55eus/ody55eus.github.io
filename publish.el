;;; publish.el --- Ody55eus.gitlab.io Webpage -*- lexical-binding: t; -*-
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
;;  This file configures the export settings of Emacs. It renders the
;;  html template files and exports all org pages as html.
;;
;;; Code:

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'org-roam)
(straight-use-package 'htmlize)
(require 'ox-publish)
(require 'ox-html)
(require 'org-roam)
(require 'find-lisp)
(require 'htmlize)

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

(jp/init-webpage)

;; Timestamps can be used to avoid rebuilding everything.
;; This is useful locally for testing.
;; It won't work on Gitlab when stored in ./: the timestamps file should
;; probably be put inside the public/ directory.  It's not so useful there
;; however since generation is fast enough.
(setq org-publish-use-timestamps-flag t
      org-publish-timestamp-directory "./")

;; Get rid of index.html~ and the like that pop up during generation.
(setq make-backup-files nil)

(setq org-export-with-section-numbers nil
      org-export-with-smart-quotes t
      org-export-with-email t
      org-export-with-date t
      org-export-with-tags 'not-in-toc
      org-export-with-toc t
      org-html-container-element "section"
      org-html-metadata-timestamp-format "%Y-%m-%d"
      org-html-checkbox-type 'html
      org-html-html5-fancy t
      org-html-validation-link nil
      org-html-doctype "html5")

(defun jp/preamble (info)
  "Return preamble as a string."
  (let* ((file (plist-get info :input-file))
         (gitlab-url "https://gitlab.com/ody55eus")
         (github-url "https://github.com/ody55eus")
         (prefix (file-relative-name (expand-file-name "source" jp/root)
                                     (file-name-directory file)))
         (prefix2 (file-relative-name
                                     (file-name-directory file)
                                     (expand-file-name "source" jp/root)))
         (filename (file-name-nondirectory file))
         (filepath (if (string-equal prefix2 ".")
                           filename
                           (concat prefix2 filename))))
    (format
     (concat
     "<a href=\"%1$s/index.html\"><i class=\"fa fa-home\"></i> About</a>
<a href=\"%1$s/Projects/projects.html\"><i class=\"fa fa-folder-open\"></i> Projects</a>
<img class=\"logo\" src=\"%1$s/logo.png\">
<span class=\"banner\"><a
  href=\"%4$s\"><i class=\"fa fa-gitlab\"></i></a><a
  href=\"%5$s\"><i class=\"fa fa-github\"></i></a>Ody55eus</span>
<span class=\"source\"><a href=\"%3$s/-/tree/main/source/%2$s\"><i class=\"fa fa-code\"></i> Page-Source</a></span>
")
     prefix filepath jp/repository gitlab-url github-url)))

(setq ;; org-html-divs '((preamble "header" "top")
 ;;                 (content "main" "content")
 ;;                 (postamble "footer" "postamble"))
 org-html-postamble t
 org-html-postamble-format `(("en" ,(concat "<p class=\"comments\"><a href=\""
                                            jp/repository "/issues\">Comments</a></p>

<p class=\"date\">Date: %u</p>
<p class=\"creator\">Made with %c</p>
<p class=\"license\">
  &copy; 2021 Jonathan Pieper
  <a rel=\"license\" href=\"https://www.gnu.org/licenses/gpl-3.0.en.html\"><img alt=\"GNU General Public License\" width=\"64px\" style=\"border-width:0\" src=\"https://www.gnu.org/graphics/gplv3-127x51.png\" /></a>
  <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-sa/4.0/\"><img alt=\"Creative Commons License\" width=\"64px\" style=\"border-width:0\" src=\"https://mirrors.creativecommons.org/presskit/buttons/88x31/png/by-sa.png\" /></a>
</p>")))
 ;; Use custom preamble function to compute relative links.
 org-html-preamble #'jp/preamble
)

(setq org-html-style-plain org-html-style-default
      org-html-htmlize-output-type 'css)

;; Some help functions
(defun jp/git-creation-date (file)
  "Return the first commit date of FILE.
Format is %Y-%m-%d."
  (with-temp-buffer
    (call-process "git" nil t nil "log" "--reverse" "--date=short" "--pretty=format:%cd" file)
    (goto-char (point-min))
    (buffer-substring-no-properties (line-beginning-position) (line-end-position))))

(defun jp/git-last-update-date (file)
  "Return the last commit date of FILE.
Format is %Y-%m-%d."
  (with-output-to-string
    (with-current-buffer standard-output
      (call-process "git" nil t nil "log" "-1" "--date=short" "--pretty=format:%cd" file))))

(defun jp/org-html-format-spec (info)
  "Return format specification for preamble and postamble.
INFO is a plist used as a communication channel.
Just like `org-html-format-spec' but uses git to return creation and last update
dates.
The extra `u` specifier displays the creation date along with the last update
date only if they differ."
  (let* ((timestamp-format (plist-get info :html-metadata-timestamp-format))
         (file (plist-get info :input-file))
         (meta-date (org-export-data (org-export-get-date info timestamp-format)
                                     info))
         (creation-date (if (string= "" meta-date)
                            (jp/git-creation-date file)
                          ;; Default to the #+DATE value when specified.  This
                          ;; can be useful, for instance, when Git gets the file
                          ;; creation date wrong if the file was renamed.
                          meta-date))
         (last-update-date (jp/git-last-update-date file)))
    `((?t . ,(org-export-data (plist-get info :title) info))
      (?s . ,(org-export-data (plist-get info :subtitle) info))
      (?d . ,creation-date)
      (?T . ,(format-time-string timestamp-format))
      (?a . ,(org-export-data (plist-get info :author) info))
      (?e . ,(mapconcat
	      (lambda (e) (format "<a href=\"mailto:%s\">%s</a>" e e))
	      (split-string (plist-get info :email)  ",+ *")
	      ", "))
      (?c . ,(plist-get info :creator))
      (?C . ,last-update-date)
      (?v . ,(or (plist-get info :html-validation-link) ""))
      (?u . ,(if (string= creation-date last-update-date)
                 creation-date
               (format "%s (<a href=%s>Last update: %s</a>)"
                       creation-date
                       (format "%s/commits/main/%s" jp/repository (file-relative-name file jp/root))
                       last-update-date))))))
(advice-add 'org-html-format-spec :override 'jp/org-html-format-spec)

(defun jp/org-publish-find-date (file project)
  "Find the date of FILE in PROJECT.
Just like `org-publish-find-date' but do not fall back on file
system timestamp and return nil instead."
  (let ((file (org-publish--expand-file-name file project)))
    (or (org-publish-cache-get-file-property file :date nil t)
    (org-publish-cache-set-file-property
     file :date
     (let ((date (org-publish-find-property file :date project)))
       ;; DATE is a secondary string.  If it contains
       ;; a time-stamp, convert it to internal format.
       ;; Otherwise, use FILE modification time.
           (let ((ts (and (consp date) (assq 'timestamp date))))
         (and ts
          (let ((value (org-element-interpret-data ts)))
            (and (org-string-nw-p value)
             (org-time-string-to-time value))))))))))

(defun jp/org-publish-sitemap (title list)
  "Outputs site map, as a string.
See `org-publish-sitemap-default'. "
  ;; Remove index and non articles.
  (setcdr list (seq-filter
                (lambda (file)
                  (string-match "file:.*.org" (car file)))
                (cdr list)))
  ;; TODO: Include subtitle?  It may be wiser, at least for projects.
  (concat "#+TITLE: " title "\n"
          "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"../dark.css\">"
          "\n"
          "#+HTML_HEAD: <link rel=\"icon\" type=\"image/x-icon\" href=\"../logo.png\"> "
          "\n"
          (org-list-to-org list)))

(defun jp/org-publish-main-sitemap (title list)
  "Outputs site map, as a string.
See `org-publish-sitemap-default'. "
  ;; Remove index and non articles.
  (setcdr list (seq-filter
                (lambda (file)
                  (string-match "file:.*.org" (car file)))
                (cdr list)))
  (concat "#+TITLE: " title "\n"
          "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"dark.css\">"
          "\n"
          "#+HTML_HEAD: <link rel=\"icon\" type=\"image/x-icon\" href=\"logo.png\"> "
          "\n"
          (org-list-to-org list)))

(defun jp/org-publish-sitemap-entry (entry style project)
  "Custom format for site map ENTRY, as a string.
See `org-publish-sitemap-default-entry'."
  (cond ((not (directory-name-p entry))
         (let* ((meta-date (jp/org-publish-find-date entry project))
                (file (expand-file-name entry
                                        (org-publish-property :base-directory project)))
                (creation-date (if (not meta-date)
                                   (jp/git-creation-date file)
                                 ;; Default to the #+DATE value when specified.  This
                                 ;; can be useful, for instance, when Git gets the file
                                 ;; creation date wrong if the file was renamed.
                                 (format-time-string "%Y-%m-%d" meta-date)))
                (last-date (jp/git-last-update-date file)))
           (format "[[file:%s][%s]]^{ (%s)}"
                   entry
                   (org-publish-find-title entry project)
                   (if (string= creation-date last-date)
                       creation-date
                     (format "%s, updated %s" creation-date last-date)))))
	((eq style 'tree)
	 ;; Return only last subdir.
	 (capitalize (file-name-nondirectory (directory-file-name entry))))
	(t entry)))

(setq org-publish-project-alist
      (list
       (list "all-site-pages-org"
             :base-directory "./source/"
             :recursive t
             :publishing-function '(org-html-publish-to-html)
             :publishing-directory "./public/"
             :auto-sitemap nil
             :html-head-include-default-style nil
             :html-head-include-scripts nil
             :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"../dark.css\">
<link rel=\"icon\" type=\"image/x-icon\" href=\"../logo.png\">")
       (list "main-site-org"
             :base-directory "./source/"
             :recursive nil
             :publishing-function '(org-html-publish-to-html)
             :publishing-directory "./public/"
             :sitemap-format-entry #'jp/org-publish-sitemap-entry
             :auto-sitemap t
             :sitemap-title "Sitemap"
             :sitemap-filename "sitemap.org"
             ;; :sitemap-file-entry-format "%d *%t*"
             :sitemap-style 'list
             :sitemap-function #'jp/org-publish-main-sitemap
             ;; :sitemap-ignore-case t
             :sitemap-sort-files 'anti-chronologically
             :html-head-include-default-style nil
             :html-head-include-scripts nil
             :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"dark.css\">
<link rel=\"icon\" type=\"image/x-icon\" href=\"logo.png\">")
       (list "site-projects-org"
             :base-directory "./source/Projects"
             :recursive t
             :publishing-function '(org-html-publish-to-html)
             :publishing-directory "./public/Projects"
             :sitemap-format-entry #'jp/org-publish-sitemap-entry
             :auto-sitemap t
             :sitemap-title "Projects"
             :sitemap-filename "projects.org"
             ;; :sitemap-file-entry-format "%d *%t*"
             :sitemap-style 'list
             :sitemap-function #'jp/org-publish-sitemap
             ;; :sitemap-ignore-case t
             :sitemap-sort-files 'anti-chronologically
             :html-head-include-default-style nil
             :html-head-include-scripts nil
             :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"../dark.css\">
<link rel=\"icon\" type=\"image/x-icon\" href=\"../logo.png\">")
       (list "site-static"
             :base-directory "static/"
             :exclude "\\.org\\'"
             :base-extension 'any
             :publishing-directory "./public"
             :publishing-function 'org-publish-attachment
             :recursive t)
       (list "site" :components '("main-site-org" "site-projects-org" "site-static"))))

(defun jp/publish-html ()
  (org-roam-setup)
  (org-id-update-id-locations)
  (org-publish-all)
  )

(provide 'publish)
;;; publish.el ends here
