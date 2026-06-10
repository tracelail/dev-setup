# dev-setup

Standalone development environment for bioinformatics and computational biology work.
Works on any fresh Debian/Ubuntu machine — desktop or server, no other repos required.

## What's included

### Shell
- **Zsh** + Oh My Zsh + Powerlevel10k

### CLI Tools
- **gh** — GitHub CLI for auth and repo management
- **tldr** — simplified man pages
- **just** — project-level command runner
- **uv** — fast Python package and tool installer

### Code Quality (global)
- **ruff** — linting and formatting (replaces Black, Flake8, isort)
- **mypy** — type checking
- **pre-commit** — git hook manager
- **gitleaks** — secret detection before commits
- **prettier** — formatter for Nextflow/nf-core repos

### Environment Management
- **pixi** — primary environment manager (conda-forge + bioconda + PyPI + lockfile)
- **miniconda** — kept alongside pixi for conda-native workflows and users who prefer it
- **copier** — project scaffolding with updatable templates

### Bioinformatics
- **nf-core tools** — Nextflow + nf-core + nf-test via pixi environment
- **seqkit** — fast sequence file manipulation
- **Docker** — CE + CLI + Compose plugin (no Desktop)
- **default-jdk** — required for Nextflow

### Apps
- **VSCode** — with GitHub settings sync

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
make tools      # pixi, uv, just, ruff, mypy, pre-commit, gitleaks, prettier, miniconda
make nf-core    # Nextflow + nf-core + nf-test pixi environment
make apps       # VSCode
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

### 4. Docker Group

Log out and back in after install for docker group permissions to take effect. Verify with:

```bash
docker run hello-world
```

### 5. nf-core Tools

The nf-core environment lives at `~/.nf-core/`. To use it:

```bash
cd ~/.nf-core && pixi run nf-core --help
```

### 6. Global Git Config

Verify the global gitignore was set:

```bash
git config --global core.excludesfile
```

Add your name and email if not already set:

```bash
git config --global user.name "tracelail"
git config --global user.email "lailtrace@gmail.com"
```

### 7. CITATION.cff

A template lives at `configs/git/CITATION.cff`. Copy it into any new project:

```bash
cp ~/dev-setup/configs/git/CITATION.cff ~/projects/YOUR-PROJECT/
```

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
│       └── pixi.toml             # nf-core tools pixi environment
└── README.md
```

---

## Tool Sources & Credits

| Tool | Install Method | Source |
|------|---------------|--------|
| Zsh | apt | https://www.zsh.org |
| Oh My Zsh | curl installer | https://ohmyz.sh |
| Powerlevel10k | git clone | https://github.com/romkatv/powerlevel10k |
| gh | apt | https://cli.github.com |
| pixi | curl installer | https://pixi.sh |
| uv | curl installer | https://docs.astral.sh/uv |
| just | curl installer | https://just.systems |
| ruff | uv tool install | https://docs.astral.sh/ruff |
| mypy | uv tool install | https://mypy.readthedocs.io |
| pre-commit | uv tool install | https://pre-commit.com |
| copier | uv tool install | https://copier.readthedocs.io |
| gitleaks | curl installer | https://github.com/gitleaks/gitleaks |
| prettier | npm | https://prettier.io |
| miniconda | curl installer | https://docs.anaconda.com/miniconda |
| Nextflow | pixi | https://nextflow.io |
| nf-core | pixi | https://nf-co.re |
| nf-test | pixi | https://nf-test.com |
| seqkit | apt | https://bioinf.shenwei.me/seqkit |
| Docker | apt | https://docs.docker.com/engine/install/debian |
| VSCode | .deb | https://code.visualstudio.com |

---

## Troubleshooting

**pixi command not found after install**
```bash
source ~/.zshrc
```

**uv tools not found after install**
```bash
source ~/.zshrc
```
uv tools install to `~/.local/bin` — make sure it's on your PATH.

**Docker permission denied**
```bash
sudo usermod -aG docker $USER
```
Then log out and back in.

**nf-core tools not resolving**
```bash
cd ~/.nf-core && pixi install
```

**dpkg errors during VSCode install**
```bash
sudo apt install -f -y
```

**conda not found after install**
```bash
source ~/.zshrc
```
miniconda adds itself to `.zshrc` during install via `conda init zsh`.
