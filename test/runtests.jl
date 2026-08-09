using TauPUtils
using Test

@testset "TauPUtils" begin
    @testset "split monotonic curves" begin
        parts = split_monotonic_parts([0.0, 1.0, 2.0], [3.0, 4.0, 5.0])
        @test parts == [(x=[0.0, 1.0, 2.0], y=[3.0, 4.0, 5.0])]

        parts = split_monotonic_parts([0.0, 2.0, 1.0, 3.0], [0.0, 2.0, 1.0, 3.0])
        @test length(parts) == 3
        @test all(issorted(part.x) for part in parts)
        @test_throws AssertionError split_monotonic_parts([1.0], [1.0])
        @test_throws AssertionError split_monotonic_parts([1.0, 1.0], [1.0, 2.0])
    end

    @testset "parse curve JSON" begin
        curves = TauPUtils.parse_taup_curve_json(joinpath(@__DIR__, "fixtures", "curve.json"))
        @test length(curves) == 1
        @test curves[1].model == "iasp91"
        @test curves[1].phase == "P"
        @test curves[1].source_depth == 10.0
        @test curves[1].x == [0.0, 1.0, 2.0]
        @test curves[1].y == [0.0, 10.0, 20.0]
    end

    @testset "parse path JSON" begin
        path = TauPUtils.parse_taup_path_json(joinpath(@__DIR__, "fixtures", "path.json"))
        @test path.model == "ak135"
        @test length(path.arrivals) == 1
        @test path.arrivals[1].phase == "P"
        @test path.arrivals[1].path[1].degree == [0.0, 1.0]
        @test path.arrivals[1].path[1].depth ≈ [6378.137, 6278.137]
    end
end
