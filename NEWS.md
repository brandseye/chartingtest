# chartingtest 1.6.0

* `topics_metric()` can now show the parent ID when filtering using a topic tree id.

# chartingtest 1.5.0

* `volume_sentiment()` now has unique author count.

# chartingtest 1.4.0

* `topics_metric()` now also shows positive and negative sentiment.

# chartingtest 1.3.0

* New release for analysts.

# chartingtest 1.2.0.9000
* `topics_metric()` now supports getting data for a particular parent only.
* `topics_metric()` now agrees with the app.

# chartingtest 1.2.0
* There is a new `returning_authors()` function supplying returning authors.
* There is a new `returning_authors_metric()` function counting new and returning authors.
* Version bump to release development changes for analysts.

# chartingtest 1.1.0.9000

* Added percentages to `topics_metric()` and `sites_metric()`

# chartingtest 1.1.0

* There is a new `topics_metric()` function supplying topics data.
* There is a new `location_metric()` function supplying country data.
* There is a new `regions_metric()` function supplying region data.
* There is a new `cities_metric()` function supplying city data.
* Version bump to release development changes for analysts.

# chartingtest 1.0.0.9000

## Chart updates
* `sites_metric()` now has netSentiment, engagement, and OTS. 
* `authors_metric()` now provides netSentiment, engagement, and OTS.

## Other fixes
* Added a `NEWS.md` file to track changes to the package.
* Fixed bugs using `truncateAt` in various functions.
* Added instructions to README.Rmd on how to update this library.
