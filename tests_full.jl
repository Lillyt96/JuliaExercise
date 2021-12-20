using Test
# import Base.rand
# include("sol_example.jl")
# include("task1.jl")  # submitted solution goes here
include("task1_optimised.jl")  # submitted solution goes here

# Full set of tests - Do NOT supply this to the person doing the challenge

# Basic test examples
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

@testset "advanced tests 1 - dupes" begin
    # more edge cases and checking
    ps = PointSet()
    @test typeof(ps) == PointSet
    insert!(ps, 1, 1.0, 2.0)
    insert!(ps, 2, 2.0, 2.0)
    insert!(ps, 3, 3.0, 2.0)
    insert!(ps, 4, 4.0, 2.0)
    insert!(ps, 5, -1.0, -2.0)
    @test insert!(ps, 6, 4.0, 2.0) == false  # handle dupe points
    # insert!(ps, 10, -181, -91) == false # non-gps should not allowed, bonus points if this is checked or otherwise handled
    for _ in 1:100
        @test rand(ps) ∈ collect(1:5)
    end
    @test remove!(ps, 2) == true
    @test remove!(ps, 2) == false
    @test insert!(ps, 1, 2.0, 3.0) == false  # dupe in ID
    @test insert!(ps, 2, 1.0, 2.0) == false  # dupe in position
    @test insert!(ps, 2, 3.0, 1.0) == true
    @test insert!(ps, 2, missing, 2.0) == false  # dupe in ID & missing
    @test get_point(ps, 2) == [3.0,1.0]
    for i in 1:5
        @test rand(ps) ∈ collect(i:5)
        @test remove!(ps, i) == true
    end
    
end


@testset "advanced tests 2 - missings" begin
    ps = PointSet()
    # @test isnothing(rand(ps)) # not necessarily a good test, default empty behaviour is raise error
    @test insert!(ps, 1, missing, 1.0)
    @test rand(ps) == 1
    @test insert!(ps, 1, missing, 1.0) == false
    for i = 1:10
        insert!(ps, i, missing, rand([1.0, missing]))
        @test rand(ps) ∈ collect(1:i)
    end
    for i = 10:-1:1
        @test rand(ps) ∈ collect(1:i)
        println(i)
        println(ps)
        @test remove!(ps, i)
    end
    @test insert!(ps, 1, 1.0, 1.0)
    @test get_point(ps, 1) == [1.0, 1.0]
    @test get_point(ps, 10) == false
end

ps =  PointSet()
remove!(ps, 10)