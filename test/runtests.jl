using Plots
using ChirpSignal: chirp
using AcousticFeatures
using SpecAugment
using Test

# a double peak
f  = 0.0 : 2.0 : 4000.0;
p1 = @. 4exp( - (f - 1500)^2 / 35900 );  # center frequency is 1500Hz
p2 = @. 2exp( - (f - 2100)^2 / 99930 );  # center frequency is 2100Hz
p  = p1 + p2;


# create chirp signals
fl = 100.0   # start frequency
fh = 7900.0  # final frequency
Fs = 16000   # sampling frequency
T  = 2.05    # duration of signal
data  = chirp(T, Fs, fl, fh, method="logarithmic");

# An operator for calculating time-frequency spectrum
power = PowerSpec(fs = Fs, fmax=8000, winlen=1024, stride=128, nffts=2048, donorm=true, type=Vector{Float64});

# normlized in [0, 1] span as clean spectrum
X = minmaxnorms(10log10.(power(data) .+ 1e-5));

# a sleeping duration for showing plots
dt = 2.0

@testset "testing spectrum augmentation" begin
    try
        include("1-addnoise.jl")
        @test true
    catch
        @test false
    end


    try
        include("2-scale.jl")
        @test true
    catch
        @test false
    end


    try
        include("3-flip.jl")
        @test true
    catch
        @test false
    end


    try
        include("4-figure.jl")
        @test true
    catch
        @test false
    end


    try
        include("5-stretch.jl")
        @test true
    catch
        @test false
    end


    try
        include("6-warp.jl")
        @test true
    catch
        @test false
    end
end

