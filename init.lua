local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local utils = require("telescope.previewers.utils")
local config = require("telescope.config").values

local log = require("plenary.log"):new()
log.level = 'debug'

local M = {}

M.show_docker_images = function (opts)
  pickers.new(opts, {
    finder = finders.new_async_job({
      command_generator = function ()
        -- command line utility that returns json
        return {"echo"}
      end,

      entry_maker = function (entry)
        local parsed = vim.json.decode(entry)
        if parsed then
          return {
            value = parsed,
            display = parsed.name,
            ordinal = parsed.name,
          }
        end
      end,
    }),
    sorter = config.generic_sorter(opts),

    previewer = previewers.new_buffer_previewer ({
      title = "Docker Image Details",
      define_preview = function (self, entry)
        vim.api.nvim_buf_set_lines(
          self.state.bufnr,
          0,
          0,
          true,
          vim.tbl_flatten({
            "hello",
            "everyone",
            "",
            "```lua",
            vim.split(vim.inspect(entry.value), '\n'),
            "```",
          })
        )
        utils.highlighter(self.state.bufnr, "markdown")
      end,
    }),
  }):find()
end

M.show_docker_images()

return M
