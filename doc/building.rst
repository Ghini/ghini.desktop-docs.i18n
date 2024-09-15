Developer's Manual
========================

Helping Ghini development
--------------------------

Installing Ghini always includes downloading the sources, from the
GitHub repository. Every user is a potential developer.

There are many ways to contribute to Ghini:

 * Use the software, note the things you don't like, `open an issue
   <http://github.com/Ghini/ghini.desktop/issues/new>`_ for each of them. A
   developer will react sooner than you can imagine.
 * If you have an idea of what you miss in the software but can't quite
   formalize it into separate issues, you could consider hiring a
   professional. This is the best way to make sure that something happens
   quickly. Do make sure the developer opens issues and publishes
   their contribution on GitHub.
 * Translations can be made  without installing anything, by using the
   online translation service offered by http://hosted.weblate.org/
 * Fork the respository, choose an issue, solve it, open a pull request. See
   the `bug solving workflow`_ below.

If you haven't yet installed Ghini, and want to have a look at its code
history, you can open the `GitHub project page
<http://github.com/Ghini/ghini.desktop>`_ and see all that has been going on
since its inception as Bauble, back in 2004.

Software source, versions, branches
-------------------------------------------------------------

Versions are released and maintained as branches,
``git checkout`` the_branch_name corresponding to the
version of your choice.

production line
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Branch names of stable versions of Ghini (production), follow the pattern of
``ghini-x.y`` (eg: ghini-1.0); test versions have -dev appended to the branch
name: ``ghini-x.y-dev`` (eg: ghini-1.0-dev).

Development Workflow
-------------------------------------------------------------

Commits continuously land in the testing branch, to often push
them to GitHub, letting travis-ci and coveralls.io check the quality of the
pushed testing branches. From time to time, the testing branch is merged
into a branch which name corresponds with the release name.

Seldomly, larger issues taking more than a couple of days, might be branched out.

Larger issues
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When facing a single larger issue, create a branch tag at the tip of a main
development line (e.g.: ``ghini-1.0-dev``), and follow the workflow
described at

https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging

in short::

    git up
    git checkout -b issue-xxxx
    git push origin issue-xxxx

Work on the new temporary branch. When ready, go to GitHub, merge the branch
with the main development branch (the one you breanched out from), solve conflicts
where necessary, then delete the temporary branch.

When ready for publication, merge the development branch into the
corresponding production branch.

Updating the set of translatable strings
-------------------------------------------------------------

From time to time, during the process of updating the software, you will be
adding or modifying strings in the Python sources, in the documentation, in
the Glade sources. Most of the strings are translatable, and are offered on
Weblate for people to contribute, in the form of several ``.po`` files.

A ``PO`` file is mostly composed of pairs of text portions, the original and
corresponding translation, which is specific to a target language.
When translating a string on Weblate, this reaches our repository on GitHub.
When a programmer adds a string to the software, this reaches Weblate as
"To be translated".

Weblate hosts the `Ghini <https://hosted.weblate.org/projects/ghini/>`_
project. Within this project you will find components, each of which corresponds
to a branch of a repository on GitHub. Each component accepts translations
in several languages.

================== =========================== ==================
component          repository                  branch
================== =========================== ==================
Desktop 1.0        ghini.desktop               ghini-1.0-dev
Desktop 1.1        ghini.desktop               ghini-1.1-dev
Documentation 1.0  ghini.desktop-docs.i18n     ghini-1.0-dev
Documentation 1.1  ghini.desktop-docs.i18n     ghini-1.1-dev
Web 1.2            ghini.web                   master
================== =========================== ==================

To update the ``PO`` files relative to the *software*, you set the working
directory to the root of your checkout of *ghini.desktop*, and you run the
script::

  ./scripts/i18n.sh

To update the ``PO`` files relative to the *documentation*, you set the
working directory to the root of your checkout of *ghini.desktop-docs.i18n*,
and you run the script::

  ./doc/runme.sh

When you run either of the above mentioned scripts, chances are you need to
commit *all* ``PO`` files in the project. You may want to review the changes
before committing them to the respository. This is most important when you
perform a marginal correction to a string, like removing a typo.

`Our documentation <https://readthedocs.org/projects/ghini/>`_ on
readthedocs has an original English version, and several translations.
It is a copy of `description of localisation
<http://docs.readthedocs.io/en/latest/localization.html>`_.

