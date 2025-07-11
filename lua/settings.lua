local M = {}

function M.home()
    return os.getenv 'HOME' or os.getenv 'LOCALAPPDATA'
end


function M.setup()
    vim.g.mapleader = ','
    vim.g.maplocalleader = '\\'

    vim.opt.mouse = ''

    -- theme
    vim.opt.termguicolors = true
    vim.opt.background = 'dark' -- or "light" for light mode
    vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

    -- basic settings
    vim.opt.encoding = 'utf-8'
    vim.opt.backspace = 'indent,eol,start' -- backspace works on every char in insert mode
    vim.opt.completeopt = 'menu,menuone,noselect'
    vim.opt.history = 1000
    vim.opt.dictionary = '/usr/share/dict/words'
    vim.opt.startofline = true
    -- fix '#' comment indentation
    -- https://unix.stackexchange.com/questions/106526/stop-vim-from-messing-up-my-indentation-on-comments
    -- http://neovim.io/doc/user/indent.html
    vim.opt.smartindent = false
    vim.opt.cindent     = true
    vim.opt.cinkeys:remove '0#'
    vim.opt.indentkeys:remove '0#'
    vim.opt.cinkeys:remove '0--'
    vim.opt.indentkeys:remove '0--'

    -- Mapping waiting time
    vim.opt.timeout     = false
    vim.opt.ttimeout    = true
    vim.opt.ttimeoutlen = 100

    -- Display
    vim.opt.showmatch   = true -- show matching brackets
    vim.opt.scrolloff   = 3 -- always show 3 rows from edge of the screen
    vim.opt.synmaxcol   = 300 -- stop syntax highlight after x lines for performance
    vim.opt.laststatus  = 2 -- always show status line

    vim.opt.list        = false -- do not display white characters
    vim.opt.foldenable  = false
    vim.opt.foldlevel   = 4 -- limit folding to 4 levels
    vim.opt.foldmethod  = 'syntax' -- use language syntax to generate folds
    vim.opt.wrap        = false --do not wrap lines even if very long
    vim.opt.eol         = false -- show if there's no eol char
    vim.opt.showbreak   = '↪' -- character to show when line is broken

    -- Sidebar
    vim.opt.number      = false -- line number on the left
    vim.opt.modelines   = 0
    vim.opt.showcmd     = true  -- display command in bottom bar

    -- Search
    vim.opt.incsearch   = true -- starts searching as soon as typing, without enter needed
    vim.opt.ignorecase  = true -- ignore letter case when searching
    vim.opt.smartcase   = true -- case insentive unless capitals used in search

    vim.opt.matchtime   = 2    -- delay before showing matching paren
    vim.opt.mps         = vim.o.mps .. ',<:>'

    -- White characters
    --vim.opt.autoindent = true
    --vim.opt.smartindent = true
    --vim.opt.tabstop = 2 -- 1 tab = 2 spaces
    --vim.opt.shiftwidth = 2 -- indentation rule
    --vim.opt.formatoptions = 'qnj1' -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word
    --vim.opt.expandtab = true -- expand tab to spaces

    -- Backup files
    vim.opt.backup      = true                                     -- use backup files
    vim.opt.writebackup = false
    vim.opt.swapfile    = false                                    -- do not use swap file
    vim.opt.undodir     = M.home() .. '/.config/nvim/tmp/undo//'   -- undo files
    vim.opt.backupdir   = M.home() .. '/.config/nvim/tmp/backup//' -- backups
    vim.opt.directory   = M.home() .. '/.config/nvim/tmp/swap//'   -- swap files

    --vim.cmd([[
    --au FileType python                  set ts=4 sw=4
    --au BufRead,BufNewFile *.md          set ft=mkd tw=80 syntax=markdown
    --]])

    -- Commands mode
    vim.opt.wildmenu    = true -- on TAB, complete options for system command
    vim.opt.wildignore  =
    'deps,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc'

    -- :help exrc
    -- If the 'exrc' option is on (which is NOT the default), the current                                                                                                               │*
    -- directory is searched for the following files, in order of precedence:                                                                                                           │E
    -- - ".nvim.lua"                                                                                                                                                                    │>
    -- - ".nvimrc"                                                                                                                                                                      │
    -- - ".exrc"                                                                                                                                                                        │*
    -- The first that exists is used, the others are ignored.
    vim.o.exrc          = true

    -- Only show cursorline in the current window and in normal mode.
    vim.cmd [[
    augroup cline
        au!
        au WinLeave * set nocursorline
        au WinEnter * set cursorline
        au InsertEnter * set nocursorline
        au InsertLeave * set cursorline
    augroup END
    ]]
end

return M
