:;exec emacs --quick --script   "$0" 

(defconst zv-hugo-base-dir "/home/valjean/workspace/notes/blogs/")
(defconst content-org "./")

(let ((static-dir (concat zv-hugo-base-dir "static/")))
  (make-directory static-dir :parents))

(setq package-user-dir (expand-file-name "./.packages"))
;; Install packages
(require 'package)

(setq package-archives '(("gnu" . "http://mirrors.ustc.edu.cn/elpa/gnu/") 
			("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/") 
			("nongnu" . "http://mirrors.ustc.edu.cn/elpa/nongnu/")))

(package-initialize)
(unless package-archive-contents
	(package-refresh-contents))

(dolist (pkg '(org ox-hugo))
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; Load packages
(require 'org)
(require 'ox-hugo)
(require 'find-lisp)


(progn
  (setq org-hugo-base-dir zv-hugo-base-dir)
  (setq org-pattern "\\.org$")
  (setq org-id-track-globally t)
  (setq org-id-locations-file "/home/valjean/.emacs.d/var/org/id-locations.el")
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
    (find-file elt)
    ;; (org-babel-execute-buffer t)
    (org-hugo-export-wim-to-md t)
    (message (format "Exported from %s" elt)))
  (message "Finished exporting to markdown"))

(publish-all)
(message "Build Success")
