;; The only thing missing from ivy-bibtex is linking. We can remedy
;; this by creating a custom org-mode link that opens ivy-bibtex,
;; although eventually it would be nice to also integrate a popup.
;;
;; In order to get ivy-bibtex to open the selection at point with the
;; new link type we have to redefine the
;; `bibtex-completion-key-at-point` function. To insert the custom
;; link we create a new ivy action with the function
;; `cloud/insert-link`.
;;
;; Avoid `org-ref` for now since it seems to be overkill --- PDFs and
;; bibtex file are handled external to emacs.

(org-add-link-type "bibtex" '(lambda (path) (ivy-bibtex)))

(defun bibtex-completion-key-at-point ()
  "Return the key of the BibTeX entry at point. If the current file is
   a BibTeX file, return the key of the entry at point. Otherwise, try
   to use `reftex' to check whether point is at a citation macro, and
   if so return the key at point. Otherwise, if the current file is an
   org-mode file, return the value of `org-bibtex-key-property' (or
   default to \"CUSTOM_ID\") or the path from a `bibtex'
   link. Otherwise, return nil."
  (or (and (eq major-mode 'bibtex-mode)
           (save-excursion
             (bibtex-beginning-of-entry)
             (and (looking-at bibtex-entry-maybe-empty-head)
                  (bibtex-key-in-head))))
      (and (require 'reftex-parse nil t)
           (save-excursion
             (skip-chars-backward "[:space:],;}")
             (let ((macro (reftex-what-macro 1)))
               (and (stringp (car macro))
                    (string-match "\\`\\\\cite\\|cite\\'" (car macro))
                    (thing-at-point 'symbol)))))
      (and (eq major-mode 'org-mode)
           (let ((object (org-element-context)))
             (if (and (equal (org-element-type object) 'link)
                      (equal (org-element-property :type object) "bibtex"))
                 (org-element-property :path object)
               (let (key)
                 (and (setq key (org-entry-get nil
                                               (if (boundp 'org-bibtex-key-property)
                                                   org-bibtex-key-property
                                                 "CUSTOM_ID")
                                               t))
                      ;; KEY may be the empty string the the property is
                      ;; present but has no value
                      (if (> (length key) 0)
                          key))))))))

(defun cloud/insert-org-link (keys)
  "Insert bibtex link from KEYS."
  (insert (mapconcat (lambda (n) (concat "bibtex:" n)) keys "\n")))