Read the Docs checks the project's *Language* setting, and invokes
``sphinx-intl`` to produce the formatted documentation in the target
language. With the default configuration—which we did not alter—
``sphinx-intl`` expects one ``po`` file per source document, named as the
source document, and that they all reside in the directory
``local/$(LANG)/LC_MESSAGES/``.

On the other hand, both Weblate and us alike,  prefer a single ``PO`` file per
language, and WL keeps them all in the same ``/po`` directory, just as we do
for the software project: ``/po/$(LANG).po``.

In order not to repeat info, and to let both systems work their
natural way, there are two sets of symbolic links (git honors them).

To summarise: when a file in the documentation is updated, the ``runme.sh``
script will:

1. Copy the ``rst`` files from the software to the documentation;
2. Create a new ``POT`` file for each of the documentation files;
3. Merge all ``POT`` files into one ``doc.pot``;
4. Use the updated ``doc.pot`` to update all ``doc.po`` files (one per language);
5. Create all the symbolic links:
      
   a. Those expected by ``sphinx-intl`` in ``/local/$(LANG)/LC_MESSAGES/``
   b. Those used by weblate in ``/po/$(LANG).po``

The above could, but has yet to, be made into a Makefile, or even better included
in ``/doc/Makefile``.


Adding missing unit tests
-------------------------------------------------------------

If you are interested in contributing to the development of Ghini, a good way to
do so would be by helping us finding and writing the missing unit tests.

A well tested function is one whose behaviour you cannot change without
breaking at least one unit test.

We all agree that ideally theory and practice match perfectly and that one
first writes the tests, then implements the function. In practice, however,
it is the other way around.

This section describes the process of adding unit tests for
``bauble.plugins.plants.family.remove_callback``.

What to test
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First of all, open the coverage report index, and choose a file with low
coverage.

For this example, ran in October 2015, we landed on
``bauble.plugins.plants.family``, at 33%.

https://coveralls.io/builds/3741152/source?filename=bauble%2Fplugins%2Fplants%2Ffamily.py

The first two functions which need tests, ``edit_callback`` and
``add_genera_callback``, include creation and activation of an object
relying on a custom dialog box. One should really first write unit tests for
that class, then come back here.

The next function, ``remove_callback``, also activates a couple of dialog
and message boxes, but in the form of invoking a function requesting user
input via Yes-No-OK boxen. These functions can easily be replaced with a
function simulating the behaviour.

How to test
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Having decided what to describe in unit test, we look at the code and
see it needs to discriminate a couple of cases:

**Parameter correctness**
  * The list of families has no elements.
  * The list of families has more than one element.
  * The list of families has exactly one element.

**Cascade**
  * The family has no genera
  * The family has one or more genera

**Confirm**
  * The user confirms deletion
  * The user does not confirm deletion

**Deleting**
  * All goes well when deleting the family
  * There is some error while deleting the family

The decision is made to only focus on the **cascade** and the **confirm**
aspects. Two binary questions: 4 cases.

Where to put the tests
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Locate the test script and choose the class to put the extra unit tests in.

https://coveralls.io/builds/3741152/source?filename=bauble%2Fplugins%2Fplants%2Ftest.py#L273

.. Admonition: What about skipped tests
   :Class: Note

           The ``FamilyTests`` class contains a skipped test, implementing
           it will be quite a bit of work because it means rewriting the
           FamilyEditorPresenter, separating it from the FamilyEditorView and
           reconsidering what to do with the FamilyEditor class, which possibly
           should be removed and replaced with a single function.

Writing the tests
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After the last test in the FamilyTests class, the four cases I want to
describe are added, making sure they fail. In the aid of laziness, by writing
the most compact code I know for generating an error:

        def test_remove_callback_no_genera_no_confirm(self):
            1/0

        def test_remove_callback_no_genera_confirm(self):
            1/0

        def test_remove_callback_with_genera_no_confirm(self):
            1/0

        def test_remove_callback_with_genera_confirm(self):
            1/0

One test, step by step
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Let's start with the first test case.

When writing tests, I generally follow the pattern: 

* T₀ (initial condition), 
* action, 
* T₁ (testing the result of the action given the initial conditions)

.. admonition:: what's in a name — unit tests
   :class: note
        
           There's a reason why unit tests are called unit tests. Please
           never test two actions in one test.

Let's describe T₀ for the first test, a database holding a family without
genera::

        def test_remove_callback_no_genera_no_confirm(self):
            f5 = Family(family=u'Arecaceae')
            self.session.add(f5)
            self.session.flush()

