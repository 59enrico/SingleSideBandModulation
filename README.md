# Single Sideband (SSB) modulation - Digital Signal Processing SS2025 - University of Applied Sciences Offenburg

This project implements the upper single sideband (SSB) modulation of an audio signal using the Hilbert transform and the phase method.
The goal is to translate the frequency content of a given audio signal upwards by a variable amount in a generally real-time capable approach.
The script loads an audio signal, computes its analytic signal using the Hilbert transform, and modulates it with a complex carrier signal, to obtain the upper SSB modulation.
The spectra of both signals (original and modulated) are calculated and plotted to visualize the frequency shift.
To demonstrate the effect of the modulation, both signals are also played back sequentially via speakers for comparison.
