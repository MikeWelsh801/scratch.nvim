local M = {}

local cleared = false

local function close_win(win)
    if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
        cleared = false
    end
end

local function clear_window(win, buf)
    if cleared then
        return
    end

    local win_height = vim.api.nvim_win_get_height(win)
    local lines = {}

    for _ = 1, win_height do
        table.insert(lines, "")
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    cleared = true
end

function M.create_poop_float()
    -- Get the editor's dimensions
    local width = vim.o.columns
    local height = vim.o.lines

    -- Calculate window size (80% of screen)
    local win_height = math.floor(height * 0.85)
    local win_width = math.floor(width * 0.95)

    -- Calculate starting position for center alignment
    local row = math.floor((height - win_height) / 3)
    local col = math.floor((width - win_width) / 2)

    -- Create buffer for the floating window
    local buf = vim.api.nvim_create_buf(false, true)

    -- ASCII art poop
    local ascii_poop = {
        '            ⡶⣤',
        '           ⣰⠃⢸⡀',
        '        ⣠⡴⠟⠁⠀⠈⠳⠦⣤⣀',
        '       ⢰⡟⠀⠀⠀⠐⠼⢟⣲⡐⠈⣻⣤⣤⣀',
        '       ⢸⣇⠐⠀⢀⠀⠀⠀⠀⡉⠉⠉⢠⡘⠙⣿⣦⡀',
        '      ⢀⣠⣿⣦⡀⠈⠐⠀⠄⠀⠀⠀⠀⠀⣀⣀⢈⠘⣧',
        '    ⣠⡾⠋⠁⣠⠌⠉⠓⠒⠀⠀⠀⠀⠐⠊⠊⠇⠿⠀⣀⣿',
        '   ⣼⠯⣷⡀⡜⢡⠆⠰⠂⠀⠀⠀⠀⠒⠦⠄⠌⠙⠲⢻⠉⡿⢶⣤⣀',
        '   ⣿⣾⠟⢠⠇⢩⠃⠀⠀⠀⠀⠀⠀⠤⠃⠀⠀⠀⠀⠀⠹⣄⠀⡈⠙⣷⡄',
        ' ⢀⣴⠟⡋⠁⠀⠀⠀⠀⠀⠀⣰⠓⡀⠠⠀⠀⠀⠀⠀⠀⠀⠀⢀⡈⡆⠳⣌⢸⣷',
        ' ⣰⡟⠱⠡⠃⠐⠂⡄⠀⠀⠠⠄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠆⢹⣴⣀⣳⣷⣶⠾⠟⠛⢷⣄',
        '⢰⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠉⠉⣉⡙⡛⠛⠛⠛⠛⠋⠉⠉⠀⠀⠀⢣⡑⠈⢻⡆',
        '⢸⡇⢹⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠁⠀⠀⡀⢰⢠⠀⡆⠀⠆⠀⡄⢄⢶⠼⣿',
        '⠹⣷⡀⠘⡟⡆⡄⡀⠀⠀⠀⢀⠀⠀⠰⠀⠀⠀⠀⠐⣶⠄⡇⠾⠘⠀⢉⡄⢠⢧⢧⢸⠀⣰⡟⢀',
        '⢀⣼⣷⡄⠀⣡⠁⢀⠈⡀⠀⠈⠐⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠃⠘⠢⠘⠊⢈⣡⠴⠋⡀⠋⡰⠃⡄',
        '⢸⠕⢋⡽⠻⣶⣅⣇⠈⠰⠁⡇⠄⢰⠀⠀⠀⠀⠠⢠⣴⠠⠀⠃⠀⠀⢀⣀⣤⠔⡨⢔⡾⢣⠞⢠⠞⢀⡜⠁',
        '⠈⠁⠀⠚⠉⠉⠛⠛⠛⠓⠒⠒⠶⠦⠤⠤⠤⠤⠶⠶⠒⠒⠊⠭⠉⠍⠂⠈⠋⠀⠋⠐⠁⠘⠁⠀⠊⠀⠈'
    }
    local lines = {}
    local v_pad = math.floor((win_height - table.getn(ascii_poop)) / 2)
    -- Add some blank lines at the top for vertical centering
    for _ = 1, v_pad / 2 do
        table.insert(lines, "")
    end

    local h_padding = string.rep(" ", math.floor(win_width - #ascii_poop[3]) / 2)

    -- Add each line of the ASCII art with horizontal centering
    for _, line in ipairs(ascii_poop) do
        table.insert(lines, h_padding .. line .. h_padding)
    end

    for _ = 1, v_pad / 2 do
        table.insert(lines, "")
    end
    local close = "Press q to close"
    h_padding = string.rep(" ", math.floor(win_width - #close) / 2)
    table.insert(lines, h_padding .. close)

    -- Set buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)

    -- Configure window options
    local opts = {
        title = "Scratch Paper",
        title_pos = "center",
        relative = "editor",
        row = row,
        col = col,
        width = win_width,
        height = win_height,
        style = "minimal",
        border = "rounded",
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Create autocommands to close the window
    local augroup = vim.api.nvim_create_augroup('PoopFloat', { clear = true })


    -- Close on insert mode
    vim.api.nvim_create_autocmd('InsertEnter', {
        group = augroup,
        callback = function()
            if vim.api.nvim_win_is_valid(win) then
                clear_window(win, buf)
            end
        end
    })

    -- Use BufLeave and WinLeave to force focus back
    vim.api.nvim_create_autocmd({'BufLeave', 'WinLeave'}, {
        group = augroup,
        buffer = buf,
        callback = function()
            vim.schedule(function()
                if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_set_current_win(win)
                    -- Lock the cursor in the window
                    vim.cmd('lockmarks normal! G')
                    vim.api.nvim_win_set_cursor(win, {1, 0})
                end
            end)
        end
    })

    vim.api.nvim_buf_create_user_command(buf, "Quit", function () close_win(win) end, {})
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ":Quit<CR>", {})
end

return M
