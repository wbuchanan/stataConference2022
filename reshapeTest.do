// Clear any existing timers
timer clear

// Load the large dataset to test reshaping on
use sparseLong.dta, clear

// Start the timer for Stata Native reshape wide
timer on 1

// Reshape the data
reshape wide value has, i(id) j(scoreidx)

// Turn timer for reshape wide off
timer off 1

// Start timer for Stata native reshape long
timer on 2

// Reshape the data
reshape long value has, i(id) j(scoreidx)

// Turn off the timer for reshape long
timer off 2

// Turn on timer for greshape wide w/o options
timer on 3

// Reshape the same data
greshape wide value has, i(id) j(scoreidx)

// Turn off the timer for greshape wide
timer off 3

// Turn on a timer for greshape long w/o options
timer on 4

// Reshape the data
greshape long value has, i(id) j(scoreidx)

// Turn off the timer for greshape long w/o options
timer off 4

// Turn on timer for greshape wide w/nocheck option
timer on 5

// Reshape the data
greshape wide value has, i(id) j(scoreidx) nochecks

// Turn off timer for greshape wide w/nocheck option
timer off 5

// Turn on timer for greshape long w/nocheck option
timer on 6

// Reshape the data
greshape long value has, i(id) j(scoreidx) nochecks

// Turn off timer for greshape long w/nocheck option
timer off 6

// Print out reminder of what the timers correspond to
di as res "Timer 1 - Stata reshape wide" _n "Timer 2 - Stata reshape long" _n ///
"Timer 3 - greshape wide" _n "Timer 4 - greshape long" _n		     ///
"Timer 5 - greshape wide nochecks" _n "Timer 6 - greshape long nochecks"

// Display the timing results
timer list

