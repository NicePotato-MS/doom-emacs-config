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

;; don't lose other peoples important bimsness work !!!!
(global-auto-revert-mode 1) 
(setq global-auto-revert-non-file-buffers t)

; look at me and make me big
(defun +raise-and-focus-frame-h (&optional frame)
  (when (display-graphic-p frame)
    (with-selected-frame (or frame (selected-frame))
      (doom-big-font-mode 1)
      ;; (set-frame-parameter nil 'fullscreen 'maximized)
      (raise-frame)
      (select-frame-set-input-focus (selected-frame)))))

(add-hook 'doom-init-ui-hook #'+raise-and-focus-frame-h)
(add-hook 'server-after-make-frame-hook #'+raise-and-focus-frame-h)

; i don't want your free symbol handouts
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

; crush the cursor's hopes and dreams
(use-package! centered-cursor-mode
  :hook ((prog-mode text-mode conf-mode) . centered-cursor-mode)
  :config
  (setq ccm-recenter-at-end-of-file t))

; i don't want to keep pressing backspace twice
(setq +electric-continue-comments nil)

; do not hide the facts !!!!
(add-hook! 'compilation-mode-hook #'visual-line-mode)

; for your own selfish desires
(load! "local")

; languages meow


; woadin
(use-package! odin-ts-mode
  :mode "\\.odin\\'")
  ;; :hook (odin-ts-mode . eglot-ensure))

(add-hook 'odin-ts-mode-local-vars-hook #'lsp! 'append)

(when-let* ((ols (executable-find "ols")))
  (setq lsp-odin-ols-binary-path ols))

(after! treesit
  (add-to-list 'treesit-language-source-alist
               '(odin "https://github.com/tree-sitter-grammars/tree-sitter-odin"))
  (add-to-list 'treesit-language-source-alist
               '(python "https://github.com/tree-sitter/tree-sitter-python"))
  (unless (treesit-language-available-p 'odin)
    (treesit-install-language-grammar 'odin))
  (unless (treesit-language-available-p 'python)
    (treesit-install-language-grammar 'python)))

;; (after! eglot
;;   (add-to-list 'eglot-server-programs
;;                '((odin-ts-mode) . ("ols"))))

(defun +odin-ols-check-on-open-h () ;; dear god
  (when (eq major-mode 'odin-ts-mode)
    (run-with-timer 0.2 nil (lambda (buf)
      (when (buffer-live-p buf)
        (with-current-buffer buf
          (set-buffer-modified-p t)
          (save-buffer)))) (current-buffer))))

;; (add-hook 'eglot-managed-mode-hook #'+odin-ols-check-on-open-h)
(add-hook 'lsp-after-open-hook #'+odin-ols-check-on-open-h)


; EW PYTHON I HATE PYTHON SCREW YOU PYTHON EWWWW
(setq lsp-pyright-langserver-command "basedpyright")

;; (after! eglot
;;   (add-to-list 'eglot-server-programs
;;                '((python-mode python-ts-mode)
;;                  . ("basedpyright-langserver" "--stdio"))))

(after! lsp-mode
  (dolist (re '("[/\\\\]\\.venv\\'"
                "[/\\\\]venv\\'"
                "[/\\\\]\\.mypy_cache\\'"
                "[/\\\\]\\.ruff_cache\\'"))
    (add-to-list 'lsp-file-watch-ignored-directories re)))

(after! python
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode)))

(after! project
  (add-to-list 'project-vc-ignores "**/.venv/")
  (add-to-list 'project-vc-ignores "**/venv/")
  (add-to-list 'project-vc-ignores "**/__pycache__/")
  (add-to-list 'project-vc-ignores "**/.mypy_cache/"))
