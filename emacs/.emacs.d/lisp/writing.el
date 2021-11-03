;;; Packages for writing
(use-package markdown-mode
  :commands (markdown-mode)
  :mode (("README\\.md" . gfm-mode)
         ("\\.[R]md" . markdown-mode))
  :init (setq markdown-command "pandoc"))

;; Distraction free writing
(use-package writeroom-mode
  :general
  (:states 'normal
   :prefix "SPC"
   "tw" 'writeroom-mode)
  :config
  (setq writeroom-fullscreen-effect 'maximize))

;; Spell check
(use-package flyspell
  :ensure f
  :diminish (flyspell-mode . " α")
  :hook (text-mode . flyspell-mode)
  :config
  (setq-default ispell-program-name "aspell"
                ispell-list-command "--list"))

(defun cloud/clock ()
  "Toggle org-clock in/out.
Purposefully restrictive --- clocking out should be global, while
clocking in should be explicit.  Usually easier to clock in to a task
using 'org-agenda' and 'I'."
  (interactive)
  (if (and (fboundp 'org-clocking-p) (org-clocking-p))
      (org-clock-out)
    (if (equal major-mode 'org-mode)
        (org-clock-in)
      (message "Can't clock-in outside org-mode"))))

(use-package org
  :hook (org-mode . (lambda ()
                      (auto-fill-mode t)
                      (org-indent-mode t)
                      (diminish 'org-indent-mode)
                      (org-display-inline-images)))
  :init (setq org-src-fontify-natively t
              org-fontify-whole-heading-line t)
  :general (:states '(normal visual)
            :prefix "SPC"
            "o" '(:ignore t :which-key "org-mode")
            "ao" 'org-agenda
            "o@" 'org-add-note
            "o$" 'org-archive-subtree
            "o!" 'cloud/clock
            "oc" 'org-capture
            "od" 'org-deadline
            "oi" 'org-insert-link-global
            "ol" 'org-store-link
            "op" 'org-set-property
            "os" 'org-schedule
            "ot" 'org-todo
            "oq" 'org-set-tags-command
            "ow" 'org-refile)
           (:states 'normal
            "<tab>" 'org-cycle)
          (:keymap 'org-agenda-mode-map
           :states 'motion
            "@" 'org-agenda-add-note)
  :config
  ;; Don't expand topics when opening file
  (setq org-startup-folded t)

  ;; Space b/w collapsed headers
  (setq org-cycle-separator-lines 1)

  ;; Stylize emphasis markers like bold or italics
  (setq org-hide-emphasis-markers t)

  ;; Render latex snippets as svg for retina
  (setq org-latex-create-formula-image-program 'dvisvgm)

  ;; Possible states for TODO tasks
  (setq org-todo-keywords
        '((sequence "TODO" "WAITING(@/!)" "STARTED(!)" "|" "DONE" "CANCELED")))

  ;; Record when a todo was closed
  (setq org-log-done 'time)

  ;; Default file for org-capture and create some templates
  (setq org-default-notes-file "~/notes/n.org"
        org-capture-templates
        '(("n" "NOTE" entry (file+headline "~/notes/n.org" "Inbox")
           "* %?\n %T\n\n %i\n")
          ("c" "Code Snippet" entry (file "~/notes/snippets.org")
           "* %?\t:%^{language}:\n#+BEGIN_SRC %\\1\n%i\n#+END_SRC")
          ("l" "Log Book" entry (file+datetree "~/notes/n.org")
           "* Log\n%?")
          ("t" "Todo" entry (file+headline "~/notes/n.org" "Inbox")
           "* TODO %?\n %i\n")))

  ;; Agenda options
  (setq org-agenda-files '("~/notes")
        org-agenda-window-setup 'current-window
        org-agenda-skip-scheduled-if-deadline-is-shown t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-start-on-weekday 0
        org-agenda-scheduled-leaders '("" "")
        org-agenda-deadline-leaders '("" "")
        org-agenda-custom-commands
        '(("q" "Full agenda"
           ((todo "STARTED")
            (agenda "Week View")
            (todo "TODO"
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'scheduled 'deadline))))
            (todo "WAITING")))))

  ;; Refile across files
  (setq org-refile-targets
        '((nil :maxlevel . 3)
          (org-agenda-files :maxlevel . 3)
          (org-files-list :maxlevel . 3)))

  ;; Selection menu for possible targets across files, narrow to
  ;; specific headings
  (setq org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil)

  ;; Persist check in time
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)

  ;; Display settings org-agenda
  (add-hook 'diary-display-hook 'fancy-diary-display)
  (add-hook 'diary-today-visible-calendar-hook 'calendar-mark-today)

  (setq-default prettify-symbols-alist
                '(("#+OPTION:" . "∷")
                  (":PROPERTIES:" . ":")
                  ("#+BEGIN_SRC" . "λ")
                  ("#+END_SRC" . "⋱")
                  ("#+begin_src" . "λ")
                  ("#+end_src" . "⋱")
                  ("#+RESULTS:" . "»")
                  (":END:" . "⋱")
                  (":RESULTS:" . "⋱")
                  ("#+BEGIN_EXAMPLE" . "~")
                  ("#+END_EXAMPLE" . "~")))

  (add-hook 'org-mode-hook 'prettify-symbols-mode)

  ;; Symbol indicating hidden content
  (setq org-ellipsis " ⇣")

  ;; Generally stick to polymode for interactive eval w/ repl
  (org-babel-do-load-languages
   'org-babel-load-languages '((emacs-lisp . t)
                               (shell . t)
                               (python . t)
                               (R . t)))

  ;; When editing src block keep window arrangement as is
  (setq org-src-window-setup 'split-window-below)

  ;; Get old easy-template behavior back so that <r TAB inserts an R
  ;; code block
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("r" . "src R")))

;; Interactive eval of src blocks with polymode
(use-package poly-org)
(use-package poly-markdown
  :mode ("\\.Rmd" . poly-markdown-mode))

;; Display matching org header
(use-package org-sticky-header
  :hook (org-mode . org-sticky-header-mode))

;; Fancy bullet symbols
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; Notational velocity like file search
(use-package deft
  :general (:states 'normal
                    :prefix "SPC"
                    "fn" 'deft)
  :config
  (setq deft-extensions '("org")
        deft-directory "~/notes"
        deft-use-filename-as-title t))

;;; Reference management
(use-package ivy-bibtex
  :init
  (setq bibtex-completion-bibliography "~/Dropbox/refs/library.bib"
        bibtex-completion-pdf-field "file"
        bibtex-completion-notes-path "~/notes/lit.org"
        bibtex-completion-pdf-symbol "⌘"
        bibtex-completion-notes-symbol "✎"
        ivy-bibtex-default-action 'ivy-bibtex-insert-citation)

  (setq bibtex-completion-notes-template-one-file
        "* ${author} (${year}): ${title}\n :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :AUTHOR: ${author}\n  :YEAR: ${year}\n :END:\n\n")

  :general
  ("C-c c" 'ivy-bibtex)
  (:states 'normal
           :prefix "SPC"
           "fq" 'ivy-bibtex))
