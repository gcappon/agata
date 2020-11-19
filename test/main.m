close all;
clear all;
clc;

restoredefaultpath;

addpath(genpath(fullfile('..','src')));

results = runtests(pwd,'IncludeSubfolders',true);