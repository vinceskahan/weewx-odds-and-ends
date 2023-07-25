

# Installing a driver, skin, or extension

The WeeWX extension installer can be used to install, uninstall, and list properly constructed WeeWX drivers, extensions or skins.   Each such item might require subsequent edits to weewx.conf or to the skin's skin.conf file.  Consult the particular item's documentation for details.

This example installs a demonstration skin, but the command syntax is identical for drivers and extensions.

## Prerequisites for pip installations

For pip users - first - activate the python virtual environment.  Notice how the shell prompt changes to indicate your shell session is in a python virtual environment.   Pre-packaged WeeWX systems can skip this step.

The remainder of this document assumes the user is running in an activated python virtual environment.


```
vagrant@bookworm:~$ source weewx-venv/bin/activate
(weewx-venv) vagrant@bookworm:~$
```

## Usage

```
(weewx-venv) vagrant@bookworm:~$ weectl extension -h
usage: weectl extension list
            [--config=CONFIG-PATH]

       weectl extension install (FILE|DIR|URL)
            [--config=CONFIG-PATH]
            [--dry-run] [--verbosity=N]

       weectl extension uninstall NAME
            [--config=CONFIG-PATH]
            [--dry-run] [--verbosity=N]

Manages WeeWX extensions

options:
  -h, --help            show this help message and exit

Which action to take:
  {list,install,uninstall}
    list                List all installed extensions
    install             Install an extension contained in FILE (such as pmon.tar.gz), directory (DIR), or from an URL.
    uninstall           Uninstall an extension
```

### List installed extensions

In this example, no additional skins or extensions are present.

```
(weewx-venv) vagrant@bookworm:~$ weectl extension list
No extensions installed

```

### Install a skin or extension from a URL

This example installs a demonstration skin directory from its GitHub 'Download ZIP' link.

```
(weewx-venv) vagrant@bookworm:~$ weectl extension install https://github.com/vinceskahan/weewx-demo-skin/archive/refs/heads/main.zip
Request to install 'https://github.com/vinceskahan/weewx-demo-skin/archive/refs/heads/main.zip'
Extracting from zip archive /tmp/tmphui6w1dv
Saving installer file to /home/vagrant/weewx-data/bin/user/installer/demo-skin
Saved configuration dictionary. Backup copy at /home/vagrant/weewx-data/weewx.conf.20230725220310
Finished installing extension demo-skin from https://github.com/vinceskahan/weewx-demo-skin/archive/refs/heads/main.zip

(weewx-venv) vagrant@bookworm:~$ weectl extension list
Extension Name    Version   Description
demo-skin         0.3       demo minimalist custom skin

```

### Uninstall a skin

```
(weewx-venv) vagrant@bookworm:~$ weectl extension uninstall demo-skin
Request to remove extension 'demo-skin'
Finished removing extension 'demo-skin'

(weewx-venv) vagrant@bookworm:~$ weectl extension list
No extensions installed
```

### Install a skin from a downloaded copy

This example downloads a demonstration skin via `wget`, saves it as a .zip file in the current working directory, and then installs it.

```
(weewx-venv) vagrant@bookworm:~$ wget -O weewx-demo-skin.zip https://github.com/vinceskahan/weewx-demo-skin/archive/refs/heads/main.zip
--2023-07-25 22:05:17--  https://github.com/vinceskahan/weewx-demo-skin/archive/refs/heads/main.zip
Resolving github.com (github.com)... 192.30.255.113
Connecting to github.com (github.com)|192.30.255.113|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://codeload.github.com/vinceskahan/weewx-demo-skin/zip/refs/heads/main [following]
--2023-07-25 22:05:18--  https://codeload.github.com/vinceskahan/weewx-demo-skin/zip/refs/heads/main
Resolving codeload.github.com (codeload.github.com)... 192.30.255.121
Connecting to codeload.github.com (codeload.github.com)|192.30.255.121|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [application/zip]
Saving to: ‘weewx-demo-skin.zip’

weewx-demo-skin.zip                        [ <=>                                                                         ]  13.26K  --.-KB/s    in 0.01s

2023-07-25 22:05:18 (1.30 MB/s) - ‘weewx-demo-skin.zip’ saved [13576]

```

Then install it, specifying the filename you saved the skin or extension to.

```
(weewx-venv) vagrant@bookworm:~$ weectl extension install weewx-demo-skin.zip
Request to install 'weewx-demo-skin.zip'
Extracting from zip archive weewx-demo-skin.zip
Saving installer file to /home/vagrant/weewx-data/bin/user/installer/demo-skin
Saved configuration dictionary. Backup copy at /home/vagrant/weewx-data/weewx.conf.20230725220615
Finished installing extension demo-skin from weewx-demo-skin.zip

(weewx-venv) vagrant@bookworm:~$ weectl extension list
Extension Name    Version   Description
demo-skin         0.3       demo minimalist custom skin
```


### Install from a directory containing a skin

Similarly, a directory using an extracted skin can be installed.


```
(weewx-venv) vagrant@bookworm:~$ ls
install-weewx.log  weewx-data  weewx-demo-skin.zip  weewx-venv

(weewx-venv) vagrant@bookworm:~$ unzip weewx-demo-skin.zip
Archive:  weewx-demo-skin.zip
d77aa4d0df25ad3087be58779bed4a2af66f3546
   creating: weewx-demo-skin-main/
 extracting: weewx-demo-skin-main/.gitignore
  inflating: weewx-demo-skin-main/changelog
  inflating: weewx-demo-skin-main/install.py
  inflating: weewx-demo-skin-main/readme.txt
  inflating: weewx-demo-skin-main/screenshot.png
   creating: weewx-demo-skin-main/skins/
   creating: weewx-demo-skin-main/skins/demo-skin/
  inflating: weewx-demo-skin-main/skins/demo-skin/000-README.txt
  inflating: weewx-demo-skin-main/skins/demo-skin/index.html.tmpl
 extracting: weewx-demo-skin-main/skins/demo-skin/mystyle.css
  inflating: weewx-demo-skin-main/skins/demo-skin/skin.conf

(weewx-venv) vagrant@bookworm:~$ ls
weewx-data  weewx-demo-skin-main  weewx-demo-skin.zip  weewx-venv

(weewx-venv) vagrant@bookworm:~$ weectl extension install weewx-demo-skin-main
Request to install 'weewx-demo-skin-main'
Saving installer file to /home/vagrant/weewx-data/bin/user/installer/demo-skin
Saved configuration dictionary. Backup copy at /home/vagrant/weewx-data/weewx.conf.20230725221237
Finished installing extension demo-skin from weewx-demo-skin-main

(weewx-venv) vagrant@bookworm:~$ weectl extension list
Extension Name    Version   Description
demo-skin         0.3       demo minimalist custom skin

```

