#! /bin/sh## Get lozenges back into text, also get rid of A HREF/ A NAME # hyper text mark ups for improved readability## Nat! (c) 1997   Mulle kybernetiK   Freeware## $Id: dehtmlify.sh,v 1.1 1997/07/18 23:18:40 nat Exp $#for i in *.htmldo   src=$i   dst=`basename $i .html`.ascii   echo "Converting $src to $dst..."   cat $i | sed -e 's/<[/]*A[^>]*>//g' -e 's/&lt;/</g' -e 's/&gt;/>/g' > $dstdone