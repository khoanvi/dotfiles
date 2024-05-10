# dotfiles
NOTED: These are my personal configuration files, which could be changed as I develop my environment on macOS.

## Showcase
![image](./screenshots/vim-screenshot.png)

## Installation
Clone repository to your local device and `cd` into it:
```shell script
$ git clone https://github.com/khoanduy/dotfiles.git
$ cd dotfiles
```

Then run the setup script (you have to run `chmod +x` in able to execute it):
```shell script
$ chmod +x configure-tilde
$ ./configure-tilde
```

This might take quite a while as it needs to download and install several tools.

After script execution finish, reload your `zsh` config file:
```shell script
$ source ~/.zshrc
```

Try to launch `vim` up, ignore all errors and try `:PlugInstal` then restart `vim`.

### Additional notes
If you want to develop Java using Vim, additional script is needed:
```shell script
$ chmod +x configure-jdtls
$ ./configure-jdtls
```

## References
[tmux](https://github.com/tmux/tmux)\
[vim](https://www.vim.org/) \
[langserver](https://langserver.org/)
