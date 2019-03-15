# ~/

Collection of dotfiles and shell scripts. Deployment managed with GNU stow.

```sh
$ git clone --recurse-submodules git://github.com/jsks/dotfiles.git

# Assuming zsh and noglob_dots
$ cd dotfiles; stow -R *(/)
```
