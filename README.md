ADA Matcher
===========

An RSpec add-on to help test for ADA compliance in web pages

The [RSpec][rspecLink] library supports the addition of custom Matchers for
use in Specifications. This Matcher, when used in a [Cucumber][cucumberLink]
project, can check the HTML code of a page for some common web accessibility
problems.

What this code can do
---------------------
The Matcher will scan HTML and evaluate these ADA/accessibility points:

*  Image tags should include alt text (see Notes below)

*  Link tags should include explanatory titles

*  Links which cause new windows to open should say so (see Notes below)

*  Header tags should be used in proper hierarchy (a page with an H3 should have H1 and H2)

*  Form fields should have associated Label tags (see Notes below)

What this code does not do
--------------------------
It will not guarantee fully ADA compliant web pages. It only scans for the tedious
and easily forgotten small things that web developers should be in the habit of
including in their web pages.

Notes
-----
Full ADA compliance requires a large amount of subjective judgement, testing, and
common sense. No automatic processor can fully grasp the usability of a particular
layout and organization of semantic elements on a web page. The
[quick reference guide to web accessibility][adaQuickRefLink]
is pages and pages long and is filled with exceptions and special circumstances. For
example:

*  Images which are purely decorative and carry no significant meaning for the reader
   [should have empty alt attributes][noAltLink] (`alt = ""`). This is to avoid cluttering up the page
   with needless descriptions of decorative pictures.

*  Links should warn about opening new windows, but a link may do so in a non-obvious
   way via javascript. This Matcher makes no attempt to evaluate `onClick` and so on. It
   only looks for a "target" attribute in the "a" tag and evaluates the text in the "title"
   attribute.

*  Form fields should have Labels, but in [some cases][noLabelLink] with restricted space on the page,
   a label can be skipped in lieu of an explanatory "title" attribute in the form field.

When does a form field require a label and when not? When is an image merely decorative?
This Matcher cannot make these judgements. That is the job of the humans writing the code.
Likewise, humans must evaluate the page to see that the visual layout is readable to those
users who cannot see text and other visual elements with a low contrast against the background.
Or that the page, when stripped entirely of its visual styles and images, still reads in
a sensible and meaningful way.

Usage
-----
The ADA Matcher requires some page or browser object with an API like that of the [Watir web
automator][watirLink]. Other similar libraries like [Watir-WebDriver][watirWebDriverLink],
[Selenium][seleniumLink], and [Celerity][celerityLink]
should work since their top-level APIs match Watir.

This Matcher works most easily in a Cucumber project. The example below is for such a case.

In a page definition, add:

    require 'ada_matcher'

In a step definition file, add something like:

    Then /^the page is ADA compliant$/ do
      @browser.should meet_ada_requirements
    end

In a feature file, you can use a scenario like:

    Scenario: The page should meet ADA requirements
    Given I am on The Page
    Then the page is ADA compliant

The page and step definition code is best placed in a "global" page/step
file that all other page/step files inherit. This will make it clear that
the ADA check is available to any feature page in the Cucumber project.

More usage
----------
The execution of the matcher (`@browser.should meet_ada_requirements`) has
some optional arguments:

* (empty argument set) = run all ADA checks

* `meet_ada_requirements(:all)` = run all ADA checks

* `meet_ada_requirements(:some_specific_test_name)` = run just one ADA check

* `meet_ada_requirements([:one_test, :another_test, :a_third_test])` = run several specific checks

The supported ADA tests are:

*  `:image_alt`

*  `:link_title`

*  `:link_window_warning`

*  `:htag_hierarchy`

*  `:label_for`

Finally, the Matcher runs on a "browser" object, but if the object supplied to the
matcher is some other object, it will search for a "browser" property or method to
get at the underlying browser object. This allows the Matcher to seamlessly support
WatirPageHelper page objects, for example, like:

`page.should meet_ada_requirements`.

[rspecLink]: http://rspec.info/
[cucumberLink]: http://cukes.info/
[watirLink]: http://watir.com/
[watirWebDriverLink]: http://watirwebdriver.com/
[seleniumLink]: http://seleniumhq.org/
[celerityLink]: http://celerity.rubyforge.org/
[adaQuickRefLink]: http://www.w3.org/WAI/WCAG20/quickref/
[noLabelLink]: http://www.w3.org/TR/2012/NOTE-WCAG20-TECHS-20120103/H65
[noAltLink]: http://www.w3.org/TR/2008/REC-WCAG20-20081211/#text-equiv
