return {
  "zbirenbaum/copilot.lua",
  optional = true,
  opts = function()
    -- temp fix https://github.com/LazyVim/LazyVim/issues/5899#issuecomment-278139803
    require("copilot.api").status = require("copilot.status")
  end,
}
