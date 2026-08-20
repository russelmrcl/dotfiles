# SSH Setup for GitHub & GitLab

---

## 1. Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

When prompted, you can press `Enter` to accept the default path (`~/.ssh/id_ed25519`) or give it a custom name.

---

## 2. Add Key to SSH Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

## 3. Copy Your Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the entire output.

---

## 4. Add to GitHub

1. Go to [github.com/settings/keys](https://github.com/settings/keys)
2. Click **New SSH key**
3. Paste your public key → **Add SSH key**

Test connection:

```bash
ssh -T git@github.com
# Hi username! You've successfully authenticated.
```

---

## 5. Add to GitLab

1. Go to [gitlab.com/-/profile/keys](https://gitlab.com/-/profile/keys)
2. Paste your public key → **Add key**

Test connection:

```bash
ssh -T git@gitlab.com
# Welcome to GitLab, @username!
```

---

## 6. Use SSH Remotes

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

## Troubleshooting

**Permission denied:**
```bash
ssh-add ~/.ssh/id_ed25519
```

**Check which key is being used:**
```bash
ssh -vT git@github.com
```

**List loaded keys:**
```bash
ssh-add -l
```