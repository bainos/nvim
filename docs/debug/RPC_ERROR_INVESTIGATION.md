# RPC Error Investigation - Comprehensive Debug Report

## Problem Statement
A persistent RPC error occurs when opening YAML files in Neovim, despite extensive configuration changes and complete removal of yamlls. The error suggests URI scheme issues but the root cause remains unidentified.

## Error Details

### Original Error Message
```
Error executing vim.schedule lua callback: ...m-linux-x86_64/share/nvim/runtime/lua/vim/lsp/client.lua:544: RPC[Error] code_name = InternalError, message = "Request initialize failed with message: [UriError]: Scheme is missing: {scheme: \"\", authority: \"\", path: \"null\", query: \"\", fragment: \"\"}"
stack traceback:
        [C]: in function 'assert'
        ...m-linux-x86_64/share/nvim/runtime/lua/vim/lsp/client.lua:544: in function ''
        vim/_editor.lua: in function <vim/_editor.lua:0>
        [C]: in function 'wait'
        ...oder/.local/share/nvim/lazy/lazy.nvim/lua/lazy/async.lua:113: in function 'wait'
        ...al/share/nvim/lazy/lazy.nvim/lua/lazy/manage/process.lua:235: in function <...al/share/nvim/lazy/lazy.nvim/lua/lazy/manage/process.lua:232>
        [C]: in function 'pcall'
        ....local/share/nvim/lazy/lazy.nvim/lua/lazy/manage/git.lua:192: in function 'get_tag_refs'
        ....local/share/nvim/lazy/lazy.nvim/lua/lazy/manage/git.lua:161: in function 'ref'
        ....local/share/nvim/lazy/lazy.nvim/lua/lazy/manage/git.lua:149: in function <....local/share/nvim/lazy/lazy.nvim/lua/lazy/manage/git.lua:118>
        [C]: in function 'pcall'
        ...al/share/nvim/lazy/lazy.nvim/lua/lazy/manage/checker.lua:43: in function 'fast_check'
        ...al/share/nvim/lazy/lazy.nvim/lua/lazy/manage/checker.lua:15: in function 'start'
        ...local/share/nvim/lazy/lazy.nvim/lua/lazy/core/config.lua:345: in function ''
        vim/_editor.lua: in function ''
        vim/_editor.lua: in function <vim/_editor.lua:0>
```

### Key Characteristics
- **Trigger**: Only occurs when opening YAML files (*.yml, *.yaml)
- **Frequency**: Consistent reproduction on every YAML file open
- **Error Type**: RPC[Error] with InternalError code_name
- **URI Issue**: "Scheme is missing" with null path
- **Stack Trace**: Involves lazy.nvim git operations (get_tag_refs, git.lua)

## Investigation Timeline

### Phase 1: Initial yamlls Suspicion
**Hypothesis**: yamlls LSP server causing URI parsing errors
**Actions Taken**:
- Removed yamlls from ensure_installed list
- Disabled yamlls in LSP configuration
- Added yamlls blocking handlers in mason-lspconfig

**Result**: Error persisted

### Phase 2: Complete yamlls Elimination
**Hypothesis**: Residual yamlls configuration or auto-start
**Actions Taken**:
- Completely removed yamlls from all configurations
- Added `lspconfig.yamlls = nil` and `require('lspconfig.configs').yamlls = nil`
- Created autocmd to kill any yamlls instances that auto-start
- Verified yamlls binary not installed globally

**Result**: Error persisted

### Phase 3: LSP Configuration Investigation
**Hypothesis**: LSP configuration or mason causing conflicts
**Actions Taken**:
- Temporarily disabled ALL LSP configuration
- Disabled mason-tool-installer plugin
- Disabled vim-helm plugin
- Added LSP start debugging hooks

**Result**: When ALL LSP disabled, error disappeared; when re-enabled, error returned

### Phase 4: Filetype Association Focus
**Hypothesis**: Filetype detection causing LSP auto-start
**Actions Taken**:
- Implemented autocmd-based filetype detection
- Successfully got azure_pipelines_ls, helm_ls working correctly
- Verified correct filetype assignment (yaml.azure-pipelines, helm, yaml.kubernetes)

**Result**: Filetype association working, but RPC error persists

### Phase 5: Current State Analysis
**Current Findings**:
- Error occurs with YAML files regardless of specific filetype
- No LSP servers auto-starting inappropriately
- azure_pipelines_ls and helm_ls work correctly when triggered
- Error NOT present in `/home/coder/.local/state/nvim/lsp.log`
- Error contains lazy.nvim stack trace references

## Technical Analysis

### Error Dissection
```
RPC[Error] code_name = InternalError
message = "Request initialize failed with message: [UriError]: Scheme is missing: {scheme: \"\", authority: \"\", path: \"null\", query: \"\", fragment: \"\"}"
```

**Observations**:
- RPC error suggests client-server communication failure
- URI error indicates malformed file path or URL
- "path: null" suggests something is passing null instead of a valid file path
- Initialize request failure suggests LSP server startup issue

