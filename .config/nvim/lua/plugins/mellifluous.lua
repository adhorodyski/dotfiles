return {
  {
    "ramojus/mellifluous.nvim",
    priority = 1000,
    -- neutral = true matches the palette the Ghostty "Mellifluous Light" theme
    -- was generated from. No background override: follow the terminal's
    -- light/dark (Neovim auto-detects via OSC 11), same as Ghostty's switch.
    opts = { mellifluous = { neutral = true } },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "mellifluous" },
  },
}
