# Ghini Desktop : documentation internationalization (docs-i18n)

## how does this work

Ghini and its documentation are translated making use of ``gettext``.

``gettext`` relies on the presence of so called ``po`` files, which contain easy to edit string-by-string translation. ``po`` files get compiled into ``mo`` files (this happens during program installation), the ``mo`` files are then used by the program while running. Depending on the currently configured system language, Ghini will use ``gettext`` in order to find the translation of any string before displaying it to the user.

Something similar can be done for producing translated documentation. The difference is that a documentation, be it in file, site, archive, or whatever container form, it is a static object, non a dynamic program, so it has to be translated before you start reading it. The active translation task, equally relying on ``gettext`` and ``mo`` files, is taken over by ``sphinx``, you then enjoy the static translated documentation.

For both software and documentation, Weblate hosts our ``po`` files and
[offers them to translators](https://hosted.weblate.org/projects/ghini/).
We have given Weblate permissions to push changes straight into our
``master`` branch.  Translators with a github account can also edit ``po``
files manually, and open a pull request to have their edits accepted.

There's one part which is less obvious: At the time of writing, Weblate
wants to handle one and only one ``po`` file per component, in order to
produce the single ``mo`` file, one per language, used at runtime.  With
Bauble, we adapted to this set up and we configured as many weblate
components as the documentation source files.  Keep in mind that
Hosted@Weblate is a courtesy by Michal Čihař, which he handles manually on a
case by case base, so any time we wanted to add a new documentation chapter,
we had to either ask Michal, or to fit the new chapter in an existing,
configured file.  This is what we did for Bauble, and we're handling it
differently in Ghini.

In [our ghini project hosted at
weblate](https://hosted.weblate.org/projects/ghini/) we have one component
for the whole documentation, and we achieve this by merging all ``pot``
files into a single ``doc.pot``, which in turn is used to update the single,
language specific, ``doc.po``.  We have a symbolic link from each individual
``po`` file to the global ``doc.po``, it will contain all strings, but who
cares, sphinx will only use the ones mentioned in the ``rst`` file.

Up to now we're still only looking at the ``po`` files.  Their ``mo`` binary
counterparts are generated, so are not under version control.

A commit to github will trigger actions on readthedocs: on Readthedocs we
have registered several projects, all referring to the same repository here,
but each of them specifying a different language.  At this point it is
Readthedocs that will produce and use the ``mo`` files.

All Ghini documentation projects on Readthedocs are linked with each other: the English version is the central one, all others are marked as translation of it. All are reachable from each other on our Readthedocs pages, by choosing the language you want to read.

## what did we do to organize it

Ghini-the.software contains a script you would invoke every time changes in
the sources include changes in translatable strings. Translatable strings
are either the ones passed as parameter to the ``_`` function, or are the
textual content of a glade element that has attribute
``translatable="True"``. You edit the software, you realize you changed
things having effect on the translation, you run ``scripts/i18n.sh``, you
complete the translations as far as you can, you hope someone else will help
you out with the languages you do not master.

Ghini-the.documentation is part of Ghini-the.software just as far as English
documentation is concerned and not further than that. Whenever someone edits
the English documentation, readthedocs is notified of the fact and updates
the generated English documentation site. This has no impact on the
translations.

ghini.desktop-docs.i18n (this project) doesn't exactly contain the
translated documentation, it just contains all that Readthedocs needs to
generate it.  ghini.desktop-docs.i18n is the place where we keep a verbatim
copy of the Ghini documentation, from ghini.desktop, plus all corresponding
``po`` files.  As explained above, Readthedocs runs ``sphinx`` to generate
the ``mo`` translation tables, and the translated documentation sites,
Weblate helps translators contribute their translations.
ghini.desktop-docs.i18n is also the place where we keep a script that
automatizes the process, this script is invoked by ``scripts/i18n.sh`` if
you add an positional argument, like in ``scripts/i18n.sh 1``.

    |---source (the verbatim copy of the ghini docs)
    |---locale
        \---<language>
            \---LC_MESSAGES
                |---doc.po
                |---<document-name>.po -> doc.po
                |---<document-name>.po -> doc.po
                |---<document-name>.po -> doc.po
                \---<document-name>.po -> doc.po

The script for initializing this repository is the same we use for keeping it up-to-date, and is described in the next section.

### variation on the theme

We're probably repeating ourselves here, have a look and decide for
yourself.  Anyhow, the implementation of this logic is all in the two
scripts ``i18n.sh`` in the software respository, and the ``runme.sh`` here
in this translation repository.

``sphinx`` needs the ``mo`` file to carry the same name as the ``rst``
documentation it is translating, this is the reason for the above
organization.  Each time Readthedocs runs sphinx, sphinx will produce as
many ``po`` files as the documentation sources —as many as the symbolic
links we created and committed— all corresponding to the single ``doc.po``,
but each named as the ``<document-name>``.

For the sake of Weblate, on the other hand, it is way easier to have one ``po`` file to edit, at least, if you want to start offer stuff to translators before you are even sure how many pages there will be in your documentation, or if you plan to include in your statistics something like "Spanish documentation at xx%".

If you want to blend all po files into one, you will need to add symbolic links to it, named as each of your documentation sources. When updating, too, you will need a few more steps, which I did not explore yet.

