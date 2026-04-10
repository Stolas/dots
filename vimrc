"*****
"**  Thank you Mister Conway, http://tinyurl.com/IBV2013
"**  Also I never forget the folks at http://www.vimbits.com/
"**  /r/vim gave me a number of tips.
"**  The newest tips came from Amir Salihefendic ( http://amix.dk/vim/vimrc.html )
"**  Guess what, it happend.. Claude fixed a bunch of things on my todo list.
"*****
"
"==============================================================================
" FUNCTION KEY MAP (quick reference)
"==============================================================================
" <F5>       Undotree toggle
" <F6>       Termdebug: Start debugger
" <F7>       Tagbar toggle
" <F8>       Termdebug: Step Over
" <F9>       Termdebug: Step Into
" <F12>      TaskList (TODO/FIXME browser)
"
" LEADER MAP (quick reference — <Space> is leader)
" <leader>ff/fb/fg/ft/fh  FZF: Files/Buffers/Rg/Tags/History
" <leader>gd/gr/K          LSP: definition/references/hover
" <leader>rn/<leader>ca    LSP: rename/code-action
" <leader>lf               LSP: format buffer
" <leader>m / :make        Build (cmake --build or make, auto-detected)
" <leader>mj               :make --target <name> (partial build)
" <leader>af               ALE: fix (clang-format / black / isort)
" <leader>Ce/Ca/Cr/Cs      Claude: Explain/Audit/Review/Summarise
" <leader>hx               Toggle hex/xxd view
" <leader>ss               Cycle spell language
" <leader>br/<leader>de    Debugger: breakpoint/evaluate
"==============================================================================

"==============================================================================
" [ 1. INITIALIZATION & ENVIRONMENT ]
"==============================================================================

" Bail out if this Vim is too old to understand basic expressions.
if !1 | finish | endif

" Force nocompatible mode (required for all modern features).
if &cp | set nocompatible | endif

" -- Platform detection --------------------------------------------------------
let g:is_windows = has('win16') || has('win32') || has('win64')
let g:is_freebsd = has('bsd')

" -- Encoding ------------------------------------------------------------------
" Only force UTF-8 in GUI; terminal encoding is the terminal's job.
if &encoding ==# 'latin1' && has('gui_running')
    set encoding=utf-8
endif

" -- vim-plug auto-install -----------------------------------------------------
" Installs plug.vim if it's missing, then triggers PlugInstall on next launch.
let s:plug_src = expand('~/.vim/autoload/plug.vim')
if !filereadable(s:plug_src)
    if g:is_windows
        silent !powershell -NoProfile -Command ^
            "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'" ^
            "-OutFile (New-Item -Force '$HOME/vimfiles/autoload/plug.vim')"
    elseif executable('curl')
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    elseif executable('fetch')
        " FreeBSD fetch
        silent !fetch -o ~/.vim/autoload/plug.vim
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"==============================================================================
" [ 2. PLUGINS ]
"==============================================================================
call plug#begin()

" -- Navigation & Project ------------------------------------------------------
Plug 'airblade/vim-rooter'              " Auto-lcd to project root (.git etc.)
Plug 'mhinz/vim-startify'               " Fancy start screen + session manager
Plug 'tpope/vim-vinegar'                " Enhanced netrw ('-' to explore)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                 " Files, Buffers, Rg, Tags fuzzy search
Plug 'mbbill/undotree'                  " Visual undo history (<F5>)

" -- LSP & Completion ----------------------------------------------------------
" Using prabirshrestha stack — pure Vimscript, no external Node dependency.
Plug 'prabirshrestha/vim-lsp'                  " Core async LSP client
Plug 'prabirshrestha/asyncomplete.vim'         " Async completion engine
Plug 'prabirshrestha/asyncomplete-lsp.vim'     " LSP completion source

" -- Code Navigation -----------------------------------------------------------
Plug 'majutsushi/tagbar'                " Symbol browser powered by ctags (<F7>)
Plug 'kshenoy/vim-signature'            " Show marks in the sign column

" -- VCS -----------------------------------------------------------------------
Plug 'tpope/vim-fugitive'               " Full Git wrapper (:Git, :Gblame, etc.)

" -- Language Support ----------------------------------------------------------
Plug 'gabrielelana/vim-markdown'        " Markdown (pentest/research reports)
Plug 'sploit/snort-vim'                 " Snort/Suricata rule syntax
Plug 'vim-scripts/TaskList.vim'         " <F12> — browse TODO/FIXME/HACK tags
Plug 'peterhoeg/vim-qml'               " QML syntax + indent

" -- CMake ---------------------------------------------------------------------
" vim-cmake only supports Neovim on Windows
if !g:is_windows || has('nvim')
    Plug 'cdelledonne/vim-cmake'        " CMake project integration
endif

