
clc
clear all
close all

casenum = 7;
Hs = 8.7;
fm = 0.0803;
w0 = fm;
gamma = 4.82;
%gamma = 1;
alpha=0.0087;

% Input file is determined here
WaveFreqs = xlsread('/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/WaveFrequencyInput.xlsx','Sheet1');
WaveFreqsRad = WaveFreqs*2*pi;

wavespecJONSWAP(casenum,[Hs,w0,gamma],[WaveFreqs],1);
