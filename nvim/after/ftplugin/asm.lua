vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4

vim.opt_local.commentstring = "; %s"

vim.keymap.set("n", "<leader>ab", function()
    vim.cmd.write()
    vim.cmd.make()
end, {
    buffer = true,
    desc = "Assembly: build project",
})

vim.keymap.set("n", "<leader>aq", "<cmd>copen<cr>", {
    buffer = true,
    desc = "Assembly: open build errors",
})
