# Neovim Cache and Data Cleanup Guide

## Neovim Cache and Data Directories

### Primary Cache Locations
1. **`~/.cache/nvim/`** - Main cache directory ✅ **ALREADY REMOVED**
   - Lua bytecode cache
   - Plugin caches
   - Tree-sitter compiled parsers

2. **`~/.local/share/nvim/`** - Data directory (contains important data)
   - **`lazy/`** - Lazy.nvim plugin installations
   - **`mason/`** - Mason tool installations  
   - **`site/`** - Site-specific plugins
   - **`swap/`** - Swap files (if not redirected)
   - **`shada/`** - Shared data (history, registers, etc.)

3. **`~/.local/state/nvim/`** - State directory
   - **`lsp.log`** - LSP server logs
   - **`log`** - Neovim logs
   - **`shada/`** - Additional shared data

### Custom Cache Locations (Our Config)
4. **`~/.config/nvim/tmp/`** - Our custom temp directory
   - **`backup/`** - Backup files
   - **`undo/`** - Undo history files
   - **`swap/`** - Swap files (redirected here)

## Nuclear Cleanup Strategy

### Step 1: Complete Cache Removal
```bash
# Already done
rm -rf ~/.cache/nvim/

# Remove state data (logs, etc.)
rm -rf ~/.local/state/nvim/

# Remove our custom temp directory
rm -rf ~/.config/nvim/tmp/
```

### Step 2: Plugin Fresh Install
```bash
# Remove all plugins (will be reinstalled)
rm -rf ~/.local/share/nvim/lazy/

# Remove Mason tools (will be reinstalled)
rm -rf ~/.local/share/nvim/mason/

# Remove site plugins (if any)
rm -rf ~/.local/share/nvim/site/
```

### Step 3: Optional - Reset Everything
```bash
# NUCLEAR OPTION: Remove entire nvim data directory
# WARNING: This removes ALL nvim data including history, registers, etc.
rm -rf ~/.local/share/nvim/
```

## Safe Cleanup Procedure

### Phase 1: Cache Only (Safest)
```bash
# Remove caches but keep data
rm -rf ~/.cache/nvim/
rm -rf ~/.local/state/nvim/
rm -rf ~/.config/nvim/tmp/
```

### Phase 2: Plugin Reset
```bash
# Remove plugin installations
rm -rf ~/.local/share/nvim/lazy/
rm -rf ~/.local/share/nvim/mason/
```

### Phase 3: Complete Reset (Nuclear)
```bash
# Remove all nvim data (WARNING: loses history, registers, etc.)
rm -rf ~/.local/share/nvim/
```

## Verification Commands

### Check What Exists
```bash
# Check cache directories
ls -la ~/.cache/ | grep nvim
ls -la ~/.local/state/ | grep nvim
ls -la ~/.local/share/ | grep nvim

# Check our custom directories
ls -la ~/.config/nvim/tmp/

# Check plugin directories specifically
ls -la ~/.local/share/nvim/lazy/
ls -la ~/.local/share/nvim/mason/
```

### After Cleanup Verification
```bash
# Should return "No such file or directory" after cleanup
ls ~/.cache/nvim/
ls ~/.local/state/nvim/
ls ~/.local/share/nvim/lazy/
ls ~/.local/share/nvim/mason/
ls ~/.config/nvim/tmp/
```

## Reinstallation Process

### Step 1: Start Neovim
```bash
nvim
```

### Step 2: Plugin Installation
- Lazy.nvim will automatically detect missing plugins
- Run `:Lazy sync` to install all plugins

### Step 3: Mason Tools Installation  
- Run `:Mason` to check tools
- LSP servers should auto-install due to our `ensure_installed` config
- May need to run `:MasonInstallAll` or manually install

### Step 4: Verification
- Test YAML file opening
- Check if RPC error persists
- Verify LSP servers working

## Expected Behavior After Cleanup

### Immediate Effects
- All plugins will be downloaded fresh
- All LSP servers will be downloaded fresh
- No cached data or compiled bytecode
- Fresh tree-sitter parsers

### What Should Be Fixed
- Any corrupted cache data
- Any problematic plugin states
- Any conflicting compiled modules
- Any stale configuration caches

### What Won't Be Fixed
- Configuration errors in our Lua files
- Plugin configuration conflicts
- Fundamental logic errors

## Risk Assessment

### Low Risk Operations
- `~/.cache/nvim/` removal ✅ **DONE**
- `~/.local/state/nvim/` removal (just logs)
- `~/.config/nvim/tmp/` removal (our temp files)

### Medium Risk Operations  
- `~/.local/share/nvim/lazy/` removal (plugins need reinstall)
- `~/.local/share/nvim/mason/` removal (tools need reinstall)

### High Risk Operations
- `~/.local/share/nvim/` complete removal (loses ALL nvim data)

## Testing Strategy

### Test 1: Cache Cleanup Only
1. Remove cache directories
2. Restart nvim
3. Test YAML file
4. Check if error persists

### Test 2: Plugin Fresh Install
1. Remove lazy/ and mason/ directories  
2. Restart nvim
3. Reinstall everything
4. Test YAML file

### Test 3: Nuclear Option
1. Remove entire nvim data directory
2. Complete fresh start
3. Test YAML file

---

**Recommended Approach**: Start with Test 1 (cache only), then Test 2 (plugin reset) if needed.