" -- Linting / Formatting ------------------------------------------------------
" vim-lsp already drives clang-tidy diagnostics via clangd.
" ale is added for cases without an LSP (shell scripts, makefiles, etc.)
Plug 'dense-analysis/ale'               " Async Lint Engine (fallback linter)

" -- Visuals -------------------------------------------------------------------
Plug 'vim-scripts/darkspectrum'         " Dark legacy colorscheme
Plug 'bronson/vim-trailing-whitespace'  " Highlight/strip trailing whitespace

call plug#end()

" Required after plug#end() — enable filetype detection and syntax.
filetype plugin indent on
syntax on

"==============================================================================
" [ 3. CORE SETTINGS ]
"==============================================================================

" -- Leader --------------------------------------------------------------------
let mapleader = "\<Space>"

" -- Editing behaviour ---------------------------------------------------------
set expandtab               " Spaces not tabs (per-filetype overrides below)
set shiftwidth=4            " Indent width
set tabstop=4               " Tab display width
set softtabstop=4           " Backspace over spaces like tabs
set smarttab                " Use shiftwidth when inserting a tab at BOL
set autoread                " Reload file if changed outside Vim
set hidden                  " Allow unsaved buffers in background
set mouse=a                 " Full mouse support
set nofoldenable            " No folding — distracting in kernel/llvm trees
set scrolloff=5             " Keep 5 lines of context around cursor
set linebreak               " Don't break words in the middle
set nrformats-=octal        " Don't treat 007 as octal with <C-A>/<C-X>
set formatoptions+=j        " Remove comment leader when joining lines

" -- Search --------------------------------------------------------------------
set incsearch               " Show match while typing
set hlsearch                " Highlight all matches
set ignorecase              " Case-insensitive search …
set smartcase               " … unless the pattern has a capital letter

" -- UI ------------------------------------------------------------------------
set number relativenumber   " Hybrid line numbers (absolute current + relative)
set title                   " Set terminal window title to filename
set lazyredraw              " Don't redraw during macros (faster)
set ttyfast                 " Assume a fast terminal connection
set splitbelow splitright   " New splits open below and to the right
if exists('+jumpoptions')
    set jumpoptions=stack   " Jumplist as a stack: forward entries discarded on new jump
endif
set colorcolumn=100         " Ruler at 100 chars
set laststatus=2            " Always show the status line
set wildmenu                " Enhanced command-line completion
set wildmode=longest:full,full
if exists('+wildoptions')
    set wildoptions=pum         " Wildmenu in a popup like the completion menu
endif

if has('popupwin')
    set completeopt=menuone,popup,noselect
else
    set completeopt=menuone,preview,noselect
endif

if exists('+completefuzzymatch')
    set completefuzzymatch=all  " Fuzzy-match native completion popup (mlce -> MyLongClassName)
endif

" -- Clipboard -----------------------------------------------------------------
set clipboard+=unnamed      " Use the system clipboard for y/p

" -- Whitespace display --------------------------------------------------------
exec "set listchars=tab:\uA6\\ ,trail:\uAF,nbsp:~"
set list                    " Always show invisibles

" -- Wildcard ignores ----------------------------------------------------------
set wildignore+=*.o,*.obj,*.pyc,*.exe,*.pdb,*.d

" -- Persistent undo -----------------------------------------------------------
if has('persistent_undo')
    let s:undodir = expand('~/.vim/undodir')
    if !isdirectory(s:undodir)
        call mkdir(s:undodir, 'p')
    endif
    let &undodir = s:undodir
    set undofile
endif

" -- Appearance ----------------------------------------------------------------
set background=dark
silent! colorscheme darkspectrum
hi ColorColumn guibg=#272727 ctermbg=235

"==============================================================================
" [ 4. HELPER FUNCTIONS ]
"==============================================================================

" Walk up looking for compile_commands.json (in root or root/build).
" Used when registering clangd so it picks up the right compilation database.
" NOTE: s:find_project_root() is intentionally absent — vim-rooter already
" lcd's to the project root, so getcwd() is always the project root.
function! s:find_compile_commands_dir() abort
    let l:dir = expand('%:p:h')
    while l:dir !=# fnamemodify(l:dir, ':h')
        if filereadable(l:dir . '/compile_commands.json')
            return l:dir
        elseif filereadable(l:dir . '/build/compile_commands.json')
            return l:dir . '/build'
        endif
        let l:dir = fnamemodify(l:dir, ':h')
    endwhile
    return getcwd()
endfunction

"==============================================================================
" [ 5. PLUGIN SETTINGS ]
"==============================================================================

" -- vim-rooter ----------------------------------------------------------------
let g:rooter_cd_cmd       = 'lcd'          " Keep chdir local to window/tab
let g:rooter_patterns     = ['.git', 'CMakeLists.txt', 'Makefile', 'setup.py', '*.pro']
let g:rooter_silent_chdir = 1              " No messages on chdir