We do not want the function being tested to invoke the interactive
``utils.yes_no_dialog`` function, we want ``remove_callback`` to invoke a
non-interactive replacement function. We achieve this simply by making
``utils.yes_no_dialog`` point to a ``lambda`` expression which, like the
original interactive function, accepts one parameter and returns a
boolean. In this case: ``False``::

        def test_remove_callback_no_genera_no_confirm(self):
            # T_0
            f5 = Family(family=u'Arecaceae')
            self.session.add(f5)
            self.session.flush()

            # action
            utils.yes_no_dialog = lambda x: False
            from bauble.plugins.plants.family import remove_callback
            remove_callback(f5)

Next we test the result.

Well, we don't just want to test whether or not the object Arecaceae was
deleted, we also should test the value returned by ``remove_callback``, and
whether ``yes_no_dialog`` and ``message_details_dialog`` were invoked or
not.

A ``lambda`` expression is not enough for this. We do something apparently
more complex, which will make life a lot easier.

Let's first define a rather generic function:

    def mockfunc(msg=None, name=None, caller=None, result=None):
        caller.invoked.append((name, msg))
        return result

And we grab ``partial`` from the ``functools`` standard module, to partially
apply the above ``mockfunc``, leaving only ``msg`` unspecified, and use this
partial application, which is a function accepting one parameter and
returning a value, to replace the two functions in ``utils``. The test
function now looks like this::

    def test_remove_callback_no_genera_no_confirm(self):
        # T_0
        f5 = Family(family=u'Arecaceae')
        self.session.add(f5)
        self.session.flush()
        self.invoked = []

        # action
        utils.yes_no_dialog = partial(
            mockfunc, name='yes_no_dialog', caller=self, result=False)
        utils.message_details_dialog = partial(
            mockfunc, name='message_details_dialog', caller=self)
        from bauble.plugins.plants.family import remove_callback
        result = remove_callback([f5])
        self.session.flush()

The test section checks that ``message_details_dialog`` was not invoked,
that ``yes_no_dialog`` was invoked, with the correct message parameter, that
Arecaceae is still there::

        # effect
        self.assertFalse('message_details_dialog' in
                         [f for (f, m) in self.invoked])
        self.assertTrue(('yes_no_dialog', u'Are you sure you want to '
                         'remove the family <i>Arecaceae</i>?')
                        in self.invoked)
        self.assertEquals(result, None)
        q = self.session.query(Family).filter_by(family=u"Arecaceae")
        matching = q.all()
        self.assertEquals(matching, [f5])

And so on
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    `there are two kinds of people, those who complete what they start, and
    so on`

The next test is almost the same, with the difference that the
``utils.yes_no_dialog`` should return ``True`` (this is achieved by
specifying ``result=True`` in the partial application of the generic
``mockfunc``). 

With this action, the value returned by ``remove_callback`` should be
``True``, and there should be no Arecaceae Family in the database anymore::

    def test_remove_callback_no_genera_confirm(self):
        # T_0
        f5 = Family(family=u'Arecaceae')
        self.session.add(f5)
        self.session.flush()
        self.invoked = []

        # action
        utils.yes_no_dialog = partial(
            mockfunc, name='yes_no_dialog', caller=self, result=True)
        utils.message_details_dialog = partial(
            mockfunc, name='message_details_dialog', caller=self)
        from bauble.plugins.plants.family import remove_callback
        result = remove_callback([f5])
        self.session.flush()

        # effect
        self.assertFalse('message_details_dialog' in
                         [f for (f, m) in self.invoked])
        self.assertTrue(('yes_no_dialog', u'Are you sure you want to '
                         'remove the family <i>Arecaceae</i>?')
                        in self.invoked)
        self.assertEquals(result, True)
        q = self.session.query(Family).filter_by(family=u"Arecaceae")
        matching = q.all()
        self.assertEquals(matching, [])

Have a look at commit 734f5bb9feffc2f4bd22578fcee1802c8682ca83 for the other
two test functions.

Testing logging
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Our ``bauble.test.BaubleTestCase`` objects use handlers of the class
``bauble.test.MockLoggingHandler``. Every time an individual unit test is
started, the ``setUp`` method will create a new ``handler`` and associate it
to the root logger. The ``tearDown`` method takes care of removing it.

