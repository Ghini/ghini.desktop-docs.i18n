# Ghini Desktop : documentation internationalization (docs-i18n)

## how does this work

Ghini and its documentation are translated making use of ``gettext``.

``gettext`` relies on the presence of so called ``po`` files, which contain easy to edit string-by-string translation. ``po`` files get compiled into ``mo`` files (this happens during program installation), the ``mo`` files are then used by the program while running. Depending on the currently configured system language, Ghini will use ``gettext`` in order to find the translation of any string before displaying it to the user.

Something similar can be done for producing translated documentation. The difference is that a documentation, be it in file, site, archive, or whatever container form, it is a static object, non a dynamic program, so it has to be translated before you start reading it. The active translation task, equally relying on ``gettext`` and ``mo`` files, is taken over by ``sphinx``, you then enjoy the static translated documentation.

Weblate is hosting our ``po`` files and any change to them will trigger saving them along with their compiled corresponding ``mo`` files to this project.

Translators can also edit ``po`` files manually, but in this case it is important that they also compile them to ``mo`` and they commit both source and generated files to github.

A commit to github will trigger actions on readthedocs, not just one: several actions. point is: on Readthedocs we have registered several projects, all referring to the same repository here, but each of them specifying a different language.

All Ghini documentation projects on Readthedocs are linked with each other: the English version is the central one, all others are marked as translation of it. All are reachable from each other on our Readthedocs pages, by choosing the language you want to read.

## what did we do to organize it

Ghini-the.software contains a script you would invoke every time changes in the sources include changes in translatable strings. Translatable strings are either the ones passed as parameter to the ``_`` function, or are the textual content of a glade element that has attribute ``translatable="True"``. You edit the software, you realize you changed things having effect on the translation, you run ``scripts/i18n.sh``, you complete the translations as far as you can, you hope someone else will help you out with the languages you do not master.

Ghini-the.documentation is part of Ghini-the.software just as far as English documentation is concerned and not farther than that. Whenever someone edits the English documentation, readthedocs is notified of the fact and updates the generated English documentation site. This has no impact on the translations.

ghini.desktop-docs.i18n (this project) doesn't exactly contain the translated documentation, it just contains all that Readthedocs needs to generate it. ghini.desktop-docs.i18n is the place where we keep a verbatim copy of the Ghini documentation, from ghini.desktop, plus all corresponding ``po`` and ``mo`` files. Readthedocs runs ``sphinx`` to generate the translated documentation sites, Weblate helps translators contribute their translations.

    |---source (the verbatim copy of the ghini docs)
    |---locale
        \---<language>
            \---LC_MESSAGES
                |---<document-name>.po
                |---<document-name>.po
                |---<document-name>.po
                \---<document-name>.po

The script for initializing this repository is the same we use for keeping it up-to-date, and is described in the next section.

### variation on the theme

``sphinx`` needs the ``mo`` file to carry the same name as the ``rst`` documentation it is translating, this is the reason for the above organization. 

For the sake of Weblate, on the other hand, it is way easier to have one ``po`` file to edit, at least, if you want to start offer stuff to translators before you are even sure how many pages there will be in your documentation, or if you plan to include in your statistics something like "Spanish documentation at xx%".

If you want to blend all po files into one, you will need to add symbolic links to it, named as each of your documentation sources. When updating, too, you will need a few more steps, which I did not explore yet.

## which way do we keep it up to date
