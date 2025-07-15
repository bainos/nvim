# Neovim Drumtab Plugin - PRD

## 1. Project Overview
The **Neovim Drumtab Plugin** is a Lua-based plugin designed to help drummers write simple drum tabs easily within Neovim. The plugin aims to provide an efficient workflow for generating, editing, and converting drum tabs into **LilyPond** notation.

## 2. Use Cases
The primary audience for this plugin consists of **Nerd Drummers** who:
- Prefer writing and reading drum sheets in a text-based format.
- Want to quickly generate structured drum tabs.
- Need an easy way to convert drum tabs into **LilyPond** notation for engraving.

## 3. Features & Functionality
The plugin will be implemented in three stages:

### 3.1 Basic Drum Tab Rendering in Neovim
- Generate empty drum tabs based on input parameters (e.g., measures and subdivisions).
- Render the drum tab as text in a Neovim buffer.
- Provide commands and keybindings to add/edit drum notes efficiently.

### 3.2 Parsing Drum Tabs into Lua Structures
- Implement a parser to convert drum tab text into a structured Lua table representation.
- Ensure a simple and intuitive mapping between text-based drum notation and the Lua structure.

### 3.3 Converting Drum Tabs to LilyPond
- Generate LilyPond-compatible output from the parsed Lua structure.
- Avoid using external LilyPond-related libraries to keep the implementation lightweight.
- Focus on **simple drum rhythms**, avoiding advanced rhythmic complexities in the initial release.

## 4. User Interface & Experience
- The plugin should integrate seamlessly into Neovim, following established UX patterns for Neovim plugins.
- Interaction will primarily rely on **commands and keybindings**.
- Optional configuration via a Lua setup function.

## 5. Technical Details
- Written in **Lua**.
- No external dependencies beyond Neovim’s built-in Lua runtime.
- Follows best practices for Neovim plugin development.
- The LilyPond export functionality will generate a `.ly` file directly within Neovim.

## 6. Examples & Edge Cases
- Many drum tab examples are available online and can be used for testing.
- Edge cases (e.g., polyrhythms, tuplets, nested groupings) **will not** be handled in the initial version.

## 7. Future Enhancements
- Support for embedding drum tabs within Markdown as "code snippets" with a dedicated `drumtab` type.
- Convert Markdown documents containing drum tabs into a **LilyPond book** (PDF output).
- Expand support for more advanced rhythmic notation over time.


