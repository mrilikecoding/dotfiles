# MrILikeCoding's Dotfiles

					.+i+;I:
	              :=..    t:
	             =;+;:..   ii.       
	            +I::;=:;;+t=i;=.         
	            +;;;+;i.;;:It++i;             
	          ;X  t+=+=;;i;=iItt+V
	          :t  =ii+.=.;:=+ii++iIY
	          :R   i=ti+=+;i+i=t=++:+Ii+==
	          :R  .+iii==;;itt=++i=i::=YRBBBMRRVY+;
	           ;+    +i+;+;+itiiitii+i+i .=iYVIi+iitI=;=
	   +. ::.X:.;   .:=;+=i=ii++YYIIiiiIt.  ;YI::+:;=iit===;
	  I;:. .  :+:YI;R..=;;=i+titIVItIYVYYYXVX=+:.....;;+t=+::=
	  +i;.::......:;:=;;;;;=+iii=+=++ii++tttVI===;;;;::;;+;tti=
	   tI+.::::.;::;:=+++i=+;i++ititttItIItt=;=t+==;:;::;:;=+IY=:
	    :=i;::.::::;=:;++=i===;iiittitttttItt=;=;:;;...::;::;.;+ii:;
	      :=+::.;+i+t++itiIIY=RRRXXV+VYi===:::;;:.:.........::;;;:;;;;:;;;;
	          :tYti=;=+;+;=+++=;iIVRRRRVVRXRYYYV=;=::::..........:.:==+i==;;==;;:
	            ;Xti;=;+i;+ti++=+tRBBBYBVRYXIVtYY++=..:........:.;;::==;::;.;;;
	              YVi==;++:I;;ii+IRXIYIY=:;i;i;=;;;;;.........;:::;:;=;..:;::
	              :=XI=+iItIiit=:IXRRIItiXiIYiIt;I==:.......:..:....;:........
	              :BWRRV;YRIXY...+YRRVYVR+XIRItitI++=:.....;:.........:....:.::..
	             ==+RWBXtIRRV+.+IiYRBYBRRYYIRI;VitI;=;..........:::.::;::::...;;;:.


### Introduciton

Some wicked Vim dotfiles and an installation script!

This my opinionated and evolving setup, mostly for keeping my setup consistent across machines... but hey, feel free to yank this! I'm borrowing from all over.

### Setup

I use iTerm2, oh-my-zsh, rvm, and the latest Homebrew Vim.

* First, [Install iTerm2](https://www.iterm2.com/)
* [Install homebrew](http://brew.sh/)
* Clone this repo into your home directory
* Run the installation script: `sh makesymlinks.sh` **This will install zshell if it isn't already installed!**

I use the [solarized color scheme](http://ethanschoonover.com/solarized) cuz there's some science or something... To get this scheme to work with Vim, set iTerm2 colorschemes in the preferences with light and dark schemes located within `/itermcolors`. I switch between the light and dark themes depending on my mood. You'll need to switch both the Vim colorscheme and the iTerm2 colorscheme for everthing to look right. 

Additionally, you'll also find the iTerm preferences file in the home directory, which you can load into iTerm via the preferences menu.

Because OSX's default Vim doesn't compile with certain nice things, you'll want to install an up to date Vim via Homebrew and set a flag so that it compiles with `clientserver`. Or better yet, try [NeoVim](https://github.com/neovim/neovim)!
	
	# mercurial required - install if you don't already have it.
	$ brew install mercurial
	$ brew install Caskroom/cask/xquartz
	
	# if you want to use neovim instead of vim
	$brew tap neovim/neovim
	$brew install --HEAD neovim

  #you'll need to create aliases in zshrc for vim to nvim

	# otherwise install Vim
	$ brew install vim --with-client-server

	# if /usr/bin is before /usr/local/bin in your $PATH,
	# hide the old system Vim so the new version is found first
	$ sudo mv /usr/bin/vim /usr/bin/vim73

	# should return /usr/local/bin/vim
	$ which vim

Launch Vim, and run `:PlugInstall`

### Configurations

Any environment variables should be kept in `.zprofile` which is not kept in source control.

### Managing Vim plugins

Vim plugins are managed via Vim Plug. Checkout out the `plugins.vim` file. Plugins are loosely categorized. After adding a plugin, run `:source %` (or restart Vim) followed by `:PlugInstall`.

Other settings, including plugin configurations and key mappings, are managed from vimrc.

Happy coding!

