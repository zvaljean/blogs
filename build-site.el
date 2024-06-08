:;exec emacs --quick --script   "$0" 

;; (defconst zv-hugo-base-dir "/home/valjean/workspace/notes/blogs/")
(defconst zv-hugo-base-dir default-directory)
(defconst content-org "./content-org")

(let ((static-dir (concat zv-hugo-base-dir "static/")))
  (make-directory static-dir :parents))

(setq package-user-dir (expand-file-name "./.packages"))
;; Install packages
(require 'package)

;; (setq package-archives
;;       '(("gnu" . "https://elpa.gnu.org/packages/")
;;         ("gnu-devel" . "https://elpa.gnu.org/devel/")
;;         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
;;         ("melpa" . "https://melpa.org/packages/")))
;;; 
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;;; https://emacs.stackexchange.com/questions/233/how-to-proceed-on-package-el-signature-check-failure
(setq package-check-signature nil) 

(package-initialize)
(unless package-archive-contents
	(package-refresh-contents))

(setq pkgs '(org ox-hugo))
(setq package-selected-packages pkgs)

(dolist (pkg pkgs)
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; Load packages
(require 'org)
(require 'ox-hugo)
(require 'find-lisp)
(require 'tomelr)


(progn
  (setq org-hugo-base-dir zv-hugo-base-dir)
  (setq org-pattern "\\.org$")
  ;; (setq org-id-track-globally t)
  (org-id-locations-load))


(defun find-org-file-recursively (directory pattern)
  "Recursively find files in DIRECTORY matching the given PATTERN.
Exclude hidden directories and files, as well as entries containing '/.'."
  (let ((files (directory-files-recursively directory pattern)))
    (cl-remove-if (lambda (file)
                    (or 
                        (string-match-p "^\\." (file-name-nondirectory file)) ;; hidden files
                        (string-match-p "/\\." file))) ; 排除包含 "/." 的条目
                  files)))

(defun publish-all()
  (message "Publishing from emacs...")
  (dolist (elt (find-org-file-recursively content-org org-pattern))

	;; (message "---> %s" elt)
	(with-current-buffer (find-file-noselect elt)
    ;; (org-babel-execute-buffer t)
    (org-hugo-export-wim-to-md))
	
    (message (format "Exported from %s" elt)))
  (message "Finished exporting to markdown"))

(publish-all)
(message "Build Success")
