# RPC Error Resolution - Major Bug Fix

## Issue Summary
**Date**: 2025-01-11  
**Duration**: 1+ year persistent issue  
**Impact**: RPC errors when opening YAML files disrupting workflow

## Problem Description
Persistent error when opening YAML files:
```
Error executing vim.schedule lua callback: RPC[Error] code_name = InternalError, 
message = "Request initialize failed with message: [UriError]: Scheme is missing: 
{scheme: "", authority: "", path: "null", query: "", fragment: ""}"
```

## Root Cause Analysis
Through systematic debugging, identified **dual root cause**:

1. **Mason-lspconfig Auto-Start Conflict**
   - `mason-lspconfig.setup()` was auto-starting LSP servers regardless of filetype restrictions
   - Conflicted with manual LSP configuration causing duplicate initialization attempts
   - Ignored custom filetype configurations (e.g., `azure_pipelines_ls` only for `yaml.azure-pipelines`)

2. **Missing Root Directory Detection**
   - LSP servers require valid project root directories for initialization
   - Without proper `root_dir` function, servers received null/malformed URIs
   - Default lspconfig root detection failed in certain scenarios

## Solution Implemented

### Part 1: Separate Mason from LSP Auto-Management
```lua
-- BEFORE (problematic)
require 'mason-lspconfig'.setup {
    ensure_installed = lsp_servers,
    automatic_installation = false,
    handlers = {},  -- This caused auto-start conflicts
}

-- AFTER (solution)
-- Mason used ONLY for installation via :Mason UI
-- LSP configuration handled manually
```

### Part 2: Robust Root Directory Detection
```lua
root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find({'.git', '.hg', '.svn'}, {
        path = fname,
        upward = true
    })[1]) or vim.fn.getcwd()
end,
```

## Debugging Process Documentation
Complete investigation documented in:
- `docs/debug/COMPLETE_SOLUTION.md` - Final comprehensive solution
- `docs/debug/RPC_ERROR_INVESTIGATION.md` - Initial investigation
- `docs/debug/LSP_DISABLE_BREAKTHROUGH.md` - Key debugging breakthrough
- `docs/debug/NUCLEAR_RESET_RESULTS.md` - Plugin reset testing
- `docs/debug/CACHE_CLEANUP_RESULTS.md` - Cache cleanup testing

## Validation Results
- ✅ **RPC errors completely eliminated** on YAML files
- ✅ **All 9 LSP servers working correctly** with proper filetype restrictions
- ✅ **Azure Pipelines/Helm/K8s YAML detection** functioning as intended
- ✅ **No performance impact** or functionality regression

## Configuration Changes
- **Modified**: `lua/config/lsp-config.lua` - Removed Mason auto-start, added proper root_dir
- **Modified**: `lua/plugins/init.lua` - Disabled lazy.nvim checker (minor contributor to error)
- **Added**: Comprehensive debugging documentation in `docs/debug/`

## Impact
- **User Experience**: Eliminated year-long workflow disruption
- **Maintainability**: Cleaner separation between Mason installation and LSP configuration
- **Reliability**: Robust root directory detection prevents future URI scheme issues
- **Documentation**: Extensive troubleshooting knowledge base for future issues

## Lessons Learned
1. **Mason-lspconfig ≠ Manual LSP config**: Should not be mixed
2. **Root directory detection is critical**: LSP servers fail silently without proper roots
3. **Systematic debugging works**: Isolation and elimination revealed exact cause
4. **Documentation is valuable**: Comprehensive records helped track complex debugging process

---

**Status**: ✅ COMPLETELY RESOLVED  
**Cost**: ~$10 debugging investment  
**Value**: Eliminated 1+ year persistent workflow disruption