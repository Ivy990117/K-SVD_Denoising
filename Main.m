%============================================================
%               - denoise an image
% this is a run_file the demonstrate how to denoise an image, 
% using dictionaries. The methods implemented here are the same
% one as described in "Image Denoising Via Sparse and Redundant
% representations over Learned Dictionaries", (appeared in the 
% IEEE Trans. on Image Processing, Vol. 15, no. 12, December 2006).
% ============================================================
 
clear
bb=8; % block size
RR=4; % redundancy factor  冗余因素
K=RR*bb^2; % number of atoms in the dictionary
 
sigma = 50; 
%pathForImages ='';
%imageName = 'barbara.png';
%   [IMin0,pp]=imread('cameraman.tif');
 [IMin0,pp]=imread('w.jpg');
IMin0=im2double(IMin0);
if (length(size(IMin0))>2)
    IMin0 = rgb2gray(IMin0);
end
if (max(IMin0(:))<2)
    IMin0 = IMin0*255;
end
 
IMin=IMin0+sigma*randn(size(IMin0));%%%%%%此处有随机函数
PSNRIn = 20*log10(255/sqrt(mean((IMin(:)-IMin0(:)).^2)));
tic
%%%基于压缩的论文
[IoutAdaptive,output] = denoiseImageKSVD(IMin, sigma,K);
 
PSNROut = 20*log10(255/sqrt(mean((IoutAdaptive(:)-IMin0(:)).^2)));
figure;
subplot(1,3,1); imshow(IMin0,[]); title('Original clean image');
subplot(1,3,2);
imshow(IMin,[]); title(strcat(['Noisy image, ',num2str(PSNRIn),'dB']));
subplot(1,3,3); 
imshow(IoutAdaptive,[]); title(strcat(['Clean Image by Adaptive dictionary, ',num2str(PSNROut),'dB']));
 
figure;
I = displayDictionaryElementsAsImage(output.D, floor(sqrt(K)), floor(size(output.D,2)/floor(sqrt(K))),bb,bb);
title('The dictionary trained on patches from the noisy image');
toc