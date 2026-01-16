# Bedrock Ghost - Simple Inline AI Completion for Neovim

Ultra-minimal Copilot-style inline suggestions powered by AWS Bedrock Claude.

## Features

- ✅ Ghost text suggestions (gray inline text)
- ✅ Manual trigger only (no auto-suggestions)
- ✅ AWS Bedrock Claude integration
- ✅ Reuses existing AWS credentials
- ✅ Simple: 3 files, ~170 lines of code

## Usage

### Keybindings

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<Leader>ai` | Normal | Request completion | Ask Bedrock for code suggestion |
| `<C-Space>` | **Insert** | Request completion | **Trigger from INSERT mode (recommended!)** |
| `<Tab>` | Insert | Accept | Insert ghost text and continue typing |
| `<C-]>` | Insert | Dismiss | Clear ghost text without accepting |
| `<Esc>` | Normal | Dismiss | Clear ghost text |

### Workflow

**From INSERT mode (recommended):**
1. While typing, press `<Ctrl+Space>`
2. **Stay in INSERT mode** - ghost text appears
3. Press `<Tab>` to accept → text inserted, **stays in INSERT mode**
4. OR press `<Ctrl+]>` to dismiss → ghost cleared, stays in INSERT mode
5. Continue typing naturally

**Auto-dismiss:**
- Ghost text auto-clears when you continue typing (ignoring suggestion)
- Ghost text auto-clears when switching buffers
- No ghost text pollution across requests

**From NORMAL mode:**
1. Position cursor where you want completion
2. Press `<Leader>ai` (`,ai` by default)
3. Wait 1-3 seconds for ghost text to appear
4. Press `<Esc>` to dismiss

## Configuration

Default settings (in `lua/plugins/init.lua`):

```lua
{
    'bedrock_ghost',
    dir = vim.fn.stdpath('config') .. '/lua/bedrock_ghost',
    config = function()
        require('bedrock_ghost').setup({
            model = 'us.anthropic.claude-haiku-4-5-20251001-v1:0',
            region = 'us-east-1',
            max_tokens = 512,
            keymaps = {
                request = '<Leader>ai',
                accept = '<Tab>',
                dismiss = '<Esc>',
            },
        })
    end,
}
```

## Requirements

- Neovim 0.10+
- curl 8.0+ (with `--aws-sigv4` support)
- AWS credentials configured (via `config/aws-credentials.lua`)

## Architecture

```
bedrock_ghost/
├── init.lua         # Setup, keybindings, entry points
├── completion.lua   # Bedrock API calls via curl
└── ghost.lua        # Virtual text display/accept/dismiss
```

## How It Works

1. **Request** (`<Leader>ai` or `<Ctrl+Space>`): 
   - Splits buffer at cursor into PREFIX (before) and SUFFIX (after)
   - Sends structured prompt to Bedrock with few-shot examples
   - Uses industry-standard PREFIX/SUFFIX format (like Copilot)
   
2. **Display**: Shows completion as gray ghost text below cursor

3. **Accept** (`<Tab>`): Inserts ghost text at cursor

4. **Dismiss** (`<Esc>`): Clears ghost text

### Technical Details

**Context Format:**
```
PREFIX: "function fibona"
SUFFIX: "\n\nif __name__ == '__main__':"
```

**Prompt Strategy:**
- Clear PREFIX/SUFFIX separation (prevents buffer repetition)
- Few-shot examples showing expected format
- Explicit instructions: "Do NOT repeat PREFIX code"
- Filetype context for language-specific completion

**Response Cleaning:**
- Strips markdown code blocks (```lang```)
- Removes XML tags
- Removes common labels (PREFIX:, OUTPUT:, etc.)
- Trims whitespace

## Cost Considerations

- **Manual trigger only** = Low cost
- Uses Claude Haiku (cheapest model)
- ~$0.02-0.03 per hour of active coding
- ~$3-5 per month for typical usage

## Troubleshooting

**No ghost text appears:**
- Check AWS credentials: `:lua print(require('config.aws-credentials').get_bedrock_keys())`
- Check curl version: `curl --version` (must be 8.0+)
- Check notifications for error messages

**Ghost text doesn't accept:**
- Make sure ghost text is visible before pressing `<Tab>`
- Try `<Esc>` to dismiss, then request again

## License

Same as parent Neovim config (assumed MIT).
