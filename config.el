;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

; reload with SPC r r

(setq org-directory "~/org/")

;; meow :3
(setq doom-theme 'doom-dark+)
(setq display-line-numbers-type t) ; nil: off, t: linear, relative: relative

(setq-default tab-width 4
              evil-shift-width 4
              indent-tabs-mode nil) ;; no more icky tab characters 🤢

(setq auto-save-visited-interval 0.5) ;; don't lose important bimsness work !!!!
(auto-save-visited-mode +1)

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
  :mode "\\.odin\\'"
  :hook (odin-ts-mode . eglot-ensure))

(after! treesit
  (add-to-list 'treesit-language-source-alist
               '(odin "https://github.com/tree-sitter-grammars/tree-sitter-odin"))
  (unless (treesit-language-available-p 'odin)
    (treesit-install-language-grammar 'odin)))

(after! eglot
  (add-to-list 'eglot-server-programs
               '((odin-ts-mode) . ("ols"))))

(defun +odin-ols-check-on-open-h () ;; dear god
  (when (eq major-mode 'odin-ts-mode)
    (run-with-timer 0.2 nil (lambda (buf)
      (when (buffer-live-p buf)
        (with-current-buffer buf
          (set-buffer-modified-p t)
          (save-buffer)))) (current-buffer))))

(add-hook 'eglot-managed-mode-hook #'+odin-ols-check-on-open-h)


(after! python
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode)))

(after! lsp-pyright
  (setq lsp-pyright-langserver-command "basedpyright"))
