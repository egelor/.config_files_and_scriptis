;#####csound emacs mode#####
;;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/stef-elisp")
;;(require 'stef-elisp)

;#####supercollider emacs mode#####

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

    (require 'color-theme)
    (color-theme-initialize)
    (color-theme-lethe)



(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(color-theme-selection "Arjen" nil (color-theme))
 '(emacs-goodies-el-defaults t)
 '(pop-up-frames nil)
 '(pop-up-windows t)
 '(sclang-auto-scroll-post-buffer t)
 '(sclang-eval-line-forward nil)
 '(sclang-help-path (quote ("/usr/local/share/SuperCollider/Help" "~/.local/share/SuperCollider/Help")))
 '(sclang-library-configuration-file "~/.config/SuperCollider/sclang_conf.yaml")
 '(sclang-runtime-directory "~/.local/share/SuperCollider/")
 '(sclang-server-panel "Server.default.makeGui")
 '(show-paren-mode t)
 '(w3m-pop-up-frames t)
 '(w3m-pop-up-windows nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

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


;# set emacs the standard editor for Python
(defvar server-buffer-clients) 
(when (and (fboundp 'server-start) (string-equal (getenv "TERM") 'xterm)) 
  (server-start) 
  (defun fp-kill-server-with-buffer-routine () 
    (and server-buffer-clients (server-done))) 
  (add-hook 'kill-buffer-hook 'fp-kill-server-with-buffer-routine)) 

;# ORG-MODE ACTIVATION
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)


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

