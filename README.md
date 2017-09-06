# restore-frame-position

Remember and restore initial frame position when restarting Emacs.

Based on various snippets around the internet, including [this
one](https://wwwtech.de/articles/2011/jul/emacs-restore-last-frame-size-on-startup)
which was the oldest I could find.

## Installation

You can install this package from [Melpa][]

```
M-x package-install RET restore-frame-position RET
```

## Usage

Add to your `init.el`:

```elisp
(restore-frame-position)
```

[Melpa]: http://melpa.milkbox.net/
