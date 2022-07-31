// Defines a mata function used to create random strings
// Start mata interpreter
mata:

	// Clear anything from Mata's memory
	mata clear

	// Does not return anything
	void rstring(real scalar obs, real scalar strlen, string scalar varnm) {

		// Declare variable to store the ASCII values of the random string
		real matrix idchars

		// Declare variable to store the string from the ASCII codes in idchars
		string matrix ids

		// Declares a variable to iterate over the matrices
		real scalar i

		// Creates a matrix of random ints used to create mappings to ASCII
		// with dimensions of observations by number of characters in the ID
		idchars = runiformint(obs, strlen, 48, 123)

		// Creates the matrix to store the ID strings
		ids = J(obs, 1, "")

		// Iterate over the rows of the ID chars matrix
		for(i = 1; i <= obs; i++) {

			// Convert the row vector into a string scalar and store it
			ids[i, 1] = char(idchars[i, .])

		} // End loop over the matrix

		// Store the ID strings in the Stata dataset
		st_sstore(., varnm, ids)

	} // End Mata Function definition

// End the Mata interpreter
end

// Loop over values of string lengths
foreach i in 10 13 44 45 55 {

    // Clear data from memory
    clear

    // Set the pseudorandom number seed
    set seed 7779311

    // Set a local for the number of observations
    loc obs 1000000

    // Set a local for the length of the string ID 15 seems to be the point where
    // the strL is more efficient
    loc strlen `i'

    // Set the average number of repeated observations per individual
    loc mureps 8

    // Set the number of observations in the dataset
    set obs `obs'

    // Create the container for the IDs
    g str`strlen' id = ""

	// Populate the ID variable using the Mata function defined above
	mata: rstring(`obs', `strlen', "id")

    // Create the number of repeated observations per individual
    g byte iobs = rpoisson(`mureps')

    // Expand the dataset to create the repeated observations
    expandcl iobs, cl(id) gen(newcl)

    // Drop the variables that aren't needed
    drop newcl iobs

    // Create a time variable with the sequence of records per individual
    bys id: g byte time = _n

    // Store the example dataset
    save savedAsstr`strlen'.dta, replace

    // Get memory report
    memory

    // sort the dataset
    sort id time

    // Recast the ids to strLs
    recast strL id

    // Store the compressed dataset
    qui: save savedAsstr`strlen'L.dta, replace

    // Get the memory report after recasting to strL
    memory

    // See if compress recasts the strL
    compress, coalesce

} // End loop over string lengths

// String Length  | Recasted Type
// 10             | str10
// 13             | str13
// 44             | str44
// 45             | strL
// 55             | strL

// Get the file sizes for each of the two files
! ls -ohU savedAsstr*.dta
savedAsstr10.dta  84M
savedAsstr10L.dta 99M
savedAsstr13.dta  107M
savedAsstr13L.dta 102M
savedAsstr44.dta  344M
savedAsstr44L.dta 131M
savedAsstr45.dta  352M
savedAsstr45L.dta 132M
savedAsstr55.dta  428M
savedAsstr55L.dta 142M


