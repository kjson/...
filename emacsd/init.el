(require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el")
(cask-initialize)


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)



; Kevin's stuff
(load "~/.emacs.d/nosidebar.el")
(global-set-key (kbd "C-x C-b") 'ibuffer)

; melpa
(require 'evil)
(require 'merlin)
(require 'idris-mode)
