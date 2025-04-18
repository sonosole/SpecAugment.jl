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


## -------------------------------------
prand = randscale(p, 0.8, 1.2, dims=1);
psin = sinscale(p, 0.7, 1.3, dims=1);
plot(f, p, label="clean", fg_legend = :transparent, ylims=(-0.1, 5)); 
plot!(f, prand, label="randscale", framestyle=:zerolines); 
plot!(f, psin, label="sinscale", xlabel="frequency Hz")

Xrand = randscale(X, 0.2, 1.5, dims=(1,2));
Xsin = sinscale(X, 0.3, 1.6, dims=(1,2));
heatmap(hcat(X, ones(1024,1), Xrand, ones(1024,1), Xsin), ticks=nothing)
annotate!(125,     900, "clean",      :white)
annotate!(125+250, 900, "randscale",  :white)
annotate!(125+500, 900, "sinscale",   :white)


## -------------------------------------
pflip = flip(p, dims=1);
plot(f, p, label="clean", fg_legend = :transparent, ylims=(-0.1, 5)); 
plot!(f, pflip, label="flipped", framestyle=:zerolines)

Xflip = flip(X, dims=(1,2));
heatmap(hcat(X, ones(1024,1), Xflip))
annotate!(125,     900, "clean",   :white)
annotate!(125+250, 900, "flipped", :black)


## -------------------------------------
pslim = slimorfat(p, ratio=0.7);
pfatt = slimorfat(p, ratio=2);
plot(f, p, label="clean", fg_legend = :transparent, linewidth=2); 
plot!(f, pslim, label="slim", framestyle=:zerolines); 
plot!(f, pfatt, label="fat", xlabel="frequency Hz")

Xslim = slimorfat(X, dims=(1,2), ratio=0.8);
Xfatt = slimorfat(X, dims=(1,2), ratio=4);
heatmap(hcat(X, ones(1024,1), Xslim, ones(1024,1), Xfatt), ticks=nothing)
annotate!(125,     900, "clean", :white)
annotate!(125+250, 900, "slim",  :white)
annotate!(125+500, 900, "fat",   :white)

