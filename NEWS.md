# zootraits 1.0.2

Changes suggested by the reviewers of the manuscript.

* Download buttons - All download buttons exports a `.csv` file (before were `.xlsx`).

* Tables with reactable: the functionality of sorting values are more explicit now.

* ExploreTrait -  The pages "Data Exploration" and "Table Exploration" were merged into one page: "Data Exploration".

* ExploreTrait - We changed the bar plot for the taxonomic groups to a time series plot of the cumulative number of papers, by year, for the taxonomic groups.

* ExploreTrait - The filter for taxonomic groups now is empty when the App starts.

* GetTraits - Removed the search option in the table.

* GetTraits - Changes in the data: now there is information about Class and Order.

* GetTraits - Now there is possible to filter by Class and Order. Removed the filter by Family. 

* GetTraits - The table shows information about Class and Order. There is no column about Family anymore.


* About - Added Beatriz Milz in the list of authors.


# zootraits 1.0.1

* Update taxon names data: using file from October 2023 (`ZooTraits_taxon_names_oct23.xlsx`).

* The taxonomic group is now being used from the column `new_level` from the file `ZooTraits_taxon_names_oct23.xlsx`.

* Removed the Help button (in the top right of the page).

* Added title and labels in the plots.

* The colors in the plots "Trait dimensions" (bar plot) and "Traits" (tree map) are mapped with the `trait_dimension` column.

# zootraits 1.0.0

* The first version of the app is available in: https://ecofun.shinyapps.io/zootraits/

# zootraits 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
