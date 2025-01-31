# vim-nftables

## Installation

[NeoBundle](#neobundle) is no longer actively maintained. In newer versions of vim, there 
is no need for a plugin manager. In order to install the plugin such that it
will be loaded automatically on startup, execute the following instructions:

```
mkdir -p $HOME/.vim/pack/vendor/start
cd $HOME/.vim/pack/vendor/start
git checkout https://github.com/awisse/vim-nftables.git
```

NB: The "vendor" directory name can be substituted with any other name.

## NeoBundle

Is no longer maintained but can be found [here](https://github.com/Shougo/neobundle.vim).

After installing NeoBundle, add the following to your vimrc:

```vim
NeoBundle 'nfnty/vim-nftables'
```

## Notes

## Recommendations

Note that this is not a full parser of the nftables syntax. If you choose a 
reserved keyword, like, for instance `input`, `filter`, `forward` 
as table, chain set or other object names, these will be highlighted like the 
corresponding keyword. So in order to fully benefit from this syntax 
highlighting, choose object and variable names that are not reserved words. 

Note that there are 431 reserved words in nftables. To see all reserved words,
run `./kw-count.py keywords/*.vim syntax/nftables.vim -q --all` in the
`vim-nftables` folder
