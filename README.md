Coding Test for Simulations
# Intro
This is a simple coding exercise, the type that a simulation engineer on Optimal Reality might be asked to do, which is designed to get you acquainted with Julia.

## Background

When creating a simulation, we need to generate the intended paths of every vehicle that will be part of the simulation (known as a 'Schedule'). A key part of this process is the generation of paths for every vehicle, and placing these positions on a map. 

You will create a system to quickly load a set of points of a map from a LightOSM graph into a set, and randomnly sample from this set to create start and end points. Using this, you will then generate a set of possible paths to pass through to the core simulation engine. The tasks in the challenge mimics a simplified version of the OR schedule Generation System.

# Task
This task has two parts:
- Part 1 is a guided coding exercise designed to help you get into Julia and a review software engineering principles
- Part 2 is more designed around data exploration and working with geospatial data, through analysing open source data.

You will need to install:
- For part 1: install Julia (v1.6+ recommened) and Start a Julia REPL inside this repo
- Activate this repo as a julia project using `using Pkg; Pkg.activate("."); Pkg.instantiate()`
- For part 2: This will also install the latest version of the LightOSM package https://github.com/DeloitteDigitalAPAC/LightOSM.jl, which you can start using with `using LightOSM`
- You will most likely also want VSCode, which has the official Julia IDE plugin for developing in Julia

## Task Part 1:

This task has multiple steps - please attempt these in order as they are increasing in difficulty. Depending on your level of software engineering experience, it is not necessary to complete all the exercises (check with the contact handing you this test). 

As a rule of thumb, if have dev experience in other languages and are just new to Julia, it should take you 1-2 hours to complete this section.

Unit tests have been provided for each section. When you have done 1a, run the `tests_basic_1a.jl` script to check your solution. 

### 1a - basic

Using the provided function outlines, write a set of functions that operate on the given struct `ps::PointSet` that is able to add, delete and randomnly select point IDs with GPS coordinate positions:
- `insert!`
    - Add a point ID along with its lon-lat (x,y) position. If a point ID already exists, return false. 
- `remove!`
    - If the point exists, remove it and return true. Otherwise, return false
- `rand`
    - Randomly pick an point and return the ID, if there is one
- `rand_point`
    - Randomnly returns a point, if there is one
    - Note that for purposes of this test, use a length 2 vector `[x, y]` as the return format
- `get_point`
    - Returns the coordinate of ID supplied
    - Same return format as rand_point


### 1b - medium
Now, Each point must be unique in both ID and position, but also we want to make possible to have points that are `missing` lat-long positions.

Update your `insert!` function to check if an existing lat-long already exists under an different ID, and return false (do not add or update the existing ID). However, it should allow multiple ids that are `missing` one or both lat-long values to be inserted 

### 1c - advanced
For maximum effiency, the `insert!`, `remove!` and `rand` functions should operate in constant time O(1). 

Update the `ps::PointSet` struct, its constructor and all methods so that they are in O(1) time.

Explain how your design & implementation achieves this. You may use benchmarks or refer to any documentation for any functions/packages you may be using to achieve this.

- For benchmarking speed of the solution, you should use the `@time` or `@btime` macro from the `benchmarktools` package)


### Example test sequences
To check your work, run the unit tests in the relevant test file against the task section. 

Explanation of the test function calls in `test_basic_1a.jl`:
- `insert!(ps, 1, 1.0, 2.0)`; // Inserts 1 to the set. Returns true as 1 was inserted successfully.
- `remove!(ps, 2)`; // Returns false as 2 does not exist in the set.
- `insert!(ps, 2, 2.0, 3.0)`; // Inserts 2 to the set, returns true. Set now contains [1,2].
- `rand(ps)`; // should return either 1 or 2 randomly.
- `remove!(ps, 1)`; // Removes 1 from the set, returns true. Set now contains [2].
- `insert!(ps, 2, 3.0, 5.0)`; // 2 was already in the set, so return false.
- `rand(ps)`; // Since 2 is the only number in the set, getRandom() will always return 2.
- `rand_point(ps, 2)`; // Returns a random point, but only 2 is in the set, so return [2.0, 3.0]
- `get_point(ps, 1)`; // Returns false as no data associated with ID 1


## Task part 2:

This part has no test cases, and is a free-form data exploration exercise. If you have completed task 1 or are already familiar with Julia, it should take you 1-2 hours to complete

Using the code from part 1 and LightOSM,
- randomnly generate 100,000 Generate the shortest path between random 'nodes' on a 20km LightOSM Graph, as fast as possible
- Output this to a as arrays of longitude-latitude linestrings (e.g. `[[1,0], [2,1], [3,2]]`)

Provide the longest and shortest path that was generated. Document and discuss:
- Timing benchmarks of your solution
- Any issues with the data, and ways to handle data issues
- Potential ways to improve your solution

Bonus points: Perform this same operation above in python using the  OSMNX package, and discuss any observed performance differences.

# Test cases & Completing the task
- Part 1 of your soltuion will be evaluated based on passing all basic tests, plus additional tests (not provided here) to check for edge cases. It is up to you to come up with any additional edge cases you may like to check.
- Documentation and comments to explain your work is helpful (including multiple approaches that were tried, if relevant.)
- For part 2, Feel free to other Julia packages if desired (e.g. for Plotting or analysis). 

# Julia Tips
If this is your first time using Julia, some tips to get you going:
- Learn how the Package Manager `pkg` works (activate the env in the code-test folder)
- Check out the LightOSM tutorial 
- If you update the struct, unfortunately as of Julia v1.6, you will need to start a new terminal session, due to structs being immutable objects
- For part 2, the goal is to be able to explain what your solution is doing, as well as how it deals with any challenges in the 'real world' data. Using some Viz to understand what's going on is highly encouraged.