" -- vim-cmake -----------------------------------------------------------------
" :CMakeGenerate   — runs cmake in build/
" :CMakeBuild      — runs cmake --build build/
" :CMakeClean      — cleans the build dir
let g:cmake_link_compile_commands = 1      " Symlink compile_commands.json to root
let g:cmake_build_dir_location    = 'build'

" -- ALE (fixers + shellcheck only) -------------------------------------------
" LSP (clangd / pyright / marksman) already handles linting for C, C++,
" Python, and Markdown.  ALE's value here is exclusively:
"   - shellcheck for shell scripts (bash-language-server is optional)
"   - clang-format / black / isort as on-save code formatters
" <leader>af runs :ALEFix manually when auto-fix is undesirable.
let g:ale_linters = {
    \ 'sh': ['shellcheck'],
\ }
let g:ale_fixers = {
    \ 'c':      ['clang-format'],
    \ 'cpp':    ['clang-format'],
    \ 'python': ['black', 'isort'],
    \ '*':      ['remove_trailing_lines', 'trim_whitespace'],
\ }
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save         = 1
let g:ale_fix_on_save          = 1   " Run fixers automatically on save
let g:ale_set_signs            = 1
let g:ale_sign_error           = 'E>'
let g:ale_sign_warning         = 'W>'
let g:ale_disable_lsp          = 1   " Never compete with vim-lsp diagnostics

nnoremap <leader>af :ALEFix<CR>

" -- asyncomplete --------------------------------------------------------------
" FIX: The source must be explicitly registered — was missing in the original.
augroup asyncomplete_setup_group
    autocmd!
    autocmd User asyncomplete_setup
        \ call asyncomplete#register_source(
        \     asyncomplete#sources#lsp#get_source_options({
        \         'name': 'lsp',
        \         'allowlist': ['*'],
        \         'completor': function('asyncomplete#sources#lsp#completor'),
        \     })
        \ )
augroup END

" -- vim-lsp settings ----------------------------------------------------------
let g:lsp_diagnostics_echo_cursor          = 1   " Show diagnostic under cursor in cmdline
let g:lsp_diagnostics_virtual_text_enabled = 0   " No inline virtual text (noisy)
let g:lsp_document_highlight_enabled       = 1   " Highlight references to symbol
let g:lsp_signature_help_enabled           = 1   " Show function signature while typing
let g:lsp_hover_ui = has('popupwin') ? 'popup' : 'preview'

"==============================================================================
" [ 6. LSP SERVER REGISTRATION ]
"==============================================================================
" Servers are registered lazily via the lsp_setup User event.
" Add new servers here — the pattern is: check executable ? register.

augroup lsp_server_setup
    autocmd!
    autocmd User lsp_setup call s:register_lsp_servers()
augroup END

function! s:register_lsp_servers() abort

    " -- clangd (C / C++ / Objective-C) ---------------------------------------
    " clangd drives everything: completions, diagnostics, clang-tidy, inlay hints.
    " compile_commands.json must exist (cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1).
    if executable('clangd')
        call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info -> [
            \     'clangd',
            \     '--background-index',
            \     '--clang-tidy',
            \     '--all-scopes-completion',
            \     '--completion-style=detailed',
            \     '--header-insertion=iwyu',
            \     '--compile-commands-dir=' . s:find_compile_commands_dir(),
            \ ]},
            \ 'allowlist': ['c', 'cpp', 'cc', 'objc', 'objcpp'],
        \ })
    endif

    " -- pyright (Python) ------------------------------------------------------
    " Install: npm install -g pyright
    " Handles type checking, completions, go-to-definition.
    if executable('pyright-langserver')
        call lsp#register_server({
            \ 'name': 'pyright',
            \ 'cmd': {server_info -> ['pyright-langserver', '--stdio']},
            \ 'allowlist': ['python'],
        \ })
    endif

    " -- bash-language-server (shell scripts) ----------------------------------
    " Install: npm install -g bash-language-server
    if executable('bash-language-server')
        call lsp#register_server({
            \ 'name': 'bash-language-server',
            \ 'cmd': {server_info -> ['bash-language-server', 'start']},
            \ 'allowlist': ['sh', 'bash'],
        \ })
    endif

    " -- marksman (Markdown — research reports) --------------------------------
    " Install: https://github.com/artempyanykh/marksman/releases
    if executable('marksman')
        call lsp#register_server({
            \ 'name': 'marksman',
            \ 'cmd': {server_info -> ['marksman', 'server']},
            \ 'allowlist': ['markdown'],
        \ })
    endif

    " -- qmlls (QML — Qt 6) ---------------------------------------------------
    " Ships with Qt 6.2+: <Qt install>/bin/qmlls
    " Also available standalone: pip install qmlls (experimental)
    if executable('qmlls')
        call lsp#register_server({
            \ 'name': 'qmlls',
            \ 'cmd': {server_info -> ['qmlls']},
            \ 'allowlist': ['qml'],
        \ })
    endif

