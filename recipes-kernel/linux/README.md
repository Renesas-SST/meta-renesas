# Notes: #

## Config files:

The .cfg kernel confic fragments are located as follows:

|   Location   |       Description                                                                                                                                                                                |
|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| rzg2l-sbc/   | Due the use of machine conf in the SRC_URI (i.e SRC_URI:append:<machine>): the fetcher looks for the cfg files in the <machine> (rzg2l-sbc) directory instead of <recipe_name> (i.e linux-yocto).|
| linux-yocto/ | retained for general builds.                                                                                                                                                                     |

## Recipie for 6.10

The base recipie for 6.10 is already available in the poky poky/meta/recipes-kernel/linux/ directory. There are variations of it for comparison.
Hence this recipe uses .bbappend files to overrride those basefiles.

