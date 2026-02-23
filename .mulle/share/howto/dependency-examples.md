# mulle-sde Dependency Addition Examples
<!-- Keywords: mulle-sde, sourcetree, add, copy, dependency, library -->


## If a dependency is not a library

``` bash
mulle-sde dependency mark <name> no-link
mulle-sde dependency mark <name> no-header
```

## Copy dependencies from another project

You are in your project and want to copy "Foo" from `/tmp/other-project`

``` bash
mulle-sourcetree rcopy /tmp/other-project Foo
```

You can clobber your projects with all the dependencies and libraries of
another project like this:

``` bash
mkdir -p .mulle/etc/sourcetree
cp /tmp/other-project/.mulle/etc/sourcetree/config .mulle/etc/sourcetree/
mulle-sourcetree reuuid    # important!!
```

## Reordering dependencies

The order of the dependencies is very important. Base dependencies need to come
first. You can reorder with the `mulle-sde move` command.


``` bash
mulle-sde move MulleObjC below MyLibrary
mulle-sde move mulle-testallocator to bottom
```


