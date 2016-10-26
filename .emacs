
(defun move-text-internal (arg)
   (cond
    ((and mark-active transient-mark-mode)
     (if (> (point) (mark))
            (exchange-point-and-mark))
     (let ((column (current-column))
              (text (delete-and-extract-region (point) (mark))))
       (forward-line arg)
       (move-to-column column t)
       (set-mark (point))
       (insert text)
       (exchange-point-and-mark)
       (setq deactivate-mark nil)))
    (t
     (beginning-of-line)
     (when (or (> arg 0) (not (bobp)))
       (forward-line)
       (when (or (< arg 0) (not (eobp)))
            (transpose-lines arg))
       (forward-line -1)))))

(defun move-text-down (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines down."
   (interactive "*p")
   (move-text-internal arg))

(defun move-text-up (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines up."
   (interactive "*p")
   (move-text-internal (- arg)))

(global-set-key [\M-\C-up] 'move-text-up)
(global-set-key [\M-\C-down] 'move-text-down)



(add-to-list 'load-path "/usr/share/emacs/site-lisp")
(require 'dircolors) 
(setq load-path (cons "~/.emacs.d/org2blog/" load-path))
(require 'org2blog-autoloads)

(setq org2blog/wp-blog-alist
      '(("wordpress"
	 :url "http://localhost:8008/xmlrpc.php"
	 :username "egelor"
	 :default-title "Notes "
	 :default-categories ("org2blog" "emacs")
	 :tags-as-categories nil)
	("my-blog"
	 :url "http://localhost:8008/xmlrpc.php"
	 :username "egelor")))


(add-hook 'after-init-hook 'global-company-mode)

(require 'ido)
(ido-mode t)



(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))



	



(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'load-path "~/elisp")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

(global-font-lock-mode 1)
(add-hook 'org-mode-hook 'turn-on-font-lock) 



  (setq erc-echo-notice-in-minibuffer-flag t)

  (global-set-key "\C-c L" 'org-insert-link-global )
  (global-set-key "\C-c o" 'org-open-at-point-global)



(require 'sclang)
(require 'w3m)

;#####skeleton pair insertion for brackets and stuff#####
(global-set-key "\"" 'skeleton-pair-insert-maybe)
(global-set-key "\'" 'skeleton-pair-insert-maybe)
(global-set-key "\`" 'skeleton-pair-insert-maybe)
(global-set-key "\{" 'skeleton-pair-insert-maybe)
(global-set-key "\[" 'skeleton-pair-insert-maybe)
(global-set-key "\(" 'skeleton-pair-insert-maybe)
(global-set-key "\<" 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)

;#####no toolbar, menubar, highlight a selection while making it#####
(tool-bar-mode 0)
(scroll-bar-mode -1)
(transient-mark-mode 1)
(menu-bar-mode t)



'(sclang-auto-scroll-post-buffer t)
 '(sclang-eval-line-forward nil)
 '(sclang-help-path (quote ("/usr/local/share/SuperCollider/Help" "~/.local/share/SuperCollider/Help")))
 '(sclang-library-configuration-file "~/.config/SuperCollider/sclang_conf.yaml")
 '(sclang-runtime-directory "~/.local/share/SuperCollider/")
 '(sclang-server-panel "Server.default.makeGui")
 '(show-paren-mode t)
 '(w3m-pop-up-frames t)
 '(w3m-pop-up-windows nil)

;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 

;## hack to make the cursor work normally in w3m-mode - thanks martin :)
(eval-after-load "w3m"
 '(progn
 (define-key w3m-mode-map [left] 'backward-char)
 (define-key w3m-mode-map [right] 'forward-char)
 (define-key w3m-mode-map [up] 'previous-line)
 (define-key w3m-mode-map [down] 'next-line)
 (setq w3m-auto-show 1)
;; (setq truncate-lines 1)
;; (setq truncate-lines t)
 ))


(defun sclang-turn-on-eldoc-mode ()
 ; "Enable eldoc-mode for sclang"
  (interactive)
  (set (make-local-variable 'eldoc-documentation-function)
       'sclang-show-method-args)
  (turn-on-eldoc-mode))

(add-hook 'sclang-mode-hook 'sclang-turn-on-eldoc-mode)


;# ORG-MODE ACTIVATION
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-font-lock-mode 1)  ; for all buffers
(add-hook 'org-mode-hook 'turn-on-font-lock) ; org buffer only
(setq org-agenda-custom-commands
   '(("f" occur-tree "FIXME")))


(global-set-key (kbd "C-c c") 'org-capture)

(setq org-default-notes-file "~/org/organizer.org")

(setq org-refile-targets '((org-agenda-files . (:maxlevel . 6 ))))

(global-set-key (kbd "C-c o") 
                (lambda () (interactive) (find-file "~/org/TODO.org")))

(setq org-todo-keywords
'((sequence "TODO(t)" "|" "DONE(d)")
(sequence "REPORT(r)" "BUG(b)" "DOING(k)" "|" "FIXED(f)")
(sequence "|" "CANCELED(c)")))


;; Org count words 



(defvar count-words-buffer
  nil
  "*Number of words in the buffer.")

(defun wicked/update-wc ()
  (interactive)
  (setq count-words-buffer (number-to-string (count-words-buffer)))
  (force-mode-line-update))

; only setup timer once
(unless count-words-buffer
  ;; seed count-words-paragraph
  ;; create timer to keep count-words-paragraph updated
  (run-with-idle-timer 1 t 'wicked/update-wc))


;; add count words paragraph the mode line
(unless (memq 'count-words-buffer global-mode-string)
  (add-to-list 'global-mode-string "words: " t)
  (add-to-list 'global-mode-string 'count-words-buffer t)) 

;; count number of words in current paragraph
(defun count-words-buffer ()
  "Count the number of words in the current paragraph."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((count 0))
      (while (not (eobp))
	(forward-word 1)
        (setq count (1+ count)))
      count)))

(defun wicked/org-update-checkbox-count (&optional all)
  "Update the checkbox statistics in the current section.
This will find all statistic cookies like [57%] and [6/12] and update
them with the current numbers.  With optional prefix argument ALL,
do this for the whole buffer."
  (interactive "P")
  (save-excursion
    (let* ((buffer-invisibility-spec (org-inhibit-invisibility))
	   (beg (condition-case nil
		    (progn (outline-back-to-heading) (point))
		  (error (point-min))))
	   (end (move-marker
		 (make-marker)
		 (progn (or (outline-get-next-sibling) ;; (1)
			    (goto-char (point-max)))
			(point))))
	   (re "\\(\\[[0-9]*%\\]\\)\\|\\(\\[[0-9]*/[0-9]*\\]\\)")
	   (re-box
	    "^[ \t]*\\(*+\\|[-+*]\\|[0-9]+[.)]\\) +\\(\\[[- X]\\]\\)")
	   b1 e1 f1 c-on c-off lim (cstat 0))
      (when all
	(goto-char (point-min))
	(or (outline-get-next-sibling) (goto-char (point-max))) ;; (2)
	(setq beg (point) end (point-max)))
      (goto-char beg)
      (while (re-search-forward re end t)
	(setq cstat (1+ cstat)
	      b1 (match-beginning 0)
	      e1 (match-end 0)
	      f1 (match-beginning 1)
	      lim (cond
		   ((org-on-heading-p)
		    (or (outline-get-next-sibling) ;; (3)
			(goto-char (point-max)))
		    (point))
		   ((org-at-item-p) (org-end-of-item) (point))
		   (t nil))
	      c-on 0 c-off 0)
	(goto-char e1)
	(when lim
	  (while (re-search-forward re-box lim t)
	    (if (member (match-string 2) '("[ ]" "[-]"))
		(setq c-off (1+ c-off))
	      (setq c-on (1+ c-on))))
	  (goto-char b1)
	  (insert (if f1
		      (format "[%d%%]" (/ (* 100 c-on)
					  (max 1 (+ c-on c-off))))
		    (format "[%d/%d]" c-on (+ c-on c-off))))
	  (and (looking-at "\\[.*?\\]")
	       (replace-match ""))))
      (when (interactive-p)
	(message "Checkbox statistics updated %s (%d places)"
		 (if all "in entire file" "in current outline entry")
		 cstat)))))
(defadvice org-update-checkbox-count (around wicked activate)
  "Fix the built-in checkbox count to understand headlines."
  (setq ad-return-value
	(wicked/org-update-checkbox-count (ad-get-arg 1))))


(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("~/org/Emacs.org" "~/org/TODO.org" "~/story/rela.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
