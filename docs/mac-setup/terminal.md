# Terminal (Ghostty)

Any terminal works. This repo's config targets [Ghostty](https://ghostty.org/).

## Install

```bash
brew install --cask ghostty
brew install --cask font-hack-nerd-font
```

The Nerd Font provides the icons used by [Starship](starship.md).

## Configure

Copy the repo config:

```bash
mkdir -p ~/.config/ghostty
cp configs/ghostty/config ~/.config/ghostty/config
```

Or set just the font:

```bash
echo 'font-family = "Hack Nerd Font"' >> ~/.config/ghostty/config
```

## Verify

Open a new Ghostty window; text renders in Hack Nerd Font.