endfunction

" -- LSP buffer keybindings ----------------------------------------------------
" Called whenever an LSP is activated for the current buffer.
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete

    " Navigation
    nmap <buffer> gd          <plug>(lsp-definition)
    nmap <buffer> gD          <plug>(lsp-declaration)
    nmap <buffer> gy          <plug>(lsp-type-definition)
    nmap <buffer> gi          <plug>(lsp-implementation)
    nmap <buffer> gr          <plug>(lsp-references)
    nmap <buffer> K           <plug>(lsp-hover)

    " Refactoring
    nmap <buffer> <leader>rn  <plug>(lsp-rename)
    nmap <buffer> <leader>ca  <plug>(lsp-code-action)
    nmap <buffer> <leader>qf  <plug>(lsp-document-diagnostics)

    " Diagnostics navigation
    nmap <buffer> ]g          <plug>(lsp-next-diagnostic)
    nmap <buffer> [g          <plug>(lsp-previous-diagnostic)

    " Format current buffer via LSP (clang-format / black etc.)
    nmap <buffer> <leader>lf  <plug>(lsp-document-format)
endfunction

augroup lsp_buffer_enable
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" -- Completion menu keybindings -----------------------------------------------
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

"==============================================================================
" [ 7. STATUS LINE ]
"==============================================================================
" Custom lightweight statusline with LSP diagnostics, Git branch, paste mode.
" No external plugin needed — pure built-in.
"
" Layout:
"   LEFT:  filename  [git-branch]  [PASTE]  LSP:E2 W1
"   RIGHT: filetype  [line/total, col]  percentage

" Helper: show paste mode indicator
function! StatusPasteMode() abort
    return &paste ? ' [PASTE]' : ''
endfunction

" Helper: show LSP error/warning counts for the current buffer.
" Returns empty string if vim-lsp is not loaded or no diagnostics.
function! StatusLspDiagnostics() abort
    if !exists('*lsp#get_buffer_diagnostics_counts')
        return ''
    endif
    let l:counts = lsp#get_buffer_diagnostics_counts()
    if empty(l:counts)
        return ''
    endif
    let l:e = get(l:counts, 'error',   0)
    let l:w = get(l:counts, 'warning', 0)
    if l:e == 0 && l:w == 0
        return ' [OK]'
    endif
    let l:out = ' LSP:'
    if l:e > 0 | let l:out .= ' E' . l:e | endif
    if l:w > 0 | let l:out .= ' W' . l:w | endif
    return l:out
endfunction

" Helper: show LSP server name(s) active for this buffer.
function! StatusLspServer() abort
    if !exists('*lsp#get_server_status')
        return ''
    endif
    " Collect names of running servers for this buffer's filetype.
    let l:servers = lsp#get_allowed_servers()
    let l:running = []
    for l:s in l:servers
        if lsp#get_server_status(l:s) ==# 'running'
            call add(l:running, l:s)
        endif
    endfor
    return empty(l:running) ? '' : ' [' . join(l:running, ',') . ']'
endfunction

" Helper: show current/total match count for the active search.
function! StatusSearch() abort
    if !v:hlsearch | return '' | endif
    let l:c = searchcount({'maxcount': 999, 'timeout': 20})
    if empty(l:c) || l:c.incomplete | return '' | endif
    return ' [' . l:c.current . '/' . l:c.total . ']'
endfunction

" Build the statusline.
" %t   = tail of filename (basename)
" %m   = modified flag
" %r   = readonly flag
" %h   = help buffer flag
" %=   = separator (switch to right side)
" %y   = filetype
" %l   = current line, %L = total lines, %c = column
" %P   = percentage through file
set statusline=
set statusline+=\ %t                            " Filename
set statusline+=%m%r%h                          " Modified / Readonly / Help flags
set statusline+=\ [%{FugitiveHead()}]           " Git branch
set statusline+=%{StatusPasteMode()}            " [PASTE] when paste is on
set statusline+=%{StatusLspDiagnostics()}       " LSP error/warning counts
set statusline+=%{StatusLspServer()}            " Active LSP server name(s)
set statusline+=%{StatusSearch()}               " Search match [current/total]
set statusline+=%=                              " -- right side --
set statusline+=%y                              " [filetype]
set statusline+=\ [%l/%L,\ %c]                 " [current/total, col]
set statusline+=\ %P\                           " percentage

" Per-window title bar: filename + modified flag + git branch on the right.
" Suppressed for special buffers (quickfix, help, terminal, nofile scratch).
if exists('+winbar')
    augroup winbar_setup
        autocmd!
        autocmd BufEnter,BufWinEnter * call s:SetWinbar()
    augroup END

    function! s:SetWinbar() abort
        if &buftype !=# ''
            setlocal winbar=
        else
            setlocal winbar=%t\ %m%r\ %=%{FugitiveHead()}
        endif
    endfunction
endif

" Refresh diagnostics in the statusline when vim-lsp updates them.
augroup lsp_statusline_refresh
    autocmd!
    autocmd User lsp_diagnostics_updated redrawstatus
augroup END

"==============================================================================
" [ 8. DEBUGGING ]
"==============================================================================
" Uses Vim's built-in termdebug pack (GDB/LLDB/CDB bridge).
" No external plugins needed — `packadd termdebug` is enough.

if v:version >= 800 && has('terminal')
    packadd termdebug

    " -- Debugger selection ----------------------------------------------------
    if g:is_windows
        " Windows kernel/user-mode debugging with CDB (WinDbg command-line)
        let g:termdebugger = 'cdb'
    elseif executable('lldb')
        " FreeBSD / LLVM-native
        let g:termdebugger = 'lldb'
    elseif executable('gdb')
        let g:termdebugger = 'gdb'
    endif

    " Make termdebug use a vertical split (easier on wide monitors)
    let g:termdebug_wide = 1

    " -- Debug keybindings -----------------------------------------------------
    nnoremap <F6>        :Debug<CR>
    nnoremap <F8>        :Over<CR>
    nnoremap <F9>        :Step<CR>
    nnoremap <leader>br  :Break<CR>
    nnoremap <leader>bc  :Clear<CR>
    nnoremap <leader>de  :Evaluate<CR>
    nnoremap <leader>dc  :Continue<CR>
    nnoremap <leader>df  :Finish<CR>
endif

"==============================================================================
" [ 9. BUILD SYSTEM (Make / CMake) ]
"==============================================================================
" :make and <leader>m both go through makeprg, which is set automatically
" whenever vim-rooter lcd's to a new project root (DirChanged event).
"
" Detection order:
"   build/CMakeCache.txt  -> cmake --build build (generator-agnostic: Ninja,
"                            Makefiles, MSBuild all work)
"   Makefile present      -> make (plain)
"   fallback              -> make
"
" This means bare :make always does the right thing without flags.

function! s:UpdateMakePrg() abort
    let l:root = getcwd()
    if filereadable(l:root . '/build/CMakeCache.txt')
        " cmake --build is generator-agnostic (Ninja, Makefiles, MSBuild).
        let &makeprg = 'cmake --build ' . shellescape(l:root . '/build', 1)
    elseif filereadable(l:root . '/Makefile')
        let &makeprg = 'make'
    else
        let &makeprg = 'make'
    endif
endfunction

" Fire on every vim-rooter lcd and on startup.
augroup smart_makeprg
    autocmd!
    autocmd DirChanged * call s:UpdateMakePrg()
    autocmd VimEnter   * call s:UpdateMakePrg()
augroup END

" Quickfix navigation — compile errors go here.
nnoremap <leader>m  :make<CR>
nnoremap <leader>mj :make --target
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprev<CR>
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>

" cmake-specific shortcuts (see vim-cmake docs)
nnoremap <leader>cg :CMakeGenerate<CR>
nnoremap <leader>cb :CMakeBuild<CR>

"==============================================================================
" [ 10. CTAGS & CSCOPE (LCD-Aware) ]
"==============================================================================
" Because vim-rooter uses `lcd`, we must walk up to find tag/cscope files.
" The trailing `;` in `set tags` tells Vim to do the same walk itself.

" -- ctags ---------------------------------------------------------------------
if executable('ctags')
    " Run ctags from the project root, exclude noise dirs.
    command! MakeTags
        \ silent! execute '!ctags -R'
        \   . ' --exclude=.git --exclude=build --exclude=node_modules'
        \   . ' ' . getcwd()
        \ | redraw!

    " Walk up the directory tree for tags files (the `;` suffix is the magic).
    set tags=./tags;,tags;

    " <C-]>  ? go to definition (show list if ambiguous with g<C-]>)
    " <C-[>  ? go back (same as <C-T>; <C-[> === <Esc> in some terms, be careful)
    nnoremap <C-]>      g<C-]>
    nnoremap <leader>ct :MakeTags<CR>
