# Smalltalk Makefiles (aka Jan's Makefiles)

*Smalltalk Makefiles* is a set of makefiles and make macros
to simplify development and testing of (some) Smalltalk
projects.

## How to update makefiles in a project...

...that references *Smalltalk Makefiles* as submodule:

```
git clone --recurse-submodules <project.git>
cd <project>
git checkout -b pr/update-makefiles
git -C makefiles/ fetch origin master:master
git -C makefiles/ pull origin master
git add makefiles
git commit -m "Update makefiles"
git push --set-upstream origin pr/update-makefiles
```
