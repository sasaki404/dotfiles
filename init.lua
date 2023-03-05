-- package manager
require("packer").startup(function()
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/vim-vsnip"

  use 'scrooloose/nerdtree'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'

end)

-- 1. LSP Sever management
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    -- -- Function executed when the LSP server startup
    -- on_attach = function(client, bufnr)
    --   local opts = { noremap=true, silent=true }
    --   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
    -- end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
  require('lspconfig')[server].setup(opt)
end })

-- 2. build-in LSP function
-- keyboard shortcut
vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)
-- Reference highlight
vim.cmd [[
set updatetime=500
highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]]

-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
  },
})
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "path" },
    { name = "cmdline" },
  },
})

-- 4.そのほかの設定

-- バックアップファイルを作らない
vim.opt.backup = false

-- スワップファイルを作らない
vim.opt.swapfile = false

-- インデント可視化
vim.opt.list = true
vim.opt.listchars = { tab = "»-", trail = "-", eol = "↲", extends = "»", precedes = "«", nbsp = "%" }

-- エンコーディング
vim.opt.encoding = "utf-8"

-- jキーを二度押しでESCキー
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })
-- help日本語化
vim.opt.helplang = "ja"

-- 行番号を表示
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.shiftwidth = 4

-- 挿入モードでバックスペースで削除できるようにする
vim.opt.backspace = { "indent", "eol", "start" }

-- 自動でカッコ等を閉じる
vim.api.nvim_set_keymap("i", "{<CR>", "{}<Left><CR><ESC><S-o>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "[<CR>", "[]<Left><CR><ESC><S-o>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "(<CR>", "()<Left><CR><ESC><S-o>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "(", "()<LEFT>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "\"", "\"\"<LEFT>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "'", "''<LEFT>", { noremap = true, silent = true })


-- インサートモードでCTRL+f、CTRL+b、CTRL+n、CTRL+pキーを使用して右、左、下、上に移動する
vim.api.nvim_set_keymap("i", "<C-f>", "<Right>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-b>", "<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-n>", "<Down>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-p>", "<Up>", { noremap = true })
-- インサートモード中にCTRL+aで行頭、CTRL+eで行末に移動する
vim.api.nvim_set_keymap("i", "<C-a>", "<Home>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-e>", "<End>", { noremap = true })


-- :ssコマンドを実行すると、init.luaファイルが再読み込みされるようにする
vim.api.nvim_command("command! SS luafile ~/.config/nvim/init.lua")


-- ヤンクするとクリップボードに保存される
vim.opt.clipboard:append("unnamed")

vim.api.nvim_set_keymap('n', '<C-b>', '<Left>', {noremap = true})
vim.api.nvim_set_keymap('n', '<ESC><ESC>', ':nohlsearch<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', 'ss', '^', {noremap = true})
vim.api.nvim_set_keymap('n', ';;', '$', {noremap = true})
vim.api.nvim_set_keymap('i', '<expr><CR>', 'pumvisible() ? "<C-y>" : "<CR>"', {noremap = true})

vim.o.completeopt = 'menuone,noinsert'
vim.api.nvim_set_keymap('i', '<expr><C-n>', 'pumvisible() ? "<Down>" : "<C-n>"', {noremap = true})
vim.api.nvim_set_keymap('i', '<expr><C-p>', 'pumvisible() ? "<Up>" : "<C-p>"', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-t>', ':NERDTreeToggle<CR>', {noremap = true})

vim.g.airline_extensions_tabline_enabled = 1
vim.api.nvim_set_keymap('n', '<C-p>', '<Plug>AirlineSelectPrevTab', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-n>', '<Plug>AirlineSelectNextTab', {noremap = true})
vim.g.airline_extensions_tabline_buffer_idx_mode = 1
vim.g.airline_extensions_tabline_buffer_idx_format = {
  ['0'] = '0 ',
  ['1'] = '1 ',
  ['2'] = '2 ',
  ['3'] = '3 ',
  ['4'] = '4 ',
  ['5'] = '5 ',
  ['6'] = '6 ',
  ['7'] = '7 ',
  ['8'] = '8 ',
  ['9'] = '9 ',
}
vim.opt.ttimeoutlen = 50
