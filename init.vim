cmap <c-p> <up>
cmap <c-n> <down>
let mapleader = ' '
let maplocalleader = '  '
map <silent> <leader>s :set invspell spell?<cr>
map <silent> <leader>w :set invwrap wrap?<cr>
map <silent> <leader>n :set invnumber number?<cr>
map <silent> <leader>N :set invrelativenumber relativenumber?<cr>
map <silent> <leader>r :up<bar>vs<bar>term %:p:S<cr>i
map <silent> <leader>, :e ~/cfg/init.vim<cr>

set mouse= title
set nojoinspaces smartindent
set ignorecase smartcase
set undofile
set history=10000
set expandtab tabstop=2 shiftwidth=2 softtabstop=2
set list listchars=tab:>\ ,nbsp:+,extends:↪,precedes:↪
set nowrap number
set splitbelow splitright
set diffopt+=iwhiteall,iwhiteeol,vertical,algorithm:patience
set foldlevelstart=1000
set shada+='1000
autocmd BufEnter * syntax sync fromstart

autocmd Filetype * AnyFoldActivate

set termguicolors
colorscheme codedark

let g:startify_session_persistence = 1
autocmd User Startified setlocal cursorline buftype=nofile
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
let g:startify_fortune_use_unicode = 1

let g:EasyMotion_startofline = 0
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'ASDFGHJKL;QWERTYUIOPZXCVBNM'
map ;w <Plug>(easymotion-bd-w)
map ;l <Plug>(easymotion-bd-jk)
map ;j <Plug>(easymotion-jumptoanywhere)

let NERDTreeWinSize=50
map <leader>t :NERDTreeToggle<cr>
map <leader>f :NERDTreeFind<cr>

map <silent> <leader>e :CocCommand explorer<cr>

let g:context_enabled = 0

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_second_hightlight = 0

command! GD Gdiff

autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead *.flow setlocal filetype=javascript.jsx
let g:polyglot_disabled = ['csv']
let g:javascript_plugin_flow = 1
let g:coc_config_home = getenv('HOME') . '/cfg'

set hidden nobackup nowritebackup updatetime=300 shortmess+=c signcolumn=yes:1
highlight link CocHighlightText Search
autocmd CursorHold * silent call CocActionAsync('highlight')
augroup mygroup
  autocmd!
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 F :call CocAction('format')
command! -nargs=0 Diagnostics :CocList --normal --auto-preview diagnostics
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
imap <silent><expr> <c-space> coc#refresh()
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ge <Plug>(coc-rename)
nmap <silent> g. <Plug>(coc-codeaction)
nmap <silent> g/ <Plug>(coc-codelens-action)
nmap <silent> gs :CocList -I symbols<cr>
nmap <silent> gh :call CocAction('doHover')<cr>
nmap <silent> g, :CocConfig<CR>
nmap <leader>i :CocInfo<cr>
nmap <leader>l :CocList<cr>
nmap <leader>c :CocList commands<cr>
nmap <c-c> :echo<bar>silent CocRestart<cr>

set noshowmode
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#nvimlsp#enabled = 0

nmap <silent> gT :BufferPrevious<cr>
nmap <silent> gt :BufferNext<cr>
nmap <silent> gb :BufferPick<cr>
nmap <silent> gH :BufferMovePrevious<cr>
nmap <silent> gL :BufferMoveNext<cr>
nmap <silent> <leader>d :BufferClose<cr>
let bufferline = get(g:, 'bufferline', {})
let bufferline.animation = v:false
let bufferline.auto_hide = v:false
let bufferline.tabpages = v:true
let bufferline.closable = v:false
let bufferline.icon_custom_colors = v:true
let bufferline.insert_at_end = v:true
let bufferline.maximum_padding = 0
hi default BufferCurrent guibg=#0A7ACA guifg=white
hi default BufferCurrentMod guibg=#FFAF00 guifg=black
hi default BufferCurrentSign guibg=#0A7ACA guifg=white
hi default BufferCurrentTarget guibg=#0A7ACA guifg=red gui=bold

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6 } }
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
nmap <silent> <leader>p :Files<cr>
nmap <silent> <leader>o :History<cr>
nmap <silent> <leader>b :Buffers<cr>
nmap <silent> <leader>g :RG<cr>
nmap <expr> <leader>G ':Rg \b'.expand('<cword>').'\b<cr>'
vmap <silent> <leader>G y:Rg \b<c-r>"\b<cr>
