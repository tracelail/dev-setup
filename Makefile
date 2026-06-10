.PHONY: all packages shell tools nf-core apps help

all: packages shell tools nf-core apps  ## Full dev environment install

help:  ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36mmake %-12s\033[0m %s\n", $$1, $$2}'


# ─── Packages ────────────────────────────────────────────────────────
# Docker install requires adding their apt repo first

packages:  ## Install apt packages from packages.txt
	@echo "==> Adding Docker apt repo..."
	sudo apt update
	sudo apt install -y ca-certificates curl gnupg
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $$(. /etc/os-release && echo $$VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update
	@echo "==> Installing packages..."
	xargs sudo apt install -y < packages.txt
	@echo "==> Adding user to docker group..."
	sudo usermod -aG docker $$USER
	@echo "    NOTE: Log out and back in for docker group to take effect"


# ─── Shell ───────────────────────────────────────────────────────────
# Docs:  https://ohmyz.sh/#install
# Theme: https://github.com/romkatv/powerlevel10k

shell:  ## Install zsh + Oh My Zsh + Powerlevel10k + configs
	sh -c "$$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
	chsh -s $$(which zsh)
	cp configs/zsh/.zshrc ~/.zshrc
	cp configs/zsh/.p10k.zsh ~/.p10k.zsh
	@echo "    NOTE: Log out and back in for zsh to take effect"


# ─── Dev Tools ───────────────────────────────────────────────────────
# pixi:       https://pixi.sh
# uv:         https://docs.astral.sh/uv
# just:       https://just.systems
# copier:     https://copier.readthedocs.io
# ruff:       https://docs.astral.sh/ruff
# mypy:       https://mypy.readthedocs.io
# pre-commit: https://pre-commit.com
# gitleaks:   https://github.com/gitleaks/gitleaks
# prettier:   https://prettier.io
# miniconda:  https://docs.anaconda.com/miniconda

tools:  ## Install pixi, uv, just, copier, ruff, mypy, pre-commit, gitleaks, prettier, miniconda
	@echo "==> Installing pixi..."
	curl -fsSL https://pixi.sh/install.sh | bash

	@echo "==> Installing uv..."
	curl -LsSf https://astral.sh/uv/install.sh | sh

	@echo "==> Installing just..."
	mkdir -p ~/.local/bin
	curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin

	@echo "==> Installing uv tools (ruff, mypy, pre-commit, copier)..."
	uv tool install ruff
	uv tool install mypy
	uv tool install pre-commit
	uv tool install copier

	@echo "==> Installing gitleaks..."
	mkdir -p ~/.local/bin
	curl -sSfL https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks_linux_x64.tar.gz | tar -xz -C ~/.local/bin gitleaks

	@echo "==> Installing prettier globally via npm..."
	sudo npm install -g prettier

	@echo "==> Installing miniconda..."
	curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh
	bash /tmp/miniconda.sh -b -p $$HOME/miniconda3
	rm /tmp/miniconda.sh
	$$HOME/miniconda3/bin/conda init zsh
	@echo "    NOTE: conda base auto-activation is disabled by default in .zshrc"

	@echo "==> Configuring global git settings..."
	git config --global core.excludesfile ~/.gitignore_global
	cp configs/git/.gitignore_global ~/.gitignore_global


# ─── nf-core ─────────────────────────────────────────────────────────
# Nextflow: https://nextflow.io
# nf-core:  https://nf-co.re
# nf-test:  https://nf-test.com

nf-core:  ## Install nf-core pixi environment
	@echo "==> Setting up nf-core tools environment..."
	mkdir -p ~/.nf-core
	cp configs/nf-core/pixi.toml ~/.nf-core/pixi.toml
	cd ~/.nf-core && pixi install
	@echo ""
	@echo "    Run nf-core tools with: cd ~/.nf-core && pixi run nf-core"


# ─── Apps ────────────────────────────────────────────────────────────

apps:  ## Install VSCode via .deb
	@echo "==> Installing VSCode..."
	curl -fsSL "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/vscode.deb
	sudo dpkg -i /tmp/vscode.deb
	sudo apt install -f -y
	rm /tmp/vscode.deb
	@echo "    NOTE: Sign into VSCode with GitHub to sync extensions and settings"
