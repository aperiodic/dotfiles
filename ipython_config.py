c.TerminalInteractiveShell.editing_mode = 'vi'
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode =True

# Autoreloading breaks isinstance() checks for classes defined in autoreloaded
# modules. I have it on most of the time because it's so convenient, but when I'm
# testing out code where those checks are necessary, I turn it off
c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['%autoreload 2']
