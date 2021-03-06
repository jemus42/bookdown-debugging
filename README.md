# bookdown-debugging

[![Travis (.org)](https://img.shields.io/travis/jemus42/bookdown-debugging?logo=travis)](https://travis-ci.org/github/jemus42/bookdown-debugging)
![actions bookdown](https://github.com/jemus42/bookdown-debugging/workflows/bookdown/badge.svg)

This is a minimal example of a book based on R Markdown and **bookdown** (https://github.com/rstudio/bookdown).   
This repository tests various thing I find myself wanting to do, but don't want to have to work out with actual projects each time.  

| CI Provider    | Deployment Target    | GitBook | PDF | Output                                          |
|----------------|----------------------|---------|-----|-------------------------------------------------|
| [GitHub Actions][gh-actions-link]      | Netlify              | ✔️       | ❌   | https://jemus42-bookdown-debugging.netlify.app/ |
| [Travis CI][travis-link]      | GitHub Pages              | ✔️       | ✔️  | https://jemus42.github.io/bookdown-debugging/ |
| [Travis CI][travis-link] | Server / ssh + rsync | ✔️       | ✔️   | https://bookdown-debug.tadaa-data.de/           |

[travis-link]: https://travis-ci.org/github/jemus42/bookdown-debugging
[gh-actions-link]: https://github.com/jemus42/bookdown-debugging/actions

This project "demonstrates":

- Using `renv` with bookdown and CI/CD providers [see also](https://rstudio.github.io/renv/articles/ci.html)
- Building via travis CI and deploying via SSH to a server (see `.travis.yml`)
  - Bonus feature: Installing Adobe Source (Serif|Sans|Code) Pro fonts for the PDF output (`bin/get_adobe_fonts.sh`)
- Building via GitHub actions and deploying to netlify (see `.github/workflows/bookdown.yaml`)

## The `DESCRIPTION` file

This is more of a dummy file, but it's required for travis to recognize this as an R project.  
The `Imports:` field normally is used for dependency management, but since `renv` is used, this isn't really necessary.  
It should also be noted that `renv` bootstraps itself via `.Rprofile`, so `renv` doesn't need to be installed explicitly before `renv::restore` is called.

## Using `renv` for package management

Set up `renv` and use as normal.

```r
renv::init()

renv::snapshot()
```

As long as `renv::restore()` is called in `.travis.yml` (/ whatever CI config) and caching is set up (optional, but recommended), this should work just fine.  
Some dependencies might not be picked up automatically, like `ragg` which is used only by setting `dev = ragg_png` in `_output.yml` for `bookdown::gitbook`.  
I "solve" this by just calling `library(ragg)` explicitly, because `renv::record()` is more annoying.

## Deployment

### GitHub Pages

Add your `$GITHUB_PAT` to travis by whatever means you're used to, the rest is handled via `.travis.yml`.

### Netlify (WIP)

Based on [this blog post](https://www.hvitfeldt.me/blog/bookdown-netlify-github-actions/) and
using the GitHub action for bookdown as a basis (`usethis::use_github_action("bookdown")`).

It works fine for HTML (GitBook) output for now, but PDF output and custom fonts are WIP.

### Script deployment via `rsync` / `ssh`

This is based on https://oncletom.io/2016/travis-ssh-deploy:

```sh
# Generate a new rsa key
ssh-keygen -t rsa -b 4096 -C 'build@travis-ci.org' -f ./deploy_rsa

# Encrypt the key and add to travis repo, requires travis CLI tool (brew install travis)
travis encrypt-file deploy_rsa --add

# Add the key to your server
ssh-copy-id -i deploy_rsa.pub -p 54321 travis@pearson.tadaa-data.de

# Delete (as to *really really* not accidentally publish)
rm -f deploy_rsa deploy_rsa.pub

# Add changes
git add deploy_rsa.enc .travis.yml
```

The corresponding lines in `.travis.yml` are added by `travis`, but will have to be moved to the `before_deploy` step in `.travis.yml` including the `ssh-agent` step etc.
