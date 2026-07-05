# DeepSearch v12

**DeepSearch** is an advanced Roblox game scanner with staged searching, GitHub-updatable wordbanks, and high-value item detection.

## Features

- Modern clean UI
- Staged + prioritized scanning system
- Full and Lite versions (manual selection)
- High-value item detection with explanations
- GitHub wordbank support (`main.json` + `priority.json`)
- Executor detection + username info on startup
- RightShift keybind to toggle UI
- Performance mode + AutoSave logs
- Strong error handling

## How to Use

1. Edit `main.lua` and choose `"full"` or `"lite"`
2. Execute `main.lua` using your executor
3. Press **RightShift** to show/hide the UI
4. Use the sidebar buttons or command bar

## Wordbanks

- `wordbanks/main.json` — General scanning keywords
- `wordbanks/priority.json` — High priority exploitable items (recommended)

## Updating

Simply update the JSON files in the `wordbanks` folder and push to GitHub. No need to change the main script.

## Version

Current version: **v12**
