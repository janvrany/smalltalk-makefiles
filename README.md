# Smalltalk Makefiles (aka Jan's Makefiles)

*Smalltalk Makefiles* is a set of makefiles and make macros
to simplify development and testing of (some) Smalltalk
projects.

## Usage

The best way is to copy makefiles from existing projects
using *Smalltalk Makefiles*, for example:

 * https://github.com/shingarov/MachineArithmetic/blob/pure-z3/pharo/GNUmakefile
 * https://github.com/shingarov/MachineArithmetic/blob/pure-z3/stx/GNUmakefile
 * https://github.com/shingarov/Pharo-ArchC/tree/pure-z3/pharo/GNUmakefile
 * https://github.com/shingarov/Pharo-ArchC/tree/pure-z3/stx/GNUmakefile
 * https://github.com/janvrany/Tinyrossa/blob/master/pharo/GNUmakefile
 * https://github.com/janvrany/Tinyrossa/blob/master/stx/GNUmakefile

## Rationale

As you may have noticed, in projects using *Smalltalk Makefiles* some of the
dependencies are expressed twice, once in Metacello's `BaselineOf???` and then
in the makefile.

There are three reasons for this:

  1. Some of the projects are partially developed (and tested) in Smalltalk/X which does not have Metacello so it cannot depend on it to load dependencies.

  2. Metacello can only deal with smalltalk code, but (for example) for [ArchC](https://github.com/shingarov/Pharo-ArchC) you need to clone PDLs. For [Tinyrossa](https://github.com/janvrany/Tinyrossa) you also need to build fatshell to run tests. None of this can be done with Metacello (unless you go wild about postload actions, but even that, API for calling external code in Pharo is but a joke).

  3. If I make change in dependency of project and want to test it locally, with Metacello I'd have to (i) commit all changes and push them to Github then (ii) update baseline in user of the dependency to point to different branch, (iii) commit that and push to temporary branch and then (iv) I can test. Imagine I change [MachineArithmetic](https://github.com/shingarov/MachineArithmetic) and want to test it in Tinyrossa, which load MachineArithmetic indirectly indirectly through ArchC. I'd have to change baselines in all of these, push and then test to find out I messed up. With makefiles, I do not even have to commit changes to MachineArithmetic, just file them out and then do make in Tinyrossa. This is perhaps just my (Jan's) usecase, but this is very important to me (Jan).

Keep in mind that when using *Smalltalk Makefiles*, the code checked out on the disk in location
specified by makefiles always take precedence over `BaselineOf???`.

## How to update makefiles in a project...

...that references *Smalltalk Makefiles* as submodule:

```
git clone --recurse-submodules <project.git>
cd <project>
git -C makefiles/ fetch origin master
git -C makefiles/ pull origin master
git checkout -b "pr/update-makefiles-to-$(git -C makefiles rev-parse --short=8 HEAD)"
git add makefiles
git commit -m "Update makefiles to $(git -C makefiles rev-parse --short=8 HEAD)"
git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
```