endif

" -- cscope --------------------------------------------------------------------
" cscope is powerful for large C codebases (Linux kernel, LLVM, BSD).
if has('cscope') && executable('cscope')
    set cscopetag       " Use cscope for tag-jumps
    set csto=0          " Check cscope before ctags

    " Load the nearest cscope.out walking up from the current file.
    function! s:load_cscope() abort
        let l:db = findfile('cscope.out', '.;')
        if !empty(l:db) && filereadable(l:db)
            " Avoid re-adding the same database.
            try
                silent execute 'cscope add ' . l:db . ' ' . fnamemodify(l:db, ':h')
            catch
            endtry
        endif
    endfunction

    augroup cscope_load
        autocmd!
        autocmd BufEnter *.c,*.cpp,*.h,*.hpp call s:load_cscope()
    augroup END

    " Build / rebuild cscope database from project root.
    nnoremap <leader>cs :silent! execute '!cscope -Rbq -s ' . getcwd()
        \ <bar> cscope reset <bar> redraw!<CR>

    " Query shortcuts — all use the word under the cursor.
    nnoremap <leader>cf :cscope find s <C-R>=expand('<cword>')<CR><CR>
    nnoremap <leader>cG :cscope find g <C-R>=expand('<cword>')<CR><CR>
    nnoremap <leader>cd :cscope find d <C-R>=expand('<cword>')<CR><CR>
    nnoremap <leader>ci :cscope find i <C-R>=expand('<cword>')<CR><CR>
