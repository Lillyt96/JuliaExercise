using Test
include("task1_optimised.jl")
# include("sol_example.jl")

# Basic test examples - run this file to check your work

@testset "basic tests for task 1c" begin
    ps = PointSet()
    
    @test typeof(ps) == PointSet
    @test insert!(ps, 1, 1.0, 2.0) == true
    @test remove!(ps, 2) == false
    @test insert!(ps, 2, 2.0, 3.0) == true
    @test rand(ps) ∈ [1,2]
    @test remove!(ps, 1) == true
    @test insert!(ps, 2, 3.0, 5.0) == false
    @test rand(ps) == 2
    @test rand_point(ps) == [2.0, 3.0] 
    @test get_point(ps, 1) == false
    @test insert!(ps, 3, missing, missing) == true
    @test remove!(ps, 3) == true
    @test insert!(ps, 4, 2.0, 3.0) == false
    @test insert!(ps, 4, 3.0, 5.0) == true
end


# Additional tests will be run upon your submission - up to you to check all edge cases
@testset "additional tests for task 1a" begin 
    ps = PointSet()
    #test if insert! adds key value to ps.pset
    insert!(ps,1, 1.0, 2.0)
    @test ps.pset[1] == [1.0, 2.0]

    #test if insert! adds value to ps.vset
    @test [1.0, 2.0] in ps.vset

    #test that insert! allows for one missing lat/long value
    @test insert!(ps, 2, 4, missing) == true
    @test insert!(ps, 3, missing, 4) == true

    #test if remove! removes a point from ps.pset
    remove!(ps,1)
    @test haskey(ps.pset, 1) == false


    #test if remove! removes value from ps.vset
    for point in ps.vset
        @test point != [1.0, 2.0]
    end 

    #test whether rand and rand_point work if ps.pset is empty 
    for val in keys(ps.pset)
        delete!(ps.pset,val)
    end 
    @test rand(ps) == false
    @test rand_point(ps) == false 

    #test if we can have multiple entries with missing values
    for i in 1:10
        insert!(ps, i, missing, missing)
    end
    for i in 10:20
        insert!(ps, i, 3, missing)
    end
    for i in 20:30
        insert!(ps, i, missing, 3)
    end 
    @test remove!(ps,10)
    @test remove!(ps,20)
    @test remove!(ps,30)
    print(ps.pset)

end 
