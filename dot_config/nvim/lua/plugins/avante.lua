-- Avante.nvim configuration for AWS Bedrock
-- Make sure you've exported BEDROCK_KEYS environment variable first

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Don't pin to specific version for latest features
  opts = {
    -- Set Bedrock as the provider
    provider = "bedrock",

    -- Providers configuration
    providers = {
      -- Bedrock configuration
      bedrock = {
        -- AWS Bedrock model ID - using Claude 3.5 Sonnet
        -- model = "us.anthropic.claude-3-7-sonnet-20250219-v1:0",
        model = "us.anthropic.claude-3-7-sonnet-20250219-v1:0",
        -- Alternative models you can use:
        -- model = "anthropic.claude-3-5-sonnet-20241022-v2:0", -- for non-cross-region
        -- model = "us.anthropic.claude-3-haiku-20240307-v1:0", -- for faster/cheaper responses
        -- model = "cohere.command-r-plus-v1:0", -- if you prefer Cohere

        -- AWS region (should match your BEDROCK_KEYS)
        aws_region = "us-west-2",

        -- Optional: specify AWS profile if not using default
        -- aws_profile = "bedrock",

        -- Request timeout in milliseconds
        timeout = 30000,

        -- Request body configuration
        extra_request_body = {
          -- Temperature for response creativity (0-1)
          temperature = 0,

          -- Maximum tokens in response
          max_tokens = 8192,
        },
      },
    },

    -- Optional: Enable debug mode for troubleshooting
    debug = false,

    -- Mode configuration - "agentic" is recommended for better code planning
    mode = "agentic",

    -- Auto-suggestions configuration
    auto_suggestions = false, -- Set to true if you want real-time suggestions

    -- Behavior settings
    behaviour = {
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false, -- Set true for Cursor-like behavior
      jump_result_buffer_on_finish = false,
    },

    -- File selector provider (choose one)
    selector = {
      provider = "telescope",
      -- Options override for custom providers
      provider_opts = {},
    },

    -- Key mappings
    mappings = {
      ask = "<leader>aa", -- Ask AI about current file
      edit = "<leader>ae", -- Edit with AI
      refresh = "<leader>ar", -- Refresh response

      -- Diff conflict resolution
      diff = {
        ours = "co",
        theirs = "ct",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },

      -- Suggestion controls
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },

    -- Windows configuration
    windows = {
      wrap = true,
      width = 30,
      sidebar_header = {
        align = "center",
        rounded = true,
      },
    },

    -- Optional: Disable specific tools if needed
    -- disabled_tools = { "python", "bash" },

    -- Optional: Web search configuration
    -- web_search_engine = {
    --   provider = "tavily", -- or "serpapi", "google", etc.
    -- },
  },

  -- Build configuration
  build = "make", -- Use "make BUILD_FROM_SOURCE=true" if you want to build from source
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false", -- for Windows

  -- Dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- Optional dependencies
    "nvim-tree/nvim-web-devicons", -- or "echasnovski/mini.icons"
    "hrsh7th/nvim-cmp", -- for autocompletion
    -- File selector dependencies (choose based on your selector provider)
    -- "nvim-telescope/telescope.nvim", -- for telescope selector
    -- "ibhagwan/fzf-lua", -- for fzf selector
    -- "echasnovski/mini.pick", -- for mini.pick selector

    {
      -- Image pasting support
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true, -- Required for Windows
        },
      },
    },

    {
      -- Markdown rendering
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },

  -- Key bindings setup
  keys = {
    {
      "<leader>aa",
      function()
        require("avante.api").ask()
      end,
      desc = "Avante: Ask",
      mode = { "n", "v" },
    },
    {
      "<leader>ae",
      function()
        require("avante.api").edit()
      end,
      desc = "Avante: Edit",
      mode = { "n", "v" },
    },
    {
      "<leader>ar",
      function()
        require("avante.api").refresh()
      end,
      desc = "Avante: Refresh",
      mode = "v",
    },
    {
      "<leader>ac",
      function()
        require("avante").toggle()
      end,
      desc = "Avante: Toggle Chat",
    },
  },
}
