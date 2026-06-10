# dev-setup

Standalone development environment for bioinformatics and computational biology work.
Works on any fresh Debian/Ubuntu machine — no other repos required.

## What's included

- **Shell**: Zsh + Oh My Zsh + Powerlevel10k
- **gh**: GitHub CLI for auth and repo management
- **pixi**: Primary environment and dependency manager (conda-forge + bioconda + PyPI)
- **uv**: Fast Python package installer (used internally by pixi, standalone for pure-Python projects)
- **just**: Command runner for project-level tasks
- **copier**: Project scaffolding with updatable templates
- **ruff**: Linting and formatting (installed per-project via pixi, not globally)
- **prettier**: Code formatter for Nextflow/nf-core repos (global npm install)
- **tldr**: Simplified man pages
- **Docker**: CE + CLI + Compose plugin (no Desktop)
- **nf-core tools**: Nextflow + nf-core + nf-test via pixi environment
- **VSCode**: With GitHub settings sync
- **Brave**: Browser
- **Discord**: Communication

---

## Install on a new machine

```bash
git clone https://github.com/tracelail/dev-setup.git
cd dev-setup
make all
```

### Or install individual components

```bash
make packages   # apt packages + Docker repo setup
make shell      # Zsh + Oh My Zsh + Powerlevel10k
make tools      # pixi, uv, just, copier, prettier, tldr
make nf-core    # Nextflow + nf-core + nf-test pixi environment
make apps       # VSCode, Brave, Discord
```

### See all available commands

```bash
make help
```

---

## Post-install: Required Manual Steps

### 1. GitHub Authentication

```bash
gh auth login
```

Choose GitHub.com → HTTPS → Login with web browser.

### 2. Terminal Font (Powerlevel10k)

- Open Terminal → **Preferences** → Profile → **Text** tab
- Uncheck **"Use the system fixed width font"**
- Choose `MesloLGS NF` or a Powerline font
- Run `p10k configure` to set up your prompt

### 3. VSCode Settings Sync

Sign into VSCode with your GitHub account to pull your synced extensions and settings automatically.

### 4. nf-core Tools

The nf-core environment lives at `~/.nf-core/`. To use it:

```bash
cd ~/.nf-core && pixi run nf-core --help
```

Or add a shell alias:

```bash
alias nf-core="cd ~/.nf-core && pixi run nf-core"
```

### 5. Global Git Config

The install sets `~/.gitignore_global` automatically. Verify with:

```bash
git config --global core.excludesfile
```

Add your name and email if not already set:

```bash
git config --global user.name "tracelail"
git config --global user.email "lailtrace@gmail.com"
```

### 6. CITATION.cff

A template lives at `configs/git/CITATION.cff`. Copy it into any new project:

```bash
cp configs/git/CITATION.cff ~/projects/YOUR-PROJECT/
```

Fill in the title, description, ORCID, and release date.

---

## Repo Structure

```
dev-setup/
├── Makefile                      # Run make help to see all commands
├── packages.txt                  # apt packages list
├── configs/
│   ├── zsh/
│   │   ├── .zshrc                # Zsh config with Powerlevel10k
│   │   └── .p10k.zsh             # Powerlevel10k prompt config
│   ├── git/
│   │   ├── .gitignore_global     # Global gitignore (bioinformatics additions)
│   │   └── CITATION.cff          # Citation template for academic projects
│   └── nf-core/
│       └── pixi.toml             # nf-core tools environment
└── README.md
```

---

## Tool Sources & Credits

| Tool | Source |
|------|--------|
| Zsh | https://www.zsh.org |
| Oh My Zsh | https://ohmyz.sh |
| Powerlevel10k | https://github.com/romkatv/powerlevel10k |
| pixi | https://pixi.sh |
| uv | https://docs.astral.sh/uv |
| just | https://just.systems |
| copier | https://copier.readthedocs.io |
| ruff | https://docs.astral.sh/ruff |
| prettier | https://prettier.io |
| tldr | https://tldr.sh |
| Nextflow | https://nextflow.io |
| nf-core | https://nf-co.re |
| nf-test | https://nf-test.com |
| Docker | https://docs.docker.com/engine/install/debian |
| VSCode | https://code.visualstudio.com |
| Brave | https://brave.com/linux |
| Discord | https://discord.com |

---

## Troubleshooting

**pixi command not found after install**
```bash
source ~/.zshrc
```
or open a new terminal — pixi adds itself to your PATH in `.zshrc`.

**Docker permission denied**
Add your user to the docker group:
```bash
sudo usermod -aG docker $USER
```
Then log out and back in.

**nf-core tools not resolving**
Make sure pixi installed correctly and the environment is set up:
```bash
cd ~/.nf-core && pixi install
```

**dpkg errors during app install**
Run after any failed `.deb` install:
```bash
sudo apt install -f -y
```
