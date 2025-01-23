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

To toggle on and off obfuscation, use `lua require('obfuscate').toggle()`
Or bind it for easier access

Example keybinding:
```lua
vim.keymap.set(
  "n",
  "<C-t>",
  require('obfuscate').toggle,
  { desc = "Toggle Obfuscate", noremap = true, silent = true }
)
```

## TODO
- [ ] Implement user command to toggle obfuscation
