# nvim-keys

> My Neovim key bindings, for someone coming from VS Code. Leader is `Space`.
> "(mine)" marks bindings from my config; the rest are Neovim or plugin defaults.
> Press `Space` and wait to see every leader binding (which-key).

- Move by character / word / line start / line end (no mouse, no arrows):

`{{h}} {{j}} {{k}} {{l}}  /  {{w}} {{b}}  /  {{0}} {{^}}  /  {{$}}`

- Go to the top / bottom of the file / to line N:

`{{gg}} / {{G}} / {{N}}{{G}}`

- Jump half a page down / up, keeping the cursor centered:

`{{Ctrl d}} / {{Ctrl u}}`

- Jump to any visible text, VS Code's "go to anywhere" (mine, flash):

`{{s}} {{two or three letters}} {{label}}`

- Select the syntax node around the cursor and grow it (mine, flash):

`{{S}} {{label}}`

- Enter insert mode before / after the cursor / on a new line below / above:

`{{i}} / {{a}} / {{o}} / {{O}}`

- Leave insert mode and clear search highlight (mine):

`{{Esc}}`

- Select text: character / line / block; then act on it (`d` delete, `y` copy, `>` indent):

`{{v}} / {{V}} / {{Ctrl v}}`

- Delete / change / copy a word, a line, or inside quotes or brackets:

`{{dw}} {{dd}} {{di"}}  /  {{cw}} {{cc}} {{ci(}}  /  {{yw}} {{yy}} {{yi{}}`

- Paste / undo / redo / repeat the last change:

`{{p}} / {{u}} / {{Ctrl r}} / {{.}}`

- Search in the file, next / previous match, word under cursor:

`{{/}}{{text}} {{Enter}}  /  {{n}} / {{N}}  /  {{*}}`

- Find and replace in the file (VS Code Ctrl+H):

`:{{%s/old/new/gc}}`

- Save / close the window / quit everything (mine for the first two):

`{{Space w}} / {{Space q}} / :{{qa}}`

- Find a file by name, VS Code Ctrl+P (mine, telescope):

`{{Space ff}}`

- Search text across the project, VS Code Ctrl+Shift+F (mine, telescope):

`{{Space fg}}`

- Switch between open buffers (VS Code tabs) / search the help (mine, telescope):

`{{Space fb}} / {{Space fh}}`

- Inside a telescope list: move / open / open in split / vertical split / close:

`{{Ctrl n}} {{Ctrl p}}  /  {{Enter}}  /  {{Ctrl x}}  /  {{Ctrl v}}  /  {{Esc}}`

- Toggle the file tree sidebar / reveal the current file in it (mine, nvim-tree):

`{{Space e}} / {{Space E}}`

- In the file tree: add / rename / delete / copy / cut / paste / show help:

`{{a}} / {{r}} / {{d}} / {{c}} / {{x}} / {{p}} / {{g?}}`

- Edit the current directory like a text buffer; `:w` applies renames and deletes (mine, oil):

`{{-}}`

- Next / previous buffer, close buffer:

`:{{bn}} / :{{bp}} / :{{bd}}`

- Focus the split to the left / below / above / right (mine):

`{{Ctrl h}} {{Ctrl j}} {{Ctrl k}} {{Ctrl l}}`

- Split the window side by side / stacked:

`:{{vsplit}} / :{{split}}`

- Go to definition / references / implementation / type definition:

`{{gd}} (mine)  /  {{grr}}  /  {{gri}}  /  {{grt}}`

- Show docs for the symbol under the cursor (VS Code hover):

`{{K}}`

- Rename the symbol / code action (VS Code quick fix, Ctrl+.):

`{{grn}} / {{gra}}`

- Show signature help while typing arguments:

`{{Ctrl s}}` (insert mode)

- Jump to the next / previous diagnostic, show the one under the cursor:

`{{]d}} / {{[d}}  /  {{Ctrl w d}}`

- Open the diagnostics list for the project / the current file / quickfix (mine, trouble):

`{{Space xx}} / {{Space xb}} / {{Space xq}}`

- Format the buffer (mine; Python via ruff and Lua via stylua also format on save):

`{{Space cf}}`

- Accept / move through the completion menu, Tab for snippets in LaTeX (mine):

`{{Ctrl y}} / {{Ctrl n}} {{Ctrl p}}  /  {{Tab}}`

- Next / previous git hunk, preview it, reset it, blame the line (mine, gitsigns):

`{{]h}} / {{[h}}  /  {{Space gp}}  /  {{Space gr}}  /  {{Space gb}}`

- Run the current Python file with uv in a split below (mine):

`{{Space rr}}`

- Open a terminal in a split / leave terminal mode back to normal mode:

`:{{terminal}}  /  {{Ctrl \ Ctrl n}}`

- Compile / view the PDF of a LaTeX file (mine, vimtex):

`{{Space ll}} / {{Space lv}}`

- Open the plugin manager, update plugins / check LSP servers:

`:{{Lazy}} {{then}} {{S}}  /  :{{checkhealth vim.lsp}}`

- Look up any command or key in the built-in help:

`:{{help}} {{topic}}`
