# Java (SDKMAN)

SDKMAN installs and switches JDKs (and Gradle, Maven, Kotlin, …).

## Install

```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java
```

The installer adds the loader to `~/.zshrc`. If you copied `dotfiles/.zshrc`, it is already there.

## Verify

```bash
sdk version
java -version
```

## Daily use

```bash
sdk list java              # available versions
sdk install java 21.0.5-tem
sdk use java 21.0.5-tem    # this shell only
sdk default java 21.0.5-tem
```

Other tools: `sdk install gradle`, `sdk install maven`.
