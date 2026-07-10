;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

; reload with SPC r r

(setq org-directory "~/org/")

;; meow :3
(setq doom-theme 'doom-dark+)
(setq display-line-numbers-type t) ; nil: off, t: linear, relative: relative

(setq-default tab-width 4
              evil-shift-width 4
              indent-tabs-mode nil) ;; no more icky tab characters 🤢

(setq auto-save-default t
      auto-save-visited-interval 30) ; don't lose important bimsness work !!!!

; make me big
(add-hook 'doom-init-ui-hook #'doom-big-font-mode)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

; look at me
(add-hook 'doom-init-ui-hook
          (defun +raise-and-focus-frame-h ()
            (raise-frame)
            (select-frame-set-input-focus (selected-frame))))


; languages meow

(use-package! odin-ts-mode
  :mode "\\.odin\\'")

(after! python
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode)))

(after! lsp-pyright
  (setq lsp-pyright-langserver-command "basedpyright"))
