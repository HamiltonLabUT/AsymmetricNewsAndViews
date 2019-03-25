% dichotic_stims.m
%
% Code to create figure for Hamilton LS (2019). "The asymmetric auditory cortex" Nature Human Behaviour. 25 March 2019.
% Link: https://doi.org/10.1038/s41562-019-0582-x
% In reference to Flinker et al. (2019) Spectrotemporal modulation provides a unifying framework for auditory cortical asymmetries.
% Nature Human Behaviour. https://www.nature.com/articles/s41562-019-0548-z
%
% Uses code from Flinker et al., available here: https://github.com/flinkerlab/SpectroTemporalModulationFilter
%
% Written 2019 Liberty Hamilton.

% Read in the audio file
[w,fs] = audioread('fcaj0_si1479.wav');

TFout = STM_CreateTF(w,fs,'gauss');

% Do temporal filtering
for temp_cut = [5 6]
    % Low-pass filter temporal at 5 or 6 Hz
    [MS_tempcut] = STM_Filter_Mod(TFout, temp_cut);
    
    % Reconstruct filtered sound
    [Recon, newTF,TFreference] = STM_Invert_Spectrum(MS_tempcut);
    
    TF_temp = STM_CreateTF(Recon,fs,'gauss');
    
    figure;
    imagesc(TF_temp.x_axis, TF_temp.y_axis, TF_temp.TFlog); axis xy;
    colormap(parula); colorbar;
    title(sprintf('Temporal modulations <%d Hz', temp_cut));
    xlabel('Time'); ylabel('Freq');
    print_quality_fig(gcf,sprintf('templow_%dHz.eps', temp_cut),8,4,2,'inches','epsc');
    
end

% Low-pass filter spectral at 0.6 or 0.8 cyc/oct
for spec_cut = [0.6 0.8]
    [MS_speccut] = STM_Filter_Mod(TFout, [], spec_cut);
    
    % Reconstruct filtered sound
    [Recon, newTF,TFreference] = STM_Invert_Spectrum(MS_speccut);
    
    TF_spec = STM_CreateTF(Recon,fs,'gauss');
    
    figure;
    imagesc(TF_spec.x_axis, TF_spec.y_axis, TF_spec.TFlog); axis xy;
    colorbar;
    colormap(parula);
    title(sprintf('Spectral modulations <%d Hz', spec_cut));
    xlabel('Time'); ylabel('Freq');
    print_quality_fig(gcf,sprintf('speclow_%d.eps', spec_cut),8,4,2,'inches','epsc');
end

figure; imagesc(MS_speccut.x_axis, MS_speccut.y_axis, log(MS_speccut.new_MS)); axis xy;
ylim([0 MS_speccut.y_axis(93)]);
colormap(parula)
print_quality_fig(gcf,sprintf('speccut_MPS.eps'),8,2,2,'inches','epsc');

figure; imagesc(MS_tempcut.x_axis, MS_tempcut.y_axis, log(MS_tempcut.new_MS)); axis xy;
ylim([0 MS_tempcut.y_axis(93)]);
colormap(parula)
print_quality_fig(gcf,sprintf('tempcut_MPS.eps'),8,2,2,'inches','epsc');

figure; imagesc(MS_tempcut.x_axis, MS_tempcut.y_axis, log(MS_tempcut.orig_MS)); axis xy;
ylim([0 MS_tempcut.y_axis(93)]);
colormap(parula)
print_quality_fig(gcf,sprintf('orig_MPS.eps'),8,2,2,'inches','epsc');
