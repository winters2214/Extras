git-guilt(1) -- calculate change between two revisions
========================================

## SYNOPSIS

git guilt [&lt;option&gt;] &lt;since&gt; &lt;until&gt;

## DESCRIPTION

Calculate the change in blame between two revisions

## OPTIONS

  -h, --help

  Output usage information

  -e, --email

  Display author emails instead of names

  -w, --ignore-whitespace

  Ignore whitespace only changes when attributing blame

  -d, --debug

  Output debug information

## Examples

Find blame delta between two commits:

    $ git guilt HEAD~2 HEAD
    spacewander                   +++++++++++++++++++++++++++++++++++++++++++++(115)
    Jesse Sipprell                -

Find blame delta over the last three weeks:

    $ git guilt `git log --until="3 weeks ago" --format="%H" -n 1` HEAD 
    Paul Schreiber                +++++++++++++++++++++++++++++++++++++++++++++(349)
    spacewander                   +++++++++++++++++++++++++++++++++++++++++++++(113)
    Mark Eissler                  ++++++++++++++++++++++++++
    CJ                            +++++
    nickl-                        -
    Jesse Sipprell                -
    Evan Grim                     -
    Ben Parnell                   -
    hemanth.hm                    --

Since git 1.8.5, the above can also be written as:

  $ git guilt @{3.weeks.ago}

Find blame delta for a topic branch:

    $ git guilt `git merge-base master git-guilt` git-guilt 
    spacewander                   +++++++++++++++++++++++++++++++++++++++++++++(112)

## AUTHOR

Written by spacewander &lt;<spacewanderlzx@gmail.com>&gt;

## REPORTING BUGS

&lt;<https://github.com/tj/git-extras/issues>&gt;

## SEE ALSO

&lt;<https://github.com/tj/git-extras>&gt;
