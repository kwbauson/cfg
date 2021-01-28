config.load_autoconfig()
c.confirm_quit = ['downloads']
c.new_instance_open_target = 'window'
c.session.default_name = 'default'

c.auto_save.session = True
c.content.cache.size = None
c.content.fullscreen.window = True
c.content.geolocation = False
c.content.pdfjs = True
c.completion.cmd_history_max_items = -1
c.completion.height = '25%'
c.completion.show = 'auto'
c.completion.web_history.exclude = ['about:blank']
c.completion.open_categories = ['bookmarks', 'history']
c.downloads.remove_finished = 1000
c.hints.chars = 'asdfghjkl;qwertyuiopzxcvbnm'
c.hints.scatter = False
c.hints.uppercase = True
c.input.forward_unbound_keys = 'none'
c.spellcheck.languages = ['en-US']
c.statusbar.position = 'top'
c.statusbar.widgets = ['keypress', 'url', 'scroll', 'history', 'progress']
c.tabs.show = 'multiple'
c.tabs.tabs_are_windows = True
c.url.default_page = 'about:blank'
c.url.open_base_url = True
c.url.start_pages = ['about:blank']
c.window.title_format = '{perc}{current_title}'
c.colors.webpage.prefers_color_scheme_dark = True

# c.bindings.default = {}

config.bind(';d', 'hint all delete')
config.bind(';e', 'hint inputs')
config.bind(';f', 'hint all tab-fg')
config.bind(';r', 'hint --rapid all tab-bg')
config.bind(';y', 'hint links yank-primary')
config.bind('<Alt+h>', 'scroll left')
config.bind('<Alt+j>', 'scroll down')
config.bind('<Alt+k>', 'scroll up')
config.bind('<Alt+l>', 'scroll right')
config.bind('<Ctrl+e>', 'scroll-px 0 40')
config.unbind('<Ctrl+w>')
config.bind('<Ctrl+y>', 'scroll-px 0 -40')
config.bind('<Down>', 'scroll down')
config.bind('<Shift+Space>', 'scroll-page 0 -1')
config.bind('<Space>', 'scroll-page 0 1')
config.bind('<Up>', 'scroll up')
config.bind('F', 'hint all tab-bg')
config.bind('O', 'set-cmd-text :open {url:pretty}')
config.bind('P', 'open -t {primary}')
config.bind('T', 'set-cmd-text :open -t {url:pretty}')
config.bind('Y', 'yank')
config.bind('b', 'set-cmd-text -s :open -b')
config.bind('c', 'tab-clone')
config.bind('gb', 'open qute:bookmarks')
config.bind('gp', 'spawn -u login-fill')
config.bind('gq', 'open https://github.com/qutebrowser/qutebrowser/commits/master')
config.bind('gc', 'open https://github.com/kwbauson/cfg')
config.bind('gs', 'set')
config.bind('gv', 'open qute:version')
config.bind('h', 'scroll-px -40 0')
config.bind('j', 'scroll-px 0 40')
config.bind('k', 'scroll-px 0 -40')
config.bind('l', 'scroll-px 40 0')
config.bind('p', 'open {primary}')
config.bind('s', 'stop')
config.bind('t', 'set-cmd-text -s :open -t')
config.bind('w', 'open -t')
config.bind('y', 'yank --sel')
config.bind('u', 'undo --window')

config.bind('<Ctrl+h>', 'fake-key <backspace>', mode='insert')
config.bind('<Ctrl+j>', 'fake-key <enter>', mode='insert')
config.bind('<Ctrl+m>', 'fake-key <enter>', mode='insert')
config.bind('<Ctrl+u>', 'fake-key <shift-home><backspace>', mode='insert')
config.bind('<Ctrl+w>', 'fake-key <ctrl-backspace>', mode='insert')
