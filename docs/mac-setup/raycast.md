# Raycast

Launcher that replaces Spotlight: apps, files, clipboard history, window management, snippets.

## Install

```bash
brew install --cask raycast
```

Open it once and finish the onboarding.

## Make it the default (⌘ Space)

Spotlight owns ⌘ Space, so free it first.

1. **Disable the Spotlight shortcut**
   _System Settings → Keyboard → Keyboard Shortcuts… → Spotlight_ →
   uncheck **Show Spotlight search** (and **Show Finder search window**, so ⌥⌘ Space is free too).

2. **Assign it to Raycast**
   _Raycast → Settings (⌘ ,) → General → Raycast Hotkey_ → press **⌘ Space**.

3. **Start at login**
   _Raycast → Settings → General → Launch Raycast at login_.

## Verify

Press ⌘ Space: the Raycast bar opens, not Spotlight.

## Worth setting up

| Feature           | Where                              | Tip                                     |
| ----------------- | ---------------------------------- | --------------------------------------- |
| Clipboard history | _Extensions → Clipboard History_   | Assign a hotkey, e.g. ⇧⌘ V              |
| Window management | _Extensions → Window Management_   | Replaces Rectangle if you want one tool |
| Snippets          | _Extensions → Snippets_            | Text expansion for repeated text        |
| Aliases           | _Extensions → select item → Alias_ | e.g. `ch` → Google Chrome               |

## Troubleshooting

**⌘ Space still opens Spotlight**: the Spotlight shortcut is still enabled in step 1, or the menu has a different name on your macOS version (look for "Spotlight" under Keyboard Shortcuts).

**Hotkey conflict warning in Raycast**: another app or an input-source switch uses ⌘ Space; disable it in _Keyboard Shortcuts → Input Sources_.
