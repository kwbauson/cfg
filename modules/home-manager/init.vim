cmap <c-p> <up>
cmap <c-n> <down>
let mapleader = ' '
let maplocalleader = '  '
map <silent> <leader>s :setlocal invspell spell?<cr>
map <silent> <leader>w :setlocal invwrap wrap?<cr>
map <silent> <leader>n :set invnumber number?<cr>
map <silent> <leader>N :set invrelativenumber relativenumber?<cr>

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

set termguicolors
colorscheme codedark

let g:startify_session_persistence = 1
autocmd User Startified setlocal cursorline buftype=nofile
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
let g:startify_fortune_use_unicode = 1

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_second_hightlight = 0

command! GD Gdiff

set hidden nobackup nowritebackup updatetime=300 shortmess+=c signcolumn=yes:1

nmap <silent> gT :BufferPrevious<cr>
nmap <silent> gt :BufferNext<cr>
nmap <silent> gb :BufferPick<cr>
nmap <silent> gH :BufferMovePrevious<cr>
nmap <silent> gL :BufferMoveNext<cr>
nmap <silent> <leader>d :BufferClose<cr>

set noshowmode
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#nvimlsp#enabled = 1
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
nmap <silent> <leader>b :Buffers<cr>
nmap <silent> <leader>g :RG<cr>
nmap <expr> <leader>G ':Rg \b'.expand('<cword>').'\b<cr>'
vmap <silent> <leader>G y:Rg \b<c-r>"\b<cr>