You can check for presence of specific logging messages in
``self.handler.messages``. ``messages`` is a dictionary, initially empty,
with two levels of indexation. First the name of the logger issuing the
logging record, then the name of the level of the logging record. Keys are
created when needed. Values hold lists of messages, formatted according to
whatever formatter you associate to the handler, defaulting to
``logging.Formatter("%(message)s")``.

You can explicitly empty the collected messages by invoking
``self.handler.clear()``.


Putting all together
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From time to time you want to activate the test class you're working at:

    nosetests bauble/plugins/plants/test.py:FamilyTests

And at the end of the process you want to update the statistics:

    ./scripts/update-coverage.sh


Structure of user interface
------------------------------------

The user interface is built according to the **Model** — **View** —
**Presenter** architectural pattern.  For much of the interface, **Model**
is a SQLAlchemy database object, but we also have interface elements where
there is no corresponding database model.  In general:

* The **View** is described as part of a **Glade** file. This should include
  the signal-callback and ListStore-TreeView associations. Just reuse the
  base class ``GenericEditorView`` defined in ``bauble.editor``. When you
  create your instance of this generic class, pass it the **Glade** file
  name and the root widget name, then hand this instance over to the
  **presenter** constructor.

  In the Glade file, in the ``action-widgets`` section closing your
  GtkDialog object description, make sure every ``action-widget`` element
  has a valid ``response`` value.  Use `valid GtkResponseType values
  <http://gtk.php.net/manual/en/html/gtk/gtk.enum.responsetype.html>`_, for
  example:

  * GTK_RESPONSE_OK, -5
  * GTK_RESPONSE_CANCEL, -6
  * GTK_RESPONSE_YES, -8
  * GTK_RESPONSE_NO, -9

  There is no easy way to unit test a subclassed view, so please don't
  subclass views, there's really no need to.

  In the Glade file, every input widget should define which handler is
  activated on which signal.  The generic Presenter class offers generic
  callbacks which cover the most common cases.

  * GtkEntry (one-line text entry) will handle the ``changed`` signal, with
    either ``on_text_entry_changed`` or ``on_unique_text_entry_changed``.
  * GtkTextView: associate it to a GtkTextBuffer. To handle the ``changed``
    signal on the GtkTextBuffer, we have to define a handler which invokes
    the generic ``on_textbuffer_changed``, the only role for this function
    is to pass our generic handler the name of the model attribute that
    receives the change. This is a workaroud for an `unresolved bug in GTK
    <http://stackoverflow.com/questions/32106765/>`_.
  * GtkComboBox with translated texts can't be easily handled from the Glade
    file, so we don't even try.  Use the ``init_translatable_combo`` method
    of the generic ``GenericEditorView`` class, but please invoke it from
    the **presenter**.

* The **Model** is just an object with known attributes. In this
  interaction, the **model** is just a passive data container, it does
  nothing more than to let the **presenter** modify it.

* The subclassed **Presenter** defines and implements:

  * ``widget_to_field_map``, a dictionary associating widget names to name
    of model attributes,
  * ``view_accept_buttons``, the list of widget names which, if
    activated by the user, mean that the view should be closed,
  * All needed callbacks,
  * Optionally, it plays the **model** role, too.

  The **presenter** continuously updates the **model** according to changes
  in the **view**. If the **model** corresponds to a database object, the
  **presenter** commits all **model** updates to the database when the
  **view** is closed, or rolls them back if the **view** is
  canceled. (this behaviour is influenced by the parameter ``do_commit``)

  If the **model** is something else, then the **presenter** will do
  something else.

  .. note::
     
     A well behaved **presenter** uses the **view** API to query the values
     inserted by the user or to forcibly set widget statuses. Please do not
     learn from the practice of our misbehaving presenters, some of which
     directly handle fields of ``view.widgets``. By doing so, these
     presenters prevents us from writing unit tests.

The base class for the presenter, ``GenericEditorPresenter`` defined in
``bauble.editor``, implements many useful generic callbacks. There is a
``MockView`` class, that you can use when writing tests for your presenters.

Examples
^^^^^^^^^^^^^

``Contact`` and ``ContactPresenter`` are implemented following the above
lines. The view is defined in the ``contact.glade`` file.

A good example of Presenter/View pattern (no model) is given by the
connection manager.

