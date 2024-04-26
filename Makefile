# vim: set fenc=utf8 ffs=unix ft=make list noet sw=2 ts=2 tw=100:

.ONESHELL:

vars ?= HS_APPLICATION=/Applications PREFIX=$${HOME}/.hammerspoon

help: ## Display all Makfile targets
	@grep -E '^.*[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

dependencies:
	git submodule update --init --recursive


install: dependencies ## Install dependencies (i.e., asm modules)
	$(info compiling modules)
	zsh +o extendedglob -ilc \
		'for mk_dir in **/(*/)#Makefile(:h); \
		${vars} \
		make --always-make --directory=$${mk_dir} --ignore-errors --jobs --keep-going'

install-luaformatter: ## Install luaformatter via luarocks
	luarocks install \
		--server https://luarocks.org/dev \
		luaformatter

format: ## Run lua-formatter using .lua_format.yml config
	stylua \
		--call-parentheses Input \
		--collapse-simple-statement Always \
		--column-width 120 \
		--glob **/*.lua \
		--indent-type Spaces \
		--line-endings Unix \
		--quote-style AutoPreferSingle \
		--verbose

clean: ## Remove artifacts
	git submodule deinit \
		--all \
		--force
	find ./Spoons/* -not \( -name "asm*" -o -name "SpoonInstall.spoon" \) -type d -exec rm -rvf {} +
