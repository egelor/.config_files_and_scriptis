;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.

;;package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; Second init file
(load "~/.emacs.d/.emAcs" t)
(load "~/.emacs.d/.emacs2" t)

(add-to-list 'load-path "~/.emacs.d/elpa/company-0.8.12")
(autoload 'company-mode "company" nil t)
(add-hook 'after-init-hook' global-company-mode)

;; gnus
(require 'gnus)
(setq gnus-select-method '(nnml ""))
(setq bbdb/news-auto-create-p t)
(setq bbdb-use-pop-up nil)
;;nnir to be able to search within your gmail/imap mail
(require 'nnir)
;; bbdb
(add-to-list 'load-path "~/.emacs.d/el-get/bbdb/lisp")
(add-to-list 'load-path  "~/.emacs.d/bbdb-autoloads")
(require 'bbdb-autoloads)
(require 'bbdb)
    (add-to-list 'file-coding-system-alist
                 (cons "\\.bbdb\\'" bbdb-file-coding-system))
    (bbdb-initialize 'gnus 'message)
    (add-hook 'message-setup-hook 'bbdb-define-all-aliases)
(global-set-key (kbd "C-c b") 'bbdb)
    (setq bbdb-canonicalize-net-hook
          '(lambda (addr)
             (cond ((string-match "\\`\\([^@+]+\\)\\+[^@]+\\(@.*\\)\\'" addr)
                    (concat (match-string 1 addr) (match-string 2 addr)))
                   ((string-match "\\`\\([^@]+@\\).*\\.\\(\\w+\\.\\w+\\.\\w+\\)\\'"
                                  addr)
                    (concat (match-string 1 addr) (match-string 2 addr)))
                   (t addr)))
          bbdb-north-american-phone-numbers-p nil
          bbdb-default-country "Greece"
          bbdb-print-require t
          bbdb-print-net 'all)

(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(add-to-list 'load-path "~/.emacs.d/bbdb-vcard/vcard.el")
(add-to-list 'load-path "~/.emacs.d/bbdb-vcard/test-bbdb-vcard.el")
;; Dircolors
(require 'dircolors)
;; Xml-rpc-el
(add-to-list 'load-path "~/.emacs.d/el-get/xml-rpc-el")
(require 'xml-rpc)


; wordpress org2blog
(setq load-path (cons "~/.emacs.d/org2blog/" load-path))
(require 'org2blog-autoloads)
(setq org2blog/wp-blog-alist
      '(("wordpress"
	 :url "http://62.38.141.195:8008/wordpress/xmlrpc.php"
	 :username "egelor"
	 :default-title "Notes"
	 :default-categories ("org2blog" "emacs" "code")
	 :tags-as-categories nil)
	("wordpress"
	 :url "http://62.38.141.195:8008/wordpress/xmlrpc.php"
	 :username "egelor")))

;company-mode
(add-to-list 'load-path "~/.emacs.d/elpa/company-0.8.12")
(autoload 'company-mode "company" nil t)
(add-hook 'after-init-hook 'global-company-mode)

;cl-lib for company-mode
(add-to-list 'load-path "~/.emacs.d/cl-lib")
;(load "cl-lib")
(require 'cl-lib)
;loads ido-mode
(require 'ido)
(ido-mode t)
;;Color-theme
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-tty-dark)))

;;El-get
(add-to-list 'load-path "~/.emacs.d/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/recipes")
(el-get 'sync)

(global-font-lock-mode 1)
(add-hook 'org-mode-hook 'turn-on-font-lock)

 (setq erc-echo-notice-in-minibuffer-flag t)
(global-set-key "\C-c L" 'org-insert-link-global )
(global-set-key "\C-c o" 'org-open-at-point-global)

;#SuperCollider w3m
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






(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("~/org/exoda.org" "~/Documents/eGelor_Programming/Arduino/org's/arduino.org" "~/org/video.org" "~/org/Emacs.org" "~/org/TODO.org" "~/org/Server.org" "~/org/Audio_signals.org")))
 '(send-mail-function (quote smtpmail-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
