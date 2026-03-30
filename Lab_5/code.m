%% 1. Завантаження зображень
I1 = imread('peppers.png'); % кольорове
I2 = imread('cameraman.tif'); % ч/б

figure('Name','Original');
subplot(1,2,1), imshow(I1), title('Color');
subplot(1,2,2), imshow(I2), title('Grayscale');

%% 2. Перетворення в grayscale
I1_gray = rgb2gray(I1);

figure;
imshow(I1_gray), title('Converted to Grayscale');

%% 3. DCT
D1 = dct2(double(I1_gray));
D2 = dct2(double(I2));

figure('Name','DCT Spectrum');
subplot(1,2,1), imshow(log(1+abs(D1)),[]), title('DCT 1');
subplot(1,2,2), imshow(log(1+abs(D2)),[]), title('DCT 2');

%% 4. Відновлення
I1_rec = idct2(D1);
I2_rec = idct2(D2);

figure('Name','Reconstructed');
subplot(1,2,1), imshow(I1_rec,[]), title('Reconstructed 1');
subplot(1,2,2), imshow(I2_rec,[]), title('Reconstructed 2');

%% 5. Квантування DCT
N = 10; % крок квантування
D1_q = round(D1 / N) * N;

figure;
imshow(log(1+abs(D1_q)),[]), title('Quantized DCT');

%% 6. Відновлення після квантування
I1_q_rec = idct2(D1_q);

figure;
subplot(1,2,1), imshow(I1_gray), title('Original');
subplot(1,2,2), imshow(I1_q_rec,[]), title(['Restored, N=', num2str(N)]);

%% 7. Квантування у просторі
n = 20;
I_quant = round(double(I1_gray)/n)*n;

figure;
subplot(1,2,1), imshow(I1_gray), title('Original');
subplot(1,2,2), imshow(I_quant,[]), title('Spatial Quantization');