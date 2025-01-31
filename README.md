# Paper for when you need it most

### Install with lazy
```lua
'MikeWelsh801/scratch.nvim'
```

- If you want a nice keymap to open a piece of paper use:

```lua
{
    'MikeWelsh801/scratch.nvim',
    lazy = true,
    config = function()
        vim.keymap.set('n', '<leader>tp', require("scratch").create_poop_float, {silent = true})
    end
}

```

### To open a piece of paper
- run:
```lua
:PoopFloat
```
