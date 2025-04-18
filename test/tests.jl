# a double peak
f  = 0.0 : 2.0 : 4000.0;
p1 = @. 4exp( - (f - 1500)^2 / 35900 );  # center frequency is 1500Hz
p2 = @. 2exp( - (f - 2100)^2 / 99930 );  # center frequency is 2100Hz
p  = p1 + p2;


using WAV, AcousticFeatures, SpecAugment, Plots

# A whistle example, but you can use your own sound file
data, fs = wavread("whistle.wav")
Fs = floor(Int, fs)

# An operator for calculating time-frequency spectrum
power = PowerSpec(fs = Fs, fmax=8000, winlen=1024, stride=128, nffts=2048, donorm=true, type=Vector{Float64});

# normlized in [0, 1] span as clean spectrum
X = minmaxnorms(10log10.(power(data) .+ 1e-5));



## -------------------------------------
prand = addrand(p, dims=1, snr=5);
prandn = addrandn(p, dims=1, snr=1);
plot(f, p, label="clean", fg_legend = :transparent, ylims=(-0.1, 5)); 
plot!(f, prand, label="5dB rand", framestyle=:zerolines); 
plot!(f, prandn, label="1dB randn", xlabel="frequency Hz")

Xrand  = addrand(X, dims=(1,2), snr=-5);
Xrandn = addrandn(X, dims=(1,2), snr=-8);
heatmap(hcat(X, ones(1024,1), Xrand, ones(1024,1), Xrandn), ticks=nothing)
annotate!(125,     900, "clean",      :white)
annotate!(125+250, 900, "-5dB rand",  :white)
annotate!(125+500, 900, "-8dB randn", :white)


