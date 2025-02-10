return {
  "sphamba/smear-cursor.nvim",
  opts = {
    enabled = true,
    stiffness = 0.8,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.5,
    hide_target_hack = false,
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    legacy_computing_symbols_support = false,
  },
  event = "VeryLazy",
}