We use the same architectural pattern for non-database interaction, by
setting the presenter also as model. We do this, for example, for the JSON
export dialog box. The following command will give you a list of
``GenericEditorView`` instantiations::

  grep -nHr -e GenericEditorView\( bauble

Extending Ghini with Plugins
-----------------------------

Nearly everything about Ghini is extensible through plugins. They
can create tables, define custom searchs, add menu items, create
custom commands and more.

To create a new plugin you must extend the ``bauble.pluginmgr.Plugin``
class.

The ``Tag`` plugin is a good minimal example, even if the ``TagItemGUI``
falls outside the Model-View-Presenter architectural pattern.

Plugins structure
-------------------------------------------------------------

Ghini is a framework for handling collections, and is distributed along
with a set of plugins making Ghini a botanical collection manager. But
Ghini stays a framework and you could in theory remove all plugins we
distribute and write your own, or write your own plugins that extend or
complete the current Ghini behaviour.

Once you have selected and opened a database connection, you land in the
Search window. The Search window is an interaction between two objects:
SearchPresenter (SP) and SearchView (SV).

SV is what you see, SP holds the program status and handles the requests you
express through SV. Handling these requests affect the content of SV and the
program status in SP.

The search results shown in the largest part of SV are rows, objects that
are instances of classes registered in a plugin.

Each of these classes must implement an amount of functions in order to
properly behave within the Ghini framework. The Ghini framework reserves
space to pluggable classes.

SP knows of all registered (plugged in) classes, they are stored in a
dictionary, associating a class to its plugin implementation.  SV has a slot
(a gtk.Box) where you can add elements. At any time, at most only one
element in the slot is visible.

A plugin defines one or more plugin classes. A plugin class plays the role
of a partial presenter (pP - plugin presenter) as it implement the callbacks
needed by the associated partial view fitting in the slot (pV - plugin
view), and the MVP pattern is completed by the parent presenter (SP), again
acting as model. To summarize and complete:

* SP acts as model,
* The pV partial view is defined in a Glade file.
* The callbacks implemented by pP are referenced by the Glade file.
* A context menu for the SP row,
* A children property.

When you register a plugin class, the SP:

* Adds the pV in the slot and makes it non-visible.
* Adds an instance of pP in the registered plugin classes.
* Tells the pP that the SP is the model.
* Connects all callbacks from pV to pP.

When an element in pV triggers an action in pP, the pP can forward the
action to SP and can request SP that it updates the model and refreshes the
view.

When the user selects a row in SP, SP hides everything in the pluggable slot
and shows only the single pV relative to the type of the selected row, and
asks the pP to refresh the pV with whatever is relative to the selected row.

Apart from setting the visibility of the various pV, nothing needs be
disabled nor removed: An invisible pV cannot trigger events!

Bug solving workflow
--------------------

Normal development workflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* While using the software, you notice a problem, or you get an idea of
  something that could be better, you think about it good enough in order to
  have a very clear idea of what it really is, that you noticed. you open an
  issue and describe the problem. someone might react with hints.
* You open the issues site and choose one you want to tackle.
* Assign the issue to yourself, this way you are informing the world that
  you have the intention to work at it. someone might react with hints.
* Optionally fork the repository in your account and preferably create a
  branch, clearly associated to the issue.
* Write unit tests and commit them to your branch (please do not push
  failing unit tests to GitHub, run ``nosetests`` locally first).
* Write more unit tests (ideally, the tests form the complete description of
  the feature you are adding or correcting).
* Make sure the feature you are adding or correcting is really completely
  described by the unit tests you wrote.
* Make sure your unit tests are atomic, that is, that you test variations on
  changes along one single variable. Do not give complex input to unit
  tests or tests that do not fit on one screen (25 lines of code).
* Write the code that makes your tests succeed.
* Update the i18n files (run ``./scripts/i18n.sh``).
* Whenever possible, translate the new strings you put in code or Glade
  files.
* When you change strings, please make sure that old translations get re-used.
* Commit your changes.
* Push to GitHub.
* Open a pull request.

Publishing to production
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Open the pull request page using as base a production line ``ghini-x.y``,
  compared to ``ghini-x.y-dev``.
* Make sure a ``bump`` commit is included in the differences.
* It should be possible to automatically merge the branches.
* Create the new pull request, call it as “publish to the production line”.
* You possibly need wait for travis-ci to perform the checks.
* Merge the changes.
* Tell the world about it: on IRC, the forum, diaspora*, …

Closing step
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Review this workflow. Consider this as a guideline, to yourself and to
  your colleagues. Please help make it better, and match its practice in doing so.
