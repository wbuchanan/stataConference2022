// Clear data from memory
clear

// Set the pseudorandom number seed
set seed 7779311

// Set a local for the number of observations
loc obs 1000000

// Set a local for the number of score variables
loc nscores 500

// Set the average number of scores observed for the observations
loc muscores 10

// Set the number of observations in the dataset
set obs `obs'

// Create an ID variable
g long id = _n

// Create a variable for the number of scores observed for each observation
g byte nscores = rpoisson(`muscores')

// Expand the dataset to create the score variable indices
expandcl `nscores', cl(id) gen(scidx)

// Create index within id
bys id: g int scoreidx = _n

// Create a random uniform to shuffle the scores within individuals
bys id: g double shuffle = runiform()

// Sort the data within id by the shuffle variable
sort id shuffle

// Create a new variable with a score for nscores scores within each individual
by id: g byte value = round(runiformint(0, 100), 10) if _n <= nscores

// Create an indicator for whether the individual has a specific score
g byte has = !mi(value)

// Get rid of the variable I had to generate with expandcl
drop scidx shuffle

// Save the version of the file that is long, but not fully optimized
qui: save sparseLong.dta, replace

// Size 5245.21M
// Memory 6208M

// Reshape the data into a common form that is extremely sparse
greshape wide value has, i(id) j(scoreidx) nochecks

// save in this format
qui: save sparseWide.dta, replace

// Size 958.44M
// Memory 1248M

// Make long again
greshape long value has, i(id) j(scoreidx) nochecks

// Size 5245.21M
// Memory 6208M

// Keep only records that have data
keep if !mi(has, value)

// Size 104.91M
// Memory 192M

// Save a copy of the file with the redundant variable
qui: save denseWRedundancy.dta, replace

// Get rid of redundant indicator
drop has

// Size 95.37M
// Memory 160M

// Save with full optimization
qui: save denseWORedundancy.dta, replace

// See disk use:
! ls -ohU *se*.dta
// sparseLong.dta        4.2G
// sparseWide.dta        960M
// denseWRedundancy.dta  105M
// denseWORedundancy.dta 96M