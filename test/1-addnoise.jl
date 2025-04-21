prand = addrand(p, dims=1, snr=5);
prandn = addrandn(p, dims=1, snr=1);
plot(f, p, label="clean", fg_legend = :transparent, ylims=(-0.1, 5)); 
plot!(f, prand, label="5dB rand", framestyle=:zerolines); 
plot!(f, prandn, label="1dB randn", xlabel="frequency Hz")
gui();sleep(dt);

Xrand  = addrand(X, dims=(1,2), snr=-5);
Xrandn = addrandn(X, dims=(1,2), snr=-8);
heatmap(hcat(X, ones(1024,1), Xrand, ones(1024,1), Xrandn), ticks=nothing)
annotate!(125,     900, "clean",      :white)
annotate!(125+250, 900, "-5dB rand",  :white)
annotate!(125+500, 900, "-8dB randn", :white)
gui();sleep(dt);
