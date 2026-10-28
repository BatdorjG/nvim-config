-- ~/.config/nvim/lua/plugins/mason.lua

return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  opts = {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    -- Add any other custom overrides here:
    -- log_level = vim.log.levels.DEBUG,
    -- max_concurrent_installers = 4,
  },
}
