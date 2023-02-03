(defun nrn/save-buffers ()
  (save-some-buffers 'no-confirm (lambda () t)))

(add-hook 'focus-out-hook 'nrn/save-buffers)


(add-hook 'before-save-hook 'delete-trailing-whitespace)
