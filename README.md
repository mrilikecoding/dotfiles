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

This is mostly for keeping my setup consistent across machines... but hey, feel free to yank this! I'm borring from all over...

### Dependencies
First, Install iTerm2
Clone this repo into your home directory

Run installation script: `sh makesymlinks.sh`

**Note: this will install zshell if it isn't already installed!**

Set iterm2 colorschemes with the schemes located within `/itermcolors`

You'll want to install an up to date Vim via Homebrew so it compiles with ruby, python, clientserver...
	
	# mercurial required - install if you don't already have it.
	$ brew install mercurial
	$ brew install Caskroom/cask/xquartz

	# install Vim
	$ brew install vim --with-client-server

	# if /usr/bin is before /usr/local/bin in your $PATH,
	# hide the old system Vim so the new version is found first
	$ sudo mv /usr/bin/vim /usr/bin/vim73

	# should return /usr/local/bin/vim
	$ which vim

Launch Vim, and run `:PluginInstall`

### Configurations

Set environment variables in .zprofile

### What's what?

Vim plugins managed via Vundle. Checkout out the `Vundles` folder. Plugins are categorized. After adding a plugin, run `:source %` followed by `:PluginInstall`.

