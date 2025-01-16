# obfuscate.nvim

![Demo](https://github.com/user-attachments/assets/8078ecb4-634a-4bae-a2a2-6e83c4cce2b4)

**obfuscate.nvim** visually obfuscates your top secret code while you are programming in public

## Features
- Partially obfuscate alphabetic characters, leaving symbols and numbers
- Purely visual obfuscation that does not alter the actual content
- Quick real-time toggle

## Installing (lazy.nvim)

```lua
{
  "https://github.com/ck-zhang/obfuscate.nvim",
}
```

## Usage

To toggle on and off obfuscation, use command `:ToggleObfuscate`

Example keybinding:
```lua
vim.api.nvim_set_keymap(
	"n",
	"<C-t>",
	"<cmd>ToggleObfuscate<CR>",
	{ desc = "Toggle Obfuscate", noremap = true, silent = true }
)
```
