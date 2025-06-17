return {
  { "nvim-neotest/neotest-jest", "marilari88/neotest-vitest" },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-jest", "neotest-vitest" } },
    config = function()
      local neotest = require("neotest")

      local function find_nearest_vitest_config_dir()
        local current_dir = vim.fn.expand("%:p:h") -- current buffer dir
        while current_dir ~= "/" do
          if vim.fn.filereadable(current_dir .. "/vitest.config.ts") == 1 then
            return current_dir
          end
          current_dir = vim.fn.fnamemodify(current_dir, ":h")
        end
        return nil
      end

      local function get_root_dir()
        local original_cwd = vim.fn.getcwd()
        local node_modules_dir = find_nearest_vitest_config_dir()
        return node_modules_dir or original_cwd
      end

      ---@diagnostic disable-next-line: missing-fields
      neotest.setup({
        adapters = {
          require("neotest-vitest")({
            vitestCommand = "vitest --disable-console-intercept",
            cwd = get_root_dir(),
            filter_dir = function(name, rel_path, root)
              return name ~= "node_modules"
            end,
          }),
        },
      })
    end,
  },
}
