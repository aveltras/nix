(global-display-line-numbers-mode)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(auto-save-visited-mode 1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(font . "Iosevka-18"))
(setq inhibit-startup-screen t)

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file) (load custom-file))

(setq auto-save-visited-interval 1)

(global-set-key (kbd "C-x é") 'split-window)
(global-set-key (kbd "C-x \"") 'split-window-horizontally)
(global-set-key (kbd "C-x &") 'delete-other-windows)
(global-set-key (kbd "C-x à") 'delete-window)

; Straight.el initialization
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

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

; Appearance

(setq-default line-spacing 4)
;; (use-package solarized-theme :config (load-theme 'solarized-dark t))
;; (use-package dracula-theme :config (load-theme 'dracula t))
(use-package warm-night-theme :config (load-theme 'warm-night t))
;; (use-package gruvbox-theme :config (load-theme 'gruvbox-dark-soft t))
;; (use-package kaolin-themes :config (load-theme 'kaolin-galaxy t))

; General functionality
(use-package company :config (add-hook 'after-init-hook 'global-company-mode))
(use-package ace-window
  :config
  (global-set-key (kbd "M-o") 'ace-window)
  (setq aw-keys '(?a ?z ?e ?r ?t ?q ?s ?d ?f)))

(use-package counsel
  :config
  (ivy-mode 1)
  (global-set-key (kbd "C-s") 'swiper)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)

  (global-set-key (kbd "C-h f") 'counsel-describe-function)
  (global-set-key (kbd "C-h v") 'counsel-describe-variable)
  (global-set-key (kbd "C-h l") 'counsel-find-library)
  (global-set-key (kbd "C-h i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "C-h u") 'counsel-unicode-char)

  (global-set-key (kbd "C-c C-r") 'ivy-resume)

  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package json-mode)
(use-package yaml-mode)
(use-package nix-mode :after json-mode :mode "\\.nix\\'")

(use-package expand-region
  :config
  (global-set-key (kbd "C-=") 'er/expand-region)
  (global-set-key (kbd "C-x C-=") 'er/contract-region))

(use-package direnv :config (direnv-mode))
(use-package magit :config (global-set-key (kbd "C-x g") 'magit-status))

(use-package avy
  :config
  (global-set-key (kbd "C-:") 'avy-goto-char)
  (avy-setup-default))

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/Code")))

(use-package dired-subtree :config (define-key dired-mode-map (kbd "<tab>") 'dired-subtree-toggle))

(setq-default dired-listing-switches "-laGh1v --group-directories-first")

; Haskell
(use-package haskell-mode)
(use-package dante
  :after haskell-mode
  :commands dante-mode
  :init
  (add-hook 'haskell-mode-hook 'flycheck-mode)
  (add-hook 'haskell-mode-hook 'dante-mode))
