# MyToolbx

A base image and action for Toolbx base on ublue-os/boxkit.

This image is going to experiment with what a "born from cloud native" UNIX terminal experience would look like. 
It is used in conjuction with a [dotfile manager](https://dotfiles.github.io/utilities/) and designed to be the companion terminal experience for cloud-native desktops. 

- Starts with the latest fedora image from the [Toolbx Community Images](https://github.com/toolbx-images/images)
- Adds some quality of life
  - `cwpowerlevel10kstarship` prompt
  - `just` for task execution
  - `chezmoi` for dotfile management
  - `btop` for process management
  - `nvim` text editors
  - [clipboard](https://github.com/Slackadays/Clipboard) to cut, copy, and paste anything, anywhere, all from the terminal! 
  - `python3` 
  - Some common power tools: `plocate`, `fzf`, `cosign`, `ripgrep`, `github-cli`, and `ffmpeg`
  - CLI tools recommended by [rawkode](https://www.youtube.com/watch?v=TNlDSG1iDW8)
    - [zellij](https://github.com/zellij-org/zellij) - terminal workspace
    - [direnv](https://direnv.net/) - environment variable extension for your shell 
    - [atuin](https://github.com/ellie/atuin) - magical shell history

## How to use

### Create Box

If you use toolbx:

    toolbox create -i ghcr.io/pliveyns/mytoolbx -c MyToolbx
    toolbox enter MyToolbx

### Pull down your config

Use `chezmoi` to pull down your dotfiles and set up git sync.


### Make your own

Check the base for this https://github.com/ublue-os/boxkit
Fork and add programs to this image - over time you'll end up with the perfect CLI for you.
Keeping it as a pet works, though the author recommends leaving all your config in git and routinely pulling a new image.

The user experience is much nicer if you [set your terminal open right in the container](https://distrobox.privatedns.org/useful_tips.html#using-distrobox-as-main-cli) and is the intended experience. 

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/pliveyns/MyToolbx
    
If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions.

## Finding Good Base Images

Of course you can make this however you want, but start with the [Toolbx Community images](https://github.com/toolbx-images/images).
These are a set of mostly-stock images with packages needed to run as a toolbox/distrobox already installed. 

Try to derive your blingbox from those base images so we can all help maintain them over time, you can't have bling without good stock!

Tag your image with `boxkit` to share with others!