endif

"==============================================================================
" [ 11. FILETYPE OVERRIDES ]
"==============================================================================
augroup filetype_configs
    autocmd!

    " -- C / C++ ---------------------------------------------------------------
    " Kernel style: 8-space hard tabs.  Override per-project in .vimrc.local.
    autocmd FileType c,cpp,cc
        \ setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab

    " -- Python (exploit dev, scripting) ---------------------------------------
    autocmd FileType python
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

    " -- Markdown (research reports) -------------------------------------------
    autocmd FileType markdown,mkd
        \ setlocal spell spelllang=en_US colorcolumn=80 wrap

    " -- LLVM IR ---------------------------------------------------------------
    autocmd BufRead,BufNewFile *.ll   set filetype=llvm

    " -- Snort / Suricata rules ------------------------------------------------
    autocmd BufRead,BufNewFile *.snort set syntax=hog

    " -- CMakeLists ------------------------------------------------------------
    autocmd BufRead,BufNewFile CMakeLists.txt set filetype=cmake

    " -- QML (Qt Markup Language) ----------------------------------------------
    " Qt convention: 4-space indent, 80-col limit.
    autocmd FileType qml
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab colorcolumn=80

    " -- Qt resource / designer files (XML-based) ------------------------------
    autocmd BufRead,BufNewFile *.qrc,*.ui set filetype=xml
    autocmd BufRead,BufNewFile *.pro,*.pri set filetype=make
augroup END

"==============================================================================
" [ 12. KEYBINDINGS ]
"==============================================================================

" -- Window navigation ---------------------------------------------------------
" <C-hjkl> to move between splits without needing <C-w> first.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" -- FZF fuzzy search ----------------------------------------------------------
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fh :History<CR>

" -- Plugin toggles ------------------------------------------------------------
nnoremap <F5>  :UndotreeToggle<CR>
nnoremap <F7>  :TagbarToggle<CR>
nnoremap <F12> <Plug>TaskList

" -- Disable Ex mode (it trips people up constantly) ---------------------------
nnoremap Q <nop>

" -- Save as root --------------------------------------------------------------
" FIX: original had `%!sudo tee > /dev/null %` which redirects before the
" filename, so tee gets no input.  Correct form below sends buffer to tee.
cnoremap w!! w !sudo tee % > /dev/null

" -- Clear search highlight ----------------------------------------------------
nnoremap <leader><space> :nohlsearch<CR>

" -- Spell toggle (cycles: off ? en_US ? nl) ----------------------------------
let g:my_lang_list = ['nospell', 'en_US', 'nl']
let b:my_lang = 0

function! ToggleSpell() abort
    " b:my_lang may be undefined in a fresh buffer
    if !exists('b:my_lang') | let b:my_lang = 0 | endif
    let b:my_lang = (b:my_lang + 1) % len(g:my_lang_list)
    let l:lang = g:my_lang_list[b:my_lang]
    if l:lang ==# 'nospell'
        setlocal nospell
    else
        execute 'setlocal spell spelllang=' . l:lang
    endif
    echo 'Spelllang: ' . l:lang
endfunction

nnoremap <leader>ss :call ToggleSpell()<CR>

" Custom spell error appearance (underline + red, no distracting background)
highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=red gui=undercurl,bold

" -- Visual block swap ---------------------------------------------------------
" NOTE: This remapping is intentionally kept but documented as opinionated.
" It makes `v` behave as block-select and `<C-V>` as character-select.
" Comment these 4 lines out if it causes confusion with plugins.
nnoremap v     <C-V>
nnoremap <C-V> v
vnoremap v     <C-V>
vnoremap <C-V> v

"==============================================================================
" [ 13. CLAUDE CLI INTEGRATION ]
"==============================================================================
" Requires: `claude` CLI installed and authenticated (`claude auth login`).
"
" Keybindings (visual or normal mode):
"   <leader>Ce  -- explain selected code / current file
"   <leader>Ca  -- security audit: vulns, attack surface, dangerous patterns
"   <leader>Cr  -- code review: bugs, logic errors, style
"   <leader>Cs  -- summarise what the code does (quick triage)
"
" Output opens in a scratch window. Close with q.
" Uses `claude -p` (print / non-interactive) via job_start() -- async, won't block Vim.

