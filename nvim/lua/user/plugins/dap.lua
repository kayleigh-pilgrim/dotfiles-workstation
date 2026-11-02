-- Asssembly debugging
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "igorlfs/nvim-dap-view",
                version = "1.*",
            },
        },
        config = function()
            local dap = require("dap")
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = {
                    "--interpreter=dap",
                    -- Match NASM's Intel-style syntax.
                    "--eval-command",
                    "set disassembly-flavor intel",
                    "--eval-command",
                    "set print pretty on",
                },
            }
            local assembly_configurations = {
                {
                    name = "Launch Assembly executable",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input({
                            prompt = "Executable: ",
                            default = vim.fn.getcwd() .. "/",
                            completion = "file",
                        })
                    end,
                    cwd = "${workspaceFolder}",
                    -- Stop at the first machine instruction.
                    -- This is preferable to stopping at main because a
                    -- freestanding Assembly program may only have _start.
                    stopOnEntry = true,
                },
            }
            dap.configurations.asm = assembly_configurations
            dap.configurations.nasm = assembly_configurations
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {
                desc = "Debugger: toggle breakpoint",
            })
            vim.keymap.set("n", "<leader>dc", dap.continue, {
                desc = "Debugger: continue/start",
            })
            vim.keymap.set("n", "<leader>di", dap.step_into, {
                desc = "Debugger: step instruction",
            })
            vim.keymap.set("n", "<leader>do", dap.step_over, {
                desc = "Debugger: step over",
            })
            vim.keymap.set("n", "<leader>dO", dap.step_out, {
                desc = "Debugger: step out",
            })
            vim.keymap.set("n", "<leader>dr", dap.repl.open, {
                desc = "Debugger: open REPL",
            })
            vim.keymap.set("n", "<leader>dv", "<cmd>DapViewOpen<cr>", {
                desc = "Debugger: open view",
            })
            vim.keymap.set("n", "<leader>dV", "<cmd>DapViewClose<cr>", {
                desc = "Debugger: close view",
            })
        end,
    },
}
