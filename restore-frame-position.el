;;; restore-frame-position.el --- remember and restore initial frame position

;; Copyright (C) 2017 by Aaron Jensen

;; Author: Aaron Jensen <aaronjensen@gmail.com>
;; URL: https://github.com/aaronjensen/restore-frame-position
;; Version: 1.0.0
;; Package-Requires: ((emacs "25"))

;;; Commentary:

;; This package remembers and restores the position of the initial frame. To use
;; it, add this to your `init.el':

;;    (restore-frame-position)

;;; License:

;; This file is not part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
(defcustom restore-frame-position-file
  (expand-file-name "frame-position.el" user-emacs-directory)
  "The file to store the frame position to."
  :type 'file
  :group 'frames)

(defun restore-frame-position-save ()
  "Save the current frame's size and position to `restore-frame-position-file'."
  (when (window-system)
    (let* ((frame-size (alist-get 'outer-size (frame-geometry (selected-frame))))
           (frame-geometry-left (frame-parameter (selected-frame) 'left))
           (frame-geometry-top (frame-parameter (selected-frame) 'top))
           (frame-geometry-width (car frame-size))
           (frame-geometry-height (cdr frame-size)))

      (when (not (number-or-marker-p frame-geometry-left))
        (setq frame-geometry-left 0))
      (when (not (number-or-marker-p frame-geometry-top))
        (setq frame-geometry-top 0))
      (when (not (number-or-marker-p frame-geometry-width))
        (setq frame-geometry-width 0))
      (when (not (number-or-marker-p frame-geometry-height))
        (setq frame-geometry-height 0))

      (with-temp-buffer
        (insert
         ";;; This is the previous Emacs frame's geometry.\n"
         ";;; Last generated " (current-time-string) " by `restore-frame-position'.\n"
         (format "(add-to-list 'initial-frame-alist '(top . %d))\n" (max frame-geometry-top 0))
         (format "(add-to-list 'initial-frame-alist '(left . %d))\n" (max frame-geometry-left 0))
         ;; For some reason, we're about 20x4px off, so adjust
         (format "(add-to-list 'initial-frame-alist '(width . (text-pixels . %d)))\n" (max (- frame-geometry-width 20) 0))
         (format "(add-to-list 'initial-frame-alist '(height . (text-pixels . %d)))\n" (max (- frame-geometry-height 4) 0)))
        (when (file-writable-p restore-frame-position-file)
          (write-file restore-frame-position-file))))))

(defun restore-frame-position-load ()
  "Load the current frame's size and position from `restore-frame-position-file'."
  (when (file-readable-p restore-frame-position-file)
    (load-file restore-frame-position-file)))

;;;###autoload
(defun restore-frame-position ()
  "Install hooks to remember and restore initial frame poosition."
  (if after-init-time
      (restore-frame-position-load)
    (add-hook 'after-init-hook 'restore-frame-position-load))
  (add-hook 'kill-emacs-hook 'restore-frame-position-save))

(provide 'restore-frame-position)
;;; restore-frame-position.el ends here