if executable('claude')
    function! s:ClaudeShowResult(lines, tmpfile) abort
        call delete(a:tmpfile)
        botright new
        setlocal buftype=nofile bufhidden=wipe noswapfile filetype=markdown
        call setline(1, a:lines)
        nnoremap <buffer> q :q<CR>
    endfunction

    function! s:ClaudeQuery(prompt, lnum1, lnum2) abort
        let l:lines   = getline(a:lnum1, a:lnum2)
        let l:code    = join(l:lines, "\n")
        let l:full    = a:prompt . "\n\n```\n" . l:code . "\n```"
        let l:tmpfile = tempname()
        call writefile([l:full], l:tmpfile)

        if !has('job')
            " Fallback: synchronous (Vim < 8 or no job support).
            let l:out = systemlist('claude -p', l:full)
            call s:ClaudeShowResult(l:out, l:tmpfile)
            return
        endif

        let l:out = []
        call job_start('claude -p', {
            \ 'in_io':   'file',
            \ 'in_name':  l:tmpfile,
            \ 'out_cb':  {_, line -> add(l:out, line)},
            \ 'exit_cb': {_, _ -> s:ClaudeShowResult(l:out, l:tmpfile)},
            \ })
        echomsg '[Claude] running...'
    endfunction

    command! -range ClaudeExplain
        \ call s:ClaudeQuery('Explain this code concisely. Note any non-obvious behaviour.', <line1>, <line2>)
    command! -range ClaudeAudit
        \ call s:ClaudeQuery('Security audit. List: vulnerabilities (CWE if applicable), dangerous patterns, attack surface, unsafe API usage.', <line1>, <line2>)
    command! -range ClaudeReview
        \ call s:ClaudeQuery('Code review. List: bugs, logic errors, resource leaks, undefined behaviour, and style issues.', <line1>, <line2>)
    command! -range ClaudeSummarise
        \ call s:ClaudeQuery('Summarise in 3-5 sentences what this code does. Be terse.', <line1>, <line2>)

    " Normal mode: operate on whole file.
    nnoremap <leader>Ce :%ClaudeExplain<CR>
    nnoremap <leader>Ca :%ClaudeAudit<CR>
    nnoremap <leader>Cr :%ClaudeReview<CR>
    nnoremap <leader>Cs :%ClaudeSummarise<CR>

    " Visual mode: operate on selection.
    vnoremap <leader>Ce :ClaudeExplain<CR>
    vnoremap <leader>Ca :ClaudeAudit<CR>
    vnoremap <leader>Cr :ClaudeReview<CR>
    vnoremap <leader>Cs :ClaudeSummarise<CR>
endif

