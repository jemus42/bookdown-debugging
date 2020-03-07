This is a minimal example of a book based on R Markdown and **bookdown** (https://github.com/rstudio/bookdown). Please see the page "Get Started" at https://bookdown.org/home/about/ for how to compile this example.

## renv

```r
renv::init()

renv::snapshot()
```

## Script deployment via `rsync` / `ssh`

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
