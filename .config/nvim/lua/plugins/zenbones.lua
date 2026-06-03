return {
  {
    "zenbones-theme/zenbones.nvim",
    -- zenbones uses lush to define its palette
    dependencies = "rktjmp/lush.nvim",
    priority = 1000,
    -- zenbones is "auto": light variant on light background, dark on dark
    -- kept installed as a fallback; mellifluous.lua sets the active colorscheme
  },
}
