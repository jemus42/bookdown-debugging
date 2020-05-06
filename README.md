# bookdown-debugging

This is a minimal example of a book based on R Markdown and **bookdown** (https://github.com/rstudio/bookdown).   
This repository tests various thing I find myself wanting to do, but don't want to have to work out with actual projects each time.  

This project "demonstrates":

- Using `renv` with bookdown and CI/CD providers
- Building via travis CI and deploying via SSH to a server
- Building via GitHub actions and deploying to netlify

Output:
- Server deplyoment: https://bookdown-debug.tadaa-data.de/
- Netlify: https://jemus42-bookdown-debugging.netlify.app/

## `DESCRIPTION`

This is more of a dummy file, but it's required for travis to recognize this as an R project.  
The `Imports:` field normally is used for dependency management, but since `renv` is used, this isn't really necessary.  
It should also be noted that `renv` bootstraps itself via `.Rprofile`, so `renv` doesn't need to be installed explicitly before `renv::restore` is called.

## renv

Set up `renv` and use as normal.

```r
renv::init()

renv::snapshot()
```

As long as `renv::restore()` is called in `.travis.yml` and caching is set up (optional, but recommend), this should work just fine.

## Deployment

### GitHub Pages

Add your `$GITHUB_PAT` to travis by whatever means you're used to, the rest is handled via `.travis.yml`.

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

The corresponding lines in `.travis.yml` are added by `travis`, but will have to me moved to the `before_deploy` step in `.travis.yml` including the `ssh-agent` step etc.
