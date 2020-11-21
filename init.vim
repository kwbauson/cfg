cmap <c-p> <up>
cmap <c-n> <down>
let mapleader = ' '
let maplocalleader = '  '
map <silent> <leader>s :set invspell spell?<cr>
map <silent> <leader>w :set invwrap wrap?<cr>
map <silent> <leader>n :set invnumber number?<cr>
map <silent> <leader>N :set invrelativenumber relativenumber?<cr>
map <silent> <leader>r :up<bar>vs<bar>term %:p<cr>i
map <silent> <leader>, :e ~/.config/nixpkgs/init.vim<cr>

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

map <silent> <leader>d :BW<cr>

let g:context_enabled = 0

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_second_hightlight = 0

command! GD Gdiff

autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead *.flow setlocal filetype=javascript.jsx
let g:polyglot_disabled = ['csv']
let g:javascript_plugin_flow = 1
let g:coc_config_home = getenv('HOME') . '/.config/nixpkgs'

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
imap <silent><expr> <TAB> pumvisible() ? coc#_select_confirm() : "\<TAB>"
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
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

" call nvim_lsp#setup("tsserver", {})
" set omnifunc=lsp#omnifunc
" nnoremap <silent> gd :call lsp#text_document_definition()<cr>
" nnoremap <silent> gh :call lsp#text_document_hover()<cr>

set noshowmode
nmap <silent> gT :bprevious<cr>
nmap <silent> gt :bnext<cr>
nmap <silent> gb :buffer <c-r>=v:count<cr><cr>
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#whitespace#enabled = 0

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
