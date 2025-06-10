;; ??? APARENTEMENTE acelera
;;(setq gc-cons-threshold 100000000)
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
(setq read-process-output-max (* 1024 1024 3))
(setq use-package-always-defer t)

;; arquivo separado pro emacs n foder minha config.
(setq custom-file "~/.emacs.d/custom.el")
(load-file custom-file)

;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; paradas chatas q vem por padrão.
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
;;(global-display-line-numbers-mode)
;; adicionei para não quebrar os pdfs, peguei do @suzumenobu2 em: https://github.com/vedang/pdf-tools/issues/252
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'org-mode-hook 'display-line-numbers-mode)
(dolist (mode '(pdf-view-mode-hook
                term-mode-hook
                eshell-mode-hook
;;                vterm-mode-hook
                imenu-list-minor-mode-hook
                imenu-list-major-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))
(setq-default display-line-numbers-type 'relative)

;; fonte

(add-to-list 'default-frame-alist '(font . "Iosevka-14"))

;; tab
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method 'nil)
(c-set-offset 'case-label tab-width)

;; y-n
(defalias 'yes-or-no-p 'y-or-n-p)

;; use-package
;; não precisa mais, vem built in no emacs!

;; dashboard c:
(use-package dashboard
  :ensure t
  :defer nil
  :config
  (setq dashboard-items '(
						  (projects  . 5)
						  (recents   . 5)
                          (bookmarks . 5)))
  (setq dashboard-banner-logo-title "year of the linux desktop!")
  (setq dashboard-startup-banner "~/.emacs.d/banner/logo1234.png")
    (setq dashboard-set-init-info t)
  (setq dashboard-init-info (format "%d packages loaded in %s"
                                    (length package-activated-list) (emacs-init-time)))
  (dashboard-setup-startup-hook))

;; diminish
(use-package diminish
  :ensure t)

;; ido && smex
(ido-mode 1)
(ido-everywhere 1)

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1)
  (setq ido-vertical-define-keys 'C-n-and-C-p-only))

(use-package smex
  :ensure t
  :init
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

;; swiper
(use-package ivy
  :ensure t)
(ivy-mode)
(diminish 'ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

(use-package swiper
  :ensure t
  :bind ("C-s" . 'swiper))

;; pdf-tools
(use-package pdf-tools
  :ensure t
  :config
  (pdf-loader-install))

;; eletric pair mode
(setq electric-pair-pairs '(
                            (?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")
                            ))
;;(setq electric-pair-inhibit-predicate
;;      '(lambda(c)
;;         (if (char-equal c ?\<) t (,electric-pair-inhibit-predicate c))))
(electric-pair-mode t)


;; switch window
(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l"))
  :bind
  ([remap other-window] . switch-window))

;; which key
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (which-key-mode))

;; company
(use-package company
  :ensure t
  :diminish company-mode company-box-mode
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "SPC") #'company-abort)
  )
(use-package company-box
  :ensure t
  :diminish company-box-mode
  :hook (company-mode . company-box-mode )
  )
(use-package company-c-headers
  :defer nil
  :ensure t)

;; yasnippets
(use-package yasnippet
  :ensure t
  :diminish
  )
(diminish 'yas-mode)
(diminish 'yas-minor-mode)
(yas-global-mode 1)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(use-package yasnippet-snippets
  :ensure t)

(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
        "~/.emacs.d/elpa/yasnippet-snippets-20250225.950/snippets/" ;; the yasmate collection
        ))

;; lsp
(use-package lsp-mode
  :ensure t
  :diminish
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-clangd-version "18.1.3")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c-mode . lsp)
;;		 (c++-mode . lsp)
		 (rust-mode . lsp)
	 ;;  				 (simpc-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(setq lsp-idle-delay 0.500)
(setq lsp-log-io nil)

;; optionally
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-ui-doc-enable t)
  (setq lsp-completion-show-detail t)
  (setq lsp-completion-show-kind t)
  (setq lsp-ui-sideline-delay 0)
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-show-with-mouse t)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-modeline-code-actions-enable t)
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-enable-snippet nil)
  (setq company-lsp-enable-snippet nil)
  )

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol
  )

;; c / simp-mode
(add-to-list 'load-path "~/.emacs.d/coisas")
;; Importing simpc-mode
(require 'simpc-mode)
(require 'fasm-mode)
(add-to-list 'auto-mode-alist '("\\.asm\\'" . fasm-mode))
;; Automatically enabling simpc-mode on files with extensions like .h, .c, .cpp, .hpp
;;(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

;; rust
(use-package rust-mode
  :ensure t)

;; custom func

(defun rc/duplicate-line () ;; peguei do tsoding https://github.com/rexim/dotfiles/blob/master/.emacs.rc/misc-rc.el
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)

;; eshell
(defun eshell-other-window ()
  "Create or visit an eshell buffer."
  (interactive)
  (if (not (get-buffer "*eshell*"))
      (progn
        (split-window-sensibly (selected-window))
        (other-window 1)
        (eshell))
    
    (switch-to-buffer-other-window "*eshell*")))

(global-set-key (kbd "<C-return>") 'eshell-other-window)

;; split window
(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

;;
