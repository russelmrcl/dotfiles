# Git & SSH Setup

Identity, defaults, and SSH keys for GitHub & GitLab.

---

## 1. Install & Identity

macOS ships Git with the Xcode Command Line Tools. To get a current version:

```bash
brew install git
```

Set who you are. **Without this, commits carry a wrong or empty author** (and GitHub won't attribute them to you):

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Use the email that is verified on your GitHub / GitLab account. To keep it private, use the `…@users.noreply.github.com` address from [github.com/settings/emails](https://github.com/settings/emails).

---

## 2. Recommended Defaults

```bash
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global push.autoSetupRemote true
git config --global fetch.prune true
git config --global rerere.enabled true
git config --global core.editor "vim"
```

| Setting                     | Why                                                  |
| --------------------------- | ---------------------------------------------------- |
| `init.defaultBranch main`   | New repos start on `main`                            |
| `pull.rebase true`          | `git pull` rebases instead of creating merge commits |
| `push.autoSetupRemote true` | First `git push` sets the upstream automatically     |
| `fetch.prune true`          | Deleted remote branches disappear locally            |
| `rerere.enabled true`       | Git remembers conflict resolutions                   |
| `core.editor`               | Editor for commit messages and rebases               |

Global ignore for macOS noise:

```bash
echo ".DS_Store" >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
```

Verify:

```bash
git config --global --list
```

---

## 3. Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

Press `Enter` to accept the default path (`~/.ssh/id_ed25519`). Set a passphrase.

---

## 4. Add Key to SSH Agent & Keychain

Tell SSH to load the key automatically and store the passphrase in the macOS Keychain, so you only enter it once:

```bash
mkdir -p ~/.ssh && touch ~/.ssh/config
cat >> ~/.ssh/config <<'EOF'
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
```

Add the key now:

```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

---

## 5. Copy Your Public Key

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

The key is now in your clipboard.

---

## 6. Add to GitHub

1. Go to [github.com/settings/keys](https://github.com/settings/keys)
2. Click **New SSH key**
3. Paste your public key → **Add SSH key**

Test connection:

```bash
ssh -T git@github.com
# Hi username! You've successfully authenticated.
```

---

## 7. Add to GitLab

1. Go to [gitlab.com/-/profile/keys](https://gitlab.com/-/profile/keys)
2. Paste your public key → **Add key**

Test connection:

```bash
ssh -T git@gitlab.com
# Welcome to GitLab, @username!
```

---

## 8. Use SSH Remotes

Always clone with SSH:

```bash
# GitHub
git clone git@github.com:user/repo.git

# GitLab
git clone git@gitlab.com:user/repo.git
```

Fix an existing HTTPS remote:

```bash
git remote set-url origin git@github.com:user/repo.git
```

---

## Verify

```bash
git config --global user.name    # your name
git config --global user.email   # your email
ssh -T git@github.com            # authenticated
```

---

## Troubleshooting

**Commits show the wrong author:**

```bash
git config --global user.name
git config --global user.email
git config user.email   # a repo-local value overrides the global one
```

**Permission denied:**

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

**Check which key is being used:**

```bash
ssh -vT git@github.com
```

**List loaded keys:**

```bash
ssh-add -l
```