"==============================================================================
" [ 14. GUI SETTINGS ]
"==============================================================================
if has('gui_running')
    set mousemodel=popup        " Right-click gives a popup menu
    set guioptions+=m           " Menu bar
    set guioptions-=T           " No toolbar
    set guioptions-=r           " No right scrollbar
    set guioptions-=L           " No left scrollbar
    for s:font in ['Hack:h12:cANSI:qDRAFT', 'Consolas:h12:cANSI', 'Courier_New:h12:cANSI']
        try
            exec 'set guifont=' . escape(s:font, ' ')
            break
        catch
        endtry
    endfor

    " -- Font size adjustment --------------------------------------------------
    function! s:AdjustFontSize(amount) abort
        let l:pat  = '^\(.* \)\([1-9][0-9]*\)$'
        let l:name = substitute(&guifont, l:pat, '\1', '')
        let l:size = substitute(&guifont, l:pat, '\2', '') + a:amount
        if l:size >= 6 && l:size <= 64
            let &guifont = l:name . l:size
        endif
    endfunction

    nnoremap <S-Up>   :call <SID>AdjustFontSize(1)<CR>
    nnoremap <S-Down> :call <SID>AdjustFontSize(-1)<CR>

    " Paste from system clipboard in GUI
    map  <silent> <S-Insert> "+p
    imap <silent> <S-Insert> <Esc>"+pa

    " -- Search menu (FZF) -------------------------------------------------------
    amenu Search.Files          :Files<CR>
    amenu Search.Buffers        :Buffers<CR>
    amenu Search.Ripgrep        :Rg<CR>
    amenu Search.Tags           :Tags<CR>
    amenu Search.History        :History<CR>

    " -- LSP menu ----------------------------------------------------------------
    nnoremenu LSP.Go\ to\ Definition      <Plug>(lsp-definition)
    nnoremenu LSP.Go\ to\ Declaration     <Plug>(lsp-declaration)
    nnoremenu LSP.Type\ Definition        <Plug>(lsp-type-definition)
    nnoremenu LSP.Find\ References        <Plug>(lsp-references)
    nnoremenu LSP.Hover                   <Plug>(lsp-hover)
    nnoremenu LSP.-Sep1-                  <Nop>
    nnoremenu LSP.Rename                  <Plug>(lsp-rename)
    nnoremenu LSP.Code\ Action            <Plug>(lsp-code-action)
    nnoremenu LSP.Format\ Buffer          <Plug>(lsp-document-format)
    nnoremenu LSP.Diagnostics             <Plug>(lsp-document-diagnostics)

    " -- Build menu --------------------------------------------------------------
    amenu Build.Make                      :make<CR>
    amenu Build.-Sep1-                    <Nop>
    amenu Build.CMake\ Generate           :CMakeGenerate<CR>
    amenu Build.CMake\ Build              :CMakeBuild<CR>
    amenu Build.-Sep2-                    <Nop>
    amenu Build.Next\ Error<Tab>cn        :cnext<CR>
    amenu Build.Prev\ Error<Tab>cp        :cprev<CR>
    amenu Build.Open\ Quickfix<Tab>co     :copen<CR>
    amenu Build.Close\ Quickfix<Tab>cc    :cclose<CR>

    " -- Debug menu (termdebug) --------------------------------------------------
    if v:version >= 800 && has('terminal')
        amenu Debug.Start<Tab>F6                  :Debug<CR>
        amenu Debug.Step\ Over<Tab>F8             :Over<CR>
        amenu Debug.Step\ Into<Tab>F9             :Step<CR>
        amenu Debug.Continue                      :Continue<CR>
        amenu Debug.Finish                        :Finish<CR>
        amenu Debug.-Sep-                         <Nop>
        amenu Debug.Set\ Breakpoint               :Break<CR>
        amenu Debug.Clear\ Breakpoint             :Clear<CR>
        amenu Debug.Evaluate                      :Evaluate<CR>
    endif

    " -- Misc menu ---------------------------------------------------------------
    amenu Misc.Cycle\ Spell\ Language     :call ToggleSpell()<CR>
    amenu Misc.Clear\ Search\ Highlight   :nohlsearch<CR>
    if executable('xxd')
        amenu Misc.-Sep-                  <Nop>
        amenu Misc.Toggle\ Hex\ View      :call <SID>ToggleHex()<CR>
    endif

    " -- Claude menus (only when claude is also available) ----------------------
    if executable('claude')
        amenu Claude.Explain\ File        :%ClaudeExplain<CR>
        amenu Claude.Audit\ File          :%ClaudeAudit<CR>
        amenu Claude.Review\ File         :%ClaudeReview<CR>
        amenu Claude.Summarise\ File      :%ClaudeSummarise<CR>
        amenu Claude.-Sep-                <Nop>
        vmenu Claude.Explain\ Selection   :ClaudeExplain<CR>
        vmenu Claude.Audit\ Selection     :ClaudeAudit<CR>
        vmenu Claude.Review\ Selection    :ClaudeReview<CR>
        vmenu Claude.Summarise\ Selection :ClaudeSummarise<CR>
    endif
endif

"==============================================================================
" [ 15. AUTOCMDS — MISC ]
"==============================================================================

" -- Swap file conflict: open readonly -----------------------------------------
" FIX: Original had echohl None before any echohl WarningMsg — pointless.
" Corrected version sets the highlight before the echo.
augroup no_simultaneous_edits
    autocmd!
    autocmd SwapExists *  let v:swapchoice = 'o'
    autocmd SwapExists *  echohl WarningMsg
    autocmd SwapExists *  echo 'Duplicate edit session — opened read-only'
    autocmd SwapExists *  echohl None
    autocmd SwapExists *  sleep 1
augroup END

" -- Hex / binary view toggle -------------------------------------------------
" Useful for auditing compiled binaries, firmware, shellcode etc.
" <leader>hx toggles between text and xxd hex view.
" WARNING: saving in hex mode writes the xxd dump, not the binary.
"          Use BinEdit workflow (open with `vim -b`) for real binary editing.
if executable('xxd')
    function! s:ToggleHex() abort
        if !exists('b:hex_mode') || !b:hex_mode
            let b:hex_mode = 1
            %!xxd
        else
            let b:hex_mode = 0
            %!xxd -r
        endif
    endfunction
    nnoremap <leader>hx :call <SID>ToggleHex()<CR>
endif

" -- Return to last cursor position when reopening a file ----------------------
augroup restore_cursor
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line('$')
        \|    execute "normal! g'\""
        \| endif
augroup END

"==============================================================================
" [ 16. LOCAL OVERRIDES ]
"==============================================================================
" Project-specific overrides live in .vimrc.local in the project root.
" Example use: override tabstop for a specific codebase, set a custom debugger.
if filereadable(expand('./.vimrc.local'))
    source ./.vimrc.local
endif