### Stack Trace Analysis
**Key Components in Stack Trace**:
- `vim/lsp/client.lua:544` - LSP client initialization
- `lazy.nvim/lua/lazy/async.lua` - Lazy.nvim async operations
- `lazy.nvim/lua/lazy/manage/git.lua` - Git operations (get_tag_refs, ref)
- `lazy.nvim/lua/lazy/manage/checker.lua` - Plugin checking
- `lazy.nvim/lua/lazy/core/config.lua` - Core lazy configuration

**Hypothesis**: The error might be triggered by lazy.nvim's plugin checking/git operations that somehow interfere with LSP initialization when YAML files are opened.

## Current Configuration State

### LSP Servers Active
- bashls
- lua_ls
- rust_analyzer
- dockerls
- terraformls
- azure_pipelines_ls (for yaml.azure-pipelines)
- pyright
- marksman
- helm_ls (for helm)

### Filetype Detection (Working)
- `*.yml` → `yaml.azure-pipelines` → `azure_pipelines_ls`
- `values*.yaml` → `yaml.helm-values` → `helm_ls`
- `*/templates/*.yaml`, `*/templates/*.tpl` → `helm` → `helm_ls`
- `*/resources/*.yaml` → `yaml.kubernetes` (no LSP)

### Mason Packages Installed
- azure-pipelines-language-server
- bash-language-server
- dockerfile-language-server
- helm-ls
- lua-language-server
- marksman
- prettier (orphaned)
- prettierd (orphaned)
- pyright
- ruff (orphaned)
- rust-analyzer
- shfmt (orphaned)
- terraform-ls

## Hypotheses for Further Investigation

### Hypothesis A: Lazy.nvim Plugin Checker Interference
**Theory**: Lazy.nvim's background plugin checking triggers git operations that somehow interfere with LSP initialization for YAML files.

**Evidence**:
- Stack trace shows lazy.nvim git operations
- Error only occurs with YAML files
- Error disappears when LSP completely disabled

**Test Strategy**:
- Disable lazy.nvim checker temporarily
- Check if error persists
- Investigate lazy.nvim configuration options

### Hypothesis B: Background Process URI Handling
**Theory**: Some background process (possibly lazy.nvim or another plugin) is making RPC calls with malformed URIs when YAML files are opened.

**Evidence**:
- "path: null" in error message
- RPC error suggests client-server communication
- Error not in LSP logs (suggesting non-LSP RPC)

**Test Strategy**:
- Add more granular RPC debugging
- Check for non-LSP RPC processes
- Investigate vim.schedule callbacks

### Hypothesis C: Git Repository Context Issues
**Theory**: The error is related to git operations in the current repository context when YAML files are opened.

**Evidence**:
- Working directory is a git repository
- Stack trace shows git operations (get_tag_refs)
- Error might be related to repository state

**Test Strategy**:
- Test in non-git directory
- Test with different git repository
- Check git repository health

### Hypothesis D: Plugin Configuration Conflict
**Theory**: A plugin (possibly vim-helm or another) is conflicting with YAML file handling.

**Evidence**:
- Error specific to YAML files
- Complex plugin ecosystem
- vim-helm plugin specifically handles YAML

**Test Strategy**:
- Systematically disable plugins one by one
- Test minimal configuration
- Check plugin load order

## Environment Details

### System Information
- **OS**: Linux 5.10.228-219.884.amzn2.x86_64
- **Neovim**: Running in CodeSpaces environment
- **Working Directory**: `/home/coder/workspaces/projects/musixmatch-ai-salus` (git repository)
- **Date**: 2025-01-11

### File Context
- **Current file tested**: `mxm-salus-console-v2/ci/azure-pipeline-saluscluster-dev.yml`
- **File type detected**: `yaml.azure-pipelines`
- **LSP attached**: `azure_pipelines_ls` (working correctly)
- **Error occurrence**: Consistent on file open

### Git Repository Context
- **Repository**: musixmatch-ai-salus
- **Current branch**: feat/copilot-chat
- **Repository health**: Clean (no uncommitted changes)
- **YAML files in repo**: Multiple Azure Pipeline files, Helm values, K8s manifests

## Next Steps for Investigation

1. **Lazy.nvim Configuration Analysis**
   - Review lazy.nvim checker settings
   - Test with checker disabled
   - Investigate git operation triggers

2. **RPC Call Tracing**
   - Add vim.schedule debugging
   - Trace non-LSP RPC calls
   - Identify source of malformed URI

3. **Minimal Configuration Testing**
   - Test with bare minimum plugin set
   - Systematic plugin elimination
   - Identify specific conflict source

4. **Repository Context Testing**
   - Test in different git repository
   - Test in non-git directory
   - Check repository-specific triggers

## Impact Assessment

### Current Impact
- **Functional**: YAML editing works correctly despite error
- **LSP Services**: All intended LSP servers working properly
- **User Experience**: Error messages are distracting but non-blocking
- **Performance**: No apparent performance impact

### Risk Level
- **Low**: Error does not prevent normal operation
- **Medium**: Potential indicator of underlying configuration issue
- **Low**: Easy to ignore but should be resolved for clean setup

---

**Document Status**: Investigation Phase
**Last Updated**: 2025-01-11
**Next Action**: Systematic hypothesis testing
